select materialvaluemgt
  from bd_materialfi
 where pk_material in
       (select pk_material from bd_material_v where code in ('990403000112','990403000114','990403000110',
       '990403000116','990401000154','990403000111','990403000113'))
   for update
