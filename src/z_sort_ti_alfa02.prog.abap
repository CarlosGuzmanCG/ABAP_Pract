*&---------------------------------------------------------------------*
*& Report Z_SORT_TI_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SORT_TI_ALFA02.

data: gt_sociedades type standard table of t001,
      gwa_sociedades type t001.

select * from t001
      into table gt_sociedades where bukrs ne space.

if sy-subrc eq 0.

*  sort gt_sociedades ascending by butxt waers.

    sort gt_sociedades DESCENDING by butxt waers.

  LOOP at gt_sociedades into gwa_sociedades.

      data v_l1 type string.

      v_l1 = gwa_sociedades-waers.

    IF v_l1 eq 'USD'.
      write: / gwa_sociedades-butxt, gwa_sociedades-waers.
    ENDIF.

  ENDLOOP.

  LOOP AT gt_sociedades TRANSPORTING NO FIELDS
    where waers eq 'EUR'.

    exit.

  ENDLOOP.

  if sy-subrc eq 0.
  write / 'Existen una sociedad con la moneda EUR'.
  endif.


  if sy-subrc eq 0.

  LOOP AT GT_SOCIEDADES INTO gwa_sociedades.

    gwa_sociedades-waers = 'USD'.

    modify gt_sociedades from gwa_sociedades transporting waers.

  ENDLOOP.

    LOOP at gt_sociedades into gwa_sociedades.

      write: / gwa_sociedades-butxt, gwa_sociedades-waers.

  ENDLOOP.

  endif.

endif.
