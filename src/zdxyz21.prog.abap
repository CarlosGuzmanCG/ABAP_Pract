*&---------------------------------------------------------------------*
*& Report ZDXYZ21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdxyz21.

*TABLES: zzemp_alfa02.

include: FZZEMP_ALFA02CDT.

DATA: gs_emp_master TYPE zzemp_alfa02.
DATA: gs_emp_master_o TYPE zzemp_alfa02.
DATA: gv_flag TYPE flag.

DATA: r_m,
      r_f,
      r_u.

DATA: gv_id TYPE vrm_id,
      gt_values TYPE vrm_values,
      gs_values LIKE LINE OF gt_values.

DATA: gv_init,
      gv_ans.

DATA: gv_len TYPE i.
DATA: gt_state_city TYPE STANDARD TABLE OF zstate_city,
      gs_state_city TYPE zstate_city.

DATA: garg LIKE seqg3-garg,
      enq LIKE STANDARD TABLE OF seqg3 WITH HEADER LINE,
      gv_msg TYPE string.

data: gt_icdtxt   type STANDARD TABLE OF cdtxt,
      gv_objectid type cdhdr-objectid.

DATA: GV_CURSOR TYPE CHAR50.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_empid TYPE zzemp_alfa02-empid OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

CALL FUNCTION 'ENQUEUE_EZZEMP_ALFA02' " OBJECT LOCK SM12
 EXPORTING
   mode_zzemp_alfa02       = 'E'
   mandt                   = sy-mandt
   empid                   = p_empid
*   X_EMPID                 = ' '
*   _SCOPE                  = '2'
*   _WAIT                   = ' '
*   _COLLECT                = ' '
 EXCEPTIONS
   foreign_lock            = 1
   system_failure          = 2
   OTHERS                  = 3
          .
IF sy-subrc = 1.

  CONCATENATE sy-mandt p_empid INTO garg.

  CALL FUNCTION 'ENQUEUE_READ'
   EXPORTING
     gclient                     = sy-mandt
     gname                       = 'ZZEMP_ALFA02'
     garg                        = GARG
*     GUNAME                      = SY-UNAME
*     LOCAL                       = ' '
*     FAST                        = ' '
*     GARGNOWC                    = ' '
*   IMPORTING
*     NUMBER                      =
*     SUBRC                       =
    TABLES
      enq                         = enq
   EXCEPTIONS
     communication_failure       = 1
     system_failure              = 2
     OTHERS                      = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE enq INDEX 1.

  CONCATENATE 'THE OBJECT IS LOCK BY USER' enq-guname INTO gv_msg SEPARATED BY space.

  MESSAGE S002(zemp_alfa02) with enq-guname.

*  MESSAGE gv_msg TYPE 'S'.

  SET SCREEN 0.

* Implement suitable error handling here
*  MESSAGE 'OBJECT IS LOCK BY OTHER USER' TYPE 'S'.
*  SET SCREEN 0.

ELSE.


  SELECT SINGLE * FROM zzemp_alfa02 INTO CORRESPONDING FIELDS OF gs_emp_master
    WHERE empid = p_empid.

    gs_emp_master-empid = p_empid.

  IF gs_emp_master-gender = 'M'.
    r_m = 'X'.
  ELSEIF gs_emp_master-gender = 'F'.
    r_f = 'X'.
  ELSE.
    r_u = 'X'.
  ENDIF.

    CALL SCREEN 0100.

  " FREE OBJECT
    CALL FUNCTION 'DEQUEUE_EZZEMP_ALFA02'
     EXPORTING
       MODE_ZZEMP_ALFA02       = 'E'
       MANDT                   = SY-MANDT
       EMPID                   = p_empid
*       X_EMPID                 = ' '
*       _SCOPE                  = '3'
*       _SYNCHRON               = ' '
*       _COLLECT                = ' '
              .


 ENDIF.

