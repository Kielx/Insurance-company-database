-- 05 Funkcje rankingowe - Baza danych
-- Zestawienie rankingu oddzia��w pod k�tem ilo�ci sprzedanych polis
SELECT branch_name AS "Nazwa oddzia�u",
  SUM(price)       AS "Suma sprzeda�y polis",
  COUNT(*) "Ilo�c sprzedanych polis w oddziale",
  RANK() OVER (ORDER BY SUM(price) DESC) AS "Ranking"
FROM branch
INNER JOIN insurance USING (branch_id)
GROUP BY branch_name ;


-- 05 Funkcje rankingowe - Baza danych
-- Ranking pracownik�w pod k�tem ilo�ci sprzedanych polis
SELECT first_name,
  last_name,
  "Suma sprzeda�y polis",
  "Ilosc sprzedanych polis",
  "Ranking"
FROM
  (SELECT employee_id,
    SUM(price) AS "Suma sprzeda�y polis",
    COUNT(*) "Ilosc sprzedanych polis",
    RANK() OVER (ORDER BY SUM(price) DESC) AS "Ranking"
  FROM insurance
  GROUP BY employee_id
  ) pol
LEFT JOIN employee USING (employee_id)
;


-- 05 Funkcje rankingowe - Baza danych
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
