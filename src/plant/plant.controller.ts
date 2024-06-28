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
  findPlantById(@Param('id', ParseIntPipe) id: number): Plant {
    const plant = this.service.findOne(id);
    if (!plant) {
      throw new NotFoundException({
        message: `Plant with ID ${id} not found`,
        error: 'Not Found',
        statusCode: 404,
      });
    }
    return plant;
  }

  @Post()
  async createPlant(@Body() createPlantDTO: CreatePlantDTO): Promise<Plant> {
    return await this.service.create(createPlantDTO);
  }

  @Delete(':id')
  removePlant(@Param('id', ParseIntPipe) id: number): void {
    this.service.remove(id);
  }

  @Put(':id')
  updatePlant(
    @Param('id', ParseIntPipe) id: number,
    @Body() updatePlantDTO: CreatePlantDTO,
  ): Plant {
    return this.service.update(id, updatePlantDTO);
  }
}
