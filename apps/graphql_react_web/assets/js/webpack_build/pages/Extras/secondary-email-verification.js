import * as React from 'react'
import { VERIFIY_SECONDARY_EMAIL } from '../../apollo/requests'
import { client } from '../../apollo'
import { getLSItem } from '../../utils/utils'


const SecondaryEmailVerification = (props) => {
  const [error, setErr] = React.useState('')
  React.useEffect(() => {
    const token = getLSItem('Access_Token')
    if (!token) {
      window.location.href = "/"
    }
    const { conn } = props
    const { code, emailId } = conn
    console.log(code, emailId)
    client.query({
      query: VERIFIY_SECONDARY_EMAIL,
      variables: { code: code, emailId: parseInt(emailId) },
    }).then((response) => {
      window.location.href = "/settings"
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

export default SecondaryEmailVerification