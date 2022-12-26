LOAD DATA
INFILE 'dataGenerator/generatedData/claim.csv'
REPLACE
INTO TABLE claim
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
claim_id,claim_name,insurance_id,claim_amount,cs_id
)