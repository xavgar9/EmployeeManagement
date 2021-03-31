SET GLOBAL log_bin_trust_function_creators = 1;
###########################################################################################
                                    #RefreshUsers
###########################################################################################
DROP FUNCTION IF EXISTS RefreshUsers;
DELIMITER //
CREATE FUNCTION RefreshUsers(name VARCHAR(50), username VARCHAR(50), department VARCHAR(50), agency VARCHAR(50))
  RETURNS VARCHAR(20)
 
  BEGIN
    DECLARE s VARCHAR(20);    
    IF (EXISTS(SELECT 1 FROM Users WHERE Users.Username=username)) THEN
            UPDATE Users SET Name=name,Username=username,Department=department,Agency=agency WHERE Users.Username=username;
            SET s = "Update";
	  ELSE
            INSERT INTO Users (Name,Username,Department,Agency,Access)
        			   VALUES (name, username, department, agency, 1);
            SET s = "Insert";
    END IF;
    RETURN s;
  END //
DELIMITER ;

###########################################################################################
                                    #SaveToken
###########################################################################################
DROP FUNCTION IF EXISTS SaveToken;
DELIMITER //
CREATE FUNCTION SaveToken(username VARCHAR(50), token VARCHAR(500), expirationDate VARCHAR(19))
  RETURNS VARCHAR(20)

  BEGIN
    DECLARE userID INT;    
    DECLARE s VARCHAR(20);

    IF (EXISTS(SELECT 1 FROM Users WHERE Users.Username=username)) THEN
        SELECT Users.ID INTO userID FROM Users WHERE Users.Username=username;
        IF (EXISTS(SELECT 1 FROM Sessions WHERE Sessions.User=userID)) THEN
          UPDATE Sessions SET Token=token, ExpirationDate=expirationDate WHERE Sessions.User=userID;
          SET s = "Updated";
        ELSE
            INSERT INTO Sessions (User, Token, ExpirationDate)
                VALUES (userID, token, expirationDate);
            SET s = "Insert";
        END IF;                                        
    ELSE
        SET s = "User doesnt exist";
    END IF;
    RETURN s;
  END //
DELIMITER ;

###########################################################################################
                                    #DeleteToken
###########################################################################################
DROP FUNCTION IF EXISTS DeleteToken;
DELIMITER //
CREATE FUNCTION DeleteToken(token VARCHAR(500))
  RETURNS VARCHAR(20)

  BEGIN
    DECLARE s VARCHAR(20);

    IF (EXISTS(SELECT 1 FROM Sessions WHERE Sessions.Token=token)) THEN
            DELETE FROM Sessions WHERE Sessions.Token=token;
            SET s = "Deleted";
    ELSE
            SET s = "Token doesnt exist";
    END IF;
    RETURN s;
  END //
DELIMITER ;

###########################################################################################
                                    #IsValidToken
###########################################################################################
DROP FUNCTION IF EXISTS IsValidToken;
DELIMITER //
CREATE FUNCTION IsValidToken(user INT, token VARCHAR(500))
  RETURNS VARCHAR(20)

  BEGIN
    DECLARE s VARCHAR(20);

    IF (EXISTS(SELECT 1 FROM Sessions WHERE Sessions.User=user AND Sessions.Token=token AND Sessions.ExpirationDate>NOW())) THEN
            SET s = "True";
    ELSE
            SET s = "False";
    END IF;
    RETURN s;
  END //
DELIMITER ;

###########################################################################################
                                    #CreateRequest
###########################################################################################
DROP FUNCTION IF EXISTS CreateRequest;
DELIMITER //
CREATE FUNCTION CreateRequest(petitioner INT, statuss VARCHAR(50), company VARCHAR(50), agency VARCHAR(50), client VARCHAR(100), machineModel VARCHAR(50), referencess JSON, description VARCHAR(300), priority VARCHAR(20))
  RETURNS VARCHAR(20)

  BEGIN
    DECLARE s INT;

    IF (EXISTS(SELECT 1 FROM Users WHERE Users.ID=petitioner)) THEN
        INSERT INTO Requests (CreationDate, Petitioner, Statuss, Company, Agency, Client, MachineModel, Referencess, Description, Priority, Note)
            VALUES (NOW(), petitioner, statuss, company, agency, client, machineModel, referencess, description, priority, '');
        
        INSERT INTO RequestsChanges (Changer, Request, CreationDate, Statuss, Note)
            VALUES (petitioner, last_insert_id(), NOW(), statuss, '');
            SET s = last_insert_id();
    ELSE
            SET s = 0;
    END IF;
    RETURN s;
  END; //
DELIMITER;

###########################################################################################
                                    #UpdateRequestStatus
###########################################################################################
DROP FUNCTION IF EXISTS UpdateRequestStatus;
DELIMITER //
CREATE FUNCTION UpdateRequestStatus(requestID INT, changerID INT, statuss VARCHAR(50), note VARCHAR(300))
  RETURNS VARCHAR(20)

  BEGIN
    DECLARE s VARCHAR(20);
    SET s = "Not created";

    IF (EXISTS(SELECT 1 FROM Users WHERE Users.ID=changerID)) THEN
        IF (EXISTS(SELECT 1 FROM Requests WHERE Requests.ID=requestID)) THEN
            INSERT INTO RequestsChanges (Request, Changer, CreationDate, Statuss, Note)
              VALUES (requestID, changerID, NOW(), statuss, note);
            UPDATE Requests SET Statuss=statuss, Note=note  WHERE Requests.ID=requestID;
            SET s = "Updated";
        END IF;
    END IF;
    RETURN s;
  END //
