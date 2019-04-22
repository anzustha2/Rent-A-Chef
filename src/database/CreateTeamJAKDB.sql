# CS-420 Team-JAK
# Author Jeremy/Anju/Keshab
DROP DATABASE IF EXISTS Rent_A_Chef_db;
CREATE DATABASE Rent_A_Chef_db;
GRANT ALL PRIVILEGES ON Rent_A_Chef_db.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
USE Rent_A_Chef_db;

##############################################################################################################################################
######################################################       TABLES         ##################################################################
##############################################################################################################################################
# SELECT * FROM JAK_SupportCodeLists
CREATE TABLE JAK_SupportCodeLists -- Codes, and description.
(
	CodeType VARCHAR(15) NOT NULL,
    Code VARCHAR(10) NOT NULL,
    Description VARCHAR(200) NULL,
    PRIMARY KEY(CodeType,Code)
);

# Create the table for login user.
# SELECT * FROM JAK_User
CREATE TABLE JAK_User(
	userId BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	userName VARCHAR(50) UNIQUE NOT NULL,
    userTypeCode VARCHAR(10) NOT NULL,
    dateCreated  VARCHAR(40) ,
    userPassword VARCHAR(255) NOT NULL,
    userStatusCode VARCHAR(10) NOT NULL DEFAULT 'ACV',
    unblockDate VARCHAR(50) NULL,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    phoneNo VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL,
    CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('USR_Type',userTypeCode)),
    CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('USR_Status',userStatusCode))
);

# Create the table for user address
CREATE TABLE JAK_Address(
	addressId BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    userId BIGINT,
	address1 VARCHAR(200) NOT NULL,
    address2 VARCHAR(50) NOT NULL,
    city VARCHAR(15) NOT NULL,
    state VARCHAR(15) NOT NULL,
    zip VARCHAR(15) NOT NULL,
    addressTypeCode VARCHAR(10) NOT NULL,
    FOREIGN KEY (userId) REFERENCES JAK_User(userId),
    CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('Address_Type',addressTypeCode))
);

# Create table for Ingredient
CREATE TABLE JAK_Ingredient(
	ingredientId BIGINT PRIMARY KEY NOT NULL,
    ingredientName VARCHAR(50) NOT NULL,
    description VARCHAR (500),
    imagePath VARCHAR(100),
    videoPath VARCHAR(100)
);
# Create table for Dish
CREATE TABLE JAK_Dish(
	dishId BIGINT PRIMARY KEY NOT NULL,
    dishName VARCHAR(50) NOT NULL,
    description VARCHAR (500),
    cuisineTypeCode VARCHAR(50) DEFAULT 'ALL',
    unitTypeCode VARCHAR(50) DEFAULT 'CT',
    baseUnits DOUBLE DEFAULT 1,
    imagePath VARCHAR(100),
    videoPath VARCHAR(100),
    estCost DOUBLE,
	CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('Cuisine_Type',cuisineTypeCode)),
    CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('Unit_Type',unitTypeCode))
);

# Create table for the recipe
CREATE TABLE JAK_Recipe(
	dishId BIGINT NOT NULL,
    ingredientId BIGINT NOT NULL,
    unitTypeCode VARCHAR(20),
    units DOUBLE,
    PRIMARY KEY (dishId, ingredientId),
    CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('Unit_Type',unitTypeCode)
));

# Create table for the orders
CREATE TABLE JAK_Order(
	orderId BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    userId BIGINT NOT NULL,
    chefId BIGINT,
    createdTimestamp VARCHAR(50),
    expireDateTime NVARCHAR(50),
    scheduledDateTime NVARCHAR(50),
    scheduledAddressId BIGINT,
    completionDateTime NVARCHAR(50),
    pickedUpDateTime NVARCHAR(50),
    orderStatusCode VARCHAR(20) DEFAULT 'IP',
    estCostWithoutTax DOUBLE DEFAULT 0.0,
    estTax DOUBLE DEFAULT 0.0,
    actualAmountWithoutTax DOUBLE,
    actualTax DOUBLE,
    FOREIGN KEY (userId) REFERENCES JAK_User(userId),
    FOREIGN KEY (chefId) REFERENCES JAK_User(userId),
    CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('Order_Status',orderStatusCode))
);
# Create table for the orders
CREATE TABLE JAK_OrderItem(
	orderId BIGINT,
    dishId BIGINT,
    unitTypeCode VARCHAR (50),
    units DOUBLE,
    estCostWithoutTax DOUBLE,
    estTax DOUBLE,
    FOREIGN KEY (orderId) REFERENCES JAK_Order(orderId),
    FOREIGN KEY (dishId) REFERENCES JAK_Dish(dishId),
    CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('Unit_Type',unitTypeCode))
);

