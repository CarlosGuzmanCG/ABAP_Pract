*&---------------------------------------------------------------------*
*& Report Z31_AND_OR_NOT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z31_AND_OR_NOT_ALFA02.

  data gt_flights type table of zspflialfa02.

  select * from zspflialfa02
    into table gt_flights
    where cityfrom eq 'FRANKFURT'
    and ( cityto eq 'TOKYO' or cityto eq 'NEW YORK')
    and deptime ge '130000'.

   IF sy-subrc eq 0.
      cl_demo_output=>display( gt_flights ).
   ENDIF.
