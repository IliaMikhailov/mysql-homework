DROP DATABASE IF EXISTS smk;
CREATE DATABASE smk;
USE smk;

CREATE TABLE production(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	tech_name VARCHAR(145) NOT null unique,
	cost Decimal,
	inc_control_need boolean,
	index(tech_name)
);
CREATE table supliers(
id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
suplier_name VARCHAR(145) NOT null unique
);

CREATE TABLE warehouse(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	tech_name VARCHAR(145) NOT null,
	shipment BIGINT NOT null unique,
	number_in_shipment int NOT NULL,
	suplier_name VARCHAR(145) NOT NULL,
	date_of_custom DATEtime DEFAULT NULL,
	index(tech_name),
	index(shipment),
	CONSTRAINT production_to_warehouse FOREIGN KEY (tech_name) REFERENCES production (tech_name),
	CONSTRAINT supliers_for_shipment FOREIGN KEY (suplier_name) REFERENCES supliers (suplier_name)
);

CREATE TABLE incoming_control(
	tech_name VARCHAR(145) NOT null,
	shipment BIGINT NOT null unique,
	number_in_shipment int NOT NULL,
	control DATETIME DEFAULT NULL,
	control_result BOOLEAN DEFAULT false,
	index(tech_name),
	index(shipment),	
	CONSTRAINT production_to_control FOREIGN KEY (tech_name) REFERENCES production (tech_name)
);

CREATE TABLE factory(
	tech_name VARCHAR(145) NOT null,
	shipment BIGINT NOT null unique,
	number_in_shipment int NOT null,
	index(tech_name),
	index(shipment),
	CONSTRAINT production_from_warehouse FOREIGN KEY (tech_name) REFERENCES production (tech_name)
);

CREATE TABLE logs(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	from_table VARCHAR(145) NOT null,
	to_table VARCHAR(145) NOT null,
	tech_name VARCHAR(145) NOT null,
	CONSTRAINT production FOREIGN KEY (tech_name) REFERENCES production (tech_name)
);

CREATE TABLE defect_types(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	type_of_defect VARCHAR(145) NOT null,
	index(type_of_defect)
);

insert into defect_types (type_of_defect) values
('���������� ������ �� ������������� ��'),
('������ �� ������������� ��'),
('������������ ����������� ������'),
('�������� �� ������������� ��'),
('�������������� �������� �� ������������� ����������� ��'),
('������ ���� �� ������������� ��'),
('Ҹ���� ����/��������/������������ �����������'),
('��� ������ �� ������������� ��'),
('������� ��������� �� ������������� ��'),
('������������ ��������� �� ������������� ��'),
('������������� �� ������������� ��'),
('������� �� ������������� ��������� �����'),
('��� �� ������������� ��'),
('������ ���������� �� ������������� ��');

CREATE TABLE solution_types(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	solution VARCHAR(145) NOT null,
	index(solution)
);

insert into solution_types (solution) values
('���������'),
('��������� ����������. ���������'),
('��������� ����������. ���������� �� �����'),
('��������� ����������. ���������� � ��'),
('��������� ����������. ���������� �� ���'),
('��������� ����������. ������� ����������'),
('��������� ����������. ������� � �������������'),
('������� � �������������'),
('���������� �� ���'),
('���������� � ��'),
('���������� �� �����'),
('���������� ������'),
('�������� ������� ������'),
('��������� ����������. ����������� ����������� ����������');

CREATE TABLE defect_production(
	tech_name VARCHAR(145) NOT null,
	shipment BIGINT NOT null unique,
	number_in_shipment int NOT null,
	type_of_defect VARCHAR(145) default null,
	text_of_defect VARCHAR(145) default null,
	solution VARCHAR(145) default null,
	index(tech_name),
	index(shipment),
	CONSTRAINT production_from_control FOREIGN KEY (tech_name) REFERENCES production (tech_name),
	CONSTRAINT defect FOREIGN KEY (type_of_defect) REFERENCES defect_types (type_of_defect),
	CONSTRAINT solution_type FOREIGN KEY (solution) REFERENCES solution_types (solution),
	CONSTRAINT shipment_of_defect_production FOREIGN KEY (shipment) REFERENCES warehouse (shipment)
);