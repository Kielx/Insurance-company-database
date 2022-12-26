-- 01 ROLLUP - Baza danych
--Roczne zestawienie ilości sprzedanych polis w odniesieniu do regionu i pracowników
SELECT rok,
  NVL2(region_name, region_name, 'Wszystkie województwa') AS "Województwo",
  NVL2(employee.first_name, employee.first_name, 'Suma')  AS "Imię pracownika",
  NVL2(employee.last_name, employee.last_name, 'Suma')    AS "Nazwisko pracownika",
  "Ilość sprzedanych polis"
FROM region
RIGHT JOIN
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    region_id,
    employee_id,
    COUNT(employee_id) AS "Ilość sprzedanych polis"
  FROM insurance
  INNER JOIN employee USING (employee_id)
  GROUP BY ROLLUP (EXTRACT(YEAR FROM insurance.begin_date), region_id, employee_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    COUNT(employee_id) DESC
  ) USING (region_id)
LEFT JOIN employee USING (employee_id) ;


-- 01 ROLLUP - Baza danych
--Roczne zestawienie ilości sprzedanych polis w odniesieniu do oddziału i typu polisy
SELECT EXTRACT(YEAR FROM insurance.begin_date)                                         AS Rok,
  NVL2(branch.branch_name, branch.branch_name, 'Wszystkie Oddziały')                   AS "Nazwa oddziału",
  NVL2(insurancetype.insurance_type, insurancetype.insurance_type, 'Wszystkie polisy') AS "Rodzaj polisy",
  COUNT(insurance.insuranceType_id)                                                    AS Ilosc
FROM insurance
INNER JOIN insuranceType
ON insurance.insurancetype_id = insurancetype.insurancetype_id
INNER JOIN branch
ON insurance.branch_id = branch.branch_id
GROUP BY ROLLUP (EXTRACT(YEAR FROM insurance.begin_date), branch.branch_name, insurancetype.insurance_type )
ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
  branch.branch_name,
  COUNT(insurance.insuranceType_id) DESC;
  

-- 01 ROLLUP - Baza danych
-- Roczne zestawienie przychodu ze sprzedanych polis w odniesieniu do poszczególnych oddziałów i pracowników
-- W zestawieniu widzimy jaki sumaryczny przychód z polis w danym roku odnotowano w stosunku do wszystkich działów (branch),
-- jaki w odniesieniu do poszcczególnych działów,
-- a jaki w odniesieniu do poszczególnych pracowników tych działów
SELECT pol.rok,
  NVL2(branch.branch_name, branch.branch_name, 'Wszystkie oddziały')   AS "Nazwa oddziału",
  NVL2(employee.first_name, employee.first_name, 'Wszyscy pracownicy') AS "Imię pracownika",
  NVL2(employee.last_name, employee.last_name, 'Wszyscy pracownicy')   AS "Nazwisko pracownika",
  pol.suma
FROM employee
RIGHT JOIN
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    insurance.branch_id,
    employee.employee_id,
    SUM(insurance.price) AS Suma
  FROM insurance
  INNER JOIN employee
  ON employee.employee_id = insurance.employee_id
  GROUP BY ROLLUP (EXTRACT(YEAR FROM insurance.begin_date), insurance.branch_id, employee.employee_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    SUM(insurance.price) DESC
  ) pol ON employee.employee_id = pol.employee_id
LEFT JOIN branch
ON pol.branch_id = branch.branch_id;