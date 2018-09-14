select h.vbillcode        单据号,
       m.code             物料编码,
       m.name             物料名称,
       st.name            仓库名称,
       sm.user_name       制单人,
       bt.billtypename    出库类型,
       dept.name          部门名称,
       b.cgeneralbid      表体主键,
       d.name             费用项目,
       d.pk_defdoc        费用项目主键
  from ic_generalout_b b
left join ic_generalout_h h on b.cgeneralhid = h.cgeneralhid
left join bd_material m on b.cmaterialoid = m.pk_material
left join bd_defdoc d on b.vbdef1 = d.pk_defdoc
left join bd_billtype bt on h.ctrantypeid = bt.pk_billtypeid
left join bd_stordoc st on h.cwarehouseid = st.pk_stordoc
left join sm_user sm on h.billmaker = sm.cuserid
left join org_dept dept on h.cdptid = dept.pk_dept
;

select d.name 项目名称, d.pk_defdoc 项目主键 from bd_defdoc d
left join bd_defdoclist l on d.pk_defdoclist = l.pk_defdoclist
where l.name = '费用项目辅助核算'
;
