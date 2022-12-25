LOAD DATA
INFILE 'dataGenerator/generatedData/insurance.csv'
REPLACE
INTO TABLE insurance
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
insurance_id,insurance_number,client_id,employee_id,begin_date DATE "yyyy-mm-dd",expiration_date DATE "yyyy-mm-dd",insuranceType_id,payment_id,branch_id,price
)