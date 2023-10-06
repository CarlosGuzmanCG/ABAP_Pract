class ZCL_HTTP_PO1 definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_HTTP_PO1 IMPLEMENTATION.


  method IF_HTTP_EXTENSION~HANDLE_REQUEST.


    DATA: lr_request type ref to if_http_request,
          lr_response type ref to if_http_response,
          lv_value type string,
          lv_reason type xstring,
          lv_data type xstring,
          ep_xstring type xstring,
          ERROR_message type string,
          ep_po type ebeln.

    lr_request  = server->request.
    lr_response = server->response.

    "check the calling method

    IF lr_request->get_method( ) eq 'GET' .

      lv_value = lr_request->get_form_field(
                   name               = 'PO'
*                   formfield_encoding = 0
*                   search_option      = 3
                 ).

      EP_PO = lv_value.

      IF ep_po IS NOT INITIAL.

        CALL FUNCTION 'ZAFAR_PO_SF_PDF'
         EXPORTING
           IP_EBELN            = ep_po
         IMPORTING
           EP_XSTRING          = ep_xstring
           ERROR_MESSAGE       = error_message .

        lv_data = ep_xstring.
        lr_response->set_data( LV_DATA ).
        lr_response->set_status( CODE = 200 REASON = ' ' ).

        SELECT SINGLE MIMETYPE FROM TDWP INTO lv_value WHERE DAPPL = 'PDF'.

          IF SY-SUBRC = 0.

            lr_response->set_header_field( NAME = 'Content-Type' Value = lv_value ).

          ENDIF.

      ENDIF.

    ENDIF.

  endmethod.
ENDCLASS.
