import csv
import random

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

if __name__ == '__main__':
    generate_regions(regionsList)
    generate_cities(citiesList)
    generate_streets(100)
    generate_house_numbers(100)
