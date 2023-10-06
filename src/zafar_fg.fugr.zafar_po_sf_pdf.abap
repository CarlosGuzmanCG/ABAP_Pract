FUNCTION ZAFAR_PO_SF_PDF.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IP_EBELN) TYPE  EBELN OPTIONAL
*"  EXPORTING
*"     VALUE(EP_XSTRING) TYPE  XSTRING
*"     VALUE(ERROR_MESSAGE) TYPE  STRING
*"----------------------------------------------------------------------

"for smartform calling
DATA : FM_NAME            TYPE  RS38L_FNAM,
       CONTROL_PARAMETERS TYPE  SSFCTRLOP,
       OUTPUT_OPTIONS     TYPE  SSFCOMPOP,
       LW_SSFCRESCL       TYPE SSFCRESCL.

"for otf to pdf
DATA:  LI_OTF          TYPE TABLE OF ITCOO,
       LW_OTF          TYPE ITCOO,
       LI_OTF1         TYPE TABLE OF ITCOO,
       LI_PDF_TAB      TYPE TABLE OF TLINE,
       LI_CONTENT_TXT  TYPE SOLI_TAB,
       LW_CONTENT      TYPE SOLI,
       LI_CONTENT_HEX  TYPE SOLIX_TAB,
       LI_OBJHEAD      TYPE SOLI_TAB,
       lv_bin_filesize   TYPE i,
       LV_TRANSFER_BIN TYPE SX_BOOLEAN,
       LV_LEN          TYPE SO_OBJ_LEN.


CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
  EXPORTING
    FORMNAME                 = 'ZDEMO_PO1'
*   VARIANT                  = ' '
*   DIRECT_CALL              = ' '
 IMPORTING
   FM_NAME                  = FM_NAME
 EXCEPTIONS
   NO_FORM                  = 1
   NO_FUNCTION_MODULE       = 2
   OTHERS                   = 3
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


   CONTROL_PARAMETERS-GETOTF     = 'X'.
   CONTROL_PARAMETERS-PREVIEW    = space.
   CONTROL_PARAMETERS-NO_DIALOG  = 'X'.

   OUTPUT_OPTIONS-TDDEST = 'LP01'.


 CALL FUNCTION FM_NAME                       "'/1BCDWB/SF00000264'
  EXPORTING
*    ARCHIVE_INDEX              =
*    ARCHIVE_INDEX_TAB          =
*    ARCHIVE_PARAMETERS         =
    CONTROL_PARAMETERS         = CONTROL_PARAMETERS
*    MAIL_APPL_OBJ              =
*    MAIL_RECIPIENT             =
*    MAIL_SENDER                =
    OUTPUT_OPTIONS             = OUTPUT_OPTIONS
    USER_SETTINGS              = 'X'
    IP_EBELN                   = IP_EBELN
  IMPORTING
*    DOCUMENT_OUTPUT_INFO       =
    JOB_OUTPUT_INFO            = LW_SSFCRESCL
*    JOB_OUTPUT_OPTIONS         =
  EXCEPTIONS
    FORMATTING_ERROR           = 1
    INTERNAL_ERROR             = 2
    SEND_ERROR                 = 3
    USER_CANCELED              = 4
    OTHERS                     = 5
           .
 IF SY-SUBRC <> 0.
* Implement suitable error handling here
 ENDIF.


*/.. Get OTF data to convert to PDF
    REFRESH LI_OTF[].
    LI_OTF[] = LW_SSFCRESCL-OTFDATA[].
    CLEAR : LV_BIN_FILESIZE.

    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        FORMAT                = 'PDF'
      IMPORTING
        BIN_FILESIZE          = LV_BIN_FILESIZE
        BIN_FILE              = EP_XSTRING
      TABLES
        OTF                   = LI_OTF
        LINES                 = LI_PDF_TAB
      EXCEPTIONS
        ERR_MAX_LINEWIDTH     = 1
        ERR_FORMAT            = 2
        ERR_CONV_NOT_POSSIBLE = 3
        ERR_BAD_OTF           = 4
        OTHERS                = 5.

    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


ENDFUNCTION.
