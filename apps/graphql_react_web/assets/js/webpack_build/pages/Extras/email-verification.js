import * as React from 'react'
import { VERIFY_EMAIL } from '../../apollo/requests'
import { client } from '../../apollo'

const EmailVerification = (props) => {
  const [error, setErr] = React.useState('')
  React.useEffect(() => {

    const { conn } = props
    const { code, emailId } = conn

    client.mutate({
      mutation: VERIFY_EMAIL,
      variables: { code, emailId: parseInt(emailId) },
    }).then((response) => {
      window.location.href = "/home"
    })
      .catch((err) => {
        console.log(err.message)
        setErr(err.message)
      });
  }, [])

  return (
    <div>

      <h1>Verifying.......</h1>
      {error ? (<h4 style={{ color: "red" }}>{error}</h4>) : ""}
    </div>
  )
}

export default EmailVerification