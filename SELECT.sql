-- 01 ROLLUP - Baza danych
--Roczne zestawienie ilo�ci sprzedanych polis w odniesieniu do regionu i pracownik�w

SELECT rok, NVL2(region_name, region_name, 'Wszystkie wojew�dztwa') AS "Wojew�dztwo",  NVL2(employee.first_name, employee.first_name, 'Suma') AS "Imi� pracownika", NVL2(employee.last_name, employee.last_name, 'Suma') AS "Nazwisko pracownika", "Ilo�� sprzedanych polis" FROM region RIGHT JOIN 
(SELECT  EXTRACT(year FROM insurance.begin_date) AS Rok, region_id, employee_id, count(employee_id) AS "Ilo�� sprzedanych polis"
FROM insurance
INNER JOIN employee USING (employee_id)
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), region_id, employee_id)
ORDER BY EXTRACT(year FROM insurance.begin_date), COUNT(employee_id) DESC)
USING (region_id)
LEFT JOIN employee USING (employee_id)
;


-- 01 ROLLUP - Baza danych
--Roczne zestawienie ilo�ci sprzedanych polis w odniesieniu do oddzia�u i typu polisy

SELECT  EXTRACT(year FROM insurance.begin_date) AS Rok, branch.branch_name AS "Nazwa oddzia�u", NVL2(insurancetype.insurance_type, insurancetype.insurance_type, 'Wszystkie polisy') AS "Rodzaj polisy",  count(insurance.insuranceType_id) AS Ilosc
FROM insurance
INNER JOIN insuranceType ON insurance.insurancetype_id = insurancetype.insurancetype_id
INNER JOIN branch ON insurance.branch_id = branch.branch_id
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), branch.branch_name, insurancetype.insurance_type )
ORDER BY EXTRACT(year FROM insurance.begin_date), branch.branch_name, COUNT(insurance.insuranceType_id) DESC;


-- 01 ROLLUP - Baza danych
-- Roczne zestawienie przychodu ze sprzedanych polis w odniesieniu do poszczeg�lnych oddzia��w i pracownik�w
-- W zestawieniu widzimy jaki sumaryczny przych�d z polis w danym roku odnotowano w stosunku do wszystkich dzia��w (branch), 
-- jaki w odniesieniu do poszcczeg�lnych dzia��w, 
-- a jaki w odniesieniu do poszczeg�lnych pracownik� tych dzia��w
SELECT pol.rok, NVL2(branch.branch_name, branch.branch_name, 'Wszystkie oddzia�y') AS "Nazwa oddzia�u", NVL2(employee.first_name, employee.first_name, 'Wszyscy pracownicy') AS "Imi� pracownika", NVL2(employee.last_name, employee.last_name, 'Wszyscy pracownicy') AS "Nazwisko pracownika", pol.suma  FROM employee RIGHT JOIN (
SELECT EXTRACT(year FROM insurance.begin_date) AS Rok, insurance.branch_id, employee.employee_id,  SUM(insurance.price) AS Suma
FROM insurance
INNER JOIN employee ON employee.employee_id = insurance.employee_id
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), insurance.branch_id, employee.employee_id)
ORDER BY EXTRACT(year FROM insurance.begin_date), SUM(insurance.price) DESC 
) pol
ON employee.employee_id = pol.employee_id
LEFT JOIN branch ON pol.branch_id = branch.branch_id;


-- 02 Cube - Baza danych
--Roczne i miesi�czne zestawienie ilo�ci sprzedanych polis w wojew�dztwach
SELECT  "Rok", region_name AS "Wojew�dztwo", "Miesi�c", "Ilo�� sprzedanych polis" FROM region OUTER LEFT JOIN (
SELECT EXTRACT(year FROM insurance.begin_date) AS "Rok", EXTRACT(month FROM insurance.begin_date) AS "Miesi�c", region_id, count(employee_id) AS "Ilo�� sprzedanych polis"
FROM insurance
INNER JOIN employee USING (employee_id)
GROUP BY CUBE (EXTRACT(year FROM insurance.begin_date), EXTRACT(month FROM insurance.begin_date), region_id)
ORDER BY EXTRACT(year FROM insurance.begin_date), COUNT(employee_id) DESC)
USING (region_id);
