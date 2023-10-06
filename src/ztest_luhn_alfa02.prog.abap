*&---------------------------------------------------------------------*
*& Report ZTEST_LUHN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_LUHN_ALFA02.

DATA:
  lv_num_string TYPE string,
  lv_length     TYPE i,
  lv_mult       TYPE i,
  lv_sum        TYPE i,
  lv_digit      TYPE i.

lv_num_string = '9876543215'.
lv_length = STRLEN( lv_num_string ).

data lv_cont type i.
lv_cont = 0.

DO lv_length TIMES.

  IF sy-index MOD 2 = 0.
    lv_mult = 2.
  ELSE.
    lv_mult = 1.
  ENDIF.

    lv_digit = lv_num_string+sy-index(1) - 1.
    write lv_digit.
    lv_digit = lv_digit - '0'.
    lv_digit = lv_digit * lv_mult.

      lv_digit = lv_digit - '0'.
    lv_digit = lv_digit * lv_mult.

  IF lv_digit > 9.
    lv_digit = lv_digit - 9.
  ENDIF.

  lv_sum = lv_sum + lv_digit.

ENDDO.

lv_digit = ( 10 - ( lv_sum MOD 10 ) ) MOD 10.

lv_num_string = lv_num_string && lv_digit.

write lv_num_string.


*DATA:
*  lv_num_string TYPE string VALUE '3456789803',
*  lv_length     TYPE i,
*  lv_mult       TYPE i,
*  lv_sum        TYPE i,
*  lv_digit      TYPE i.
*
*lv_length = STRLEN( lv_num_string ).
*
*DO lv_length TIMES.
*  IF sy-index MOD 2 = 0.
*    lv_mult = 2.
*  ELSE.
*    lv_mult = 1.
*  ENDIF.
*
*  lv_digit = lv_num_string+sy-index(1).
*  lv_digit = lv_digit - '0'.
*  lv_digit = lv_digit * lv_mult.
*
*  IF lv_digit > 9.
*    lv_digit = lv_digit - 9.
*  ENDIF.
*
*  lv_sum = lv_sum + lv_digit.
*ENDDO.
*
*lv_digit = ( 10 - ( lv_sum MOD 10 ) ) MOD 10.
*
*lv_num_string = lv_num_string && lv_digit.
*
*write lv_num_string.

*
*DATA: NUMBER_PART TYPE C LENGTH 10,
*      CHECK_DIGIT TYPE C.
*
*
*
*NUMBER_PART = '3456789803'.
*
*
*DATA: LENGTH TYPE I, MULT1 TYPE N, MULT2 TYPE N VALUE 2,
*      PROD(2) TYPE N, ADDI TYPE P VALUE 0, MODU(1) TYPE N, REST TYPE P.
*DATA: WORK_STRING TYPE C LENGTH 10.
*
*WORK_STRING = NUMBER_PART.
*
*LENGTH = STRLEN( WORK_STRING ).
*
*SHIFT WORK_STRING RIGHT DELETING TRAILING SPACE.
*
*DO LENGTH TIMES.
*   SHIFT WORK_STRING RIGHT CIRCULAR.
*   WRITE WORK_STRING(1) TO MULT1.
*   PROD = MULT1 * MULT2.
*   ADDI = ADDI  + PROD(1) + PROD+1(1).
*   IF MULT2 = 1.
*     MULT2 = 1.
*   ELSE.
*     MULT2 = 0.
*   ENDIF.
*ENDDO.
*
*REST = ADDI MOD 10.
*
*MODU = ( 10 - REST ) MOD 10.
*
*CHECK_DIGIT = MODU.
*
*WRITE CHECK_DIGIT.

*
*DATA:
*lv_check_digit   TYPE c, "
*lv_number_part   TYPE c. "
*
*lv_number_part = '3456789803'.
** check lv_check_digit is not initial.
** lv_number_part = lv_check_digit.
*
*CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*  EXPORTING
*    number_part       = lv_number_part
* IMPORTING
*   CHECK_DIGIT       = lv_check_digit
*          .
**
*write lv_check_digit.

*DATA: lv_number_part TYPE string.
*
*lv_number_part = '1234567891'.
*
*  CHECK lv_number_part IS NOT INITIAL.
*
**  lv_number_part = number_part.
*
*  CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
*    EXPORTING
*      number_part = lv_number_part
*    IMPORTING
*      check_digit = check_digit.
*ENDFUNCTION.


*  DATA: sum(1) TYPE n VALUE 0. " Sum of checksum.
*  DATA: current TYPE i. " Current digit.
*  DATA: odd TYPE i VALUE 1. " Multiplier.
*  DATA: len TYPE i. " String crowler.
*  data: pr_valid type abap_bool.
*  data pi_string type c.
*  len = 7895462130.
*
*
*  " Luhn algorithm.
*  len = NUMOFCHAR( pi_string ) - 1.
*  WHILE ( len >= 0 ).
*    current = pi_string+len(1) * odd.
*    IF ( current > 9 ).
*      current = current - 9. " Digits sum.
*    ENDIF.
*    sum = sum + current.
*    odd = 3 - odd. " 1 <--> 2 Swich
*    len = len - 1. " Move to next charcter.
*  ENDWHILE.
*
*  " Validation check.
*  IF ( sum = 0 ).
*    pr_valid = abap_true.
*  ELSE.
*    pr_valid = abap_false.
*  ENDIF.



*CONSTANTS: luhn_map(16)     TYPE c VALUE '1224364851637587',
*             numbers(11)      TYPE c VALUE '0123456789 '.
*
*Data: pr_is_ok type abap_bool.
*
*  DATA: lv_counter(1) TYPE n,
*        lv_idcr(9)    TYPE n,
*        lv_luhn(9)    TYPE c.
*
*
*  " Check that there are only digits in the input.
**  REPLACE ALL OCCURRENCES OF REGEX '\D' IN pi_id WITH ''. " Remove none-digit chars.
*  CHECK pi_id CO numbers.
*
*  " Convert to 9 char with zero leads.
*  lv_idcr = pi_id.
*  lv_luhn = lv_idcr.
*
*  " replace chars to the Luhn of them.
*  TRANSLATE lv_luhn USING luhn_map.
*
*  " Sum of each even/odd digits. (luhn and original).
*  lv_counter =   lv_idcr+0(1) + lv_idcr+2(1) + lv_idcr+4(1) + lv_idcr+6(1) + lv_idcr+8(1)
*               + lv_luhn+1(1) + lv_luhn+3(1) + lv_luhn+5(1) + lv_luhn+7(1).
*
*  IF ( lv_counter = 0 ).
*    pr_is_ok = abap_true.
*  ELSE.
*    pr_is_ok = abap_false.
*  ENDIF.
