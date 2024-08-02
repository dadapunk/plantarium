import React from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
} from "@mui/material";
import { Plant } from "../pages/api/hello";

interface PlantTableProps {
  data: Plant[];
}

const PlantTable = ({ data }: PlantTableProps) => {
  return (
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
  );
};

export default PlantTable;
