LOAD DATA
INFILE 'dataGenerator/generatedData/employee.csv'
REPLACE
INTO TABLE employee
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
employee_id,first_name,last_name,date_of_birth DATE "yyyy-mm-dd",region_id,city_id,street_id,houseNr_id,date_of_employment DATE "yyyy-mm-dd",salary
)