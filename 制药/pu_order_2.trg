create or replace trigger pu_order_1
  before insert 
  on po_order_b 
  for each row
declare
/*合格供方管控使用的触发器。用于替代系统在交易类型上做的校验，减少采购订单的交易类型数量*/
  is_materInVRM   NUMBER(2,0);
  is_VRM          NUMBER(2,0);
  price_Model     varchar2(20);
  jzjg_price       NUMBER(8,4);
  jmb_price       NUMBER(8,4);
  
begin
  SELECT COUNT(*) into is_materInVRM    FROM VRM_VENDORMATER T WHERE T.PK_MATERIAL = :new.pk_material and t.dr = 0 and t.pk_org = :new.pk_org;
  select count(*) into is_VRM           from vrm_vendormater t where t.pk_material = :new.pk_material and t.dr = 0 and t.pk_supplier = :new.pk_supplier and t.pk_org = :new.pk_org;
  select decode(m.def1,'~','1001NC10000000002MMF',m.def1)   into price_Model      from bd_material m where m.pk_material = :new.pk_material;
  IF is_materInVRM = 0                 THEN :NEW.vbdef2 := 1; END IF;--物料不控制合格供方
  IF is_VRM >= 0                       THEN :NEW.vbdef2 := 2; END IF;--合格供方检查通过
  IF is_materInVRM > 0 AND is_VRM < 1  
    THEN :NEW.vbdef2 := 3; 
         raise_application_error(-20001,'不符合合格供方管理，请联系质量部添加合格供方信息'); 
  
  END IF;--合格供方检查不通过
  --基准价格的物料自定义项  1001NC10000000002MMG
  if price_Model = '1001NC10000000002MMG' then 
    select iprice into jzjg_price from 
          ( select b.iprice iprice from po_preprice_b b
            left join po_preprice h on b.pk_preprice = h.pk_preprice
            where b.pk_org = :new.pk_org and b.pk_gcode = :new.pk_material and substr(h.effectivedate,1,10) <= substr(:new.dbilldate,1,10) 
                  and substr(h.expirydate,1,10) >= substr(:new.dbilldate,1,10)
            order by h.expirydate desc)
     where rownum = 1;
    :new.vbdef4 := jzjg_price;
    if  :new.nprice > jzjg_price then 
      select 1 into jmb_price from
             (select b.nordprice from purp_priceaudit_b b
              left join purp_priceaudit h on b.pk_priceaudit = h.pk_priceaudit
              where b.pk_org = :new.pk_org and b.pk_material = :new.pk_material and substr(b.dqtvaliddate,1,10) <= substr(:new.dbilldate,1,10) 
                  and substr(b.dqtinvaliddate,1,10) >= substr(:new.dbilldate,1,10) and h.fbillstatus = 3 and b.border = 'Y'
              order by b.dqtinvaliddate)
      where rownum = 1;
      --:new.nprice = jmb_price; 
      if :new.nprice > jmb_price then 
        raise_application_error(-20002,'采购价格既高于基准价格也高于价目表价格，请确认'); 
      end if; 
    end if; 
  end if;
  
end pu_order_1;
/
