create or replace trigger pu_order_1
  before insert 
  on po_order_b 
  for each row
declare
/*合格供方管控使用的触发器。用于替代系统在交易类型上做的校验，减少采购订单的交易类型数量*/
  is_materInVRM   NUMBER(2,0);
  is_VRM          NUMBER(2,0);
  
  
  
begin
  SELECT COUNT(*) into is_materInVRM    FROM VRM_VENDORMATER T WHERE T.PK_MATERIAL = :new.pk_material and t.dr = 0 and t.pk_org = :new.pk_org;
  select count(*) into is_VRM           from vrm_vendormater t where t.pk_material = :new.pk_material and t.dr = 0 and t.pk_supplier = :new.pk_supplier and t.pk_org = :new.pk_org;
  
  IF is_materInVRM = 0                 THEN :NEW.Vbdef20 := 1; END IF;--物料不控制合格供方
  IF is_VRM >= 0                       THEN :NEW.Vbdef20 := 2; END IF;--合格供方检查通过
  IF is_materInVRM > 0 AND is_VRM < 1  
    THEN :NEW.Vbdef20 := 3; 
         raise_application_error(-20001,'不符合合格供方管理，请联系质量部添加合格供方信息'); 
  
  END IF;--合格供方检查不通过
end pu_order_1;
/
