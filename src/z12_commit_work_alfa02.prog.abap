*&---------------------------------------------------------------------*
*& Report Z12_COMMIT_WORK_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z12_COMMIT_WORK_ALFA02.

  data gwa_airline type zscarralfa02.

  select single * from zscarralfa02
         into gwa_airline where carrid eq 'AB'.

    IF sy-subrc eq 0.

       gwa_airline-currcode = 'USD'.

       update zscarralfa02 from gwa_airline.

       commit work.

       IF sy-subrc eq 0.

          write 'Actualizado con exito'.

       ENDIF.

    ENDIF.
