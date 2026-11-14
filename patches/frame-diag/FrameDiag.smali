.class public final LFrameDiag;
.super Ljava/lang/Object;
.source "FrameDiag.java"


# static fields
.field private static final LATE_DROP_US:J = -0x7530L

.field private static final TAG:Ljava/lang/String; = "FrameDiag"

.field private static dropEvents:I

.field private static droppedDecoder:I

.field private static droppedInput:I

.field private static frames:I

.field private static late:I

.field private static late30:I

.field private static minEarlyUs:J

.field private static sumEarlyUs:J

.field private static windowStartMs:J


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 24
    const-wide v0, 0x7fffffffffffffffL

    sput-wide v0, LFrameDiag;->minEarlyUs:J

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static dropped(II)V
    .locals 1

    .line 42
    if-nez p0, :cond_0

    if-nez p1, :cond_0

    return-void

    .line 43
    :cond_0
    sget v0, LFrameDiag;->droppedInput:I

    add-int/2addr v0, p0

    sput v0, LFrameDiag;->droppedInput:I

    .line 44
    sget v0, LFrameDiag;->droppedDecoder:I

    add-int/2addr v0, p1

    sput v0, LFrameDiag;->droppedDecoder:I

    .line 45
    if-lez p0, :cond_1

    sget p0, LFrameDiag;->dropEvents:I

    add-int/lit8 p0, p0, 0x1

    sput p0, LFrameDiag;->dropEvents:I

    .line 46
    :cond_1
    invoke-static {}, LFrameDiag;->flushIfDue()V

    .line 47
    return-void
.end method

.method private static flushIfDue()V
    .locals 13

    .line 50
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    .line 51
    sget-wide v2, LFrameDiag;->windowStartMs:J

    const-wide/16 v4, 0x0

    cmp-long v6, v2, v4

    if-nez v6, :cond_0

    .line 52
    sput-wide v0, LFrameDiag;->windowStartMs:J

    .line 53
    return-void

    .line 55
    :cond_0
    sget-wide v2, LFrameDiag;->windowStartMs:J

    sub-long v2, v0, v2

    .line 56
    const-wide/16 v6, 0x3e8

    cmp-long v8, v2, v6

    if-gez v8, :cond_1

    return-void

    .line 57
    :cond_1
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "frames="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    sget v9, LFrameDiag;->frames:I

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, " late="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    sget v9, LFrameDiag;->late:I

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, " late>30ms="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    sget v9, LFrameDiag;->late30:I

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, " avgEarlyMs="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    .line 60
    sget v9, LFrameDiag;->frames:I

    if-nez v9, :cond_2

    move-wide v9, v4

    goto :goto_0

    :cond_2
    sget-wide v9, LFrameDiag;->sumEarlyUs:J

    sget v11, LFrameDiag;->frames:I

    int-to-long v11, v11

    div-long/2addr v9, v11

    div-long/2addr v9, v6

    :goto_0
    invoke-virtual {v8, v9, v10}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, " minEarlyMs="

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    .line 61
    sget v9, LFrameDiag;->frames:I

    if-nez v9, :cond_3

    move-wide v9, v4

    goto :goto_1

    :cond_3
    sget-wide v9, LFrameDiag;->minEarlyUs:J

    div-long/2addr v9, v6

    :goto_1
    invoke-virtual {v8, v9, v10}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, " droppedOut="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    sget v7, LFrameDiag;->droppedDecoder:I

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, " droppedIn="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    sget v7, LFrameDiag;->droppedInput:I

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, " inputDropEvents="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    sget v7, LFrameDiag;->dropEvents:I

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, " windowMs="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 57
    const-string v3, "FrameDiag"

    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 66
    sput-wide v0, LFrameDiag;->windowStartMs:J

    .line 67
    const/4 v0, 0x0

    sput v0, LFrameDiag;->dropEvents:I

    sput v0, LFrameDiag;->droppedDecoder:I

    sput v0, LFrameDiag;->droppedInput:I

    sput v0, LFrameDiag;->late30:I

    sput v0, LFrameDiag;->late:I

    sput v0, LFrameDiag;->frames:I

    .line 68
    sput-wide v4, LFrameDiag;->sumEarlyUs:J

    .line 69
    const-wide v0, 0x7fffffffffffffffL

    sput-wide v0, LFrameDiag;->minEarlyUs:J

    .line 70
    return-void
.end method

.method public static offset(J)V
    .locals 3

    .line 33
    sget v0, LFrameDiag;->frames:I

    add-int/lit8 v0, v0, 0x1

    sput v0, LFrameDiag;->frames:I

    .line 34
    const-wide/16 v0, 0x0

    cmp-long v2, p0, v0

    if-gez v2, :cond_0

    sget v0, LFrameDiag;->late:I

    add-int/lit8 v0, v0, 0x1

    sput v0, LFrameDiag;->late:I

    .line 35
    :cond_0
    const-wide/16 v0, -0x7530

    cmp-long v2, p0, v0

    if-gez v2, :cond_1

    sget v0, LFrameDiag;->late30:I

    add-int/lit8 v0, v0, 0x1

    sput v0, LFrameDiag;->late30:I

    .line 36
    :cond_1
    sget-wide v0, LFrameDiag;->minEarlyUs:J

    cmp-long v2, p0, v0

    if-gez v2, :cond_2

    sput-wide p0, LFrameDiag;->minEarlyUs:J

    .line 37
    :cond_2
    sget-wide v0, LFrameDiag;->sumEarlyUs:J

    add-long/2addr v0, p0

    sput-wide v0, LFrameDiag;->sumEarlyUs:J

    .line 38
    invoke-static {}, LFrameDiag;->flushIfDue()V

    .line 39
    return-void
.end method
