*&---------------------------------------------------------------------*
*& Report ZVIST_SUP_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZVIST_SUP_ALFA02.

  DATA ls_emple type zvs_empe_alfa02.

  ls_emple-num_dir = 3.

  ls_emple-nombre = 'Carlos'.

  insert zvs_empe_alfa02 from ls_emple.

  IF sy-subrc eq 0.
      write 'Datos guardados'.
  ENDIF.
