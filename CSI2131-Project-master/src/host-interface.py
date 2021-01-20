
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
    database=config['DEFAULT']['db_name'],
    user=config['DEFAULT']['db_user'],
    password=config['DEFAULT']['db_password'],
    host=config['DEFAULT']['db_host'],
    port=config['DEFAULT']['db_port']
)


conn.autocommit = True

cursor = conn.cursor()

cursor.execute("SET SEARCH_PATH = 'main';")

try:
    while True:
        questions = [
            {
                'type': 'list',
                'name': 'query_selection',
                'message': 'Please select a query to run',
                'choices': [
                    '1) Upload a new listing',
                    '2) Query all the properties you have listed',
                    '3) END'
                ]
            }
        ]
        print()
        print()
        print()
        print()
        answers = prompt(questions)
        query_selection = answers['query_selection']
        query_selection = int(query_selection[0:query_selection.find(')')])

        if query_selection == 1:
            hid= input("Enter your host id: ")
            a=input("Enter your house number: ")
            b=input("Enter your street: ")
            c=input("Enter your city: ")
            d=input("Enter your province: ")
            e=input("Enter your country: ")
            f=input("Enter your postal code: ")
            g=input("Enter your property type: ")
            h=input("Enter your rental type: ")
            i=input("Enter your price: ")
            j=input("Enter your description: ")
            k=input("Enter your amenities: ")
            l=input("Enter your sleeping arrangement: ")
            m=input("Enter your available dates: ")



            cursor.execute('''
        INSERT INTO main.Property (addr_house_number, addr_street, addr_city, addr_province, addr_country, addr_postal_code, property_type, rental_type, price, description, amenities, sleeping_arrangement, available_dates, host_id)
        VALUES (''' + a +''', \'''' +b +'''\', \''''+c +'''\', \''''+d+'''\', \''''+e+'''\', \''''+f +'''\', \''''+ g +'''\', \''''+h+'''\', '''+ i +''', \''''+ j+'''\', \''''+ k +'''\', \''''+l +'''\', \''''+ m +'''\', '''+ hid +''');
            ''')

        elif query_selection == 2:
            hid= input("Enter your: host id :")
            cursor.execute('''
            select * from property where property.host_id='''+hid+''';
                  ''')
            for row in cursor.fetchall():
                print(f"ID: {row[0]} | address: {row[1]} {row[3]} {row[4]} {row[5]} {row[6]} | property type: {row[7]} | rental type: {row[8]} | price: {row[9]} | description: {row[10]} | amenities: {row[11]} | sleeping arrangement: {row[12]} | available dates: {row[13]} | host id : {row[14]}")
                print()


        elif query_selection == 3:
            print("Thank you and Goodbye!")
            print()
            print()
            print()
            print()
            break

except Exception as err:
    print('An exception occurred: ' + str(err))
finally:
    cursor.close()
    conn.close()
