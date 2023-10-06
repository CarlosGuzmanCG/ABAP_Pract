*&---------------------------------------------------------------------*
*& Report Z06_UPDATE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z06_UPDATE_ALFA02.

  data gt_airline type table of zscarralfa02.

  field-SYMBOLS <gfs_airline> type zscarralfa02.

  DATA:
    url type c length 5 value '/home',
    str type string.


  select * from zscarralfa02
    into table gt_airline.


    IF sy-subrc eq 0.

      LOOP AT gt_airline ASSIGNING <gfs_airline>.

        Write: / 'Dato a actualizar',<gfs_airline>-url.

        CONCATENATE <gfs_airline>-url url into <gfs_airline>-url.

        Write: / 'Dato actualizado',<gfs_airline>-url.

      ENDLOOP.

      update zscarralfa02 from table gt_airline.

      IF sy-subrc eq 0.

        Write: / 'Fin de la actualizacion...'.

      ENDIF.

    ENDIF.
