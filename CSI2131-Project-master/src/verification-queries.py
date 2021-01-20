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
                    '1) Query details of all guests who rented properties',
                    '2) Query the GuestListView',
                    '3) Query details of the cheapest completed rental',
                    '4) Query details of all properties rented',
                    '5) Query details of all properties listed but not yet rented',
                    '6) Query details of all properties rented on the 10th day of any month',
                    '7) Query details of all managers and employees with salary greater than or equal to 15000',
                    '8) Generate bill for guest',
                    '9) Update guest phone number',
                    '10) Concatenate names for guest',
                    '11) END'
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
        SELECT p.payment_type,r.start_date as signing_date,g.first_name,g.middle_name,g.last_name,k.property_type ,k.price,h.addr_country as branch,m.status
        FROM Reservation r inner JOIN Guest g ON r.guest_id=g.id left join paymentmethod p on g.id=p.guest_id inner join property k on k.id =r.property_id inner join host h on h.id=k.host_id left join payment m on m.reservation_id=r.id 
        order by p.payment_type asc, r.start_date desc;
    
            ''')

            for row in cursor.fetchall():
                print(f"|payment type: {row[0]} | start date: {row[1]} | first name: {row[2]} | middle name: {row[3]} | last name: {row[4]} | property type: {row[5]} | price: {row[6]} | branch: {row[7]} | status: {row[8]}")
                print()

        elif query_selection == 2:
            cursor.execute('''
        create or replace view detailguests as select b.country,g.id,g.first_name,g.middle_name,g.last_name,g.bday_day,g.bday_month,g.bday_year,g.addr_house_number,g.addr_street,g.addr_city,g.addr_province,g.addr_country
        from guest g left join reservation r on g.id=r.guest_id left join property p on r.property_id = p.id left join host h on h.id=p.host_id left join branch b on h.addr_country =b.country order by b.country, g.id;
    
        select * from detailguests;
                  ''')
            for row in cursor.fetchall():
                print(f"country: {row[0]} | ID: {row[1]} | first name: {row[2]} | middle name: {row[3]} | last name: {row[4]} | birthday(dd,mm.year): {row[5]}/{row[6]}/{row[7]} | address: {row[8]} {row[9]} {row[10]} {row[11]} {row[12]}")
                print()
        elif query_selection == 3:
            cursor.execute('''
        select * 
        from payment 
        where amount =( 
            select min(amount) 
            from payment)
            and status = 'paid';
                  ''')
            for row in cursor.fetchall():
                print(f"|payment id: {row[0]} | status: {row[1]} | amount: {row[2]} | reservation id: {row[3]} | payment method id: {row[4]}" )
                print()
        elif query_selection == 4:
            cursor.execute('''
    
        select h.addr_country, (a.cleanliness+a.communication+a.check_in+a.accuracy+a.location+a.value)/6 as reviews, p.addr_house_number,p.addr_street ,p.addr_city ,p.addr_province ,p.addr_country,p.addr_postal_code,p.property_type ,p.rental_type,p.price,p.description ,p.amenities ,p.sleeping_arrangement ,p.available_dates ,p.host_id
        from reservation r inner join property p  on p.id = r.property_id inner join host h on p.host_id=h.id left join review a on r.id = a.reservation_id
        order by h.addr_country, reviews;
    
                  ''')
            for row in cursor.fetchall():
                print(f"branch: {row[0]} | ave. review rating: {row[1]} | address: {row[2]} {row[3]} {row[4]} {row[5]} {row[6]} {row[7]} | property type: {row[8]} | rental type: {row[9]}| price: {row[10]} | description: {row[11]} | amenities: {row[12]} | sleeping arrangement {row[13]} | available dates {row[14]} | host id : {row[15]}")
                print()
        elif query_selection == 5:
            cursor.execute('''
        select distinct p.addr_street ,p.addr_city ,p.addr_province ,p.addr_country,p.addr_postal_code,p.property_type ,p.rental_type,p.price,p.description ,p.amenities ,p.sleeping_arrangement ,p.available_dates ,p.host_id
        from property p inner join reservation r on p.id != r.property_id;
    
                  ''')
            for row in cursor.fetchall():
                print(f"address: {row[0]} {row[1]} {row[2]} {row[3]} {row[4]} | property type: {row[5]} | rental type: {row[6]}| price: {row[7]} | description: {row[8]} | amenities: {row[9]} | sleeping arrangement {row[10]} | available dates {row[11]} | host id : {row[12]}")
                print()
        elif query_selection == 6:
            cursor.execute('''
        select * from property p inner join reservation r on p.id=r.property_id where 10= EXTRACT(day FROM r.start_date);
    
                  ''')
            for row in cursor.fetchall():
                print(f"ID: {row[0]} | address: {row[1]} {row[3]} {row[4]} {row[5]} {row[6]} | property type: {row[7]} | rental type: {row[8]} | price: {row[9]} | description: {row[10]} | amenities: {row[11]} | sleeping arrangement: {row[12]} | available dates: {row[13]} | host id : {row[14]}")
                print()
        elif query_selection == 7:
            cursor.execute('''
        select e.id,e.salary,e.first_name, e.middle_name, e.last_name, e.title, b.country as branch_id, b.branch_manager_id as branch_name 
        from employee e, branch b 
        where b.country=e.branch_country and e.salary>=15000 
        order by case e.title when 'Manager' then 1 else 2 end,e.id; 
    
                  ''')
            for row in cursor.fetchall():
                print(f"id: {row[0]}  salary: {row[1]} | first name: {row[2]} | middle name: {row[3]} | last name: {row[4]} | title: {row[5]} | branch: {row[6]} | branch manager: {row[7]} ")
                print()
        elif query_selection == 8:
            x=input("Enter your guest id: ")

            cursor.execute('''
        select distinct p.property_type ,p.host_id,p.addr_house_number,p.addr_street ,p.addr_city ,p.addr_province ,p.addr_country,p.addr_postal_code,a.amount,b.payment_type  
        from reservation r inner join guest g on r.guest_id = '''+x+''' inner join property p on r.property_id=p.id inner join payment a on a.reservation_id=r.id inner join paymentmethod b on a.payment_method_id=b.id;
                  ''')
            for row in cursor.fetchall():
                print(f"property type: {row[0]}  host id: {row[1]} | address: {row[2]} {row[3]} {row[4]} {row[5]} {row[6]} {row[7]} | amount: {row[8]} | payment type: {row[9]} ")
                print()
        elif query_selection == 9:
            x = input("Enter your guest id: ")
            y = input("Enter your new phone number:")
            cursor.execute('''
        update guest  set phone_number='''+y+'''where  guest.id='''+x+''';
        select * from guest where id='''+x+''';
                  ''')
            for row in cursor.fetchall():
                print(f"ID: {row[0]} | first name: {row[1]} | middle name: {row[2]} | last name: {row[3]} | birthday(dd,mm.year): {row[4]}/{row[5]}/{row[6]} | address: {row[7]} {row[8]} {row[9]} {row[10]} {row[11]} {row[12]} | email address: {row[13]} | phone number: {row[14]}| ")
                print()
        elif query_selection == 10:
            cursor.execute('''
        CREATE OR REPLACE FUNCTION FirstNameFirst() 
            RETURNS TABLE (full_name text) 
            AS $$
                BEGIN
                    RETURN QUERY 
                    SELECT concat(first_name,' ',last_name) 
                    FROM guest;
        END; $$ 
        LANGUAGE 'plpgsql';
        
        select * from FirstNameFirst();
                  ''')
            for row in cursor.fetchall():
                print(f"Names: {row[0]}")
                print()
        elif query_selection == 11:
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
