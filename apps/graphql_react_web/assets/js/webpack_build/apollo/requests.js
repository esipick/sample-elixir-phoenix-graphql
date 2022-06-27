import {
    gql
  } from "@apollo/client";


// # Mutations 
export const LOGIN = gql`
  mutation login($email: String!, $password: String!) {
    login( email: $email, password: $password ) {
        user {
            firstName
            lastName
            email
            username
          }
          token
    }
  }
`;

export const REGISTER_USER = gql`
  mutation registerUser($input: UserInput!){
    registerUser(input: $input){
      username
      id
      firstName
      lastName
      email
    }
  }
`
// # Queries 
export const GET_USER_INFO = gql`
query getUser {
  getUser {
    username
    lastName
    firstName
    email
  }
}
`;