*&---------------------------------------------------------------------*
*& Report Z_SOR_HASH_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_sor_hash_alfa02.

DATA: gt_TableS TYPE SORTED TABLE OF kna1 WITH UNIQUE KEY
      kunnr,
      gt_TableH TYPE HASHED TABLE OF kna1 WITH UNIQUE KEY
      kunnr,
      gwa_IToH TYPE kna1.

gwa_IToH-kunnr = '123456789'.


Insert gwa_itoh into table gt_TableS.

Insert gwa_itoh into table gt_TableH.
