class ZCL_TEST_SOC_NOMBRE_ALFA02 definition
  public
  create public
  for testing .

public section.

  methods TEST_COMPROBAR_SOCIEDAD
  for testing .
protected section.
private section.
ENDCLASS.



CLASS ZCL_TEST_SOC_NOMBRE_ALFA02 IMPLEMENTATION.


  method TEST_COMPROBAR_SOCIEDAD.

    data: lv_sociedad type ref to lcl_sociedad,
          lv_bool type abap_bool.

    create object lv_sociedad.

    lv_sociedad->comprobar_sociedad(
      EXPORTING
        bukrs1 = '001'
      IMPORTING
        abap_s = lv_bool
    ).

    cl_aunit_assert=>assert_equals(
      EXPORTING
        exp                  = abap_true
        act                  = lv_bool
        msg                  = 'CORRECTO'
*        level                = if_aunit_constants=>severity-medium
*        tol                  =
*        quit                 = if_aunit_constants=>quit-test
*        ignore_hash_sequence = abap_false
*      RECEIVING
*        assertion_failed     =
    ).

  endmethod.
ENDCLASS.
