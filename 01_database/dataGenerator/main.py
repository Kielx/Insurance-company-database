import csv
from random import randrange
from datetime import date, timedelta
from faker import Faker
import os
import re


faker = Faker('pl_PL')
regionsList = ['Greater Poland (Wielkopolskie)', 'Kuyavian-Pomeranian (Kujawsko-pomorskie)',
               'Lesser Poland (Malopolskie)',
               'Lodz (Lodzkie)',
               'Lower Silesian (Dolnoslaskie)',
               'Lublin (Lubelskie)',
               'Lubusz (Lubuskie)',
               'Masovian (Mazowieckie)',
               'Opole (Opolskie)',
               'Podlasie (Podlaskie)',
               'Pomeranian (Podlaskie)',
               'Silesian (Dolnoslaskie)',
               'Subcarpathian (Podkarpackie)',
               'Swietokrzyskie (Swietokrzyskie)',
               'Warmian-Masurian (Warminsko-mazurskie)',
               'Western-Pomeranian (Zachodniopomorskie)']

citiesList = ['Poznań', 'Bydgoszcz', 'Kraków', 'Łódź', 'Wrocław', 'Lublin', 'Gorzów Wielkopolski', 'Warszawa', 'Opole',
              'Białystok', 'Gdańsk', 'Katowice', 'Rzeszów', 'Kielce', 'Olsztyn', 'Szczecin']

insurance_begin_dates = []
employee_employment_dates = []
os.remove("../load_data.bat")

bat_file_text = """@echo off

rem Script that loads previously created data into the database using sqlldr
rem To change the default values you need to call the script and enter them sequentially as command arguments
rem Run the script using a command line, e.g. cmd
rem Then we move to the folder where the script is located
rem And then run it by entering the command .\data.bat
rem This command will run it with the default user data
rem If you want to change it, enter other data, e.g. .\load_data.bat username password my_base:1521


rem Set default values for the connection
set USERNAME=kielx
set PASSWORD=d11
set CONNECTION_STRING=@//localhost:1521/XEPDB1


rem Check if cli arguments are present, if not use default values
if not "%1"=="" (
  set USERNAME=%1
) 

if not "%2"=="" (
  set PASSWORD=%2
) 

if not "%3"=="" (
  set CONNECTION_STRING=%3
) 

"""

def write_text_to_file(filename, text):
    with open(filename, 'w') as f:
        f.write(text)

def create_ctl_file(filename, headers):
    file = open(f'../sqlldr/{filename}.ctl', "w+")
    file.write("LOAD DATA\n")
    file.write(f"INFILE 'dataGenerator/generatedData/{filename}.csv'\n")
    file.write("REPLACE\n")
    file.write(f"INTO TABLE {filename}\n")
    file.write("FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"'\n")
    file.write("TRAILING NULLCOLS\n")
    file.write("(\n")
    for i in range(len(headers)):
        if re.search(r'date', headers[i], re.IGNORECASE):
            file.write(f'{headers[i]} DATE "yyyy-mm-dd"')
        else:
            file.write(headers[i])
        if i != (len(headers) - 1):
            file.write(",")
    file.write("\n)")
    file.close()
    print(f"Successfully generated {filename}.ctl file")
    bat_file = open('../load_data.bat', "a+")
    bat_file.write(f"sqlldr %USERNAME%/%PASSWORD%%CONNECTION_STRING% control='sqlldr/{filename}.ctl' log='sqlldr/logs/{filename}.log' bad='sqlldr/bads/{filename}.bad'\n")
    bat_file.close()
    print(f"Successfully appended {filename} data to load_files.bat")



"""
def generate_countries(countries):
    headers = ["country_id", "country_name"]
    with open("./generatedData/country.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(len(countries)):
            writer.writerow({
                "country_id": i,
                "country_name": countries[i],
            })
    print(f'Successfully generated {len(countries)} countries')
"""


def generate_regions(regions):
    headers = ["region_id", "region_name"]
    with open("./generatedData/region.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(len(regions)):
            writer.writerow({
                headers[0]: i,
                headers[1]: regions[i],
            })
    print(f'Successfully generated {len(regions)} regions')
    create_ctl_file("region", headers)


def generate_cities(cities):
    headers = ["city_id", "city_name"]
    with open("./generatedData/city.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(len(cities)):
            writer.writerow({
                headers[0]: i,
                headers[1]: cities[i],
            })
    print(f'Successfully generated {len(cities)} cities')
    create_ctl_file("city", headers)


def generate_streets(records):
    headers = ["street_id", "street_name"]
    with open("./generatedData/street.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: faker.street_name()
            })
    print(f'Successfully generated {records} streets')
    create_ctl_file("street", headers)


def generate_house_numbers(records):
    headers = ["houseNr_id", "houseNr_nr"]
    with open("./generatedData/houseNr.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: faker.building_number()
            })
    print(f'Successfully generated {records} house numbers')
    create_ctl_file("houseNr", headers)


def generate_phoneType(records):
    headers = ["phoneType_id", "type_name"]
    phoneTypes = ["komórkowy"]
    with open("./generatedData/phoneType.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: phoneTypes[0]
            })
    print(f'Successfully generated {records} client phone types')
    create_ctl_file("phoneType", headers)


def generate_phones(records):
    headers = ["phone_id", "phone_number", "client_id", "employee_id", "branch_id", "phoneType_id"]
    with open(f"./generatedData/phone.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: faker.phone_number(),
                headers[2]: i if (i<10000) else None,
                headers[3]: i if (i>= 10000) else None,
                headers[4]: None,
                headers[5]: 0
            })
    print(f'Successfully generated {records} phone numbers')
    create_ctl_file("phone", headers)


