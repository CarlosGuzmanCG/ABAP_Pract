class ZCL_HR_DATA_EMP_ALFA02 definition
  public
  create public .

public section.

  data:
    gt_skill TYPE TABLE OF za23_habilidades .
  data:
    gt_family TYPE TABLE OF zcl_hr_family_alfa02=>gty_emp_family .
  data:
    gt_employee TYPE TABLE OF za23_empleados .
  data:
    gs_employee LIKE LINE OF gt_employee .

  methods SEARCH_DATA_EMP
    importing
      !ID_EMPLOYEE type NUMC10
    exporting
      !GT_SKILL like GT_SKILL
      !GT_FAMILY like GT_FAMILY .
  methods SEARCH_EMPLOYEE
    importing
      !ID_EMPLOYEE type NUMC10
    exporting
      !LS_EMPLOYEE like GS_EMPLOYEE
      !LV_BOOL type ABAP_BOOL .
PROTECTED SECTION.
PRIVATE SECTION.
  DATA: ls_skill LIKE LINE OF gt_skill.
  DATA: ls_family LIKE LINE OF gt_family.

ENDCLASS.



CLASS ZCL_HR_DATA_EMP_ALFA02 IMPLEMENTATION.


  METHOD search_data_emp.

    DATA: ls_skill LIKE ls_skill,
          ls_family LIKE ls_family.

    SELECT employee~id_empleado, member_fam~*, skill_emp~*
      FROM ( za23_empleados AS employee
      INNER JOIN za23_familiares AS member_fam
     ON employee~id_empleado = member_fam~id_empleado
      INNER JOIN za23_habilidades AS skill_emp
     ON employee~id_empleado = skill_emp~id_empleado )
     WHERE employee~id_empleado = @id_employee INTO @DATA(lt_search_fam_skill).

      IF lt_search_fam_skill-skill_emp-id_empleado EQ id_employee.
        ls_skill = lt_search_fam_skill-skill_emp.
        APPEND ls_skill TO gt_skill.
      ENDIF.

      IF lt_search_fam_skill-member_fam-id_empleado EQ id_employee.
        ls_family = lt_search_fam_skill-member_fam.
        APPEND ls_family TO gt_family.
      ENDIF.

    CLEAR:  ls_family,ls_skill, lt_search_fam_skill.
    ENDSELECT.

    SORT gt_family BY id_familiar.
    SORT gt_skill BY id_habilidad.
    DELETE ADJACENT DUPLICATES FROM gt_family COMPARING id_familiar.
    DELETE ADJACENT DUPLICATES FROM gt_skill COMPARING id_habilidad.

  ENDMETHOD.


  METHOD search_employee.

    SELECT SINGLE * FROM za23_empleados INTO @ls_employee
      WHERE id_empleado = @id_employee AND status EQ 'ACT'.

    IF sy-subrc eq 0.
      lv_bool = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
