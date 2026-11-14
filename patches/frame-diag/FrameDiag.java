import android.util.Log;

/**
 * Logs, once a second, what Media3's video renderer did with the decoder's output frames: how many
 * it handled, how late they were against the audio clock, and how many it dropped. A diagnostic
 * only: it changes no decision.
 *
 * Hooks (added by patch_frame-diag.py):
 * - offset(earlyUs): called from updateVideoFrameProcessingOffsetCounters, once for every output
 *   frame that is rendered, skipped or dropped. earlyUs < 0 means the frame came out late.
 * - dropped(input, decoder): called from updateDroppedBufferCounters. input > 0 comes from late
 *   input dropping or a drop to the next keyframe.
 *
 * Read it with: adb logcat -s FrameDiag
 */
public final class FrameDiag {
  private static final String TAG = "FrameDiag";
  private static final long LATE_DROP_US = -30_000; // Media3's MIN_EARLY_US_LATE_THRESHOLD

  private static long windowStartMs;
  private static int frames;
  private static int late;
  private static int late30;
  private static long minEarlyUs = Long.MAX_VALUE;
  private static long sumEarlyUs;
  private static int droppedInput;
  private static int droppedDecoder;
  private static int dropEvents;

  private FrameDiag() {}

  public static void offset(long earlyUs) {
    frames++;
    if (earlyUs < 0) late++;
    if (earlyUs < LATE_DROP_US) late30++;
    if (earlyUs < minEarlyUs) minEarlyUs = earlyUs;
    sumEarlyUs += earlyUs;
    flushIfDue();
  }

  public static void dropped(int input, int decoder) {
    if (input == 0 && decoder == 0) return;
    droppedInput += input;
    droppedDecoder += decoder;
    if (input > 0) dropEvents++;
    flushIfDue();
  }

  private static void flushIfDue() {
    long now = android.os.SystemClock.elapsedRealtime();
    if (windowStartMs == 0) {
      windowStartMs = now;
      return;
    }
    long elapsed = now - windowStartMs;
    if (elapsed < 1000) return;
    Log.i(TAG, "frames=" + frames
        + " late=" + late
        + " late>30ms=" + late30
        + " avgEarlyMs=" + (frames == 0 ? 0 : sumEarlyUs / frames / 1000)
        + " minEarlyMs=" + (frames == 0 ? 0 : minEarlyUs / 1000)
        + " droppedOut=" + droppedDecoder
        + " droppedIn=" + droppedInput
        + " inputDropEvents=" + dropEvents
        + " windowMs=" + elapsed);
    windowStartMs = now;
    frames = late = late30 = droppedInput = droppedDecoder = dropEvents = 0;
    sumEarlyUs = 0;
    minEarlyUs = Long.MAX_VALUE;
  }
}
