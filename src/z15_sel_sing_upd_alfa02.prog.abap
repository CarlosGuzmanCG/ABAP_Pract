*&---------------------------------------------------------------------*
*& Report Z15_SEL_SING_UPD_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z15_SEL_SING_UPD_ALFA02.

  data gwa_flight type ZSPFLIALFA02.

  select single for update *
    from ZSPFLIALFA02
    into gwa_flight
    where carrid eq 'AA'
    and connid eq '17'.

    write sy-subrc.
