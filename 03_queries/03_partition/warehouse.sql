-- 03 Partycje obliczeniowe - Hurtownia danych
-- Procentowe zestawienie wynagrodzenia pracownika w stosunku do średniej wydziału i ogólnej
SELECT first_name                                                      AS "Imię pracownika",
  last_name                                                            AS "Nazwisko Pracownika",
  branch_name                                                          AS "Oddział",
  salary                                                               AS "Wynagrodzenie",
  AVG(salary) OVER (PARTITION BY branch_id)                            AS "Średnie wynagrodzenie w oddziale",
  ROUND(salary * 100.0 / AVG(salary) OVER (PARTITION BY branch_id), 2) AS "% do średniej wydziału",
  ROUND(salary * 100.0 / AVG(salary) OVER (), 2)                       AS "% do średniej ogólnej"
FROM employee
INNER JOIN insurance USING (employee_id)
INNER JOIN branch USING (branch_id)
ORDER BY branch_id,
  salary DESC ;
  
  
-- 03 Partycje obliczeniowe - Hurtownia danych
-- Procentowe zestawienie udziału pracowników sprzedaży polis
SELECT first_name                                                                                         AS "Imię pracownika",
  last_name                                                                                               AS "Nazwisko Pracownika",
  branch_name                                                                                             AS "Oddział",
  SUM(price) OVER (PARTITION BY employee_id)                                                              AS "Suma sprzedaży pracownika",
  SUM(price) OVER (PARTITION BY branch_id)                                                                AS "Suma sprzedaży w oddziale",
  ROUND(SUM(price) OVER (PARTITION BY employee_id) * 100.0 / SUM(price) OVER (PARTITION BY branch_id), 2) AS "% do całkowitej sprzedaży wydziału",
  ROUND(SUM(price) OVER (PARTITION BY employee_id) * 100.0 / SUM(price) OVER (), 2)                       AS "% do sumy ogólnej"
FROM employee
INNER JOIN insurance USING (employee_id)
INNER JOIN branch USING (branch_id)
ORDER BY branch_id,
  "% do całkowitej sprzedaży wydziału" DESC ;
  
  
-- 03 Partycje obliczeniowe - Hurtownia danych
-- Procentowe zestawienie wypłat z tytułu odszkodowań na przestrzeni działów i ich procentowy udział w sumie wszystkich wypłat
SELECT claim_id "Identyfikator wypłaty",
  branch_name                                                                      AS "Nazwa oddziału",
  claim_amount                                                                     AS "Wielkość wypłaty",
  SUM(claim_amount) OVER (PARTITION BY branch_id)                                  AS "Suma wypłat oddziału",
  SUM(claim_amount) OVER ()                                                        AS "Suma wszystkich wypłat",
  ROUND(claim_amount                                    * 100.0 / SUM(claim_amount) OVER (PARTITION BY branch_id), 2) AS "% wypłat oddziału",
  ROUND(SUM(claim_amount) OVER (PARTITION BY branch_id) * 100 / SUM(claim_amount) OVER (), 2)                         AS "% w sumie wypłat"
FROM claim
INNER JOIN insurance USING (insurance_id)
INNER JOIN branch USING (branch_id)
WHERE cs_id = 0
ORDER BY branch_id,
  "% w sumie wypłat",
  "% wypłat oddziału" DESC ;