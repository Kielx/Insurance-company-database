-- 01 ROLLUP - Hurtownia danych
--Roczne zestawienie ilo¶ci sprzedanych polis w odniesieniu do regionu i pracowników
SELECT rok,
  pol.region_id AS "Województwo",
  NVL2(employee.first_name, employee.first_name, 'Suma')  AS "Imiê pracownika",
  NVL2(employee.last_name, employee.last_name, 'Suma')    AS "Nazwisko pracownika",
  "Ilo¶æ sprzedanych polis"
FROM (
SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    region_id,
    employee_id,
    COUNT(employee_id) AS "Ilo¶æ sprzedanych polis"
  FROM insurance
  INNER JOIN employee USING (employee_id)
  GROUP BY ROLLUP (EXTRACT(YEAR FROM insurance.begin_date), region_id, employee_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    COUNT(employee_id) DESC
) pol
LEFT JOIN employee USING (employee_id);



-- 01 ROLLUP - Hurtownia danych
--Roczne zestawienie ilo¶ci sprzedanych polis w odniesieniu do oddzia³u i typu polisy
SELECT EXTRACT(YEAR FROM insurance.begin_date)                                         AS Rok,
  NVL2(branch.branch_name, branch.branch_name, 'Wszystkie Oddzia³y')                   AS "Nazwa oddzia³u",
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
-- Roczne zestawienie przychodu ze sprzedanych polis w odniesieniu do poszczególnych oddzia³ów i pracowników
-- W zestawieniu widzimy jaki sumaryczny przychód z polis w danym roku odnotowano w stosunku do wszystkich dzia³ów (branch),
-- jaki w odniesieniu do poszcczególnych dzia³ów,
-- a jaki w odniesieniu do poszczególnych pracowników tych dzia³ów
SELECT pol.rok,
  NVL2(branch.branch_name, branch.branch_name, 'Wszystkie oddzia³y')   AS "Nazwa oddzia³u",
  NVL2(employee.first_name, employee.first_name, 'Wszyscy pracownicy') AS "Imiê pracownika",
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
--Roczne i miesiêczne zestawienie ilo¶ci sprzedanych polis w województwach
SELECT "Rok",
  region_id AS "Województwo",
  "Miesi±c",
  "Ilo¶æ sprzedanych polis"
  FROM
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS "Rok",
    EXTRACT(MONTH FROM insurance.begin_date)      AS "Miesi±c",
    region_id,
    COUNT(employee_id) AS "Ilo¶æ sprzedanych polis"
  FROM insurance
  INNER JOIN employee USING (employee_id)
  GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), EXTRACT(MONTH FROM insurance.begin_date), region_id)
  ORDER BY EXTRACT(YEAR FROM insurance.begin_date),
    COUNT(employee_id) DESC
  );
  
-- 02 Cube - Hurtownia danych
-- Roczne i miesiêczne zestawienie sumy wyp³aconych odszkodowañ, które zosta³y zatwierdzone
-- Dziêki zestawieniu mo¿emy zanotowaæ w których miesi±cach i latach osi±gali¶my najwy¿sze zyski
SELECT EXTRACT(YEAR FROM insurance.begin_date) AS rok,
  EXTRACT(MONTH FROM insurance.begin_date)     AS miesi±c,
  SUM(claim_amount)                            AS "Suma wyp³aconych odszkodowañ"
FROM claim
INNER JOIN insurance USING (insurance_id)
WHERE cs_id = 0
GROUP BY CUBE (EXTRACT(YEAR FROM insurance.begin_date), EXTRACT(MONTH FROM insurance.begin_date));

-- 02 Cube - Hurtownia danych
-- Roczne zestawienie ilo¶ci sprzedanych polis w odniesieniu do poszczególnych pracowników z podzia³em na rodzaj polisy oraz sumê sprzeda¿y i dodatkow± informacjê o wynagrodzeniu pracownika
-- Dziêki temu zestawieniu w ³atwy sposób mo¿emy oceniæ, który pracownik osi±ga najwiêksze zyski oraz jaki rodzaj sprzedawanych polis jest dla firmy najbarziej rentowny.
-- Dodatkowo mo¿emy oceniæ czy pracownik przynosi dla firmy zyski czy straty oraz porównaæ jak wygl±da jego praca na przestrzeni lat
SELECT rok,
  employee.first_name AS "Imiê",
  employee.last_name  AS "Nazwisko",
  salary              AS "Wynagrodzenie",
  "Rodzaj polisy",
  "Suma sprzeda¿y"
