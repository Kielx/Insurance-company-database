-- 01 ROLLUP - Baza danych
--Roczne zestawienie ilo¶ci sprzedanych polis w odniesieniu do regionu i pracowników

SELECT rok, NVL2(region_name, region_name, 'Wszystkie województwa') AS "Województwo",  NVL2(employee.first_name, employee.first_name, 'Suma') AS "Imiê pracownika", NVL2(employee.last_name, employee.last_name, 'Suma') AS "Nazwisko pracownika", "Ilo¶æ sprzedanych polis" FROM region RIGHT JOIN 
(SELECT  EXTRACT(year FROM insurance.begin_date) AS Rok, region_id, employee_id, count(employee_id) AS "Ilo¶æ sprzedanych polis"
FROM insurance
INNER JOIN employee USING (employee_id)
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), region_id, employee_id)
ORDER BY EXTRACT(year FROM insurance.begin_date), COUNT(employee_id) DESC)
USING (region_id)
LEFT JOIN employee USING (employee_id)
;


-- 01 ROLLUP - Baza danych
--Roczne zestawienie ilo¶ci sprzedanych polis w odniesieniu do oddzia³u i typu polisy
SELECT  EXTRACT(year FROM insurance.begin_date) AS Rok, branch.branch_name AS "Nazwa oddzia³u", NVL2(insurancetype.insurance_type, insurancetype.insurance_type, 'Wszystkie polisy') AS "Rodzaj polisy",  count(insurance.insuranceType_id) AS Ilosc
FROM insurance
INNER JOIN insuranceType ON insurance.insurancetype_id = insurancetype.insurancetype_id
INNER JOIN branch ON insurance.branch_id = branch.branch_id
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), branch.branch_name, insurancetype.insurance_type )
ORDER BY EXTRACT(year FROM insurance.begin_date), branch.branch_name, COUNT(insurance.insuranceType_id) DESC;


-- 01 ROLLUP - Baza danych
-- Roczne zestawienie przychodu ze sprzedanych polis w odniesieniu do poszczególnych oddzia³ów i pracowników
-- W zestawieniu widzimy jaki sumaryczny przychód z polis w danym roku odnotowano w stosunku do wszystkich dzia³ów (branch), 
-- jaki w odniesieniu do poszcczególnych dzia³ów, 
-- a jaki w odniesieniu do poszczególnych pracownikó tych dzia³ów
SELECT pol.rok, NVL2(branch.branch_name, branch.branch_name, 'Wszystkie oddzia³y') AS "Nazwa oddzia³u", NVL2(employee.first_name, employee.first_name, 'Wszyscy pracownicy') AS "Imiê pracownika", NVL2(employee.last_name, employee.last_name, 'Wszyscy pracownicy') AS "Nazwisko pracownika", pol.suma  FROM employee RIGHT JOIN (
SELECT EXTRACT(year FROM insurance.begin_date) AS Rok, insurance.branch_id, employee.employee_id,  SUM(insurance.price) AS Suma
FROM insurance
INNER JOIN employee ON employee.employee_id = insurance.employee_id
GROUP BY ROLLUP (EXTRACT(year FROM insurance.begin_date), insurance.branch_id, employee.employee_id)
ORDER BY EXTRACT(year FROM insurance.begin_date), SUM(insurance.price) DESC 
) pol
ON employee.employee_id = pol.employee_id
LEFT JOIN branch ON pol.branch_id = branch.branch_id;


-- 02 Cube - Baza danych
--Roczne i miesiêczne zestawienie ilo¶ci sprzedanych polis w województwach
SELECT  "Rok", region_name AS "Województwo", "Miesi±c", "Ilo¶æ sprzedanych polis" FROM region OUTER LEFT JOIN (
SELECT EXTRACT(year FROM insurance.begin_date) AS "Rok", EXTRACT(month FROM insurance.begin_date) AS "Miesi±c", region_id, count(employee_id) AS "Ilo¶æ sprzedanych polis"
FROM insurance
INNER JOIN employee USING (employee_id)
GROUP BY CUBE (EXTRACT(year FROM insurance.begin_date), EXTRACT(month FROM insurance.begin_date), region_id)
ORDER BY EXTRACT(year FROM insurance.begin_date), COUNT(employee_id) DESC)
USING (region_id);

-- 02 Cube - Baza danych
-- Roczne i miesiêczne zestawienie sumy wyp³aconych odszkodowañ, które zosta³y zatwierdzone oraz sumy zarobków, a tak¿e obliczonego przychodu netto z tytu³u prowadzonej dzia³alno¶ci
-- Zauwa¿yæ mo¿emy, ¿e nasza firma na przestrzeni 10 lat przynios³a ponad 3mln z³otych strat z samej sprzeda¿y polis, a jedynym miesi±cem, gdzie uda³o siê osi±gn±c jakiekolwiek zyski by³ maj 2011r.
-- Dziêki zestawieniu mo¿na w jasny sposób zauwa¿yæ, ¿e w celu osi±gniêcia zysków konieczne jest albo podniesienie cen polis, albo obni¿enie sum wyp³acanych odszkodowañ
SELECT EXTRACT(year FROM insurance.begin_date) AS rok, EXTRACT(month FROM insurance.begin_date) as miesi±c, SUM(claim_amount) AS "Suma wyp³aconych odszkodowañ", SUM(price) "Suma przychodu z sprzeda¿y polis",  SUM(price) - SUM(claim_amount) AS "Przychód netto" FROM claim
INNER JOIN claimstatus USING (cs_id)
INNER JOIN insurance USING (insurance_id)
WHERE cs_status = 'Approved'
GROUP BY CUBE (EXTRACT(year FROM insurance.begin_date), EXTRACT(month FROM insurance.begin_date));

-- 02 Cube - Baza danych
-- Roczne zestawienie ilo¶ci sprzedanych polis w odniesieniu do poszczególnych pracowników z podzia³em na rodzaj polisy oraz sumê sprzeda¿y i dodatkow± informacjê o wynagrodzeniu pracownika
-- Dziêki temu zestawieniu w ³atwy sposób mo¿emy oceniæ, który pracownik osi±ga najwiêksze zyski oraz jaki rodzaj sprzedawanych polis jest dla firmy najbardziej rentowny.
-- Dodatkowo mo¿emy oceniæ czy pracownik przynosi dla firmy zyski czy straty oraz porównaæ jak wygl±da jego praca na przestrzeni lat
SELECT rok, employee.first_name AS "Imiê", employee.last_name AS "Nazwisko", salary AS "Wynagrodzenie", "Rodzaj polisy", "Suma sprzeda¿y"  FROM employee JOIN (
SELECT  EXTRACT(year FROM insurance.begin_date) AS Rok, employee.employee_id, NVL2(insurancetype.insurance_type, insurancetype.insurance_type, 'Wszystkie polisy') AS "Rodzaj polisy",  SUM(insurance.price) AS "Suma sprzeda¿y"
FROM insurance
INNER JOIN insuranceType ON insurance.insurancetype_id = insurancetype.insurancetype_id
INNER JOIN employee ON insurance.employee_id = employee.employee_id
GROUP BY CUBE (EXTRACT(year FROM insurance.begin_date), employee.employee_id, insurancetype.insurance_type )
ORDER BY EXTRACT(year FROM insurance.begin_date), insurancetype.insurance_type,  SUM(insurance.price) DESC
)
USING (employee_id)
