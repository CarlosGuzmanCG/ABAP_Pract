*&---------------------------------------------------------------------*
*& Report Z42_ALIAS_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z42_ALIAS_ALFA02.

  types: begin of gty_flight,
     comp_aerea type s_carr_id,
     moneda     type s_currcode,
     end of gty_flight.

  data gt_flieghts type STANDARD TABLE OF gty_flight.

  select carrid as comp_aerea
         currency as moneda
    from zsflightalfa02 as vuelos
    into table gt_flieghts
    where carrid ne space
    group by carrid currency
    order by comp_aerea moneda.

    IF sy-subrc eq 0.
        cl_demo_output=>display( gt_flieghts ).
    ENDIF.
