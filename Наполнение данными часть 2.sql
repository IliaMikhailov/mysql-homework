USE smk;

-- ������� � ��
START TRANSACTION;

INSERT INTO smk.incoming_control  
SELECT t1.tech_name, t1.shipment, t1.number_in_shipment, null as control, null as control_result
	FROM warehouse as t1
		JOIN production t2 ON t1.tech_name = t2.tech_name
	WHERE t2.inc_control_need = 1;

update smk.warehouse 
set date_of_custom = current_timestamp()
where id in (SELECT t1.id
	FROM (SELECT t1.*
	FROM warehouse as t1
		JOIN production t2 ON t1.tech_name = t2.tech_name
	WHERE t2.inc_control_need = 1) as t1
		JOIN production t2 ON t1.tech_name = t2.tech_name
	WHERE t2.inc_control_need = 1);

COMMIT;

-- ������� ��� ��
START TRANSACTION;

INSERT INTO smk.factory  
SELECT t1.tech_name, t1.shipment, t1.number_in_shipment
	FROM warehouse as t1
		JOIN production t2 ON t1.tech_name = t2.tech_name
	WHERE t2.inc_control_need = 0;

update smk.warehouse 
set date_of_custom = current_timestamp()
where id in (SELECT t1.id
	FROM (SELECT t1.*
	FROM warehouse as t1
		JOIN production t2 ON t1.tech_name = t2.tech_name
	WHERE t2.inc_control_need = 0) as t1
		JOIN production t2 ON t1.tech_name = t2.tech_name
	WHERE t2.inc_control_need = 0);

COMMIT;

update incoming_control 
set control_result = 0 
where shipment between 0 and 300;

update incoming_control 
set control_result = 0 
where shipment between 701 and 999;
-- ������� �� �� � ��������� ���������
START TRANSACTION;

INSERT INTO smk.defect_production  
SELECT tech_name, shipment, number_in_shipment, null as type_of_defect, null as text_of_defect, null as solution
	FROM incoming_control
	WHERE control_result = 0;

update smk.incoming_control 
set control = current_timestamp()
where control is null and control_result is not null;

COMMIT;

update incoming_control 
set control_result = 1 
where shipment between 301 and 700;

-- �� �� �� �����
START TRANSACTION;

INSERT INTO smk.factory  
SELECT tech_name, shipment, number_in_shipment
	FROM incoming_control
	WHERE control_result = 1;

update smk.incoming_control 
set control = current_timestamp()
where control is null and control_result is not null;

COMMIT;



