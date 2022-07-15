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

import { ADD_EMAIL, DELETE_EMAIL, GET_EMAILS, SET_PRIMARY_EMAIL } from '../../apollo/requests'
import { client } from '../../apollo'

const AddEmail = () => {
  const [color, setColor] = React.useState('black')
  const [message, setMessage] = React.useState('')
  const [emails, setEmails] = React.useState([])

  const handleAddEmail = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);

    client.mutate({
      mutation: ADD_EMAIL,
      variables: {
        email: data.get('email'),

      },

    }).then(res => {
      getEmails()
      setMessage(res.data.addEmail)
      setColor('green')
    }).catch(err => {
      setColor('red')
      setMessage(err.message)
    })

  }
  const getEmails = () => {
    client.query({
      query: GET_EMAILS,
      fetchPolicy: "network-only"
    }).then(res => {
      setEmails(res.data.getUserEmails.user_emails)
    }).catch(err => {
      setColor('red')
      setMessage(err.message)
    })
  }
  const renderEmails = (isPrimary) => {
    if (emails.length > 0) {
      return emails.map((ele, i) => {
        if (isPrimary && ele.isPrimary) {
          return (
            <Grid key={i} style={{ paddingTop: '10px' }} container spacing={2}>
              <Grid item xs={6}>
                <ListItem  disablePadding>
                  {ele.email}
                </ListItem>
              </Grid>
              <Grid   item xs={6}>
               <Typography component="h3" variant="h5"> Status :  <span style={{color: ele.isVerified ? "green" : "red"}} >{ ele.isVerified ? "Verified" : "Not Verified !"}</span> </Typography>
              </Grid>

            </Grid>


          )
        } else if (!isPrimary && !ele.isPrimary) {
          return (
            <Grid key={i} style={{ paddingTop: '10px' }} container spacing={2}>
              <Grid item xs={4}>
                <ListItem  disablePadding>
                  {ele.email}
                </ListItem>
              </Grid>
              <Grid  item xs={2}>
                <Button size="medium" color="success" onClick={() => handleSetPrimaryEmail(ele)} variant="outlined">Set Primary</Button>
              </Grid>
              <Grid  item xs={2}>
                <Button size="medium" color="error" onClick={() => handleDeleteEmail(ele)} variant="outlined">Delete Email</Button>
              </Grid>
              <Grid  item xs={4}>
                <Typography component="h3" variant="h5"> Status : <span style={{color: ele.isVerified ? "green" : "red"}} >{ ele.isVerified ? "Verified" : "Not Verified !"}</span> </Typography>

              </Grid>
            </Grid>

          )
        }
      })
    }
  }

  handleDeleteEmail = (email) => {
    client.mutate({
      mutation: DELETE_EMAIL,
      variables: {
        id: parseInt(email.id),
      },

    }).then(res => {
      getEmails()
      setMessage(res.data.deleteEmail)
      setColor('green')
    }).catch(err => {
      setColor('red')
      setMessage(err.message)
    })

  }
  handleSetPrimaryEmail = (email) => {
    client.mutate({
      mutation: SET_PRIMARY_EMAIL,
      variables: {
        id: parseInt(email.id),
      },

    }).then(res => {
      getEmails()
      setMessage(res.data.deleteEmail)
      setColor('green')
    }).catch(err => {
      setColor('red')
      setMessage(err.message)
    })
  }

  React.useEffect(() => {
    getEmails()
  }, [])
  return (
    <Grid container spacing={2}>
      <Grid item xs={4}>
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

      <Grid item xs={8}>
        <Box
          sx={{
            my: 12,
            mx: 6,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'start',
          }}
        >
          <Typography component="h1" variant="h5">
            Primary Email
          </Typography>

          <List style={{ width: "100%" }}>
            {renderEmails(true)}
          </List>
          <Typography component="h1" variant="h5">
            Your current Secondary emails:
          </Typography>

          <List style={{ width: "100%" }}>
            {renderEmails(false)}
          </List>
        </Box>

      </Grid>

    </Grid>
  )
}

export default AddEmail