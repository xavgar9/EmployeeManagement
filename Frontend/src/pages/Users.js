import React, { useState, useEffect } from "react"
import config from "../config.json"
import axios from "axios"
import Accordion from 'react-bootstrap/Accordion'
import { Button, Modal, Form, Row, Col, Table, Card, Spinner } from "react-bootstrap"
import { FontAwesomeIcon as Fas} from "@fortawesome/react-fontawesome"
import { faPlus } from "@fortawesome/free-solid-svg-icons"
import MaterialTable  from "material-table"
import { Delete, Edit } from "@material-ui/icons";

import "react-date-range/dist/styles.css"; // main style file
import "react-date-range/dist/theme/default.css";
import { Calendar } from "react-date-range"

import { UserModel } from "../models/userModel"


export default function Users(){ 

  const cols = [
    {title: "ID", field: "ID"},
    {title: "Primer apellido", field: "FirstLastName"},
    {title: "Segundo apellido", field: "SecondLastName"},
    {title: "Primer nombre", field: "FirstName"},
    {title: "Otros nombres", field: "OtherNames"},
    {title: "País", field: "Country"},
    {title: "Tipo de documento", field: "DocumentType"},
    {title: "Documento", field: "Document"},
    {title: "Email", field: "Email"},
    {title: "Fecha inicio", field: "StartDate"},
    {title: "Área", field: "Area"},
    {title: "Estado", field: "Status"},
    {title: "Fecha de registro", field: "RegistrationDate"}
  ]

  //-------------------------------- DEFINITIONS --------------------------------
  const [currentUser, setCurrentUser] = UserModel()

  // Validate the form before send it to backend
  const [validated, setValidated] = useState(false);

  // Modal create
  const [showModalCreate, setShowModalCreate] = useState(false)

  // Modal update
  const [showModalUpdate, setShowModalUpdate] = useState(false)

  // Modal error
  const [showModalError, setShowModalError] = useState(false)
  
  // Modal delete
  const [showModalDelete, setShowModalDelete] = useState(false)

  // Modal loading
  const [showModalLoading, setShowModalLoading] = useState(false)

  // Shows the error in modal error
  const [backendError, setBackendError] = useState({
    ErrorCode: "",
    ErrorDetail: "",
    Reload: false
  });

  // Date month ago
  var dateOffset = (24*60*60*1000) * 30; //30 days ago
  var minDate = new Date();
  minDate.setTime(minDate.getTime() - dateOffset);

  // Date day ago
  var dateOffset = (24*60*60*1000) * 1; //1 day ago
  var maxDate = new Date();
  maxDate.setTime(maxDate.getTime() - dateOffset);

  //-------------------------------- FUNCTIONS -------------------------------
  function FilterData(basicString, option){
    /*
      FilterData filter the str by the option (1,2,3)
      Option 1: [A-Z]
      Option 2: [A-Z ]
      Option 3: [[A-Za-z0-9_]]
    */

    var transformedString = String(basicString)
    var regExp = ""
      if (option === 1){
        transformedString = transformedString.toUpperCase()
        regExp = /[A-Z]+/g
      } else if (option === 2){
        transformedString = transformedString.toUpperCase()
        regExp = /[A-Z ]+/g
      } else if (option === 3){
        regExp = /[A-Za-z0-9-]+/g
      }
    
    transformedString = transformedString.match(regExp)
    if (transformedString === null){
      transformedString = ""
    } else{
      transformedString = transformedString[0]
    }
    return transformedString
  }


  function formatDate(date){
    /*
      Converts a date from DD-MM-YYYY to YYYY-MM-DD and
      converts a date from YYYY-MM-DD to DD-MM-YYYY
    */
    var newDate = date
    const arrayDate = date.split("-")
    if (arrayDate[2].length === 4){
      newDate = arrayDate[2] + "-" + arrayDate[1] + "-" + arrayDate[0]
    }
    return newDate
  }


  //-------------------------------- HANDLERS --------------------------------
  // Handle open close modal info
  const handleCloseModalCreate = () => {setShowModalCreate(false)}
  const handleShowModalCreate = () => setShowModalCreate(true)
    
  // Handle open close modal Update
  const handleCloseModalUpdate = () => setShowModalUpdate(false)
  const handleShowModalUpdate = () => {setShowModalUpdate(true)}

  // Handle open close modal error
  const handleCloseModalError = () => {if (backendError["Reload"]) {document.location.reload()}; setShowModalError(false)}
  const handleShowModalError = () => setShowModalError(true)

  // Handle open close modal delete
  const handleCloseModalDelete = () => {setShowModalDelete(false)}
  const handleShowModalDelete = () => setShowModalDelete(true)

  // Handle open close modal loading
  const handleCloseModalLoading = () => {setShowModalLoading(false)}
  const handleShowModalLoading = () => setShowModalLoading(true)
  
  const handleChange=e=>{
    const {name, value}= e.target
    setCurrentUser({
      ...currentUser,
      [name]: value
    })   
  }

  // Handle form regex verification
  const handleChangeRegex=(option, event)=>{
    const {name, value}= event.target
    const valueTransformed = FilterData(value, option)    
    setCurrentUser({
      ...currentUser,
      [name]: valueTransformed
    })    
    document.getElementById(name).value=valueTransformed
  }
  
  // Handle form date verification
  function handleStartDate(event){
    var value = event
    const startDate = value.toISOString().slice(0, 19).replace("T", " ").slice(0, 10)
    currentUser["StartDate"] = startDate
    document.getElementById("StartDate").value = startDate
    
  }

  // Handle submit create user
  const handleSubmitCreate = (event) => { 
    event.preventDefault()       
    const form = event.currentTarget;              
    if (form.checkValidity() === false) {
        event.stopPropagation()
    } else{
        setValidated(true)
        createUser(event)
    }
    setValidated(true)
  }

  // Handle submit update user
  const handleSubmitUpdate = (event) => { 
    event.preventDefault()       
    const form = event.currentTarget;              
    if (form.checkValidity() === false) {
        event.stopPropagation()
    } else{
        setValidated(true)
        updateUser(event)
    }
    setValidated(true)
  }

  //-------------------------------- HTTP METHODS --------------------------------

  // GetAll users
  const [ data, setData ] = useState([]);
  const getAllUsers=async()=>{
    await axios.get(config.BASE_URL_API + config.USERS.GET_ALL)
    .then (response=>{
      setData(response.data);
    }).catch(error=>{
      try{
        setBackendError({
          ...backendError,
          ["ErrorCode"]: error.response.status,
          ["ErrorDetail"]: error.response.data,
          ["Reload"]: false
        })
      } catch (error) {
        setBackendError({
          ...backendError,
          ["ErrorCode"]: 500,
          ["ErrorDetail"]: "Algo ha fallado en el servidor",
          ["Reload"]: true
        })
      }
      handleCloseModalLoading()
      handleShowModalError()
    })
  }

  // Create user
  const createUser = async() => {
    // convert strings value to int values
    currentUser["CountryID"] = parseInt(document.getElementById("Country").value)
    currentUser["DocumentTypeID"] = parseInt(document.getElementById("DocumentTypeID").value)
    currentUser["AreaID"] = parseInt(document.getElementById("Area").value)

    handleShowModalLoading()
    await axios({
      method: "POST",      
      url: config.BASE_URL_API + config.USERS.CREATE,
      data: currentUser,
    })
    .then (response=>{
      var result = response.data
      var updatedData = data
      updatedData.forEach(usr=>{
        if(usr.ID === currentUser.ID){          
          usr.Name = result.Name
          usr.Username = result.Username
          usr.Agency = result.Agency
          usr.Department = result.Department
        }
      });
      handleCloseModalLoading()
      getAllUsers()
      handleCloseModalCreate()
    }).catch(error=>{
      try{
        setBackendError({
          ...backendError,
          ["ErrorCode"]: error.response.status,
          ["ErrorDetail"]: error.response.data,
          ["Reload"]: false
        })
      } catch (error) {
        setBackendError({
          ...backendError,
          ["ErrorCode"]: 500,
          ["ErrorDetail"]: "Algo ha fallado en el servidor",
          ["Reload"]: true
        })
      }
      handleCloseModalLoading()
      handleShowModalError()
    })
  } 

  // Update user
  const updateUser = async() => {
    // convert strings value to int values
    currentUser["CountryID"] = parseInt(document.getElementById("Country").value)
    currentUser["DocumentTypeID"] = parseInt(document.getElementById("DocumentTypeID").value)
    currentUser["AreaID"] = parseInt(document.getElementById("Area").value)

    currentUser["StartDate"] = formatDate(currentUser["StartDate"])
    handleShowModalLoading()
    await axios({
      method: "POST",      
      url: config.BASE_URL_API + config.USERS.UPDATE,
      data: currentUser,
    })
    .then (response=>{
      var result = response.data
      var updatedData = data
      updatedData.forEach(usr=>{        
      });
      getAllUsers();
      handleCloseModalLoading()
      handleCloseModalUpdate()
    }).catch(error=>{
      try{
        setBackendError({
          ...backendError,
          ["ErrorCode"]: error.response.status,
          ["ErrorDetail"]: error.response.data,
          ["Reload"]: false
        })
      } catch (error) {
        setBackendError({
          ...backendError,
          ["ErrorCode"]: 500,
          ["ErrorDetail"]: "Algo ha fallado en el servidor",
          ["Reload"]: true
        })
      }
      handleCloseModalLoading()
      handleShowModalError()
    })
  }  

  // Delete user
  const deleteUser = async() => {
    handleShowModalLoading()
    await axios({
      method: "DELETE",      
      url: config.BASE_URL_API + config.USERS.DELETE,
      data: {ID: currentUser.ID},
    })
    .then (()=>{
      getAllUsers()
      handleCloseModalLoading()
      handleCloseModalDelete()
    }).catch(error=>{
      try{
        setBackendError({
          ...backendError,
          ["ErrorCode"]: error.response.status,
          ["ErrorDetail"]: error.response.data,
          ["Reload"]: false
        })
      } catch (error) {
        setBackendError({
          ...backendError,
          ["ErrorCode"]: 500,
          ["ErrorDetail"]: "Algo ha fallado en el servidor",
          ["Reload"]: true
        })
      }
      handleCloseModalLoading()
      handleShowModalError()
    })
  }  

  //-------------------------------- EXTRA --------------------------------
  const selectCurrentUser=(user, action)=>{
    setCurrentUser(user);
    switch (action) {
      case "Create":
        handleShowModalCreate();
        break;
      case "Update":
        handleShowModalUpdate();
        break;    
      case "Delete":
        handleShowModalDelete();
        break;             
      default:
        break;
    }     
  }

  useEffect(()=>{
    getAllUsers()
  },[]);

  return (
  <div className="text-center text-md-left">
    <Card>
      <Card.Header>
        <Row>
          <Col className="text-right">
            <Button className="left" variant="success btn-sm" onClick={handleShowModalCreate}> <Fas icon={faPlus} /> Nuevo usuario</Button>
          </Col>
        </Row>
      </Card.Header>
      <Card.Body  Style="max-height: 71vh; overflow-y: scroll;">
        {/* -------------------- DATA TABLE -------------------- */}
        <MaterialTable
          title = {<h4>Lista de empleados</h4>}
          columns = {cols}
          data = {data}
          actions = {[
            {
              icon: "Edit",
              tooltip: "Editar",
              onClick: (event, rowData) => selectCurrentUser(rowData, "Update")
            },
            {
              icon: "Delete",
              tooltip: "Eliminar",
              onClick: (event, rowData) => selectCurrentUser(rowData, "Delete")
            }
          ]}
          localization = {{
            header: {
              actions: "Acciones"
            }
          }}
        />       
      </Card.Body>
    </Card>

    {/* -------------------- MODAL LOADING -------------------- */}
    <Modal show={showModalLoading} onHide={handleCloseModalLoading} backdrop="static" centered>
        <Modal.Header>
        </Modal.Header>
        <Modal.Body>   
              <strong> Cargando </strong>
              <Spinner animation="border" role="status">
                <span className="sr-only">Loading...</span>
              </Spinner>
        </Modal.Body>
    </Modal>

    {/* -------------------- MODAL ERROR -------------------- */}
    <Modal show={showModalError} onHide={handleCloseModalError} centered>
        <Modal.Header closeButton>
            <Modal.Title><h4>¡Oops! Algo fue mal :'(</h4></Modal.Title>
        </Modal.Header>
        <Modal.Body>   
          <Col>
            <p>Tuvimos problemas para ejecutar tu petición, intenta de nuevo.</p>
            <p>Si el problema persiste, por favor contacte al administrador del sistema.</p>
            <hr></hr>
            <Accordion>                                        
              <Accordion.Toggle as={Button} variant="link" eventKey="1">
                  Detalles del error
              </Accordion.Toggle>
              
              <Accordion.Collapse eventKey="1">
                  <div>
                      <Form.Control plaintext readOnly placeholder="Código de error" />
                      <Form.Control plaintext readOnly placeholder={backendError.ErrorCode} />
                      
                      <Form.Control plaintext readOnly placeholder="Detalles del error" />
                      <Form.Control plaintext placeholder={backendError.ErrorDetail} disabled/>
                  </div>
              </Accordion.Collapse>                    
            </Accordion>                         
          </Col>                    
        </Modal.Body>
        <Modal.Footer>
            <Button variant="secondary" onClick={handleCloseModalError}>Cerrar</Button>
        </Modal.Footer>
    </Modal>
    
    {/* -------------------- MODAL DELETE -------------------- */}
    <Modal show={showModalDelete} onHide={handleCloseModalDelete} centered>
        <Modal.Header closeButton>
            <Modal.Title><h4>Eliminar empleado</h4></Modal.Title>
        </Modal.Header>
        <Modal.Body> 
          
          <strong> ¿Está seguro de que desea eliminar el siguiente empleado? </strong>
          <strong> ID </strong> <p> {currentUser.ID} </p>
          <strong> Nombre </strong> <p> {currentUser.FirstName + " " + currentUser.OtherNames + " " + currentUser.FirstLastName + " " + currentUser.SecondLastName} </p>
          <strong> Email </strong> <p> {currentUser.Email} </p>
        </Modal.Body>

        <Modal.Footer>
            <Col className="text-left">
              <Button variant="secondary" onClick={handleCloseModalDelete}>Cerrar</Button>            
            </Col>
            <Col className="text-right">
              <Button variant="danger" onClick={deleteUser}>Eliminar</Button>
            </Col>
        </Modal.Footer>
    </Modal>

    {/* -------------------- MODAL CREATE -------------------- */}
    <Modal show={showModalCreate} onHide={handleCloseModalCreate} centered>
      <Form noValidate validated={validated} onSubmit={handleSubmitCreate}>
        <Modal.Header closeButton>
            <Modal.Title><h4>Crear empleado</h4></Modal.Title>            
        </Modal.Header>
        <Modal.Body>
          <Card Style="max-height: 60vh; overflow-y: scroll">
            <Card.Body>
              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Primer apellido
                    </Form.Label>
                    
                    <Form.Control type="text" name="FirstLastName" id="FirstLastName" maxLength="20" onChange={(e) => handleChangeRegex(1, e)} required/>
                    <Form.Control.Feedback type="invalid">
                        El primer apellido es obligatorio
                    </Form.Control.Feedback>
                </Col>
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Segundo apellido
                    </Form.Label>
                    
                    <Form.Control type="text" name="SecondLastName" id="SecondLastName" maxLength="20" onChange={(e) => handleChangeRegex(1, e)} required/>
                    <Form.Control.Feedback type="invalid">
                        El segundo apellido es obligatorio
                    </Form.Control.Feedback>
                </Col> 
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Primer nombre
                    </Form.Label>
                    
                    <Form.Control type="text" name="FirstName" id="FirstName" maxLength="20" onChange={(e) => handleChangeRegex(1, e)} required/>
                    <Form.Control.Feedback type="invalid">
                        El primer nombre es obligatorio
                    </Form.Control.Feedback>
                </Col> 
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Otros nombres
                    </Form.Label>
                    
                    <Form.Control type="text" name="OtherNames" id="OtherNames" maxLength="50" onChange={(e) => handleChangeRegex(2, e)}/>
                </Col> 
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        País de empleo
                    </Form.Label>

                    <Form.Control as="select" name="Country" id="Country" onChange={handleChange}>
                        <option value="1" >Colombia</option>
                        <option value="2" >Estados Unidos</option>
                    </Form.Control>
                </Col>                                            
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                    Tipo de identifiación
                    </Form.Label>  

                    <Form.Control as="select" name="DocumentTypeID" id="DocumentTypeID"  onChange={handleChange}>
                        <option value="1" >Cédula de ciudadanía</option>
                        <option value="2" >Cédula de extranjería</option>
                        <option value="3" >Pasaporte</option>
                        <option value="4" >Permiso especial</option>
                    </Form.Control>
                </Col>                                            
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Número de identificación
                    </Form.Label>   

                    <Form.Control type="text" name="Document" id="Document" maxLength="20" onChange={(e) => handleChangeRegex(3, e)} required/>
                    <Form.Control.Feedback type="invalid">
                        El número de identificación es obligatorio
                    </Form.Control.Feedback>
                </Col>
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Fecha de ingreso
                    </Form.Label>

                    <Form.Control type="text" name="StartDate" id="StartDate" maxLength="10" defaultValue={maxDate.toISOString().slice(0, 19).replace("T", " ").slice(0, 10)} onChange={handleChange} disabled/>
                    <Form.Control.Feedback type="invalid">
                        La fecha de ingreso es obligatoria
                    </Form.Control.Feedback>
                </Col>
                <Col className="text-center">
                    <Calendar date={new Date()} minDate={minDate} maxDate={maxDate} showMonthAndYearPickers={false} name="CalendarStartDate" id="CalendarStartDate" onChange={(e) => {handleStartDate(e)}}/>
                </Col>
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                    Área
                    </Form.Label>  

                    <Form.Control as="select" name="Area" id="Area" onChange={handleChange}>
                        <option value="1" >Administración</option>
                        <option value="2" >Financiera</option>
                        <option value="3" >Compras</option>
                        <option value="4" >Infraestructura</option>
                        <option value="5" >Talento Humano</option>
                        <option value="6" >Servicios Varios</option>
                        <option value="7" >Otro</option>                          
                    </Form.Control>
                </Col>                                            
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Estado
                    </Form.Label>  

                    <Form.Control type="text" name="Status" id="Status" defaultValue="Activo" disabled/>
                </Col>
              </Form.Group>
              <br></br>
            </Card.Body>
          </Card>
        </Modal.Body>
        <Modal.Footer>
            <Col className="text-left">
              <Button variant="secondary" onClick={handleCloseModalCreate}>Cerrar</Button>            
            </Col>
            <Col className="text-right">
              <Button type="submit" variant="danger" onClick={() => handleSubmitCreate}>Crear</Button>
            </Col>
        </Modal.Footer>
      </Form>  
    </Modal>
  
    {/* -------------------- MODAL UPDATE -------------------- */}
    <Modal show={showModalUpdate} onHide={handleCloseModalUpdate} centered>
      <Form noValidate validated={validated} onSubmit={handleSubmitUpdate}>
        <Modal.Header closeButton>
            <Modal.Title><h4>Actualizar información del empleado</h4></Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Card Style="max-height: 60vh; overflow-y: scroll">
            <Card.Body>
              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Primer apellido
                    </Form.Label>
                    
                    <Form.Control type="text" name="FirstLastName" id="FirstLastName" maxLength="20" defaultValue={currentUser.FirstLastName} onChange={(e) => handleChangeRegex(1, e)} required/>
                    <Form.Control.Feedback type="invalid">
                        El primer apellido es obligatorio
                    </Form.Control.Feedback>
                </Col>
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Segundo apellido
                    </Form.Label>
                    
                    <Form.Control type="text" name="SecondLastName" id="SecondLastName" maxLength="20" defaultValue={currentUser.SecondLastName} onChange={(e) => handleChangeRegex(1, e)} required/>
                    <Form.Control.Feedback type="invalid">
                        El segundo apellido es obligatorio
                    </Form.Control.Feedback>
                </Col> 
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Primer nombre
                    </Form.Label>
                    
                    <Form.Control type="text" name="FirstName" id="FirstName" maxLength="20" defaultValue={currentUser.FirstName} onChange={(e) => handleChangeRegex(1, e)} required/>
                    <Form.Control.Feedback type="invalid">
                        El primer nombre es obligatorio
                    </Form.Control.Feedback>
                </Col> 
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Otros nombres
                    </Form.Label>
                    
                    <Form.Control type="text" name="OtherNames" id="OtherNames" maxLength="50" defaultValue={currentUser.OtherNames} onChange={(e) => handleChangeRegex(2, e)}/>
                </Col> 
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        País de empleo
                    </Form.Label>

                    <Form.Control as="select" name="Country" id="Country" defaultValue={currentUser.CountryID} onChange={handleChange}>
                        <option value="1" >Colombia</option>
                        <option value="2" >Estados Unidos</option>
                    </Form.Control>
                </Col>                                            
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                    Tipo de identifiación
                    </Form.Label>  

                    <Form.Control as="select" name="DocumentTypeID" id="DocumentTypeID" defaultValue={currentUser.DocumentTypeID} onChange={handleChange}>
                        <option value="1" >Cédula de ciudadanía</option>
                        <option value="2" >Cédula de extranjería</option>
                        <option value="3" >Pasaporte</option>
                        <option value="4" >Permiso especial</option>
                    </Form.Control>
                </Col>                                            
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Número de identificación
                    </Form.Label>   

                    <Form.Control type="text" name="Document" id="Document" maxLength="20" defaultValue={currentUser.Document} onChange={(e) => handleChangeRegex(3, e)} required/>
                    <Form.Control.Feedback type="invalid">
                        El número de identificación es obligatorio
                    </Form.Control.Feedback>
                </Col>
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Fecha de ingreso
                    </Form.Label>

                    <Form.Control type="text" name="StartDate" id="StartDate" maxLength="10" defaultValue={formatDate(currentUser.StartDate)} onChange={handleChange} disabled/>
                    <Form.Control.Feedback type="invalid">
                        La fecha de ingreso es obligatoria
                    </Form.Control.Feedback>
                </Col>
                <Col className="text-center">
                    <Calendar date={new Date()} minDate={minDate} maxDate={maxDate} showMonthAndYearPickers={false} name="CalendarStartDate" id="CalendarStartDate" onChange={(e) => {handleStartDate(e)}}/>
                </Col>
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                    Área
                    </Form.Label>  

                    <Form.Control as="select" name="Area" id="Area" defaultValue={currentUser.AreaID} onChange={handleChange}>
                        <option value="1" >Administración</option>
                        <option value="2" >Financiera</option>
                        <option value="3" >Compras</option>
                        <option value="4" >Infraestructura</option>
                        <option value="5" >Talento Humano</option>
                        <option value="6" >Servicios Varios</option>
                        <option value="7" >Otro</option>                          
                    </Form.Control>
                </Col>                                            
              </Form.Group>

              <Form.Group as={Row}>
                <Col className="text-left">
                    <Form.Label>
                        Estado
                    </Form.Label>  

                    <Form.Control type="text" name="Status" id="Status" defaultValue="Activo" disabled/>
                </Col>
              </Form.Group>
              <br></br>
            </Card.Body>
          </Card>
        </Modal.Body>
        <Modal.Footer>
            <Col className="text-left">
              <Button variant="secondary" onClick={handleCloseModalUpdate}>Cerrar</Button>            
            </Col>
            <Col className="text-right">
              <Button type="submit" variant="danger" onClick={() => handleSubmitUpdate}>Actualizar</Button>
            </Col>
        </Modal.Footer>
      </Form>  
    </Modal>
  </div>
  );
}