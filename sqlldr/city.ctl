LOAD DATA
INFILE '../dataGenerator/generatedData/city.csv'
REPLACE
INTO TABLE city
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
city_id,city_name
)