LOAD DATA
INFILE 'dataGenerator/generatedData/clientType.csv'
REPLACE
INTO TABLE clientType
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
clientType_id,clientType_name
)