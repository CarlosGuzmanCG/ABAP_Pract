*&---------------------------------------------------------------------*
*& Report ZTEST_LB_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_LB_ALFA02.

data: lb_name type char12.

CALL SCREEN 1000.
data: txtbox type string, LB2 type string.

*&---------------------------------------------------------------------*
*& Module STATUS_1000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_1000 OUTPUT.

      LOOP AT screen.
          LOOP AT screen.
            LB2 = TXTBOX.

          ENDLOOP.

        MODIFY SCREEN.

      ENDLOOP.

MODIFY SCREEN.

ENDMODULE.
