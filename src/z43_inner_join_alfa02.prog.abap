*&---------------------------------------------------------------------*
*& Report Z43_INNER_JOIN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z43_inner_join_alfa02.

PARAMETERS: pa_ctyfr TYPE zspflialfa02-cityfrom,
            pa_ctyto TYPE zspflialfa02-cityto.

  TYPES: BEGIN OF gty_flight,
    fldate    TYPE zsflightalfa02-fldate,
    carrname  TYPE zscarralfa02-carrname,
    connid    TYPE zspflialfa02-connid,
  END OF gty_flight.

  DATA gt_flights TYPE SORTED TABLE OF gty_flight
        WITH UNIQUE KEY carrname connid fldate.

try.

    SELECT c~fldate a~carrname b~connid
    INTO CORRESPONDING FIELDS OF TABLE gt_flights
    FROM ( ( zscarralfa02 AS a
     INNER JOIN zspflialfa02 AS b ON b~carrid EQ a~carrid
                                  AND b~cityfrom EQ pa_ctyfr
                                  AND b~cityto EQ pa_ctyto )
    INNER JOIN zsflightalfa02 AS c ON c~carrid EQ b~carrid
                                   AND c~connid EQ b~connid ).
CATCH cx_root.

  write 'ERROR'.

ENDtry.

 IF sy-subrc EQ 0.
      cl_demo_output=>display( gt_flights ).
 ENDIF.
