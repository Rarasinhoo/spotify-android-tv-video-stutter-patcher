.class public final LHeaderTiming;
.super Ljava/lang/Object;
.source "HeaderTiming.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        LHeaderTiming$Bits;
    }
.end annotation


# static fields
.field private static final ABSURD:J = 0x1e8480L

.field static final CHANGED:I = 0x1

.field static final INCOMPLETE:I = 0x2

.field private static final TAG:Ljava/lang/String; = "HeaderTiming"

.field static final UNCHANGED:I

.field private static volatile avc:Z

.field private static lastIn:[B

.field private static lastOut:[B


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static compute([B)[B
    .locals 24

    .line 128
    move-object/from16 v0, p0

    const/4 v1, 0x1

    array-length v2, v0

    invoke-static {v0, v1, v2}, LHeaderTiming;->unescape([BII)[B

    move-result-object v1

    .line 129
    invoke-static {v1}, LHeaderTiming;->timingPos([B)I

    move-result v2

    .line 130
    const/4 v3, 0x0

    if-gez v2, :cond_0

    return-object v3

    .line 131
    :cond_0
    new-instance v4, LHeaderTiming$Bits;

    invoke-direct {v4, v1}, LHeaderTiming$Bits;-><init>([B)V

    .line 132
    iput v2, v4, LHeaderTiming$Bits;->pos:I

    .line 133
    invoke-virtual {v4}, LHeaderTiming$Bits;->u32()J

    move-result-wide v5

    invoke-virtual {v4}, LHeaderTiming$Bits;->u32()J

    move-result-wide v7

    .line 135
    const-wide/16 v9, 0x0

    cmp-long v4, v5, v9

    if-eqz v4, :cond_2

    const-wide/16 v9, 0xf0

    mul-long v9, v9, v5

    cmp-long v4, v7, v9

    if-lez v4, :cond_1

    div-long v9, v7, v5

    const-wide/32 v11, 0x1e8480

    cmp-long v4, v9, v11

    if-ltz v4, :cond_2

    :cond_1
    return-object v3

    .line 136
    :cond_2
    const/16 v4, 0xd

    new-array v9, v4, [J

    fill-array-data v9, :array_0

    const/4 v11, 0x0

    :goto_0
    const-string v12, "SPS timing "

    const-string v13, "HeaderTiming"

    const-string v14, "/"

    if-ge v11, v4, :cond_5

    move-object v15, v3

    aget-wide v3, v9, v11

    .line 137
    const/16 v16, 0x0

    invoke-static {v3, v4}, LHeaderTiming;->scales(J)[J

    move-result-object v10

    move-object/from16 v17, v15

    array-length v15, v10

    move-object/from16 v18, v1

    const/4 v1, 0x0

    :goto_1
    if-ge v1, v15, :cond_4

    move-object/from16 v19, v9

    move-object/from16 v20, v10

    aget-wide v9, v20, v1

    .line 138
    move/from16 v21, v1

    new-instance v1, LHeaderTiming$Bits;

    invoke-virtual/range {v18 .. v18}, [B->clone()Ljava/lang/Object;

    move-result-object v22

    move/from16 v23, v11

    move-object/from16 v11, v22

    check-cast v11, [B

    invoke-direct {v1, v11}, LHeaderTiming$Bits;-><init>([B)V

    .line 139
    iput v2, v1, LHeaderTiming$Bits;->pos:I

    .line 140
    invoke-virtual {v1, v3, v4}, LHeaderTiming$Bits;->put32(J)V

    .line 141
    invoke-virtual {v1, v9, v10}, LHeaderTiming$Bits;->put32(J)V

    .line 142
    aget-byte v11, v0, v16

    iget-object v1, v1, LHeaderTiming$Bits;->b:[B

    invoke-static {v11, v1}, LHeaderTiming;->escape(B[B)[B

    move-result-object v1

    .line 143
    array-length v11, v1

    move-object/from16 v22, v1

    array-length v1, v0

    if-ne v11, v1, :cond_3

    .line 144
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " -> "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v9, v10}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v13, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 145
    return-object v22

    .line 137
    :cond_3
    add-int/lit8 v1, v21, 0x1

    move-object/from16 v9, v19

    move-object/from16 v10, v20

    move/from16 v11, v23

    goto :goto_1

    .line 136
    :cond_4
    move-object/from16 v19, v9

    move/from16 v23, v11

    add-int/lit8 v11, v23, 0x1

    move-object/from16 v3, v17

    move-object/from16 v1, v18

    const/16 v4, 0xd

    goto/16 :goto_0

    .line 149
    :cond_5
    move-object/from16 v17, v3

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " left as is: no same-length rewrite"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v13, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 150
    return-object v17

    :array_0
    .array-data 8
        0x1
        0x2
        0x3
        0x4
        0x5
        0x6
        0x7
        0x8
        0x10
        0x100
        0x101
        0x200
        0x3e8
    .end array-data
.end method

.method static escape(B[B)[B
    .locals 6

    .line 262
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 263
    invoke-virtual {v0, p0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 264
    nop

    .line 265
    array-length p0, p1

    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v2, p0, :cond_2

    aget-byte v4, p1, v2

    .line 266
    and-int/lit16 v4, v4, 0xff

    .line 267
    const/4 v5, 0x2

    if-lt v3, v5, :cond_0

    const/4 v5, 0x3

    if-gt v4, v5, :cond_0

    .line 268
    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 269
    const/4 v3, 0x0

    .line 271
    :cond_0
    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 272
    if-nez v4, :cond_1

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_1
    const/4 v3, 0x0

    .line 265
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 274
    :cond_2
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    return-object p0
.end method

.method static nextStart([BII)I
    .locals 2

    .line 112
    nop

    :goto_0
    add-int/lit8 v0, p1, 0x2

    if-ge v0, p2, :cond_1

    .line 113
    aget-byte v1, p0, p1

    if-nez v1, :cond_0

    add-int/lit8 v1, p1, 0x1

    aget-byte v1, p0, v1

    if-nez v1, :cond_0

    aget-byte v0, p0, v0

    const/4 v1, 0x1

    if-ne v0, v1, :cond_0

    add-int/lit8 p1, p1, 0x3

    return p1

    .line 112
    :cond_0
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 115
    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method public static onFormat(Landroid/media/MediaFormat;)V
    .locals 4

    .line 31
    const-string v0, "csd-0"

    :try_start_0
    const-string v1, "video/avc"

    const-string v2, "mime"

    invoke-virtual {p0, v2}, Landroid/media/MediaFormat;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    sput-boolean v1, LHeaderTiming;->avc:Z

    .line 32
    sget-boolean v1, LHeaderTiming;->avc:Z

    if-nez v1, :cond_0

    return-void

    .line 33
    :cond_0
    invoke-virtual {p0, v0}, Landroid/media/MediaFormat;->getByteBuffer(Ljava/lang/String;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 34
    if-nez v1, :cond_1

    return-void

    .line 35
    :cond_1
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->duplicate()Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 36
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v2

    new-array v2, v2, [B

    .line 37
    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 38
    const/4 v1, 0x0

    invoke-static {v2, v1}, LHeaderTiming;->rewrite([BZ)I

    move-result v1

    const/4 v3, 0x1

    if-ne v1, v3, :cond_2

    invoke-static {v2}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v1

    invoke-virtual {p0, v0, v1}, Landroid/media/MediaFormat;->setByteBuffer(Ljava/lang/String;Ljava/nio/ByteBuffer;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 41
    :cond_2
    goto :goto_0

    .line 39
    :catchall_0
    move-exception p0

    .line 40
    const-string v0, "HeaderTiming"

    const-string v1, "format"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 42
    :goto_0
    return-void
.end method

.method public static onSample(Ljava/nio/ByteBuffer;)V
    .locals 7

    .line 46
    sget-boolean v0, LHeaderTiming;->avc:Z

    if-eqz v0, :cond_7

    if-nez p0, :cond_0

    goto :goto_2

    .line 48
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->limit()I

    move-result v0

    .line 49
    const/4 v1, 0x5

    if-ge v0, v1, :cond_1

    return-void

    .line 50
    :cond_1
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->hasArray()Z

    move-result v1

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_3

    .line 51
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->arrayOffset()I

    move-result v1

    .line 52
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->array()[B

    move-result-object p0

    .line 53
    add-int v4, v1, v0

    invoke-static {p0, v1, v4}, Ljava/util/Arrays;->copyOfRange([BII)[B

    move-result-object v4

    .line 54
    invoke-static {v4, v3}, LHeaderTiming;->rewrite([BZ)I

    move-result v5

    if-ne v5, v2, :cond_2

    invoke-static {v4, v3, p0, v1, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 55
    :cond_2
    return-void

    .line 57
    :cond_3
    const/16 v1, 0x1000

    invoke-static {v0, v1}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 59
    :goto_0
    new-array v4, v1, [B

    .line 60
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->duplicate()Ljava/nio/ByteBuffer;

    move-result-object v5

    .line 61
    invoke-virtual {v5, v3}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 62
    invoke-virtual {v5, v4, v3, v1}, Ljava/nio/ByteBuffer;->get([BII)Ljava/nio/ByteBuffer;

    .line 63
    if-ge v1, v0, :cond_4

    const/4 v5, 0x1

    goto :goto_1

    :cond_4
    const/4 v5, 0x0

    :goto_1
    invoke-static {v4, v5}, LHeaderTiming;->rewrite([BZ)I

    move-result v5

    .line 64
    const/4 v6, 0x2

    if-ne v5, v6, :cond_5

    .line 65
    nop

    .line 66
    move v1, v0

    goto :goto_0

    .line 68
    :cond_5
    if-ne v5, v2, :cond_6

    .line 69
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->duplicate()Ljava/nio/ByteBuffer;

    move-result-object p0

    .line 70
    invoke-virtual {p0, v3}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 71
    invoke-virtual {p0, v4, v3, v1}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 73
    :cond_6
    return-void

    .line 75
    :catchall_0
    move-exception p0

    .line 76
    const-string v0, "HeaderTiming"

    const-string v1, "sample"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 78
    return-void

    .line 46
    :cond_7
    :goto_2
    return-void
.end method

.method static rewrite([BZ)I
    .locals 8

    .line 88
    nop

    .line 89
    array-length v0, p0

    const/4 v1, 0x0

    invoke-static {p0, v1, v0}, LHeaderTiming;->nextStart([BII)I

    move-result v0

    .line 90
    if-gez v0, :cond_0

    return v1

    :cond_0
    const/4 v2, 0x0

    .line 91
    :goto_0
    const/4 v3, 0x2

    if-ltz v0, :cond_7

    array-length v4, p0

    if-ge v0, v4, :cond_7

    .line 92
    aget-byte v4, p0, v0

    and-int/lit8 v4, v4, 0x1f

    .line 93
    const/4 v5, 0x1

    if-eq v4, v5, :cond_6

    const/4 v6, 0x5

    if-ne v4, v6, :cond_1

    goto :goto_2

    .line 94
    :cond_1
    array-length v6, p0

    invoke-static {p0, v0, v6}, LHeaderTiming;->nextStart([BII)I

    move-result v6

    .line 95
    if-gez v6, :cond_2

    if-eqz p1, :cond_2

    return v3

    .line 96
    :cond_2
    if-gez v6, :cond_3

    array-length v3, p0

    goto :goto_1

    :cond_3
    add-int/lit8 v3, v6, -0x3

    .line 97
    :goto_1
    if-le v3, v0, :cond_4

    add-int/lit8 v7, v3, -0x1

    aget-byte v7, p0, v7

    if-nez v7, :cond_4

    add-int/lit8 v3, v3, -0x1

    goto :goto_1

    .line 98
    :cond_4
    const/4 v7, 0x7

    if-ne v4, v7, :cond_5

    .line 99
    invoke-static {p0, v0, v3}, Ljava/util/Arrays;->copyOfRange([BII)[B

    move-result-object v3

    invoke-static {v3}, LHeaderTiming;->rewriteSps([B)[B

    move-result-object v3

    .line 100
    if-eqz v3, :cond_5

    .line 101
    array-length v2, v3

    invoke-static {v3, v1, p0, v0, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 102
    const/4 v2, 0x1

    .line 105
    :cond_5
    nop

    .line 106
    move v0, v6

    goto :goto_0

    .line 93
    :cond_6
    :goto_2
    return v2

    .line 107
    :cond_7
    if-eqz p1, :cond_8

    const/4 v2, 0x2

    :cond_8
    return v2
.end method

.method static declared-synchronized rewriteSps([B)[B
    .locals 2

    const-class v0, LHeaderTiming;

    monitor-enter v0

    .line 120
    :try_start_0
    sget-object v1, LHeaderTiming;->lastIn:[B

    if-eqz v1, :cond_0

    sget-object v1, LHeaderTiming;->lastIn:[B

    invoke-static {v1, p0}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v1

    if-eqz v1, :cond_0

    sget-object p0, LHeaderTiming;->lastOut:[B
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object p0

    .line 121
    :cond_0
    :try_start_1
    invoke-static {p0}, LHeaderTiming;->compute([B)[B

    move-result-object v1

    .line 122
    sput-object p0, LHeaderTiming;->lastIn:[B

    .line 123
    sput-object v1, LHeaderTiming;->lastOut:[B
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 124
    monitor-exit v0

    return-object v1

    .line 119
    :catchall_0
    move-exception p0

    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method

.method private static scales(J)[J
    .locals 18

    .line 155
    const/16 v0, 0xc

    new-array v1, v0, [J

    fill-array-data v1, :array_0

    .line 157
    const/16 v2, 0xb

    new-array v3, v2, [J

    fill-array-data v3, :array_1

    .line 158
    const/16 v4, 0x84

    new-array v4, v4, [J

    .line 159
    nop

    .line 160
    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    :goto_0
    if-ge v6, v0, :cond_3

    aget-wide v8, v1, v6

    .line 161
    const/4 v10, 0x0

    :goto_1
    if-ge v10, v2, :cond_2

    aget-wide v11, v3, v10

    .line 162
    const-wide/32 v13, 0x1e8480

    cmp-long v15, v8, v13

    if-nez v15, :cond_0

    mul-long v15, v8, p0

    add-long/2addr v15, v11

    goto :goto_2

    :cond_0
    or-long v15, v8, v11

    .line 163
    :goto_2
    const-wide/32 v11, 0x7fffffff

    cmp-long v17, v15, v11

    if-gtz v17, :cond_1

    div-long v11, v15, p0

    cmp-long v17, v11, v13

    if-ltz v17, :cond_1

    add-int/lit8 v11, v7, 0x1

    aput-wide v15, v4, v7

    move v7, v11

    .line 161
    :cond_1
    add-int/lit8 v10, v10, 0x1

    goto :goto_1

    .line 160
    :cond_2
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 166
    :cond_3
    invoke-static {v4, v7}, Ljava/util/Arrays;->copyOf([JI)[J

    move-result-object v0

    return-object v0

    nop

    :array_0
    .array-data 8
        0x1e8480
        0x200000
        0x400000
        0x800000
        0x1000000
        0x2000000
        0x4000000
        0x8000000
        0x10000000
        0x20000000
        0x40000000
        0x7f000000
    .end array-data

    :array_1
    .array-data 8
        0x0
        0x1
        0x100
        0x101
        0x10000
        0x10001
        0x10100
        0x10101
        0xff
        0xffff
        0xffffff
    .end array-data
.end method

.method static timingPos([B)I
    .locals 14

    .line 172
    const/4 v0, -0x1

    :try_start_0
    new-instance v1, LHeaderTiming$Bits;

    invoke-direct {v1, p0}, LHeaderTiming$Bits;-><init>([B)V

    .line 173
    const/16 v2, 0x8

    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    .line 174
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 175
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 176
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 177
    const/16 v4, 0x64

    const/16 v5, 0x40

    const/16 v6, 0x10

    const/4 v7, 0x0

    const/4 v8, 0x3

    const/4 v9, 0x1

    if-eq v3, v4, :cond_0

    const/16 v4, 0x6e

    if-eq v3, v4, :cond_0

    const/16 v4, 0x7a

    if-eq v3, v4, :cond_0

    const/16 v4, 0xf4

    if-eq v3, v4, :cond_0

    const/16 v4, 0x2c

    if-eq v3, v4, :cond_0

    const/16 v4, 0x53

    if-eq v3, v4, :cond_0

    const/16 v4, 0x56

    if-eq v3, v4, :cond_0

    const/16 v4, 0x76

    if-eq v3, v4, :cond_0

    const/16 v4, 0x80

    if-eq v3, v4, :cond_0

    const/16 v4, 0x8a

    if-eq v3, v4, :cond_0

    const/16 v4, 0x8b

    if-eq v3, v4, :cond_0

    const/16 v4, 0x86

    if-eq v3, v4, :cond_0

    const/16 v4, 0x87

    if-ne v3, v4, :cond_7

    .line 180
    :cond_0
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    move-result v3

    .line 181
    if-ne v3, v8, :cond_1

    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 182
    :cond_1
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 183
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 184
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 185
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v4

    if-eqz v4, :cond_7

    .line 186
    const/4 v4, 0x0

    :goto_0
    if-eq v3, v8, :cond_2

    const/16 v10, 0x8

    goto :goto_1

    :cond_2
    const/16 v10, 0xc

    :goto_1
    if-ge v4, v10, :cond_7

    .line 187
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v10

    if-eqz v10, :cond_6

    .line 188
    const/4 v10, 0x6

    if-ge v4, v10, :cond_3

    const/16 v10, 0x10

    goto :goto_2

    :cond_3
    const/16 v10, 0x40

    .line 189
    :goto_2
    const/4 v11, 0x0

    const/16 v12, 0x8

    const/16 v13, 0x8

    :goto_3
    if-ge v11, v10, :cond_6

    .line 190
    if-eqz v12, :cond_4

    invoke-virtual {v1}, LHeaderTiming$Bits;->se()I

    move-result v12

    add-int/2addr v12, v13

    add-int/lit16 v12, v12, 0x100

    rem-int/lit16 v12, v12, 0x100

    .line 191
    :cond_4
    if-nez v12, :cond_5

    goto :goto_4

    :cond_5
    move v13, v12

    .line 189
    :goto_4
    add-int/lit8 v11, v11, 0x1

    goto :goto_3

    .line 186
    :cond_6
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 197
    :cond_7
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 198
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    move-result v3

    .line 199
    if-nez v3, :cond_8

    .line 200
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    goto :goto_6

    .line 201
    :cond_8
    if-ne v3, v9, :cond_9

    .line 202
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 203
    invoke-virtual {v1}, LHeaderTiming$Bits;->se()I

    .line 204
    invoke-virtual {v1}, LHeaderTiming$Bits;->se()I

    .line 205
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    move-result v3

    .line 206
    nop

    :goto_5
    if-ge v7, v3, :cond_9

    invoke-virtual {v1}, LHeaderTiming$Bits;->se()I

    add-int/lit8 v7, v7, 0x1

    goto :goto_5

    .line 208
    :cond_9
    :goto_6
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 209
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 210
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 211
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 212
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-nez v3, :cond_a

    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 213
    :cond_a
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 214
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_b

    .line 215
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 216
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 217
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 218
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 220
    :cond_b
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-nez v3, :cond_c

    return v0

    .line 221
    :cond_c
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_d

    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    const/16 v4, 0xff

    if-ne v3, v4, :cond_d

    .line 222
    invoke-virtual {v1, v6}, LHeaderTiming$Bits;->u(I)I

    .line 223
    invoke-virtual {v1, v6}, LHeaderTiming$Bits;->u(I)I

    .line 225
    :cond_d
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_e

    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 226
    :cond_e
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_f

    .line 227
    invoke-virtual {v1, v8}, LHeaderTiming$Bits;->u(I)I

    .line 228
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 229
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_f

    .line 230
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 231
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 232
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 235
    :cond_f
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_10

    .line 236
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 237
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 239
    :cond_10
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-nez v3, :cond_11

    return v0

    .line 240
    :cond_11
    iget v3, v1, LHeaderTiming$Bits;->pos:I

    add-int/2addr v3, v5

    array-length p0, p0

    mul-int/lit8 p0, p0, 0x8

    if-gt v3, p0, :cond_12

    iget v0, v1, LHeaderTiming$Bits;->pos:I
    :try_end_0
    .catch Ljava/lang/ArrayIndexOutOfBoundsException; {:try_start_0 .. :try_end_0} :catch_0

    :cond_12
    return v0

    .line 241
    :catch_0
    move-exception p0

    .line 242
    return v0
.end method

.method static unescape([BII)[B
    .locals 5

    .line 247
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 248
    nop

    .line 249
    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_0
    if-ge p1, p2, :cond_2

    .line 250
    aget-byte v3, p0, p1

    and-int/lit16 v3, v3, 0xff

    .line 251
    const/4 v4, 0x2

    if-lt v2, v4, :cond_0

    const/4 v4, 0x3

    if-ne v3, v4, :cond_0

    .line 252
    nop

    .line 253
    const/4 v2, 0x0

    goto :goto_1

    .line 255
    :cond_0
    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 256
    if-nez v3, :cond_1

    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    :cond_1
    const/4 v2, 0x0

    .line 249
    :goto_1
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 258
    :cond_2
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    return-object p0
.end method
