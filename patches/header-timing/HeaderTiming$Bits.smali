.class final LHeaderTiming$Bits;
.super Ljava/lang/Object;
.source "HeaderTiming.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = LHeaderTiming;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Bits"
.end annotation


# instance fields
.field final b:[B

.field pos:I


# direct methods
.method constructor <init>([B)V
    .locals 0

    .line 281
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 282
    iput-object p1, p0, LHeaderTiming$Bits;->b:[B

    .line 283
    return-void
.end method


# virtual methods
.method put32(J)V
    .locals 8

    .line 312
    const/16 v0, 0x1f

    :goto_0
    if-ltz v0, :cond_0

    .line 313
    shr-long v1, p1, v0

    const-wide/16 v3, 0x1

    and-long/2addr v1, v3

    long-to-int v2, v1

    iget v1, p0, LHeaderTiming$Bits;->pos:I

    shr-int/lit8 v1, v1, 0x3

    iget v3, p0, LHeaderTiming$Bits;->pos:I

    and-int/lit8 v3, v3, 0x7

    rsub-int/lit8 v3, v3, 0x7

    .line 314
    iget-object v4, p0, LHeaderTiming$Bits;->b:[B

    iget-object v5, p0, LHeaderTiming$Bits;->b:[B

    aget-byte v5, v5, v1

    const/4 v6, 0x1

    shl-int v7, v6, v3

    not-int v7, v7

    and-int/2addr v5, v7

    shl-int/2addr v2, v3

    or-int/2addr v2, v5

    int-to-byte v2, v2

    aput-byte v2, v4, v1

    .line 315
    iget v1, p0, LHeaderTiming$Bits;->pos:I

    add-int/2addr v1, v6

    iput v1, p0, LHeaderTiming$Bits;->pos:I

    .line 312
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 317
    :cond_0
    return-void
.end method

.method se()I
    .locals 2

    .line 307
    invoke-virtual {p0}, LHeaderTiming$Bits;->ue()I

    move-result v0

    .line 308
    and-int/lit8 v1, v0, 0x1

    if-eqz v1, :cond_0

    add-int/lit8 v0, v0, 0x1

    div-int/lit8 v0, v0, 0x2

    goto :goto_0

    :cond_0
    div-int/lit8 v0, v0, 0x2

    neg-int v0, v0

    :goto_0
    return v0
.end method

.method u(I)I
    .locals 4

    .line 286
    nop

    .line 287
    const/4 v0, 0x0

    const/4 v1, 0x0

    :goto_0
    if-ge v0, p1, :cond_0

    .line 288
    shl-int/lit8 v1, v1, 0x1

    iget-object v2, p0, LHeaderTiming$Bits;->b:[B

    iget v3, p0, LHeaderTiming$Bits;->pos:I

    shr-int/lit8 v3, v3, 0x3

    aget-byte v2, v2, v3

    iget v3, p0, LHeaderTiming$Bits;->pos:I

    and-int/lit8 v3, v3, 0x7

    rsub-int/lit8 v3, v3, 0x7

    shr-int/2addr v2, v3

    and-int/lit8 v2, v2, 0x1

    or-int/2addr v1, v2

    .line 289
    iget v2, p0, LHeaderTiming$Bits;->pos:I

    add-int/lit8 v2, v2, 0x1

    iput v2, p0, LHeaderTiming$Bits;->pos:I

    .line 287
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 291
    :cond_0
    return v1
.end method

.method u32()J
    .locals 5

    .line 295
    const/16 v0, 0x10

    invoke-virtual {p0, v0}, LHeaderTiming$Bits;->u(I)I

    move-result v1

    int-to-long v1, v1

    shl-long/2addr v1, v0

    invoke-virtual {p0, v0}, LHeaderTiming$Bits;->u(I)I

    move-result v0

    int-to-long v3, v0

    or-long/2addr v1, v3

    return-wide v1
.end method

.method ue()I
    .locals 3

    .line 299
    const/4 v0, 0x0

    .line 300
    :goto_0
    const/4 v1, 0x1

    invoke-virtual {p0, v1}, LHeaderTiming$Bits;->u(I)I

    move-result v2

    if-nez v2, :cond_1

    .line 301
    add-int/lit8 v0, v0, 0x1

    const/16 v1, 0x1f

    if-gt v0, v1, :cond_0

    goto :goto_0

    :cond_0
    new-instance v0, Ljava/lang/ArrayIndexOutOfBoundsException;

    invoke-direct {v0}, Ljava/lang/ArrayIndexOutOfBoundsException;-><init>()V

    throw v0

    .line 303
    :cond_1
    shl-int v2, v1, v0

    sub-int/2addr v2, v1

    invoke-virtual {p0, v0}, LHeaderTiming$Bits;->u(I)I

    move-result v0

    add-int/2addr v2, v0

    return v2
.end method
