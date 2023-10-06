interface ZIF_ZDPP_ALFA02 public.

" This interface pool has been generated.
" It contains the type definitions for
" database procedure proxy ZDPP_ALFA02
" representing db procedure _SYS_BIC.sap.erp.sappl.lo.sgt.L-Procs/CHECK_SEG_VALUE_LLANG

" Please note that database table types are mapped
" to ABAP structures.

types: iv_seg_value                   type c length 16.
types: begin of it_work_tab,
         key_offset                     type i,
         dd_offset                      type i,
         f_length                       type i,
       end of it_work_tab.
types: begin of et_out,
         rcode                          type i,
       end of et_out.

endinterface .
