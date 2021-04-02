import React from 'react';
import { Navbar, Nav, } from 'react-bootstrap';
import axios from 'axios';
import config from "../config.json";

export const NavigationBar = () => (
    <div>
        
            <Navbar collapseOnSelect expand="lg" bg="dark" variant="dark">
                <Navbar.Brand href="/inicio">
                    <img src="cidenet-dos-logo.png" className="image" style={{opacity: 1}} alt="Cidenet logo" width="81" height="50" ></img>
                </Navbar.Brand>
                <Navbar.Toggle aria-controls="responsive-navbar-nav" />
                <Navbar.Collapse id="responsive-navbar-nav">
                    <Nav className="mr-auto">
                        <Nav.Link href={config.URL_PAGES.USERS}>Empleados</Nav.Link>                        
                    </Nav>
                </Navbar.Collapse>
            </Navbar>    
        
    </div>
)