*&---------------------------------------------------------------------*
*& Include ZDS1TOP                                  - Module Pool      ZDXYZ_ALFA02
*&---------------------------------------------------------------------*
PROGRAM zdxyz_alfa02.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'AAA'.
 SET TITLEBAR 'BBB'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  data: io1 type i,
        io2 type i,
        io3 type i.

  CASE sy-ucomm.

  WHEN 'BACK'.
      LEAVE PROGRAM.
  when 'SUM'.
    IO3 = IO1 + IO2.
  when 'MINUS'.
    IO3 = IO1 - IO2.
  when 'PRODUCT'.
    IO3 = IO1 * IO2.
  WHEN 'CLEAR'.
    CLEAR: IO1, io2, io3.
  WHEN 'EXIT'.
    LEAVE PROGRAM.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ABCD  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE abcd INPUT.

  case SY-UCOMM.
    WHEN 'CANCEL'.
      leave program.

  endcase.

ENDMODULE.
