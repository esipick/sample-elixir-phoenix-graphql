import {
    ApolloClient,
    InMemoryCache,
    ApolloProvider,
    useQuery,
    gql
  } from "@apollo/client";
import {  getLSItem } from '../utils/utils'

  export const client = new ApolloClient({
    uri: '/api/graphiql',
    cache: new InMemoryCache(),
    options: {
      reconnect: true,
      connectionParams: {
        headers: {
          Authorization: `Bearer ${getLSItem('Access_Token')} `,
        },
      },
    },
  });
  
  // export default client