LOAD DATA
INFILE 'dataGenerator/generatedData/branch.csv'
REPLACE
INTO TABLE branch
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
branch_id,branch_name,region_id,city_id,street_id,houseNr_id
)