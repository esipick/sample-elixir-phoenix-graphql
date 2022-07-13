import * as React from 'react';
import Paper from '@mui/material/Paper';
import MenuList from '@mui/material/MenuList';
import MenuItem from '@mui/material/MenuItem';
import ListItemText from '@mui/material/ListItemText';


export default function IconMenu() {
  return (
    <Paper sx={{ width: 320, maxWidth: '100%' }}>
      <MenuList>
        <MenuItem>
          <ListItemText>Change Email</ListItemText>

        </MenuItem>

        <MenuItem>
          <ListItemText>Chane Password</ListItemText>
        </MenuItem>

        <MenuItem>
          <ListItemText>Add Email</ListItemText>
        </MenuItem>


      </MenuList>
    </Paper>
  );
}
