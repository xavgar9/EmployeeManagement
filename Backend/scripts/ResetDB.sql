DELETE FROM Users;
ALTER TABLE Users AUTO_INCREMENT = 1;
DELETE FROM IdTypes;
ALTER TABLE IdTypes AUTO_INCREMENT = 1;
DELETE FROM Area;
ALTER TABLE Area AUTO_INCREMENT = 1;
DELETE FROM Countries;
ALTER TABLE Countries AUTO_INCREMENT = 1;

-- IdTypes
INSERT INTO IdTypes(Name) VALUES("CEDULA DE CIUDADANIA");
INSERT INTO IdTypes(Name) VALUES("CEDULA DE EXTRANJERIA");
INSERT INTO IdTypes(Name) VALUES("PASAPORTE");
INSERT INTO IdTypes(Name) VALUES("PERMISO ESPECIAL");

-- Area
INSERT INTO Area(Name) VALUES("ADMINISTRACION");
INSERT INTO Area(Name) VALUES("FINANCIERA");
INSERT INTO Area(Name) VALUES("COMPRAS");
INSERT INTO Area(Name) VALUES("INFRAESTRUCTURA");
INSERT INTO Area(Name) VALUES("TALENTO HUMANO");
INSERT INTO Area(Name) VALUES("SERVICIOS VARIOS");
INSERT INTO Area(Name) VALUES("OTROS");

-- Countries
INSERT INTO Countries(Name) VALUES("COLOMBIA");
INSERT INTO Countries(Name) VALUES("ESTADOS UNIDOS");

-- Users
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("GARZON", "LOPEZ", "XAVIER", "", 1, 1, "1144114411", "xavier.garzon@cidenet.com.co", "2021-03-25 14:00:00", 1, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("PALACIO", "GUZMAN", "MICHAEL", "ANDRES", 1, 1, "1133224412", "michael.palacio@cidenet.com.co", "2021-03-26 10:00:00", 4, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("PALACIO", "MARTINEZ", "MICHAEL", "DARIO", 1, 1, "2233224413", "michael.palacio3@cidenet.com.co", "2021-03-26 10:30:00", 3, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("GARZON", "GUTIERREZ", "XAVIER", "", 2, 1, "1144114422", "xavier.garzon@cidenet.com.us", "2021-03-25 21:40:00", 2, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("GARZON", "GUTIERREZ", "XAVIER", "ANTONIO", 2, 2, "TR-0105454", "xavier.garzon5@cidenet.com.us", "2021-03-25 21:45:00", 1, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("GOMEZ", "HERNANDEZ", "ANDRES", "ANDRES", 1, 1, "1133224651", "andres.gomez@cidenet.com.co", "2021-03-26 09:00:00", 1, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("HERNANDEZ", "GONZALEZ", "ANDRES", "", 1, 1, "1033224411", "andres.hernandez@cidenet.com.co", "2021-03-26 10:00:00", 2, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("PAZ", "FERNADEZ", "MARCO", "DE LA CALLE", 2, 1, "1666224411", "marco.paz@cidenet.com.us", "2021-03-26 11:00:00", 4, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("PINEDA", "DUQUE", "ANDREA", "", 1, 1, "1109024411", "andrea.pineda@cidenet.com.co", "2021-03-26 12:00:00", 5, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("RODRIGUEZ", "MARIN", "SOFIA", "", 2, 1, "2133224411", "sofia.rodriguez@cidenet.com.us", "2021-03-26 14:00:00", 6, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("ESTUPINAN", "TAVAREZ", "MARIANA", "", 2, 1, "4133224411", "mariana.estupinan@cidenet.com.us", "2021-03-26 15:00:00", 7, "ACTIVO", NOW());