import android.media.MediaFormat;
import android.util.Log;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;

/**
 * Neutralises the wrong-but-plausible frame rate Spotify writes into its H.264 headers (VUI
 * timing_info, e.g. 1 / 3050). The MStar decoder trusts such a rate in hardware-render mode and paces
 * the video plane by it (1-2 fps). An absurd rate (>= 1,000,000 fps) makes it measure the real rate
 * from timestamps instead ("FrameRate Guess Mode"), the same thing it does for Spotify's videos that
 * already play fine. Real rates (up to 120 fps) are left alone.
 *
 * The header reaches the decoder twice: in csd-0 when the decoder is set up, and again inside the
 * samples on a quality switch that keeps the decoder. Both are rewritten. Inside a sample the
 * rewrite is in place and keeps the NAL unit's exact length, so sample sizes and crypto subsample
 * maps stay valid.
 */
public final class HeaderTiming {
  private static final String TAG = "HeaderTiming";
  /** Smallest declared rate (time_scale / num_units_in_tick, i.e. 2x fps) treated as absurd. */
  private static final long ABSURD = 2_000_000L;

  private static volatile boolean avc;
  private static byte[] lastIn;
  private static byte[] lastOut;

  /** Called with the decoder's MediaFormat right before it is configured. */
  public static void onFormat(MediaFormat format) {
    try {
      avc = "video/avc".equals(format.getString(MediaFormat.KEY_MIME));
      if (!avc) return;
      ByteBuffer csd = format.getByteBuffer("csd-0");
      if (csd == null) return;
      ByteBuffer dup = csd.duplicate();
      byte[] b = new byte[dup.remaining()];
      dup.get(b);
      if (rewrite(b, false) == CHANGED) format.setByteBuffer("csd-0", ByteBuffer.wrap(b));
    } catch (Throwable t) {
      Log.w(TAG, "format", t);
    }
  }

  /** Called with each video sample (Annex-B, [0, limit)) right before it is queued. */
  public static void onSample(ByteBuffer data) {
    if (!avc || data == null) return;
    try {
      int limit = data.limit();
      if (limit < 5) return;
      if (data.hasArray()) {
        int off = data.arrayOffset();
        byte[] arr = data.array();
        byte[] copy = Arrays.copyOfRange(arr, off, off + limit);
        if (rewrite(copy, false) == CHANGED) System.arraycopy(copy, 0, arr, off, limit);
        return;
      }
      int n = Math.min(limit, 4096);
      while (true) {
        byte[] head = new byte[n];
        ByteBuffer dup = data.duplicate();
        dup.position(0);
        dup.get(head, 0, n);
        int r = rewrite(head, n < limit);
        if (r == INCOMPLETE) {
          n = limit;
          continue;
        }
        if (r == CHANGED) {
          ByteBuffer w = data.duplicate();
          w.position(0);
          w.put(head, 0, n);
        }
        return;
      }
    } catch (Throwable t) {
      Log.w(TAG, "sample", t);
    }
  }

  static final int UNCHANGED = 0, CHANGED = 1, INCOMPLETE = 2;

  /**
   * Rewrites every SPS in b in place. In a sample, parameter sets come before the first slice, so
   * the scan stops there. truncated: b is only the head of the sample; INCOMPLETE asks for all of
   * it when no slice was reached.
   */
  static int rewrite(byte[] b, boolean truncated) {
    int result = UNCHANGED;
    int nal = nextStart(b, 0, b.length);
    if (nal < 0) return UNCHANGED;
    while (nal >= 0 && nal < b.length) {
      int type = b[nal] & 0x1f;
      if (type == 1 || type == 5) return result;
      int next = nextStart(b, nal, b.length);
      if (next < 0 && truncated) return INCOMPLETE;
      int end = next < 0 ? b.length : next - 3;
      while (end > nal && b[end - 1] == 0) end--;
      if (type == 7) {
        byte[] out = rewriteSps(Arrays.copyOfRange(b, nal, end));
        if (out != null) {
          System.arraycopy(out, 0, b, nal, out.length);
          result = CHANGED;
        }
      }
      nal = next;
    }
    return truncated ? INCOMPLETE : result;
  }

  /** Index of the byte after the next 00 00 01 at or after from, or -1. */
  static int nextStart(byte[] b, int from, int to) {
    for (int i = from; i + 2 < to; i++) {
      if (b[i] == 0 && b[i + 1] == 0 && b[i + 2] == 1) return i + 3;
    }
    return -1;
  }

  /** Returns a same-length SPS NAL with an absurd timing, or null to leave it as is. */
  static synchronized byte[] rewriteSps(byte[] nal) {
    if (lastIn != null && Arrays.equals(lastIn, nal)) return lastOut;
    byte[] out = compute(nal);
    lastIn = nal;
    lastOut = out;
    return out;
  }

  private static byte[] compute(byte[] nal) {
    byte[] rbsp = unescape(nal, 1, nal.length);
    int pos = timingPos(rbsp);
    if (pos < 0) return null;
    Bits r = new Bits(rbsp);
    r.pos = pos;
    long units = r.u32(), scale = r.u32();
    // Leave real rates (up to 120 fps) and already-absurd ones alone.
    if (units != 0 && (scale <= 240 * units || scale / units >= ABSURD)) return null;
    for (long u : new long[] {1, 2, 3, 4, 5, 6, 7, 8, 16, 256, 257, 512, 1000}) {
      for (long s : scales(u)) {
        Bits w = new Bits(rbsp.clone());
        w.pos = pos;
        w.put32(u);
        w.put32(s);
        byte[] cand = escape(nal[0], w.b);
        if (cand.length == nal.length) {
          Log.i(TAG, "SPS timing " + units + "/" + scale + " -> " + u + "/" + s);
          return cand;
        }
      }
    }
    Log.w(TAG, "SPS timing " + units + "/" + scale + " left as is: no same-length rewrite");
    return null;
  }

