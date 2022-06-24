import React from 'react';
import { ConnectedRouter } from 'connected-react-router';

import { Root } from '../routes';


class App extends React.Component {

  constructor(){
    super();
    this.state = {};
  }

  render() {
    return (
        <ConnectedRouter history={history}>
          <Root />
        </ConnectedRouter>
    );
  }
}

const connectedApp = App;
export { connectedApp as App };