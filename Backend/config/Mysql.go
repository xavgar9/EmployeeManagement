package config

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

// MYSQLConnection bla bla...
func MYSQLConnection() (*sql.DB, error) {
	dbDriver := "mysql"
	dbUser := "root"
	dbPass := "root"
	dbName := "employeemanagement"
	dbURL := "db:3306"
	db, err := sql.Open(dbDriver, dbUser+":"+dbPass+"@tcp("+dbURL+")/"+dbName)
	if err != nil {
		log.Fatal(fmt.Errorf("sql.Open(): %w", err))
	}

	// Confirm a successful connection.
	if err := db.Ping(); err != nil {
		log.Fatal(fmt.Errorf("db.Ping(): %w", err))
	}
	return db, err
}
