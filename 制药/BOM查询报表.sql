select h.vbillcode    BOM编码,
       h.vbilltype    BOM名称,
       mh.code        母件编码,
       mh.name        母件名称,
       c.code         子件基本分类编码,
       c.name         子件基本分类名称,
       mb.code        子件编码,
       mb.name        子件名称,
       b.dr,
       h.dr,
       mh.dr,
       mb.dr,
       c.dr
  from bd_bom_b b
left join bd_bom h on b.cbomid = h.cbomid
left join bd_material mh on h.hcmaterialid = mh.pk_material
left join bd_material mb on b.cmaterialid = mb.pk_material
left join bd_marbasclass c on mb.pk_marbasclass = c.pk_marbasclass
where b.dr = 0
order by h.vbillcode,mb.code
