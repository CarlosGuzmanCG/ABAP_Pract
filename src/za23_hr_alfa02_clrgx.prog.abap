*&---------------------------------------------------------------------*
*& Include          ZA23_HR_ALFA02_CLRGX
*&---------------------------------------------------------------------*
*

CLASS lcl_validate_data DEFINITION.

  PUBLIC SECTION.

  METHODS: regex_name IMPORTING name TYPE string
    RETURNING VALUE(value_name) TYPE abap_bool.

  METHODS: regex_address IMPORTING address TYPE string
    RETURNING VALUE(value_adress) TYPE abap_bool.

  METHODS: regex_phone IMPORTING phone TYPE string
    RETURNING VALUE(value_phone) TYPE abap_bool.

  METHODS: regex_email IMPORTING email TYPE string
    RETURNING VALUE(value_email) TYPE abap_bool.

  METHODS: regex_curp IMPORTING curp TYPE string
    RETURNING VALUE(value_curp) TYPE abap_bool.

  METHODS: regex_rfc IMPORTING rfc TYPE string
    RETURNING VALUE(value_rfc) type abap_bool.

  methods: regex_imss importing imss type string
    RETURNING VALUE(value_imss) type abap_bool.

  PRIVATE SECTION.


  CONSTANTS: rgx_name TYPE string VALUE '^[a-zA-ZÑñ]+([ ]?[a-zA-ZÑñ]+)*$',
             rgx_street TYPE string VALUE '^[a-zA-ZÑñ0-9.,\s]+$',
             rgx_phone TYPE string VALUE '^(?![0])([0-9]){10,10}$',
             rgx_email TYPE string VALUE '^(?![\.\-\_\*\d])([a-zA-Z0-9]+)@((gmail)|(outlook)|([a-zA-Z]{2,20}]))(\.)((com)|(mx)).*$',
             rgx_curp TYPE string VALUE '^(?=[A-ZÑ&]{4})([A-ZÑ&])([AEIOUX]{1})([A-ZÑ&]{2})([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])([HM]{1})([A-ZÑ&]{2})([B-DF-HJ-NP-TV-Z]{3})([0-9A-Z]{1})([0-9]{1})$',
             rgx_rfc type string value '^([A-Z&Ñ]{4})(\d{2})((0[1-9])|(1[0-2]))(([0-2][1-9])|(3[0-1]))[A-Z\d]{3}$|^([A-Z&Ñ]{4})((\d{2}(0[1-9]|1[0-2])([0-2][1-9]|3[0-1])))((\w*[^\s\w]{1}\w*[^\s\w?])|(X{1}))(\d{3})$',
             rgx_imss type string value '[0-9]{11,11}$'.




ENDCLASS.


CLASS lcl_validate_data IMPLEMENTATION.


  METHOD regex_name.

    FIND REGEX rgx_name IN name.

    value_name = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

  ENDMETHOD.

  METHOD regex_address.

    FIND REGEX rgx_street IN address.

    value_adress = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

  ENDMETHOD.

  METHOD regex_phone.

*    DATA LV_POS.


    FIND REGEX rgx_phone IN phone.

    value_phone = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

  ENDMETHOD.

  METHOD regex_email.

    DATA lv_pos.

    FIND REGEX rgx_email IN email IGNORING CASE MATCH OFFSET lv_pos.

    value_email = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

    CLEAR lv_pos.

  ENDMETHOD.

  METHOD regex_curp.

    DATA lv_pos.

    FIND REGEX rgx_curp IN curp IGNORING CASE MATCH OFFSET lv_pos.

    value_curp = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

    CLEAR lv_pos.

  ENDMETHOD.

  method regex_rfc.

    FIND REGEX rgx_rfc IN rfc.

    value_rfc = COND abap_bool(
    WHEN sy-subrc = 0
      THEN abap_true
      ELSE abap_false
    ).

  ENDMETHOD.

  method regex_imss.

  find regex rgx_imss in imss.

  IF sy-subrc eq 0 and imss <> '00000000000'.

    value_imss = abap_true.

  ELSE.
    value_imss = abap_false.
  ENDIF.

  endmethod.

ENDCLASS.
