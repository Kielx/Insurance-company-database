LOAD DATA
INFILE 'dataGenerator/generatedData/client.csv'
REPLACE
INTO TABLE client
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
client_id,first_name,last_name,date_of_birth DATE "yyyy-mm-dd",region_id,city_id,street_id,houseNr_id,clientType_id,discount
)