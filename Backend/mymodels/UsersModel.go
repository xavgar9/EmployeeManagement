package mymodels

// User struct
type User struct {
	ID               *int    `json:"ID,omitempty"`
	FirstLastName    *string `json:"FirstLastName,omitempty"`
	SecondLastName   *string `json:"SecondLastName,omitempty"`
	FirstName        *string `json:"FirstName,omitempty"`
	OtherNames       *string `json:"OtherNames,omitempty"`
	CountryID        *int    `json:"CountryID,omitempty"`
	Country          *string `json:"Country,omitempty"`
	DocumentTypeID   *int    `json:"DocumentTypeID,omitempty"`
	DocumentType     *string `json:"DocumentType,omitempty"`
	Document         *string `json:"Document,omitempty"`
	Email            *string `json:"Email,omitempty"`
	StartDate        *string `json:"StartDate,omitempty"`
	AreaID           *int    `json:"AreaID,omitempty"`
	Area             *string `json:"Area,omitempty"`
	Status           *string `json:"Status,omitempty"`
	RegistrationDate *string `json:"RegistrationDate,omitempty"`
	ModificationDate *string `json:"ModificationDate,omitempty"`
}

// AllUsers slice of users
type AllUsers []User
