-- 02 Cube - Hurtownia danych
--Roczne i miesięczne zestawienie ilości sprzedanych polis w województwach
SELECT "Rok",
  region_id AS "Województwo",
  "Miesiąc",
  "Ilość sprzedanych polis"
  FROM
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS "Rok",
    EXTRACT(MONTH FROM insurance.begin_date)      AS "Miesiąc",
    region_id,
    COUNT(employee_id) AS "Ilość sprzedanych polis"
  FROM insurance
  INNER JOIN employee USING (employee_id)
  GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), EXTRACT(MONTH FROM insurance.begin_date), region_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    COUNT(employee_id) DESC
  );
  
-- 02 Cube - Hurtownia danych
-- Roczne i miesięczne zestawienie sumy wypłaconych odszkodowań, które zostały zatwierdzone
-- Dzięki zestawieniu możemy zanotować w których miesiącach i latach osiągaliśmy najwyższe zyski
SELECT EXTRACT(YEAR FROM insurance.begin_date) AS rok,
  EXTRACT(MONTH FROM insurance.begin_date)     AS miesiąc,
  SUM(claim_amount)                            AS "Suma wypłaconych odszkodowań"
FROM claim
INNER JOIN insurance USING (insurance_id)
WHERE cs_id = 0
GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), EXTRACT(MONTH FROM insurance.begin_date));

-- 02 Cube - Hurtownia danych
-- Roczne zestawienie ilości sprzedanych polis w odniesieniu do poszczególnych pracowników z podziałem na rodzaj polisy oraz sumę sprzedaży i dodatkową informację o wynagrodzeniu pracownika
-- Dzięki temu zestawieniu w łatwy sposób możemy ocenić, który pracownik osiąga największe zyski oraz jaki rodzaj sprzedawanych polis jest dla firmy najbarziej rentowny.
-- Dodatkowo możemy ocenić czy pracownik przynosi dla firmy zyski czy straty oraz porównać jak wygląda jego praca na przestrzeni lat
SELECT rok,
  employee.first_name AS "Imię",
  employee.last_name  AS "Nazwisko",
  salary              AS "Wynagrodzenie",
  "Rodzaj polisy",
  "Suma sprzedaży"
FROM employee
JOIN
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    employee.employee_id,
    NVL2(insurancetype.insurance_type, insurancetype.insurance_type, 'Wszystkie polisy') AS "Rodzaj polisy",
    SUM(insurance.price)                                                                 AS "Suma sprzedaży"
  FROM insurance
  INNER JOIN insuranceType
  ON insurance.insurancetype_id = insurancetype.insurancetype_id
  INNER JOIN employee
  ON insurance.employee_id = employee.employee_id
  GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), employee.employee_id, insurancetype.insurance_type )
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    insurancetype.insurance_type,
    SUM(insurance.price) DESC
  ) USING (employee_id);