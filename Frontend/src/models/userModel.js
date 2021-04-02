import { useState } from "react"
export function UserModel() {
  // Date day ago
  var dateOffset = (24*60*60*1000) * 1
  var yesterday = new Date()
  yesterday.setTime(yesterday.getTime() - dateOffset)
  yesterday = yesterday.toISOString().slice(0, 19).replace('T', ' ').slice(0, 10)
  //const currentDate = new Date().toISOString().slice(0, 19).replace('T', ' ')

  // Current user data
  const [currentUser, setCurrentUser] = useState({
      ID: "",
      FirstLastName: "",
      SecondLastName: "",
      FirstName: "",
      OtherNames: "",
      CountryID: 1,
      Country: "",
      DocumentTypeID: 1,
      DocumentType: "",
      Document: "",
      Email: "",
      StartDate: yesterday,
      AreaID: 1,
      Area: "",
      Status: "ACTIVO",
      RegistrationDate: "",
    });

  return [currentUser, setCurrentUser]
}