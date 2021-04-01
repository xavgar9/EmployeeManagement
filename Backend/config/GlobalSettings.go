// Author(s): Xavier Garzón
// Some of the next code was taken from Maharlikans Code's YouTube Channel
// Maharlikans Code
// Novemeber 2020
// Golang Web Application Project Structure - Golang Web Development
// Golang Web Server Using Gorilla Package - Golang Web Development
// Golang URL Router Using Gorilla Mux - Golang Web Development
// Source code
// https://www.youtube.com/watch?v=AWf6BntPXtc&t=1475s
// https://www.youtube.com/watch?v=IwYaSOejDLs
// https://www.youtube.com/watch?v=K5jgg9efioc
// https://www.youtube.com/c/MaharlikansCode

package config

// Settings is where the common settings.go constant variables.
type Settings struct {
	SiteTimeZone string
}

// SiteSettings defines all constant variables from the settings.go
var SiteSettings = Settings{
	SiteTimeZone: SiteTimeZone,
}
