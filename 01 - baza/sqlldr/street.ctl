LOAD DATA
INFILE 'dataGenerator/generatedData/street.csv'
REPLACE
INTO TABLE street
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
street_id,street_name
)