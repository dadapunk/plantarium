import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  NotFoundException,
} from '@nestjs/common';
import { Plant } from './plant.entity';

@Controller({ path: 'plant' })
export class PlantController {
  plants: Plant[] = [];
  idCounter = 1;

  @Get()
  findPlants(): Plant[] {
    return this.plants;
  }

  @Get(':id')
  findPlantById(@Param('id') id: number): Plant {
    console.log('id', id);
    const numId = Number(id);
    const plant = this.plants.find((item) => item.id === id);
    if (!plant) {
      throw new NotFoundException('Plant not found');
    }
    return plant;
  }

  @Post('/add')
  addPlant(@Body() body: Plant): void {
    // TODO: Validate the body before pushing it into the array
    body.id = this.idCounter++;
    this.plants.push(body);
  }

  @Delete('delete:id')
  removePlant(@Param('id') id: number): void {
    this.plants = this.plants.filter((item) => item.id !== id);
  }
}
