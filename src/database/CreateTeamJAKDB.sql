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
    dateCreated DATETIME DEFAULT NOW(),
    userPassword VARCHAR(255) NOT NULL,
    userStatusCode VARCHAR(10) NOT NULL DEFAULT 'ACV',
    unblockDate DATETIME NULL,
    CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('USR_Type',userTypeCode)),
    CONSTRAINT CHK_CODE CHECK (JAK_FN_ValidateCode('USR_Status',userStatusCode))
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
        scl.Description as 'StatusDescription'
	FROM JAK_User u 
    INNER JOIN JAK_SupportCodeLists scl ON scl.CodeType='USR_Status' AND scl.Code=u.userStatusCode 
	WHERE u.userName = userName;
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
 ('USR_Status','TBLOCK','Temporarily Blocked.');
 
# Create some users now
INSERT INTO JAK_User ( userName, userTypeCode, userStatusCode, userPassword)
VALUES
-- create some admin users
('admin','ADMIN','ACV',SHA('admin')),
('admin1','ADMIN','ACV',SHA('admin1')),
('admin2','ADMIN','ACV',SHA('admin2')),
('admin3','ADMIN','ACV',SHA('admin3')),
-- create some chef users
('chef','CHEF','ACV',SHA('chef')),
('chef1','CHEF','ACV',SHA('chef1')),
('chef2','CHEF','ACV',SHA('chef2')),
('chef3','CHEF','ACV',SHA('chef3')),
('chef4','CHEF','ACV',SHA('chef4')),
('chef5','CHEF','ACV',SHA('chef5')),
('chef6','CHEF','ACV',SHA('chef6')),
('chef7','CHEF','ACV',SHA('chef7')),
('chef8','CHEF','ACV',SHA('chef8')),
('chef9','CHEF','ACV',SHA('chef9')),
-- create some consumer users
('user','USR','ACV',SHA('user')),
('user1','USR','ACV',SHA('user1')),
('user2','USR','ACV',SHA('user2')),
('user3','USR','ACV',SHA('user3')),
('user4','USR','ACV',SHA('user4')),
('user5','USR','ACV',SHA('user5')),
('user6','USR','ACV',SHA('user6')),
('user7','USR','ACV',SHA('user7')),
('user8','USR','ACV',SHA('user8')),
('user9','USR','ACV',SHA('user9'));

##############################################################################################################################################
#########################################################       Test login        ###########################################################
##############################################################################################################################################
# admin login
CALL JAK_SP_ProcessLogin('admin','admin');
# chef login

# user login
##############################################################################################################################################
######################################################       END        ######################################################################
##############################################################################################################################################
