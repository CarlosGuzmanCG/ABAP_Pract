*&---------------------------------------------------------------------*
*& Report Z09_MODIFY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z09_MODIFY_ALFA02.

  data gt_zs type zscarralfa02.

select * from
  zscarralfa02 into gt_zs where carrid = 'CO'.
endselect.

  IF sy-subrc eq 0.

    gt_zs-carrid = 'WZ'.

    Modify zscarralfa02 from gt_zs.

    IF sy-subrc eq 0.

      write / 'Datos insertados/actualizados'.

    Else.

        Write /'Error....'.

    ENDIF.

  ELSE.

    WRITE / 'No existen los datos '.

  ENDIF.
