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
import PropTypes from 'prop-types';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';

import UpdatePassword from './update-password'
import AddNewEmail from './add-email'

import { getLSItem } from '../../utils/utils';
import { UPDATE_EMAIL, GET_EMAILS } from '../../apollo/requests'
import { client } from '../../apollo'


function TabPanel(props) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography  component="h1">{children}</Typography>
        </Box>
      )}
    </div>
  );
}

TabPanel.propTypes = {
  children: PropTypes.node,
  index: PropTypes.number.isRequired,
  value: PropTypes.number.isRequired,
};

function a11yProps(index) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}


const Settings = () => {
  const [color, setColor] = React.useState('black')
  const [message, setMessage] = React.useState('')
  const [value, setValue] = React.useState(0);


  const showEmailChange = () => {
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
          Enter New Email Address
        </Typography>
        <Box component="form" noValidate={false} onSubmit={handleUpdateEmail} sx={{ mt: 1 }}>
          <TextField
            margin="normal"
            required
            fullWidth
            id="email"
            label="Email Address"
            name="email"

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



  const handleUpdateEmail = (event) => {
    event.preventDefault();
    const data = new FormData(event.currentTarget);
    if (data.get('email')) {
      client.mutate({
        mutation: UPDATE_EMAIL,
        variables: {
          email: data.get('email'),
          emailNo: 1,
          dataNo: "asdsad"
        }

      }).then(res => {
        setMessage(res.data.updateEmail)
        setColor('green')
      }).catch(err => {
        setColor('red')
        setMessage(err.message)
      })
    }
  }

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  React.useEffect(() => {
    const token = getLSItem('Access_Token')
    if (!token) {
      window.location.href = "/"
    }
  }, [])
  return (
    <Grid container spacing={2}>
      <Grid item xs={12}>
        <Box sx={{ width: '100%' }}>
          <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
            <Tabs value={value} onChange={handleChange} aria-label="basic tabs example">
              <Tab label="Change Email" {...a11yProps(0)} />
              <Tab label="Chane Password" {...a11yProps(1)} />
              <Tab label="Add Secondary Email" {...a11yProps(2)} />
            </Tabs>
          </Box>
          <TabPanel value={value} index={0}>
            {showEmailChange()}
          </TabPanel>
          <TabPanel value={value} index={1}>
            <UpdatePassword />
          </TabPanel>
          <TabPanel value={value} index={2}>
            <AddNewEmail  />
          </TabPanel>
        </Box>

      </Grid>


    </Grid>
  )
}


export default Settings