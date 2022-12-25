LOAD DATA
INFILE 'dataGenerator/generatedData/region.csv'
REPLACE
INTO TABLE region
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
region_id,region_name
)