package api

import (
	users "Backend/myhandlers"

	"github.com/gorilla/mux"
)

// MainRouters are the collection of all URLs for the Main App.
func MainRouters(router *mux.Router) {

	// Users URLs
	router.HandleFunc("/Users/GetAllUsers", users.GetAllUsers).Methods("GET", "OPTIONS")
	router.HandleFunc("/Users/GetUser", users.GetUser).Methods("GET", "OPTIONS")
	router.HandleFunc("/Users/UpdateUser", users.UpdateUser).Methods("POST", "OPTIONS")
	router.HandleFunc("/Users/CreateUser", users.CreateUser).Methods("POST", "OPTIONS")
	router.HandleFunc("/Users/DeleteUser", users.DeleteUser).Methods("DELETE", "OPTIONS")
}
