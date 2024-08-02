import React, { useState } from 'react';
import { TextField, Button, Paper } from '@mui/material';
import { Plant } from '../pages/api/hello';

interface AddPlantFormProps {
  onAddPlant: (plant: Plant) => void;
}

const AddPlantForm = ({ onAddPlant }: AddPlantFormProps) => {
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
  );
};

export default AddPlantForm;
