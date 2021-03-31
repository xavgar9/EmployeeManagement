package tests

import (
	"bytes"
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"Backend/mymodels"
	"Backend/tests/testhelpers"
)

func printCountCases(t *testing.T, cntCases int) {
	fmt.Println(" ")
	fmt.Printf("<-------------- Total cases tested: %d -------------->\n", cntCases)
	fmt.Println(" ")
}

// runTest basic test for running endpoints test.
func runTest(t *testing.T, allTest mymodels.AllTest) {
	fmt.Printf("( %d ) \n", len(allTest))
	for i, test := range allTest {
		req, err := http.NewRequest(test.Method, test.URL, nil)
		if err != nil {
			t.Fatal(err)
		}
		rr := httptest.NewRecorder()
		handler := http.HandlerFunc(test.Function)
		handler.ServeHTTP(rr, req)
		if status := rr.Code; status != test.StatusCode {
			t.Errorf("Test #%v: Handler returned wrong status code: got %v want %v",
				i, status, test.StatusCode)
		}
		responseBody := strings.TrimSuffix(rr.Body.String(), "\n") //deleting \n last char
		if responseBody != test.ExpectedBody {
			t.Errorf("Test #%v: Handler returned unexpected body: got \n%v want \n%v",
				i, responseBody, test.ExpectedBody)
		}
		cntCases++
	}
}

// runUpdateTest basic test for running endpoints test.
func runTestWithBody(t *testing.T, allTest mymodels.AllTest) {
	fmt.Printf("( %d ) \n", len(allTest))
	for i, test := range allTest {
		req, err := http.NewRequest(test.Method, test.URL, bytes.NewBuffer([]byte(test.Body)))
		if err != nil {
			t.Fatal(err)
		}
		rr := httptest.NewRecorder()
		handler := http.HandlerFunc(test.Function)
		handler.ServeHTTP(rr, req)
		if status := rr.Code; status != test.StatusCode {
			t.Errorf("Test #%v: Handler returned wrong status code: got %v want %v",
				i, status, test.StatusCode)
		}
		responseBody := strings.TrimSuffix(rr.Body.String(), "\n") //deleting \n last char
		if responseBody != test.ExpectedBody {
			t.Errorf("Test #%v: Handler returned unexpected body: got \n%v want \n%v",
				i, responseBody, test.ExpectedBody)
		}
		cntCases++
	}
}

// runTestWithBodyIgnoreBodyResponse basic test for running endpoints test.
func runTestWithBodyIgnoreBodyResponse(t *testing.T, allTest mymodels.AllTest) {
	fmt.Printf("( %d ) \n", len(allTest))
	for i, test := range allTest {
		req, err := http.NewRequest(test.Method, test.URL, bytes.NewBuffer([]byte(test.Body)))
		if err != nil {
			t.Fatal(err)
		}
		rr := httptest.NewRecorder()
		handler := http.HandlerFunc(test.Function)
		handler.ServeHTTP(rr, req)
		if status := rr.Code; status != test.StatusCode {
			t.Errorf("Test #%v: Handler returned wrong status code: got %v want %v",
				i, status, test.StatusCode)
		}
		cntCases++
	}
}

var cntCases int

// Users test

func TestGetAllUsers(t *testing.T) {
	runTest(t, testhelpers.CasesGetAllUsers())
}

func TestGetUser(t *testing.T) {
	runTest(t, testhelpers.CasesGetUser())
}

func TestUpdateUser(t *testing.T) {
	runTestWithBody(t, testhelpers.CasesUpdateUser())
}

func TestCreateUser(t *testing.T) {
	runTestWithBody(t, testhelpers.CasesCreateUser())
}

func TestDeleteUser(t *testing.T) {
	runTestWithBody(t, testhelpers.CasesDeleteUser())
}

func TestCountCases(t *testing.T) {
	printCountCases(t, cntCases)
}
