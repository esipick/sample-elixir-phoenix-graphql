import {
    gql
  } from "@apollo/client";


// # Mutations 
export const LOGIN = gql`
  mutation login($email: String!, $password: String!) {
    login( email: $email, password: $password ) {
        user {
            id
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

export const UPDATE_EMAIL = gql`
  mutation updateEmail($email: String!){
    updateEmail(email: $email)
  }
`
export const UPDATE_PASSWORD = gql`
  mutation($oldPassword: String!, $newPassword: String!, $confirmNewPassword: String!){
    updatePassword(oldPassword: $oldPassword, newPassword: $newPassword, confirmNewPassword: $confirmNewPassword)
  }
`

export const ADD_EMAIL = gql`
  mutation addEmail($email: String!){
    addEmail(email: $email)
  }
`
export const DELETE_EMAIL = gql`
  mutation deleteEmail($id: Int!){
    deleteEmail(id: $id)
  }
`
export const SET_PRIMARY_EMAIL = gql`
  mutation setPrimaryEmail($id: Int!){
    setPrimaryEmail(id: $id)
  }
`




// # Queries 
export const GET_USER_INFO = gql`
query getUser {
  getUser {
    id
    username
    lastName
    firstName
    email
  }
}
`;

export const VERIFY_EMAIL = gql`
query verifyEmail($code: String!, $userId: Int! ) {
  verifyEmail(code:$code, userId: $userId) 
}
`;

export const GET_EMAILS = gql`
query getUserEmails{
  getUserEmails {
    user_emails {
      id
      email
      isVerified
      isPrimary
    }
    
  }
}
`
export const VERIFIY_SECONDARY_EMAIL = gql`
  query verifySecondaryEmail($code: String!, $emailId: Int!){
    verifySecondaryEmail(code: $code,  emailId: $emailId)
  }
`