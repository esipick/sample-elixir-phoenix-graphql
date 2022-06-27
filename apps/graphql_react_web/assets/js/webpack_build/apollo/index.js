import {
    ApolloClient,
    InMemoryCache,
    createHttpLink
  } from "@apollo/client";
  import { setContext } from '@apollo/client/link/context';

import {  getLSItem } from '../utils/utils'


const httpLink = createHttpLink({
  uri: '/api/graphiql',
});

const authLink = setContext((_, { headers }) => {
    // get the authentication token from local storage if it exists
    const token = getLSItem('Access_Token')
    // return the headers to the context so httpLink can read them
    return {
      headers: {
        ...headers,
        authorization: token ? `Bearer ${token}` : "",
      }
    }
  });
  export const client = new ApolloClient({
    link: authLink.concat(httpLink),
    cache: new InMemoryCache(),
    
  });
  