-- 05 Funkcje rankingowe - Hurtownia danych
-- Zestawienie rankingu oddziałów pod kątem ilości sprzedanych polis
SELECT branch_name AS "Nazwa oddziału",
  SUM(price)       AS "Suma sprzedaży polis",
  COUNT(*) "Ilośc sprzedanych polis w oddziale",
  RANK() OVER (ORDER BY SUM(price) DESC) AS "Ranking"
FROM branch
INNER JOIN insurance USING (branch_id)
GROUP BY branch_name ;


-- 05 Funkcje rankingowe - Hurtownia danych
-- Ranking pracowników pod kątem ilości sprzedanych polis
SELECT first_name,
  last_name,
  "Suma sprzedaży polis",
  "Ilosc sprzedanych polis",
  "Ranking"
FROM
  (SELECT employee_id,
    SUM(price) AS "Suma sprzedaży polis",
    COUNT(*) "Ilosc sprzedanych polis",
    RANK() OVER (ORDER BY SUM(price) DESC) AS "Ranking"
  FROM insurance
  GROUP BY employee_id
  ) pol
LEFT JOIN employee USING (employee_id)


-- 05 Funkcje rankingowe - Hurtownia danych
-- Ranking na podstawie średniej cen sprzedaży polis w poszczególnych oddziałach z uwzględnieniem ilości sprzedanych polis i ilości klientów
SELECT *
FROM
  (SELECT RANK() OVER (ORDER BY AVG(price) DESC) AS Ranking,
    branch_name                                  AS "Nazwa oddziału",
    AVG(price)                                   AS "Średnia cena polisy",
    COUNT(insurance_id)                          AS "Ilośc sprzedanych polis"
  FROM branch
  INNER JOIN insurance USING (branch_id)
  GROUP BY (branch_name)
  )
INNER JOIN
  (SELECT branch_name AS "Nazwa oddziału",
    COUNT(*)          AS "Ilość klientów"
  FROM client
  INNER JOIN insurance USING (client_id)
  INNER JOIN branch USING (branch_id)
  GROUP BY (branch_name)
  ) USING ("Nazwa oddziału")
ORDER BY Ranking
