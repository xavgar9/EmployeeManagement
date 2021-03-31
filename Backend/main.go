// Author(s): Xavier Garzón
// Some of the next code was taken from Maharlikans Code's YouTube Channel
// Maharlikans Code
// November 2020
// Golang Web Application Project Structure - Golang Web Development
// Golang Web Server Using Gorilla Package - Golang Web Development
// Golang URL Router Using Gorilla Mux - Golang Web Development
// Source code
// https://www.youtube.com/watch?v=AWf6BntPXtc&t=1475s
// https://www.youtube.com/watch?v=IwYaSOejDLs
// https://www.youtube.com/watch?v=K5jgg9efioc
// https://www.youtube.com/c/MaharlikansCode

package main

import (
	"Backend/api"
	"Backend/config"
	"context"
	"flag"
	"fmt"
	"net"
	"net/http"
	"os"
	"os/signal"
	"time"

	//"github.com/gorilla/csrf"

	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"github.com/itrepablik/itrlog"
	"github.com/itrepablik/sakto"
)

//CurrentLocalTime bla bla...
var CurrentLocalTime = sakto.GetCurDT(time.Now(), "America/New_York")

func main() {
	os.Setenv("TZ", config.SiteTimeZone) // Set the local timezone globally
	fmt.Println("Starting the web servers at ", CurrentLocalTime)
	var dir string
	var wait time.Duration
	flag.DurationVar(&wait, "graceful-timeout", time.Second*15, "the duration for which the server gracefully wait for existing connections to finish - e.g. 15s or 1m")
	flag.StringVar(&dir, "dir", "static", "the directory to serve files from. Defaults to the current dir")
	flag.Parse()

	router := mux.NewRouter()
	// Create cross-site request forgery (CSRF) protection in every http requests
	// 32-byte-long-auth-key []string{config.SiteDomainName}
	/*
		csrfMiddleware := csrf.Protect(
			[]byte(config.SecretKeyCORS),
			csrf.Secure(false),
			csrf.TrustedOrigins([]string{config.SiteDomainName}), // Change this in production
		)

	*/
	// This is related to the CORS config to allow all origins []string{"*"} or specify only allowed IP or hostname.

	cors := handlers.CORS(
		handlers.AllowedHeaders([]string{"Origin", "Content-Type", "Authorization", "Access-Control-Allow-Origin", "Token"}),
		handlers.AllowedMethods([]string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}),
		handlers.AllowedOrigins([]string{"*"}),
	)

	router.Use(cors)
	//router.Use(csrfMiddleware)
	//router.Use(loggingMiddleware)
	//router.Use(mux.CORSMethodMiddleware(router))

	// This will serve the files under http://localhost:3000/static/<filename>
	router.PathPrefix("/static/").Handler(http.StripPrefix("/static/", http.FileServer(http.Dir(dir))))

	// Initialize the APIs here
	api.MainRouters(router) // URLs for the main app.

	// Initialize IP and PORT of app
	conn, err := net.Dial("udp", "8.8.8.8:80")
	if err != nil {
		itrlog.Error(err)
	}
	defer conn.Close()
	IP := conn.LocalAddr().(*net.UDPAddr).IP.String()
	var PORT = config.ServerPort

	srv := &http.Server{
		//Addr: "localhost:3600",
		Addr: IP + ":" + PORT,
		// Good practice to set timeouts to avoid Slowloris attacks.
		WriteTimeout: time.Second * 15,
		ReadTimeout:  time.Second * 15,
		IdleTimeout:  time.Second * 60,
		Handler:      router, // Pass our instance of gorilla/mux in.
	}

	// Run our server in a goroutine so that it doesn't block.
	go func() {
		msg := "Server started at " + IP + ":" + PORT
		fmt.Println(msg, CurrentLocalTime)
		itrlog.Info("Server started at ", CurrentLocalTime)
		if err := srv.ListenAndServe(); err != nil {
			itrlog.Error(err)
		}
	}() // Note the parentheses - must call the function.

	// BUFFERED CHANNELS = QUEUES
	c := make(chan os.Signal, 1) // Queue with a capacity of 1.

	// We'll accept graceful shutdowns when quit via SIGINT (Ctrl+C)
	// SIGKILL, SIGQUIT or SIGTERM (Ctrl+/) will not be caught.
	signal.Notify(c, os.Interrupt)

	// Block until we receive our signal.
	<-c

	// Create a deadline to wait for.
	ctx, cancel := context.WithTimeout(context.Background(), wait)
	defer cancel()
	srv.Shutdown(ctx)
	fmt.Println("Shutdown web server at " + CurrentLocalTime.String())
	itrlog.Warn("Server has been shutdown at ", CurrentLocalTime.String())
	os.Exit(0)
}

func loggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, router *http.Request) {
		// Do stuff here
		req := "IP:" + sakto.GetIP(router) + ":" + router.RequestURI + ":" + CurrentLocalTime.String()
		fmt.Println(req)
		itrlog.Info(req)

		// Call the next handler, which can be another middleware in the chain, or the final handler.
		next.ServeHTTP(w, router)
	})
}
