USE smk;

-- перенос в ВК
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

-- перенос без ВК
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
-- перенос из ВК в дефектную продукцию
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

-- из ВК на завод
START TRANSACTION;

INSERT INTO smk.factory  
SELECT tech_name, shipment, number_in_shipment
	FROM incoming_control
	WHERE control_result = 1;

update smk.incoming_control 
set control = current_timestamp()
where control is null and control_result is not null;

COMMIT;



update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', 
text_of_defect = 'Размер 68 мм не соответствует КД. По факту 72 мм.', solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 100;
update defect_production set type_of_defect = 'Резьба не соответствует КД', 
text_of_defect = 'Резьба М8 не соответствует КД. По резьба М6.',solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 103;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствуют стопорные кольца. поз.2',
solution = 'Выставить рекламацию. Применить' where shipment = 104;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 18 мм не соответствует КД. По факту 14 мм.',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 267;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 100 мм не соответствует КД. По факту 101 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 128;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие Ц12.хр',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 129;
update defect_production set type_of_defect = 'Материал не соответствует КД', text_of_defect = 'По КД деталь должна быть изготовлена из латуни, по факту из стали',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 215;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'По КД деталь должна быть изготовлена из латуни, по факту из стали',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 292;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'По КД деталь должна быть изготовлена из латуни, по факту из стали',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 293;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'По КД деталь должна быть изготовлена из латуни, по факту из стали',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 255;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'По КД деталь должна быть изготовлена из латуни, по факту из стали',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 242;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'По КД деталь должна быть изготовлена из латуни, по факту из стали',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 193;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'По КД деталь должна быть изготовлена из латуни, по факту из стали',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 269;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'По КД деталь должна быть изготовлена из латуни, по факту из стали',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 132;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'По КД деталь должна быть изготовлена из латуни, по факту из стали',
solution = 'Выставить рекламацию. Доработать по МЗК' where shipment = 276;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 100 мм не соответствует КД. По факту 101 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 252;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 12 мм не соответствует КД. По факту 12,5 мм.',
solution = 'Применить' where shipment = 134;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 14 мм не соответствует КД. По факту 14,5 мм.',
solution = 'Применить' where shipment = 186;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 22 мм не соответствует КД. По факту 21 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 198;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 235 мм не соответствует КД. По факту 240 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 204;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 120 мм не соответствует КД. По факту 122 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 273;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 14 мм не соответствует КД. По факту 13 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 275;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 14 мм не соответствует КД. По факту 15 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 112;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 12 мм не соответствует КД. По факту 11 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 108;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 8 мм не соответствует КД. По факту 8,1 мм.',
solution = 'Применить' where shipment = 207;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 24 мм не соответствует КД. По факту 24,5 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 147;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 98 мм не соответствует КД. По факту 101 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 122;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 12 мм не соответствует КД. По факту 13 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 288;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 15 мм не соответствует КД. По факту 14,8 мм.',
solution = 'Применить' where shipment = 166;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Размер 57 мм не соответствует КД. По факту 80 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 170;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 190;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 143;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 125;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 163;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 259;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 291;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 190;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 143;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 125;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 163;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 259;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 291;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 300;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 183;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 249;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 116;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 226;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 176;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 160;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 229;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 145;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 245;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 282;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 208;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 113;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 216;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 283;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 133;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 213;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 260;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 274;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 264;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 139;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 164;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 240;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 296;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 203;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 241;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 205;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 138;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 142;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 151;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 181;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 187;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 258;
update defect_production set type_of_defect = 'Механические повреждения детали', text_of_defect = 'Механические повреждения на корпусе детали',
solution = 'Выставить рекламацию. Применить' where shipment = 123;
update defect_production set type_of_defect = 'Гиб детали не соответствует КД', text_of_defect = 'Гиб детали выполнен не по КД. По КД размер 25 мм и размер 20 мм. По факту 24 и 21 мм соответственно',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 148;
update defect_production set type_of_defect = 'Гиб детали не соответствует КД', text_of_defect = 'Гиб детали выполнен не по КД. По КД угол 45, по факту 30',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 137;
update defect_production set type_of_defect = 'Гиб детали не соответствует КД', text_of_defect = 'Гиб детали выполнен не по КД. По КД угол 30, по факту 60',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 247;
update defect_production set type_of_defect = 'Гиб детали не соответствует КД', text_of_defect = 'Гиб детали выполнен не по КД. По КД угол 25, по факту 30',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 120;
update defect_production set type_of_defect = 'Гиб детали не соответствует КД', text_of_defect = 'Гиб детали выполнен не по КД. По КД угол 45, по факту 60',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 266;
update defect_production set type_of_defect = 'Гиб детали не соответствует КД', text_of_defect = 'Гиб детали выполнен не по КД. По КД угол 130, по факту 60',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 110;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 230;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 221;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 251;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 214;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 117;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 246;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 253;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 238;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 141;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 243;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 250;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 146;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 154;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 202;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 222;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 297;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 220;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 271;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'По КД диаметр отверстия 7/11.5 мм, по факту 6,5/10 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 235;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'Непрокрас на боковой стороне детали',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 257;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 174;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 109;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 140;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 179;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 167;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 65;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 730;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 747;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 980;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 1;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 32;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 45;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 71;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 53;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 711;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'По КД ral 7037, по факту ral 7035',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 845;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствуют штифты 2 шт.' where shipment = 945;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствует сертификат соответствия',
solution = 'Выставить рекламацию. Допоставить недостающие компоненты' where shipment = 874;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствует сертификат соответствия',
solution = 'Выставить рекламацию. Допоставить недостающие компоненты' where shipment = 852;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствует сертификат соответствия',
solution = 'Выставить рекламацию. Допоставить недостающие компоненты' where shipment = 921;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствует сертификат соответствия' where shipment = 990;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствует сертификат соответствия',
solution = 'Выставить рекламацию. Допоставить недостающие компоненты' where shipment = 762;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствует сертификат соответствия',
solution = 'Выставить рекламацию. Допоставить недостающие компоненты' where shipment = 796;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствует сертификат соответствия',
solution = 'Выставить рекламацию. Допоставить недостающие компоненты' where shipment = 31;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствует сертификат соответствия',
solution = 'Выставить рекламацию. Допоставить недостающие компоненты' where shipment = 885;
update defect_production set type_of_defect = 'Комплектность не соответствует КД', text_of_defect = 'Отсутствует сертификат соответствия',
solution = 'Выставить рекламацию. Допоставить недостающие компоненты' where shipment = 9;
update defect_production set type_of_defect = 'Расположение отверстий не соответствует КД', text_of_defect = 'Размер расположения отверстия 8 мм не соответствует КД. По КД 30 мм, по факту 40 мм.',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 755;
update defect_production set type_of_defect = 'Расположение отверстий не соответствует КД', text_of_defect = 'Размер расположения отверстия 10 мм не соответствует КД. По КД 55 мм, по факту 56 мм.',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 21;
update defect_production set type_of_defect = 'Расположение отверстий не соответствует КД', text_of_defect = 'Размер расположения отверстия 8 мм не соответствует КД. По КД 42 мм, по факту 40 мм.',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 756;
update defect_production set type_of_defect = 'Расположение отверстий не соответствует КД', text_of_defect = 'Размер расположения отверстия 7 мм не соответствует КД. По КД 30 мм, по факту 21 мм.',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 97;
update defect_production set type_of_defect = 'Расположение отверстий не соответствует КД', text_of_defect = 'Размер расположения отверстия 5 мм не соответствует КД. По КД 30 мм, по факту 45 мм.',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 706;
update defect_production set type_of_defect = 'Расположение отверстий не соответствует КД', text_of_defect = 'Размер расположения отверстия 3 мм не соответствует КД. По КД 30 мм, по факту 8 мм.',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 5;
update defect_production set type_of_defect = 'Расположение отверстий не соответствует КД', text_of_defect = 'Размер расположения отверстия 3 мм не соответствует КД. По КД 30 мм, по факту 12 мм.',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 23;
update defect_production set type_of_defect = 'Расположение отверстий не соответствует КД', text_of_defect = 'Размер расположения отверстия 3 мм не соответствует КД. По КД 30 мм, по факту 7 мм.',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 758;
update defect_production set type_of_defect = 'Расположение отверстий не соответствует КД', text_of_defect = 'Размер расположения отверстия 4 мм не соответствует КД. По КД 80 мм, по факту 82 мм.',
solution = 'Выставить рекламацию. Списать и утилизировать' where shipment = 877;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 779;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 922;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 64;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 720;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 897;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 946;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 736;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 830;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 940;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 3;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 819;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 972;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 93;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 759;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 798;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 917;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 978;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 58;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на резьбе',
solution = 'Доработать в ЗЦ' where shipment = 957;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 959;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 24;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 715;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 741;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 872;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 16;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 955;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 944;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали' where shipment = 983;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 947;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали' where shipment = 982;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 893;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 744;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 783;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 856;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 824;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 919;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 709;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 956;
update defect_production set type_of_defect = 'Тёмный налёт/ржавчина/загрязненная поверхность', text_of_defect = 'Ржавчина на поверхности детали',
solution = 'Доработать в ЗЦ' where shipment = 12;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 787;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 953;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 977;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 25;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 883;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 853;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 912;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 29;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 84;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 725;
update defect_production set type_of_defect = 'Ширина паза не соответствует КД', text_of_defect = 'Ширина паза под стопорное кольцо не соответствует КД. По КД 1,1 мм, по факту 0,9 мм',
solution = 'Доработать в ЗЦ' where shipment = 802;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М12-LH не соответствует КД, по факту М12' where shipment = 941;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М12-LH не соответствует КД, по факту М12',
solution = 'Списать и утилизировать' where shipment = 52;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М12-LH не соответствует КД, по факту М12',
solution = 'Списать и утилизировать' where shipment = 77;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М12-LH не соответствует КД, по факту М12' where shipment = 987;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М12-LH не соответствует КД, по факту М12' where shipment = 991;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М12 не соответствует КД, по факту М10',
solution = 'Доработать в ЗЦ' where shipment = 60;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М12 не соответствует КД, по факту М10',
solution = 'Доработать в ЗЦ' where shipment = 764;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М12 не соответствует КД, по факту М10',
solution = 'Доработать в ЗЦ' where shipment = 898;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М4 не соответствует КД, по факту М6',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 86;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М4 не соответствует КД, по факту М6',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 842;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М4 не соответствует КД, по факту М6',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 860;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'Резьба М4 не соответствует КД, по факту М6',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 864;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'Отсутствует ЛКП',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 751;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'Отсутствует ЛКП',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 763;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'Отсутствует ЛКП',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 904;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'Отсутствует ЛКП',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 905;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'Отсутствует ЛКП',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 942;
update defect_production set type_of_defect = 'ЛКП не соответствует КД', text_of_defect = 'Отсутствует ЛКП',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 49;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД. По факту 22 мм.',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 748;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД. По факту 22 мм.',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 805;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД. По факту 20,3 мм.',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 809;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД. По факту 20,3 мм.',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 814;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД. По факту 20,3 мм.',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 895;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД. По факту 20,3 мм.',
solution = 'Выставить рекламацию. Вернуть поставщику' where shipment = 775;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД. По факту 20,3 мм.' where shipment = 976;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД. По факту 20,3 мм.' where shipment = 979;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 25 мм не соответствует КД. По факту 24,7 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 2;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 25 мм не соответствует КД. По факту 24,7 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 98;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 25 мм не соответствует КД. По факту 24,7 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 812;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 25 мм не соответствует КД. По факту 24,7 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 83;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 25 мм не соответствует КД. По факту 24,7 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 90;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 25 мм не соответствует КД. По факту 24,7 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 731;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 87;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 705;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 718;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 826;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 974;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 791;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 800;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 964;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 984;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 105 мм не соответствует КД. По факту 104 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 984;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 850;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 970;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 832;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 988;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 42;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 780;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 795;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 82;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 804;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 825;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 899;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 918;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', 
text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.' where shipment = 962;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 14;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 750;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 80 мм не соответствует КД. По факту 79,8 мм.',
solution = 'Выставить рекламацию. Применить' where shipment = 857;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 12 мм не соответствует КД. По факту 11,8 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 925;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 10 мм не соответствует КД. По факту 10,2 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 43;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 10 мм не соответствует КД. По факту 10,2 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 833;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', 
text_of_defect = 'Диаметр отверстия 10 мм не соответствует КД. По факту 9,8 мм' where shipment = 985;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 54;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 56;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 262;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 701;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 949;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 34;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 712;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 753;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 908;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 738;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 817;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6,3 мм не соответствует КД. По факту 6,2 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 734;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6,5 мм не соответствует КД. По факту 5,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 760;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 6,2 мм не соответствует КД. По факту 5,9 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 930;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 8 мм не соответствует КД. По факту 7,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 786;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 12 мм не соответствует КД. По факту 12,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 76;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 4 мм не соответствует КД. По факту 3,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 969;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 8 мм не соответствует КД. По факту 8,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 704;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр отверстия 8 мм не соответствует КД. По факту 8,7 мм',
solution = 'Выставить рекламацию. Применить' where shipment = 891;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6',
solution = 'Доработать по МЗК' where shipment = 20;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6' where shipment = 992;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6',
solution = 'Доработать по МЗК' where shipment = 81;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6',
solution = 'Доработать по МЗК' where shipment = 99;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6',
solution = 'Доработать по МЗК' where shipment = 882;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6',
solution = 'Доработать по МЗК' where shipment = 938;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6',
solution = 'Доработать по МЗК' where shipment = 15;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6',
solution = 'Доработать по МЗК' where shipment = 30;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6',
solution = 'Доработать по МЗК' where shipment = 870;
update defect_production set type_of_defect = 'Гальваническое покрытие не соответствует требованиям КД', text_of_defect = 'Отсутствует гальваническое покрытие: Ц6' where shipment = 997;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД.По факту 20,3 мм',
solution = 'Применить' where shipment = 794;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД.По факту 20,3 мм',
solution = 'Применить' where shipment = 951;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 30 мм не соответствует КД.По факту 30,3 мм',
solution = 'Применить' where shipment = 710;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 30 мм не соответствует КД.По факту 30,3 мм',
solution = 'Применить' where shipment = 726;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 30 мм не соответствует КД.По факту 30,3 мм',
solution = 'Применить' where shipment = 740;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 30 мм не соответствует КД.По факту 30,3 мм',
solution = 'Применить' where shipment = 916;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 30 мм не соответствует КД.По факту 30,3 мм',
solution = 'Применить' where shipment = 96;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД.По факту 20,3 мм',
solution = 'Применить' where shipment = 708;
update defect_production set type_of_defect = 'Радиус скругления не соответствует КД', text_of_defect = 'R4 не соответствует КД. По факту R3',
solution = 'Применить' where shipment = 723;
update defect_production set type_of_defect = 'Радиус скругления не соответствует КД', text_of_defect = 'R4 не соответствует КД. По факту R6',
solution = 'Применить' where shipment = 92;
update defect_production set type_of_defect = 'Радиус скругления не соответствует КД', text_of_defect = 'R4 не соответствует КД. По факту R6',
solution = 'Применить' where shipment = 858;
update defect_production set type_of_defect = 'Радиус скругления не соответствует КД', text_of_defect = 'R4 не соответствует КД. По факту R6',
solution = 'Применить' where shipment = 939;
update defect_production set type_of_defect = 'Радиус скругления не соответствует КД', text_of_defect = 'R4 не соответствует КД. По факту R6',
solution = 'Применить' where shipment = 728;
update defect_production set type_of_defect = 'Радиус скругления не соответствует КД', text_of_defect = 'R4 не соответствует КД. По факту R6',
solution = 'Применить' where shipment = 815;
update defect_production set type_of_defect = 'Радиус скругления не соответствует КД', text_of_defect = 'R4 не соответствует КД. По факту R6',
solution = 'Применить' where shipment = 915;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'М4 не соответствует КД. По факту М5',
solution = 'Применить' where shipment = 767;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'М4 не соответствует КД. По факту М5',
solution = 'Применить' where shipment = 841;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'М4 не соответствует КД. По факту М5',
solution = 'Применить' where shipment = 927;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'М4 не соответствует КД. По факту М5',
solution = 'Применить' where shipment = 966;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'М4 не соответствует КД. По факту М5',
solution = 'Применить' where shipment = 721;
update defect_production set type_of_defect = 'Резьба не соответствует КД', text_of_defect = 'М4 не соответствует КД. По факту М5',
solution = 'Применить' where shipment = 769;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 16,8 мм не соответствует КД.По факту 17 мм',
solution = 'Применить' where shipment = 41;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 16,8 мм не соответствует КД.По факту 17 мм',
solution = 'Применить' where shipment = 822;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 16,8 мм не соответствует КД.По факту 17 мм' where shipment = 934;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 16,8 мм не соответствует КД.По факту 17 мм' where shipment = 993;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 18 мм не соответствует КД.По факту 17,9 мм',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 797;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 18 мм не соответствует КД.По факту 17,9 мм',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 811;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 18 мм не соответствует КД.По факту 17,9 мм',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 849;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 18 мм не соответствует КД.По факту 17,9 мм',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 854;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 18 мм не соответствует КД.По факту 17,9 мм',
solution = 'Выставить рекламацию. Доработать в ЗЦ' where shipment = 914;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 23 мм не соответствует КД.По факту 22 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 11;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 23 мм не соответствует КД.По факту 22 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 823;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 23 мм не соответствует КД.По факту 22 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 847;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 15 мм не соответствует КД.По факту 14,9 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 10;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 15 мм не соответствует КД.По факту 14,9 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 774;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 15 мм не соответствует КД.По факту 14,9 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 906;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Диаметр 15 мм не соответствует КД.По факту 14,9 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 933;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 60 мм не соответствует КД.По факту 60,3 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 829;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 60 мм не соответствует КД.По факту 60,3 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 862;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 60 мм не соответствует КД.По факту 60,3 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 873;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 60 мм не соответствует КД.По факту 60,3 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 932;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 20 мм не соответствует КД.По факту 20,3 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 743;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 60 мм не соответствует КД.По факту 60,3 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 909;
update defect_production set type_of_defect = 'Габаритный размер не соответствует КД', text_of_defect = 'Габаритный размер 120 мм не соответствует КД.По факту 120,5 мм',
solution = 'Выставить рекламацию. Доработать по месту' where shipment = 722;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Отсутствует отверстие диметром 8 мм',
solution = 'Доработать в ЗЦ' where shipment = 13;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Отсутствует отверстие диметром 8 мм',
solution = 'Доработать в ЗЦ' where shipment = 848;
update defect_production set type_of_defect = 'Диаметр отверстий не соответствует КД', text_of_defect = 'Отсутствует отверстие диметром 8 мм',
solution = 'Доработать в ЗЦ' where shipment = 902;









