-- 02 Cube - Hurtownia danych
--Roczne i miesieczne zestawienie ilosci sprzedanych polis w oddzialach
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
  
-- 02 Cube - Hurtownia danych
-- Roczne i miesi�czne zestawienie sumy wyp�aconych odszkodowa�, kt�re zosta�y zatwierdzone
-- Dzi�ki zestawieniu mo�emy zanotowa� w kt�rych miesi�cach i latach osi�gali�my najwy�sze zyski
SELECT EXTRACT(YEAR FROM insurance.begin_date) AS rok,
  EXTRACT(MONTH FROM insurance.begin_date)     AS miesi�c,
  SUM(claim_amount)                            AS "Suma wyp�aconych odszkodowa�"
FROM insurance
INNER JOIN claim USING (insurance_id)
WHERE cs_id = 0
GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), EXTRACT(MONTH FROM insurance.begin_date));

-- 02 Cube - Hurtownia danych
-- Roczne zestawienie ilo�ci sprzedanych polis w odniesieniu do poszczeg�lnych pracownik�w z podzia�em na rodzaj polisy oraz sum� sprzeda�y i dodatkow� informacj� o wynagrodzeniu pracownika
-- Dzi�ki temu zestawieniu w �atwy spos�b mo�emy oceni�, kt�ry pracownik osi�ga najwi�ksze zyski oraz jaki rodzaj sprzedawanych polis jest dla firmy najbarziej rentowny.
-- Dodatkowo mo�emy oceni� czy pracownik przynosi dla firmy zyski czy straty oraz por�wna� jak wygl�da jego praca na przestrzeni lat
SELECT rok,
  NVL2(employee.first_name, employee.first_name, 'Suma') AS "Imi�",
  NVL2(employee.last_name, employee.last_name, 'Suma') AS "Nazwisko",
  salary              AS "Wynagrodzenie",
  NVL2(insurancetype.insurance_type, insurancetype.insurance_type, 'Wszystkie polisy') AS "Rodzaj polisy",
  "Suma sprzeda�y" FROM
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    employee_id,
    insuranceType_id,
    SUM(insurance.price)                                                                 AS "Suma sprzeda�y"
  FROM insurance
  GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), employee_id, insuranceType_id )
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
      SUM(insurance.price) DESC,
    insuranceType_id

  ) pol 
LEFT JOIN employee ON pol.employee_id = employee.employee_id
LEFT JOIN insuranceType ON pol.insuranceType_id = insuranceType.insuranceType_id;
  ) USING (employee_id);