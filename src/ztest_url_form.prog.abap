*&---------------------------------------------------------------------*
*& Include          ZTEST_URL_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  IF go_container is INITIAL.

CREATE OBJECT go_container
  EXPORTING
    container_name              = 'CONT'
  EXCEPTIONS
    cntl_error                  = 1
    cntl_system_error           = 2
    create_error                = 3
    lifetime_error              = 4
    lifetime_dynpro_dynpro_link = 5
    others                      = 6
    .
    IF sy-subrc <> 0.
     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  CREATE OBJECT go_html_viewer
    EXPORTING
*      shellstyle         =
      parent             = go_container
    EXCEPTIONS
      cntl_error         = 1
      cntl_install_error = 2
      dp_install_error   = 3
      dp_error           = 4
      others             = 5
      .
  IF sy-subrc <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

endif.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'GO'.
      CALL METHOD go_html_viewer->show_url
        EXPORTING
          url                    = GV_URL
          frame                  = GV_FRAME
*          in_place               = ' X'
*        EXCEPTIONS
*          cntl_error             = 1
*          cnht_error_not_allowed = 2
*          cnht_error_parameter   = 3
*          dp_error_general       = 4
*          others                 = 5
              .
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.

  ENDCASE.

ENDMODULE.
