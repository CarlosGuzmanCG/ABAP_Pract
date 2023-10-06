*&---------------------------------------------------------------------*
*& Report ZA_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZA_TEST.

TABLES: bkpf.
TYPE-POOLS: slis.

TYPES: BEGIN OF ty_bkpf,
    bukrs TYPE bkpf-bukrs,
    belnr TYPE bkpf-belnr,
    gjahr TYPE bkpf-gjahr,
    blart TYPE bkpf-blart,
    bldat TYPE bkpf-bldat,
    budat TYPE bkpf-budat,
    monat TYPE bkpf-monat,
  END OF ty_bkpf.

DATA: lt_bkpf TYPE TABLE OF ty_bkpf.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.
** Contiene la info del pdf
DATA: BEGIN OF gt_objaux OCCURS 0.
        INCLUDE STRUCTURE tline.
DATA: END OF gt_objaux.

DATA: path TYPE string,
      fullpath TYPE string.

**********************************************************************
* Pantalla de Seleccion
**********************************************************************
SELECT-OPTIONS: so_belnr FOR bkpf-belnr,
                so_bukrs FOR bkpf-bukrs,
                so_gjahr FOR bkpf-gjahr.

PARAMETERS: p_file TYPE string.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM get_file USING p_file.

**********************************************************************
* Proceso Principal
**********************************************************************
START-OF-SELECTION.

  SELECT bukrs belnr gjahr blart bldat budat monat
    INTO TABLE lt_bkpf
    FROM bkpf
    WHERE bukrs IN so_bukrs
      AND belnr IN so_belnr
      AND gjahr IN so_gjahr.


  PERFORM zf_fieldcat.
  PERFORM zf_generar_alv.
  PERFORM zf_generar_pdf.
  PERFORM zf_bajar_pdf.
*&---------------------------------------------------------------------*
*& Form ZF_FIELDCAT
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM zf_fieldcat.

  gt_fieldcat-fieldname = 'BUKRS'.
  gt_fieldcat-tabname = 'LT_BKPF'.
  gt_fieldcat-seltext_l = 'Sociedad'.
  APPEND gt_fieldcat.

  gt_fieldcat-fieldname = 'BELNR'.
  gt_fieldcat-tabname = 'LT_BKPF'.
  gt_fieldcat-seltext_l = 'Documento'.
  APPEND gt_fieldcat.

  gt_fieldcat-fieldname = 'GJAHR'.
  gt_fieldcat-tabname = 'LT_BKPF'.
  gt_fieldcat-seltext_l = 'Ejercicio'.
  APPEND gt_fieldcat.

  gt_fieldcat-fieldname = 'BLART'.
  gt_fieldcat-tabname = 'LT_BKPF'.
  gt_fieldcat-seltext_l = 'Clase Docu.'.
  APPEND gt_fieldcat.

  gt_fieldcat-fieldname = 'BLDAT'.
  gt_fieldcat-tabname = 'LT_BKPF'.
  gt_fieldcat-seltext_l = 'Clase Docu.'.
  APPEND gt_fieldcat.

  gt_fieldcat-fieldname = 'BUDAT'.
  gt_fieldcat-tabname = 'LT_BKPF'.
  gt_fieldcat-seltext_l = 'Fecha Docu'.
  APPEND gt_fieldcat.

  gt_fieldcat-fieldname = 'MONAT'.
  gt_fieldcat-tabname = 'LT_BKPF'.
  gt_fieldcat-seltext_l = 'Periodo'.
  APPEND gt_fieldcat.

ENDFORM. " ZF_FIELDCAT
*&---------------------------------------------------------------------*
*& Form ZF_GENERAR_ALV
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM zf_generar_alv .

  DATA: ls_layout TYPE slis_layout_alv.
  DATA: lv_print TYPE slis_print_alv.

  lv_print-print                  = 'X'.
  lv_print-no_print_listinfos     = 'X'. " display no listinfos
  lv_print-no_change_print_params = 'X'.

  SY-BATCH = 'X'.

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      is_layout          = ls_layout
      it_fieldcat        = gt_fieldcat[]
      is_print           = lv_print
    TABLES
      t_outtab           = lt_bkpf
    EXCEPTIONS
   program_error                     = 1
   OTHERS                            = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM. " ZF_GENERAR_ALV
