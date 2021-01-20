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

try:
    while True:
        questions = [
            {
                'type': 'list',
                'name': 'query_selection',
                'message': 'Please select a query to run',
                'choices': [
                    '1) see all the listings',
                    '2) END'
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
            cursor.execute('''
            select * from property;
                  ''')
            for row in cursor.fetchall():
                print(f"ID: {row[0]} | address: {row[1]} {row[3]} {row[4]} {row[5]} {row[6]} | property type: {row[7]} | rental type: {row[8]} | price: {row[9]} | description: {row[10]} | amenities: {row[11]} | sleeping arrangement: {row[12]} | available dates: {row[13]} | host id : {row[14]}")
                print()


        elif query_selection == 2:
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
