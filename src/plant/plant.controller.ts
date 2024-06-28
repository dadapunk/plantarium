import {
  Body,
  Controller,
  Delete,
  Get,
  NotFoundException,
  Param,
  Post,
  Put,
  ParseIntPipe,
} from '@nestjs/common';
import { CreatePlantDTO } from './dto/create-plant.dto';
import { PlantService } from './plant.service';
import { Plant } from './entities/plant.entity';

@Controller({ path: 'plant' })
export class PlantController {
  constructor(private readonly service: PlantService) {}

  @Get()
  async findPlants(): Promise<Plant[]> {
    return this.service.findAll();
  }

  @Get(':id')
  async findPlantById(@Param('id', ParseIntPipe) id: number): Promise<Plant> {
    const plant = await this.service.findOne(id);
    if (!plant) {
      throw new NotFoundException({
        message: `Plant with ID ${id} not found`,
        error: 'Not Found',
        statusCode: 404,
      });
    }
    return plant;
  }

  @Delete(':id')
  async removePlant(@Param('id', ParseIntPipe) id: number): Promise<void> {
    await this.service.remove(id);
  }

  @Put(':id')
  async updatePlant(
    @Param('id', ParseIntPipe) id: number,
    @Body() updatePlantDTO: CreatePlantDTO,
  ): Promise<Plant> {
    return await this.service.update(id, updatePlantDTO);
  }
}
