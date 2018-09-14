select c1.code  一级分类编码,
       c1.name  一级分类名称,
       c2.code  二级分类编码,
       c2.name  二级分类名称,
       c3.code  三级分类编码,
       c3.name  三级分类名称,
       c.code   四级分类编码,
       c.name   四级分类名称,
       d.code   申购流程编码,
       d.name   申购流程名称
from bd_marbasclass c
left join bd_defdoc d on c.def1 = d.pk_defdoc
left join bd_marbasclass c3 on c.pk_parent = c3.pk_marbasclass
left join bd_marbasclass c2 on c3.pk_parent = c2.pk_marbasclass
left join bd_marbasclass c1 on c2.pk_parent = c1.pk_marbasclass 
where c.pk_parent<>'~' 
;
select d.code, d.name from bd_defdoc d 
left join bd_defdoclist l on d.pk_defdoclist = l.pk_defdoclist
where l.name = '采购流程分类'
