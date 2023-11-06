-- tables
-- Table: Area
CREATE TABLE IF NOT EXISTS Area (
    ID int NOT NULL AUTO_INCREMENT,
    Name varchar(50) NOT NULL,
    CONSTRAINT Area_pk PRIMARY KEY (ID)
);

-- Table: Countries
CREATE TABLE IF NOT EXISTS Countries (
    ID int NOT NULL AUTO_INCREMENT,
    Name varchar(50) NOT NULL,
    CONSTRAINT Countries_pk PRIMARY KEY (ID)
);

-- Table: IdTypes
CREATE TABLE IF NOT EXISTS IdTypes (
    ID int NOT NULL AUTO_INCREMENT,
    Name varchar(50) NOT NULL,
    CONSTRAINT IdTypes_pk PRIMARY KEY (ID)
);

-- Table: Users
CREATE TABLE IF NOT EXISTS Users (
    ID int NOT NULL AUTO_INCREMENT,
    FirstLastName varchar(20) NOT NULL,
    SecondLastName varchar(20) NOT NULL,
    FirstName varchar(20) NOT NULL,
    OtherNames varchar(50) NOT NULL,
    CountryID int NOT NULL,
    IdTypes int NOT NULL,
    IdentificationDocument varchar(20) NOT NULL,
    Email varchar(300) NOT NULL,
    StartDate datetime NOT NULL,
    AreaID int NOT NULL,
    Status varchar(20) NOT NULL,
    RegisterDate datetime NOT NULL,
    UpdateDate datetime NULL,
    CONSTRAINT Users_pk PRIMARY KEY (ID)
);

-- foreign keys
-- Reference: Users_Area (table: Users)
ALTER TABLE Users ADD CONSTRAINT Users_Area FOREIGN KEY Users_Area (AreaID)
    REFERENCES Area (ID);

-- Reference: Users_Countries (table: Users)
ALTER TABLE Users ADD CONSTRAINT Users_Countries FOREIGN KEY Users_Countries (CountryID)
    REFERENCES Countries (ID);

-- Reference: Users_IdTypes (table: Users)
ALTER TABLE Users ADD CONSTRAINT Users_IdTypes FOREIGN KEY Users_IdTypes (IdTypes)
    REFERENCES IdTypes (ID);

-- End of file.

