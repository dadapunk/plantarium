// apps/frontend/src/components/PlantTable.tsx
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
} from "@mui/material";
import { Plant } from "../pages/api/hello";
import AddPlantForm from "./AddPlantForm";

interface PlantTableProps {
  data: Plant[];
  onAddPlant: (plant: Plant) => void;
}

const PlantTable = ({ data, onAddPlant }: PlantTableProps) => {
  const [plants, setPlants] = useState<Plant[]>(data);

  const handleAddPlant = (newPlant: Plant) => {
    setPlants((prevPlants) => [...prevPlants, newPlant]);
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
            </TableRow>
          </TableHead>
          <TableBody>
            {plants.map((plant) => (
              <TableRow key={plant.id}>
                <TableCell>{plant.name}</TableCell>
                <TableCell>{plant.species}</TableCell>
                <TableCell>{plant.family}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Container>
  );
};

export default PlantTable;
