*&---------------------------------------------------------------------*
*& Include ZABC1TOP                                 - Module Pool      ZDXYZ2
*&---------------------------------------------------------------------*
PROGRAM zdxyz2.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.

  DATA: vbeln  TYPE vbak-vbeln,
        erdat  TYPE vbak-erdat,
        erzet  TYPE vbak-erzet,
        ernam  TYPE vbak-ernam,
        auart  TYPE vbak-auart.

  CASE sy-ucomm.
    WHEN 'DATA'.

      SELECT SINGLE erdat erzet ernam auart FROM vbak
        INTO (erdat, erzet, ernam, auart)
        WHERE vbeln = vbeln.

      IF sy-subrc NE 0.
        MESSAGE 'NO SALES DOCUMENT DATA IS AVAILABLE' TYPE 'I'.
      ENDIF.

    WHEN 'CLEAR'.
      CLEAR: vbeln, erdat, erzet, ernam, auart.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

    ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ABC1  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE abc1 INPUT.

  CASE sy-ucomm.

    WHEN 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ABC2  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE abc2 INPUT.
* This function 'POPUP_TO_INFORM' is help search of the field vbeln screen
 CALL FUNCTION 'POPUP_TO_INFORM'
   EXPORTING
     titel         = 'TITLE FOR CUSTOM F1 HELP'
     txt1          = 'CUSTOM F1 HELP FOR VBELN IS'
     txt2          = 'HERE WE HAVE TO PASS SALES DOC NO ONLY'
*    TXT3          = ' '
*    TXT4          = ' '
           .


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ABC3  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE abc3 INPUT.

*  TYPES: begin of ty_vbak,
*    vbeln type vbak-vbeln,
*    auart type vbak-vbeln,
*   end of ty_vbak.

*   data lt_vbak type table of ty_vbak.

   select vbeln, auart from vbak into table @data(lt_vbak)
     where auart in ('TA').

 if sy-subrc eq 0.

   CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
     EXPORTING
*      DDIC_STRUCTURE         = ' '
       retfield               = 'VBELN'
*      PVALKEY                = ' '
      DYNPPROG               = SY-REPID
      DYNPNR                 = SY-DYNNR
      DYNPROFIELD            = 'VBELN'
*      STEPL                  = 0
*      WINDOW_TITLE           =
*      VALUE                  = ' '
      VALUE_ORG              = 'S'
*      MULTIPLE_CHOICE        = ' '
*      DISPLAY                = ' '
*      CALLBACK_PROGRAM       = ' '
*      CALLBACK_FORM          = ' '
*      CALLBACK_METHOD        =
*      MARK_TAB               =
*    IMPORTING
*      USER_RESET             =
     tables
       value_tab              = lt_vbak
*      FIELD_TAB              =
*      RETURN_TAB             =
*      DYNPFLD_MAPPING        =
*    EXCEPTIONS
*      PARAMETER_ERROR        = 1
*      NO_VALUES_FOUND        = 2
*      OTHERS                 = 3
             .
   IF sy-subrc <> 0.
* Implement suitable error handling here
   ENDIF.

  ENDIF.


ENDMODULE.
