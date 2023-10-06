*&---------------------------------------------------------------------*
*& Report Z04_INSERT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z04_INSERT_ALFA02.

  data: gt_sc type table of scarr,
        gw_zs type table of zscarralfa02.

  select * from scarr into table gt_sc.

  move-corresponding gt_sc to gw_zs.

  insert zscarralfa02 from table gw_zs ACCEPTING DUPLICATE KEYS.

  IF sy-subrc eq 0.

     write: 'Datos guardados....', sy-subty.

  Else.

    write 'Datos no guardados....'.

  ENDIF.
