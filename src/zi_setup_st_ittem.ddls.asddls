@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Setup Approval Item Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SETUP_ST_ITTEM
  as select from zqm_st_setup_ap2
  association to parent ZI_SETUP_ST_HEAD as _HDR on $projection.Cuuid = _HDR.Cuuid
{
  key cuuid          as Cuuid,
  key itemno         as Itemno,
      parameters     as Parameters,
      specifications as Specifications,
      mmr            as Mmr,
      obs1           as Obs1,
      obs2           as Obs2,
      obs3           as Obs3,
      obs4           as Obs4,
      obs5           as Obs5,
      obs1_t,
      obs2_t,
      obs3_t,
      obs4_t,
      obs5_t,
      _HDR
}
