import React from 'react'
import { Route } from 'react-router-dom'

export const PublicRoute = ({component, ...options}) => {
    return <Route {...options} component={component}/>
}
