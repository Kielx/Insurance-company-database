LOAD DATA
INFILE 'dataGenerator/generatedData/insuranceType.csv'
REPLACE
INTO TABLE insuranceType
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
insuranceType_id,insurance_type
)