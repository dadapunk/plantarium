import React from "react";
import { AppBar, Toolbar, Typography, Button, Box } from "@mui/material";
import { Link } from "react-router-dom";

const Navbar = () => {
  return (
    <AppBar position="static">
      <Toolbar>
        <Typography variant="h6" style={{ flexGrow: 1 }}>
          Plantarium
        </Typography>
        <Box>
          <Button color="inherit" component={Link} to="/plots">
            Plots
          </Button>
          <Button color="inherit" component={Link} to="/plants">
            Plants
          </Button>
          <Button color="inherit" component={Link} to="/garden-notes">
            Garden Notes
          </Button>
          <Button color="inherit" component={Link} to="/calendar">
            Calendar
          </Button>
        </Box>
      </Toolbar>
    </AppBar>
  );
};

export default Navbar;
