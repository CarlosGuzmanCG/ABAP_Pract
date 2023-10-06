*&---------------------------------------------------------------------*
*& Report Z17_SEL_CLIENT_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z17_SEL_CLIENT_ALFA02.

  data gts_zs type spfli.

  select single * from spfli CLIENT SPECIFIED
    into gts_zs where mandt eq '000' and carrid = 'LH' and connid eq '400' .

    IF sy-subrc eq 0.

      write: / gts_zs-mandt,
             / gts_zs-cityfrom,
             / gts_zs-cityto.

    ENDIF.
