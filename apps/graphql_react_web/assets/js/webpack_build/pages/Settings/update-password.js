import * as React from 'react'
import Paper from '@mui/material/Paper';
import MenuList from '@mui/material/MenuList';
import MenuItem from '@mui/material/MenuItem';
import ListItemText from '@mui/material/ListItemText';
import Grid from '@mui/material/Grid';
import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import FormHelperText from '@mui/material/FormHelperText';

import { UPDATE_PASSWORD } from '../../apollo/requests'
import { client } from '../../apollo'
import { signOut } from '../../utils/utils'
const UpdatePassword = () => {
  const [color, setColor] = React.useState('black')
  const [message, setMessage] = React.useState('')

  const handleUpdatePassword = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);

    if (data.get('new_password') === data.get('conf_new_password')) {
      client.mutate({
        mutation: UPDATE_PASSWORD,
        variables: {
          oldPassword: data.get('old_password'),
          newPassword: data.get('new_password'),
          confirmNewPassword: data.get('conf_new_password')
        },

      }).then(res => {
        console.log(res.data)
        setMessage(res.data.updatePassword)
        setColor('green')
        setTimeout(() => {
          setMessage('Please Login again')
          signOut()
          window.location.href = "/"
        }, 3000)
      }).catch(err => {
        console.log(err.message)
        setColor('red')
        setMessage(err.message)
      })
    } else {
      setMessage('New Password and confirm new password does not match')
      setColor('red')
    }


  }
  return (
    <Box
      sx={{
        my: 8,
        mx: 4,
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'start',
      }}
    >
      <Typography component="h1" variant="h5">
        Update your Password
      </Typography>
      <Box component="form" noValidate={false} onSubmit={handleUpdatePassword} sx={{ mt: 1 }}>

        <TextField
          margin="normal"
          required
          fullWidth
          id="old_pass"
          label="Old Password"
          name="old_password"
          type="password"

        />
        <TextField
          margin="normal"
          required
          fullWidth
          name="new_password"
          label="New Password"
          type="password"
          id="new_password"
        />
        <TextField
          margin="normal"
          required
          fullWidth
          name="conf_new_password"
          label="Confirm New Password"
          type="password"
          id="new_password"
        />
        <Button
          type="submit"
          fullWidth
          variant="contained"
          sx={{ mt: 3, mb: 2 }}
        >
          Update
        </Button>
        <FormHelperText style={{ color: color }} variant="standard" id="component-error-text">{message}</FormHelperText>
      </Box>
    </Box>
  )
}

export default UpdatePassword