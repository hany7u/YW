select m.code,
       m.name,
       m.pk_material 
from bd_material m
where m.code like '90%';

select ms.remain  from bd_materialstock ms where ms.pk_material = '1001NC1000000001IVXW'
for update;

--delete from bd_material m  where m.code like '90%';
--commit;

