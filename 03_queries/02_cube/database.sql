-- 02 Cube - Baza danych
--Roczne i miesięczne zestawienie ilości sprzedanych polis w województwach
SELECT 
  "Rok",
   NVL2(branch_name, branch_name, 'Wszystkie oddzialy') AS "Oddzial",
  "Miesiac",
  "Ilosc sprzedanych polis"
FROM
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS "Rok",
    EXTRACT(MONTH FROM insurance.begin_date)      AS "Miesiac",
    branch_id,
    COUNT(employee_id) AS "Ilosc sprzedanych polis"
  FROM insurance
  GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), EXTRACT(MONTH FROM insurance.begin_date), branch_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    COUNT(employee_id) DESC
  ) pol
LEFT JOIN branch ON pol.branch_id = branch.branch_id; 
  
-- 02 Cube - Baza danych
-- Roczne i miesięczne zestawienie sumy wypłaconych odszkodowań, które zostały zatwierdzone
-- Dzięki zestawieniu możemy zanotować w których miesiącach i latach osiągaliśmy najwyższe zyski
SELECT EXTRACT(YEAR FROM insurance.begin_date) AS rok,
  EXTRACT(MONTH FROM insurance.begin_date)     AS miesiąc,
  SUM(claim_amount)                            AS "Suma wypłaconych odszkodowań"
FROM claim
INNER JOIN claimstatus USING (cs_id)
INNER JOIN insurance USING (insurance_id)
WHERE cs_status = 'Approved'
GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), EXTRACT(MONTH FROM insurance.begin_date));

-- 02 Cube - Baza danych
-- Roczne zestawienie ilości sprzedanych polis w odniesieniu do poszczególnych pracowników z podziałem na rodzaj polisy oraz sumę sprzedaży i dodatkową informację o wynagrodzeniu pracownika
-- Dzięki temu zestawieniu w łatwy sposób możemy ocenić, który pracownik osiąga największe zyski oraz jaki rodzaj sprzedawanych polis jest dla firmy najbarziej rentowny.
-- Dodatkowo możemy ocenić czy pracownik przynosi dla firmy zyski czy straty oraz porównać jak wygląda jego praca na przestrzeni lat
SELECT rok,
  NVL2(employee.first_name, employee.first_name, 'Suma') AS "Imię",
  NVL2(employee.last_name, employee.last_name, 'Suma') AS "Nazwisko",
  salary              AS "Wynagrodzenie",
  NVL2(insurancetype.insurance_type, insurancetype.insurance_type, 'Wszystkie polisy') AS "Rodzaj polisy",
  "Suma sprzedaży" FROM
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    employee_id,
    insuranceType_id,
    SUM(insurance.price)                                                                 AS "Suma sprzedaży"
  FROM insurance
  GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), employee_id, insuranceType_id )
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
      SUM(insurance.price) DESC,
    insuranceType_id

  ) pol 
LEFT JOIN employee ON pol.employee_id = employee.employee_id
LEFT JOIN insuranceType ON pol.insuranceType_id = insuranceType.insuranceType_id;
  ) USING (employee_id);