def generate_clients(records):
    headers = ["client_id", "first_name", "last_name", "date_of_birth", "region_id", "city_id", "street_id",
               "houseNr_id", "clientType_id", "discount"]

    with open(f"./generatedData/client.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            full_name = faker.name()
            flname = full_name.split(" ")
            firstname = flname[0]
            lastname = flname[1]

            writer.writerow({
                headers[0]: i,
                headers[1]: firstname,
                headers[2]: lastname,
                headers[3]: faker.date_of_birth(None, 18, 65),
                headers[4]: i % 16,
                headers[5]: i % 16,
                headers[6]: i,
                headers[7]: i,
                headers[8]: randrange(0, 2),
                headers[9]: randrange(0, 50, 5)
            })
    print(f'Successfully generated {records} clients')
    create_ctl_file("client", headers)


def generate_clientType(records):
    headers = ["clientType_id", "clientType_name"]
    clientTypes = ["retail", "business"]

    with open(f"./generatedData/clientType.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: clientTypes[i%2]
            })
    print(f'Successfully generated {records} client types')
    create_ctl_file("clientType", headers)


def generate_employees(records):
    headers = ["employee_id", "first_name", "last_name", "date_of_birth", "region_id", "city_id", "street_id",
               "houseNr_id", "date_of_employment", "salary"]

    with open(f"./generatedData/employee.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            full_name = faker.name()
            flname = full_name.split(" ")
            firstname = flname[0]
            lastname = flname[1]
            employment_date = faker.date_between_dates(date(2010, 1, 1), date(2020, 1, 1))
            employee_employment_dates.append(employment_date)
            writer.writerow({
                headers[0]: i,
                headers[1]: firstname,
                headers[2]: lastname,
                headers[3]: faker.date_of_birth(None, 18, 65),
                headers[4]: i % 16,
                headers[5]: i % 16,
                headers[6]: i,
                headers[7]: i,
                headers[8]: employment_date,
                headers[9]: randrange(2000, 4500, 100)
            })
    print(f'Successfully generated {records} employees')
    create_ctl_file("employee", headers)


def generate_branches(records):
    headers = ["branch_id", "branch_name", "region_id", "city_id", "street_id", "houseNr_id"]

    with open(f"./generatedData/branch.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: faker.company(),
                headers[2]: i % 16,
                headers[3]: i % 16,
                headers[4]: i % 16,
                headers[5]: i,
            })
    print(f'Successfully generated {records} branches')
    create_ctl_file("branch", headers)


def generate_insurances(records):
    headers = ["insurance_id", "insurance_number", "client_id", "employee_id", "begin_date", "expiration_date",
               "insuranceType_id", "payment_id", "branch_id", "price"]

    with open(f"./generatedData/insurance.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            employee_id = faker.random_int(0, 999)
            begin_date = faker.date_between_dates(employee_employment_dates[employee_id], date(2020, 1, 1))
            expiration_date = begin_date + timedelta(days=365)
            writer.writerow({
                headers[0]: i,
                headers[1]: faker.bothify(text=f'Ube-B{i % 16}/C-{i}/E-{employee_id}-####'),
                headers[2]: i,
                headers[3]: employee_id,
                headers[4]: begin_date,
                headers[5]: expiration_date,
                headers[6]: faker.random_int(0, 3),
                headers[7]: i,
                headers[8]: i % 16,
                headers[9]: faker.random_int(300, 2500, 100)
            })
            insurance_begin_dates.append(begin_date)
    print(f'Successfully generated {records} insurances')
    create_ctl_file("insurance", headers)


def generate_insurance_types(records):
    headers = ["insuranceType_id", "insurance_type"]
    types = ["House", "Car", "Health", "Property"]

    with open(f"./generatedData/insuranceType.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: types[i]
            })
    print(f'Successfully generated {records} insurance Types')
    create_ctl_file("insuranceType", headers)


def generate_payments(records):
    headers = ["payment_id", "payment_type", "payment_amount", "payment_date"]

    with open(f"./generatedData/payment.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: "cash",
                headers[2]: faker.random_int(300, 2500, 100),
                headers[3]: insurance_begin_dates[i],
            })
    print(f'Successfully generated {records} payments')
    create_ctl_file("payment", headers)


def generate_claims(records):
    headers = ["claim_id", "claim_name", "insurance_id", "claim_amount", "cs_id"]

    with open(f"./generatedData/claim.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: faker.bothify(text=f'{i}-????-####'),
                headers[2]: faker.random_int(0, 9999),
                headers[3]: faker.random_int(100, 25000, 100),
                headers[4]: faker.random_int(0, 2),
            })
    print(f'Successfully generated {records} claims')
    create_ctl_file("claim", headers)


def generate_claim_statuses(records):
    headers = ["cs_id", "cs_status"]
    types = ["Approved", "Pending", "Rejected"]

    with open(f"./generatedData/claimStatus.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: types[i]
            })
    print(f'Successfully generated {records} claim statuses')
    create_ctl_file("claimStatus", headers)


if __name__ == '__main__':
    write_text_to_file('../dane.bat', bat_file_text)
    generate_regions(regionsList)
    generate_cities(citiesList)
    generate_streets(10000)
    generate_house_numbers(10000)
    generate_clientType(2)
    generate_clients(10000)
    generate_employees(1000)
    generate_branches(16)
    generate_phoneType(1)
    generate_phones(11000)
    generate_insurance_types(4)
    generate_insurances(10000)
    generate_payments(10000)
    generate_claim_statuses(3)
    generate_claims(1000)



