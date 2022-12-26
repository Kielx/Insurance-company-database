@echo off

rem Script that loads previously created data into the database using sqlldr
rem To change the default values you need to call the script and enter them sequentially as command arguments
rem Run the script using a command line, e.g. cmd
rem Then we move to the folder where the script is located
rem And then run it by entering the command .\data.bat
rem This command will run it with the default user data
rem If you want to change it, enter other data, e.g. .\load_data.bat username password my_base:1521


rem Set default values for the connection
set USERNAME=kielx
set PASSWORD=d11
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
