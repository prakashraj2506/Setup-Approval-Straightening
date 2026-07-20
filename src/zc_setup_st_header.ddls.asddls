@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Setup Approval Header Consumption'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_SETUP_ST_HEADER
  provider contract transactional_query
  as projection on ZI_SETUP_ST_HEAD

{
  key Cuuid,
      Inspectionlot,
      Lotcreate,
      Startofinsp,
      Endofinsp,
      @Consumption.valueHelpDefinition: [{ entity :{  element: 'Plant' , name: 'I_PlantStdVH' } }]

      Plant,
      @Consumption.valueHelpDefinition: [{ entity :{  element: 'Product' , name: 'I_ProductText' } }]

      Material,
      Customer,
      Baseunit,
      @Consumption.valueHelpDefinition: [{ entity :{  element: 'ManufacturingOrder' , name: 'ZCDS_VH_05' } }]

      Productionorder,
      Inspectionlotobjecttext,
      @Consumption.valueHelpDefinition: [{ entity :{  element: 'Batch' , name: 'I_Batch' } }]

      Batch,
      Supplier,
      Manufacturer,
      Inspectionoperation,
      Inspection,
      Salesorder,
      Drgno,
      RmSpecification,
      Grade,
      Partno,
      Operationtext,
      Workcentertext,
      Operationconfirmation,
      Shift,
      Operatorname,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZCDS_VH_01',element: 'Opeartion' } }]

      Previousopt,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZCDS_VH_01',element: 'Opeartion' } }]

      Nextopt,
      Filename,
      @Semantics.largeObject:{
           mimeType: 'Mimetype',
           fileName: 'Filename',
           contentDispositionPreference: #INLINE
           }
      Attachments,
      Mimetype,
      Materialdescription,
      Customername,
      QtyChkd,
      InvNo,
      InvDate,
      CustDraw,
      SksDraw,
      Materiallongtxt,
      FilenameUl,
      AttachmentsUl,
      MimetypeUl,
      Formtype,

      refnum,
      partdesc,

      rawmatspec,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZD_OPERATOR_NAME', element: 'operatorNameText' } }]

      operator,
      currentoperationno,
      operationdetails,
      inspector,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZCDS_VH_01',element: 'Opeartion' } }]


      previousoperation,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZCDS_VH_01',element: 'Opeartion' } }]

      nextoperation,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZCDS_QM_DD_01' , element: 'Value' } }]

      dateshift,

      //  @Consumption.valueHelpDefinition: [{ entity :{  element: 'WorkCenterInternalID' , name: 'ZI_WorkCenter' } }]

      // machine,

      // CORRECT - maps to Work Center name
      @Consumption.valueHelpDefinition: [{
        entity: {
          name: 'I_WorkCenter',
          element: 'WorkCenter'   // <-- This gives you "CMBF-03"
        }
      }]
      machine,

      remarks,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZD_APPROVED_BY', element: 'operatorNameText' } }]

      inspectby,
      submittedtoprd,
      submittedtoqa,
      submittedtoprd_time,
      submittedtoqa_time,
      setupapprovalno,
      zdate,
      toolno,
      @Semantics.systemDateTime.createdAt: true
      CreatedOn,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      ChangedOn,
      @Semantics.user.lastChangedBy: true
      ChangedBy,
      LocalLastChangedOn,
      LocalLastChangedBy,
      _Item : redirected to composition child ZC_SETUP_ST_ITEM
}
