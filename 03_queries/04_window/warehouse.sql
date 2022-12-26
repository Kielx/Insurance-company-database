-- 04 Okna czasowe - Hurtownia danych
-- Zestawienie sumy wypłat w okresie ostatniego kwartału każdego roku
SELECT EXTRACT (YEAR FROM begin_date)                                                                                                       AS rok,
  EXTRACT (MONTH FROM begin_date)                                                                                                           AS miesiąc,
  branch_name                                                                                                                               AS "Nazwa oddziału",
  insurance_number                                                                                                                          AS "Numer polisy",
  claim_amount                                                                                                                              AS "Suma wypłaty",
  claim_name                                                                                                                                AS "Numer zgłoszenia",
  COUNT(claim_id) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)   AS "Numer wypłaty w danym okresie roku",
  SUM(claim_amount) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Suma wypłat w danym okresie"
FROM insurance
INNER JOIN claim USING (insurance_id)
INNER JOIN branch USING (branch_id)
WHERE EXTRACT (MONTH FROM begin_date) BETWEEN 9 AND 12
AND claim.cs_id = 0
ORDER BY EXTRACT (YEAR FROM begin_date),
  EXTRACT (MONTH FROM begin_date) ASC ;
  
  
-- 04 Okna czasowe - Hurtownia danych
-- Zestawienie sumy przychodów oddziałów w okresie pierwszego półrocza każdego roku
SELECT EXTRACT (YEAR FROM begin_date)                                                                                                             AS rok,
  EXTRACT (MONTH FROM begin_date)                                                                                                                 AS miesiąc,
  branch_name                                                                                                                                     AS "Nazwa oddziału",
  insurance_number                                                                                                                                AS "Numer polisy",
  price                                                                                                                                           AS "Cena polisy",
  COUNT(insurance_number) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Numer zawartej polisy w danym okresie roku",
  SUM(price) OVER (PARTITION BY EXTRACT (YEAR FROM begin_date) ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)              AS "Suma dotychczasowych wypłat w danym okresie w roku"
FROM insurance
INNER JOIN claim USING (insurance_id)
INNER JOIN branch USING (branch_id)
WHERE EXTRACT (MONTH FROM begin_date) BETWEEN 1 AND 6
ORDER BY EXTRACT (YEAR FROM begin_date),
  EXTRACT (MONTH FROM begin_date),
  "Numer zawartej polisy w danym okresie roku" ASC ;
  
  
-- 04 Okna czasowe - Hurtownia danych
-- Zestawienie ilości zatrudnionych pracowników we wszystkich oddziałach na przestrzeni lat
SELECT EXTRACT (YEAR FROM begin_date)                                                                                   AS rok,
  EXTRACT (MONTH FROM begin_date)                                                                                       AS miesiąc,
  first_name                                                                                                            AS "Imię pracownika",
  last_name                                                                                                             AS "Nazwisko pracownika",
  branch_name                                                                                                           AS "Oddział",
  COUNT(employee_id) OVER (PARTITION BY branch_id ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Ilość pracowników zatrudnionych w oddziale",
  COUNT(employee_id) OVER (ORDER BY begin_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)                        AS "Ilość pracowników zatrudnionych we wszystkich oddziałach"
FROM insurance
INNER JOIN employee USING (employee_id)
INNER JOIN branch USING (branch_id)
ORDER BY EXTRACT (YEAR FROM begin_date),
  EXTRACT (MONTH FROM begin_date) ASC ;