LOAD DATA
INFILE 'dataGenerator/generatedData/claimStatus.csv'
REPLACE
INTO TABLE claimStatus
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
cs_id,cs_status
)