gcd   cmp r0, r1                                 ; �����β?
      beq stop
      blt less                                   ;if r0 > r1
      sub r0, r0, r1                             ; r0=r0-r1
      bal gcd
less  sub r1, r1, r0                             ; r1=r1-r0
      bal gcd
      stop