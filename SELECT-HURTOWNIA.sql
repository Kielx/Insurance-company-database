-- 01 ROLLUP - Hurtownia danych
--Roczne zestawienie ilo�ci sprzedanych polis w odniesieniu do regionu i pracownik�w
SELECT rok,
  pol.region_id AS "Wojew�dztwo",
  NVL2(employee.first_name, employee.first_name, 'Suma')  AS "Imi� pracownika",
  NVL2(employee.last_name, employee.last_name, 'Suma')    AS "Nazwisko pracownika",
  "Ilo�� sprzedanych polis"
FROM (
SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    region_id,
    employee_id,
    COUNT(employee_id) AS "Ilo�� sprzedanych polis"
  FROM insurance
  INNER JOIN employee USING (employee_id)
  GROUP BY ROLLUP (EXTRACT(YEAR FROM insurance.begin_date), region_id, employee_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    COUNT(employee_id) DESC
) pol
LEFT JOIN employee USING (employee_id);



-- 01 ROLLUP - Hurtownia danych
--Roczne zestawienie ilo�ci sprzedanych polis w odniesieniu do oddzia�u i typu polisy
SELECT EXTRACT(YEAR FROM insurance.begin_date)                                         AS Rok,
  NVL2(branch.branch_name, branch.branch_name, 'Wszystkie Oddzia�y')                   AS "Nazwa oddzia�u",
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
  

-- 01 ROLLUP - Hurtownia danych
-- Roczne zestawienie przychodu ze sprzedanych polis w odniesieniu do poszczeg�lnych oddzia��w i pracownik�w
-- W zestawieniu widzimy jaki sumaryczny przych�d z polis w danym roku odnotowano w stosunku do wszystkich dzia��w (branch),
-- jaki w odniesieniu do poszcczeg�lnych dzia��w,
-- a jaki w odniesieniu do poszczeg�lnych pracownik�w tych dzia��w
SELECT pol.rok,
  NVL2(branch.branch_name, branch.branch_name, 'Wszystkie oddzia�y')   AS "Nazwa oddzia�u",
  NVL2(employee.first_name, employee.first_name, 'Wszyscy pracownicy') AS "Imi� pracownika",
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

-- 02 Cube - Hurtownia danych
--Roczne i miesi�czne zestawienie ilo�ci sprzedanych polis w wojew�dztwach
SELECT "Rok",
  region_id AS "Wojew�dztwo",
  "Miesi�c",
  "Ilo�� sprzedanych polis"
  FROM
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS "Rok",
    EXTRACT(MONTH FROM insurance.begin_date)      AS "Miesi�c",
    region_id,
    COUNT(employee_id) AS "Ilo�� sprzedanych polis"
  FROM insurance
  INNER JOIN employee USING (employee_id)
  GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), EXTRACT(MONTH FROM insurance.begin_date), region_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    COUNT(employee_id) DESC
  );
  
-- 02 Cube - Hurtownia danych
-- Roczne i miesi�czne zestawienie sumy wyp�aconych odszkodowa�, kt�re zosta�y zatwierdzone
-- Dzi�ki zestawieniu mo�emy zanotowa� w kt�rych miesi�cach i latach osi�gali�my najwy�sze zyski
SELECT EXTRACT(YEAR FROM insurance.begin_date) AS rok,
  EXTRACT(MONTH FROM insurance.begin_date)     AS miesi�c,
  SUM(claim_amount)                            AS "Suma wyp�aconych odszkodowa�"
FROM claim
INNER JOIN insurance USING (insurance_id)
WHERE cs_id = 0
GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), EXTRACT(MONTH FROM insurance.begin_date));

-- 02 Cube - Hurtownia danych
-- Roczne zestawienie ilo�ci sprzedanych polis w odniesieniu do poszczeg�lnych pracownik�w z podzia�em na rodzaj polisy oraz sum� sprzeda�y i dodatkow� informacj� o wynagrodzeniu pracownika
-- Dzi�ki temu zestawieniu w �atwy spos�b mo�emy oceni�, kt�ry pracownik osi�ga najwi�ksze zyski oraz jaki rodzaj sprzedawanych polis jest dla firmy najbarziej rentowny.
-- Dodatkowo mo�emy oceni� czy pracownik przynosi dla firmy zyski czy straty oraz por�wna� jak wygl�da jego praca na przestrzeni lat
SELECT rok,
  employee.first_name AS "Imi�",
  employee.last_name  AS "Nazwisko",
  salary              AS "Wynagrodzenie",
  "Rodzaj polisy",
  "Suma sprzeda�y"
