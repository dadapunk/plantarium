import { Injectable } from '@nestjs/common';
import { Plant } from './entities/plant.entity';
import { CreatePlantDTO } from './dto/create-plant.dto';

@Injectable()
export class PlantService {
  plants: Plant[] = [];
  idCounter = 1;

  create(createPlantDTO: CreatePlantDTO) {
    return this.plants;
  }
  findAll() {
    return this.plants;
  }
  findOne(id: number) {
    const plant = this.plants.find((item) => item.id == id);
    return plant;
  }
  update(id: number, updatePlantDTO: CreatePlantDTO) {
    return 'This action updates a #${id} plant';
  }
  remove(id: number) {
    return 'This action removes a #${id} plant';
  }
}
