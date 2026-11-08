import android.media.MediaFormat;
import android.util.Log;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;

/**
 * Experiment: rewrites the H.264 VUI timing (num_units_in_tick, time_scale) in csd-0 to 1 / 2,000,000.
 * MStar decoders reject that as absurd and estimate the frame rate from timestamps ("guess mode"),
 * instead of trusting a wrong-but-plausible header rate. Fields are fixed 32-bit, so only bytes change.
 */
public final class VuiFix {
  private static final String TAG = "VuiFix";

  public static void fix(MediaFormat format) {
    try {
      String mime = format.getString(MediaFormat.KEY_MIME);
      if (!"video/avc".equals(mime)) return;
      ByteBuffer csd = format.getByteBuffer("csd-0");
      if (csd == null) return;
      ByteBuffer dup = csd.duplicate();
      byte[] in = new byte[dup.remaining()];
      dup.get(in);
      byte[] out = rewrite(in);
      if (out == null) return;
      format.setByteBuffer("csd-0", ByteBuffer.wrap(out));
    } catch (Throwable t) {
      Log.w(TAG, "failed", t);
    }
  }

  static byte[] rewrite(byte[] annexB) {
    int start = -1;
    for (int i = 0; i + 3 < annexB.length; i++) {
      if (annexB[i] == 0 && annexB[i + 1] == 0 && annexB[i + 2] == 1) { start = i + 3; break; }
    }
    if (start < 0 || (annexB[start] & 0x1f) != 7) { Log.i(TAG, "no SPS"); return null; }
    byte[] rbsp = unescape(annexB, start + 1, annexB.length);
    Bits r = new Bits(rbsp);
    int profile = r.u(8); r.u(8); r.u(8); r.ue();
    if (profile == 100 || profile == 110 || profile == 122 || profile == 244 || profile == 44
        || profile == 83 || profile == 86 || profile == 118 || profile == 128) {
      int cf = r.ue(); if (cf == 3) r.u(1);
      r.ue(); r.ue(); r.u(1);
      if (r.u(1) != 0) { Log.i(TAG, "scaling lists, skipped"); return null; }
    }
    r.ue();
    int poc = r.ue();
    if (poc == 0) r.ue();
    else if (poc == 1) { r.u(1); r.se(); r.se(); int n = r.ue(); for (int i = 0; i < n; i++) r.se(); }
    r.ue(); r.u(1); r.ue(); r.ue();
    if (r.u(1) == 0) r.u(1);
    r.u(1);
    if (r.u(1) != 0) { r.ue(); r.ue(); r.ue(); r.ue(); }
    if (r.u(1) == 0) { Log.i(TAG, "no VUI"); return null; }
    if (r.u(1) != 0) { if (r.u(8) == 255) { r.u(16); r.u(16); } }
    if (r.u(1) != 0) r.u(1);
    if (r.u(1) != 0) { r.u(3); r.u(1); if (r.u(1) != 0) { r.u(8); r.u(8); r.u(8); } }
    if (r.u(1) != 0) { r.ue(); r.ue(); }
    if (r.u(1) == 0) { Log.i(TAG, "no timing_info"); return null; }
    int pos = r.pos;
    long units = r.u32(), scale = r.u32();
    Bits w = new Bits(rbsp);
    w.pos = pos; w.put32(1); w.put32(2000000);
    if ("0".equals(prop("debug.vuifix"))) {
      Log.i(TAG, "VUI timing " + units + "/" + scale + " left as is (debug.vuifix=0)");
      return null;
    }
    Log.i(TAG, "VUI timing " + units + "/" + scale + " -> 1/2000000");
    ByteArrayOutputStream o = new ByteArrayOutputStream();
    o.write(annexB, 0, start + 1);
    escape(rbsp, o);
    return o.toByteArray();
  }

  static String prop(String key) {
    try {
      return (String) Class.forName("android.os.SystemProperties").getMethod("get", String.class).invoke(null, key);
    } catch (Throwable t) {
      return "";
    }
  }

  static byte[] unescape(byte[] b, int from, int to) {
    ByteArrayOutputStream o = new ByteArrayOutputStream();
    int zeros = 0;
    for (int i = from; i < to; i++) {
      int v = b[i] & 0xff;
      if (zeros >= 2 && v == 3) { zeros = 0; continue; }
      o.write(v);
      zeros = v == 0 ? zeros + 1 : 0;
    }
    return o.toByteArray();
  }

  static void escape(byte[] rbsp, ByteArrayOutputStream o) {
    int zeros = 0;
    for (byte x : rbsp) {
      int v = x & 0xff;
      if (zeros >= 2 && v <= 3) { o.write(3); zeros = 0; }
      o.write(v);
      zeros = v == 0 ? zeros + 1 : 0;
    }
  }

  static final class Bits {
    final byte[] b; int pos;
    Bits(byte[] b) { this.b = b; }
    int u(int n) { int v = 0; for (int i = 0; i < n; i++) { v = (v << 1) | ((b[pos >> 3] >> (7 - (pos & 7))) & 1); pos++; } return v; }
    long u32() { return ((long) u(16) << 16) | u(16); }
    int ue() { int z = 0; while (u(1) == 0) z++; return (1 << z) - 1 + u(z); }
    int se() { int k = ue(); return (k & 1) != 0 ? (k + 1) / 2 : -(k / 2); }
    void put32(long v) {
      for (int i = 31; i >= 0; i--) {
        int bit = (int) ((v >> i) & 1), idx = pos >> 3, sh = 7 - (pos & 7);
        b[idx] = (byte) ((b[idx] & ~(1 << sh)) | (bit << sh)); pos++;
      }
    }
  }
}
