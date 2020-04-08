⍝ Adapted from HASH.atf posted to bug-apl@gnu.org by Mike Duvos on 20150910.
⍝ Reworked as an APL Package Manager package by David B. Lamkins.

⍝ This is an implementation of SHA-256. The main functions are hash∆SHA256 and
⍝ hash∆HASH. These return a binary and hexadecimal hash, respectively, of their
⍝ character vector argument.
⍝
⍝ Ref: FIPS 180-4

⍝ FIX: Don't assume that input characters are in ⎕AV.
⍝ Use 18⎕CR? Use numeric vector as input?

∇Z←hash⍙BITSUM X
  Z←1=(32⍴2)⊤hash⍙T32|+/2⊥⍉X
∇

∇Z←hash⍙CH256 X
  Z←(X[0;]∧X[1;])≠(∼X[0;])∧X[2;]
∇

∇Z←hash⍙CHR2HEX X
  Z←hash⍙HEX[,⍉16 16⊤⎕AV⍳X]
∇

∇Z←hash⍙FINAL256 X
  Z←⎕AV[,⍉(4⍴256)⊤X]
∇

∇Z←hash∆HASH X;⎕IO
  ⎕IO←0
  Z←hash⍙CHR2HEX hash∆SHA256 X
∇

∇Z←hash⍙MAJ256 X
  Z←≠/[0]X∧1⊖X
∇

∇Z←hash⍙PAD X;L;S
  L←⍴Z←,⍉(8⍴2)⊤⎕AV⍳X
  Z←Z,1,64⍴0
  S←(⌊(511+⍴Z)÷512),512
  Z←(×/S)↑Z
  (¯64↑Z)←(64⍴2)⊤L
  Z←1=S⍴Z
∇

∇Z←hash⍙RE X;I
  Z←(1↑⍴X)⍴I←¯1
 L1:→((I←I+1)≥⍴Z)/0
  Z[I]←⊂X[I;]
  →L1
∇

∇Z←hash⍙SCHED X;I;T
  Z←16 32⍴X
  I←15
 L1:→((I←I+1)≥64)/0
  T←0 32⍴0
  T←T,[0]hash⍙sig1256 Z[I-2;]
  T←T,[0]Z[I-7;]
  T←T,[0]hash⍙sig0256 Z[I-15;]
  T←T,[0]Z[I-16;]
  Z←Z,[0]hash⍙BITSUM T
  →L1
∇

∇Z←hash⍙SCRAMBLE VL;H;W;K;a;b;c;d;e;f;g;h;I;T1;T2
  (H W K)←VL
  (a b c d e f g h)←hash⍙RE⍉1=(32⍴2)⊤H
  I←¯1
 L1:→((I←I+1)≥64)/L2
  T1←hash⍙BITSUM 5 32⍴h,(hash⍙SIG1256 e),(hash⍙CH256 3 32⍴e,f,g),K[I;],W[I;]
  T2←hash⍙BITSUM 2 32⍴(hash⍙SIG0256 a),hash⍙MAJ256 3 32⍴a,b,c
  h←g◊g←f◊f←e
  e←hash⍙BITSUM 2 32⍴d,T1
  d←c◊c←b◊b←a
  a←hash⍙BITSUM 2 32⍴T1,T2
  →L1
 L2:Z←hash⍙T32|H+2⊥⍉8 32⍴a,b,c,d,e,f,g,h
∇

∇Z←hash∆SHA256 X;⎕IO;M;H;I;K;W
  ⎕IO←0
  M←hash⍙PAD X
  H←hash⍙initH
  K←⍉(32⍴2)⊤hash⍙initK
  I←¯1
 L1:→((I←I+1)≥1↑⍴M)/L2
  W←hash⍙SCHED M[I;]
  H←hash⍙SCRAMBLE H W K
  →L1
 L2:Z←hash⍙FINAL256 H
∇

∇Z←hash⍙SIG0256 X
  Z←(¯2⌽X)≠(¯13⌽X)≠¯22⌽X
∇

∇Z←hash⍙SIG1256 X
  Z←(¯6⌽X)≠(¯11⌽X)≠¯25⌽X
∇

∇Z←hash⍙sig0256 X
  Z←(¯7⌽X)≠(¯18⌽X)≠32↑(3⍴0),X
∇

∇Z←hash⍙sig1256 X
  Z←(¯17⌽X)≠(¯19⌽X)≠32↑(10⍴0),X
∇

hash⍙HEX←'0123456789abcdef'

hash⍙T32←4294967296

hash⍙←1779033703 3144134277 1013904242 2773480762 1359893119 2600822924
hash⍙←hash⍙,528734635 1541459225
hash⍙initH←hash⍙
⊣ ⎕ex 'hash⍙'

hash⍙←1116352408 1899447441 3049323471 3921009573 961987163 1508970993
hash⍙←hash⍙,2453635748 2870763221 3624381080 310598401 607225278 1426881987
hash⍙←hash⍙,1925078388 2162078206 2614888103 3248222580 3835390401
hash⍙←hash⍙,4022224774 264347078 604807628 770255983 1249150122 1555081692
hash⍙←hash⍙,1996064986 2554220882 2821834349 2952996808 3210313671
hash⍙←hash⍙,3336571891 3584528711 113926993 338241895 666307205 773529912
hash⍙←hash⍙,1294757372 1396182291 1695183700 1986661051 2177026350
hash⍙←hash⍙,2456956037 2730485921 2820302411 3259730800 3345764771
hash⍙←hash⍙,3516065817 3600352804 4094571909 275423344 430227734 506948616
hash⍙←hash⍙,659060556 883997877 958139571 1322822218 1537002063 1747873779
hash⍙←hash⍙,1955562222 2024104815 2227730452 2361852424 2428436474
hash⍙←hash⍙,2756734187 3204031479 3329325298
hash⍙initK←hash⍙
⊣ ⎕ex 'hash⍙'
