-- 01 ROLLUP - Baza danych
--Roczne zestawienie ilo�ci sprzedanych polis w odniesieniu do regionu i pracownik�w
SELECT rok,
  NVL2(branch_name, branch_name, 'Suma') AS "Oddzia�",
  NVL2(employee.first_name, employee.first_name, 'Suma')  AS "Imie pracownika",
  NVL2(employee.last_name, employee.last_name, 'Suma')    AS "Nazwisko pracownika",
  "Ilosc sprzedanych polis"
FROM (
SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    employee_id,
    branch_id,
    COUNT(employee_id) AS "Ilosc sprzedanych polis"
  FROM insurance
  GROUP BY ROLLUP (EXTRACT(YEAR FROM insurance.begin_date), branch_id, employee_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    COUNT(employee_id) DESC
) pol
LEFT JOIN employee ON pol.employee_id = employee.employee_id
LEFT JOIN branch ON pol.branch_id = branch.branch_id;


-- 01 ROLLUP - Baza danych
--Roczne zestawienie ilo�ci sprzedanych polis w odniesieniu do oddzia�u i typu polisy
SELECT 
  NVL2(branch.branch_name, branch.branch_name, 'Suma') AS "Nazwa oddzia�u",
  Rok,
  Ilosc,
  NVL2(insuranceType.insurance_type, insuranceType.insurance_type, 'Suma') AS "Rodzaj polisy"
FROM
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    branch_id,
    insuranceType_id,
    COUNT(insurance.insuranceType_id) AS Ilosc
  FROM insurance
  GROUP BY ROLLUP (EXTRACT(YEAR FROM insurance.begin_date), branch_id, insuranceType_id )
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    COUNT(insurance.insuranceType_id) DESC,
    branch_id
  ) pol
LEFT JOIN branch ON pol.branch_id = branch.branch_id
LEFT JOIN insuranceType ON pol.insuranceType_id = insuranceType.insuranceType_id;
  

-- 01 ROLLUP - Baza danych
-- Roczne zestawienie przychodu ze sprzedanych polis w odniesieniu do poszczeg�lnych oddzia��w i pracownik�w
-- W zestawieniu widzimy jaki sumaryczny przych�d z polis w danym roku odnotowano w stosunku do wszystkich dzia��w (branch),
-- jaki w odniesieniu do poszcczeg�lnych dzia��w,
-- a jaki w odniesieniu do poszczeg�lnych pracownik�w tych dzia��w
SELECT pol.rok,
  NVL2(branch.branch_name, branch.branch_name, 'Wszystkie oddzialy')   AS "Nazwa oddzia�u",
  NVL2(employee.first_name, employee.first_name, 'Wszyscy pracownicy') AS "Imi� pracownika",
  NVL2(employee.last_name, employee.last_name, 'Wszyscy pracownicy')   AS "Nazwisko pracownika",
  pol.suma
FROM 
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    branch_id,
    employee_id,
    SUM(insurance.price) AS Suma
  FROM insurance
  GROUP BY ROLLUP (EXTRACT(YEAR FROM insurance.begin_date), branch_id, employee_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    SUM(insurance.price) DESC
  ) pol
LEFT JOIN branch ON pol.branch_id = branch.branch_id
LEFT JOIN employee ON pol.employee_id = employee.employee_id;