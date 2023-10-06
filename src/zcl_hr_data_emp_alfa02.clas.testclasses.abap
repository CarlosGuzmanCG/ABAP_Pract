*"* use this source file for your ABAP unit test classes

CLASS ltcl_test DEFINITION FOR TESTING
                           RISK LEVEL HARMLESS
                           DURATION SHORT.

  PRIVATE SECTION.
  DATA: lo_class_t TYPE REF TO zcl_hr_data_emp_alfa02.

  METHODS: test_emp_fam_skil FOR TESTING,
           test_emp FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.
  METHOD test_emp.
  CREATE OBJECT lo_class_t.
  DATA: ls_employee LIKE LINE OF zcl_hr_data_emp_alfa02=>gt_employee,
        lv_bool TYPE abap_bool.

  CALL METHOD lo_class_t->search_employee "EMPLOYEE INFORMATION SEARCH CLASS
    EXPORTING
      id_employee = 61
    IMPORTING
      ls_employee = ls_employee
      lv_bool     = lv_bool.

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_bool     " Data object with current value
        exp                  = abap_true   " Data object with expected type
        msg                  = 'Employee found'  " Description
    ).

  ENDMETHOD.

  method test_emp_fam_skil.
    CREATE OBJECT lo_class_t.
    DATA: lt_skill TYPE TABLE OF za23_habilidades,
          lt_family TYPE TABLE OF ZCL_HR_FAMILY_ALFA02=>gty_emp_family,
          lt2_family TYPE TABLE OF ZCL_HR_FAMILY_ALFA02=>gty_emp_family,
          lv_bool TYPE abap_bool.

    select * from za23_familiares where id_empleado eq '61' into table @lt2_family.

    CALL METHOD lo_class_t->search_data_emp
      EXPORTING
        id_employee = 61  " Numeric Character Field, Length 10
      IMPORTING
        gt_skill    = lt_skill   " STANDARD SKILL TABLE
        gt_family   = lt_family  " STANDARD CHART FOR EMERGENCY FAMILY MEMBERS
      .

     cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lt_family   " Data object with current value
        exp                  = lt2_family  " Data object with expected type
        msg                  = 'Right information' " Description
    ).

  ENDMETHOD.
ENDCLASS.
