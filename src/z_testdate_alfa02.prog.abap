*&---------------------------------------------------------------------*
*& Report Z_TESTDATE_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_TESTDATE_ALFA02.

PARAMETERS date TYPE c LENGTH 10.

DATA matcher TYPE REF TO cl_abap_matcher.
** For date
* FORMAT VALID 01/01/20000
matcher = cl_abap_matcher=>create( pattern = `[0-9]{1,2}/[0-9]{1,2}/[0-9]{2,4}`
                                   ignore_case = 'X'
                                   text = date ).



IF matcher->match( ) IS INITIAL.
  MESSAGE 'Wrong Format' TYPE 'I'.
ELSE.
  MESSAGE 'Format OK' TYPE 'I'.
ENDIF.
