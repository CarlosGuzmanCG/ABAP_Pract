*&---------------------------------------------------------------------*
*& Report Z32_AND_OR_NOT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z32_AND_OR_NOT_ALFA02.

  data gwa_zs type table of zspflialfa02.

  select * from zspflialfa02 into table gwa_zs
   where CARRID in ('JL','LH') and
    CONNID BETWEEN '200' and '500'  and
    CITYFROM IN ('TOKIO','FRANKFURT','NEW YORK') and
    DEPTIME between '100000' and '190000'.

    IF sy-subrc eq 0.
       cl_demo_output=>display( gwa_zs ).
    ENDIF.
