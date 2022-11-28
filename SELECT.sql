-- 01 ROLLUP - Baza danych
--Roczne zestawienie ilo�ci sprzedanych polis w odniesieniu do regionu i pracownik�w

SELECT  EXTRACT(year FROM insurance.begin_date) AS Rok, region_id, employee_id, count(employee_id) AS "Ilo�c sprzedanych polis"
FROM insurance
INNER JOIN employee USING (employee_id)
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), region_id, employee_id)
ORDER BY EXTRACT(year FROM insurance.begin_date), COUNT(employee_id) DESC