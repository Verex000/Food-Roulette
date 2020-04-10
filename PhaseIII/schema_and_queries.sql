/*
Creates the Food Roulette Schema
TCSS 445 - Winter 2020
Phase 3 - Project Group 9

This database is hosted on Microsoft Azure 
Script was written in SQL Server Management Studio
*/

--Create the Food roulette user table
--Checks is the user name contains non-alphanumeric characters
CREATE TABLE FR_USER (
	FR_User_Id			int			NOT NULL PRIMARY KEY,
	FR_User_Name		varchar(50)	NOT NULL		UNIQUE		CHECK(FR_User_Name NOT LIKE '%[^a-zA-Z0-9]%'),
	Last_Name			varchar(50)	NOT NULL,
	First_Name			varchar(50)	NOT NULL,
	FR_User_City		varchar(50)	NOT NULL,
	FR_User_State		varchar(2)	NOT NULL DEFAULT '//'
)

--Creates the Restaurant Relation
CREATE TABLE RESTAURANT (
	Restaurant_Id							int	NOT NULL PRIMARY KEY,
	Restaurant_Name						varchar(50)		NOT NULL,
	--Restaurant_Address						varchar(50)		NOT NULL,
	--City									varchar(50)		NOT NULL,
	--Restaurant_State						varchar(50)		NOT NULL,
	Phone_Number							varchar(10)		DEFAULT '0000000000'		CHECK(Phone_Number NOT LIKE '%[^0-9]%'),
	Rating									Decimal(2, 1)	NOT NULL	DEFAULT	5.0		CHECK(Rating <= 5.0 AND Rating > 0),
)

--Creates the Restaurant_Location Relation
CREATE TABLE RESTAURANT_LOCATION (
	Restaurant_Id		int				NOT NULL,
	Restaurant_Street	varchar(50)		NOT NULL,
	Restaurant_City		varchar(50)		NOT NULL,
	Restaurant_State	varchar(2)		NOT NULL,
	PRIMARY KEY(Restaurant_Street, Restaurant_City, Restaurant_State),
	FOREIGN KEY(Restaurant_Id) REFERENCES RESTAURANT(Restaurant_Id)		ON DELETE NO ACTION	ON UPDATE CASCADE
)

--Creates the Site Review relation
--This relation contains reviews from other websites.
--Other websites can include google reviews, trip advisor, etc.
--needed this relation, as we will not need user information from these websites.
CREATE TABLE SITE_REVIEW (
	Restaurant_Id	int				NOT NULL,
	Website			varchar(50)		NOT NULL,
	User_Rating		decimal(2, 1)	NOT NULL	DEFAULT 5.0		CHECK(User_Rating <= 5.0 AND User_Rating > 0),
	Site_User_Name	varchar(50)					DEFAULT 'Anon'		NOT NULL,
	PRIMARY KEY(Restaurant_Id, Website, Site_User_Name),
	FOREIGN KEY(Restaurant_Id) REFERENCES RESTAURANT(Restaurant_Id) 		ON DELETE NO ACTION	ON UPDATE CASCADE
)

--Creates the Cuisine relation.
--Cuisine relation references the Restaurant Relation
--Restaurants can have multiple Cuisine types
CREATE TABLE CUISINE (
	Restaurant_Id		int		NOT NULL,
	Cuisine_Type		varchar(50)		NOT NULL,
	Primary Key(Restaurant_Id, Cuisine_Type),
	Foreign Key(Restaurant_Id) REFERENCES RESTAURANT(Restaurant_Id)			ON DELETE NO ACTION ON UPDATE CASCADE
)

--Creates the User Review Relation
--Users of Food Roulette will be able to leave their own review rating
--Each review will be linked to a FR user by their user id.
--This relation is independent of the Site review relation.
CREATE TABLE USER_REVIEW (
	FR_User_Id				int		NOT NULL,
	Restaurant_Id			int		NOT NULL,
	User_Rating				decimal(2, 1)	NOT NULL DEFAULT 5.0	CHECK(User_Rating <= 5 AND User_Rating > 0)
	PRIMARY KEY(FR_User_Id, Restaurant_Id),
	FOREIGN KEY(FR_User_Id) REFERENCES FR_USER(FR_User_Id)			ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY(Restaurant_Id) REFERENCES RESTAURANT(Restaurant_Id)	ON DELETE NO ACTION ON UPDATE CASCADE
)
--If a rating is added to the User Review table, the RESTAURANT table must be updated
--This trigger averages the reviews then places them into the restaurant table.
CREATE TRIGGER UserReviewUpdate
ON [dbo].[USER_REVIEW]
FOR INSERT AS  
IF @@ROWCOUNT = 1  
BEGIN
	UPDATE	RESTAURANT
	SET	RATING = (SELECT AVG(allreviews.USER_RATING) AS AVG_RATING
    FROM    (SELECT SITE_REVIEW.Restaurant_Id, SITE_REVIEW.User_Rating
            FROM SITE_REVIEW
        UNION ALL
        SELECT USER_REVIEW.Restaurant_Id, USER_REVIEW.User_Rating
            FROM USER_REVIEW) allreviews
		WHERE Restaurant_Id = inserted.Restaurant_Id)
	FROM inserted
	WHERE RESTAURANT.Restaurant_Id = inserted.Restaurant_Id
