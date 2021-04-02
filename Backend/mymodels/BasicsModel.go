package mymodels

import (
	"net/http"
)

// Test struct for the unit test
type Test struct {
	Method       string                                   `json:"Method"`
	URL          string                                   `json:"URL"`
	Function     func(http.ResponseWriter, *http.Request) `json:"Function"`
	Body         string                                   `json:"Body"`
	ExpectedBody string                                   `json:"BodyResponse"`
	StatusCode   int                                      `json:"StatusCode"`
}

// AllTest slice of tests
type AllTest []Test
