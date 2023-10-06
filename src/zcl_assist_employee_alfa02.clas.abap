CLASS zcl_assist_employee_alfa02 DEFINITION
  PUBLIC
  INHERITING FROM cl_wd_component_assistance
  CREATE PUBLIC .

PUBLIC SECTION.

  CONSTANTS: ctex_button_next   type string value 'Next',
             ctex_button_finish type string value 'Finish'.

METHODS: insert_employee CHANGING cs_employee TYPE zempl_logali
  RETURNING VALUE(rv_process_ok) TYPE abap_bool,

  delete_employe IMPORTING iv_pernr TYPE pernr_d
    RETURNING VALUE(rv_process_ok) TYPE abap_bool,

    update_employee CHANGING is_employee TYPE zempl_logali
      RETURNING VALUE(rv_process_ok) TYPE abap_bool,

      GET_employee_list RETURNING VALUE(rt_employee_list) TYPE ztt_empl_list,

      GET_employee_panel_list RETURNING VALUE(rt_employee_panel_list) TYPE ztt_employee_header,

      get_company_details RETURNING VALUE(rs_company_details) type zst_employee_header,

      get_roadmap_info RETURNING VALUE(rs_roadmap_info) type zst_empl_roadmap.


PROTECTED SECTION.

PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_ASSIST_EMPLOYEE_ALFA02 IMPLEMENTATION.


  METHOD delete_employe.

    DELETE FROM zempl_logali WHERE pernr  EQ iv_pernr.

    IF sy-subrc EQ 0.
      rv_process_ok = abap_true.
    ENDIF.

   ENDMETHOD.


   METHOD get_company_details.

     select single * from zempl_company into @Data(ls_company_details)
       where comp_code eq ( select value from zempl_g_data where id eq 'BUKRS' ).

       IF  sy-subrc eq 0.
         MOVE-CORRESPONDING ls_company_details to rs_company_details.
       ENDIF.

   ENDMETHOD.


   METHOD GET_employee_list.

CALL FUNCTION 'Z_GET_EMPLOYEE_LIST'
 IMPORTING
   ET_EMPLOYEE_LIST       =  rt_employee_list   .


   ENDMETHOD.


  METHOD get_employee_panel_list.

    SELECT from zempl_logali
    FIELDS pernr, first_name, last_name
      where pernr ne @space
      order by pernr DESCENDING
      into table @rt_employee_panel_list.

 ENDMETHOD.


   METHOD get_roadmap_info.
     " class assisting
     select * from zempl_rm_steps
       into table @data(lt_roadmap_info)
       where language eq @sy-langu
       order by step_id ASCENDING.

       IF sy-subrc eq 0.

         LOOP AT lt_roadmap_info ASSIGNING FIELD-SYMBOL(<ls_roadmap_info>).

           CASE sy-tabix.

           	WHEN 1.

                rs_roadmap_info-step_1_desc       = <ls_roadmap_info>-step_desc.
                rs_roadmap_info-step_1_name       = <ls_roadmap_info>-step_name.
                rs_roadmap_info-step_1_enabled    = <ls_roadmap_info>-enabled.
                rs_roadmap_info-step_1_tooltip    = <ls_roadmap_info>-tooltip.
                rs_roadmap_info-step_1_visibility = <ls_roadmap_info>-visibility.

            WHEN 2.

                rs_roadmap_info-step_2_desc       = <ls_roadmap_info>-step_desc.
                rs_roadmap_info-step_2_name       = <ls_roadmap_info>-step_name.
                rs_roadmap_info-step_2_enabled    = <ls_roadmap_info>-enabled.
                rs_roadmap_info-step_2_tooltip    = <ls_roadmap_info>-tooltip.
                rs_roadmap_info-step_2_visibility = <ls_roadmap_info>-visibility.

            WHEN 3.

                rs_roadmap_info-step_3_desc       = <ls_roadmap_info>-step_desc.
                rs_roadmap_info-step_3_name       = <ls_roadmap_info>-step_name.
                rs_roadmap_info-step_3_enabled    = <ls_roadmap_info>-enabled.
                rs_roadmap_info-step_3_tooltip    = <ls_roadmap_info>-tooltip.
                rs_roadmap_info-step_3_visibility = <ls_roadmap_info>-visibility.

           ENDCASE.

         ENDLOOP.

         rs_roadmap_info-visibility = '02'.
         rs_roadmap_info-current_step_id = rs_roadmap_info-step_1_id.
         rs_roadmap_info-next_but_text = ctex_button_next.

       ENDIF.

   endmethod.


  METHOD insert_employee.

    SELECT SINGLE FROM zempl_logali FIELDS MAX( pernr )
      INTO @DATA(lv_max_pernr).

      ADD 1 TO lv_max_pernr.

      cs_employee-pernr = lv_max_pernr. " position of register user
      cs_employee-status = '1'.
      INSERT zempl_logali FROM cs_employee.

      IF sy-subrc EQ 0.
        rv_process_ok = abap_true.
      ENDIF.

  ENDMETHOD.


   METHOD update_employee.

    UPDATE zempl_logali FROM is_employee.

    IF sy-subrc EQ 0.
      rv_process_ok = abap_true.
    ENDIF.
   ENDMETHOD.
ENDCLASS.
