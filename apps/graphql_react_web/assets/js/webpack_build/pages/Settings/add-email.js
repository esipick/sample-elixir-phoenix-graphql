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
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';

import { ADD_EMAIL } from '../../apollo/requests'
import { client } from '../../apollo'

const AddEmail = ({ emails }) => {
  const [color, setColor] = React.useState('black')
  const [message, setMessage] = React.useState('')
  console.log(emails)
  const handleAddEmail = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);

    client.mutate({
      mutation: ADD_EMAIL,
      variables: {
        email: data.get('email'),

      },

    }).then(res => {
      setMessage(res.data.addEmail)
      setColor('green')
    }).catch(err => {
      setColor('red')
      setMessage(err.message)
    })

  }
  const renderEmails = () => {
    if(emails.length > 0){
      return  emails.map((ele) => {
        return (
          <ListItem disablePadding>
              {ele.secondaryEmail}
          </ListItem>
        )
      })
    }
  }
  return (
    <Grid container spacing={2}>
    <Grid item xs={6}>
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
        Enter a Valid Email Address
      </Typography>
      <Box component="form" noValidate={false} onSubmit={handleAddEmail} sx={{ mt: 1 }}>

        <TextField
          margin="normal"
          required
          fullWidth
          id="email"
          label="Email Address"
          name="email"
          type="email"

        />

        <Button
          type="submit"
          fullWidth
          variant="contained"
          sx={{ mt: 3, mb: 2 }}
        >
          Add email
        </Button>
        <FormHelperText style={{ color: color }} variant="standard" id="component-error-text">{message}</FormHelperText>
      </Box>
    </Box>
    </Grid>

    <Grid item xs={6}>
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
        Your current Secondary emails:
      </Typography>

      <List>
        {renderEmails()}
      </List>
   
    </Box>
    </Grid>
    
    </Grid>
  )
}

export default AddEmail