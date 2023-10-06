*&---------------------------------------------------------------------*
*& Report Z_SORTED_HASHED_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SORTED_HASHED_ALFA02.

DATA: gt_mat_sorted type sorted table of mara with non-unique key
      matnr ersda, gt_mat_hashed type hashed table of mara with unique key matnr ,gwa_mat type mara.

gwa_mat-matnr = '3'.

insert gwa_mat into table gt_mat_sorted.

gwa_mat-matnr = '5'.

insert gwa_mat into Table gt_mat_sorted.

insert gwa_mat into Table gt_mat_hashed.
