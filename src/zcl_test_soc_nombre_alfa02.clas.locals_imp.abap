*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_sociedad definition.

    public section.

    METHODS: comprobar_sociedad importing BUKRS1 type BUKRS
                                exporting abap_s type abap_bool.

endclass.

class lcl_sociedad implementation.

    method comprobar_sociedad.

      data lv_bukrs type bukrs.

        select single bukrs into lv_bukrs from t001
          where bukrs eq bukrs1.

          if sy-subrc eq 0.

            abap_s = abap_true.

          endif.

    endmethod.

endclass.
