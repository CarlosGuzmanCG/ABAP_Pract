*&---------------------------------------------------------------------*
*& Report Z02_NEW_TI_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_new_ti_alfa02.

SELECT carrid, connid, fldate
  FROM sflight
  INTO TABLE @DATA(gt_new_flights).

SELECT carrid, connid, fldate
  FROM sflight
  INTO TABLE @gt_new_flights.

READ TABLE gt_new_flights INTO DATA(gs_new_flight) INDEX 1.

" DEVUELVE EXCEPCIONES
TRY.
DATA(gs_new_flight_2) = gt_new_flights[ 1 ]. "leer indice 1

gs_new_flight_2 = gt_new_flights[ carrid = 'AA' connid = '4080' ]. "lectura

CATCH cx_sy_itab_line_not_found INTO DATA(go_exception).
  go_exception->get_text( ).
ENDTRY.

LOOP AT gt_new_flights ASSIGNING FIELD-SYMBOL(<gs_new_fs>).

ENDLOOP.

APPEND INITIAL LINE TO gt_new_flights ASSIGNING FIELD-SYMBOL(<gs_new_fs_2>).
<gs_new_fs_2>-carrid = 'AA'.

DATA: gv_value_1 TYPE f VALUE '10',
      gv_value_2 TYPE f VALUE '1.9'.

DATA(gv_value) = gv_value_1 + gv_value_2.

SELECT carrid, connid, fldate
  FROM sflight
  INTO TABLE @DATA(gt_flights).

SELECT carrid, connid, fldate
  FROM sflight
  INTO TABLE @DATA(gt_airlines).

DATA: gt_final TYPE TABLE OF sflight,
      gs_final TYPE sflight.

" ----- l mismo
LOOP AT gt_flights ASSIGNING FIELD-SYMBOL(<gs_old_flights>) WHERE carrid EQ 'LH'.

  LOOP AT gt_flights ASSIGNING FIELD-SYMBOL(<gs_old_airlines>) WHERE connid EQ <gs_old_flights>-connid.

    gs_final-carrid = <gs_old_airlines>-carrid.
    gs_final-connid = <gs_old_airlines>-connid.
    APPEND gs_final TO gt_final.

  ENDLOOP.

ENDLOOP.

"---- lo mismo
gt_final = VALUE #(  FOR gs_new_flights IN gt_flights WHERE ( carrid = 'LH' )
                     for gs_new_airlines in gt_airlines where ( connid = gs_new_flights-connid )
                     ( carrid = gs_new_airlines-carrid
                       connid = gs_new_airlines-connid ) ).
