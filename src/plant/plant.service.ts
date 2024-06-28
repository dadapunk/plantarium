import { Injectable, NotFoundException } from '@nestjs/common';
import { Plant } from './entities/plant.entity';
import { CreatePlantDTO } from './dto/create-plant.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@Injectable()
export class PlantService {
  constructor(
    @InjectRepository(Plant)
    private plantRepository: Repository<Plant>,
  ) {}

  plants: Plant[] = [];
  idCounter = 1;

  async create(createPlantDTO: CreatePlantDTO): Promise<Plant> {
    const plant = this.plantRepository.create(createPlantDTO);
    return this.plantRepository.save(plant);
  }

  findAll(): Plant[] {
    return this.plants;
  }

  findOne(id: number): Plant {
    const plant = this.plants.find((item) => item.id === id);
    if (!plant) {
      throw new NotFoundException(`Plant with ID ${id} not found`);
    }
    return plant;
  }

  update(id: number, updatePlantDTO: CreatePlantDTO): Plant {
    const plantIndex = this.plants.findIndex((item) => item.id === id);
    if (plantIndex === -1) {
      throw new NotFoundException(`Plant with ID ${id} not found`);
    }
    this.plants[plantIndex] = { ...this.plants[plantIndex], ...updatePlantDTO };
    return this.plants[plantIndex];
  }

  remove(id: number): void {
    const plantIndex = this.plants.findIndex((item) => item.id === id);
    if (plantIndex === -1) {
      throw new NotFoundException(`Plant with ID ${id} not found`);
    }
    this.plants.splice(plantIndex, 1);
  }
}
