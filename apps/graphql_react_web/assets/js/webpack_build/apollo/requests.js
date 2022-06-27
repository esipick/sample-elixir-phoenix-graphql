import {
    gql
  } from "@apollo/client";



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