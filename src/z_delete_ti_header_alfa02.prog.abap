*&---------------------------------------------------------------------*
*& Report Z_DELETE_TI_HEADER_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DELETE_TI_HEADER_ALFA02.

data gt_facturas type standard table of vbrk with header line.

select * from vbrk into table
      gt_facturas where fkart eq 'F2'.

  if sy-subrc eq 0.

    write / 'Las facturas antes de eliminar los registros'.

    skip .

    LOOP at gt_facturas.

        write / gt_facturas-vbeln.

    endloop.


    WRITE / '...'.

    LOOP AT gt_facturas.

    if sy-tabix gt 2.

      delete gt_facturas.

    endif.

    ENDLOOP.

    LOOP at gt_facturas.

        write / gt_facturas-vbeln.

    endloop.

  endif.