*&---------------------------------------------------------------------*
*& Form ZF_GENERAR_PDF
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM zf_generar_pdf .
* Spool to PDF conversions
  DATA: gd_bytecount LIKE tst01-dsize.

  DATA: x_rqid LIKE tsp01-rqident.

** Obtengo la orden de Spool ultima generada
  PERFORM get_numero_spool USING sy-repid
                                   sy-uname
                          CHANGING x_rqid.
* Genera el PDF
  CALL FUNCTION 'CONVERT_ABAPSPOOLJOB_2_PDF'
    EXPORTING
      src_spoolid              = x_rqid
      no_dialog                = space
    IMPORTING
      pdf_bytecount            = gd_bytecount
    TABLES
      pdf                      = gt_objaux
    EXCEPTIONS
      err_no_abap_spooljob     = 1
      err_no_spooljob          = 2
      err_no_permission        = 3
      err_conv_not_possible    = 4
      err_bad_destdevice       = 5
      user_cancelled           = 6
      err_spoolerror           = 7
      err_temseerror           = 8
      err_btcjob_open_failed   = 9
      err_btcjob_submit_failed = 10
      err_btcjob_close_failed  = 11
      OTHERS                   = 12.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM. " ZF_GENERAR_PDF
*&---------------------------------------------------------------------*
*& Form get_numero_spool
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* -->F_REPID text
* -->F_UNAME text
* -->F_RQIDENT text
*----------------------------------------------------------------------*
FORM get_numero_spool USING f_repid
                         f_uname
                CHANGING f_rqident.

  DATA: it_tsp01 LIKE tsp01 OCCURS 0 WITH HEADER LINE,
        ls_tsp01 TYPE tsp01.

  WAIT UP TO 1 SECONDS.

  SELECT rqident
     INTO CORRESPONDING FIELDS OF TABLE it_tsp01
     FROM tsp01
     WHERE rqowner  EQ sy-uname
       AND rqclient EQ sy-mandt.
*Ordeno en forma descendente para quedarme con el último formulario *generado
  SORT it_tsp01 DESCENDING BY rqident.

  READ TABLE it_tsp01 INTO ls_tsp01 INDEX 1.

  f_rqident = ls_tsp01-rqident.

ENDFORM. " get_numero_spool
*&---------------------------------------------------------------------*
*& Form ZF_BAJAR_PDF
*&---------------------------------------------------------------------*
* text
*----------------------------------------------------------------------*
* --> p1 text
* <-- p2 text
*----------------------------------------------------------------------*
FORM zf_bajar_pdf .

  DATA: lines TYPE STANDARD TABLE OF hlpext WITH HEADER LINE.

  DATA: lv_ruta(100) TYPE c,
        lv_extension(3) TYPE c.

  LOOP AT gt_objaux.
    lines-line+00(002) = gt_objaux-tdformat.
    lines-line+02(132) = gt_objaux-tdline.
    APPEND lines.
  ENDLOOP.

  SPLIT p_file AT '.' INTO lv_ruta lv_extension.

  CONCATENATE lv_ruta '_' sy-datum '_' sy-uzeit '.' lv_extension INTO p_file.

  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename                = p_file
      filetype                = 'BIN'
    CHANGING
      data_tab                = lines[]
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      not_supported_by_gui    = 22
      error_no_gui            = 23
      OTHERS                  = 24.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM. " ZF_BAJAR_PDF


FORM get_file USING p_p_file.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      window_title         = 'Guardar archivo.'
      default_extension    = 'pdf'
      default_file_name    = '.pdf'
      file_filter          = cl_gui_frontend_services=>filetype_all
      initial_directory    = 'C:\Users\'
    CHANGING
      filename             = p_p_file
      path                 = path
      fullpath             = fullpath
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  p_file = fullpath.

ENDFORM. " GET_FILE
