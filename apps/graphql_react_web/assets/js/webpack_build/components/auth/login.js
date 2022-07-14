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
import { useState } from 'react';
import { client } from '../../apollo'
import { LOGIN } from '../../apollo/requests'
import Stack from '@mui/material/Stack';
import Snackbar from '@mui/material/Snackbar';
import FormHelperText from '@mui/material/FormHelperText';
import MuiAlert from '@mui/material/Alert';
// import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import Typography from '@mui/material/Typography';
import { createTheme, ThemeProvider } from '@mui/material/styles';
import { setLSItem, getLSItem } from '../../utils/utils'

// import Alert from '../alert'
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
const Alert = React.forwardRef(function Alert(props, ref) {
  return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />;
});
const theme = createTheme();


export default SignInSide = () => {

  const [isSignUp, setIsSignUp] = useState(false);
  const [errorMessage, setErrorMessage] = useState('')
  const handleSubmit = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    client.mutate({
      mutation: LOGIN,
      variables: { email: data.get('email'), password: data.get('password'), platform: "ELIXIR_REACT" },

    }).then((response) => {
      console.log(response.data.login.user)
      setLSItem('Access_Token', response.data.login.token)
      setLSItem('USER', response.data.login.user)
      window.location.href = "/home"
    })
      .catch((err) => {
        setErrorMessage(err.message)
      });
  };

  const handleFormToggle = (show) => {
    // setIsSignUp(show)
  }

  React.useEffect(() => {
    const token = getLSItem('Access_Token')
    if (token) {
      window.location.href = "/home"
    }
    return;
  }, [])
  return (

    <ThemeProvider theme={theme}>
      {/* <Alert severity="success">This is a success message!</Alert> */}
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
              Sign in
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
                name="password"
                label="Password"
                type="password"
                id="password"
                autoComplete="current-password"
              />
              <FormHelperText style={{ color: 'red' }} variant="standard" id="component-error-text">{errorMessage}</FormHelperText>
              <Button
                type="submit"
                fullWidth
                variant="contained"
                sx={{ mt: 3, mb: 2 }}
              >
                Sign In
              </Button>
              <Grid container>
                <Grid item>
                  <Link href="/register" variant="text">Don't have an account! Sign up</Link>
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
