*&---------------------------------------------------------------------*
*& Report Z_DEMO_PCRE02
*&---------------------------------------------------------------------*
*& TEST ONE
*&---------------------------------------------------------------------*
REPORT Z_DEMO_PCRE02.

CLASS handle_regex DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_matcher_callout.
ENDCLASS.

CLASS handle_regex IMPLEMENTATION.
  METHOD if_abap_matcher_callout~callout.
    cl_demo_output=>write( |{ callout_num } { callout_string }| ).
  ENDMETHOD.
ENDCLASS.

CLASS demo_pcre DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS demo_pcre IMPLEMENTATION.
  METHOD main.
    DATA(regex) = cl_abap_regex=>create_pcre(
      pattern = `a(?C1)b(?C2)c(?C3)d(?C"D")e(?C"E")` ).

    DATA(matcher) = regex->create_matcher( text = `abcde` ).

    DATA(handler) = NEW handle_regex( ).
    matcher->set_callout( handler ).
    matcher->match( ).

    cl_demo_output=>display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo_pcre=>main( ).