FROM employee
JOIN
  (SELECT EXTRACT(YEAR FROM insurance.begin_date) AS Rok,
    employee.employee_id,
    NVL2(insurancetype.insurance_type, insurancetype.insurance_type, 'Wszystkie polisy') AS "Rodzaj polisy",
    SUM(insurance.price)                                                                 AS "Suma sprzeda¿y"
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
-- Procentowe zestawienie wynagrodzenia pracownika w stosunku do ¶redniej wydzia³u i ogólnej
SELECT first_name                                                      AS "Imiê pracownika",
  last_name                                                            AS "Nazwisko Pracownika",
  branch_name                                                          AS "Oddzia³",
  salary                                                               AS "Wynagrodzenie",
  AVG(salary) OVER (PARTITION BY branch_id)                            AS "¦rednie wynagrodzenie w oddziale",
  ROUND(salary * 100.0 / AVG(salary) OVER (PARTITION BY branch_id), 2) AS "% do ¶redniej wydzia³u",
  ROUND(salary * 100.0 / AVG(salary) OVER (), 2)                       AS "% do ¶redniej ogólnej"
FROM employee
INNER JOIN insurance USING (employee_id)
INNER JOIN branch USING (branch_id)
ORDER BY branch_id,
  salary DESC ;
  
  
-- 03 Partycje obliczeniowe - Hurtownia danych
-- Procentowe zestawienie udzia³u pracowników sprzeda¿y polis
SELECT first_name                                                                                         AS "Imiê pracownika",
  last_name                                                                                               AS "Nazwisko Pracownika",
  branch_name                                                                                             AS "Oddzia³",
  SUM(price) OVER (PARTITION BY employee_id)                                                              AS "Suma sprzeda¿y pracownika",
  SUM(price) OVER (PARTITION BY branch_id)                                                                AS "Suma sprzeda¿y w oddziale",
  ROUND(SUM(price) OVER (PARTITION BY employee_id) * 100.0 / SUM(price) OVER (PARTITION BY branch_id), 2) AS "% do ca³kowitej sprzeda¿y wydzia³u",
  ROUND(SUM(price) OVER (PARTITION BY employee_id) * 100.0 / SUM(price) OVER (), 2)                       AS "% do sumy ogólnej"
FROM employee
INNER JOIN insurance USING (employee_id)
INNER JOIN branch USING (branch_id)
ORDER BY branch_id,
  "% do ca³kowitej sprzeda¿y wydzia³u" DESC ;
  
  
-- 03 Partycje obliczeniowe - Hurtownia danych
-- Procentowe zestawienie wyp³at z tytu³u odszkodowañ na przestrzeni dzia³ów i ich procentowy udzia³ w sumie wszystkich wyp³at
SELECT claim_id "Identyfikator wyp³aty",
  branch_name                                                                      AS "Nazwa oddzia³u",
  claim_amount                                                                     AS "Wielko¶æ wyp³aty",
  SUM(claim_amount) OVER (PARTITION BY branch_id)                                  AS "Suma wyp³at oddzia³u",
  SUM(claim_amount) OVER ()                                                        AS "Suma wszystkich wyp³at",
  ROUND(claim_amount                                    * 100.0 / SUM(claim_amount) OVER (PARTITION BY branch_id), 2) AS "% wyp³at oddzia³u",
  ROUND(SUM(claim_amount) OVER (PARTITION BY branch_id) * 100 / SUM(claim_amount) OVER (), 2)                         AS "% w sumie wyp³at"
FROM claim
INNER JOIN insurance USING (insurance_id)
INNER JOIN branch USING (branch_id)
WHERE cs_id = 0
ORDER BY branch_id,
  "% w sumie wyp³at",
  "% wyp³at oddzia³u" DESC ;
  
  
-- 04 Okna czasowe - Hurtownia danych
-- Zestawienie sumy wyp³at w okresie ostatniego kwarta³u ka¿dego roku
SELECT EXTRACT (YEAR FROM begin_date)                                                                                                       AS rok,
  EXTRACT (MONTH FROM begin_date)                                                                                                           AS miesi±c,
  branch_name                                                                                                                               AS "Nazwa oddzia³u",
  insurance_number                                                                                                                          AS "Numer polisy",
  claim_amount                                                                                                                              AS "Suma wyp³aty",
  claim_name                                                                                                                                AS "Numer zg³oszenia",
  COUNT(claim_id) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)   AS "Numer wyp³aty w danym okresie roku",
  SUM(claim_amount) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Suma wyp³at w danym okresie"
FROM insurance
INNER JOIN claim USING (insurance_id)
INNER JOIN branch USING (branch_id)
WHERE EXTRACT (MONTH FROM begin_date) BETWEEN 9 AND 12
AND claim.cs_id = 0
ORDER BY EXTRACT (YEAR FROM begin_date),
  EXTRACT (MONTH FROM begin_date) ASC ;
  
  
