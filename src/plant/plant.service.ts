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

  async create(createPlantDTO: CreatePlantDTO): Promise<Plant> {
    const plant = this.plantRepository.create(createPlantDTO);
    return this.plantRepository.save(plant);
  }

  async findAll(): Promise<Plant[]> {
    return this.plantRepository.find();
  }

  async findOne(id: number): Promise<Plant> {
    return this.plantRepository.findOne({ where: { id } });
  }

  async update(id: number, updatePlantDTO: CreatePlantDTO): Promise<Plant> {
    const plant = await this.plantRepository.findOne({ where: { id } });
    if (!plant) {
      throw new NotFoundException(`Plant with ID ${id} not found`);
    }
    const updatedPlant = this.plantRepository.merge(plant, updatePlantDTO);
    return this.plantRepository.save(updatedPlant);
  }

  async remove(id: number): Promise<void> {
    const plant = await this.plantRepository.findOne({ where: { id } });
    if (!plant) {
      throw new NotFoundException(`Plant with ID ${id} not found`);
    }
    await this.plantRepository.remove(plant);
  }
}
