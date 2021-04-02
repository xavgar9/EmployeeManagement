import React from 'react';
import { NavigationBar } from './NavigationBar'
import { Container } from 'react-bootstrap';


export const Layout = (props) => (
    <div>
        <NavigationBar />
        <br></br>
            <Container style={{paddingLeft: "24px", paddingRight: "24px"}} fluid>
                {props.children}
            </Container>
    </div>
)