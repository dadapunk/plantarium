import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Req,
} from '@nestjs/common';

@Controller({ path: 'plant' })
export class PlantController {
  plants = [];

  @Get()
  findPlants() {
    return this.plants;
  }

  @Get(':id/requirements/:reqId')
  findPlantById(@Param() params: any) {
    return this.plants.find((item) => item.id === id);
  }

  @Post()
  addPlant(@Body() body: any) {
    this.plants.push(body);
  }

  @Delete(':id')
  removePlant(@Param('id') id: any) {
    this.plants = this.plants.filter((item) => item.id !== id);
  }
}
