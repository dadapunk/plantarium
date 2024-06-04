import { Injectable } from '@nestjs/common';
import { Plant } from './entities/plant.entity';
import { CreatePlantDTO } from './dto/create-plant.dto';

@Injectable()
export class PlantService {
  create(createPlantDTO: CreatePlantDTO) {
    return 'This action adds a new plant';
  }
  findAll() {
    return 'This action returns all plants';
  }
  findOne(id: number) {
    return 'this action returns a #${id} plant';
  }
  update(id: number, updatePlantDTO: CreatePlantDTO) {
    return 'This action updates a #${id} plant';
  }
  remove(id: number) {
    return 'This action removes a #${id} plant';
  }
}
