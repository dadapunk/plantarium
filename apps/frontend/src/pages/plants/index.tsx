import React from "react";
import AddPlantForm from "../../components/AddPlantForm";
import PlantTable from "../../components/PlantTable";
import { Plant } from "../../pages/api/hello";

const App = () => {
  const [plants, setPlants] = React.useState<Plant[]>([]);

  const handleAddPlant = (newPlant: Plant) => {
    setPlants((prevPlants) => [...prevPlants, newPlant]);
  };

  return (
    <div>
      <AddPlantForm onAddPlant={handleAddPlant} />
      <PlantTable data={plants} onAddPlant={handleAddPlant} />
    </div>
  );
};

export default App;
