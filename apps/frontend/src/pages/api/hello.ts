import type { NextApiRequest, NextApiResponse } from "next";

export interface Plant {
  id: number;
  name: string;
  age: number;
  species: string;
  family: string;
  leafShape: string;
  plantingDate: string;
}

const mockPlants: Plant[] = [
  {
    id: 1,
    name: "Rose",
    age: 2,
    species: "Rosa",
    family: "Rosaceae",
    leafShape: "Ovate",
    plantingDate: "2021-04-12",
  },
  {
    id: 2,
    name: "Tulip",
    age: 1,
    species: "Tulipa",
    family: "Liliaceae",
    leafShape: "Lanceolate",
    plantingDate: "2022-03-15",
  },
];

export default function handler(
  req: NextApiRequest,
  res: NextApiResponse<Plant[] | { error: string }>
) {
  try {
    res.status(200).json(mockPlants);
  } catch (error) {
    res.status(500).json({ error: "Internal Server Error" });
  }
}
