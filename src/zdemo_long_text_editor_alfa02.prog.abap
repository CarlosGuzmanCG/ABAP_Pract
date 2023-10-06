*&---------------------------------------------------------------------*
*& Report ZDEMO_LONG_TEXT_EDITOR_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDEMO_LONG_TEXT_EDITOR_ALFA02.
tables: ekko.

data: editor_container type ref to cl_gui_custom_container,
      text_editor type ref to cl_gui_textedit.

CONSTANTS: line_length type i value 132.

DATA: gt_elines(line_length) type c occurs 0,
      gv_line(line_length) type c,

      gt_line type STANDARD TABLE OF tline,
      gs_line type tline,
      gv_name type tdobname.

selection-SCREEN begin of block b1 with frame title text-001.
  parameters: p_ebeln type ekko-ebeln.
SELECTION-SCREEN end of block b1.

START-OF-SELECTION.
   call screen 0100.
end-OF-SELECTION.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'PF1'.
 SET TITLEBAR 'T1'.

 IF text_editor is initial.
   create object editor_container
     EXPORTING
*       parent                      =                  " Parent container
       container_name              = 'TEXTEDITOR'                 " Name of the Screen CustCtrl Name to Link Container To
*       style                       =                  " Windows Style Attributes Applied to this Container
*       lifetime                    = lifetime_default " Lifetime
*       repid                       =                  " Screen to Which this Container is Linked
*       dynnr                       =                  " Report To Which this Container is Linked
*       no_autodef_progid_dynnr     =                  " Don't Autodefined Progid and Dynnr?
     EXCEPTIONS
       cntl_error                  = 1                " CNTL_ERROR
       cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
       create_error                = 3                " CREATE_ERROR
       lifetime_error              = 4                " LIFETIME_ERROR
       lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
       others                      = 6
     .
   IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.
 ENDIF.
 gs_line-tdline = 'HOLA'.
   LOOP AT gt_line into gs_line.
    APPEND gs_line-tdline to gt_elines.
    clear gs_line.
  ENDLOOP.

 call method text_editor->set_text_as_r3table
   EXPORTING
     table           = gt_elines                 " table with text
   EXCEPTIONS
     error_dp        = 1                " Error while sending R/3 table to TextEdit control!
     error_dp_create = 2                " ERROR_DP_CREATE
     others          = 3
   .
 IF SY-SUBRC <> 0.
  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 ENDIF.

 CREATE object text_editor
   EXPORTING
     max_number_chars           =  132                        " maximum number of characters insertable into editor control
*     style                      = 0                      " control style, if initial a defined value is choosen
     wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position " 0: OFF; 1: wrap a window border; 2: wrap at fixed position
     wordwrap_position          = line_length                      " position of wordwrap, only makes sense with wordwrap_mode=2
     wordwrap_to_linebreak_mode = cl_gui_textedit=>TRUE                    " eq 1: change wordwrap to linebreak; 0: preserve wordwraps
*     filedrop_mode              = dropfile_event_off       " event mode to handle drop of files on control
     parent                     = editor_container                         " Parent Container
*     lifetime                   =                          " for life time management
*     name                       =                          " name for the control
   EXCEPTIONS
     error_cntl_create          = 1                        " Error while performing creation of TextEdit control!
     error_cntl_init            = 2                        " Error while initializing TextEdit control!
     error_cntl_link            = 3                        " Error while linking TextEdit control!
     error_dp_create            = 4                        " Error while creating DataProvider control!
     gui_type_not_supported     = 5                        " This type of GUI is not supported!
     others                     = 6
   .
 IF SY-SUBRC <> 0.
  MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
    WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  set screen 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      set SCREEN 0.
    WHEN 'SAVE'.
      PERFORM save.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save .

  call method text_editor->get_text_as_r3table
*    EXPORTING
*      only_when_modified     = false            " get text only when modified
    IMPORTING
      table                  = gt_elines                  " text as R/3 table
*      is_modified            =                  " modify status of text
    EXCEPTIONS
      error_dp               = 1                " Error while retrieving text table via DataProvider control!
      error_cntl_call_method = 2                " Error while retrieving a property from TextEdit control
      error_dp_create        = 3                " Error while creating DataProvider Control
      potential_data_loss    = 4                " Potential data loss: use get_text_as_stream instead
      others                 = 5
    .
  IF SY-SUBRC <> 0.
   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  clear: gt_line[], gs_line, gv_line.

  loop at gt_elines into gv_line.

  gs_line-tdformat = '*'.
  gs_line-tdline = gv_line.
  APPEND gs_line to gt_line.

  clear: gs_line, gv_line.
  ENDLOOP.

  " call the create text FM

  gv_name = p_ebeln.
  CONDENSE gv_name.

  CALL FUNCTION 'CREATE_TEXT'
    EXPORTING
      fid               = 'Z001'
      flanguage         = SY-langu
      fname             = gv_name
      fobject           = 'ZEKKO'
*     SAVE_DIRECT       = 'X'
*     FFORMAT           = '*'
    TABLES
      flines            = gt_line
   EXCEPTIONS
     NO_INIT           = 1
     NO_SAVE           = 2
     OTHERS            = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
    MESSAGE 'ERROR WHILE SAVING THE TEXT' TYPE 'I'.
  ELSE.
     MESSAGE 'TEXT SAVED SUCCESSFULLY' TYPE 'I'.
     SET SCREEN 0.
  ENDIF.


ENDFORM.
