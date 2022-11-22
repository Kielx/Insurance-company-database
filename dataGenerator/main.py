import csv
import random

from faker import Faker

faker = Faker()
countriesList = ['Poland', 'Czechia', 'Slovakia', 'Germany', 'Austria']


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

def generate_regions(countries):
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

if __name__ == '__main__':
    generate_countries(countriesList)
