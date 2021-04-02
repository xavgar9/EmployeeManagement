import React, { Suspense, lazy} from 'react'
import config from "../config.json"
import { PublicRoute } from '../helpers/routesHelper'

import { Layout } from '../components/Layout'
import { Redirect } from 'react-router'

const Users = lazy(() => import('../pages/Users'))

const Route = require("react-router-dom").Route
const Switch = require("react-router-dom").Switch

const Routes = () => {     
    return (        
        <Switch>                    
            <Layout>
                <Suspense fallback={<div>Loading...</div>}>
                    <PublicRoute exact={true} path={config.URL_PAGES.USERS} component={Users}/>
                </Suspense>            
                <Redirect from='*' to={config.URL_PAGES.USERS} />
            </Layout>
        </Switch>
    )
}

export default Routes