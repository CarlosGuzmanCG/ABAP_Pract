*&---------------------------------------------------------------------*
*& Report Z41_ALIAS_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z41_ALIAS_ALFA02.

  types: begin of gt_sc,
    ciudad_salida type s_from_cit,
    ciudad_llegada type s_to_city,
    end of gt_sc.

    data gz_zt type table of gt_sc.

  select cityfrom as ciudad_salida cityto as ciudad_llegada
    from zspflialfa02 into table gz_zt.

  IF sy-subrc eq 0.
     cl_demo_output=>display( gz_zt ).
  ENDIF.
