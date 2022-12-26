LOAD DATA
INFILE 'dataGenerator/generatedData/houseNr.csv'
REPLACE
INTO TABLE houseNr
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
houseNr_id,houseNr_nr
)