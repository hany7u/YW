create or replace trigger po_praybill_b_1
  before insert or update
  on po_praybill_b 
  for each row
declare
/*根据物料自定义项1的值生成请购单表体上的订单类型*/
  price_Model     varchar2(20);
  
  
begin
  select m.def1   into price_Model      from bd_material m where m.pk_material = :new.pk_material;
  
  if  price_Model = '1001NC10000000001ISC' then :new.cordertrantypecode := '1001NC10000000001OSW'; end if;--采购合同
  if  price_Model = '1001NC10000000001ISD' then :new.cordertrantypecode := '1001NC10000000001OTG'; end if;--预算价格
  if  price_Model = '1001NC10000000001ISE' then :new.cordertrantypecode := '1001NC10000000001OT6'; end if;--价目表
  
end po_praybill_b_1;
/
