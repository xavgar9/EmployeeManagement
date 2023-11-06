SET GLOBAL log_bin_trust_function_creators = 1;
###########################################################################################
                                    #ExistsDocument
###########################################################################################
DROP FUNCTION IF EXISTS ExistsDocument;
DELIMITER $$
CREATE FUNCTION ExistsDocument(identificationDocument VARCHAR(20))
  RETURNS VARCHAR(6)
  BEGIN
    DECLARE ans VARCHAR(6);

    SET ans = "false";
    # verify if exists the document
    IF (EXISTS(SELECT 1 FROM Users WHERE Users.IdentificationDocument=identificationDocument)) THEN
      SET ans = "true";
    END IF;
    RETURN ans;
  END$$
DELIMITER ;


###########################################################################################
                                    #CreateUser
###########################################################################################
DROP PROCEDURE IF EXISTS CreateUser;
DELIMITER $$
CREATE PROCEDURE CreateUser(firstLastName VARCHAR(20), secondLastName VARCHAR(20), firstName VARCHAR(20), otherNames VARCHAR(50), CountryID INT, IdTypes INT, IdentificationDocument VARCHAR(20), StartDate DATETIME, AreaID INT, Status VARCHAR(20))

  BEGIN
    DECLARE domain VARCHAR(14);
    DECLARE email VARCHAR(300);
    DECLARE existDocument VARCHAR(6);

    SELECT ExistsDocument(IdentificationDocument) INTO existDocument;
    IF (existDocument = "false") THEN
      # insert the user without the email
      INSERT INTO Users(FirstLastName, SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate)
          VALUES (firstLastName, secondLastName, firstName, otherNames, countryID, idTypes, identificationDocument, "", startDate, areaID, status, NOW());

      # domain creation for the email
      IF (countryID = 1) THEN
        SET domain = "cidenet.com.co";
      ELSEIF (countryID = 2) THEN
        SET domain = "cidenet.com.us";
      END IF;

      # creation of the email
      SELECT CONCAT(LCASE(firstName), ".", LCASE(FirstLastName), "@", domain) INTO email;

      # verify if exists the new email
      IF (EXISTS(SELECT 1 FROM Users WHERE Users.Email=email)) THEN
        SELECT CONCAT(LCASE(firstName), ".", LCASE(FirstLastName), last_insert_id(), "@", domain) INTO email;
      END IF;

      UPDATE Users SET Email=email WHERE Users.ID=last_insert_id();
      
      SELECT Users.ID, Users.FirstLastName, Users.SecondLastName, Users.FirstName, Users.OtherNames, Countries.ID AS CountryID, Countries.Name AS Country, IdTypes.ID AS DocumentTypeID, IdTypes.Name AS DocumentType, Users.IdentificationDocument, Users.Email, DATE_FORMAT(Users.StartDate,'%d-%m-%Y') AS StartDate, Users.Status, Area.ID AS AreaID, Area.Name AS AreaName, DATE_FORMAT(Users.RegisterDate,'%d-%m-%Y %h:%i:%s') AS RegisterDate
            FROM Users INNER JOIN IdTypes INNER JOIN Area INNER JOIN Countries ON Users.CountryID=Countries.ID AND Users.IdTypes=IdTypes.ID AND Users.AreaID=Area.ID AND Users.ID=last_insert_id();
    END IF;
  END$$
DELIMITER ;


###########################################################################################
                                    #GetAllUsers
###########################################################################################
DROP PROCEDURE IF EXISTS GetAllUsers;
DELIMITER $$
CREATE PROCEDURE GetAllUsers()

  BEGIN    
    SELECT Users.ID, Users.FirstLastName, Users.SecondLastName, Users.FirstName, Users.OtherNames, Countries.ID AS CountryID, Countries.Name AS Country, IdTypes.ID AS DocumentTypeID, IdTypes.Name AS DocumentType, Users.IdentificationDocument, Users.Email, DATE_FORMAT(Users.StartDate,'%d-%m-%Y') AS StartDate, Users.Status, Area.ID AS AreaID, Area.Name AS AreaName, DATE_FORMAT(Users.RegisterDate,'%d-%m-%Y %h:%i:%s') AS RegisterDate
      FROM Users INNER JOIN IdTypes INNER JOIN Area INNER JOIN Countries ON Users.CountryID=Countries.ID AND Users.IdTypes=IdTypes.ID AND Users.AreaID=Area.ID  ORDER BY Users.ID DESC;
  END$$
