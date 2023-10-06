*&---------------------------------------------------------------------*
*& Report Z_SQL_LECTURA_BKPF_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SQL_LECTURA_BKPF_ALFA02.

SELECT FROM BKPF
    FIELDS  BUKRS, GJAHR , BELNR
    WHERE  gjahr BETWEEN '2015' AND '2017'
    GROUP BY BUKRS, GJAHR , BELNR
    ORDER BY GJAHR DESCENDING
    INTO TABLE @DATA(LT_BKPF)
    UP TO 30 ROWS.

IF sy-subrc eq 0.
    cl_demo_output=>display( LT_BKPF ).
endif.
