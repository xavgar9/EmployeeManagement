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
	SiteFullName, SiteSlogan, SiteBaseURL, SiteTopMenuLogo, SiteProperDomainName,
	SiteShortName, SiteEmail, SitePhoneNumbers, SiteCompanyAddress, ServerIP, ServerPort string
	SiteYear int
}

// SiteSettings defines all constant variables from the settings.go
var SiteSettings = Settings{
	SiteFullName:         SiteFullName,
	SiteSlogan:           SiteSlogan,
	SiteBaseURL:          SiteBaseURL,
	SiteTopMenuLogo:      SiteTopMenuLogo,
	SiteProperDomainName: SiteProperDomainName,
	SiteShortName:        SiteShortName,
	SiteEmail:            SiteEmail,
	SitePhoneNumbers:     SitePhoneNumbers,
	SiteCompanyAddress:   SiteCompanyAddress,
	SiteYear:             SiteYear,
	ServerIP:             ServerIP,
	ServerPort:           ServerPort,
}
