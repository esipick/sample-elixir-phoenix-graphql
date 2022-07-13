import * as React from 'react'
import { VERIFY_EMAIL } from '../../apollo/requests'
import { client } from '../../apollo'
import { getLSItem } from '../../utils/utils'


const UpdateEmailVerification = (props) => {
  const [error, setErr] = React.useState('')
  React.useEffect(() => {
    const user = getLSItem('USER')
    if (!user) {
      window.location.href = "/"
    }
    const { conn } = props
    const { code } = conn
    console.log(code)
    client.mutate({
      mutation: VERIFY_EMAIL,
      variables: { code, userId: parseInt(user.id) },
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

export default UpdateEmailVerification