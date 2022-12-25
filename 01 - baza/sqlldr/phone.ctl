LOAD DATA
INFILE 'dataGenerator/generatedData/phone.csv'
REPLACE
INTO TABLE phone
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
phone_id,phone_number,client_id,employee_id,branch_id,phoneType_id
)