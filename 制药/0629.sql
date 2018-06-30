select m.pk_group,m.pk_org,orgs.name from bd_material m
left join org_orgs orgs on m.pk_org = orgs.pk_org
where substr(m.code,1,2) = '99';

--delete from bd_material m where substr(m.code,1,2) = '99';
--commit;

--delete from bd_marbasclass c where substr(c.code,1,2) = '99';
--commit;

select d.name,d.pk_defdoc from bd_defdoc d 
left join bd_defdoclist l on d.pk_defdoclist = l.pk_defdoclist
where l.name like '%价格%';

select distinct m.code,m.name,m.def1,m.pk_org,orgs.name from bd_material m  
left join org_orgs orgs on m.pk_org = orgs.pk_org
where m.pk_org = '0001NC10000000003WD1';

--update bd_material m set m.def1 = '1001NC10000000002MMF' where m.pk_org = '0001NC10000000003WD1';
--commit;
