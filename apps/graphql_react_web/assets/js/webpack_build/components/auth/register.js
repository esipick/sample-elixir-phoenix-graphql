import * as React from 'react';
import Avatar from '@mui/material/Avatar';
import Button from '@mui/material/Button';
import CssBaseline from '@mui/material/CssBaseline';
import TextField from '@mui/material/TextField';
import FormControlLabel from '@mui/material/FormControlLabel';
import Checkbox from '@mui/material/Checkbox';
import Link from '@mui/material/Link';
import Paper from '@mui/material/Paper';
import Box from '@mui/material/Box';
import Grid from '@mui/material/Grid';
import FormHelperText from '@mui/material/FormHelperText';
import { useState } from 'react';
import { client } from '../../apollo'
import { REGISTER_USER } from '../../apollo/requests'
// import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import Typography from '@mui/material/Typography';
import { createTheme, ThemeProvider } from '@mui/material/styles';

function Copyright(props) {
  return (
    <Typography variant="body2" color="text.secondary" align="center" {...props}>
      {'Copyright © '}
      <Link color="inherit" href="">
        Elixir React Graphql Example App
      </Link>{' '}
      {new Date().getFullYear()}
      {'.'}
    </Typography>
  );
}

const theme = createTheme();

const errorMessage = (message) => {
  return (<FormHelperText style={{ color: 'red' }} variant="standard" id="component-error-text">{message}</FormHelperText>)
}
export default SignInSide = () => {
  const [password, setPassword] = useState('')
  const [isValid, setIsValid] = useState(false)
  const handleSubmit = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    client.mutate({
      mutation: REGISTER_USER,
      variables: {
        input: {
          email: data.get('email'),
          username: data.get('username'),
          firstName: data.get('firstName'),
          lastName: data.get('lastName'),
          password: data.get('password'),
          passwordConfirmation: data.get('passwordConfirmation'),
          platform: "ELIXIR_REACT"
        }
      },

    }).then((response) => {
      window.location.href = "/"
    })
      .catch((err) => console.error(err));

  };
  const handleFormToggle = (show) => {
    // setIsSignUp(show)
  }
  const checkPasswrod = (cp) => {
    if (password !== cp) {
      setIsValid(true)
    } else if (password === cp) {
      setIsValid(false)
    }
  }
  return (
    <ThemeProvider theme={theme}>
      <Grid container component="main" sx={{ height: '100vh' }}>
        <CssBaseline />
        <Grid
          item
          xs={false}
          sm={4}
          md={7}
          sx={{
            backgroundImage: 'url(https://source.unsplash.com/random)',
            backgroundRepeat: 'no-repeat',
            backgroundColor: (t) =>
              t.palette.mode === 'light' ? t.palette.grey[50] : t.palette.grey[900],
            backgroundSize: 'cover',
            backgroundPosition: 'center',
          }}
        />
        <Grid item xs={12} sm={8} md={5} component={Paper} elevation={6} square>
          <Box
            sx={{
              my: 8,
              mx: 4,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
            }}
          >
            <Avatar sx={{ m: 1, bgcolor: 'secondary.main' }}>
              {/* <LockOutlinedIcon /> */}
            </Avatar>
            <Typography component="h1" variant="h5">
              Sign Up
            </Typography>
            <Box component="form" noValidate onSubmit={handleSubmit} sx={{ mt: 1 }}>
              <TextField
                margin="normal"
                required
                fullWidth
                id="email"
                label="Email Address"
                name="email"

              />
              <TextField
                margin="normal"
                required
                fullWidth
                id="username"
                label="User Name"
                name="username"

              />
              <TextField
                margin="normal"
                required
                fullWidth
                id="fname"
                label="First Name"
                name="firstName"

              />
              <TextField
                margin="normal"
                required
                fullWidth
                id="lname"
                label="Last Name"
                name="lastName"

              />
              <TextField
                margin="normal"
                required
                fullWidth
                name="password"
                label="Password"
                type="password"
                id="password"
                error={isValid}
                autoComplete="current-password"
                onChange={(e) => { setPassword(e.target.value) }}
              />
              <TextField
                margin="normal"
                required
                fullWidth
                name="passwordConfirmation"
                label="confirm Password"
                type="password"
                id="password"
                onChange={(e) => checkPasswrod(e.target.value)}
                error={isValid}
              />
              {isValid ? errorMessage('Password does not match!') : ""}
              <Button
                type="submit"
                fullWidth
                variant="contained"
                sx={{ mt: 3, mb: 2 }}
                disabled={isValid}
              >
                Sign Up
              </Button>
              <Grid container>
                <Grid item>
                  <Link href="/" variant="text">Already have an account ! login in</Link>
                </Grid>
              </Grid>
              <Copyright sx={{ mt: 5 }} />
            </Box>

          </Box>
        </Grid>
      </Grid>
    </ThemeProvider>
  );
} 
