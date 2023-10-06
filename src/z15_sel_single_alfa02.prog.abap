*&---------------------------------------------------------------------*
*& Report Z15_SEL_SINGLE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z15_SEL_SINGLE_ALFA02.

data gwa_zs type ZSPFLIALFA02.

  types: begin of gty_flights,
         carrid   type s_carr_id,
         cityfrom type s_from_cit,
         airpfrom type s_fromairp,
         cityto   type s_to_city,
         airpto   type s_toairp,
      end of gty_flights.

   data gwa_zsf type gty_flights.

   select single * from ZSPFLIALFA02 into CORRESPONDING FIELDS OF
     gwa_zsf.

  IF sy-subrc eq 0.

    write: / gwa_zsf-carrid,
            gwa_zsf-cityfrom,
            gwa_zsf-airpfrom,
            gwa_zsf-cityto,
            gwa_zsf-airpto.

  ENDIF.
