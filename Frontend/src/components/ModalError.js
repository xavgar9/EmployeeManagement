import React from 'react'
import { Button, Form, Row, Col, Modal, Card } from 'react-bootstrap'
import Accordion from 'react-bootstrap/Accordion'

export const ModalError = ( { backendError, showModalError, handleCloseModalError }) => (
    <div>
        {/* -------------------- MODAL ERROR -------------------- */}
        <Modal border="primary" show={showModalError} onHide={handleCloseModalError} centered>
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
    </div>
)