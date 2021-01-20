# CSI2131 Project

Database-driven application based on the AirBNB data model for CSI2131

### DBMS and Programming Languages

The DBMS chosen for this project was PostgreSQL, due to familiarity and both for us and for the professor/TA. The programming language used
is Python 3.7, using the psycopg2 module to interact with PostgreSQL, and the PyInquirer module for creating a question-based commandline interface.

The DDL used to create the database can be found in /sql, along with sample data generated using a third party website

### SQL code for functionality

The SQL statements used for the functionality in the various interfaces is as follows:

Employee Interface:
    - SELECT * FROM main.Property;
    - SELECT * FROM main.Property WHERE addr_country LIKE %s AND addr_province LIKE %s AND addr_city LIKE %s AND rental_type LIKE %s AND price <= %s AND amenities LIKE %s;

Guest Interface:
    - SELECT * FROM main.Property;

Host Interface:
    - INSERT INTO main.Property (addr_house_number, addr_street, addr_city, addr_province, addr_country, addr_postal_code, property_type, rental_type, price, description, amenities sleeping_arrangement, available_dates, host_id)
        VALUES (''' + a +''', \'''' +b +'''\', \''''+c +'''\', \''''+d+'''\', \''''+e+'''\', \''''+f +'''\', \''''+ g +'''\', \''''+h+'''\', '''+ i +''', \''''+ j+'''\', \''''+ k +'''\', \''''+l +'''\', \''''+ m +'''\', '''+ hid +''');
            ''')
    - SELECT * from property where property.host_id='''+hid+'''


### Installing and Running The Application

1. To run the application, ensure a database is set up using the sql/create-database.sql and sql/update-database.sql DDL.
2. Once a database is set up, fill in the details for your database in database.ini
3. Ensure the python modules defined in requirements.txt are installed on your computer
4. run the python scripts! Example: `python ./src/verification-queries.py`

#### Contributors
- Marc Gagnon
- Nam Nyung Kim
