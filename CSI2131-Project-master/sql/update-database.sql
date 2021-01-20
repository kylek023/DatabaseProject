CREATE SCHEMA main;

/* Create tables */
CREATE TABLE main.Branch (
    country varchar(255) NOT NULL,
    branch_manager_id integer,
    PRIMARY KEY (country)
);

CREATE TABLE main.Employee (
    id SERIAL NOT NULL,
    title varchar(255),
    salary integer,
    first_name varchar(255),
    middle_name varchar(255),
    last_name varchar(255),
    bday_day integer,
    bday_month integer,
    bday_year integer,
    branch_country varchar(255),
    PRIMARY KEY (id),
    FOREIGN KEY (branch_country) REFERENCES main.Branch(country) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE main.Branch ADD FOREIGN KEY (branch_manager_id) REFERENCES main.Employee(id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE main.Host (
    id SERIAL NOT NULL,
    first_name varchar(255),
    middle_name varchar(255),
    last_name varchar(255),
    bday_day integer,
    bday_month integer,
    bday_year integer,
    addr_house_number integer,
    addr_street varchar(255),
    addr_city varchar(255),
    addr_province varchar(255),
    addr_country varchar(255),
    addr_postal_code varchar(255),
    email varchar(255),
    phone_number varchar(255),
    PRIMARY KEY (id),
    FOREIGN KEY (addr_country) REFERENCES main.Branch(country) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE main.Property (
    id SERIAL NOT NULL,
    addr_house_number integer,
    addr_street varchar(255),
    addr_city varchar(255),
    addr_province varchar(255),
    addr_country varchar(255),
    addr_postal_code varchar(255),
    property_type varchar(255),
    rental_type varchar(255),
    price integer,
    description varchar(1024),
    amenities varchar(1024),
    sleeping_arrangement varchar(1024),
    available_dates varchar(1024),
    host_id integer,
    PRIMARY KEY (id),
    FOREIGN KEY (host_id) REFERENCES main.Host(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE main.Guest (
    id SERIAL NOT NULL,
    first_name varchar(255),
    middle_name varchar(255),
    last_name varchar(255),
    bday_day integer,
    bday_month integer,
    bday_year integer,
    addr_house_number integer,
    addr_street varchar(255),
    addr_city varchar(255),
    addr_province varchar(255),
    addr_country varchar(255),
    addr_postal_code varchar(255),
    email varchar(255),
    phone_number varchar(255),
    PRIMARY KEY (id),
    FOREIGN KEY (addr_country) REFERENCES main.Branch(country) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE main.PaymentMethod (
    id SERIAL NOT NULL,
    payment_type varchar(255),
    account_number integer,
    expiry_date date,
    guest_id integer,
    PRIMARY KEY (id),
    FOREIGN KEY (guest_id) REFERENCES main.Guest(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE main.Reservation (
    id SERIAL NOT NULL,
    start_date date,
    end_date date,
    guest_id integer,
    property_id integer,
    PRIMARY KEY (id),
    FOREIGN KEY (guest_id) REFERENCES main.Guest(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES main.Property(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE main.Payment (
    id SERIAL NOT NULL,
    status varchar(255),
    amount integer,
    reservation_id integer,
    payment_method_id integer,
    PRIMARY KEY (id),
    FOREIGN KEY (reservation_id) REFERENCES main.Reservation(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES main.PaymentMethod(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE main.Review (
    id SERIAL NOT NULL,
    content varchar(255),
    cleanliness integer,
    communication integer,
    check_in integer,
    accuracy integer,
    location integer,
    value integer,
    property_id integer,
    reservation_id integer,
    guest_id integer,
    PRIMARY KEY (id),
    FOREIGN KEY (property_id) REFERENCES main.Property(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (reservation_id) REFERENCES main.Reservation(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (guest_id) REFERENCES main.Guest(id) ON UPDATE CASCADE ON DELETE CASCADE
);

/* Add data */
INSERT INTO main.branch (country, branch_manager_id)
    VALUES ('Canada', NULL), 
    ('United States of America', NULL),
    ('France', NULL),
    ('Spain', NULL),
    ('China', NULL),
    ('Germany', NULL),
    ('United Kingdom', NULL),
    ('Australia', NULL);

INSERT INTO main.Employee (title, salary, first_name, middle_name, last_name, bday_day, bday_month, bday_year, branch_country)
    VALUES ('Manager', 75000, 'Abby', 'Diane', 'Hyndman', 5, 5, 1975, 'Canada'),
    ('Human Resources Generalist', 64000, 'John', NULL, 'Kenney', 6, 6, 1974, 'Canada'),
    ('Customer Success Specialist', 67000, 'Lydia', 'Maeve', 'Applebee', 1, 12, 1994, 'Canada'),
    ('Manager', 78000, 'Michelle', NULL, 'Leclerc', 3, 12, 1974, 'France'),
    ('Human Resources Generalist', 64000, 'Sean', NULL, 'Xiao', 15, 7, 1988, 'France'),
    ('Senior Customer Success Specialist', 69900, 'Jean', 'Lou', 'Gagnon', 29, 5, 1979, 'France'),
    ('Manager', 75000, 'Johnathan', NULL, 'Zorinsson', 25, 2, 1982, 'United States of America'),
    ('Human Resources Generalist', 65000, 'Mark', NULL, 'Maxwell', 2, 2, 1984, 'United States of America'),
    ('Human Resources Generalist', 64000, 'Stephane', NULL, 'Gordon', 3, 9, 1988, 'United States of America'),
    ('Customer Success Specialist', 67000, 'Sarah', 'Stephanie', 'Ouimet', 4, 11, 1989, 'United States of America'),
    ('Property Inspector', 64000, 'Stephane', NULL, 'Gordon', 12, 9, 1982, 'United States of America'),
    ('Property Inspector', 64000, 'Stephane', NULL, 'Ninez', 22, 11, 1975, 'United States of America'),
    ('Senior Software Developer', 110000, 'Chuck', 'Nelson', 'Thibert', 21, 2, 1969, 'United States of America'),
    ('Senior Software Developer', 98000, 'Anthony', 'John', 'Marker', 7, 3, 1975, 'United States of America'),
    ('Junior Software Developer', 74000, 'Steve', NULL, 'Shaw', 2, 4, 1992, 'United States of America'),
    ('Junior Software Developer', 72000, 'Jacopo', NULL, 'Tocacielli', 15, 5, 1995, 'United States of America'),
    ('Manager', 76500, 'Maria', 'Lucia', 'Gonzalez', 13, 5, 1991, 'Spain'),
    ('Human Resources Generalist', 64000, 'Johnathan', NULL, 'Walker', 8, 3, 1984, 'Spain'),
    ('Customer Success Specialist', 64900, 'Kevin', NULL, 'Espanolez', 11, 11, 1986, 'Spain'),
    ('Manager', 73000, 'Xi', NULL, 'Zhou', 15, 1, 1984, 'China'),
    ('Human Resources Generalist', 67750, 'Kristen', NULL, 'Mcmahon', 19, 3, 1988, 'China'),
    ('Customer Success Specialist', 65500, 'Gabrielle', NULL, 'Prevost', 22, 10, 1983, 'China'),
    ('Manager', 74000, 'Kyle', 'Samuel', 'Smith', 4, 3, 1982, 'Germany'),
    ('Human Resources Generalist', 68000, 'Etienne', NULL, 'Galavinakis', 13, 7, 1979, 'Germany'),
    ('Customer Success Specialist', 68000, 'Bob', NULL, 'Hope', 17, 4, 1985, 'Germany'),
    ('Manager', 74200, 'George', NULL, 'Cover', 18, 11, 1980, 'United Kingdom'),
    ('Human Resources Generalist', 67000, 'Chris', NULL, 'Chavez', 19, 9, 1969, 'Germany'),
    ('Customer Success Specialist', 65500, 'Diane', NULL, 'Nguyen', 7, 10, 1984, 'Germany'),
    ('Manager', 74000, 'Andrew', NULL, 'Rybka', 6, 9, 1977, 'Australia'),
    ('Human Resources Generalist', 69000, 'Patricia', NULL, 'Mcmahon', 1, 2, 1991, 'Australia'),
    ('Customer Success Specialist', 71000, 'Sarah', NULL, 'Greene', 27, 7, 1983, 'Australia');

UPDATE main.branch SET branch_manager_id=(SELECT id FROM main.Employee WHERE title='Manager' AND branch_country='Canada') WHERE country='Canada';
UPDATE main.branch SET branch_manager_id=(SELECT id FROM main.Employee WHERE title='Manager' AND branch_country='United States of America') WHERE country='United States of America';
UPDATE main.branch SET branch_manager_id=(SELECT id FROM main.Employee WHERE title='Manager' AND branch_country='France') WHERE country='France';
UPDATE main.branch SET branch_manager_id=(SELECT id FROM main.Employee WHERE title='Manager' AND branch_country='Spain') WHERE country='Spain';
UPDATE main.branch SET branch_manager_id=(SELECT id FROM main.Employee WHERE title='Manager' AND branch_country='China') WHERE country='China';
UPDATE main.branch SET branch_manager_id=(SELECT id FROM main.Employee WHERE title='Manager' AND branch_country='Germany') WHERE country='Germany';
UPDATE main.branch SET branch_manager_id=(SELECT id FROM main.Employee WHERE title='Manager' AND branch_country='United Kingdom') WHERE country='United Kingdom';
UPDATE main.branch SET branch_manager_id=(SELECT id FROM main.Employee WHERE title='Manager' AND branch_country='Australia') WHERE country='Australia';

INSERT INTO main.Host (first_name, middle_name, last_name, bday_day, bday_month, bday_year, addr_house_number, addr_street, addr_city, addr_province, addr_country, addr_postal_code, email, phone_number)
    VALUES ('Johnathan', 'Eric', 'Lamothe', 10, 7, 1988, 1398, 'Main St', 'Hawkesbury', 'Ontario', 'Canada', 'K0B 1R0', 'johnathan-properties@gmail.com', '613-674-5293'),
    ('Coralie', 'Viau', 'Aubrey', 22, 2, 1984, 2278, 'Brant Ave', 'Red Earth', 'Alberta', 'Canada', 'T1T 1T1', 'cv.aubrey@gmail.com', '613-632-8193'),
    ('Quincy', NULL, 'Addams', 8, 5, 1979, 2952, 'Chapel St', 'Sugar Land', 'Texas', 'United States of America', '77478', 'quincy.properties@hotmail.com', '281-718-8833'),
    ('Jae', NULL, 'Champoux', 4, 9, 1975, 3659, 'Selah Way', 'Russelville', 'Alabama', 'United States of America', '35654', 'jae233@gmail.com', '802-626-7100'),
    ('Phoebe', NULL, 'Alistair', 16, 11, 1965, 1905, 'Kennedy Court', 'West Roxbury', 'Massachusetts', 'United States of America', '02132', 'p.alistair@gmail.com', '774-271-1654'),
    ('Falerina', NULL, 'LaCaille', 20, 11, 1970, 38, 'Chemin Du Lavarin Sud', 'Calais', 'Nord-Pas-De-Calais', 'France', '62100', 'fal.lacaille@gmail.com', '03.34.33.91110'),
    ('Claude', NULL, 'Chastain', 12, 10, 1992, 64, 'rue Porte D', 'Cavaillon', 'Provence-Alpes-Côte D', 'France', '84300', 'c.chastain@gmail.com', '04.40.20.35876'),
    ('Roni', NULL, 'Pichardo', 23, 1, 1987, 95, 'Avda. Enrique Peinador', 'Almendra', 'Salamanca', 'Spain', '02132', 'roni-properties@hotmail.com', '769-852-079'),
    ('Ayelén', NULL, 'Menéndez', 18, 12, 1975, 49, 'Cañadilla', 'Bollullos Par del Condado', 'Huelva', 'Spain', '21710', 'am.properties@gmail.com', '711-490-675'),
    ('Xinxin', NULL, 'Zhang', 26, 6, 1965, 1905, 'Guo Ji Xue Yuan', 'City Area - HaiDian District', 'Beijing', 'China', '100083', 'xinxin.zhang@gmail.com', '308-252-3385'),
    ('Gang', NULL, 'Zhou', 9, 3, 1978, 2133, 'Cheng Shan Lu', 'ShangHai', 'ShanHai', 'China', '200000', 'gang.properties@gmail.com', '308-252-9477'),
    ('Lisa', NULL, 'Theiss', 24, 6, 1970, 68, 'Esplanade', 'Triefenstein', 'Freistaat Bayern', 'Germany', '97855', 'theiss.realestate@gmail.com', '09395 31 90 32'),
    ('Florian', NULL, 'Faust', 25, 10, 1986, 38, 'Motzstr.', 'Ober-Hilbersheim', 'Rheinland-Pfalz', 'Germany', '95385', 'faust.properties@gmail.com', '06728 24 08 63'),
    ('Leo', NULL, 'Barton', 17, 5, 1986, 50, 'Annfield Rd', 'Beaumont', NULL, 'United Kingdom', 'CO6 8AR', 'l.barton@gmail.com', '078 3508 0846'),
    ('Paige', NULL, 'Fitzgerald', 27, 7, 1995, 104, 'Main Rd', 'Fordstreet', NULL, 'United Kingdom', 'NP1 9AS', 'fitz.real.estate@gmail.com', '079 4556 3477'),
    ('Claire', NULL, 'Hampton', 2, 3, 1977, 84, 'Wallis Street', 'Randwick', 'Queensland', 'Australia', '2031', 'hampton.estate@gmail.com', '(02) 9653 9932'),
    ('Alexandra', NULL, 'Schaffer', 17, 2, 1988, 88, 'Anderson Street', 'Northgate MC', 'Queensland', 'Australia', '4013', 'schaffer.properties@gmail.com', '(07) 3339 7300');

INSERT INTO main.Property (addr_house_number, addr_street, addr_city, addr_province, addr_country, addr_postal_code, property_type, rental_type, price, description, amenities, sleeping_arrangement, available_dates, host_id)
    VALUES (3854, 'Robson St', 'Vancouver', 'British Colombia', 'Canada', 'V6B 3K9', 'Apartment', 'Private Room', 89, 'It is a master bedroom (with private bathroom) in an 900+ apartment at heart of Vancouver; steps away from the bars, restaurants, shops, night life and all tourist destinations.', 'Kitchen, Wifi, Dryer, Washer, Air Conditioning, Heating, TV, 1 Parking Spot, Essentials', '1 King Sized Bed', 'After April 25th', 1),
    (2552, 'Port Washington Road', 'Manyberries', 'Alberta', 'Canada', 'T0K 1L0', 'House', 'Full House', 199, 'This fully loaded, one of a kind luxury townhouse is a travelers dream. The building comes with gorgeous resort style amenities which include a lap pool, Jacuzzi, fitness room, and sauna so you are sure to feel like youre in a 5 star hotel!', 'Hot Tub, Fitness Room, Sauna, Pool, Wifi, Dryer, Washer, Air Conditioning, Heat, Breakfast, Essentials', '3 Bedrooms | 3 Queen Beds', 'After April 10th', 2),
    (3787, 'Ruckman Road', 'Oklahoma City', 'Oklahoma', 'United States of America', '73129', 'Apartment', 'Full Apartment', 99, 'This apartment is decorated in a classic style, with plenty of windows for natural light. There are smart TVs (4K) in bedroom and living room, with Cox cable and WiFi.', 'Wifi, Indoor Fireplace, TV, Dryer, Washer, Heating, Air Conditioning, Free Parking, Kitchen, Silverware, Stove, Oven, Cooking Basics, Essentials', '1 Bedroom | 1 King Bed, 1 Living Room Couch', 'After April 4th', 3),
    (1531, 'Benedum Drive', 'New York', 'New York', 'United States of America', '10011', 'Apartment','Private Room', 129, 'My apartment is in a modest walk up building just a quick walk from Madison Square park and many other beautiful places. A block from the 6 train and very close to so many great places in the city. While the building is not much to look at, I do take a lot of pride in my bedrooms. The bedroom has a queen size bed, desk, and standing closet.', 'Wifi, Essentials, Air Conditioning, Heating, Free Parking, Kitchen, Stove, Cooking Basics', '1 Queen Bed', 'After May 14th', 4),
    (774, 'Barfield Lane', 'Indianapolis', 'Indiana', 'United States of America', '46250', 'Apartment', 'Private Room', 119, 'Tall ceilings, sunny windows, and open spaces describe this home. Built in 1900, but recently updated for a modern feel. Lounge on the couch and watch Netflix, read on the porch, or relax in your bedroom in this shared space. You will only be sharing this home with the host, Elizabeth, so expect a quiet and clean home.', 'Wifi, TV, Washer, Dryer, Heating, Air Conditioning, Free Parking, Kitches, Kitchen Essentials, Coffee Maker, Balcony, Essentials', '2 King Beds', 'After May 25th', 5),
    (102, 'Faubourg Saint Honore', 'Paris', 'Ile-de-France', 'France', '75019', 'Apartment', 'Private Room', 139, 'Appartement architecte cosy et chaleureux : au coeur du 9ème arrondissement de Paris, à deux pas de Pigalle, Montmartre et non loin de Saint-Lazare, séjournez dans un havre de paix calme, lumineux et raffiné. Lappartement à bénéficié une rénovation intégrale en 2018.', 'Wifi, Dryer, Washer, Heating, Kitchen, Silverware, Microwave, Private Entrance, Essentials', '1 Queen Sized Bed', 'After May 10th', 6),
    (134, 'Rue de L', 'La Madeleine', 'Nord-Pas-de-Calais', 'France', '59110', 'Apartment', 'Private Room', 169, 'Une pièce de vie avec coin cuisine (kitchenette équipée) et coin nuit (clic clac confort et télévision), dune salle de bain et dun w/c indépendant. Draps et serviettes non compris au prix de 10€ pour 1 lit et 15 € pour 2 lits. Couvertures ,couettes, et oreillers à disposition. Connexion wifi disponible. Autour, une supérette,une pharmacie, boulangerie, tabac et restaurants.', 'Wifi, Heating, Washer, Dryer, Child-Proof Furnishings, Free Parking, Kitchen, Cooking Essentials, Oven, Microwave, Stove, Dishwasher, Essentials', '1 Queen Bed', 'After April 28th', 7),
    (60, 'Benito Guinea', 'Sant Andreu de Llavaneres', 'Barcelona', 'Spain', '08392', 'Apartment', 'Private Room', 99, 'I offer you a private room for three people with Private bathroom in my new apartment. I also live in the apartment. It is located in the center of Barcelona, in the Old Town, near the beach and the main touristic sights. The room has private bathroom, air conditioning, heater and lock. I live in the apartment and I rent another room. You also can use the kitchen', 'Wifi, Dryer, Washroom, Air Conditioning, Essentials, Elevator, Kitchen, Shampoo, Hair Dryer', '1 King Bed', 'After April 1', 8),
    (20, 'Puerto Lugar', 'Lagos', 'Malaga', 'Spain', '29700', 'Apartment', 'Private Room', 99, 'Perfect view and location! This apartment is very well located, near the centre of Lagos (3min walking) and near the awesome beaches (Meia Beach, Pinhão, D.Ana, Batata; 5-10minutes walking). This place is very quiet and calm during both day and night', 'Washer, Dryer, TV, Wifi, Baby bath, Crib, High Chair, Free Parking, Kitchen, Stove, Oven, Silverware, Shampoo, Patio, Beachfront, Essentials', '2 Bedrooms | 1 King Sized Bed, 1 Queen Sized Bed', 'After March 27th', 9),
    (58, 'Ka Yuan San Lu', 'PuDongXin District', 'Shanghai', 'China', '201201', 'Apartment', 'Private Room', 119, '【草莓の独卫4K影音休闲小屋】由美女设计老师和海归建筑师两个小伙伴搭建,两人热情,活泼,开朗。他们在上海黄金区位通过自己的设计把小房间打扮的清新,温暖。两人希望通过自己的努力给大家的旅行带来更多便捷和欢乐。小屋是完整的一户室,大门都有独立的动态密码锁门,房间采光极佳,清晨醒来,沐浴着每一缕温暖的阳光。房间位于曲阜路地铁站口旁边,步行仅需4分钟,从小屋可步行前往人民广场,南京路。欢迎大家来上海旅行时,前来体验,如有需求,请及时联系我们。浅色松木家具,配上白色的窗帘和粉色的墙面围合出一片温馨浪漫的人文天地。白天包裹在圆形的吊椅里和公仔们一起沐浴阳光,夜晚白云蓝花瓣的顶灯洒射出大自然的光影。宛若童话又充满青春的气息中洗去旅途的疲劳和自己的心灵窃窃私语。欢迎大家来上海旅行时,前来体验,如有需求,请及时联系我们', 'Elevator, Wifi, Kitchen, Hair Dryer, Heating, Washer, Dryer, Essentials', '1 Kind Bed', 'Available', 10),
    (26, 'San Mu Hua Yuan', 'DaDuKou District', 'Chongqing', 'China', '400080', 'Apartment', 'Private Room', 129, '市中心和迪士尼有很多房源，请戳头像，下拉到底，点击查看。或直接咨询我，不嫌烦。有什么需求尽管跟我提，尽量满足。如果您喜欢的房源没有了，可以给你换其他房源，给你安排！', 'Elevator, Dryer, Washing Machine, Air Conditioner, Heating, Kitchen, Microwave, Silverware, Shampoo, Essentials', '1 Queen Bed', 'After April 4th', 11),
    (95, 'Flughafenstrasse', 'Aalbude', 'Mecklenburg-Vorpommern', 'Germany', '17111', 'Apartment', 'Full Apartment', 179, 'A sweet, bright 1-room apartment to feel good in! Quiet & very green, despite being located in the middle of the lively & lovelyPrenzlauer Berg with many cafés, restaurants, small designer shops. In 8 minutes by tram to Alexanderplatz.', 'Wifi, TV, Heating, High Chair, Crib, Kitchen, Silverware, Cooking Essentials, Shampoo', '1 King Bed', 'After April 16th', 12),
    (70, 'Luckenwalder Strasse', 'Burgwedel', 'Niedersachsen', 'Germany', '30938', 'Apartment', 'Full Apartment', 199, 'Fully equipped kitchen, fast WIFI and at walking distance to all public transportations to all major sightseeing spots. The Building is not even one year old and is thus in excellent conditions. You will njoy your stay in this exciting city while relaxing in my well treated apartment.', 'Wifi, TV, Essentials, Heating, Elevator, Kitchen, Microwave, Coffee maker, Silverware, Private Entrance, Cooking Essentials', '1 King Bed', 'After May 11th', 13),
    (128, 'Park End St', 'Eilanreach', NULL, 'United Kingdom', 'IV40 6NL', 'Apartment', 'Full Apartment', 299, 'Self-contained annexe with separate entrance. Bedroom with 4ft wide bed (smaller than standard double, ) en-suite shower room, and conservatory furnished with sofabed. Private access through conservatory door; keybox for flexible arrival times.', 'Wifi, TV, Heating, Air Conditioner, Essentials, Free Parking, Kitchen, Dishes, Silverware, Private Entrance, Shampoo, Washer, Dryer', '1 King Bed, 1 Couch', 'After March 29th', 14),
    (143, 'Ermin Street', 'Wroxall', NULL, 'United Kingdom', 'PO38 5ZU', 'Studio', 'Full Studio', 169, 'This adorable wood-paneled cabin is tucked away in Ventnor Botanic Gardens Upper Nursery with sea views across the Garden to the English Channel. The Cabin is a bijou hide-away, perfect for a couple. The small wood stove keeps you warm and cosy in the open plan space, which has a full kitchen. The Cabin also has its own Mediterranean garden and terrace with outside seating.', 'Free Parking, Heating, Indoor Fireplace, Kitchen, Dishes and Silverware, Stove, Oven, Private Entrance, Balcony, Essentials', '2 King Beds', 'After April 4th', 15),
    (92, 'Thule Drive', 'Wasleys', 'South Australia', 'Australia', '5400', 'Loft', 'Full Loft', 199, 'Just five minutes from Darwin CBD, this penthouse offers a generous 450 sqm of space on the top floor of its complex.', 'Dryer, Washer, Air Conditioning, Essentials, TV, Hot Tub, Pool, Free Parking, Kitchen, Dishes, Coffee Maker, Microwave, Private Entrance, Hair Dryer, Shampoo', '3 Bedrooms | 1 King Bed, 2 Queen Beds', 'After April 16th', 16),
    (70, 'Isaac Road', 'Bronte Park', 'Tasmania', 'Australia', '7140', 'House', 'Full House', 399, '5 STAR HOME: stargaze in the hot-tub! Stunning home so close to the Bay. Oodles of space. Complimentary wine/biscuits, WIFI, aircon/heating, bicycles, etc. Sleeps 9.', 'Wifi, Indoor Fireplace, Air Conditioning, Dryer, Washer, TV, Essentials, Free Parking, Patio, Pool, Hot Tub, Kitchen, Utensils, Dishes', '5 Bedrooms | 3 Queen Beds 1 Double Bed 1 Twin Bed 1 Couch', 'After April 10th', 17);

INSERT INTO main.Guest (first_name, middle_name, last_name, bday_day, bday_month, bday_year, addr_house_number, addr_street, addr_city, addr_province, addr_country, addr_postal_code, email, phone_number)
    VALUES ('Johnathan', 'Eric', 'Lamothe', 10, 7, 1988, 1398, 'Main St', 'Hawkesbury', 'Ontario', 'Canada', 'K0B 1R0', 'johnathan-properties@gmail.com', '613-674-5293'),
    ('Quincy', NULL, 'Addams', 8, 5, 1979, 2952, 'Chapel St', 'Sugar Land', 'Texas', 'United States of America', '77478', 'quincy.properties@hotmail.com', '281-718-8833'),
    ('Falerina', NULL, 'LaCaille', 20, 11, 1970, 38, 'Chemin Du Lavarin Sud', 'Calais', 'Nord-Pas-De-Calais', 'France', '62100', 'fal.lacaille@gmail.com', '03.34.33.91110'),
    ('Roni', NULL, 'Pichardo', 23, 1, 1987, 95, 'Avda. Enrique Peinador', 'Almendra', 'Salamanca', 'Spain', '02132', 'roni-properties@hotmail.com', '769-852-079'),
    ('Xinxin', NULL, 'Zhang', 26, 6, 1965, 1905, 'Guo Ji Xue Yuan', 'City Area - HaiDian District', 'Beijing', 'China', '100083', 'xinxin.zhang@gmail.com', '308-252-3385'),
    ('Lisa', NULL, 'Theiss', 24, 6, 1970, 68, 'Esplanade', 'Triefenstein', 'Freistaat Bayern', 'Germany', '97855', 'theiss.realestate@gmail.com', '09395 31 90 32'),
    ('Leo', NULL, 'Barton', 17, 5, 1986, 50, 'Annfield Rd', 'Beaumont', NULL, 'United Kingdom', 'CO6 8AR', 'l.barton@gmail.com', '078 3508 0846'),
    ('Claire', NULL, 'Hampton', 2, 3, 1977, 84, 'Wallis Street', 'Randwick', 'Queensland', 'Australia', '2031', 'hampton.estate@gmail.com', '(02) 9653 9932');

INSERT INTO main.Reservation (start_date, end_date, guest_id, property_id)
    VALUES ('2020-3-27','2020-3-31', 1, 2),('2020-4-4','2020-4-10', 4, 9),('2020-4-23','2020-4-27', 3, 2),('2020-2-1','2020-2-27', 5,8),('2020-04-10','2020-4-27', 2, 3);

INSERT INTO main.Review( content, cleanliness,communication ,check_in ,accuracy ,location ,value ,property_id ,reservation_id ,guest_id ) VALUES
	('okay' , 5 ,7,3,1,7,6,2,1,1),('decent', 9 ,2,5,7,7,0,9,2,4),('terrible',2,1,3,1,1,2,1,3,3),('great', 9 ,10,8,10,9,8, 8,4,5),('fine',5,2,7,1,1,2,9,5,4);
INSERT INTO main.PaymentMethod(payment_type,account_number,expiry_date,guest_id)
	VALUES('debit',12987327,'2022-4-12',1),('credit',1290421,'2021-9-12',4),('credit',23343432,'2024-11-15',3),('debit',34108109,'2022-1-4',5),('debit',0278293,'2020-11-9',2);
INSERT INTO main.Payment(status, amount, reservation_id, payment_method_id)
	VALUES ('paid',235,1,1),('paid',2134,2,2),('not paid',512,3,3),('not paid',3123,4,4),('paid',21,5,5);
