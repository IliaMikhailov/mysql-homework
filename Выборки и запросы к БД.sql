USE smk;

-- детали по которым уже есть решение применить отправляем на завод
START TRANSACTION;
INSERT INTO smk.factory  
SELECT tech_name, shipment, number_in_shipment
	FROM defect_production 
	WHERE solution = 'Выставить рекламацию. Применить' or solution = 'Применить';
COMMIT;

-- количество деталей которое сейчас на производстве
select tech_name, sum(number_in_shipment) from factory f 
group by tech_name;

-- детали которые поставляет конкретный поставщик
select tech_name from warehouse
where suplier_name = 'Crist Group'
group by tech_name;

-- детали которые чаще всего браковали
select tech_name, count(shipment) as most_defective from defect_production
group by tech_name
order by most_defective desc
limit 10;

-- какие поставщики поставляют самую часто бракованную деталь
select suplier_name from warehouse w 
where tech_name = '711111.063'
group by suplier_name;

-- проверим были ли проблемы по друугим позициям с этим поставщиком
select dp.tech_name ,dp.shipment, dp.type_of_defect, w.suplier_name from defect_production dp
	join warehouse w on dp.shipment = w.shipment
where suplier_name = 'Bergnaum-Kertzmann'
group by type_of_defect ;

-- деталь котору чаще всего браковали с типом выявленного несоответствия
select tech_name, type_of_defect, shipment from defect_production dp 
where tech_name = '711111.063';

-- типы несоответствий выявленный у конкретного поставщика
select dp.tech_name ,dp.shipment, dp.type_of_defect, w.suplier_name from defect_production dp
	join warehouse w on dp.shipment = w.shipment
where suplier_name = 'Blick-Bode'
group by type_of_defect ;

-- список поставщиков по количеству несоответствующей продукции поступившей на входной контроль
select suplier_name, count(dp.shipment) as number_ship from warehouse w 
	join defect_production dp on dp.shipment = w.shipment 
group by suplier_name
order by number_ship desc;

-- поставщик с наибольшим количеством несоответствующей продукции
select suplier_name, count(dp.shipment) as number_ship from warehouse w 
	join defect_production dp on dp.shipment = w.shipment 
group by suplier_name
order by number_ship desc
limit 1;

-- распределение несоответствий по типам
select type_of_defect, count(shipment) as numbers from defect_production dp
group by type_of_defect
order by numbers desc;

-- поставщики чаще всего присылающие продукцию с конкретным типом несоответствия
select  w.suplier_name, count(type_of_defect) as numbers from warehouse w
	join defect_production dp on dp.shipment = w.shipment
where type_of_defect = 'Габаритный размер не соответствует КД'
group by suplier_name 
order by numbers desc;

-- распределение несоответствий по типам (NULL - решение по ним не принято)
select solution, count(shipment) as numbers from defect_production dp
group by solution
order by numbers desc;

-- списанные номенклатуры и их общая стоимость
select dp.tech_name, dp.number_in_shipment * p.cost from defect_production dp
	join production p on p.tech_name = dp.tech_name 
where solution = 'Выставить рекламацию. Списать и утилизировать';

-- общая сумма списанных номенклатур
select sum(dp.number_in_shipment * p.cost) as summ from defect_production dp
	join production p on p.tech_name = dp.tech_name 
where solution = 'Выставить рекламацию. Списать и утилизировать' or solution = 'Списать и утилизировать';