DELIMITER ;

###########################################################################################
                                    #GetUser
###########################################################################################
DROP PROCEDURE IF EXISTS GetUser;
DELIMITER $$
CREATE PROCEDURE GetUser(userID INT)

  BEGIN    
    SELECT Users.ID, Users.FirstLastName, Users.SecondLastName, Users.FirstName, Users.OtherNames, Countries.ID AS CountryID, Countries.Name AS Country, IdTypes.ID AS DocumentTypeID, IdTypes.Name AS DocumentType, Users.IdentificationDocument, Users.Email, DATE_FORMAT(Users.StartDate,'%d-%m-%Y') AS StartDate, Users.Status, Area.ID AS AreaID, Area.Name AS AreaName, DATE_FORMAT(Users.RegisterDate,'%d-%m-%Y %h:%i:%s') AS RegisterDate
      FROM Users INNER JOIN IdTypes INNER JOIN Area INNER JOIN Countries ON Users.CountryID=Countries.ID AND Users.IdTypes=IdTypes.ID AND Users.AreaID=Area.ID AND Users.ID=userID;
  END$$
DELIMITER ;

###########################################################################################
                                    #UpdateUser
###########################################################################################
DROP PROCEDURE IF EXISTS UpdateUser;
DELIMITER $$
CREATE PROCEDURE UpdateUser(userID INT, firstLastName VARCHAR(20), secondLastName VARCHAR(20), firstName VARCHAR(20), otherNames VARCHAR(50), CountryID INT, IdTypes INT, IdentificationDocument VARCHAR(20), StartDate DATETIME, AreaID INT, Status VARCHAR(20))

  BEGIN
    DECLARE domain VARCHAR(14);
    DECLARE email VARCHAR(300);
    DECLARE existDocument VARCHAR(6);

    SELECT ExistsDocument(IdentificationDocument) INTO existDocument;
    IF (existDocument = "false") THEN

      # domain creation for the email
      IF (countryID = 1) THEN
        SET domain = "cidenet.com.co";
      ELSEIF (countryID = 2) THEN
        SET domain = "cidenet.com.us";
      END IF;

      # creation of the email
      SELECT CONCAT(LCASE(firstName), ".", LCASE(FirstLastName), "@", domain) INTO email;

      # verify if exists the new email
      IF (EXISTS(SELECT 1 FROM Users WHERE Users.Email=email)) THEN
        SELECT CONCAT(LCASE(firstName), ".", LCASE(FirstLastName), userID, "@", domain) INTO email;
      END IF;

      IF (EXISTS(SELECT 1 FROM Users WHERE Users.ID=userID)) THEN
          UPDATE Users SET 
              FirstLastName=firstLastName, SecondLastName=secondLastName, FirstName=firstName, OtherNames=otherNames, CountryID=countryID, IdTypes=idTypes, IdentificationDocument=identificationDocument, Email=email, StartDate=startDate, AreaID=areaID, Status=status, UpdateDate=NOW()
              WHERE 
              Users.ID=userID;

          SELECT Users.ID, Users.FirstLastName, Users.SecondLastName, Users.FirstName, Users.OtherNames, Countries.ID AS CountryID, Countries.Name AS Country, IdTypes.ID AS DocumentTypeID, IdTypes.Name AS DocumentType, Users.IdentificationDocument, Users.Email, DATE_FORMAT(Users.StartDate,'%d-%m-%Y') AS StartDate, Users.Status, Area.ID AS AreaID, Area.Name AS AreaName, DATE_FORMAT(Users.RegisterDate,'%d-%m-%Y %h:%i:%s') AS RegisterDate
            FROM Users INNER JOIN IdTypes INNER JOIN Area INNER JOIN Countries ON Users.CountryID=Countries.ID AND Users.IdTypes=IdTypes.ID AND Users.AreaID=Area.ID AND Users.ID=userID;
      END IF;
    END IF;
    
  END$$
DELIMITER ;