select m.code         物料编码,
       m.name         物料名称,
       m.materialspec 规格,
       m.materialtype 型号,
       s.code         供应商编码,
       s.name         供应商名称
from VRM_VENDORMATER t
left join bd_supplier s on t.pk_supplier = s.pk_supplier
left join bd_material m on t.pk_material = m.pk_material
where t.dr = 0
order by m.code;
select m.code         物料编码,
       m.name         物料名称,
       m.materialspec 规格,
       m.materialtype 型号
from bd_material m
where m.dr = 0;
select s.code 供应商编码, s.name 供应商名称
from bd_supplier s
where s.dr = 0;
