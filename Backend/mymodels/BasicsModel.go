package mymodels

import (
	"database/sql"
	"net/http"
)

// ProductModel bla bla...
type ProductModel struct {
	Db *sql.DB
}

// Test bla bla...
type Test struct {
	Method       string                                   `json:"Method"`
	URL          string                                   `json:"URL"`
	Function     func(http.ResponseWriter, *http.Request) `json:"Function"`
	Body         string                                   `json:"Body"`
	ExpectedBody string                                   `json:"BodyResponse"`
	StatusCode   int                                      `json:"StatusCode"`
}

// AllTest bla bla...
type AllTest []Test
