-- 01 ROLLUP - Baza danych
--Roczne zestawienie iloœci sprzedanych polis w odniesieniu do regionu i pracowników

SELECT  EXTRACT(year FROM insurance.begin_date) AS Rok, region_id, employee_id, count(employee_id) AS "Iloœc sprzedanych polis"
FROM insurance
INNER JOIN employee USING (employee_id)
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), region_id, employee_id)
ORDER BY EXTRACT(year FROM insurance.begin_date), COUNT(employee_id) DESC;


-- 01 ROLLUP - Baza danych
--Roczne zestawienie iloœci sprzedanych polis w odniesieniu do oddzia³u i typu polisy

SELECT  EXTRACT(year FROM insurance.begin_date) AS Rok, branch.branch_id, insurancetype.insurance_type,  count(insurance.insuranceType_id) AS Ilosc
FROM insurance
INNER JOIN insuranceType ON insurance.insurancetype_id = insurancetype.insurancetype_id
INNER JOIN branch ON insurance.branch_id = branch.branch_id
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), branch.branch_id, insurancetype.insurance_type )
ORDER BY EXTRACT(year FROM insurance.begin_date), branch.branch_id, COUNT(insurance.insuranceType_id) DESC;


-- 01 ROLLUP - Baza danych
-- Roczne zestawienie przychodu ze sprzedanych polis w odniesieniu do poszczególnych oddzia³ów i pracowników
-- W zestawieniu widzimy jaki sumaryczny przychód z polis w danym roku odnotowano w stosunku do wszystkich dzia³ów (branch), 
-- jaki w odniesieniu do poszcczególnych dzia³ów, 
-- a jaki w odniesieniu do poszczególnych pracownikó tych dzia³ów
SELECT pol.rok, pol.branch_id, employee.first_name, employee.last_name, pol.suma  FROM employee RIGHT JOIN (
SELECT EXTRACT(year FROM insurance.begin_date) AS Rok, insurance.branch_id, employee.employee_id,  SUM(insurance.price) AS Suma
FROM insurance
INNER JOIN employee ON employee.employee_id = insurance.employee_id
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), insurance.branch_id, employee.employee_id)
ORDER BY EXTRACT(year FROM insurance.begin_date), SUM(insurance.price) DESC 
) pol
ON employee.employee_id = pol.employee_id

