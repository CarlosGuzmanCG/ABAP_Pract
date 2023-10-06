class ZCL_HR_FAMILY_ALFA02 definition
  public
  create public .

public section.

  types:
    BEGIN OF gty_emp_family,
    mandt TYPE mandt,
    id_familiar      TYPE za23_id_familiar,
    id_empleado      TYPE za23_id_empleado,
    nombre           TYPE za23_nombre,
    apellido_paterno TYPE za23_apellido_pat,
    apellido_materno TYPE za23_apellido_mat,
    parentesco       TYPE za23_parentesco,
    calle            TYPE za23_direccion_calle,
    colonia          TYPE za23_direccion_colonia,
    municipio        TYPE za23_municipio,
    estado           TYPE za23_estado_rs,
    no_interior      TYPE za23_noc_interior,
    no_exterior      TYPE za23_noc_exterior,
    cp               TYPE za23_cod_postal,
    n_telefono1      TYPE za23_num_telefono1,
    n_telefono2      TYPE za23_num_telefono2.
 TYPES: END OF gty_emp_family .

  data:
    lt_family TYPE TABLE OF gty_emp_family .
  data:
    ls_family LIKE LINE OF  lt_family .

  methods UPDATE_EMPLOYEE_DATA .
  methods INSERT_FAMILY_MEMBER
    importing
      !LS_FAMILY like LS_FAMILY
    exporting
      !LT_FAMILY like LT_FAMILY .
  methods DELETE_FAMILY_MEMBER
    importing
      !ID_FAMILY type NUMC10
      !ID_EMPLOYEE type NUMC10
    exporting
      !LT_FAMILY like LT_FAMILY .
  methods UPDATE_FAMILY_MEMBER
    importing
      !ID_EMPLEADO type NUMC10
      !LS_FAMILY like LS_FAMILY
    exporting
      !LT_FAMILY like LT_FAMILY .
  methods INSERT_SKILL .
  methods DELETE_SKILL .
  methods UPDATE_SKILL .
PROTECTED SECTION.
private section.

  methods SELECT_FAMILY_MEMBER
    importing
      !ID_EMPLOYEE type NUMC10
    exporting
      !LT_FAMILY like LT_FAMILY .
  methods SELECT_SKILL .
ENDCLASS.



CLASS ZCL_HR_FAMILY_ALFA02 IMPLEMENTATION.


  METHOD delete_family_member.

  DATA: lcl_selec_member_fam TYPE REF TO zcl_hr_family_alfa02.
  CREATE OBJECT lcl_selec_member_fam.

  DELETE FROM za23_familiares WHERE id_familiar = id_family.

  IF sy-subrc = 0.
*    COMMIT WORK.
    CLEAR: lt_family.

    CALL METHOD lcl_selec_member_fam->select_family_member
      EXPORTING
        id_employee = id_employee
      IMPORTING
        lt_family   = lt_family .

  ENDIF.

  IF lcl_selec_member_fam IS BOUND.
    CLEAR: lcl_selec_member_fam.
  ENDIF.

  ENDMETHOD.


  method DELETE_SKILL.
  endmethod.


  METHOD insert_family_member.

   DATA: lcl_selec_member_fam type ref to ZCL_HR_FAMILY_ALFA02.
   create OBJECT lcl_selec_member_fam.

   INSERT za23_familiares FROM ls_family.

   IF sy-subrc EQ 0.
*     COMMIT WORK.
     CLEAR lt_family.

     CALL METHOD lcl_selec_member_fam->select_family_member
      EXPORTING
        id_employee = ls_family-id_empleado
      IMPORTING
        lt_family   = lt_family .
   ENDIF.

   IF lcl_selec_member_fam is BOUND.
     clear: lcl_selec_member_fam.
   ENDIF.

  ENDMETHOD.


  method INSERT_SKILL.
  endmethod.


  method SELECT_FAMILY_MEMBER.

    DATA: ls_family LIKE LINE OF lt_family.

    SELECT  * FROM za23_familiares INTO @ls_family  WHERE id_empleado EQ @id_employee.
      APPEND ls_family TO lt_family.
      CLEAR ls_family.
    ENDSELECT.

  endmethod.


  method SELECT_SKILL.
  endmethod.


  method UPDATE_EMPLOYEE_DATA.
  endmethod.


  METHOD update_family_member.

    DATA: lcl_selec_member_fam TYPE REF TO zcl_hr_family_alfa02,
          lt_temp_fam TYPE za23_familiares.

    CREATE OBJECT: lcl_selec_member_fam.

    UPDATE za23_familiares FROM ls_family.

    IF sy-subrc EQ 0.
*      COMMIT WORK.
      CLEAR: lt_family.

      CALL METHOD lcl_selec_member_fam->select_family_member
        EXPORTING
          id_employee = ls_family-id_empleado
        IMPORTING
          lt_family   = lt_family .

    ENDIF.

    IF lcl_selec_member_fam IS BOUND.
      CLEAR: lcl_selec_member_fam.
    ENDIF.


  ENDMETHOD.


  method UPDATE_SKILL.
  endmethod.
ENDCLASS.