  /** time_scale candidates for num_units_in_tick u, 2,000,000 first, varied zero-byte patterns. */
  private static long[] scales(long u) {
    long[] bases = {2_000_000L, 0x00200000L, 0x00400000L, 0x00800000L, 0x01000000L, 0x02000000L,
        0x04000000L, 0x08000000L, 0x10000000L, 0x20000000L, 0x40000000L, 0x7F000000L};
    long[] lows = {0, 1, 0x100, 0x101, 0x10000, 0x10001, 0x10100, 0x10101, 0xFF, 0xFFFF, 0xFFFFFF};
    long[] out = new long[bases.length * lows.length];
    int n = 0;
    for (long base : bases) {
      for (long low : lows) {
        long s = base == 2_000_000L ? base * u + low : base | low;
        if (s <= 0x7FFFFFFFL && s / u >= ABSURD) out[n++] = s;
      }
    }
    return Arrays.copyOf(out, n);
  }

  /** Bit position of num_units_in_tick in an SPS RBSP (after the NAL header), or -1. */
  static int timingPos(byte[] rbsp) {
    try {
      Bits r = new Bits(rbsp);
      int profile = r.u(8);
      r.u(8);
      r.u(8);
      r.ue();
      if (profile == 100 || profile == 110 || profile == 122 || profile == 244 || profile == 44
          || profile == 83 || profile == 86 || profile == 118 || profile == 128 || profile == 138
          || profile == 139 || profile == 134 || profile == 135) {
        int cf = r.ue();
        if (cf == 3) r.u(1);
        r.ue();
        r.ue();
        r.u(1);
        if (r.u(1) != 0) {
          for (int i = 0; i < (cf != 3 ? 8 : 12); i++) {
            if (r.u(1) != 0) {
              int size = i < 6 ? 16 : 64, last = 8, next = 8;
              for (int j = 0; j < size; j++) {
                if (next != 0) next = (last + r.se() + 256) % 256;
                last = next == 0 ? last : next;
              }
            }
          }
        }
      }
      r.ue();
      int poc = r.ue();
      if (poc == 0) {
        r.ue();
      } else if (poc == 1) {
        r.u(1);
        r.se();
        r.se();
        int n = r.ue();
        for (int i = 0; i < n; i++) r.se();
      }
      r.ue();
      r.u(1);
      r.ue();
      r.ue();
      if (r.u(1) == 0) r.u(1);
      r.u(1);
      if (r.u(1) != 0) {
        r.ue();
        r.ue();
        r.ue();
        r.ue();
      }
      if (r.u(1) == 0) return -1;
      if (r.u(1) != 0 && r.u(8) == 255) {
        r.u(16);
        r.u(16);
      }
      if (r.u(1) != 0) r.u(1);
      if (r.u(1) != 0) {
        r.u(3);
        r.u(1);
        if (r.u(1) != 0) {
          r.u(8);
          r.u(8);
          r.u(8);
        }
      }
      if (r.u(1) != 0) {
        r.ue();
        r.ue();
      }
      if (r.u(1) == 0) return -1;
      return r.pos + 64 <= rbsp.length * 8 ? r.pos : -1;
    } catch (ArrayIndexOutOfBoundsException e) {
      return -1;
    }
  }

  static byte[] unescape(byte[] b, int from, int to) {
    ByteArrayOutputStream o = new ByteArrayOutputStream();
    int zeros = 0;
    for (int i = from; i < to; i++) {
      int v = b[i] & 0xff;
      if (zeros >= 2 && v == 3) {
        zeros = 0;
        continue;
      }
      o.write(v);
      zeros = v == 0 ? zeros + 1 : 0;
    }
    return o.toByteArray();
  }

  static byte[] escape(byte header, byte[] rbsp) {
    ByteArrayOutputStream o = new ByteArrayOutputStream();
    o.write(header);
    int zeros = 0;
    for (byte x : rbsp) {
      int v = x & 0xff;
      if (zeros >= 2 && v <= 3) {
        o.write(3);
        zeros = 0;
      }
      o.write(v);
      zeros = v == 0 ? zeros + 1 : 0;
    }
    return o.toByteArray();
  }

  static final class Bits {
    final byte[] b;
    int pos;

    Bits(byte[] b) {
      this.b = b;
    }

    int u(int n) {
      int v = 0;
      for (int i = 0; i < n; i++) {
        v = (v << 1) | ((b[pos >> 3] >> (7 - (pos & 7))) & 1);
        pos++;
      }
      return v;
    }

    long u32() {
      return ((long) u(16) << 16) | u(16);
    }

    int ue() {
      int z = 0;
      while (u(1) == 0) {
        if (++z > 31) throw new ArrayIndexOutOfBoundsException();
      }
      return (1 << z) - 1 + u(z);
    }

    int se() {
      int k = ue();
      return (k & 1) != 0 ? (k + 1) / 2 : -(k / 2);
    }

    void put32(long v) {
      for (int i = 31; i >= 0; i--) {
        int bit = (int) ((v >> i) & 1), idx = pos >> 3, sh = 7 - (pos & 7);
        b[idx] = (byte) ((b[idx] & ~(1 << sh)) | (bit << sh));
        pos++;
      }
    }
  }
}
