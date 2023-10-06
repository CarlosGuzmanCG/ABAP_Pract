*&---------------------------------------------------------------------*
*& Report ZDATA01_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDATA01_ALFA02.

*  data: gzs_zs type table of  zscarralfa02,
*        gd_sd type table of scarr.
*
*  select * from scarr into table gzs_zs.
*
*  modify zscarralfa02 from table gzs_zs.

*  data: gzs_zs type table of  ZSPFLIALFA02,
*        gd_sd type table of SPFLI.
*
*  select * from SPFLI into table gzs_zs.
*
*  modify ZSPFLIALFA02 from table gzs_zs.

*  data: gzs_zs type table of ZSAPLANEALFA02 ,
*        gd_sd type SAPLANE.
*
*  select * from SAPLANE into table gzs_zs.
*
*  modify ZSAPLANEALFA02 from table gzs_zs.


  data: gzs_zs type table of ZMAT_ALFA02.

  select

MANDT
MATNR
ERSDA
ERNAM
LAEDA
AENAM
VPSTA
PSTAT
     from MARA into table gzs_zs.

  modify ZMAT_ALFA02 from table gzs_zs.
