*&---------------------------------------------------------------------*
*& Include          Z_CONCESIONARIO_AUT_ALFA02_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT. " logic of gui status button, copy of action

  ok_code = sy-ucomm. " value to be obtained by the functions that can occur

  CASE ok_code.
    WHEN 'BACK'. " same name of 'gui status'

      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_EXIT_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_exit_2000 INPUT. "  logic of 'gui status' button CANCEL

  ok_code = sy-ucomm.

  IF ok_code EQ 'CANCEL'. " same name of 'gui status' of screen

    LEAVE TO SCREEN 0. " instruction 0

  ENDIF.

ENDMODULE.
