import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  NotFoundException,
  Put,
} from '@nestjs/common';
import { Plant } from './entities/plant.entity';
import { CreatePlantDTO } from './dto/create-plant.dto';
import { PlantService } from './plant.service';

@Controller({ path: 'plant' })
export class PlantController {
  constructor(private readonly service: PlantService) {}

  plants: Plant[] = [];
  idCounter = 1;

  @Get()
  findPlants(): Plant[] {
    return this.service.findAll();
  }

  @Get(':id')
  findPlantById(@Param('id') id: number): Plant {
    // Use a ParseIntPipe
    const plant = this.plants.find((item) => item.id == id);
    if (!plant) {
      throw new NotFoundException('Plant not found');
    }
    return plant;
  }

  @Post('/add') //replace per CreatePlantDTO
  addPlant(@Body() body: Plant): void {
    // TODO: Validate the body before pushing it into the array
    body.id = this.idCounter++;
    this.plants.push(body);
  }
  @Post()
  async createPlant(@Body() createPlantDTO: CreatePlantDTO) {
    return 'This action adds a new plant';
  }

  @Delete('delete/:id')
  removePlant(@Param('id') id: number): void {
    console.log(`Attempting to delete plant with id: ${id}`);
    const initialLength = this.plants.length;
    this.plants = this.plants.filter((item) => item.id != id);
    if (this.plants.length === initialLength) {
      console.log(`No plant found with id: ${id}`);
    } else {
      console.log(`Deleted plant with id: ${id}`);
    }
  }
  @Put('update/:id')
  updatePlant(@Param('id') id: number, @Body() body: Plant): void {
    console.log(`Attempting to update plant with id: ${id}`);
    const plant = this.plants.find((item) => item.id == id);
    if (!plant) {
      throw new NotFoundException('Plant not found');
    }
    plant.name = body.name;
    plant.description = body.description;
    plant.imageUrl = body.imageUrl;
    plant.stock = body.stock;
    console.log(`Updated plant with id: ${id}`);
  }
}
