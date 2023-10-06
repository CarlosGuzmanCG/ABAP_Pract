*&---------------------------------------------------------------------*
*& Include          ZDXYZ9_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_2000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_2000 OUTPUT.

 SET PF-STATUS 'ZSCREEN'.

 IF r1 IS INITIAL AND r2 IS INITIAL AND r3 IS INITIAL.
   r1 = 'X'.
 ENDIF.

 IF r1 IS NOT INITIAL.
   gv_screen = '2001'.
 ELSEIF r2 IS NOT INITIAL.
   gv_screen = '2002'.
 ELSEIF r3 IS NOT INITIAL.
   gv_screen = '2003'.
 ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN ''.

  ENDCASE.

ENDMODULE.
