LOAD DATA
INFILE 'dataGenerator/generatedData/phoneType.csv'
REPLACE
INTO TABLE phoneType
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
phoneType_id,type_name
)