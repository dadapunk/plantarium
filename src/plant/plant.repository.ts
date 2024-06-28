import { EntityRepository, Repository } from 'typeorm';
import { Plant } from '../plant/entities/plant.entity';
import { CreatePlantDTO } from '../plant/dto/create-plant.dto';

@EntityRepository(Plant)
export class PlantRepository extends Repository<Plant> {
  async createPlant(createPlantDto: CreatePlantDTO): Promise<Plant> {
    const { name, species, age } = createPlantDto;

    const plant = this.create({
      name,
      species,
      age,
    });

    await this.save(plant);
    return plant;
  }

  // Additional methods for find, update, delete can be added here
}
