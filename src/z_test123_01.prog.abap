*&---------------------------------------------------------------------*
*& Report Z_TEST123_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_TEST123_01.

DATA: W_NUR(10) TYPE N,
      W_NUR2(10) TYPE N VALUE 204.



      MOVE W_NUR2 TO W_NUR.
      WRITE W_NUR COLOR COL_GROUP.

      W_NUR2 = 129.
      SKIP.
      WRITE W_NUR2 NO-ZERO.

      skip.
      WRITE W_NUR2 NO-ZERO.

      skip 3.
      WRITE 'Hola'.

      skip to line 4.
      WRITE 'nbgf'.
