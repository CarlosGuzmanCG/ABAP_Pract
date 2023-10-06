*&---------------------------------------------------------------------*
*& Report Z10_MODITY_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z10_MODITY_ALFA02.

  data gt_zs type table of zscarralfa02.

  FIELD-SYMBOLS <GFT_ZS> TYPE zscarralfa02.

  data: url1 type c length 4 value 'http',
        url2 type c length 5 value 'https'.


  select * from zscarralfa02 INTO TABLE gt_zs.

  IF sy-subrc eq 0.

      LOOP AT gt_zs assigning <GFT_ZS>.

          replace url1 with url2 into <gft_zs>-url.

      ENDLOOP.

      <gft_zs>-carrid = 'IB'.
      <gft_zs>-carrname = 'Iberia Airlines'.
      <gft_zs>-currcode = 'EUR'.
      <gft_zs>-url = 'https://www.iberia.com'.

      append <gft_zs>-url to gt_zs.

      modify zscarralfa02 from table gt_zs.

      IF sy-subrc eq 0.

        write 'DATOS MODIFICADOS/ACTUALIZADOS'.

      ENDIF.

  ENDIF.