FROM employee
JOIN
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    employee.employee_id,
    NVL2(insurancetype.insurance_type, insurancetype.insurance_type, 'Wszystkie polisy') AS "Rodzaj polisy",
    SUM(insurance.price)                                                                 AS "Suma sprzeda�y"
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
  
-- 03 Partycje obliczeniowe - Hurtownia danych
-- Procentowe zestawienie wynagrodzenia pracownika w stosunku do �redniej wydzia�u i og�lnej
SELECT first_name                                                      AS "Imi� pracownika",
  last_name                                                            AS "Nazwisko Pracownika",
  branch_name                                                          AS "Oddzia�",
  salary                                                               AS "Wynagrodzenie",
  AVG(salary) OVER (PARTITION BY branch_id)                            AS "�rednie wynagrodzenie w oddziale",
  ROUND(salary * 100.0 / AVG(salary) OVER (PARTITION BY branch_id), 2) AS "% do �redniej wydzia�u",
  ROUND(salary * 100.0 / AVG(salary) OVER (), 2)                       AS "% do �redniej og�lnej"
FROM employee
INNER JOIN insurance USING (employee_id)
INNER JOIN branch USING (branch_id)
ORDER BY branch_id,
  salary DESC ;
  
  
-- 03 Partycje obliczeniowe - Hurtownia danych
-- Procentowe zestawienie udzia�u pracownik�w sprzeda�y polis
SELECT first_name                                                                                         AS "Imi� pracownika",
  last_name                                                                                               AS "Nazwisko Pracownika",
  branch_name                                                                                             AS "Oddzia�",
  SUM(price) OVER (PARTITION BY employee_id)                                                              AS "Suma sprzeda�y pracownika",
  SUM(price) OVER (PARTITION BY branch_id)                                                                AS "Suma sprzeda�y w oddziale",
  ROUND(SUM(price) OVER (PARTITION BY employee_id) * 100.0 / SUM(price) OVER (PARTITION BY branch_id), 2) AS "% do ca�kowitej sprzeda�y wydzia�u",
  ROUND(SUM(price) OVER (PARTITION BY employee_id) * 100.0 / SUM(price) OVER (), 2)                       AS "% do sumy og�lnej"
FROM employee
INNER JOIN insurance USING (employee_id)
INNER JOIN branch USING (branch_id)
ORDER BY branch_id,
  "% do ca�kowitej sprzeda�y wydzia�u" DESC ;
  
  
-- 03 Partycje obliczeniowe - Hurtownia danych
-- Procentowe zestawienie wyp�at z tytu�u odszkodowa� na przestrzeni dzia��w i ich procentowy udzia� w sumie wszystkich wyp�at
SELECT claim_id "Identyfikator wyp�aty",
  branch_name                                                                      AS "Nazwa oddzia�u",
  claim_amount                                                                     AS "Wielko�� wyp�aty",
  SUM(claim_amount) OVER (PARTITION BY branch_id)                                  AS "Suma wyp�at oddzia�u",
  SUM(claim_amount) OVER ()                                                        AS "Suma wszystkich wyp�at",
  ROUND(claim_amount                                    * 100.0 / SUM(claim_amount) OVER (PARTITION BY branch_id), 2) AS "% wyp�at oddzia�u",
  ROUND(SUM(claim_amount) OVER (PARTITION BY branch_id) * 100 / SUM(claim_amount) OVER (), 2)                         AS "% w sumie wyp�at"
FROM claim
INNER JOIN insurance USING (insurance_id)
INNER JOIN branch USING (branch_id)
WHERE cs_id = 0
ORDER BY branch_id,
  "% w sumie wyp�at",
  "% wyp�at oddzia�u" DESC ;
  
  
-- 04 Okna czasowe - Hurtownia danych
-- Zestawienie sumy wyp�at w okresie ostatniego kwarta�u ka�dego roku
SELECT EXTRACT (YEAR FROM begin_date)                                                                                                       AS rok,
  EXTRACT (MONTH FROM begin_date)                                                                                                           AS miesi�c,
  branch_name                                                                                                                               AS "Nazwa oddzia�u",
  insurance_number                                                                                                                          AS "Numer polisy",
  claim_amount                                                                                                                              AS "Suma wyp�aty",
  claim_name                                                                                                                                AS "Numer zg�oszenia",
  COUNT(claim_id) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)   AS "Numer wyp�aty w danym okresie roku",
  SUM(claim_amount) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Suma wyp�at w danym okresie"
FROM insurance
INNER JOIN claim USING (insurance_id)
INNER JOIN branch USING (branch_id)
WHERE EXTRACT (MONTH FROM begin_date) BETWEEN 9 AND 12
AND claim.cs_id = 0
ORDER BY EXTRACT (YEAR FROM begin_date),
  EXTRACT (MONTH FROM begin_date) ASC ;
  
  