DELIMITER ;
##############################################################################################################################################
######################################################       FUNCTIONS         ###############################################################
##############################################################################################################################################
DELIMITER $$
CREATE FUNCTION JAK_FN_ValidateCode (codeTypeV VARCHAR(20), codeV VARCHAR(10))
RETURNS BOOLEAN DETERMINISTIC
BEGIN
	SELECT COUNT(*) 
		INTO @count 
		FROM JAK_SupportCodeLists scl
		WHERE scl.CodeType=codeTypeV
		AND scl.Code=codeV;
	RETURN @count>0;
END $$

DELIMITER ;


##############################################################################################################################################
######################################################       Stored Procedures         #######################################################
##############################################################################################################################################
DELIMITER $$

#This stored procedure will return the userId, userTypeCode, userStatusCode, unblockDate, incorrectPassword, and status description of user
CREATE PROCEDURE JAK_SP_ProcessLogin(
	IN userName VARCHAR(50),
	IN userPassword VARCHAR(50)
)
BEGIN
	SELECT u.userId,
		u.userTypeCode,
		u.userStatusCode,
        u.unblockDate,
		(u.userPassword <> SHA(userPassword)) as 'IsIncorrectPassword',
        scl.Description as 'StatusDescription',
        firstName,
        lastName,
        email,
        phoneNo
	FROM JAK_User u 
    INNER JOIN JAK_SupportCodeLists scl ON scl.CodeType='USR_Status' AND scl.Code=u.userStatusCode 
	WHERE u.userName = userName;
END $$


# we could have multiple address for same user.
CREATE PROCEDURE JAK_SP_AddUserAddress(
		IN userIdIn BIGINT,
		IN address1In VARCHAR(100),
		IN address2In VARCHAR(50),
		IN cityIn VARCHAR(20),
		IN stateIn VARCHAR(20),
		IN zipIn VARCHAR(20),
		IN addressTypeCodeIn VARCHAR(20)
)
BEGIN 
	INSERT INTO JAK_Address (userId, address1, address2, city, state,zip,addressTypeCode)
    VALUES (userIdIn, address1In, address2In, cityIn, stateIn, zipIn, addressTypeCodeIn);
	SELECT LAST_INSERT_ID();
END $$
#This stored procedure will return the address for the given userId
# we could have multiple address for same user.
CREATE PROCEDURE JAK_SP_GetUserAddress(
	IN userId BIGINT
)
BEGIN 
	SELECT 
		a.addressId,
        a.userId,
		a.address1,
		a.address2,
		a.city,
		a.state,
		a.zip,
		a.addressTypeCode,
        scl.Description AS 'AddressDescription'
    FROM JAK_Address a
    INNER JOIN JAK_SupportCodeLists scl ON scl.CodeType='Address_Type' AND scl.Code=a.addressTypeCode
    WHERE a.userId= userId;
END $$

#This stored procedure will return the address for the given addressId
CREATE PROCEDURE JAK_SP_GetAddress(
	IN addressId BIGINT
)
BEGIN 
	SELECT 
		a.addressId,
        a.userId,
		a.address1,
		a.address2,
		a.city,
		a.state,
		a.zip,
		a.addressTypeCode,
        scl.Description AS 'AddressDescription'
    FROM JAK_Address a
    INNER JOIN JAK_SupportCodeLists scl ON scl.CodeType='Address_Type' AND scl.Code=a.addressTypeCode
    WHERE a.addressId= addressId;
END $$

CREATE PROCEDURE JAK_SP_GetDishes(
	IN cuisineTypeCode VARCHAR(50)
)
BEGIN
	SELECT
		d.dishId,
		d.dishName,
		d.description,
		d.cuisineTypeCode,
		d.imagePath,
		d.videoPath,
        d.estCost,
        d.unitTypeCode,
        d.baseUnits,
        scl.Description as 'Cuisine',
        scl2.Description as 'UnitType'
    FROM JAK_Dish d
    INNER JOIN JAK_SupportCodeLists scl ON scl.CodeType='Cuisine_Type' AND scl.Code=d.cuisineTypeCode
    INNER JOIN JAK_SupportCodeLists scl2 ON scl2.CodeType='Unit_Type' AND scl2.Code=d.unitTypeCode
    WHERE d.cuisineTypeCode=cuisineTypeCode OR cuisineTypeCode='ALL' OR d.cuisineTypeCode='ALL';