END

--If a rating is added to the Site Review table, the RESTAURANT table must be updated
--This trigger averages the reviews then places them into the restaurant table.
CREATE TRIGGER ReviewUpdate
ON [dbo].[SITE_REVIEW]
FOR INSERT AS  
IF @@ROWCOUNT = 1  
BEGIN
	UPDATE	RESTAURANT
	SET	RATING = (SELECT AVG(allreviews.USER_RATING) AS AVG_RATING
    FROM    (SELECT SITE_REVIEW.Restaurant_Id, SITE_REVIEW.User_Rating
            FROM SITE_REVIEW
        UNION ALL
        SELECT USER_REVIEW.Restaurant_Id, USER_REVIEW.User_Rating
            FROM USER_REVIEW) allreviews
		WHERE Restaurant_Id = inserted.Restaurant_Id)
	FROM inserted
	WHERE RESTAURANT.Restaurant_Id = inserted.Restaurant_Id
END
--***************************
--***************************
--Part B
--***************************
--Sample data for the RESTAURANT table
--Summary: inserts all of the data for the restaurant tables

INSERT INTO RESTAURANT
	VALUES(1,
	'Southern Kitchen',
	'2536274282',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(1,
	'1716 6th Ave',
	'TACOMA',
	'WA');

INSERT INTO RESTAURANT
	VALUES(2,
	'Dirty Oscars Annex',
	'2535720588',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(2,
	'2309 6th Ave',
	'TACOMA',
	'WA');

INSERT INTO RESTAURANT
	VALUES(3,
	'Uncle Thurms Soul Food',
	'2534751881',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(3,
	'3709 S G St',
	'TACOMA',
	'WA');


INSERT INTO RESTAURANT
	VALUES(4,
	'Pacific Grill',
	'2536273535',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(4,
	'1502 Pacific Ave',
	'TACOMA',
	'WA');

INSERT INTO RESTAURANT
	VALUES(5,
	'Lobster Shop',
	'2537592165',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(5,
	'4015 Ruston Way',
	'TACOMA',
	'WA');

INSERT INTO RESTAURANT
	VALUES(6,
	'Indo Asian Street Eatery',
	'2535033527',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(6,
	'110 N Tacoma Ave suite a',
	'TACOMA',
	'WA');


INSERT INTO RESTAURANT
	VALUES(7,
	'Bangkok Garden Street Food',
	'2539468833',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(7,
	'31509 Pacific Hwy S',
	'FEDERAL WAY',
	'WA');


INSERT INTO RESTAURANT
	VALUES(8,
	'Tokyo-ya Ramen',
	'2065926552',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(8,
	'31507 Pacific Hwy S',
	'FEDERAL WAY',
	'WA');


INSERT INTO RESTAURANT
	VALUES(9,
	'California Burrito',
	'2065929561',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(9,
	'22660 Pacific Hwy ',
	'DES MOINES',
	'WA');

INSERT INTO RESTAURANT
	VALUES(10,
	'COPPER COIN',
	'2064203608',
	5);


INSERT INTO RESTAURANT_LOCATION
	VALUES(10,
	'2329 California Ave SW',
	'SEATTLE',
	'WA');

INSERT INTO RESTAURANT
	VALUES(11,
	'Nodoguro',
	NULL,
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(11,
	'2832 SE Belmont St',
	'PORTLAND',
	'OR');

INSERT INTO RESTAURANT
	VALUES(12,
	'Le Pigeon',
	'6035468796',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(12,
	'738 E BURNSIDE ST',
	'PORTLAND',
	'OR');


INSERT INTO RESTAURANT
	VALUES(13,
	'Pizzicato Pizza',
	'5032218784',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(13,
	'1749 SW Skyline Blvd',
	'PORTLAND',
	'OR');

INSERT INTO RESTAURANT
	VALUES(14,
	'Bestia',
	'2135145724',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(14,
	'2121 E 7th Pl',
	'LOS ANGELES',
	'CA');

INSERT INTO RESTAURANT
	VALUES(15,
	'NIRMALS',
	'2135145724',
	5);

INSERT INTO RESTAURANT_LOCATION
	VALUES(15,
	'106 Occidental Ave S',
	'SEATTLE',
	'WA');

--Sample data for CUISINE
--Summary: Stores all data for cuisines.

INSERT INTO CUISINE
     VALUES
           (1,
		   'SOUTHERN');


INSERT INTO CUISINE
     VALUES
           (2,
		   'AMERICAN');


INSERT INTO CUISINE
     VALUES
           (3,
		   'SOUL');


INSERT INTO CUISINE
     VALUES
           (4,
		   'AMERICAN');


INSERT INTO CUISINE
     VALUES
           (5,
		   'SEAFOOD');

INSERT INTO CUISINE
     VALUES
           (6,
		   'ASIAN');


INSERT INTO CUISINE
     VALUES
           (7,
		   'THAI');


INSERT INTO CUISINE
     VALUES
           (8,
		   'RAMEN');


INSERT INTO CUISINE
     VALUES
           (9,
		   'MEXICAN');


INSERT INTO CUISINE
     VALUES
           (10,
		   'GRILL');


INSERT INTO CUISINE
     VALUES
           (11,
		   'JAPANESE');


INSERT INTO CUISINE
     VALUES
           (12,
		   'FRENCH');

INSERT INTO CUISINE
     VALUES
           (13,
		   'PIZZA');


INSERT INTO CUISINE
     VALUES
           (14,
		   'ITALIAN');


INSERT INTO CUISINE
     VALUES
           (15,
		   'INDIAN');
		   
--Sample data for the FR_USER (User login/information) table
--Summary: inserts all of the data for the FR_User table
		   
INSERT INTO FR_USER
	values(1,
	'lookingformiso',
	'Kolin',
	'Sinus',
	'PUYALLUP',
	'WA');
	
INSERT INTO FR_USER
	values(2,
	'foodreviewer23',
	'Daniel',
	'Grey',
	'BELLEVUE',
	'WA');
	
INSERT INTO FR_USER
	values(3,
	'JOEYSWORLDTOUR',
	'Joey',
	'Feris',
	'PORTLAND',
	'OR');
	
INSERT INTO FR_USER
	values(4,
	'jonathan123',
	'Jonathan',
	'Neer',
	'SEATTLE',
	'WA');
	
INSERT INTO FR_USER
	values(5,
	'10wayne10',
	'Wayne',
	'Hogan',
	'BONNEY LAKE',
	'WA');
	
INSERT INTO FR_USER
	values(6,
	'jonathanthedestroyer',
	'Jonathan',
	'Warner',
	'LOS ANGELES',
	'CA');
	
INSERT INTO FR_USER
	values(7,
	'muffincat23',
	'Erin',
	'Yeager',
	'TACOMA',
	'WA');
	
INSERT INTO FR_USER
	values(8,
	'pizzahutpizza',
	'Alan',
	'Moises',
	'ORLANDO',
	'FL');
	
INSERT INTO FR_USER
	values(9,
	'bonebone23',
	'BoneBone',
	'Cat',
	'SEATTLE',
	'WA');
	
INSERT INTO FR_USER
	values(10,
	'freeiphonegiveaway',
	'Bob',
	'Smith',
	'PORTLAND',
	'OR')
	
INSERT INTO FR_USER
	values(11,
	'username',
	'John',
	'Smith',
	'FEDERAL WAY',
	'WA')
	
INSERT INTO FR_USER
	values(12,
	'blackhole',
	'George',
	'Majors',
	'FIFE',
	'WA')
	
--Sample data for the USER_REVIEW (reviews from our users)
--Summary: inserts all of the data for the USER_REVIEW table
	
insert into USER_REVIEW
	VALUES (1,
			1,
			3.5);

insert into USER_REVIEW
	VALUES (1,
			2,
			4.5);

insert into USER_REVIEW
	VALUES (1,
			3,
			5.0);

insert into USER_REVIEW
	VALUES (2,
			1,
			4.0);

insert into USER_REVIEW
	VALUES (3,
			3,
			4.5);

insert into USER_REVIEW
	VALUES (5,
			1,
			3.5);

insert into USER_REVIEW
	VALUES (5,
			4,
			2.0);

insert into USER_REVIEW
	VALUES (6,
			5,
			1.0);

insert into USER_REVIEW
	VALUES (6,
			6,
			0.5);

insert into USER_REVIEW
	VALUES (7,
			1,
			5.0);

insert into USER_REVIEW
	VALUES (7,
			10,
			5.0);

insert into USER_REVIEW
	VALUES (7,
			11,
			4.0);

insert into USER_REVIEW
	VALUES (8,
			12,
			4.0);

insert into USER_REVIEW
	VALUES (8,
			13,
			3.0);

insert into USER_REVIEW
	VALUES (8,
			14,
			2.0);

insert into USER_REVIEW
	VALUES (9,
			15,
			4.0);

insert into USER_REVIEW
	VALUES (10,
			8,
			4.0);

insert into USER_REVIEW
	VALUES (11,
			7,
			4.5);

insert into USER_REVIEW
	VALUES (12,
			9,
			3.0);
			
--Sample data for the SITE_REVIEW (reviews from users of other websites)
--Summary: inserts all of the data for the SITE_REVIEW table

insert into SITE_REVIEW 
	values(1,
	'GOOGLE',
	4.0,
	'john1');

insert into SITE_REVIEW 
	values(2,
	'GOOGLE',
	5.0,
	'neighbor12');

insert into SITE_REVIEW 
	values(3,
	'GOOGLE',
	3.0,
	'nicedud3');

insert into SITE_REVIEW 
	values(4,
	'GOOGLE',
	2.0,
	'123abc');

insert into SITE_REVIEW 
	values(5,
	'YELP',
	3.5,
	'dadjoke23');

insert into SITE_REVIEW 
	values(6,
	'YELP',
	4.5,
	'name120');

insert into SITE_REVIEW 
	values(7,
	'YELP',
	5.0,
	'random103');

insert into SITE_REVIEW 
	values(8,
	'YELP',
	3.0,
	'dude12');

insert into SITE_REVIEW 
	values(9,
	'TRIP ADVISOR',
	1.0,
	'kevinthebrony');

insert into SITE_REVIEW 
	values(10,
	'TRIP ADVISOR',
	2.0,
	'youtube1');

insert into SITE_REVIEW 
	values(11,
	'TRIP ADVISOR',
	3.0,
	'aqpw');

insert into SITE_REVIEW 
	values(11,
	'Zomato',
	5.0,
	'manlydude2');

insert into SITE_REVIEW 
	values(12,
	'TRIP ADVISOR',
	4.0,
	'user1');

insert into SITE_REVIEW 
	values(13,
	'TRIP ADVISOR',
	5.0,
	'password');

insert into SITE_REVIEW 
	values(14,
	'GOOGLE',
	3.0,
	'123456789');

insert into SITE_REVIEW 
	values(15,
	'YELP',
	4.0,
	'bestreviewer');
	

--***************************
--***************************
--Part C
--***************************

--Query 1
--Purpose retrieve the all of our site reviews and the name of the restaurant and the user that reviewed it
--Since restaurants and users are identified by IDs this allows us to view who actually made what review and for what restaur
--Expected: A table with restaurant name, first/last name of the user who rated it and user rating sorted by lowest to highest reviews.

Select Restaurant.Restaurant_Name, FR_USER.First_Name, FR_USER.Last_Name, USER_REVIEW.User_Rating
FROM USER_REVIEW
INNER JOIN RESTAURANT on RESTAURANT.Restaurant_Id = USER_REVIEW.Restaurant_Id
INNER JOIN FR_USER on USER_REVIEW.FR_User_Id = FR_USER.FR_User_Id
ORDER BY User_Rating;

--************************************************************************************************	

--Query 2
--Purpose: retrieve all of the restaurants where the rating is greater than a 4.0 and group them by their name.  This is useful because 
--there may be scenarios where someone doesn’t know where they want to eat but can then choose from a list of places with good ratings.
--Expected: a table with the names of the restaurants who fit this category of having a rating higher than 4.0

SELECT Restaurant_Name 
AS 'Great Restaurants'
FROM RESTAURANT
WHERE Restaurant_Id = ANY (SELECT Restaurant_Id
							FROM RESTAURANT
							WHERE RATING >= 4.0 )
GROUP BY Restaurant_Name;
							
--************************************************************************************************			
				
--Query 3
--Purpose: Select all users and information from state = WA
--Expected: A table that has all users and their informations that are from WA

SELECT *
FROM FR_USER
WHERE FR_User_State IN (SELECT FR_User_State 
						FROM FR_USER 
						WHERE FR_User_State = 'WA')

--*************************************************************************************************
--Query 4
--Purpose: Selects the user last name and restraunts in the same city as them and joins them
--Expected: A table that has all users and restaurants and matches the user with the restaurant and null otherwise if there is no match.

SELECT FR_USER.Last_Name, RESTAURANT_LOCATION.Restaurant_Id
FROM RESTAURANT_LOCATION
FULL OUTER JOIN FR_USER
ON FR_USER.FR_User_City = RESTAURANT_LOCATION.Restaurant_City 

--**************************************************************************************************
--Query 5
--Purpose: Finds all the reviews from our site and other sites and then removes outliers (reviews less than 2 stars) amd displays the average review
--Expected: A table that has all restaurant IDs with the average rating when reviews that rate less than two stars are removed

SELECT allreviews.Restaurant_Id, AVG(allreviews.USER_RATING) AS AVG_RATING
FROM
    (SELECT SITE_REVIEW.Restaurant_Id, SITE_REVIEW.User_Rating
		FROM SITE_REVIEW
		WHERE SITE_REVIEW.User_Rating >= 2.0
    UNION ALL
    SELECT USER_REVIEW.Restaurant_Id, USER_REVIEW.User_Rating
        FROM USER_REVIEW
		WHERE USER_REVIEW.User_Rating >= 2.0) allreviews
GROUP BY allreviews.Restaurant_Id;

--***************************************************************************************************
--Query 6
--Purpose: Find all the restaurants that a user has reviewed
--Expected: A table that contains the names of all the restaurants USERID 1 has reviewed

SELECT *
FROM RESTAURANT 
WHERE Restaurant_Id = ANY (Select Restaurant_Id
						FROM	USER_REVIEW
						WHERE	USER_REVIEW.FR_User_Id = 1);

--**************************************************************************************************
--Query 7
--Purpose: Selects the restaurant and shows the average rating it has recieved across all website platforms that are not our own. This is useful because
--what if the user wants to see the total review rating from all websites and not just from EG. Google.
--Expected: A table that has the restaurant name as well as the average rating from all websites besides ours.

SELECT RESTAURANT.Restaurant_Name as 'Restaurant Name', AVG(SITE_REVIEW.User_Rating) as 'Average Rating From All Websites'
FROM RESTAURANT
FULL JOIN SITE_REVIEW
ON SITE_REVIEW.Restaurant_Id = RESTAURANT.Restaurant_Id
GROUP BY RESTAURANT.Restaurant_Name
ORDER BY RESTAURANT.Restaurant_Name
							
--**************************************************************************************************
--Query 8
--Purpose: retrieve the american restaurants which is useful because the user may only want to get food from an American cuisine type
--rather than going elsewhere
--Expected: a table with all of the information regarding the restaurant including the id, name, address, city, state, phone number, rating

SELECT *
FROM RESTAURANT as R1
WHERE EXISTS (SELECT *
			  FROM CUISINE as c
			  WHERE R1.Restaurant_Id = C.Restaurant_Id AND C.Cuisine_Type = 'AMERICAN');



--***************************************************************************************************
--Query 9
--Purpose: Retrieve all the pizza cuisines that exists in the database. This is useful because the user may just want to have pizza so it
--is important that they are given all their options.
--Expected: a table with all the pizza locations.

SELECT *
FROM RESTAURANT as R1
WHERE EXISTS (SELECT *
			  FROM CUISINE as c
			  WHERE R1.Restaurant_Id = C.Restaurant_Id AND C.Cuisine_Type = 'PIZZA');

--*****************************************************************************************************
--Query 10
--Purpose: Find all the restaurants that are located within the same city than Yeager lives in
--Expected: A table of restaurant information for the city of Tacoma where Yeager lives.
SELECT *
FROM RESTAURANT, RESTAURANT_LOCATION
WHERE RESTAURANT.Restaurant_Id = RESTAURANT_LOCATION.Restaurant_Id AND
RESTAURANT_LOCATION.Restaurant_City =	(SELECT FR_USER.FR_User_City
										 FROM FR_USER
										WHERE FR_USER.First_Name = 'Yeager');


--*****************************************************************************************************



	
				
