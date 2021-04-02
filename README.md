# Web application for employee management

Simple page web application for employee management.

## Instalation and use

Make sure you have at least Node 10, Golang 1.15 and MySQL 8.

- Clone the repo.
- Look for the sql scripts in `EmployeeManagement/Backend/scripts` and execute them in db in the next order.
	1. CreateDB
	2. FunctionsProcedures
	3. ResetDB
- Look for the next file `EmployeeManagement/Backend/config/Mysql.go` and change the credentials.
- Look for the next file `EmployeeManagement/Frontend/src/config.json` and make sure that the BASE_URL_API corresponds to the IP of the Golang server.
- Go to `EmployeeManagement/Backend` and run 
```
$ go run main.go
```

Go to `EmployeeManagement/Front` and run 
```
$ npm install
$ npm start
``` 
- Enjoy it!
## Description

Functional web app with the four basics operations (CRUD).

## Software architecture

This software was built using API REST in an Layered Architecture.

<img src="https://user-images.githubusercontent.com/22827757/113381784-79c65680-9345-11eb-817a-4a336e877064.png" alt="drawing" width="320"/>

## Project status

Done!
