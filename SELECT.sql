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
ORDER BY EXTRACT(year FROM insurance.begin_date), branch.branch_id, COUNT(insurance.insuranceType_id) DESC