END $$

CREATE PROCEDURE JAK_SP_GetDish(
	IN dishIdIn BIGINT
)
BEGIN
	SELECT
		d.dishId,
		d.dishName,
		d.description,
		d.cuisineTypeCode,
		d.imagePath,
		d.videoPath,
        d.estCost,
        d.unitTypeCode,
        d.baseUnits,
        scl.Description as 'Cuisine',
        scl2.Description as 'UnitType'
    FROM JAK_Dish d
    INNER JOIN JAK_SupportCodeLists scl ON scl.CodeType='Cuisine_Type' AND scl.Code=d.cuisineTypeCode
    INNER JOIN JAK_SupportCodeLists scl2 ON scl2.CodeType='Unit_Type' AND scl2.Code=d.unitTypeCode
    WHERE d.dishId = dishIdIn;
END $$

CREATE PROCEDURE JAK_SP_GetDishIngredients(
	IN dishId BIGINT
)
BEGIN 
	SELECT
		i.ingredientId,
		i.ingredientName,
		i.description,
		i.imagePath,
		i.videoPath,
        r.unitTypeCode,
        r.units,
        scl.Description as 'UnitType'
	FROM JAK_Recipe r
    INNER JOIN JAK_Dish d ON d.dishId = r.dishId
    INNER JOIN JAK_Ingredient i ON i.ingredientId = r.ingredientId
    INNER JOIN JAK_SupportCodeLists scl ON scl.CodeType='Unit_Type' AND scl.Code=r.unitTypeCode
    WHERE r.dishId = dishId;
END $$
   
CREATE PROCEDURE JAK_SP_CreateOrder(
	IN userIdIn BIGINT,
    IN scheduledAddressIdIn BIGINT,
    IN expireDateTimeIn NVARCHAR(50),
    IN scheduledDateTimeIn NVARCHAR(50)
)
BEGIN
	INSERT INTO JAK_Order (userId, expireDateTime, scheduledAddressId, scheduledDateTime)
    VALUES (userIdIn, expireDateTimeIn, scheduledAddressIdIn, scheduledDateTimeIn);
    	
	SELECT  LAST_INSERT_ID();
END $$



CREATE PROCEDURE JAK_SP_AddOrderItem(
	orderIdIn BIGINT,
    dishIdIn BIGINT,
    unitTypeCodeIn VARCHAR (50),
    unitsIn DOUBLE,
    estCostWithoutTaxIn DOUBLE,
    estTaxIn DOUBLE
)
BEGIN
	INSERT INTO JAK_OrderItem (orderId, dishId, unitTypeCode, units, estCostWithoutTax, estTax)
    VALUES (orderIdIn, dishIdIn, unitTypeCodeIn, unitsIn, estCostWithoutTaxIn, estTaxIn);
    
    UPDATE JAK_Order
    SET estCostWithoutTax = estCostWithoutTax + estCostWithoutTaxIn,
		estTax = estTax+ estTaxIn
	WHERE orderId = orderIdIn;
END $$

CREATE PROCEDURE JAK_SP_GetOrderItems(
	orderIdIn BIGINT
)
BEGIN
	SELECT 
		o.orderId,
		d.dishId,
        d.dishName,
		d.description,
        d.cuisineTypeCode,
        d.imagePath,
        d.videoPath,
        d.estCost,
        i.unitTypeCode,
        i.units,
        i.estCostWithoutTax,
        i.estTax,
        scl1.Description as 'cuisineType',
        scl2.Description as 'unitType'
        
    FROM JAK_Order o
    INNER JOIN JAK_OrderItem i ON o.orderId=i.orderId
    INNER JOIN JAK_Dish d ON i.dishId=d.dishId
    INNER JOIN JAK_SupportCodeLists scl1 ON scl1.CodeType='Cuisine_Type' AND scl1.Code=d.cuisineTypeCode
   INNER JOIN JAK_SupportCodeLists scl2 ON scl2.CodeType='Unit_Type' AND scl2.Code=i.unitTypeCode
    Where o.orderId=orderIdIn;
END $$

