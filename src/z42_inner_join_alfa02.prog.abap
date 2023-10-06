*&---------------------------------------------------------------------*
*& Report Z42_INNER_JOIN_ALFA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z42_INNER_JOIN_ALFA02.

  types: begin of data_colums,
         carrname  type zscarralfa02-carrname,
         fldate    type zsflightalfa02-fldate,
         price     type zsflightalfa02-price ,
         planetype type zsflightalfa02-planetype,
         producer  type zsaplanealfa02-producer,
    end of data_colums.

    data gt_zs type sorted table of data_colums with UNIQUE key  carrname
                                                                 fldate
                                                                 price
                                                                 planetype
                                                                 producer.


  select a~carrname b~fldate
         b~price b~planetype
         c~producer into corresponding fields of table gt_zs from (
         zscarralfa02 as a inner join zsflightalfa02 as b
                                   on a~carrid = b~carrid
         inner join zsaplanealfa02 as c
                                   on c~planetype = b~planetype ).

    IF sy-subrc eq 0.
       cl_demo_output=>display( gt_zs ).
    ENDIF.
