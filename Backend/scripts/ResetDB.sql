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
    VALUES ("GARZON", "LOPEZ", "XAVIER", "", 1, 1, "1144114411", "xavier.garzon@cidenet.com", "2021-03-25 14:00:00", 1, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("PALACIO", "GUZMAN", "MICHAEL", "ANDRES", 2, 1, "1133224411", "michael.palacio@cidenet.com", "2021-03-26 10:00:00", 1, "ACTIVO", NOW());
INSERT INTO Users(FirstLastName,SecondLastName,FirstName,OtherNames,CountryID,IdTypes,IdentificationDocument,Email,StartDate,AreaID,Status,RegisterDate) 
    VALUES ("PALACIO", "MARTINEZ", "MICHAEL", "DARIO", 2, 1, "2233224411", "michael.palacio1@cidenet.com", "2021-03-26 10:30:00", 3, "ACTIVO", NOW());