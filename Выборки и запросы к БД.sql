USE smk;

-- ������ �� ������� ��� ���� ������� ��������� ���������� �� �����
START TRANSACTION;
INSERT INTO smk.factory  
SELECT tech_name, shipment, number_in_shipment
	FROM defect_production 
	WHERE solution = '��������� ����������. ���������' or solution = '���������';
COMMIT;

-- ���������� ������� ������� ������ �� ������������
select tech_name, sum(number_in_shipment) from factory f 
group by tech_name;

-- ������ ������� ���������� ���������� ���������
select tech_name from warehouse
where suplier_name = 'Crist Group'
group by tech_name;

-- ������ ������� ���� ����� ���������
select tech_name, count(shipment) as most_defective from defect_production
group by tech_name
order by most_defective desc
limit 10;

-- ����� ���������� ���������� ����� ����� ����������� ������
select suplier_name from warehouse w 
where tech_name = '711111.063'
group by suplier_name;

-- �������� ���� �� �������� �� ������� �������� � ���� �����������
select dp.tech_name ,dp.shipment, dp.type_of_defect, w.suplier_name from defect_production dp
	join warehouse w on dp.shipment = w.shipment
where suplier_name = 'Bergnaum-Kertzmann'
group by type_of_defect ;

-- ������ ������ ���� ����� ��������� � ����� ����������� ��������������
select tech_name, type_of_defect, shipment from defect_production dp 
where tech_name = '711111.063';

-- ���� �������������� ���������� � ����������� ����������
select dp.tech_name ,dp.shipment, dp.type_of_defect, w.suplier_name from defect_production dp
	join warehouse w on dp.shipment = w.shipment
where suplier_name = 'Blick-Bode'
group by type_of_defect ;

-- ������ ����������� �� ���������� ����������������� ��������� ����������� �� ������� ��������
select suplier_name, count(dp.shipment) as number_ship from warehouse w 
	join defect_production dp on dp.shipment = w.shipment 
group by suplier_name
order by number_ship desc;

-- ��������� � ���������� ����������� ����������������� ���������
select suplier_name, count(dp.shipment) as number_ship from warehouse w 
	join defect_production dp on dp.shipment = w.shipment 
group by suplier_name
order by number_ship desc
limit 1;

-- ������������� �������������� �� �����
select type_of_defect, count(shipment) as numbers from defect_production dp
group by type_of_defect
order by numbers desc;

-- ���������� ���� ����� ����������� ��������� � ���������� ����� ��������������
select  w.suplier_name, count(type_of_defect) as numbers from warehouse w
	join defect_production dp on dp.shipment = w.shipment
where type_of_defect = '���������� ������ �� ������������� ��'
group by suplier_name 
order by numbers desc;

-- ������������� �������������� �� ����� (NULL - ������� �� ��� �� �������)
select solution, count(shipment) as numbers from defect_production dp
group by solution
order by numbers desc;

-- ��������� ������������ � �� ����� ���������
select dp.tech_name, dp.number_in_shipment * p.cost from defect_production dp
	join production p on p.tech_name = dp.tech_name 
where solution = '��������� ����������. ������� � �������������';

-- ����� ����� ��������� �����������
select sum(dp.number_in_shipment * p.cost) as summ from defect_production dp
	join production p on p.tech_name = dp.tech_name 
where solution = '��������� ����������. ������� � �������������' or solution = '������� � �������������';



























