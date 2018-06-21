create or replace trigger scm_batchcode_1
  before insert or update
  on scm_batchcode 
  for each row
declare
  -- 自动取批次号中的EPA含量和DHA含量
  pk_marbaclass   varchar2(20);
  marbaclass_code varchar2(20);
  EPA             NUMBER(5,2);
  DHA             NUMBER(5,2);
begin
  select m.pk_marbasclass into pk_marbaclass from bd_material m where m.pk_material = :new.cmaterialoid;
  select substr(clazz.code,1,4) into marbaclass_code from bd_marbasclass clazz where clazz.pk_marbasclass = pk_marbaclass;
  if marbaclass_code = '0207' then 
      select substr(:NEW.VBATCHCODE,instr(:NEW.VBATCHCODE,'[',-1)+1,instr(:NEW.VBATCHCODE,',',-1)-instr(:NEW.VBATCHCODE,'[',-1)-1) into EPA from dual;
      select substr(:NEW.VBATCHCODE,instr(:NEW.VBATCHCODE,',',-1)+1,instr(:NEW.VBATCHCODE,']',-1)-instr(:NEW.VBATCHCODE,',',-1)-1) into DHA from dual;
      :new.vdef1 := EPA;
      :new.vdef2 := DHA;
   end if;
end scm_batchcode_1;
/
