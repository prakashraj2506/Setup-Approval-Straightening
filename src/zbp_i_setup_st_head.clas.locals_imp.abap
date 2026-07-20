"***********************************************************************
" Local Handler Class - Item
"***********************************************************************
CLASS lhc_zi_setup_st_ittem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_setup_st_ittem RESULT result.

ENDCLASS.

CLASS lhc_zi_setup_st_ittem IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_setup_st_head IN LOCAL MODE
         ENTITY zi_setup_st_head
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(gt_hd)
         ENTITY zi_setup_st_head BY \_Item
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(gt_it)
         FAILED DATA(gt_failed).

    result = VALUE #( FOR row IN gt_it (
      %tky = row-%tky

      %features-%field-Obs2 = COND #( WHEN row-Itemno = '00001'
                                      THEN if_abap_behv=>fc-f-read_only
                                      ELSE if_abap_behv=>fc-f-unrestricted )

      %features-%field-Obs2_t = COND #( WHEN row-Itemno = '00001'
                                        THEN if_abap_behv=>fc-f-read_only
                                        ELSE if_abap_behv=>fc-f-unrestricted )

      %features-%field-Obs3 = COND #( WHEN row-Itemno = '00001'
                                      THEN if_abap_behv=>fc-f-read_only
                                      ELSE if_abap_behv=>fc-f-unrestricted )

      %features-%field-obs3_t = COND #( WHEN row-Itemno = '00001'
                                        THEN if_abap_behv=>fc-f-read_only
                                        ELSE if_abap_behv=>fc-f-unrestricted )

      %features-%field-Obs4 = COND #( WHEN row-Itemno = '00001'
                                      THEN if_abap_behv=>fc-f-read_only
                                      ELSE if_abap_behv=>fc-f-unrestricted )

      %features-%field-obs4_t = COND #( WHEN row-Itemno = '00001'
                                        THEN if_abap_behv=>fc-f-read_only
                                        ELSE if_abap_behv=>fc-f-unrestricted )

      %features-%field-Obs5 = COND #( WHEN row-Itemno = '00001'
                                      THEN if_abap_behv=>fc-f-read_only
                                      ELSE if_abap_behv=>fc-f-unrestricted )

      %features-%field-Obs5_t = COND #( WHEN row-Itemno = '00001'
                                        THEN if_abap_behv=>fc-f-read_only
                                        ELSE if_abap_behv=>fc-f-unrestricted )
    ) ).

  ENDMETHOD.

ENDCLASS.


"***********************************************************************
" Local Saver Class
"***********************************************************************
CLASS lsc_zi_setup_st_head DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_setup_st_head IMPLEMENTATION.

  METHOD save_modified.

    IF create-zi_setup_st_head IS NOT INITIAL.

      DATA lfs_item TYPE zqm_st_setup_ap2.
      DATA lft_item TYPE TABLE OF zqm_st_setup_ap2.

      LOOP AT create-zi_setup_st_head ASSIGNING FIELD-SYMBOL(<lfs_head>).

        DATA(lv_itemno) = 1.

        APPEND VALUE #( cuuid          = <lfs_head>-cuuid
                        itemno         = lv_itemno
                        parameters     = 'Speed'
                        specifications = 'As Per Process Parameter Chart'
                        mmr            = 'Clock' ) TO lft_item.

        lv_itemno += 1.
        APPEND VALUE #( cuuid          = <lfs_head>-cuuid
                        itemno         = lv_itemno
                        parameters     = 'Pressure'
                        specifications = 'Till TRD gets as per Drg.'
                        mmr            = 'Micrometer' ) TO lft_item.

        lv_itemno += 1.
        APPEND VALUE #( cuuid          = <lfs_head>-cuuid
                        itemno         = lv_itemno
                        parameters     = 'Pusher alignment'
                        specifications = 'Gap between pusher plate & moving ram/die – 1 mm max approx.'
                        mmr            = 'Feeler Gauge' ) TO lft_item.

        lv_itemno += 1.
        APPEND VALUE #( cuuid          = <lfs_head>-cuuid
                        itemno         = lv_itemno
                        parameters     = 'Pusher angle'
                        specifications = '30° approx'
                        mmr            = 'Angle Protractor' ) TO lft_item.

        lv_itemno += 1.
        APPEND VALUE #( cuuid          = <lfs_head>-cuuid
                        itemno         = lv_itemno
                        parameters     = 'Oil flow on straightening die'
                        specifications = 'Continue'
                        mmr            = 'Visual' ) TO lft_item.

        lv_itemno += 1.
        APPEND VALUE #( cuuid          = <lfs_head>-cuuid
                        itemno         = lv_itemno
                        parameters     = 'Track line gap'
                        specifications = '0.2 – 0.5 mm excess than shank dia'
                        mmr            = 'Vernier' ) TO lft_item.

        lv_itemno += 1.
        APPEND VALUE #( cuuid          = <lfs_head>-cuuid
                        itemno         = lv_itemno
                        parameters     = 'Dog plate pressure'
                        specifications = 'Less than 1 mm of blank dia'
                        mmr            = 'Vernier' ) TO lft_item.

      ENDLOOP.

      MODIFY zqm_st_setup_ap2 FROM TABLE @lft_item.

    ENDIF.

    IF update-zi_setup_st_ittem IS NOT INITIAL.
      LOOP AT update-zi_setup_st_ittem ASSIGNING FIELD-SYMBOL(<lfs_item>).
        IF <lfs_item>-Itemno = '20'.
          DATA(lv_prod_sub) = abap_true.
          UPDATE zqm_st_setup_app
            SET submittedtoprd_time = @sy-uzeit
            WHERE cuuid = @<lfs_item>-Cuuid.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