update defect_production set type_of_defect = '���������� ������ �� ������������� ��', 
text_of_defect = '������ 68 �� �� ������������� ��. �� ����� 72 ��.', solution = '��������� ����������. ������� ����������' where shipment = 100;
update defect_production set type_of_defect = '������ �� ������������� ��', 
text_of_defect = '������ �8 �� ������������� ��. �� ������ �6.',solution = '��������� ����������. ���������� � ��' where shipment = 103;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ��������� ������. ���.2',
solution = '��������� ����������. ���������' where shipment = 104;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 18 �� �� ������������� ��. �� ����� 14 ��.',
solution = '��������� ����������. ������� ����������' where shipment = 267;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 100 �� �� ������������� ��. �� ����� 101 ��.',
solution = '��������� ����������. ���������' where shipment = 128;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� �������� �12.��',
solution = '��������� ����������. ���������� �� ���' where shipment = 129;
update defect_production set type_of_defect = '�������� �� ������������� ��', text_of_defect = '�� �� ������ ������ ���� ����������� �� ������, �� ����� �� �����',
solution = '��������� ����������. ���������� �� ���' where shipment = 215;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�� �� ������ ������ ���� ����������� �� ������, �� ����� �� �����',
solution = '��������� ����������. ���������� �� ���' where shipment = 292;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�� �� ������ ������ ���� ����������� �� ������, �� ����� �� �����',
solution = '��������� ����������. ���������� �� ���' where shipment = 293;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�� �� ������ ������ ���� ����������� �� ������, �� ����� �� �����',
solution = '��������� ����������. ���������� �� ���' where shipment = 255;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�� �� ������ ������ ���� ����������� �� ������, �� ����� �� �����',
solution = '��������� ����������. ���������� �� ���' where shipment = 242;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�� �� ������ ������ ���� ����������� �� ������, �� ����� �� �����',
solution = '��������� ����������. ���������� �� ���' where shipment = 193;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�� �� ������ ������ ���� ����������� �� ������, �� ����� �� �����',
solution = '��������� ����������. ���������� �� ���' where shipment = 269;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�� �� ������ ������ ���� ����������� �� ������, �� ����� �� �����',
solution = '��������� ����������. ���������� �� ���' where shipment = 132;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�� �� ������ ������ ���� ����������� �� ������, �� ����� �� �����',
solution = '��������� ����������. ���������� �� ���' where shipment = 276;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 100 �� �� ������������� ��. �� ����� 101 ��.',
solution = '��������� ����������. ���������' where shipment = 252;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 12 �� �� ������������� ��. �� ����� 12,5 ��.',
solution = '���������' where shipment = 134;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 14 �� �� ������������� ��. �� ����� 14,5 ��.',
solution = '���������' where shipment = 186;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 22 �� �� ������������� ��. �� ����� 21 ��.',
solution = '��������� ����������. ���������' where shipment = 198;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 235 �� �� ������������� ��. �� ����� 240 ��.',
solution = '��������� ����������. ���������' where shipment = 204;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 120 �� �� ������������� ��. �� ����� 122 ��.',
solution = '��������� ����������. ���������' where shipment = 273;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 14 �� �� ������������� ��. �� ����� 13 ��.',
solution = '��������� ����������. ���������' where shipment = 275;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 14 �� �� ������������� ��. �� ����� 15 ��.',
solution = '��������� ����������. ���������' where shipment = 112;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 12 �� �� ������������� ��. �� ����� 11 ��.',
solution = '��������� ����������. ���������' where shipment = 108;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 8 �� �� ������������� ��. �� ����� 8,1 ��.',
solution = '���������' where shipment = 207;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 24 �� �� ������������� ��. �� ����� 24,5 ��.',
solution = '��������� ����������. ���������' where shipment = 147;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 98 �� �� ������������� ��. �� ����� 101 ��.',
solution = '��������� ����������. ���������' where shipment = 122;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 12 �� �� ������������� ��. �� ����� 13 ��.',
solution = '��������� ����������. ���������' where shipment = 288;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 15 �� �� ������������� ��. �� ����� 14,8 ��.',
solution = '���������' where shipment = 166;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '������ 57 �� �� ������������� ��. �� ����� 80 ��.',
solution = '��������� ����������. ���������' where shipment = 170;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 190;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 143;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 125;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 163;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 259;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 291;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 190;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 143;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 125;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 163;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 259;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 291;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 300;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 183;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 249;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 116;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 226;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 176;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 160;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 229;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 145;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 245;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 282;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 208;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� �� �����' where shipment = 113;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� �� �����' where shipment = 216;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� �� �����' where shipment = 283;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� �� �����' where shipment = 133;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� �� �����' where shipment = 213;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� � ��' where shipment = 260;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� � ��' where shipment = 274;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� � ��' where shipment = 264;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� � ��' where shipment = 139;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������� � ��' where shipment = 164;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 240;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 296;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 203;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ������� ����������' where shipment = 241;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ������� ����������' where shipment = 205;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ������� ����������' where shipment = 138;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ������� ����������' where shipment = 142;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ������� ����������' where shipment = 151;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ������� ����������' where shipment = 181;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ������� ����������' where shipment = 187;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ������� ����������' where shipment = 258;
update defect_production set type_of_defect = '������������ ����������� ������', text_of_defect = '������������ ����������� �� ������� ������',
solution = '��������� ����������. ���������' where shipment = 123;
update defect_production set type_of_defect = '��� ������ �� ������������� ��', text_of_defect = '��� ������ �������� �� �� ��. �� �� ������ 25 �� � ������ 20 ��. �� ����� 24 � 21 �� ��������������',
solution = '��������� ����������. ������� � �������������' where shipment = 148;
update defect_production set type_of_defect = '��� ������ �� ������������� ��', text_of_defect = '��� ������ �������� �� �� ��. �� �� ���� 45, �� ����� 30',
solution = '��������� ����������. ������� � �������������' where shipment = 137;
update defect_production set type_of_defect = '��� ������ �� ������������� ��', text_of_defect = '��� ������ �������� �� �� ��. �� �� ���� 30, �� ����� 60',
solution = '��������� ����������. ������� � �������������' where shipment = 247;
update defect_production set type_of_defect = '��� ������ �� ������������� ��', text_of_defect = '��� ������ �������� �� �� ��. �� �� ���� 25, �� ����� 30',
solution = '��������� ����������. ������� � �������������' where shipment = 120;
update defect_production set type_of_defect = '��� ������ �� ������������� ��', text_of_defect = '��� ������ �������� �� �� ��. �� �� ���� 45, �� ����� 60',
solution = '��������� ����������. ������� � �������������' where shipment = 266;
update defect_production set type_of_defect = '��� ������ �� ������������� ��', text_of_defect = '��� ������ �������� �� �� ��. �� �� ���� 130, �� ����� 60',
solution = '��������� ����������. ������� � �������������' where shipment = 110;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 230;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 221;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 251;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 214;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 117;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 246;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 253;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 238;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 141;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 243;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 250;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 146;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 154;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 202;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 222;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 297;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 220;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 271;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '�� �� ������� ��������� 7/11.5 ��, �� ����� 6,5/10 ��',
solution = '��������� ����������. ���������' where shipment = 235;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '��������� �� ������� ������� ������',
solution = '��������� ����������. ���������� �� �����' where shipment = 257;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 174;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 109;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 140;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 179;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 167;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 65;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 730;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 747;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 980;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 1;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 32;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 45;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 71;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 53;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 711;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '�� �� ral 7037, �� ����� ral 7035',
solution = '��������� ����������. ���������� � ��' where shipment = 845;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ������ 2 ��.' where shipment = 945;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ���������� ������������',
solution = '��������� ����������. ����������� ����������� ����������' where shipment = 874;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ���������� ������������',
solution = '��������� ����������. ����������� ����������� ����������' where shipment = 852;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ���������� ������������',
solution = '��������� ����������. ����������� ����������� ����������' where shipment = 921;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ���������� ������������' where shipment = 990;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ���������� ������������',
solution = '��������� ����������. ����������� ����������� ����������' where shipment = 762;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ���������� ������������',
solution = '��������� ����������. ����������� ����������� ����������' where shipment = 796;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ���������� ������������',
solution = '��������� ����������. ����������� ����������� ����������' where shipment = 31;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ���������� ������������',
solution = '��������� ����������. ����������� ����������� ����������' where shipment = 885;
update defect_production set type_of_defect = '������������� �� ������������� ��', text_of_defect = '����������� ���������� ������������',
solution = '��������� ����������. ����������� ����������� ����������' where shipment = 9;
update defect_production set type_of_defect = '������������ ��������� �� ������������� ��', text_of_defect = '������ ������������ ��������� 8 �� �� ������������� ��. �� �� 30 ��, �� ����� 40 ��.',
solution = '��������� ����������. ������� � �������������' where shipment = 755;
update defect_production set type_of_defect = '������������ ��������� �� ������������� ��', text_of_defect = '������ ������������ ��������� 10 �� �� ������������� ��. �� �� 55 ��, �� ����� 56 ��.',
solution = '��������� ����������. ������� � �������������' where shipment = 21;
update defect_production set type_of_defect = '������������ ��������� �� ������������� ��', text_of_defect = '������ ������������ ��������� 8 �� �� ������������� ��. �� �� 42 ��, �� ����� 40 ��.',
solution = '��������� ����������. ������� � �������������' where shipment = 756;
update defect_production set type_of_defect = '������������ ��������� �� ������������� ��', text_of_defect = '������ ������������ ��������� 7 �� �� ������������� ��. �� �� 30 ��, �� ����� 21 ��.',
solution = '��������� ����������. ������� � �������������' where shipment = 97;
update defect_production set type_of_defect = '������������ ��������� �� ������������� ��', text_of_defect = '������ ������������ ��������� 5 �� �� ������������� ��. �� �� 30 ��, �� ����� 45 ��.',
solution = '��������� ����������. ������� � �������������' where shipment = 706;
update defect_production set type_of_defect = '������������ ��������� �� ������������� ��', text_of_defect = '������ ������������ ��������� 3 �� �� ������������� ��. �� �� 30 ��, �� ����� 8 ��.',
solution = '��������� ����������. ������� � �������������' where shipment = 5;
update defect_production set type_of_defect = '������������ ��������� �� ������������� ��', text_of_defect = '������ ������������ ��������� 3 �� �� ������������� ��. �� �� 30 ��, �� ����� 12 ��.',
solution = '��������� ����������. ������� � �������������' where shipment = 23;
update defect_production set type_of_defect = '������������ ��������� �� ������������� ��', text_of_defect = '������ ������������ ��������� 3 �� �� ������������� ��. �� �� 30 ��, �� ����� 7 ��.',
solution = '��������� ����������. ������� � �������������' where shipment = 758;
update defect_production set type_of_defect = '������������ ��������� �� ������������� ��', text_of_defect = '������ ������������ ��������� 4 �� �� ������������� ��. �� �� 80 ��, �� ����� 82 ��.',
solution = '��������� ����������. ������� � �������������' where shipment = 877;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 779;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 922;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 64;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 720;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 897;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 946;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 736;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 830;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 940;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 3;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 819;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 972;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 93;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 759;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 798;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 917;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 978;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 58;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ������',
solution = '���������� � ��' where shipment = 957;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 959;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 24;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 715;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 741;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 872;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 16;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 955;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 944;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������' where shipment = 983;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 947;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������' where shipment = 982;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 893;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 744;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 783;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 856;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 824;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 919;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 709;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 956;
update defect_production set type_of_defect = 'Ҹ���� ����/��������/������������ �����������', text_of_defect = '�������� �� ����������� ������',
solution = '���������� � ��' where shipment = 12;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 787;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 953;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 977;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 25;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 883;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 853;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 912;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 29;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 84;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 725;
update defect_production set type_of_defect = '������ ���� �� ������������� ��', text_of_defect = '������ ���� ��� ��������� ������ �� ������������� ��. �� �� 1,1 ��, �� ����� 0,9 ��',
solution = '���������� � ��' where shipment = 802;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �12-LH �� ������������� ��, �� ����� �12' where shipment = 941;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �12-LH �� ������������� ��, �� ����� �12',
solution = '������� � �������������' where shipment = 52;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �12-LH �� ������������� ��, �� ����� �12',
solution = '������� � �������������' where shipment = 77;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �12-LH �� ������������� ��, �� ����� �12' where shipment = 987;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �12-LH �� ������������� ��, �� ����� �12' where shipment = 991;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �12 �� ������������� ��, �� ����� �10',
solution = '���������� � ��' where shipment = 60;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �12 �� ������������� ��, �� ����� �10',
solution = '���������� � ��' where shipment = 764;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �12 �� ������������� ��, �� ����� �10',
solution = '���������� � ��' where shipment = 898;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �4 �� ������������� ��, �� ����� �6',
solution = '��������� ����������. ������� ����������' where shipment = 86;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �4 �� ������������� ��, �� ����� �6',
solution = '��������� ����������. ������� ����������' where shipment = 842;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �4 �� ������������� ��, �� ����� �6',
solution = '��������� ����������. ������� ����������' where shipment = 860;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '������ �4 �� ������������� ��, �� ����� �6',
solution = '��������� ����������. ������� ����������' where shipment = 864;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '����������� ���',
solution = '��������� ����������. ������� ����������' where shipment = 751;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '����������� ���',
solution = '��������� ����������. ������� ����������' where shipment = 763;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '����������� ���',
solution = '��������� ����������. ������� ����������' where shipment = 904;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '����������� ���',
solution = '��������� ����������. ������� ����������' where shipment = 905;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '����������� ���',
solution = '��������� ����������. ������� ����������' where shipment = 942;
update defect_production set type_of_defect = '��� �� ������������� ��', text_of_defect = '����������� ���',
solution = '��������� ����������. ������� ����������' where shipment = 49;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��. �� ����� 22 ��.',
solution = '��������� ����������. ������� ����������' where shipment = 748;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��. �� ����� 22 ��.',
solution = '��������� ����������. ������� ����������' where shipment = 805;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��. �� ����� 20,3 ��.',
solution = '��������� ����������. ������� ����������' where shipment = 809;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��. �� ����� 20,3 ��.',
solution = '��������� ����������. ������� ����������' where shipment = 814;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��. �� ����� 20,3 ��.',
solution = '��������� ����������. ������� ����������' where shipment = 895;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��. �� ����� 20,3 ��.',
solution = '��������� ����������. ������� ����������' where shipment = 775;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��. �� ����� 20,3 ��.' where shipment = 976;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��. �� ����� 20,3 ��.' where shipment = 979;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 25 �� �� ������������� ��. �� ����� 24,7 ��.',
solution = '��������� ����������. ���������' where shipment = 2;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 25 �� �� ������������� ��. �� ����� 24,7 ��.',
solution = '��������� ����������. ���������' where shipment = 98;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 25 �� �� ������������� ��. �� ����� 24,7 ��.',
solution = '��������� ����������. ���������' where shipment = 812;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 25 �� �� ������������� ��. �� ����� 24,7 ��.',
solution = '��������� ����������. ���������' where shipment = 83;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 25 �� �� ������������� ��. �� ����� 24,7 ��.',
solution = '��������� ����������. ���������' where shipment = 90;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 25 �� �� ������������� ��. �� ����� 24,7 ��.',
solution = '��������� ����������. ���������' where shipment = 731;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 87;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 705;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 718;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 826;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 974;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 791;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 800;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 964;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 984;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 105 �� �� ������������� ��. �� ����� 104 ��.',
solution = '��������� ����������. ���������' where shipment = 984;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 850;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 970;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 832;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 988;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 42;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 780;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 795;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 82;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 804;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 825;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 899;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 918;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', 
text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.' where shipment = 962;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 14;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 750;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 80 �� �� ������������� ��. �� ����� 79,8 ��.',
solution = '��������� ����������. ���������' where shipment = 857;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 12 �� �� ������������� ��. �� ����� 11,8 ��',
solution = '��������� ����������. ���������' where shipment = 925;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 10 �� �� ������������� ��. �� ����� 10,2 ��',
solution = '��������� ����������. ���������' where shipment = 43;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 10 �� �� ������������� ��. �� ����� 10,2 ��',
solution = '��������� ����������. ���������' where shipment = 833;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', 
text_of_defect = '������� ��������� 10 �� �� ������������� ��. �� ����� 9,8 ��' where shipment = 985;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 54;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 56;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 262;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 701;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 949;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 34;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 712;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 753;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 908;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 738;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 817;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6,3 �� �� ������������� ��. �� ����� 6,2 ��',
solution = '��������� ����������. ���������' where shipment = 734;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6,5 �� �� ������������� ��. �� ����� 5,7 ��',
solution = '��������� ����������. ���������' where shipment = 760;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 6,2 �� �� ������������� ��. �� ����� 5,9 ��',
solution = '��������� ����������. ���������' where shipment = 930;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 8 �� �� ������������� ��. �� ����� 7,7 ��',
solution = '��������� ����������. ���������' where shipment = 786;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 12 �� �� ������������� ��. �� ����� 12,7 ��',
solution = '��������� ����������. ���������' where shipment = 76;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 4 �� �� ������������� ��. �� ����� 3,7 ��',
solution = '��������� ����������. ���������' where shipment = 969;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 8 �� �� ������������� ��. �� ����� 8,7 ��',
solution = '��������� ����������. ���������' where shipment = 704;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� ��������� 8 �� �� ������������� ��. �� ����� 8,7 ��',
solution = '��������� ����������. ���������' where shipment = 891;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6',
solution = '���������� �� ���' where shipment = 20;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6' where shipment = 992;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6',
solution = '���������� �� ���' where shipment = 81;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6',
solution = '���������� �� ���' where shipment = 99;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6',
solution = '���������� �� ���' where shipment = 882;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6',
solution = '���������� �� ���' where shipment = 938;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6',
solution = '���������� �� ���' where shipment = 15;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6',
solution = '���������� �� ���' where shipment = 30;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6',
solution = '���������� �� ���' where shipment = 870;
update defect_production set type_of_defect = '�������������� �������� �� ������������� ����������� ��', text_of_defect = '����������� �������������� ��������: �6' where shipment = 997;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��.�� ����� 20,3 ��',
solution = '���������' where shipment = 794;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��.�� ����� 20,3 ��',
solution = '���������' where shipment = 951;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 30 �� �� ������������� ��.�� ����� 30,3 ��',
solution = '���������' where shipment = 710;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 30 �� �� ������������� ��.�� ����� 30,3 ��',
solution = '���������' where shipment = 726;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 30 �� �� ������������� ��.�� ����� 30,3 ��',
solution = '���������' where shipment = 740;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 30 �� �� ������������� ��.�� ����� 30,3 ��',
solution = '���������' where shipment = 916;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 30 �� �� ������������� ��.�� ����� 30,3 ��',
solution = '���������' where shipment = 96;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��.�� ����� 20,3 ��',
solution = '���������' where shipment = 708;
update defect_production set type_of_defect = '������ ���������� �� ������������� ��', text_of_defect = 'R4 �� ������������� ��. �� ����� R3',
solution = '���������' where shipment = 723;
update defect_production set type_of_defect = '������ ���������� �� ������������� ��', text_of_defect = 'R4 �� ������������� ��. �� ����� R6',
solution = '���������' where shipment = 92;
update defect_production set type_of_defect = '������ ���������� �� ������������� ��', text_of_defect = 'R4 �� ������������� ��. �� ����� R6',
solution = '���������' where shipment = 858;
update defect_production set type_of_defect = '������ ���������� �� ������������� ��', text_of_defect = 'R4 �� ������������� ��. �� ����� R6',
solution = '���������' where shipment = 939;
update defect_production set type_of_defect = '������ ���������� �� ������������� ��', text_of_defect = 'R4 �� ������������� ��. �� ����� R6',
solution = '���������' where shipment = 728;
update defect_production set type_of_defect = '������ ���������� �� ������������� ��', text_of_defect = 'R4 �� ������������� ��. �� ����� R6',
solution = '���������' where shipment = 815;
update defect_production set type_of_defect = '������ ���������� �� ������������� ��', text_of_defect = 'R4 �� ������������� ��. �� ����� R6',
solution = '���������' where shipment = 915;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�4 �� ������������� ��. �� ����� �5',
solution = '���������' where shipment = 767;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�4 �� ������������� ��. �� ����� �5',
solution = '���������' where shipment = 841;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�4 �� ������������� ��. �� ����� �5',
solution = '���������' where shipment = 927;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�4 �� ������������� ��. �� ����� �5',
solution = '���������' where shipment = 966;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�4 �� ������������� ��. �� ����� �5',
solution = '���������' where shipment = 721;
update defect_production set type_of_defect = '������ �� ������������� ��', text_of_defect = '�4 �� ������������� ��. �� ����� �5',
solution = '���������' where shipment = 769;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 16,8 �� �� ������������� ��.�� ����� 17 ��',
solution = '���������' where shipment = 41;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 16,8 �� �� ������������� ��.�� ����� 17 ��',
solution = '���������' where shipment = 822;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 16,8 �� �� ������������� ��.�� ����� 17 ��' where shipment = 934;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 16,8 �� �� ������������� ��.�� ����� 17 ��' where shipment = 993;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 18 �� �� ������������� ��.�� ����� 17,9 ��',
solution = '��������� ����������. ���������� � ��' where shipment = 797;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 18 �� �� ������������� ��.�� ����� 17,9 ��',
solution = '��������� ����������. ���������� � ��' where shipment = 811;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 18 �� �� ������������� ��.�� ����� 17,9 ��',
solution = '��������� ����������. ���������� � ��' where shipment = 849;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 18 �� �� ������������� ��.�� ����� 17,9 ��',
solution = '��������� ����������. ���������� � ��' where shipment = 854;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 18 �� �� ������������� ��.�� ����� 17,9 ��',
solution = '��������� ����������. ���������� � ��' where shipment = 914;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 23 �� �� ������������� ��.�� ����� 22 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 11;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 23 �� �� ������������� ��.�� ����� 22 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 823;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 23 �� �� ������������� ��.�� ����� 22 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 847;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 15 �� �� ������������� ��.�� ����� 14,9 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 10;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 15 �� �� ������������� ��.�� ����� 14,9 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 774;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 15 �� �� ������������� ��.�� ����� 14,9 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 906;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '������� 15 �� �� ������������� ��.�� ����� 14,9 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 933;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 60 �� �� ������������� ��.�� ����� 60,3 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 829;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 60 �� �� ������������� ��.�� ����� 60,3 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 862;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 60 �� �� ������������� ��.�� ����� 60,3 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 873;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 60 �� �� ������������� ��.�� ����� 60,3 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 932;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 20 �� �� ������������� ��.�� ����� 20,3 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 743;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 60 �� �� ������������� ��.�� ����� 60,3 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 909;
update defect_production set type_of_defect = '���������� ������ �� ������������� ��', text_of_defect = '���������� ������ 120 �� �� ������������� ��.�� ����� 120,5 ��',
solution = '��������� ����������. ���������� �� �����' where shipment = 722;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '����������� ��������� �������� 8 ��',
solution = '���������� � ��' where shipment = 13;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '����������� ��������� �������� 8 ��',
solution = '���������� � ��' where shipment = 848;
update defect_production set type_of_defect = '������� ��������� �� ������������� ��', text_of_defect = '����������� ��������� �������� 8 ��',
solution = '���������� � ��' where shipment = 902;