end-of-SELECTION.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'PF1'.
 SET TITLEBAR 'T1'.

 IF gv_init IS INITIAL.
   PERFORM set_list-box.
   gv_init = 'X'.
 ENDIF.

 IF gs_emp_master-maritial_status NE 'M'.

   LOOP AT SCREEN. " CLOCK FIELD

    IF screen-group1 = 'HD1'.
      screen-input = 0.
      MODIFY SCREEN.

    ENDIF.

   ENDLOOP.

   LOOP AT SCREEN.

    IF screen-group2 = 'HD2'.
        screen-input = 0.
        MODIFY SCREEN.
    ENDIF.

   ENDLOOP.

 ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  SET SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      SET SCREEN 0.
    WHEN 'SAVE'.
      PERFORM save_confirmation.

      IF gv_ans = '1'.
        PERFORM save.
      ENDIF.
    WHEN 'STATE'.
      PERFORM set_state_city.
    WHEN 'GENDER'.

      IF r_m IS NOT INITIAL.
        gs_emp_master-title = 'MR.'.
      ELSEIF r_f IS NOT INITIAL.
        gs_emp_master-title = 'MRS.'.
      ENDIF.

    when 'PICK'.
" EVENT DOUBLE CLICK
      GET CURSOR FIELD GV_CURSOR.

      IF GV_CURSOR = 'GS_EMP_MASTER-EMPID'.
        CALL TRANSACTION 'XK03'.
      ENDIF.

  ENDCASE.

    CLEAR: sy-ucomm.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SAVE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save .

  IF gs_emp_master-createdby IS INITIAL.

    gs_emp_master-createdby = sy-uname.
    gs_emp_master-createdby = sy-datum.
    gs_emp_master-createdby = sy-uzeit.


  ENDIF.

  IF r_m IS NOT INITIAL.
    gs_emp_master-gender = 'M'.
  ELSEIF r_f IS NOT INITIAL.
    gs_emp_master-gender = 'F'.
  ELSE.
    CLEAR gs_emp_master-gender.
  ENDIF.

  perform change_log.

  MODIFY zzemp_alfa02 FROM gs_emp_master.

  MESSAGE 'Data saved successfully' TYPE 'S'.
  SET SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_list-box
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_list-box .

  CLEAR: gt_values[], gs_values.

  gs_values-key = 'MR.'.
  APPEND gs_values TO gt_values.

  gs_values-key = 'MRS.'.
  APPEND gs_values TO gt_values.

  SORT gt_values BY key.

  DELETE ADJACENT DUPLICATES FROM gt_values COMPARING key.

  gv_id = 'GS_EMP_MASTER-TITLE'.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id                    = gv_id
      values                = gt_values
   EXCEPTIONS
     id_illegal_name       = 1
     OTHERS                = 2
            .
  CLEAR: gs_values, gt_values[].

  "-------- STATE

  SELECT * FROM zstate_city INTO CORRESPONDING FIELDS OF TABLE gt_state_city.

    SORT gt_state_city BY state.

    DELETE ADJACENT DUPLICATES FROM gt_state_city COMPARING state.

    LOOP AT gt_state_city INTO gs_state_city.

      gs_values-key = gs_state_city-state.

      APPEND gs_values TO gt_values.

      CLEAR: gs_state_city.

    ENDLOOP.


  SORT gt_values BY key.

  DELETE ADJACENT DUPLICATES FROM gt_values COMPARING key.

  gv_id = 'GS_EMP_MASTER-STATE'.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id                    = gv_id
      values                = gt_values
   EXCEPTIONS
     id_illegal_name       = 1
     OTHERS                = 2
            .
  CLEAR: gs_values, gt_values[].



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_STATE_CITY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_state_city .

  SELECT * FROM zstate_city INTO CORRESPONDING FIELDS OF TABLE gt_state_city
    WHERE state = gs_emp_master-state.

  CLEAR: gt_values[], gs_values.

    LOOP AT gt_state_city INTO gs_state_city.

      gs_values-key = gs_state_city-city.
      APPEND gs_values TO gt_values.
      CLEAR: gs_values.
    ENDLOOP.

    SORT gt_values BY key.
    DELETE ADJACENT DUPLICATES FROM gt_values COMPARING key.

    gv_id = 'GS_EMP_MASTER-CITY'.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id                    = gv_id
        values                = gt_VALUES