CREATE PROCEDURE JAK_SP_GetOrders(
	userIdIn BIGINT,
	orderStatusCodeIn NVARCHAR(10)
)
BEGIN
	SELECT 
		o.orderId,
		o.userId,
		o.chefId,
		o.createdTimestamp,
		o.expireDateTime,
		o.scheduledDateTime,
		o.scheduledAddressId,
		o.completionDateTime,
		o.pickedUpDateTime,
		o.orderStatusCode,
		o.estCostWithoutTax,
		o.estTax,
		o.actualAmountWithoutTax,
		o.actualTax,
        scl.Description as 'OrderStatus'
        FROM JAK_Order o
        INNER JOIN JAK_SupportCodeLists scl ON scl.CodeType='Order_Status' AND scl.Code=o.orderStatusCode
        WHERE (o.chefId=userIdIn OR o.userId=userIdIn OR userIdIn=0) 
        AND (orderStatusCodeIn='ALL' OR orderStatusCodeIn=o.orderStatusCode)
        AND (orderStatusCode<>'C' AND orderStatusCode<>'IP');
END$$

CREATE PROCEDURE JAK_SP_GetOrder(
	orderIdIn BIGINT
)
BEGIN
	SELECT 
		o.orderId,
		o.userId,
		o.chefId,
		o.createdTimestamp,
		o.expireDateTime,
		o.scheduledDateTime,
		o.scheduledAddressId,
		o.completionDateTime,
		o.pickedUpDateTime,
		o.orderStatusCode,
		o.estCostWithoutTax,
		o.estTax,
		o.actualAmountWithoutTax,
		o.actualTax,
        scl.Description as 'OrderStatus'
        FROM JAK_Order o
         INNER JOIN JAK_SupportCodeLists scl ON scl.CodeType='Order_Status' AND scl.Code=o.orderStatusCode

        WHERE o.orderId = orderIdIn;
END$$

CREATE PROCEDURE JAK_SP_UpdateOrder(
	orderIdIn BIGINT,
	chefIdIn BIGINT,
	expireDateTimeIn VARCHAR(50),
	scheduledDateTimeIn VARCHAR(50),
	scheduledAddressIdIn BIGINT ,
	completionDateTimeIn VARCHAR(50),
	pickedUpDateTimeIn VARCHAR(50),
	orderStatusCodeIn NVARCHAR(10),
	estCostWithoutTaxIn DOUBLE,
	estTaxIn DOUBLE,
	actualAmountWithoutTaxIn DOUBLE,
	actualTaxIn DOUBLE
)
BEGIN
	UPDATE  JAK_Order
    SET 
		chefId= CASE WHEN chefIdIn >0 THEN chefIdIn ELSE NULL END,
		expireDateTime=expireDateTimeIn,
		scheduledDateTime=scheduledDateTimeIn,
		scheduledAddressId=scheduledAddressIdIn,
		completionDateTime=completionDateTimeIn,
		pickedUpDateTime=pickedUpDateTimeIn,
		orderStatusCode=orderStatusCodeIn,
		estCostWithoutTax=estCostWithoutTaxIn,
		estTax=estTaxIn,
		actualAmountWithoutTax=actualAmountWithoutTaxIn,
		actualTax=actualTaxIn
	WHERE (orderId=orderIdIn); 
END$$

CREATE PROCEDURE JAK_SP_updateOrderItem(
	IN orderIdIn BIGINT,
    IN dishIdIn BIGINT,
    IN unitTypeCodeIn VARCHAR (50),
    IN unitsIn DOUBLE,
    IN estCostWithoutTaxIn DOUBLE,
    IN estTaxIn DOUBLE
)
BEGIN
	SELECT estCostWithoutTax,estTax INTO @oldEstCost,@oldEstTax
    FROM JAK_OrderItem
    WHERE orderId=orderIdIn AND dishId=dishIdIn;
    
	UPDATE JAK_OrderItem 
    SET unitTypeCode=unitTypeCodeIn, 
		units=unitsIn,
        estCostWithoutTax=estCostWithoutTaxIn, 
        estTax=estTaxIn
        WHERE orderId=orderIdin AND dishId=dishIdIn;
    UPDATE JAK_Order
    SET estCostWithoutTax = estCostWithoutTax + estCostWithoutTaxIn - @oldEstCost,
		estTax = estTax+ estTaxIn - @oldEstTax
	WHERE orderId = orderIdIn;
END $$

