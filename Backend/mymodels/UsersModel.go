package mymodels

// User bla bla...
type User struct {
	ID                     *int    `json:"ID,omitempty"`
	FirstLastName          *string `json:"FirstLastName,omitempty"`
	SecondLastName         *string `json:"SecondLastName,omitempty"`
	FirstName              *string `json:"FirstName,omitempty"`
	OtherNames             *string `json:"OtherNames,omitempty"`
	CountryID              *int    `json:"CountryID,omitempty"`
	Country                *string `json:"Country,omitempty"`
	IdTypes                *int    `json:"IdTypes,omitempty"`
	IdTypesName            *string `json:"IdTypesName,omitempty"`
	IdentificationDocument *string `json:"IdentificationDocument,omitempty"`
	Email                  *string `json:"Email,omitempty"`
	StartDate              *string `json:"StartDate,omitempty"`
	AreaID                 *int    `json:"AreaID,omitempty"`
	AreaName               *string `json:"AreaName,omitempty"`
	Status                 *string `json:"Status,omitempty"`
	RegistrationDate       *string `json:"RegistrationDate,omitempty"`
	ModificationDate       *string `json:"ModificationDate,omitempty"`
}

// AllUsers bla bla...
type AllUsers []User
