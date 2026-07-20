@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Setup Approval Header Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SETUP_ST_HEAD
  as select from zqm_st_setup_app as a
  composition [1..*] of ZI_SETUP_ST_ITTEM as _Item
{
  key a.cuuid                   as Cuuid,
      a.inspectionlot           as Inspectionlot,
      a.lotcreate               as Lotcreate,
      a.startofinsp             as Startofinsp,
      a.endofinsp               as Endofinsp,
      a.plant                   as Plant,
      a.material                as Material,
      a.customer                as Customer,
      a.baseunit                as Baseunit,
      a.productionorder         as Productionorder,
      a.inspectionlotobjecttext as Inspectionlotobjecttext,
      a.batch                   as Batch,
      a.supplier                as Supplier,
      a.manufacturer            as Manufacturer,
      a.inspectionoperation     as Inspectionoperation,
      a.inspection              as Inspection,
      a.salesorder              as Salesorder,
      a.drgno                   as Drgno,
      a.rm_specification        as RmSpecification,
      a.grade                   as Grade,
      a.partno                  as Partno,
      a.operationtext           as Operationtext,
      a.workcentertext          as Workcentertext,
      a.operationconfirmation   as Operationconfirmation,
      a.shift                   as Shift,
      a.operatorname            as Operatorname,
      a.previousopt             as Previousopt,
      a.nextopt                 as Nextopt,
      a.filename                as Filename,
      a.attachments             as Attachments,
      a.mimetype                as Mimetype,
      a.materialdescription     as Materialdescription,
      a.customername            as Customername,
      a.qty_chkd                as QtyChkd,
      a.inv_no                  as InvNo,
      a.inv_date                as InvDate,
      a.cust_draw               as CustDraw,
      a.sks_draw                as SksDraw,
      a.materiallongtxt         as Materiallongtxt,
      a.filename_ul             as FilenameUl,
      a.attachments_ul          as AttachmentsUl,
      a.mimetype_ul             as MimetypeUl,
      a.formtype                as Formtype,
      @Semantics.systemDateTime.createdAt: true
      a.created_on              as CreatedOn,
      @Semantics.user.createdBy: true
      a.created_by              as CreatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      a.changed_on              as ChangedOn,
      @Semantics.user.lastChangedBy: true
      a.changed_by              as ChangedBy,
      a.local_last_changed_on   as LocalLastChangedOn,
      a.local_last_changed_by   as LocalLastChangedBy,

      a.refnum,
      a.partdesc,
      a.rawmatspec,
      a.operator,
      a.currentoperationno,
      a.operationdetails,
      a.inspector,
      a.previousoperation,
      a.nextoperation,
      a.dateshift,
      a.machine,
      a.remarks,
      a.inspectby,
      a.submittedtoprd,
      a.submittedtoqa,
      a.submittedtoprd_time,
      a.submittedtoqa_time,
      a.setupapprovalno,
      a.zdate,
      a.toolno,
      _Item
}
