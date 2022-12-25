LOAD DATA
INFILE 'dataGenerator/generatedData/payment.csv'
REPLACE
INTO TABLE payment
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
payment_id,payment_type,payment_amount,payment_date DATE "yyyy-mm-dd"
)