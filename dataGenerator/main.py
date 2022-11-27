import csv
from random import randrange
from datetime import date, timedelta
from faker import Faker

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


def generate_cities(cities):
    headers = ["city_id", "city_name"]
    with open("./generatedData/cities.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(len(cities)):
            writer.writerow({
                headers[0]: i,
                headers[1]: cities[i],
            })
    print(f'Successfully generated {len(cities)} cities')


def generate_streets(records):
    headers = ["street_id", "street_name"]
    with open("./generatedData/streets.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: faker.street_name()
            })
    print(f'Successfully generated {records} streets')


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


def generate_phones(records, id_start_value, client_or_employee_id_string, filename):
    headers = ["phone_id", "phone_number", client_or_employee_id_string, "phoneType_id"]
    with open(f"./generatedData/{filename}.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: id_start_value + i,
                headers[1]: faker.phone_number(),
                headers[2]: i,
                headers[3]: 1,
            })
    print(f'Successfully generated {records} {client_or_employee_id_string} phone numbers')


def generate_clients(records):
    headers = ["client_id", "first_name", "last_name", "date_of_birth", "region_id", "city_id", "street_id",
               "houseNr_id", "clientType_id", "discount"]

    with open(f"./generatedData/clients.csv", 'wt', newline='') as csvFile:
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
                headers[8]: 1,
                headers[9]: randrange(0, 50, 5)
            })
    print(f'Successfully generated {records} clients')


def generate_clientType(records):
    headers = ["clientType_id", "clientType_name"]
    clientTypes = ["retail"]

    with open(f"./generatedData/clientType.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            writer.writerow({
                headers[0]: i,
                headers[1]: clientTypes[0]
            })
    print(f'Successfully generated {records} client types')


def generate_employees(records):
    headers = ["employee_id", "first_name", "last_name", "date_of_birth", "region_id", "city_id", "street_id",
               "houseNr_id", "date_of_employment", "salary"]

    with open(f"./generatedData/employees.csv", 'wt', newline='') as csvFile:
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
                headers[8]: faker.date_between_dates(date(2010, 1, 1), date(2020, 1, 1)),
                headers[9]: randrange(2000, 4500, 100)
            })
    print(f'Successfully generated {records} employees')


def generate_branches(records):
    headers = ["branch_id", "branch_name", "region_id", "city_id", "street_id", "houseNr_id"]

    with open(f"./generatedData/branches.csv", 'wt', newline='') as csvFile:
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


def generate_insurances(records):
    headers = ["insurance_id", "insurance_number", "client_id", "employee_id", "begin_date", "expiration_date",
               "insuranceType_id", "payment_id", "branch_id", "price"]

    with open(f"./generatedData/insurances.csv", 'wt', newline='') as csvFile:
        writer = csv.DictWriter(csvFile, fieldnames=headers)
        writer.writeheader()
        for i in range(records):
            employee_id = faker.random_int(0, 1000)
            begin_date = faker.date_between_dates(date(2010, 1, 1), date(2020, 1, 1))
            expiration_date = begin_date + timedelta(days=365)
            writer.writerow({
                headers[0]: i,
                headers[1]: faker.bothify(text=f'Ube-B{i%16}/C-{i}/E-{employee_id}-####'),
                headers[2]: i,
                headers[3]: employee_id,
                headers[4]: begin_date,
                headers[5]: expiration_date,
                headers[6]: i % 4,
                headers[7]: i,
                headers[8]: i % 16,
                headers[9]: faker.random_int(300, 2500, 100)
            })
    print(f'Successfully generated {records} insurances')


if __name__ == '__main__':
    generate_regions(regionsList)
    generate_cities(citiesList)
    generate_streets(10000)
    generate_house_numbers(10000)
    generate_phoneType(1)
    generate_phones(10000, 0, "client_id", "clientPhones")
    generate_phones(1000, 10000, "employee_id", "employeePhones")
    generate_clients(10000)
    generate_clientType(1)
    generate_employees(1000)
    generate_branches(16)
    generate_insurances(10000)
