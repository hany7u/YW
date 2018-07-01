--期初暂估单关联业务员
select b.pk_initialest_b,psn.code, psn.name from po_initialest_b b
left join po_initialest h on b.pk_initialest = h.pk_initialest
left join bd_psndoc psn on h.pk_bizpsn = psn.pk_psndoc