CREATE PROCEDURE JAK_SP_RemoveOrderItem(
	IN orderIdIn BIGINT,
    IN dishIdIn BIGINT
)
BEGIN
	SELECT estCostWithoutTax,estTax INTO @oldEstCost,@oldEstTax
    FROM JAK_OrderItem
    WHERE orderId=orderIdIn AND dishId=dishIdIn LIMIT 1;
    
	UPDATE JAK_Order
    SET estCostWithoutTax = estCostWithoutTax - @oldEstCost,
		estTax = estTax - @oldEstTax
	WHERE orderId = orderIdIn;
    
    DELETE FROM JAK_OrderItem
    WHERE orderId=orderIdIn AND dishId=dishIdIn LIMIT 1;
END $$

CREATE PROCEDURE JAK_SP_getOptions(
	IN optionTypeCodeIn VARCHAR(50)
)
BEGIN
	SELECT Code, Description
    FROM JAK_SupportCodeLists
    WHERE codeType = optionTypeCodeIn;
END $$

DELIMITER ;
##############################################################################################################################################
#########################################################       Dummy Data         ###########################################################
##############################################################################################################################################
# Insert some support code lists
-- These codes are used through out the application, 
-- Some table will have constrants associtated withe these code types.
INSERT INTO JAK_SupportCodeLists (CodeType, Code, Description) 
VALUES
-- User type codes
 ('USR_Type','ADMIN', 'Administrator.' ),
 ('USR_Type','CHEF','Chef.'),
 ('USR_Type','USR','Consumer user.'),
-- User status codes
 ('USR_Status','ACV', 'Active.' ),
 ('USR_Status','DISB','Disabled.'),
 ('USR_Status','PBLOCK','Permanently Blocked.'),
 ('USR_Status','TBLOCK','Temporarily Blocked.'),
-- address type codes
 ('Address_Type','BUS', 'Business'),
 ('Address_Type','APT', 'Appartment'),
 ('Address_Type','HOUSE', 'House'),
 ('Address_Type','OT', 'Other'),
-- cuisine type codes
 ('Cuisine_Type','ALL', 'All'),
 ('Cuisine_Type','IND', 'Indian'),
 ('Cuisine_Type','NEP', 'Nepali'),
-- unit type codes
 ('Unit_Type', 'TSP','Table Spoon'),
 ('Unit_Type', 'gm','gram'),
 ('Unit_Type', 'SP','Spoon'),
 ('Unit_Type', 'mg','milligram'),
 ('Unit_Type','oz', 'Ounce'),
 ('Unit_Type','CT', 'Count'),
 ('Unit_Type','CUP', 'Cups'),
-- Order status
 ('Order_Status','OP', 'Open'),
 ('Order_Status','EXP','Expired'),
 ('Order_Status','COMP','Completed'),
 ('Order_Status','INV','Invalid'),
 ('Order_Status','IP','In-Progress'),
 ('Order_Status','PU','Picked-Up'),
 ('Order_Status','C','Cancelled')
 ;
 
# Create some users now
INSERT INTO JAK_User ( userName, userTypeCode, userStatusCode, userPassword, firstName, lastName, email, phoneNo)
VALUES
-- create some admin users
('admin','ADMIN','ACV',SHA('admin'), 'Maggie','Sargent',"sem.ut.cursus@eu.com","928-791-1624"),
('admin1','ADMIN','ACV',SHA('admin1'),'Troy','Burch','imperdiet@leo.com','137-479-9803'),
('admin2','ADMIN','ACV',SHA('admin2'),'Gwendolyn','Lambert','ut.dolor.dapibus@Innecorci.com','770-238-2794'),
-- create some chef users
('chef','CHEF','ACV',SHA('chef'),'Roanna','Norton','tincidunt.dui.augue@Innec.net','129-906-6862'),
('chef1','CHEF','ACV',SHA('chef1'),'Colt','Jacobs','tortor.Nunc@tempordiam.co.uk','594-879-0217'),
('chef2','CHEF','ACV',SHA('chef2'),'Maggie','Sargent','sem.ut.cursus@eu.com','928-791-1624'),

-- create some consumer users
('user','USR','ACV',SHA('user'),'Alfreda','Johns','lorem.ut.aliquam@inaliquet.com','957-798-7904'),
('user1','USR','ACV',SHA('user1'),'Morgan','Padilla','Duis.cursus@pedesagittis.co.uk','351-937-7795'),
('user2','USR','ACV',SHA('user2'),'Chantale','Frank','odio.tristique@tempus.co.uk','919-128-0324');

