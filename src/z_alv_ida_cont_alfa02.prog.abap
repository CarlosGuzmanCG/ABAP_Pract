*&---------------------------------------------------------------------*
*& Report z_alv_ida_cont_alfa02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_alv_ida_cont_alfa02.

data gs_flight type sflight.

START-OF-SELECTION.

  SELEct-OPTIONS: so_carid for gs_flight-carrid,
                  so_conid for gs_flight-connid,
                  so_date   for gs_flight-fldate.

end-OF-SELECTION.

CALL SCREEN 2000.

INCLUDE: z_alv_ida_cont_alfa02_TOP,
         z_alv_ida_cont_alfa02_PBO,
         z_alv_ida_cont_alfa02_PAI,
         z_alv_ida_cont_alfa02_FO1.
