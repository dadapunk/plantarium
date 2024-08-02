import React, { useState } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  TextField,
  Button,
} from '@mui/material';
import { Plant } from '../pages/api/hello';

interface PlantTableProps {
  data: Plant[];
  onAddPlant: (plant: Plant) => void;
}

const PlantTable = ({ data, onAddPlant }: PlantTableProps) => {
  const [newPlant, setNewPlant] = useState<Partial<Plant>>({
    name: '',
    species: '',
    family: '',
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setNewPlant((prev) => ({ ...prev, [name]: value }));
  };

  const handleAddPlant = () => {
    if (newPlant.name && newPlant.species && newPlant.family) {
      onAddPlant(newPlant as Plant);
      setNewPlant({ name: '', species: '', family: '' });
    }
  };

  return (
    <>
      <Paper style={{ padding: '16px', marginTop: '16px' }}>
        <h3>Add a New Plant</h3>
        <TextField
          label="Name"
          name="name"
          value={newPlant.name}
          onChange={handleChange}
          fullWidth
          margin="normal"
        />
        <TextField
          label="Species"
          name="species"
          value={newPlant.species}
          onChange={handleChange}
          fullWidth
          margin="normal"
        />
        <TextField
          label="Family"
          name="family"
          value={newPlant.family}
          onChange={handleChange}
          fullWidth
          margin="normal"
        />
        <Button
          variant="contained"
          color="primary"
          onClick={handleAddPlant}
          style={{ marginTop: '16px' }}
        >
          Add Plant
        </Button>
      </Paper>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Species</TableCell>
              <TableCell>Family</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {data.map((plant) => (
              <TableRow key={plant.id}>
                <TableCell>{plant.name}</TableCell>
                <TableCell>{plant.species}</TableCell>
                <TableCell>{plant.family}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </>
  );
};

export default PlantTable;