# Add some addresses for the users
INSERT INTO JAK_ADDRESS(userId, address1, address2, city, state, zip, addressTypeCode)
VALUES (1, '1 N State St', 'APT 202', 'Chicago','IL', '60660','APT'),
(2, '10 N State St', 'APT 202', 'Chicago','IL', '60660','APT'),
(3, '11 N State St', 'APT 202', 'Chicago','IL', '60660','APT'),
(4, '21 N State St', 'APT 202', 'Chicago','IL', '60660','APT'),
(5, '5800 N Clark St', 'APT 202', 'Chicago','IL', '60660','APT'),
(6, '800 N Halstead St', 'APT 202', 'Chicago','IL', '60660','APT'),
(7, '2100 W Peterson St', 'APT 202', 'Chicago','IL', '60660','APT'),
(8, '1400 W Foster St', 'APT 202', 'Chicago','IL', '60660','APT'),
(9, '1200 N Racine St', 'APT 202', 'Chicago','IL', '60660','APT');

# Add some ingredients
INSERT INTO JAK_Ingredient(ingredientId,ingredientName,description,imagePath,videoPath)
VALUES(1,'Sugar', 'Sweet powder made out of sugarcane liquid', 'sugar.png',''),
(2,'Salt', 'Salt powder Sodium Chloride: NaCl', 'salt.png',''),
(3,'Tealeaf', 'Tea leafs powder', 'tea.png',''),
(4,'Water','Natural clean water','water.png',''),
(5,'Milk','Whole milk','wholeMilk.png',''),
(6,'Black Pepper','spicy black pepper','blackPepper.png','');

#Add some dishes
INSERT INTO JAK_Dish(dishId,dishName, description, cuisineTypeCode,unitTypeCode,baseUnits, imagePath, videoPath, estCost)
VALUES(1,'Red tea','hot sweet red tea','ALL','CUP',1,'redtea.png','https://www.youtube.com/watch?v=GWUkMHUUOVQ',2.50),
(2,'Masala tea','hot sweet tea with milk','IND','CUP',1,'masalaTea.png','https://www.youtube.com/watch?v=6qU5FkbXob8',2.75),
(3,'Mountain tea','hot sweet tea with milk and black pepper','NEP','CUP',1,'mountainTea.png','',3.00);


#Create recipe for the dishes
INSERT INTO JAK_Recipe(dishId,ingredientId,unitTypeCode,units)
VALUES
-- red tea
(1, 1, 'sp', 1),
(1,3,'sp',0.5),
(1,4,'oz',24),
-- masala tea
(2, 1, 'sp', 1),
(2,3,'sp',0.5),
(2,4,'oz',16),
(2,5,'oz',8),
-- mountain tea
(3, 1, 'sp', 1),
(3,3,'sp',0.5),
(3,4,'oz',16),
(3,5,'oz',8),
(3,6,'sp',0.25);


##############################################################################################################################################
#########################################################       Test        ###########################################################
##############################################################################################################################################
# admin login
/*
CALL JAK_SP_ProcessLogin('admin','admin');
CALL JAK_SP_GetUserAddress(1);
CALL JAK_SP_GetAddress(9);
CALL JAK_SP_GetDishes('IND');
CALL JAK_SP_GetDishes('ALL');
CALL JAK_SP_GetDishIngredients(3);

CALL JAK_SP_CreateOrder(7,7,NOW()+INTERVAL 1 DAY,NOW()+ INTERVAL 6 HOUR);
CALL JAK_SP_AddOrderItem(1, 1,'CUP',1,25,2.5);
CALL JAK_SP_AddOrderItem (1, 2,'CUP',2,27.5,2.75);
CALL JAK_SP_updateOrderItem(1,1,'CUP',4,250,25);
CALL JAK_SP_GetOrders(7,'OP');
CALL JAK_SP_UpdateOrder(1,5,null,NOW()+INTERVAL 6 Hour,7,null,NOW()+INTERVAL 6 Hour,'PU',277.5,27.75,null,null);
CALL JAK_SP_GetOrders(5,'P');
CALL JAK_SP_GetOrderItems(1);
CALL JAK_SP_AddUserAddress(1,'123 main st', '202','chicago','IL','60660','APT');

CALL JAK_SP_GetOptions('Cuisine_Type');

CALL JAK_SP_GetOrder(1);
CALL JAK_SP_GetDishIngredients(1);

CALL JAK_SP_GetDish(2);

select * from JAK_Order;
select * from JAK_OrderItem;
CALL JAK_SP_RemoveOrderItem(2,3);*/
# chef login

# user login
##############################################################################################################################################
######################################################       END        ######################################################################
##############################################################################################################################################
