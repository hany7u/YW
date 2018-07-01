--价格管控模式和标准号检查
select m.pk_material 物料主键,m.code 物料编码,m.name 物料名称,m.materialspec 规格,m.materialtype 型号,m.def2 标准号,m.def1 价格管控模式主键,d.name 价格管控模式名称,
clazz.name 
from bd_material m
left join bd_marbasclass clazz on m.pk_marbasclass = clazz.pk_marbasclass
left join bd_defdoc d on m.def1 = d.pk_defdoc
--where m.def1 <> '~'
;

select * from qc_checkstandard;



--采购价格管控模式
select d.name,d.pk_defdoc,l.name from bd_defdoc d
left join bd_defdoclist l on d.pk_defdoclist = l.pk_defdoclist
where l.name = '价格管控模式';

--客户基本信息国家地区检查维护
select cust.pk_customer 客户主键,cust.code 客户编码,cust.name 客户名称, cz.name 国家地区名称,cz.pk_country 国家地区主键，cust.def1 是否终端客户,cust.def2 创建时间
from bd_customer cust
left join bd_countryzone cz on cust.pk_country = cz.pk_country;

select cz.name 国家地区名称,cz.pk_country 国家地区主键 from bd_countryzone cz;

--实物物料价值管理模式检查
select mfi.pk_materialfi 物料财务信息主键,m.pk_material 物料主键,m.code 物料编码,m.name 物料名称,m.materialspec 规格,m.materialtype 型号,mfi.materialvaluemgt 物料价值管理主键,
case mfi.materialvaluemgt when 1 then '存货核算' when 2 then '固定资产' when 3 then '费用' end 物料价值管理主键 

from bd_material m
left join bd_materialfi mfi on m.pk_material = mfi.pk_material ;

--物料库存信息检查
select ms.pk_materialstock 物料库存信息主键,
       /*m.pk_material       物料主键,
       m.code              物料编码,
       m.name              物料名称,
       m.materialspec      规格,
       m.materialtype      型号,*/
       ms.wholemanaflag    批次管理,
       ms.chkfreeflag      免检,
       ms.stockbycheck     根据检验结果入库,
       ms.negallowed       允许负库存
  from bd_materialstock ms
--left join bd_material m on ms.pk_material = m.pk_material
where ms.pk_materialstock in ('1001NC1000000001OXXT','1001NC1000000001OXY7','1001NC1000000001OXYJ','1001NC1000000001OXYR')
for update
;

UPDATE bd_materialstock ms SET ms.wholemanaflag = 'Y' where ms.pk_materialstock in ('1001NC1000000001OXXT','1001NC1000000001OXY7','1001NC1000000001OXYJ','1001NC1000000001OXYR');
commit;




--物料基本分类
select clazz.code             物料基本分类编码,
       clazz.name             物料基本分类,
       clazz.pk_marbasclass   物料基本分类主键,
       d.code                 对应申购流程编码, 
       d.name                 对应申购流程名称,
       clazz.def1             对应申购流程主键
  from bd_marbasclass clazz
left join bd_defdoc d on clazz.def1 = d.pk_defdoc
;
--采购流程分类自定义项
select d.code             编码,
       d.name             名称,
       d.pk_defdoc        主键,
       l.name
from bd_defdoc d
left join bd_defdoclist l on d.pk_defdoclist = l.pk_defdoclist
where l.name = '采购流程分类'
;


--客户财务信息检查
select cfi.pk_custfinance 客户财务信息主键,
       cust.pk_customer   客户主键,
       cust.code          客户编码,
       cust.name          客户名称,
       bd_income.code 默认收款协议编码,bd_income.name 默认收款协议名称，cfi.pk_payterm     默认收款协议主键,
       dept.code 默认专管部门编码,dept.name 默认专管部门名称,cfi.pk_respdept1   默认专管部门主键,
       psn.code 默认专管业务员编码,psn.name 默认专管业务员名称,cfi.pk_resppsn1    默认专管业务员主键
  from bd_customer cust
left join bd_custfinance cfi on cust.pk_customer = cfi.pk_customer
left join bd_income bd_income on cfi.pk_payterm = bd_income.pk_income
left join org_dept dept on cfi.pk_respdept1 = dept.pk_dept
left join bd_psndoc psn on cfi.pk_resppsn1 = psn.pk_psndoc
;

--客户销售信息检查
select csa.pk_custsale 客户财务信息主键,
       cust.pk_customer   客户主键,
       cust.code          客户编码,
       cust.name          客户名称,
       bd_income.code 默认收款协议编码,bd_income.name 默认收款协议名称，csa.paytermdefault     默认收款协议主键,
       dept.code 默认专管部门编码,dept.name 默认专管部门名称,csa.respdept   默认专管部门主键,
       psn.code 默认专管业务员编码,psn.name 默认专管业务员名称,csa.respperson    默认专管业务员主键
  from bd_customer cust
left join bd_custsale csa on cust.pk_customer = csa.pk_customer
left join bd_income bd_income on csa.paytermdefault = bd_income.pk_income
left join org_dept dept on csa.respdept = dept.pk_dept
left join bd_psndoc psn on csa.respperson = psn.pk_psndoc
;

--收款协议
select t.code 收款协议编码,t.name 收款协议名称,t.pk_income 收款协议主键 from bd_income t;

--部门档案
select dept.code            部门编码,
       dept.name            部门名称,
       dept.pk_dept         部门主键,
       orgs.code            组织编码,
       orgs.name            组织名称,
       orgs.pk_org          组织主键
  from org_dept dept
left join org_orgs orgs on dept.pk_org = orgs.pk_org
where orgs.name = '山东禹王制药有限公司'
;

--人员信息
select psn.code      人员编码,
       psn.name      人员姓名,
       psn.pk_psndoc 人员主键,
       orgs.code     组织编码,
       orgs.name     组织名称,
       orgs.pk_org   组织主键
  from bd_psndoc psn
left join org_orgs orgs on psn.pk_org = orgs.pk_org
;

--供应商
select s.code        供应商编码,       
       s.name        供应商名称,
       s.pk_supplier 供应商主键,
       d.code        供应商属性编码,
       d.name        供应商属性,
       s.def2        供应商属性主键,
       s.pk_group    所属集团,
       s.pk_org      所属组织,
       l.name
  from bd_supplier s
left join bd_defdoc d on s.def2 = d.pk_defdoc
left join bd_defdoclist l on d.pk_defdoclist = l.pk_defdoclist
where s.name like '%零%'
;

select d.code 供应商属性编码, d.name 供应商属性名称, d.pk_defdoc 供应商属性主键 from bd_defdoc d
left join bd_defdoclist l on d.pk_defdoclist = l.pk_defdoclist
where l.name = '供应商属性';

select t.code,
       t.name,
       t.pk_income 
from bd_income t;

select t.pk_customer,
       t.pk_org,
       t.pk_payterm
from bd_custfinance t;