ENDCLASS.


"***********************************************************************
" Local Handler Class - Header
"***********************************************************************
CLASS lhc_zi_setup_st_head DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    " Class-level flag to prevent recursive determination calls
    CLASS-DATA: gv_determination_running TYPE abap_bool.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_setup_st_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_setup_st_head RESULT result.

    METHODS getItem FOR MODIFY
      IMPORTING keys FOR ACTION zi_setup_st_head~getItem.

    METHODS getpdf FOR MODIFY
      IMPORTING keys FOR ACTION zi_setup_st_head~getpdf RESULT result.

    METHODS updateHeaderDetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_setup_st_head~updateHeaderDetails.

    METHODS createSetupNo FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_setup_st_head~createSetupNo.

    METHODS fetchHeaderFromBatch FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_setup_st_head~fetchHeaderFromBatch.

    METHODS fetchHeaderFromProdOrder FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_setup_st_head~fetchHeaderFromProdOrder.

    METHODS verifyGrade FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_setup_st_head~verifyGrade.

ENDCLASS.

CLASS lhc_zi_setup_st_head IMPLEMENTATION.

  "---------------------------------------------------------------
  " Authorization
  "---------------------------------------------------------------
  METHOD get_instance_authorizations.
  ENDMETHOD.

  "---------------------------------------------------------------
  " Instance Features
  "---------------------------------------------------------------
  METHOD get_instance_features.

    READ ENTITY IN LOCAL MODE zi_setup_st_head
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header).

    result = VALUE #( FOR ls_header IN lt_header (
      %tky = ls_header-%tky

      %features-%field-Batch = COND #(
        WHEN ls_header-Batch IS NOT INITIAL
        THEN if_abap_behv=>fc-f-read_only
        ELSE if_abap_behv=>fc-f-unrestricted )

      %features-%field-Productionorder = COND #(
        WHEN ls_header-Productionorder IS NOT INITIAL
        THEN if_abap_behv=>fc-f-read_only
        ELSE if_abap_behv=>fc-f-unrestricted )
    ) ).

  ENDMETHOD.

  "---------------------------------------------------------------
  " Factory Action: getItem
  "---------------------------------------------------------------
  METHOD getItem.

    MODIFY ENTITY IN LOCAL MODE zi_setup_st_head
      CREATE BY \_Item
      AUTO FILL CID
      FIELDS ( Cuuid Itemno Parameters Specifications )
      WITH VALUE #(
        FOR key IN keys
          ( %is_draft = if_abap_behv=>mk-on
            %key      = key-%key
            %cid_ref  = key-%cid_ref
            %target   = VALUE #(
              ( %is_draft      = if_abap_behv=>mk-on
                %cid           = 'CID_10'
                %key-Cuuid     = key-%key-Cuuid
                Itemno         = '10'
                Parameters     = 'Parameters'
                Specifications = 'Specifications' )
            )
          )
      )
      REPORTED reported
      FAILED failed
      MAPPED mapped.

  ENDMETHOD.

  "---------------------------------------------------------------
  " Action: getpdf
  "---------------------------------------------------------------
  METHOD getpdf.

    DATA : lv_base64  TYPE string,
           lv_token   TYPE string,
           lv_message TYPE string.
    DATA lft_header TYPE TABLE OF zi_setup_st_head.
    DATA lft_item   TYPE TABLE OF zi_setup_st_ittem.

    READ ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lit_header_data)
      FAILED DATA(lit_failed).

    IF lit_header_data IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lfs_header_run) = VALUE #( lit_header_data[ 1 ] ).

    SELECT * FROM zqm_st_setup_ap2
      WHERE cuuid = @lfs_header_run-Cuuid
      INTO TABLE @DATA(lft_item_db).

    MOVE-CORRESPONDING lit_header_data TO lft_header.
    MOVE-CORRESPONDING lft_item_db TO lft_item.

    zcl_btp_adobe_form=>get_ouath_token(
      EXPORTING
        im_oauth_url    = 'ADS_OAUTH_URL'
        im_clientid     = 'ADS_CLIENTID'
        im_clientsecret = 'ADS_CLIENTSECRET'
      IMPORTING
        ex_token        = lv_token
        ex_message      = lv_message ).

    zbp_i_setup_st_head=>get_pdf_xml(
      EXPORTING
        im_data_h  = lft_header
        im_data_i  = lft_item
      IMPORTING
        ex_base_64 = lv_base64 ).

    DATA(lv_form_name) = |ZSETUP_APPROVAL/Setup_App_Straight_Template|.

    zcl_btp_adobe_form=>get_pdf_api(
      EXPORTING
        im_url           = 'ADS_URL'
        im_url_path      = '/v1/adsRender/pdf?TraceLevel=2&templateSource=storageName'
        im_clientid      = 'ADS_CLIENTID'
        im_clientsecret  = 'ADS_CLIENTSECRET'
        im_token         = lv_token
        im_base64_encode = lv_base64
        im_xdp_template  = lv_form_name
      IMPORTING
        ex_base64_decode = DATA(lv_base64_decode)
        ex_message       = lv_message ).

    MODIFY ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      UPDATE FIELDS ( Attachments filename mimetype )
      WITH VALUE #( FOR lwa_header IN lit_header_data (
        %tky        = lwa_header-%tky
        Attachments = lv_base64_decode
        filename    = 'Form'
        mimetype    = 'application/pdf' ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lit_updatedheader).

    result = VALUE #( FOR lwa_upd IN lit_updatedheader (
      %tky   = lwa_upd-%tky
      %param = lwa_upd ) ).

  ENDMETHOD.

  "---------------------------------------------------------------
  " Determination on SAVE: createSetupNo
  "---------------------------------------------------------------
  METHOD createSetupNo.

    READ ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat_data).

    IF lt_mat_data IS NOT INITIAL.

      DATA(ls_mat_data) = VALUE #( lt_mat_data[ 1 ] OPTIONAL ).
      DATA lv_setup TYPE c LENGTH 20.

      SELECT COUNT( cuuid ) FROM zqm_st_setup_app
        INTO @DATA(lv_setup_old).

      lv_setup = lv_setup_old + 1.
      SHIFT lv_setup LEFT DELETING LEADING space.

      MODIFY ENTITIES OF zi_setup_st_head IN LOCAL MODE
        ENTITY zi_setup_st_head
        UPDATE FIELDS ( setupapprovalno zdate submittedtoqa_time )
        WITH VALUE #( (
          %is_draft                    = ls_mat_data-%is_draft
          Cuuid                        = VALUE #( keys[ 1 ]-Cuuid OPTIONAL )
          setupapprovalno              = lv_setup
          zdate                        = sy-datum
          submittedtoqa_time           = sy-uzeit
          %control-setupapprovalno     = if_abap_behv=>mk-on
          %control-zdate               = if_abap_behv=>mk-on
          %control-submittedtoqa_time  = if_abap_behv=>mk-on
        ) )
        FAILED DATA(lt_fail)
        REPORTED DATA(lt_reported)
        MAPPED DATA(lt_mapped).

    ENDIF.

  ENDMETHOD.

  "---------------------------------------------------------------
  " Determination on MODIFY: fetchHeaderFromProdOrder
  "
  " Triggered when user enters Production Order.
  " Uses PARENT production order via zc_prod_log_hd.
  " Same pattern as ZR_SETUP_APP_HEAD updateHeaderDetails.
  "---------------------------------------------------------------
  METHOD fetchHeaderFromProdOrder.

    " === GUARD: Prevent recursive calls ===
    IF gv_determination_running = abap_true.
      RETURN.
    ENDIF.

    READ ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat_data).

    IF lt_mat_data IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_mat_data) = VALUE #( lt_mat_data[ 1 ] OPTIONAL ).

    " === GUARD: Skip if Production Order is empty ===
    IF ls_mat_data-Productionorder IS INITIAL.
      RETURN.
    ENDIF.

    " === GUARD: Skip if Material is already populated (determination already ran) ===
    IF ls_mat_data-Material IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Set flag to prevent recursive calls
    gv_determination_running = abap_true.

    SELECT SINGLE ref_productionorder
      FROM zc_prod_log_hd WITH PRIVILEGED ACCESS
      WHERE productionorder = @ls_mat_data-Productionorder
      INTO @DATA(lv_par_prod).

    SELECT SINGLE YY1_PP_Product_Desc_ORD, productionplant, billofoperationsmaterial
      FROM I_ProductionOrder
      WHERE ProductionOrder = @lv_par_prod
      INTO @DATA(wa_pod_ord).

      SELECT SINGLE productionplant
  FROM I_ProductionOrder
  WHERE ProductionOrder = @ls_mat_data-Productionorder
  INTO @DATA(lv_plant).

      """"""""""
        SELECT SINGLE billofoperationsmaterial
        FROM I_ProductionOrder
        WHERE ProductionOrder = @ls_mat_data-Productionorder
        INTO @DATA(lv_material).
"""""""""""""""""""""""""""""""


 select single productionorder
        from zc_prod_log_hd with priviLEGED ACCESS
        where ref_productionorder = @lv_par_prod
        and operationtext = 'FORGING'
        into @data(lv_rm_spec_prod).

        seleCT single material
        from i_productionordercomponent with privileged access
        where productionorder = @lv_rm_spec_prod
        into @data(lv_rm_spec_mat).

    SELECT SINGLE Material
      FROM I_productionordercomponent
      WHERE ProductionOrder = @lv_par_prod
      INTO @DATA(lv_raw_mat).

    SELECT a~ClfnObjectID,
           a~CharcInternalID,
           a~CharcValue,
           b~Characteristic
      FROM i_clfnobjectcharcvalforkeydate( p_keydate = @sy-datum ) AS a
      INNER JOIN I_ClfnCharacteristicForKeyDate( p_keydate = @sy-datum ) AS b
        ON b~CharcInternalID = a~CharcInternalID
      WHERE ClfnObjectID = @wa_pod_ord-BillOfOperationsMaterial
      INTO TABLE @DATA(lft_char_value).

    DATA(lv_drgno) = VALUE #( lft_char_value[ Characteristic = 'DRAWING_NO' ]-CharcValue OPTIONAL ).
    DATA(lv_Grade) = VALUE #( lft_char_value[ Characteristic = 'ITEM_GRADE' ]-CharcValue OPTIONAL ).
    DATA(lv_RmSpecification) = VALUE #( lft_char_value[ Characteristic = '0000000823' ]-CharcValue OPTIONAL ).
    DATA(lv_PartNo) = VALUE #( lft_char_value[ Characteristic = 'ITEM_CODE' ]-CharcValue OPTIONAL ).

    DATA lv_text TYPE string.
    IF wa_pod_ord-BillOfOperationsMaterial IS NOT INITIAL.
      zpp_cl_mat_longtext=>get_data(
        EXPORTING
          im_value    = wa_pod_ord-BillOfOperationsMaterial
        IMPORTING
          ex_longtext = lv_text ).
    ENDIF.

    DATA: lv_production     TYPE n LENGTH 12,
          lv_nextproduction TYPE n LENGTH 12,
          lv_preproduction  TYPE n LENGTH 12,
          lv_nextprod       TYPE p DECIMALS 0,
          lv_preprod        TYPE p DECIMALS 0.

    DATA lv_optext      TYPE string.
    DATA lv_operno      TYPE string.
    DATA lv_next_optext TYPE string.
    DATA lv_pre_optext  TYPE string.

    IF ls_mat_data-Productionorder IS NOT INITIAL.

      lv_production = ls_mat_data-Productionorder.

      SELECT SINGLE operationtext
        FROM zr_prod_log_hd WITH PRIVILEGED ACCESS
        WHERE Productionorder = @lv_production
        INTO @lv_optext.

      IF lv_optext IS NOT INITIAL.
        SELECT SINGLE value_low
          FROM zoperation_no_vh WITH PRIVILEGED ACCESS
          WHERE language = 'E'
            AND text = @lv_optext
          INTO @lv_operno.
      ENDIF.

      SELECT SINGLE ref_productionorder
        FROM zr_prod_log_hd WITH PRIVILEGED ACCESS
        WHERE Productionorder = @lv_production
        INTO @DATA(lv_par_ord).

      lv_nextprod       = lv_production + 1.
      lv_preprod        = lv_production - 1.
      lv_nextproduction = lv_nextprod.
      lv_preproduction  = lv_preprod.

      IF lv_nextproduction IS NOT INITIAL.
        SELECT SINGLE operationtext
          FROM zr_prod_log_hd WITH PRIVILEGED ACCESS
          WHERE Productionorder = @lv_nextproduction
            AND ref_productionorder = @lv_par_ord
          INTO @lv_next_optext.

        IF lv_preproduction IS NOT INITIAL.
          SELECT SINGLE operationtext
            FROM zr_prod_log_hd WITH PRIVILEGED ACCESS
            WHERE Productionorder = @lv_preproduction
              AND ref_productionorder = @lv_par_ord
            INTO @lv_pre_optext.
        ENDIF.
      ENDIF.
    ENDIF.

    MODIFY ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      UPDATE FIELDS (
        zdate
        Drgno
        Grade
        Material
        plant
       " RmSpecification
        PartNo
        partdesc
        rawmatspec
        operationdetails
        nextoperation
        previousoperation
        currentoperationno
      )
      WITH VALUE #( (
        %is_draft                    = ls_mat_data-%is_draft
        Cuuid                        = VALUE #( keys[ 1 ]-Cuuid OPTIONAL )
        zdate                        = sy-datum
        Material                     = lv_material                  "wa_pod_ord-BillOfOperationsMaterial
        Drgno                        = lv_drgno
        Grade                        = lv_Grade
      "  RmSpecification              = lv_RmSpecification
        PartNo                       = lv_PartNo
        partdesc                     = lv_text
        plant                        = lv_plant          "wa_pod_ord-ProductionPlant
        rawmatspec                   =  lv_rm_spec_mat                  "lv_raw_mat
        nextoperation                = lv_next_optext
        previousoperation            = lv_pre_optext
        currentoperationno           = lv_operno
        operationdetails             = lv_optext
        %control-zdate               = if_abap_behv=>mk-on
        %control-Drgno               = if_abap_behv=>mk-on
        %control-Grade               = if_abap_behv=>mk-on
        %control-Material            = if_abap_behv=>mk-on
        %control-plant               = if_abap_behv=>mk-on
        %control-RmSpecification     = if_abap_behv=>mk-on
        %control-PartNo              = if_abap_behv=>mk-on
        %control-partdesc            = if_abap_behv=>mk-on
        %control-rawmatspec          = if_abap_behv=>mk-on
        %control-operationdetails    = if_abap_behv=>mk-on
        %control-nextoperation       = if_abap_behv=>mk-on
        %control-previousoperation   = if_abap_behv=>mk-on
        %control-currentoperationno  = if_abap_behv=>mk-on
      ) )
      FAILED DATA(lt_fail)
      REPORTED DATA(lt_reported)
      MAPPED DATA(lt_mapped).

    " Reset flag
    gv_determination_running = abap_false.

  ENDMETHOD.

  "---------------------------------------------------------------
  " Determination on MODIFY: fetchHeaderFromBatch
  "
  " Triggered when user selects Batch.
  " USES PARENT production order via zc_prod_log_hd.
  "---------------------------------------------------------------
  METHOD fetchHeaderFromBatch.

    " === GUARD: Prevent recursive calls ===
    IF gv_determination_running = abap_true.
      RETURN.
    ENDIF.

    READ ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data).

    IF lt_data IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_data) = VALUE #( lt_data[ 1 ] OPTIONAL ).

    " === GUARD: Skip if Batch is empty ===
    IF ls_data-Batch IS INITIAL.
      RETURN.
    ENDIF.

    " === GUARD: Skip if Material is already populated (determination already ran) ===
    IF ls_data-Material IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Set flag to prevent recursive calls
    gv_determination_running = abap_true.

    "---------------------------------------------------------------
    " 1. Resolve PARENT production order via zc_prod_log_hd
    "---------------------------------------------------------------
    SELECT SINGLE ref_productionorder
      FROM zc_prod_log_hd WITH PRIVILEGED ACCESS
      WHERE productionorder = @ls_data-Productionorder
      INTO @DATA(lv_par_prod).

    "---------------------------------------------------------------
    " 2. Fetch Plant and Material from PARENT Production Order
    "---------------------------------------------------------------
    SELECT SINGLE YY1_PP_Product_Desc_ORD, productionplant, billofoperationsmaterial
      FROM I_ProductionOrder
      WHERE ProductionOrder = @lv_par_prod
      INTO @DATA(wa_pod_ord).

    "---------------------------------------------------------------
    " 3. Fetch Material Description from PARENT material
    "---------------------------------------------------------------
    DATA lv_mat_desc TYPE c LENGTH 256.

    IF wa_pod_ord-BillOfOperationsMaterial IS NOT INITIAL.
      SELECT SINGLE ProductDescription
        FROM I_ProductDescription
        WHERE Product  = @wa_pod_ord-BillOfOperationsMaterial
          AND Language = @sy-langu
        INTO @lv_mat_desc.
    ENDIF.


 SELECT SINGLE billofoperationsmaterial
        FROM I_ProductionOrder
        WHERE ProductionOrder = @ls_data-Productionorder
        INTO @DATA(lv_material).


 select single productionorder
        from zc_prod_log_hd with priviLEGED ACCESS
        where ref_productionorder = @lv_par_prod
        and operationtext = 'FORGING'
        into @data(lv_rm_spec_prod).

        seleCT single material
        from i_productionordercomponent with privileged access
        where productionorder = @lv_rm_spec_prod
        into @data(lv_rm_spec_mat).



    "---------------------------------------------------------------
    " 4. Fetch Raw Material from PARENT Production Order Component
    "---------------------------------------------------------------
    SELECT SINGLE Material
      FROM I_productionordercomponent
      WHERE ProductionOrder = @ls_data-Productionorder
      INTO @DATA(lv_raw_mat).

    "---------------------------------------------------------------
    " 5. Fetch Classification Characteristics from PARENT material
    "---------------------------------------------------------------
    SELECT a~ClfnObjectID,
           a~CharcInternalID,
           a~CharcValue,
           b~Characteristic
      FROM i_clfnobjectcharcvalforkeydate( p_keydate = @sy-datum ) AS a
      INNER JOIN I_ClfnCharacteristicForKeyDate( p_keydate = @sy-datum ) AS b
        ON b~CharcInternalID = a~CharcInternalID
      WHERE ClfnObjectID = @wa_pod_ord-BillOfOperationsMaterial
      INTO TABLE @DATA(lft_char_value).

    DATA(lv_drgno) = VALUE #( lft_char_value[ Characteristic = 'DRAWING_NO' ]-CharcValue OPTIONAL ).
    DATA(lv_Grade) = VALUE #( lft_char_value[ Characteristic = 'ITEM_GRADE' ]-CharcValue OPTIONAL ).
    DATA(lv_RmSpecification) = VALUE #( lft_char_value[ Characteristic = '0000000823' ]-CharcValue OPTIONAL ).
    DATA(lv_PartNo) = VALUE #( lft_char_value[ Characteristic = 'ITEM_CODE' ]-CharcValue OPTIONAL ).

    "---------------------------------------------------------------
    " 6. Fetch Material Long Text from PARENT material
    "---------------------------------------------------------------
    DATA lv_text TYPE string.

    IF wa_pod_ord-BillOfOperationsMaterial IS NOT INITIAL.
      zpp_cl_mat_longtext=>get_data(
        EXPORTING
          im_value    = wa_pod_ord-BillOfOperationsMaterial
        IMPORTING
          ex_longtext = lv_text ).
    ENDIF.

    "---------------------------------------------------------------
    " 7. Operation Details: current, next, previous
    "---------------------------------------------------------------
    DATA: lv_production     TYPE n LENGTH 12,
          lv_nextproduction TYPE n LENGTH 12,
          lv_preproduction  TYPE n LENGTH 12,
          lv_nextprod       TYPE p DECIMALS 0,
          lv_preprod        TYPE p DECIMALS 0.

    DATA lv_optext      TYPE string.
    DATA lv_operno      TYPE string.
    DATA lv_next_optext TYPE string.
    DATA lv_pre_optext  TYPE string.

    IF ls_data-Productionorder IS NOT INITIAL.

      lv_production = ls_data-Productionorder.

      SELECT SINGLE operationtext
        FROM zr_prod_log_hd WITH PRIVILEGED ACCESS
        WHERE Productionorder = @lv_production
        INTO @lv_optext.

      IF lv_optext IS NOT INITIAL.
        SELECT SINGLE value_low
          FROM zoperation_no_vh WITH PRIVILEGED ACCESS
          WHERE language = 'E'
            AND text = @lv_optext
          INTO @lv_operno.
      ENDIF.

      SELECT SINGLE ref_productionorder
        FROM zr_prod_log_hd WITH PRIVILEGED ACCESS
        WHERE Productionorder = @lv_production
        INTO @DATA(lv_par_ord).

      lv_nextprod       = lv_production + 1.
      lv_preprod        = lv_production - 1.
      lv_nextproduction = lv_nextprod.
      lv_preproduction  = lv_preprod.

      IF lv_nextproduction IS NOT INITIAL.
        SELECT SINGLE operationtext
          FROM zr_prod_log_hd WITH PRIVILEGED ACCESS
          WHERE Productionorder = @lv_nextproduction
            AND ref_productionorder = @lv_par_ord
          INTO @lv_next_optext.

        IF lv_preproduction IS NOT INITIAL.
          SELECT SINGLE operationtext
            FROM zr_prod_log_hd WITH PRIVILEGED ACCESS
            WHERE Productionorder = @lv_preproduction
              AND ref_productionorder = @lv_par_ord
            INTO @lv_pre_optext.
        ENDIF.
      ENDIF.
    ENDIF.

    "---------------------------------------------------------------
    " 8. Update header entity with all fetched data from PARENT
    "---------------------------------------------------------------
    MODIFY ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      UPDATE FIELDS (
        Plant
        Material
        Materialdescription
        Materiallongtxt
        rawmatspec
        Drgno
        Grade
    "    RmSpecification
        Partno
        partdesc
        operationdetails
        nextoperation
        previousoperation
        currentoperationno
      )
      WITH VALUE #( (
        %is_draft                      = ls_data-%is_draft
        Cuuid                          = VALUE #( keys[ 1 ]-Cuuid OPTIONAL )
        Plant                          = wa_pod_ord-ProductionPlant
        Material                       = lv_material
        Materialdescription            = lv_mat_desc
        Materiallongtxt                = lv_mat_desc
        rawmatspec                     = lv_rm_spec_mat            "lv_raw_mat
        Drgno                          = lv_drgno
        Grade                          = lv_grade
      "  RmSpecification                = lv_RmSpecification
        Partno                         = lv_partno
        partdesc                       = lv_text
        nextoperation                  = lv_next_optext
        previousoperation              = lv_pre_optext
        currentoperationno             = lv_operno
        operationdetails               = lv_optext
        %control-Plant                 = if_abap_behv=>mk-on
        %control-Material              = if_abap_behv=>mk-on
        %control-Materialdescription   = if_abap_behv=>mk-on
        %control-Materiallongtxt       = if_abap_behv=>mk-on
        %control-rawmatspec            = if_abap_behv=>mk-on
        %control-Drgno                 = if_abap_behv=>mk-on
        %control-Grade                 = if_abap_behv=>mk-on
        %control-RmSpecification       = if_abap_behv=>mk-on
        %control-Partno                = if_abap_behv=>mk-on
        %control-partdesc              = if_abap_behv=>mk-on
        %control-operationdetails      = if_abap_behv=>mk-on
        %control-nextoperation         = if_abap_behv=>mk-on
        %control-previousoperation     = if_abap_behv=>mk-on
        %control-currentoperationno    = if_abap_behv=>mk-on
      ) )
      FAILED DATA(lt_fail)
      REPORTED DATA(lt_reported)
      MAPPED DATA(lt_mapped).

    " Reset flag
    gv_determination_running = abap_false.

  ENDMETHOD.

  "---------------------------------------------------------------
  " Determination on MODIFY: updateHeaderDetails
  " Triggered when Material field changes.
  " Uses PARENT production order via zc_prod_log_hd.
  "---------------------------------------------------------------
  METHOD updateHeaderDetails.

    " === GUARD: Prevent recursive calls ===
    IF gv_determination_running = abap_true.
      RETURN.
    ENDIF.

    READ ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat_data).

    IF lt_mat_data IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_mat_data) = VALUE #( lt_mat_data[ 1 ] OPTIONAL ).

    " === GUARD: Skip if Production Order is empty ===
    IF ls_mat_data-Productionorder IS INITIAL.
      RETURN.
    ENDIF.

    " === GUARD: Skip if Drgno is already populated (indicates this already ran) ===
    IF ls_mat_data-Drgno IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Set flag to prevent recursive calls
    gv_determination_running = abap_true.

    SELECT SINGLE ref_productionorder
      FROM zc_prod_log_hd WITH PRIVILEGED ACCESS
      WHERE productionorder = @ls_mat_data-Productionorder
      INTO @DATA(lv_par_prod).

    SELECT SINGLE YY1_PP_Product_Desc_ORD, productionplant, billofoperationsmaterial
      FROM I_ProductionOrder
      WHERE ProductionOrder = @lv_par_prod
      INTO @DATA(wa_pod_ord).

    SELECT SINGLE billofoperationsmaterial
      FROM I_ProductionOrder
      WHERE ProductionOrder = @ls_mat_data-Productionorder
      INTO @DATA(lv_material).

    SELECT SINGLE productionorder
      FROM zc_prod_log_hd WITH PRIVILEGED ACCESS
      WHERE ref_productionorder = @lv_par_prod
        AND operationtext = 'FORGING'
      INTO @DATA(lv_rm_spec_prod).

    SELECT SINGLE material
      FROM i_productionordercomponent WITH PRIVILEGED ACCESS
      WHERE productionorder = @lv_rm_spec_prod
      INTO @DATA(lv_rm_spec_mat).

    SELECT SINGLE Material
      FROM I_productionordercomponent
      WHERE ProductionOrder = @ls_mat_data-Productionorder
      INTO @DATA(lv_raw_mat).

    SELECT a~ClfnObjectID,
           a~CharcInternalID,
           a~CharcValue,
           b~Characteristic
      FROM i_clfnobjectcharcvalforkeydate( p_keydate = @sy-datum ) AS a
      INNER JOIN I_ClfnCharacteristicForKeyDate( p_keydate = @sy-datum ) AS b
        ON b~CharcInternalID = a~CharcInternalID
      WHERE ClfnObjectID = @wa_pod_ord-BillOfOperationsMaterial
      INTO TABLE @DATA(lft_char_value).

    DATA(lv_drgno) = VALUE #( lft_char_value[ Characteristic = 'DRAWING_NO' ]-CharcValue OPTIONAL ).
    DATA(lv_Grade) = VALUE #( lft_char_value[ Characteristic = 'ITEM_GRADE' ]-CharcValue OPTIONAL ).
    DATA(lv_RmSpecification) = VALUE #( lft_char_value[ Characteristic = '0000000823' ]-CharcValue OPTIONAL ).
    DATA(lv_PartNo) = VALUE #( lft_char_value[ Characteristic = 'ITEM_CODE' ]-CharcValue OPTIONAL ).

    DATA lv_text TYPE string.
    IF wa_pod_ord-BillOfOperationsMaterial IS NOT INITIAL.
      zpp_cl_mat_longtext=>get_data(
        EXPORTING
          im_value    = wa_pod_ord-BillOfOperationsMaterial
        IMPORTING
          ex_longtext = lv_text ).
    ENDIF.

    " NOTE: Removed 'Material' from UPDATE FIELDS to prevent triggering this determination again
    MODIFY ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      UPDATE FIELDS (
        zdate
        Drgno
        Grade
        Material
        "RmSpecification
        PartNo
        partdesc
        rawmatspec
      )
      WITH VALUE #( (
        %is_draft                = ls_mat_data-%is_draft
        Cuuid                    = VALUE #( keys[ 1 ]-Cuuid OPTIONAL )
        zdate                    = sy-datum
        Material                 = lv_material
        Drgno                    = lv_drgno
        Grade                    = lv_Grade
      "  RmSpecification          = lv_rm_spec_mat "lv_RmSpecification
        PartNo                   = lv_PartNo
        partdesc                 = lv_text
        rawmatspec               = lv_rm_spec_mat
        %control-zdate           = if_abap_behv=>mk-on
        %control-Drgno           = if_abap_behv=>mk-on
        %control-Grade           = if_abap_behv=>mk-on
        %control-RmSpecification = if_abap_behv=>mk-on
        %control-PartNo          = if_abap_behv=>mk-on
        %control-partdesc        = if_abap_behv=>mk-on
        %control-rawmatspec      = if_abap_behv=>mk-on
      ) )
      FAILED DATA(lt_fail)
      REPORTED DATA(lt_reported)
      MAPPED DATA(lt_mapped).

    " Reset flag
    gv_determination_running = abap_false.

  ENDMETHOD.

  "---------------------------------------------------------------
  " Determination on MODIFY: verifyGrade
  "---------------------------------------------------------------
  METHOD verifyGrade.

    " === GUARD: Prevent recursive calls ===
    IF gv_determination_running = abap_true.
      RETURN.
    ENDIF.

    READ ENTITIES OF zi_setup_st_head IN LOCAL MODE
      ENTITY zi_setup_st_head
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mat_data).

    IF lt_mat_data IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_mat_data) = VALUE #( lt_mat_data[ 1 ] OPTIONAL ).

    " === GUARD: Skip if Material is empty ===
    IF ls_mat_data-Material IS INITIAL.
      RETURN.
    ENDIF.

    SELECT a~ClfnObjectID,
           a~CharcInternalID,
           a~CharcValue,
           b~Characteristic
      FROM i_clfnobjectcharcvalforkeydate( p_keydate = @sy-datum ) AS a
      INNER JOIN I_ClfnCharacteristicForKeyDate( p_keydate = @sy-datum ) AS b
        ON b~CharcInternalID = a~CharcInternalID
      WHERE ClfnObjectID = @ls_mat_data-Material
      INTO TABLE @DATA(lft_char_value).

    DATA(lv_Grade) = VALUE #( lft_char_value[ Characteristic = 'ITEM_GRADE' ]-CharcValue OPTIONAL ).

    IF ls_mat_data-Grade IS NOT INITIAL AND ls_mat_data-Grade <> lv_grade.
      APPEND VALUE #(
        %tky = ls_mat_data-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Grade value does not match to Material Master' )
      ) TO reported-zi_setup_st_head.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