-- 04 Okna czasowe - Hurtownia danych
-- Zestawienie sumy przychodów oddzia³ów w okresie pierwszego pó³rocza ka¿dego roku
SELECT EXTRACT (YEAR FROM begin_date)                                                                                                             AS rok,
  EXTRACT (MONTH FROM begin_date)                                                                                                                 AS miesi±c,
  branch_name                                                                                                                                     AS "Nazwa oddzia³u",
  insurance_number                                                                                                                                AS "Numer polisy",
  price                                                                                                                                           AS "Cena polisy",
  COUNT(insurance_number) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Numer zawartej polisy w danym okresie roku",
  SUM(price) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)              AS "Suma dotychczasowych wyp³at w danym okresie w roku"
FROM insurance
INNER JOIN claim USING (insurance_id)
INNER JOIN branch USING (branch_id)
WHERE EXTRACT (MONTH FROM begin_date) BETWEEN 1 AND 6
ORDER BY EXTRACT (YEAR FROM begin_date),
  EXTRACT (MONTH FROM begin_date),
  "Numer zawartej polisy w danym okresie roku" ASC ;
  
  
-- 04 Okna czasowe - Hurtownia danych
-- Zestawienie ilo¶ci zatrudnionych pracowników we wszystkich oddzia³ach na przestrzeni lat
SELECT EXTRACT (YEAR FROM begin_date)                                                                                   AS rok,
  EXTRACT (MONTH FROM begin_date)                                                                                       AS miesi±c,
  first_name                                                                                                            AS "Imiê pracownika",
  last_name                                                                                                             AS "Nazwisko pracownika",
  branch_name                                                                                                           AS "Oddzia³",
  COUNT(employee_id) OVER (PARTITION BY branch_id ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Ilo¶æ pracowników zatrudnionych w oddziale",
  COUNT(employee_id) OVER (ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)                        AS "Ilo¶æ pracowników zatrudnionych we wszystkich oddzia³ach"
FROM insurance
INNER JOIN employee USING (employee_id)
INNER JOIN branch USING (branch_id)
ORDER BY EXTRACT (YEAR FROM begin_date),
  EXTRACT (MONTH FROM begin_date) ASC ;
  
  
-- 05 Funkcje rankingowe - Hurtownia danych
-- Zestawienie rankingu oddzia³ów pod k±tem ilo¶ci sprzedanych polis
SELECT branch_name AS "Nazwa oddzia³u",
  SUM(price)       AS "Suma sprzeda¿y polis",
  COUNT(*) "Ilo¶c sprzedanych polis w oddziale",
  RANK() OVER (ORDER BY SUM(price) DESC) AS "Ranking"
FROM branch
INNER JOIN insurance USING (branch_id)
GROUP BY branch_name ;


-- 05 Funkcje rankingowe - Hurtownia danych
-- Ranking pracowników pod k±tem ilo¶ci sprzedanych polis
SELECT first_name,
  last_name,
  "Suma sprzeda¿y polis",
  "Ilo¶c sprzedanych polis",
  "Ranking"
FROM
  (SELECT employee_id,
    SUM(price) AS "Suma sprzeda¿y polis",
    COUNT(*) "Ilo¶c sprzedanych polis",
    RANK() OVER (ORDER BY SUM(price) DESC) AS "Ranking"
  FROM employee
  INNER JOIN insurance USING (employee_id)
  GROUP BY employee_id
  ) pol
LEFT JOIN employee USING (employee_id) ;


-- 05 Funkcje rankingowe - Hurtownia danych
-- Ranking na podstawie ¶redniej cen sprzeda¿y polis w poszczególnych oddzia³ach z uwzglêdnieniem ilo¶ci sprzedanych polis i ilo¶ci klientów
SELECT *
FROM
  (SELECT RANK() OVER (ORDER BY AVG(price) DESC) AS Ranking,
    branch_name                                  AS "Nazwa oddzia³u",
    AVG(price)                                   AS "¦rednia cena polisy",
    COUNT(insurance_id)                          AS "Ilo¶c sprzedanych polis"
  FROM branch
  INNER JOIN insurance USING (branch_id)
  GROUP BY (branch_name)
  )
INNER JOIN
  (SELECT branch_name AS "Nazwa oddzia³u",
    COUNT(*)          AS "Ilo¶æ klientów"
  FROM client
  INNER JOIN insurance USING (client_id)
  INNER JOIN branch USING (branch_id)
  GROUP BY (branch_name)
  ) USING ("Nazwa oddzia³u")
ORDER BY Ranking