-- 04 Okna czasowe - Hurtownia danych
-- Zestawienie sumy przychod�w oddzia��w w okresie pierwszego p�rocza ka�dego roku
SELECT EXTRACT (YEAR FROM begin_date)                                                                                                             AS rok,
  EXTRACT (MONTH FROM begin_date)                                                                                                                 AS miesi�c,
  branch_name                                                                                                                                     AS "Nazwa oddzia�u",
  insurance_number                                                                                                                                AS "Numer polisy",
  price                                                                                                                                           AS "Cena polisy",
  COUNT(insurance_number) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Numer zawartej polisy w danym okresie roku",
  SUM(price) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)              AS "Suma dotychczasowych wyp�at w danym okresie w roku"
FROM insurance
INNER JOIN claim USING (insurance_id)
INNER JOIN branch USING (branch_id)
WHERE EXTRACT (MONTH FROM begin_date) BETWEEN 1 AND 6
ORDER BY EXTRACT (YEAR FROM begin_date),
  EXTRACT (MONTH FROM begin_date),
  "Numer zawartej polisy w danym okresie roku" ASC ;
  
  
-- 04 Okna czasowe - Hurtownia danych
-- Zestawienie ilo�ci zatrudnionych pracownik�w we wszystkich oddzia�ach na przestrzeni lat
SELECT EXTRACT (YEAR FROM begin_date)                                                                                   AS rok,
  EXTRACT (MONTH FROM begin_date)                                                                                       AS miesi�c,
  first_name                                                                                                            AS "Imi� pracownika",
  last_name                                                                                                             AS "Nazwisko pracownika",
  branch_name                                                                                                           AS "Oddzia�",
  COUNT(employee_id) OVER (PARTITION BY branch_id ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Ilo�� pracownik�w zatrudnionych w oddziale",
  COUNT(employee_id) OVER (ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)                        AS "Ilo�� pracownik�w zatrudnionych we wszystkich oddzia�ach"
FROM insurance
INNER JOIN employee USING (employee_id)
INNER JOIN branch USING (branch_id)
ORDER BY EXTRACT (YEAR FROM begin_date),
  EXTRACT (MONTH FROM begin_date) ASC ;
  
  
-- 05 Funkcje rankingowe - Hurtownia danych
-- Zestawienie rankingu oddzia��w pod k�tem ilo�ci sprzedanych polis
SELECT branch_name AS "Nazwa oddzia�u",
  SUM(price)       AS "Suma sprzeda�y polis",
  COUNT(*) "Ilo�c sprzedanych polis w oddziale",
  RANK() OVER (ORDER BY SUM(price) DESC) AS "Ranking"
FROM branch
INNER JOIN insurance USING (branch_id)
GROUP BY branch_name ;


-- 05 Funkcje rankingowe - Hurtownia danych
-- Ranking pracownik�w pod k�tem ilo�ci sprzedanych polis
SELECT first_name,
  last_name,
  "Suma sprzeda�y polis",
  "Ilo�c sprzedanych polis",
  "Ranking"
FROM
  (SELECT employee_id,
    SUM(price) AS "Suma sprzeda�y polis",
    COUNT(*) "Ilo�c sprzedanych polis",
    RANK() OVER (ORDER BY SUM(price) DESC) AS "Ranking"
  FROM employee
  INNER JOIN insurance USING (employee_id)
  GROUP BY employee_id
  ) pol
LEFT JOIN employee USING (employee_id) ;


-- 05 Funkcje rankingowe - Hurtownia danych
-- Ranking na podstawie �redniej cen sprzeda�y polis w poszczeg�lnych oddzia�ach z uwzgl�dnieniem ilo�ci sprzedanych polis i ilo�ci klient�w
SELECT *
FROM
  (SELECT RANK() OVER (ORDER BY AVG(price) DESC) AS Ranking,
    branch_name                                  AS "Nazwa oddzia�u",
    AVG(price)                                   AS "�rednia cena polisy",
    COUNT(insurance_id)                          AS "Ilo�c sprzedanych polis"
  FROM branch
  INNER JOIN insurance USING (branch_id)
  GROUP BY (branch_name)
  )
INNER JOIN
  (SELECT branch_name AS "Nazwa oddzia�u",
    COUNT(*)          AS "Ilo�� klient�w"
  FROM client
  INNER JOIN insurance USING (client_id)
  INNER JOIN branch USING (branch_id)
  GROUP BY (branch_name)
  ) USING ("Nazwa oddzia�u")
ORDER BY Ranking
