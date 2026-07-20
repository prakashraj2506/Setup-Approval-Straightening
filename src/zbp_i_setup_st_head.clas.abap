CLASS zbp_i_setup_st_head DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zi_setup_st_head.

  TYPES: ltt_data_h TYPE TABLE OF zi_setup_st_head.
  TYPES: ltt_data_i TYPE TABLE OF zi_setup_st_ittem.

  PUBLIC SECTION.
    CLASS-DATA gv_ins_lot TYPE c LENGTH 12.

    CLASS-METHODS get_pdf_xml
      IMPORTING
        im_data_h  TYPE ltt_data_h
        im_data_i  TYPE ltt_data_i
      EXPORTING
        ex_base_64 TYPE string.

ENDCLASS.



CLASS ZBP_I_SETUP_ST_HEAD IMPLEMENTATION.


  METHOD get_pdf_xml.

    DATA: lwa_data   TYPE zi_setup_st_head,
          lv_subject TYPE string,
          lv_xml2    TYPE string.

    DATA: lv_unit1 TYPE string VALUE '0',
          lv_unit2 TYPE string VALUE '0',
          lv_unit4 TYPE string VALUE '0'.

    DATA(lv_time) = CONV t( xco_cp=>sy->time( xco_cp_time=>time_zone->user )->as( xco_cp_time=>format->abap )->value ).

    lwa_data = VALUE #( im_data_h[ 1 ] OPTIONAL ).

    " Plant → Unit checkbox mapping
    CASE lwa_data-Plant.
      WHEN 'MHU1'.
        lv_unit1 = '1'.
      WHEN 'MHU2'.
        lv_unit2 = '1'.
      WHEN 'MHU4'.
        lv_unit4 = '1'.
    ENDCASE.

    DATA(lv_xml1) = |<?xml version="1.0" encoding="UTF-8"?>| &&
                    |<PPSetup>| &&
                    |<Header>| &&
                    |<Date>| && lwa_data-zdate && |</Date>| &&
                    |<Shift>| && lwa_data-dateshift && |</Shift>| &&
                    |<Machine>| && lwa_data-machine && |</Machine>| &&
                    |<PartNo>| && lwa_data-Partno && |</PartNo>| &&
                    |<PartDescription>| && lwa_data-partdesc && |</PartDescription>| &&
                    |<SKSDrgNo>| && lwa_data-Drgno && |</SKSDrgNo>| &&
                    |<RawMaterialSpec>| && lwa_data-rawmatspec && |</RawMaterialSpec>| &&
                     |<ToolNo>| && lwa_data-ToolNo && |</ToolNo>| &&
                    |<LotNo>| && lwa_data-Batch && |</LotNo>| &&
                    |<Operator>| && lwa_data-operator && |</Operator>| &&
                    |<CurrentOperationNumber>| && lwa_data-currentoperationno && |</CurrentOperationNumber>| &&
                    |<OperationDetails>| && lwa_data-operationdetails && |</OperationDetails>| &&
                    |<Inspector>| && lwa_data-inspector && |</Inspector>| &&
                    |<PreviousOperation>| && lwa_data-previousoperation && |</PreviousOperation>| &&
                    |<NextOperation>| && lwa_data-nextoperation && |</NextOperation>| &&
                    |<UNIT_I>|  && lv_unit1 && |</UNIT_I>|  &&
                    |<UNIT_II>| && lv_unit2 && |</UNIT_II>| &&
                    |<UNIT_IV>| && lv_unit4 && |</UNIT_IV>| &&
                    |</Header>| &&
                    |<Items>|.

    DATA: lv_count TYPE i.

    DATA(lft_data) = im_data_i.
    SORT lft_data BY Itemno ASCENDING.

    LOOP AT lft_data INTO DATA(lwa_data_i).
      lv_count = lv_count + 1.
      lv_xml2 = lv_xml2 &&
                |<Item>| &&
                |<SrNo>| && lv_count && |</SrNo>| &&
                |<Parameter>| && lwa_data_i-Parameters && |</Parameter>| &&
                |<Specification>| && lwa_data_i-Specifications && |</Specification>| &&
                |<MMR>| && lwa_data_i-Mmr && |</MMR>| &&
                |<Observation1>| && lwa_data_i-obs1_t && |</Observation1>| &&
                |<Observation2>| && lwa_data_i-obs2_t && |</Observation2>| &&
                |<Observation3>| && lwa_data_i-obs3_t && |</Observation3>| &&
                |<Observation4>| && lwa_data_i-obs4_t && |</Observation4>| &&
                |<Observation5>| && lwa_data_i-obs5_t && |</Observation5>| &&
                |</Item>|.
    ENDLOOP.

    DATA(lv_xml) = lv_xml1 && lv_xml2 &&
                   |</Items>| &&
                   |<Footer>| &&
                   |<QAToProd>| && space && |</QAToProd>| &&
                   |<QATime>| && lwa_data-submittedtoprd_time && |</QATime>| &&
                   |<ProdToQA>| && space && |</ProdToQA>| &&
                   |<ProdTime>| && lwa_data-submittedtoqa_time && |</ProdTime>| &&
                   |<Remarks>| && lwa_data-remarks && |</Remarks>| &&
                   |<InspectBy>| && lwa_data-inspectby && |</InspectBy>| &&
                   |</Footer>| &&
                   |</PPSetup>|.

    REPLACE ALL OCCURRENCES OF '&'  IN lv_xml WITH '&#38;'.
    REPLACE ALL OCCURRENCES OF '²'  IN lv_xml WITH '&#178;'.
    REPLACE ALL OCCURRENCES OF '°'  IN lv_xml WITH '&#176;'.
    REPLACE ALL OCCURRENCES OF '–'  IN lv_xml WITH '-'.

    ex_base_64 = cl_web_http_utility=>encode_base64( unencoded = lv_xml ).

  ENDMETHOD.
ENDCLASS.