DELIMITER;

###########################################################################################
                                    #GetAllRequests
###########################################################################################
DROP PROCEDURE IF EXISTS GetAllRequests;
DELIMITER //
CREATE PROCEDURE GetAllRequests(petitioner INT)

  BEGIN
    DECLARE userAccess INT;
    
    IF (EXISTS(SELECT 1 FROM Users WHERE Users.ID=petitioner)) THEN
        SELECT Users.Access INTO userAccess FROM Users WHERE Users.ID = petitioner;
        IF (userAccess = 1) THEN
          SELECT Requests.ID, Requests.CreationDate, Requests.Petitioner, Users.Name, Users.Username, Requests.Statuss, Requests.Company, Requests.Agency, Requests.Client, Requests.MachineModel, Requests.Referencess, Description, Priority, Note FROM Requests INNER JOIN Users ON Requests.Petitioner = Users.ID AND Requests.Petitioner=petitioner ORDER BY Requests.CreationDate DESC;
        ELSEIF (userAccess = 3) THEN
          SELECT Requests.ID, Requests.CreationDate, Requests.Petitioner, Users.Name, Users.Username, Requests.Statuss, Requests.Company, Requests.Agency, Requests.Client, Requests.MachineModel, Requests.Referencess, Description, Priority, Note FROM Requests INNER JOIN Users ON Requests.Petitioner = Users.ID ORDER BY Requests.CreationDate DESC;            
        END IF;
    END IF;
  END //
DELIMITER;






###########################################################################################
                                    #CreateUser
###########################################################################################
DROP FUNCTION IF EXISTS CreateUser;
DELIMITER //
CREATE FUNCTION CreateUser(firstLastName VARCHAR(20), secondLastName VARCHAR(20), firstName VARCHAR(20), otherNames VARCHAR(50), CountryID INT, IdTypes INT, IdentificationDocument VARCHAR(20), Email VARCHAR(300), StartDate DATETIME, AreaID INT, Status VARCHAR(20))
  RETURNS VARCHAR(20)

  BEGIN
    DECLARE s INT;
    SET s = 0;
    INSERT INTO Users(FirstLastName, SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate)
        VALUES (firstLastName, secondLastName, firstName, otherNames, countryID, idTypes, identificationDocument, email, startDate, areaID, status, NOW());
        SET s = last_insert_id();         
    RETURN s;
  END; //
DELIMITER;


###########################################################################################
                                    #GetAllUsers
###########################################################################################
DROP PROCEDURE IF EXISTS GetAllUsers;
DELIMITER //
CREATE PROCEDURE GetAllUsers()

  BEGIN    
    SELECT Users.ID, Users.FirstLastName, Users.SecondLastName, Users.FirstName, Users.OtherNames, Countries.ID AS CountryID, Countries.Name AS Country, IdTypes.ID AS DocumentTypeID, IdTypes.Name AS DocumentType, Users.IdentificationDocument, Users.Email, Users.StartDate, Users.Status, Area.ID AS AreaID, Area.Name AS AreaName, Users.RegisterDate
      FROM Users INNER JOIN IdTypes INNER JOIN Area INNER JOIN Countries ON Users.CountryID=Countries.ID AND Users.IdTypes=IdTypes.ID AND Users.AreaID=Area.ID  ORDER BY Users.ID DESC;
  END //
DELIMITER;

###########################################################################################
                                    #GetUser
###########################################################################################
DROP PROCEDURE IF EXISTS GetUser;
DELIMITER //
CREATE PROCEDURE GetUser(userID INT)

  BEGIN    
    SELECT Users.ID, Users.FirstLastName, Users.SecondLastName, Users.FirstName, Users.OtherNames, Countries.ID AS CountryID, Countries.Name AS Country, IdTypes.ID AS DocumentTypeID, IdTypes.Name AS DocumentType, Users.IdentificationDocument, Users.Email, Users.StartDate, Users.Status, Area.ID AS AreaID, Area.Name AS AreaName, Users.RegisterDate
      FROM Users INNER JOIN IdTypes INNER JOIN Area INNER JOIN Countries ON Users.CountryID=Countries.ID AND Users.IdTypes=IdTypes.ID AND Users.AreaID=Area.ID AND Users.ID=userID;
  END //
DELIMITER;

###########################################################################################
                                    #UpdateUser
###########################################################################################
DROP FUNCTION IF EXISTS UpdateUser;
DELIMITER //
CREATE FUNCTION UpdateUser(userID INT, firstLastName VARCHAR(20), secondLastName VARCHAR(20), firstName VARCHAR(20), otherNames VARCHAR(50), CountryID INT, IdTypes INT, IdentificationDocument VARCHAR(20), Email VARCHAR(300), StartDate DATETIME, AreaID INT, Status VARCHAR(20))
  RETURNS VARCHAR(20)

  BEGIN
    DECLARE s VARCHAR(20);
    SET s = "Not updated";

    IF (EXISTS(SELECT 1 FROM Users WHERE Users.ID=userID)) THEN
        UPDATE Users SET 
            FirstLastName=firstLastName, SecondLastName=secondLastName, FirstName=firstName, OtherNames=otherNames, CountryID=countryID, IdTypes=idTypes, IdentificationDocument=identificationDocument, Email=email, StartDate=startDate, AreaID=areaID, Status=status, UpdateDate=NOW()
            WHERE 
            Users.ID=userID;
        SET s = "Updated";
    END IF;
    RETURN s;
  END //
DELIMITER;