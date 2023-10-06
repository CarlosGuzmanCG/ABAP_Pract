interface ZIF_ZDPP_SEG_LANG_ALFA02 public.

" This interface pool has been generated.
" It contains the type definitions for
" database procedure proxy ZDPP_SEG_LANG_ALFA02
" representing db procedure _SYS_BIC.sap.erp.sappl.lo.sgt.L-Procs/CONCAT_SEG_LLANG

" Please note that database table types are mapped
" to ABAP structures.

types: begin of it_seg_key,
         mandt                          type c length 3,
         sgt_csgr                       type c length 4,
         sgt_appl                       type c length 1,
         sgt_cnrc                       type c length 3,
         atinn                          type c length 10,
         sgt_fnam                       type c length 10,
         sgt_rank                       type c length 3,
         sgt_foff                       type i,
         sgt_flen                       type i,
         sgt_inva                       type c length 30,
         sgt_reft                       type c length 30,
         sgt_reff                       type c length 30,
         sgt_reit                       type c length 30,
         sgt_reif                       type c length 30,
         sgt_bwef                       type c length 30,
         sgt_bwtmark                    type c length 1,
         sgt_chef                       type c length 1,
         sgt_eanf                       type c length 1,
         sgt_catv                       type c length 16,
       end of it_seg_key.
types: begin of et_relevance_value,
         seg_value                      type c length 16,
       end of et_relevance_value.

endinterface .
