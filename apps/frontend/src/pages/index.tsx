import { useState, useEffect } from 'react';
import PlantTable from '@/components/PlantTable';
import { Plant } from './api/hello';

function Profile() {
  const [data, setData] = useState<Plant[]>([]);
  const [isLoading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetch('http://localhost:3002/plant')
      .then((response) => response.json())
      .then((data) => {
        setData(data);
        setLoading(false);
      })
      .catch((error) => {
        setError(error.message);
        setLoading(false);
      });
  }, []);

  if (isLoading) return <p>Loading...</p>;
  if (error) return <p>Error: {error}</p>;
  if (!data.length) return <p>No profile data</p>;

  return (
    <PlantTable
      data={data}
      onAddPlant={function (plant: Plant): void {
        throw new Error('Function not implemented.');
      }}
    />
  );
}

export default Profile;
