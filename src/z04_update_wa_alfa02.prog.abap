*&---------------------------------------------------------------------*
*& Report Z04_UPDATE_WA_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z04_UPDATE_WA_ALFA02.

  data gt_airline type standard table of zscarralfa02.

  field-symbols <gfs_airline> type zscarralfa02.

  constants: gc_http type c length 4 value 'http',
             gc_https type c length 5 value 'https'.

  select * from zscarralfa02
    into table gt_airline.

    IF sy-subrc eq 0.

      LOOP AT gt_airline assigning <gfs_airline>.

        replace gc_http with gc_https into <gfs_airline>-url.

      ENDLOOP.

      update zscarralfa02 from table gt_airline.

      IF sy-subrc eq 0.

          write / 'Se han actualizado todos los registros'.

       ELSE.

         Write / 'No se han actualizado todos los registros'.

      ENDIF.

    ENDIF.
