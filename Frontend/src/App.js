import React, {Component} from 'react'
import Routes from './routes/routes'

const Router = require("react-router-dom").BrowserRouter

class App extends Component {

  render() {
    return (
      <React.Fragment>
        <Router>          
            <Routes/>         
        </Router>
      </React.Fragment>
    );
  }
}

export default App