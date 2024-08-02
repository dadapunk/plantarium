import React, { useState } from 'react';
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
} from '@mui/material';
import { Plant } from '../pages/api/hello';
import AddPlantForm from './AddPlantForm';

interface PlantTableProps {
  data: Plant[];
  onAddPlant: (plant: Plant) => void;
}

const PlantTable = ({ data, onAddPlant }: PlantTableProps) => {
  return (
    <>
      <AddPlantForm onAddPlant={onAddPlant} />

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
