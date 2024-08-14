import React, { useState } from "react";
import { TextField, Button, Paper, Box } from "@mui/material";
import { Plant } from "../pages/api/hello";

interface AddPlantFormProps {
  onAddPlant: (plant: Plant) => void;
}

const initialPlantState: Partial<Plant> = {
  name: "",
  species: "",
  family: "",
  age: 0,
  leafShape: "",
  plantingDate: "",
};

const AddPlantForm = ({ onAddPlant }: AddPlantFormProps) => {
  const [newPlant, setNewPlant] = useState<Partial<Plant>>(initialPlantState);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setNewPlant((prev) => ({
      ...prev,
      [name]: name === "age" ? Number(value) : value,
    }));
  };

  const handleAddPlant = async () => {
    if (Object.values(newPlant).every((value) => value)) {
      try {
        const response = await fetch("http://localhost:3002/plant", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(newPlant),
        });

        if (!response.ok) {
          const errorText = await response.text();
          throw new Error(`Failed to create plant: ${errorText}`);
        }

        const createdPlant = await response.json();
        onAddPlant(createdPlant);
        setNewPlant(initialPlantState);
      } catch (error) {
        console.error("Error creating plant:", error);
      }
    }
  };

  return (
    <Paper style={{ padding: "16px", marginTop: "16px" }}>
      <Box display="flex" alignItems="center">
        {["name", "species", "family", "age", "leafShape", "plantingDate"].map(
          (field) => (
            <TextField
              key={field}
              label={field.charAt(0).toUpperCase() + field.slice(1)}
              name={field}
              type={
                field === "age"
                  ? "number"
                  : field === "plantingDate"
                    ? "date"
                    : "text"
              }
              value={newPlant[field as keyof Plant] || ""}
              onChange={handleChange}
              margin="normal"
              style={{ marginRight: "16px" }}
              InputLabelProps={
                field === "plantingDate" ? { shrink: true } : undefined
              }
            />
          )
        )}
        <Button variant="contained" color="primary" onClick={handleAddPlant}>
          Add Plant
        </Button>
      </Box>
    </Paper>
  );
};

export default AddPlantForm;
