import React, { useState } from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Container,
  Typography,
  IconButton,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  TextField,
  Button,
} from "@mui/material";
import { Edit as EditIcon } from "@mui/icons-material";
import { Plant } from "../pages/api/hello";
import AddPlantForm from "./AddPlantForm";

interface PlantTableProps {
  data: Plant[];
  onAddPlant: (plant: Plant) => void;
}

const PlantTable = ({ data, onAddPlant }: PlantTableProps) => {
  const [plants, setPlants] = useState<Plant[]>(data);
  const [editingPlant, setEditingPlant] = useState<Partial<Plant> | null>(null);

  const handleAddPlant = (newPlant: Plant) => {
    setPlants((prevPlants) => [...prevPlants, newPlant]);
  };

  const updatePlant = async (plant: Partial<Plant>) => {
    try {
      console.log("Updating plant:", plant); // Log the plant data being sent
      const response = await fetch(`http://localhost:3002/plant/${plant.id}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(plant),
      });

      if (!response.ok) {
        throw new Error("Failed to update plant");
      }

      const updatedPlant = await response.json();
      console.log("Updated plant:", updatedPlant); // Log the updated plant data received
      return updatedPlant;
    } catch (error) {
      console.error("Error updating plant:", error);
      throw error;
    }
  };

  const handleSaveEdit = async () => {
    if (editingPlant) {
      try {
        console.log("Saving edited plant:", editingPlant); // Log the editing plant data
        const updatedPlant = await updatePlant(editingPlant);
        setPlants((prevPlants) =>
          prevPlants.map((plant) =>
            plant.id === updatedPlant.id ? updatedPlant : plant
          )
        );
        setEditingPlant(null);
      } catch (error) {
        console.error("Error saving edited plant:", error);
      }
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setEditingPlant((prev) => ({
      ...prev,
      [name]:
        name === "age"
          ? Number(value)
          : name === "plantingDate"
            ? value.split("T")[0]
            : value,
    }));
  };
  const handleEditClick = (plant: Plant) => {
    setEditingPlant({
      ...plant,
      plantingDate: plant.plantingDate
        ? new Date(plant.plantingDate).toISOString().split("T")[0]
        : "",
    });
  };

  return (
    <Container maxWidth="md" style={{ marginTop: "16px" }}>
      <AddPlantForm onAddPlant={handleAddPlant} />
      <Typography variant="h6" style={{ marginTop: "16px" }}>
        These are the local plants in your database
      </Typography>
      <TableContainer component={Paper} style={{ marginTop: "16px" }}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Species</TableCell>
              <TableCell>Family</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {plants.map((plant) => (
              <TableRow key={plant.id}>
                <TableCell>{plant.name}</TableCell>
                <TableCell>{plant.species}</TableCell>
                <TableCell>{plant.family}</TableCell>
                <TableCell>
                  <IconButton onClick={() => handleEditClick(plant)}>
                    <EditIcon />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      {editingPlant && (
        <Dialog
          open={Boolean(editingPlant)}
          onClose={() => setEditingPlant(null)}
        >
          <DialogTitle>Edit Plant</DialogTitle>
          <DialogContent>
            <TextField
              margin="dense"
              label="Name"
              name="name"
              value={editingPlant.name || ""}
              onChange={handleChange}
              fullWidth
            />
            <TextField
              margin="dense"
              label="Species"
              name="species"
              value={editingPlant.species || ""}
              onChange={handleChange}
              fullWidth
            />
            <TextField
              margin="dense"
              label="Family"
              name="family"
              value={editingPlant.family || ""}
              onChange={handleChange}
              fullWidth
            />
            <TextField
              margin="dense"
              label="Age"
              name="age"
              type="number"
              value={editingPlant.age || ""}
              onChange={handleChange}
              fullWidth
            />
            <TextField
              margin="dense"
              label="Leaf Shape"
              name="leafShape"
              value={editingPlant.leafShape || ""}
              onChange={handleChange}
              fullWidth
            />
            <TextField
              margin="dense"
              label="Planting Date"
              name="plantingDate"
              type="date"
              value={editingPlant.plantingDate || ""}
              onChange={handleChange}
              fullWidth
            />
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setEditingPlant(null)} color="primary">
              Cancel
            </Button>
            <Button onClick={handleSaveEdit} color="primary">
              Save
            </Button>
          </DialogActions>
        </Dialog>
      )}
    </Container>
  );
};

export default PlantTable;
