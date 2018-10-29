select agi.dr,agb.billno,vf.busidate,vf.billclass ,agi.money_cr as 收款金额 ,
ort.name as 部门,
bp.name as 业务员,
bc.code as 客户编码,
bc.name as 客户名称,
bm.code as 产品编码,
bm.name as 产品名称,
isb.vbatchcode as 产品批次号,
ssb.nnum as 销售数量,
agi.local_notax_cr as 无税金额 ,
to_date(substr(agb.billdate,1,10),'yyyy-mm-dd')-to_date(substr(isb.dbizdate,1,10),'yyyy-mm-dd') as 收款时长,
bich.paymentday as 客户账期,
--收款单的时间减去客户账期的时间
(to_date(substr(agb.billdate,1,10),'yyyy-mm-dd')-to_date(substr(isb.dbizdate,1,10),'yyyy-mm-dd')-bich.paymentday) as 超期天数,
--当收款时长小于客户账期并且大于0时，收款利息按照算法--收款金额 *时间*利率/365
case when to_date(substr(agb.billdate,1,10),'yyyy-mm-dd')-to_date(substr(isb.dbizdate,1,10),'yyyy-mm-dd')<=bich.paymentday 
  and to_date(substr(agb.billdate,1,10),'yyyy-mm-dd')-to_date(substr(isb.dbizdate,1,10),'yyyy-mm-dd')>0  then 
 (agi.money_cr * (to_date(substr(agb.billdate,1,10),'yyyy-mm-dd')-to_date(substr(isb.dbizdate,1,10),'yyyy-mm-dd'))* 0.083 /365 ) 
--当收款时长大于客户账期时，收款利息按照算法--收款金额 *时间*利率/365*2
 when to_date(substr(agb.billdate,1,10),'yyyy-mm-dd')-to_date(substr(isb.dbizdate,1,10),'yyyy-mm-dd')>bich.paymentday then 
  (agi.money_cr * (to_date(substr(agb.billdate,1,10),'yyyy-mm-dd')-to_date(substr(isb.dbizdate,1,10),'yyyy-mm-dd'))* 0.083 /365*2 ) 
 else 0 end
,ssb.vbdef2 as 指导价
from ar_gatheritem agi     --收款单行
inner join ar_gatherbill agb on agi.pk_gatherbill =agb.pk_gatherbill --收款单头
inner join so_saleorder_b ssb on agi.src_itemid=ssb.csaleorderbid    --销售订单行
inner join so_saleorder ssr on ssb.csaleorderid=ssr.csaleorderid     --销售订单头
inner join bd_income bi on bi.pk_income=ssr.cpaytermid               --收款协议档案
inner join bd_incomech bich on bich.pk_payment=bi.pk_income          --收款协议字表
inner join ic_saleout_b isb on isb.cfirstbillbid =ssb.csaleorderbid  --销售出库单表体（查询产品出库批次号）
inner join org_dept_v ort on ort.pk_dept=agi.pk_deptid               --部门档案
inner join bd_psndoc bp on bp.pk_psndoc =agi.pk_psndoc               --业务员档案
inner join bd_customer bc on bc.pk_customer = agi.ordercubasdoc      --客户档案
inner join bd_material bm on bm.pk_material =agi.material            --物料档案
left join arap_verifydetail vf on agi.pk_gatheritem = vf.pk_item 
