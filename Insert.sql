INSERT INTO address (address_id, country, region, city, street, address_number) VALUES (1, 'Poland', 'Swietokrzyskie', 'Kielce', 'Kusocinskiego', '14');
INSERT INTO address (address_id, country, region, city, street, address_number) VALUES (2, 'Poland', 'Swietokrzyskie', 'Kielce', 'Sciegiennego', '231');

INSERT INTO client (client_id, first_name, last_name, date_of_birth, address_id) VALUES (1, 'Adam', 'Nogacki', TO_DATE('1993/05/03', 'yyyy/mm/dd'), 1);

INSERT INTO phoneType (phoneType_id, type_name) VALUES (1, 'Komorkowy');

INSERT INTO phone (phone_id, phone_number, client_id, phoneType_id) VALUES (1,'726940228',1,1);

INSERT INTO employee (employee_id, first_name, last_name, date_of_birth, address_id) VALUES (1, 'Kristian', 'Swiderski', TO_DATE('1983/05/03', 'yyyy/mm/dd'), 2);

INSERT INTO coverageGroup (coveragegroup_id, coveragegroup_name) VALUES (1, 'Dom');
INSERT INTO coverageGroup (coveragegroup_id, coveragegroup_name) VALUES (2, 'Samochod');

INSERT INTO feature (feature_id, feature_name, coverageGroup_id) VALUES (1, 'Ochrona przed zalaniem', 1);
INSERT INTO feature (feature_id, feature_name, coverageGroup_id) VALUES (2, 'Ochrona przed uszkodzeniem okien', 1);
INSERT INTO feature (feature_id, feature_name, coverageGroup_id) VALUES (3, 'Ochrona przed kradzie¿a', 1);

INSERT INTO feature (feature_id, feature_name, coverageGroup_id) VALUES (4, 'OC', 2);
INSERT INTO feature (feature_id, feature_name, coverageGroup_id) VALUES (5, 'AC', 2);
INSERT INTO feature (feature_id, feature_name, coverageGroup_id) VALUES (6, 'NNW', 2);

INSERT INTO coverage (coverage_id, coverage_name, coverageGroup_id, description) VALUES (1,'Ochrona domu kompleksowa', 1, 'Najnowoczesniejszy system ochrony domu');
INSERT INTO coverage (coverage_id, coverage_name, coverageGroup_id, description) VALUES (2,'Kompleksowa ochrona samochodu', 2, 'Pelny komfort dla Ciebie i rodziny');
INSERT INTO coverage (coverage_id, coverage_name, coverageGroup_id, description) VALUES (3,'Tylko OC', 2, 'Tani wariant ochrony');

INSERT INTO feature_coverage (feature_coverage_id, coverage_id, feature_id) VALUES (1,1,1);
INSERT INTO feature_coverage (feature_coverage_id, coverage_id, feature_id) VALUES (2,1,2);
INSERT INTO feature_coverage (feature_coverage_id, coverage_id, feature_id) VALUES (3,1,3);

INSERT INTO feature_coverage (feature_coverage_id, coverage_id, feature_id) VALUES (4,2,4);
INSERT INTO feature_coverage (feature_coverage_id, coverage_id, feature_id) VALUES (5,2,5);
INSERT INTO feature_coverage (feature_coverage_id, coverage_id, feature_id) VALUES (6,2,6);

INSERT INTO feature_coverage (feature_coverage_id, coverage_id, feature_id) VALUES (7,3,6);

INSERT INTO insuredItem (insureditem_id, coveragegroup_id) VALUES (1, 1);
INSERT INTO insuredItem (insureditem_id, coveragegroup_id) VALUES (2, 2);

INSERT INTO house (insureditem_id, house_name, coverageGroup_id) VALUES (1, 'Dom na przedmiesciach', 1);
INSERT INTO vehicle (insureditem_id, vehicle_name, coverageGroup_id) VALUES (2, 'Skoda Fabia', 2);

INSERT INTO insurance (insurance_id, insurance_number, client_id, employee_id, begin_date, expiration_date, coverage_id, insuredItem_id) VALUES (2,'000002',1,1, TO_DATE('2022/11/16', 'yyyy/mm/dd'),TO_DATE('2023/11/16', 'yyyy/mm/dd'),3, 1);
INSERT INTO insurance (insurance_id, insurance_number, client_id, employee_id, begin_date, expiration_date, coverage_id, insuredItem_id) VALUES (1,'000001',1,1, TO_DATE('2022/11/16', 'yyyy/mm/dd'),TO_DATE('2023/11/16', 'yyyy/mm/dd'),1, 2);