*     EXCEPTIONS
*       ID_ILLEGAL_NAME       = 1
*       OTHERS                = 2
              .
    CLEAR: gs_values, gt_values[].


ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  FIELD_VALIDATION  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE field_validation INPUT.

  CASE sy-ucomm.
    WHEN 'SAVE'.

      IF gs_emp_master-pan IS INITIAL.

*        MESSAGE 'ENTER THE PAN CARD No.' TYPE 'E'.

         MESSAGE E000(ZEMP_MASTER).

      ELSE.

        gv_len = strlen( gs_emp_master-pan ).

        IF gv_len NE 10.

          MESSAGE 'PAN CARD SHOULD BE OF LENGTH 10' TYPE 'E'.

        ENDIF.

      ENDIF.

      IF gs_emp_master-maritial_status = 'M' AND
         gs_emp_master-spouse IS INITIAL.

        MESSAGE 'SPOUSE NAME IS MANDATORY FOR MARRIED EMPLOYEE' TYPE 'E'.

      ENDIF.

      IF gs_emp_master-doj IS INITIAL.

        MESSAGE 'PLEASE ENTER THE DATA OF JOINING' TYPE 'E'.

      ENDIF.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form save_confirmation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_confirmation .

CALL FUNCTION 'POPUP_TO_CONFIRM'
  EXPORTING
   TITLEBAR                    = 'CONFIRMATION'
*   DIAGNOSE_OBJECT             = ' '
    text_question               = 'DO YOU WANT TO SAVE'
   TEXT_BUTTON_1               = 'YES'
*   ICON_BUTTON_1               = ' '
   TEXT_BUTTON_2               = 'NO'
*   ICON_BUTTON_2               = ' '
*   DEFAULT_BUTTON              = '1'
   DISPLAY_CANCEL_BUTTON       = 'X'
*   USERDEFINED_F1_HELP         = ' '
*   START_COLUMN                = 25
*   START_ROW                   = 6
*   POPUP_TYPE                  =
*   IV_QUICKINFO_BUTTON_1       = ' '
*   IV_QUICKINFO_BUTTON_2       = ' '
 IMPORTING
   ANSWER                      = gv_ans
* TABLES
*   PARAMETER                   =
 EXCEPTIONS
   TEXT_NOT_FOUND              = 1
   OTHERS                      = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form change_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM change_log .

  select single * from zzemp_alfa02 into CORRESPONDING FIELDS OF gs_emp_master_o where empid = p_empid.

    gv_objectid = p_empid.
    CONDENSE gv_objectid.

    CALL FUNCTION 'ZZEMP_ALFA02_WRITE_DOCUMENT'
      EXPORTING
        objectid                      = gv_objectid
        tcode                         = sy-tcode
        utime                         = sy-uzeit
        udate                         = sy-datum
        username                      = sy-uname
*       PLANNED_CHANGE_NUMBER         = ' '
       OBJECT_CHANGE_INDICATOR       = 'U'
*       PLANNED_OR_REAL_CHANGES       = ' '
*       NO_CHANGE_POINTERS            = ' '
*       UPD_ICDTXT_ZZEMP_ALFA02       = ' '
       N_ZZEMP_ALFA02                = gs_emp_master
       O_ZZEMP_ALFA02                = gs_emp_master_o
       UPD_ZZEMP_ALFA02              = 'U'
      TABLES
        icdtxt_zzemp_alfa02           = gt_icdtxt
              .


ENDFORM.
