gcd   cmp r0, r1                                   ; 如果r0 > r1
      subgt r0, r0, r1                             ; r0=r0-r1
      sublt r1, r1, r0                             ; r1=r1-r0
      bne gcd                                      ; 到达结尾?
