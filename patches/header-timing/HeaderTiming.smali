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
.field static final CHANGED:I = 0x1

.field static final DECLARED_FPS:J = 0x3cL

.field static final INCOMPLETE:I = 0x2

.field private static final TAG:Ljava/lang/String; = "HeaderTiming"

.field static final UNCHANGED:I

.field private static volatile avc:Z

.field private static lastIn:[B

.field private static lastOut:[B


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static compute([B)[B
    .locals 21

    .line 135
    move-object/from16 v0, p0

    const/4 v1, 0x1

    array-length v2, v0

    invoke-static {v0, v1, v2}, LHeaderTiming;->unescape([BII)[B

    move-result-object v1

    .line 136
    invoke-static {v1}, LHeaderTiming;->timingPos([B)I

    move-result v2

    .line 137
    const/4 v3, 0x0

    if-gez v2, :cond_0

    return-object v3

    .line 138
    :cond_0
    new-instance v4, LHeaderTiming$Bits;

    invoke-direct {v4, v1}, LHeaderTiming$Bits;-><init>([B)V

    .line 139
    iput v2, v4, LHeaderTiming$Bits;->pos:I

    .line 140
    invoke-virtual {v4}, LHeaderTiming$Bits;->u32()J

    move-result-wide v5

    invoke-virtual {v4}, LHeaderTiming$Bits;->u32()J

    move-result-wide v7

    .line 142
    const-wide/16 v9, 0x0

    const-wide/16 v11, 0x78

    cmp-long v4, v5, v9

    if-eqz v4, :cond_1

    mul-long v9, v5, v11

    cmp-long v4, v7, v9

    if-gtz v4, :cond_1

    return-object v3

    .line 145
    :cond_1
    const-wide/16 v13, 0x1

    :goto_0
    const-wide/32 v15, 0x186a0

    const-string v4, "SPS timing "

    move-object/from16 v17, v3

    const-string v3, "HeaderTiming"

    const-wide/16 v18, 0x1

    const-string v9, "/"

    cmp-long v10, v13, v15

    if-gtz v10, :cond_3

    .line 146
    move-wide v15, v11

    mul-long v11, v13, v15

    .line 147
    new-instance v10, LHeaderTiming$Bits;

    invoke-virtual {v1}, [B->clone()Ljava/lang/Object;

    move-result-object v20

    move-object/from16 v15, v20

    check-cast v15, [B

    invoke-direct {v10, v15}, LHeaderTiming$Bits;-><init>([B)V

    .line 148
    iput v2, v10, LHeaderTiming$Bits;->pos:I

    .line 149
    invoke-virtual {v10, v13, v14}, LHeaderTiming$Bits;->put32(J)V

    .line 150
    invoke-virtual {v10, v11, v12}, LHeaderTiming$Bits;->put32(J)V

    .line 151
    const/4 v15, 0x0

    aget-byte v15, v0, v15

    iget-object v10, v10, LHeaderTiming$Bits;->b:[B

    invoke-static {v15, v10}, LHeaderTiming;->escape(B[B)[B

    move-result-object v10

    .line 152
    array-length v15, v10

    move-object/from16 v16, v1

    array-length v1, v0

    if-ne v15, v1, :cond_2

    .line 153
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " -> "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v13, v14}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v11, v12}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 154
    return-object v10

    .line 145
    :cond_2
    add-long v13, v13, v18

    move-object/from16 v1, v16

    move-object/from16 v3, v17

    const-wide/16 v11, 0x78

    goto :goto_0

    .line 157
    :cond_3
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " left as is: no same-length rewrite"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 158
    return-object v17
.end method

.method static escape(B[B)[B
    .locals 6

    .line 255
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 256
    invoke-virtual {v0, p0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 257
    nop

    .line 258
    array-length p0, p1

    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v2, p0, :cond_2

    aget-byte v4, p1, v2

    .line 259
    and-int/lit16 v4, v4, 0xff

    .line 260
    const/4 v5, 0x2

    if-lt v3, v5, :cond_0

    const/4 v5, 0x3

    if-gt v4, v5, :cond_0

    .line 261
    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 262
    const/4 v3, 0x0

    .line 264
    :cond_0
    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 265
    if-nez v4, :cond_1

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_1
    const/4 v3, 0x0

    .line 258
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 267
    :cond_2
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    return-object p0
.end method

.method static nextStart([BII)I
    .locals 2

    .line 119
    nop

    :goto_0
    add-int/lit8 v0, p1, 0x2

    if-ge v0, p2, :cond_1

    .line 120
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

    .line 119
    :cond_0
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 122
    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method public static onFormat(Landroid/media/MediaFormat;)V
    .locals 4

    .line 38
    const-string v0, "csd-0"

    :try_start_0
    const-string v1, "video/avc"

    const-string v2, "mime"

    invoke-virtual {p0, v2}, Landroid/media/MediaFormat;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    sput-boolean v1, LHeaderTiming;->avc:Z

    .line 39
    sget-boolean v1, LHeaderTiming;->avc:Z

    if-nez v1, :cond_0

    return-void

    .line 40
    :cond_0
    invoke-virtual {p0, v0}, Landroid/media/MediaFormat;->getByteBuffer(Ljava/lang/String;)Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 41
    if-nez v1, :cond_1

    return-void

    .line 42
    :cond_1
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->duplicate()Ljava/nio/ByteBuffer;

    move-result-object v1

    .line 43
    invoke-virtual {v1}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v2

    new-array v2, v2, [B

    .line 44
    invoke-virtual {v1, v2}, Ljava/nio/ByteBuffer;->get([B)Ljava/nio/ByteBuffer;

    .line 45
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

    .line 48
    :cond_2
    goto :goto_0

    .line 46
    :catchall_0
    move-exception p0

    .line 47
    const-string v0, "HeaderTiming"

    const-string v1, "format"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 49
    :goto_0
    return-void
.end method

.method public static onSample(Ljava/nio/ByteBuffer;)V
    .locals 7

    .line 53
    sget-boolean v0, LHeaderTiming;->avc:Z

    if-eqz v0, :cond_7

    if-nez p0, :cond_0

    goto :goto_2

    .line 55
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->limit()I

    move-result v0

    .line 56
    const/4 v1, 0x5

    if-ge v0, v1, :cond_1

    return-void

    .line 57
    :cond_1
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->hasArray()Z

    move-result v1

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_3

    .line 58
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->arrayOffset()I

    move-result v1

    .line 59
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->array()[B

    move-result-object p0

    .line 60
    add-int v4, v1, v0

    invoke-static {p0, v1, v4}, Ljava/util/Arrays;->copyOfRange([BII)[B

    move-result-object v4

    .line 61
    invoke-static {v4, v3}, LHeaderTiming;->rewrite([BZ)I

    move-result v5

    if-ne v5, v2, :cond_2

    invoke-static {v4, v3, p0, v1, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 62
    :cond_2
    return-void

    .line 64
    :cond_3
    const/16 v1, 0x1000

    invoke-static {v0, v1}, Ljava/lang/Math;->min(II)I

    move-result v1

    .line 66
    :goto_0
    new-array v4, v1, [B

    .line 67
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->duplicate()Ljava/nio/ByteBuffer;

    move-result-object v5

    .line 68
    invoke-virtual {v5, v3}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 69
    invoke-virtual {v5, v4, v3, v1}, Ljava/nio/ByteBuffer;->get([BII)Ljava/nio/ByteBuffer;

    .line 70
    if-ge v1, v0, :cond_4

    const/4 v5, 0x1

    goto :goto_1

    :cond_4
    const/4 v5, 0x0

    :goto_1
    invoke-static {v4, v5}, LHeaderTiming;->rewrite([BZ)I

    move-result v5

    .line 71
    const/4 v6, 0x2

    if-ne v5, v6, :cond_5

    .line 72
    nop

    .line 73
    move v1, v0

    goto :goto_0

    .line 75
    :cond_5
    if-ne v5, v2, :cond_6

    .line 76
    invoke-virtual {p0}, Ljava/nio/ByteBuffer;->duplicate()Ljava/nio/ByteBuffer;

    move-result-object p0

    .line 77
    invoke-virtual {p0, v3}, Ljava/nio/ByteBuffer;->position(I)Ljava/nio/Buffer;

    .line 78
    invoke-virtual {p0, v4, v3, v1}, Ljava/nio/ByteBuffer;->put([BII)Ljava/nio/ByteBuffer;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 80
    :cond_6
    return-void

    .line 82
    :catchall_0
    move-exception p0

    .line 83
    const-string v0, "HeaderTiming"

    const-string v1, "sample"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 85
    return-void

    .line 53
    :cond_7
    :goto_2
    return-void
.end method

.method static rewrite([BZ)I
    .locals 8

    .line 95
    nop

    .line 96
    array-length v0, p0

    const/4 v1, 0x0

    invoke-static {p0, v1, v0}, LHeaderTiming;->nextStart([BII)I

    move-result v0

    .line 97
    if-gez v0, :cond_0

    return v1

    :cond_0
    const/4 v2, 0x0

    .line 98
    :goto_0
    const/4 v3, 0x2

    if-ltz v0, :cond_7

    array-length v4, p0

    if-ge v0, v4, :cond_7

    .line 99
    aget-byte v4, p0, v0

    and-int/lit8 v4, v4, 0x1f

    .line 100
    const/4 v5, 0x1

    if-eq v4, v5, :cond_6

    const/4 v6, 0x5

    if-ne v4, v6, :cond_1

    goto :goto_2

    .line 101
    :cond_1
    array-length v6, p0

    invoke-static {p0, v0, v6}, LHeaderTiming;->nextStart([BII)I

    move-result v6

    .line 102
    if-gez v6, :cond_2

    if-eqz p1, :cond_2

    return v3

    .line 103
    :cond_2
    if-gez v6, :cond_3

    array-length v3, p0

    goto :goto_1

    :cond_3
    add-int/lit8 v3, v6, -0x3

    .line 104
    :goto_1
    if-le v3, v0, :cond_4

    add-int/lit8 v7, v3, -0x1

    aget-byte v7, p0, v7

    if-nez v7, :cond_4

    add-int/lit8 v3, v3, -0x1

    goto :goto_1

    .line 105
    :cond_4
    const/4 v7, 0x7

    if-ne v4, v7, :cond_5

    .line 106
    invoke-static {p0, v0, v3}, Ljava/util/Arrays;->copyOfRange([BII)[B

    move-result-object v3

    invoke-static {v3}, LHeaderTiming;->rewriteSps([B)[B

    move-result-object v3

    .line 107
    if-eqz v3, :cond_5

    .line 108
    array-length v2, v3

    invoke-static {v3, v1, p0, v0, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 109
    const/4 v2, 0x1

    .line 112
    :cond_5
    nop

    .line 113
    move v0, v6

    goto :goto_0

    .line 100
    :cond_6
    :goto_2
    return v2

    .line 114
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

    .line 127
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

    .line 128
    :cond_0
    :try_start_1
    invoke-static {p0}, LHeaderTiming;->compute([B)[B

    move-result-object v1

    .line 129
    sput-object p0, LHeaderTiming;->lastIn:[B

    .line 130
    sput-object v1, LHeaderTiming;->lastOut:[B
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 131
    monitor-exit v0

    return-object v1

    .line 126
    :catchall_0
    move-exception p0

    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method

.method static timingPos([B)I
    .locals 14

    .line 165
    const/4 v0, -0x1

    :try_start_0
    new-instance v1, LHeaderTiming$Bits;

    invoke-direct {v1, p0}, LHeaderTiming$Bits;-><init>([B)V

    .line 166
    const/16 v2, 0x8

    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    .line 167
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 168
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 169
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 170
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

    .line 173
    :cond_0
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    move-result v3

    .line 174
    if-ne v3, v8, :cond_1

    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 175
    :cond_1
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 176
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 177
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 178
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v4

    if-eqz v4, :cond_7

    .line 179
    const/4 v4, 0x0

    :goto_0
    if-eq v3, v8, :cond_2

    const/16 v10, 0x8

    goto :goto_1

    :cond_2
    const/16 v10, 0xc

    :goto_1
    if-ge v4, v10, :cond_7

    .line 180
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v10

    if-eqz v10, :cond_6

    .line 181
    const/4 v10, 0x6

    if-ge v4, v10, :cond_3

    const/16 v10, 0x10

    goto :goto_2

    :cond_3
    const/16 v10, 0x40

    .line 182
    :goto_2
    const/4 v11, 0x0

    const/16 v12, 0x8

    const/16 v13, 0x8

    :goto_3
    if-ge v11, v10, :cond_6

    .line 183
    if-eqz v12, :cond_4

    invoke-virtual {v1}, LHeaderTiming$Bits;->se()I

    move-result v12

    add-int/2addr v12, v13

    add-int/lit16 v12, v12, 0x100

    rem-int/lit16 v12, v12, 0x100

    .line 184
    :cond_4
    if-nez v12, :cond_5

    goto :goto_4

    :cond_5
    move v13, v12

    .line 182
    :goto_4
    add-int/lit8 v11, v11, 0x1

    goto :goto_3

    .line 179
    :cond_6
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 190
    :cond_7
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 191
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    move-result v3

    .line 192
    if-nez v3, :cond_8

    .line 193
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    goto :goto_6

    .line 194
    :cond_8
    if-ne v3, v9, :cond_9

    .line 195
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 196
    invoke-virtual {v1}, LHeaderTiming$Bits;->se()I

    .line 197
    invoke-virtual {v1}, LHeaderTiming$Bits;->se()I

    .line 198
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    move-result v3

    .line 199
    nop

    :goto_5
    if-ge v7, v3, :cond_9

    invoke-virtual {v1}, LHeaderTiming$Bits;->se()I

    add-int/lit8 v7, v7, 0x1

    goto :goto_5

    .line 201
    :cond_9
    :goto_6
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 202
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 203
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 204
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 205
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-nez v3, :cond_a

    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 206
    :cond_a
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 207
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_b

    .line 208
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 209
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 210
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 211
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 213
    :cond_b
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-nez v3, :cond_c

    return v0

    .line 214
    :cond_c
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_d

    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    const/16 v4, 0xff

    if-ne v3, v4, :cond_d

    .line 215
    invoke-virtual {v1, v6}, LHeaderTiming$Bits;->u(I)I

    .line 216
    invoke-virtual {v1, v6}, LHeaderTiming$Bits;->u(I)I

    .line 218
    :cond_d
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_e

    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 219
    :cond_e
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_f

    .line 220
    invoke-virtual {v1, v8}, LHeaderTiming$Bits;->u(I)I

    .line 221
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    .line 222
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_f

    .line 223
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 224
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 225
    invoke-virtual {v1, v2}, LHeaderTiming$Bits;->u(I)I

    .line 228
    :cond_f
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-eqz v3, :cond_10

    .line 229
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 230
    invoke-virtual {v1}, LHeaderTiming$Bits;->ue()I

    .line 232
    :cond_10
    invoke-virtual {v1, v9}, LHeaderTiming$Bits;->u(I)I

    move-result v3

    if-nez v3, :cond_11

    return v0

    .line 233
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

    .line 234
    :catch_0
    move-exception p0

    .line 235
    return v0
.end method

.method static unescape([BII)[B
    .locals 5

    .line 240
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 241
    nop

    .line 242
    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_0
    if-ge p1, p2, :cond_2

    .line 243
    aget-byte v3, p0, p1

    and-int/lit16 v3, v3, 0xff

    .line 244
    const/4 v4, 0x2

    if-lt v2, v4, :cond_0

    const/4 v4, 0x3

    if-ne v3, v4, :cond_0

    .line 245
    nop

    .line 246
    const/4 v2, 0x0

    goto :goto_1

    .line 248
    :cond_0
    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 249
    if-nez v3, :cond_1

    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    :cond_1
    const/4 v2, 0x0

    .line 242
    :goto_1
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 251
    :cond_2
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    return-object p0
.end method
