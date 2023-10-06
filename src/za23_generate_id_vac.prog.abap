*&---------------------------------------------------------------------*
*& Report ZA23_GENERATE_ID_VAC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZA23_GENERATE_ID_VAC.

DATA LV_NUM TYPE NUMC10.

  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr                   = '01'
      object                        = 'ZRH_ID_VAC' "NUMBER RANGE OBJECT
   IMPORTING
     NUMBER                        = lv_num
   EXCEPTIONS
     interval_not_found            = 1
     number_range_not_intern       = 2
     object_not_found              = 3
     quantity_is_0                 = 4
     quantity_is_not_1             = 5
     interval_overflow             = 6
     buffer_overflow               = 7
     OTHERS                        = 8 .

  IF sy-subrc EQ 0.
    EXPORT lv_num TO MEMORY ID 'ZID'.
    SUBMIT za23_hr_alfa02.
  ENDIF.
