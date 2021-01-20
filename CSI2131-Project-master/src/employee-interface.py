# Create an interface such that branch employees may lookup property listings in order to know the occupancy rate and organize operations of the properties
from PyInquirer import prompt
import json
import psycopg2
import configparser

config = configparser.ConfigParser()
config.read('database.ini')


print('           _      ____  _   _ ____  ')
print('     /\   (_)    |  _ \| \ | |  _ \ ')
print('    /  \   _ _ __| |_) |  \| | |_) |')
print('   / /\ \ | | \'__|  _ <| . ` |  _ < ')
print('  / ____ \| | |  | |_) | |\  | |_) |')
print(' /_/    \_\_|_|  |____/|_| \_|____/ ')
print()
print()                             

conn = psycopg2.connect(
    dbname=config['DEFAULT']['db_name'], 
    user=config['DEFAULT']['db_user'], 
    password=config['DEFAULT']['db_password'],
    host=config['DEFAULT']['db_host'],
    port=config['DEFAULT']['db_port']
)

cursor = conn.cursor()

cursor.execute("SET SEARCH_PATH = 'main';")

def list_properties_as_menu(properties):
    addresses = []
    counter = 1
    for row in properties:
        addresses.append(str(counter) + ') ' + str(row[1]) + ' ' + row[2] + ' ' + row[3] + ' ' + str(row[4]) + ' ' + row[5] + ' ' + row[6])
        counter += 1
        
    questions = [
        {
            'type': 'list',
            'name': 'address_selection',
            'message': 'Select a property to view additional details:',
            'choices': addresses
        }
    ]

    print()
    answers = prompt(questions)
    address_selection = answers['address_selection']
    address_selection = int(address_selection[0:address_selection.find(')')]) - 1

    print()
    print('Property Type: ' + properties[address_selection][7])
    print('Rental Type: ' + properties[address_selection][8])
    print('Price Per Night: ' + str(properties[address_selection][9]) + ' USD')
    print('Sleeping Arrangement: ' + properties[address_selection][12])
    print('Availability: ' + properties[address_selection][13])
    print('Description: ' + properties[address_selection][10])
    print('Amenities: ' + properties[address_selection][11])
    print()


try:
    while True:
        questions = [
            {
                'type': 'list',
                'name': 'query_selection',
                'message': 'Please select an action from the menu:',
                'choices': [
                    '1) List all properties',
                    '2) Find a specific property',
                    '3) Generate occupancy report',
                    '4) Exit'
                ]
            }
        ]

        answers = prompt(questions)
        query_selection = answers['query_selection'][0]
        
        if query_selection == '1':
            cursor.execute('SELECT * FROM main.Property;')
            
            list_properties_as_menu(cursor.fetchall())

            print()
            input('Press enter to continue...')
            print()
        elif query_selection == '2':
            questions = [
                {
                    'type': 'input',
                    'name': 'country',
                    'message': 'What country is the property located in?',
                    'default': 'Any Country'
                },
                {
                    'type': 'input',
                    'name': 'province',
                    'message': 'What state/province is the property located in?',
                    'default': 'Any State/Province'
                },
                {
                    'type': 'input',
                    'name': 'city',
                    'message': 'What city is the property located in?',
                    'default': 'Any City'
                },
                {
                    'type': 'list',
                    'name': 'rental_type',
                    'message': 'What rental type are you searching for?',
                    'choices': [
                        '1) Private Room',
                        '2) Full Apartment',
                        '3) Full House'
                    ]
                },
                {
                    'type': 'input',
                    'name': 'price',
                    'message': 'What is your maximum nightly budget in USD?',
                    'default': '200'
                },
                {
                    'type': 'input',
                    'name': 'amenities',
                    'message': 'What amenities do you require? Specify a comma-delimited list.',
                    'default': 'None'
                }
            ]

            print()
            answers = prompt(questions)

            if answers['country'] == 'Any Country':
                country = '%'
            else:
                country = '%' + answers['country'] + '%'

            if answers['province'] == 'Any State/Province':
                province = '%'
            else:
                province = '%' + answers['province'] + '%'

            if answers['city'] == 'Any City':
                city = '%'
            else:
                city = '%' + answers['city'] + '%'
            
            rental_type = answers['rental_type'][3:]
            price = answers['price'] 

            amenities = '%'
            if answers['amenities'] != 'None':
                for amenity in answers['amenities'].split(','):
                    amenities = amenities + amenity + '%' 

            cursor.execute('SELECT * FROM main.Property WHERE addr_country LIKE %s AND addr_province LIKE %s AND addr_city LIKE %s AND rental_type LIKE %s AND price <= %s AND amenities LIKE %s;', 
                (country, province, city, rental_type, price, amenities)
            )

            list_properties_as_menu(cursor.fetchall())

            print()
            input('Press enter to continue...')
            print()
        elif query_selection == '3':
            
            cursor.execute('SELECT * FROM main.Property;')

            for property in cursor.fetchall():
                property_address = str(property[0]) + ') ' + str(property[1]) + ' ' + property[2] + ', ' + property[3] + ', ' + str(property[4]) + ', ' + property[5]
                availability = property[13]
                print(property_address)
                print("    " + 'AVAILABILITY: ' + availability)
            
            print()
            input('Press enter to continue...')
            print()
        elif query_selection == '4':
            print('Thank you for using AirBNB!')
            break
except Exception as err:
    print('An exception occurred: ' + str(err))
finally:
    cursor.close()
    conn.close()
