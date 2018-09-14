select substr(c.code, 1, 2) 一级分类编码,
       1 一级分类名称,
       substr(c.code, 1, 4) 二级分类编码,
       2 二级分类名称,
       substr(c.code, 1, 6) 三级分类编码,
       3 三级分类名称,
       substr(c.code, 1, 8) 四级分类编码,
       c.name 四级分类名称,
       m.pk_material 物料主键,
       m.code 物料编码,
       m.name 物料名称,
       m.materialspec 规格,
       m.materialtype 型号,
       d.name 采购价格管控模式
  from bd_material m
left join bd_marbasclass c on m.pk_marbasclass = c.pk_marbasclass 

left join bd_defdoc d on m.def1 = d.pk_defdoc
;
select c.code 物料基本分类编码, c.name 物料基本分类名称 from bd_marbasclass c ;
