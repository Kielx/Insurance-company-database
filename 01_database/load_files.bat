@echo off

rem Skrypt ³aduj¹cy utworzony wczeœniej dane do bazy za pomoc¹ sqlldr
rem By zmienic domyslne wartosci nalezy wywolac skrypt i wprowadzic je kolejno jako argumenty polecenia
rem Skrypt uruchamiamy za pomoca wiersza polecen np. cmd
rem Nastepnie przechodzimy do folderu gdzie znajduje sie skrypt
rem A pozniej uruchamiamy go poprzez wprowadzenie komendy .\dane.bat
rem Ta komenda uruchomi go z domyslnymi danymi uzytkownika
rem Jesli chcemy je zmienic wprowadzamy inne np. .\dane.bat kamil tajnehaslo mojabaza:1521


rem Ustawiamy domyœlne wartoœci dla po³¹czenia
set USERNAME=test
set PASSWORD=test
set CONNECTION_STRING=@//localhost:1521/XEPDB1

rem Sprawdzamy czy wartoœci
if not "%1"=="" (
  set USERNAME=%1
) 

if not "%2"=="" (
  set PASSWORD=%2
) 

if not "%3"=="" (
  set CONNECTION_STRING=%3
) 

sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/region.ctl' log='sqlldr/logs/region.log' bad='sqlldr/bads/region.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/city.ctl' log='sqlldr/logs/city.log' bad='sqlldr/bads/city.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/street.ctl' log='sqlldr/logs/street.log' bad='sqlldr/bads/street.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/houseNr.ctl' log='sqlldr/logs/houseNr.log' bad='sqlldr/bads/houseNr.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/clientType.ctl' log='sqlldr/logs/clientType.log' bad='sqlldr/bads/clientType.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/client.ctl' log='sqlldr/logs/client.log' bad='sqlldr/bads/client.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/employee.ctl' log='sqlldr/logs/employee.log' bad='sqlldr/bads/employee.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/branch.ctl' log='sqlldr/logs/branch.log' bad='sqlldr/bads/branch.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/phoneType.ctl' log='sqlldr/logs/phoneType.log' bad='sqlldr/bads/phoneType.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/phone.ctl' log='sqlldr/logs/phone.log' bad='sqlldr/bads/phone.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/payment.ctl' log='sqlldr/logs/payment.log' bad='sqlldr/bads/payment.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/insuranceType.ctl' log='sqlldr/logs/insuranceType.log' bad='sqlldr/bads/insuranceType.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/insurance.ctl' log='sqlldr/logs/insurance.log' bad='sqlldr/bads/insurance.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/claimStatus.ctl' log='sqlldr/logs/claimStatus.log' bad='sqlldr/bads/claimStatus.bad'
sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/claim.ctl' log='sqlldr/logs/claim.log' bad='sqlldr/bads/claim.bad'
