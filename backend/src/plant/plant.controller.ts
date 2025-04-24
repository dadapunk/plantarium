import {
  Controller,
  Get,
  Param,
  Delete,
  Put,
  Body,
  NotFoundException,
  ParseIntPipe,
  Post,
  UsePipes,
  ValidationPipe,
  BadRequestException,
  Patch,
  Logger,
} from '@nestjs/common';
import { CreatePlantDTO } from './dto/create-plant.dto';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { PlantService } from './plant.service';
import { Plant } from './entities/plant.entity';
import { QueryFailedError } from 'typeorm';
import { ApiPermapeopleService } from '../api-permapeople/api-permapeople.service';
import { SyncedPlantDTO } from './dto/synced-plant.dto';
import { PlantSyncService } from './plant-sync.service';
import { ExternalPlantDTO } from './dto/external-plant.dto';

@ApiTags('plants')
@Controller({ path: 'plant' })
export class PlantController {
  constructor(
    private readonly plantService: PlantService,
    private readonly permaPeopleService: ApiPermapeopleService,
    private readonly plantSyncService: PlantSyncService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Get all plants' })
  @ApiResponse({ status: 200, description: 'Return all plants.' })
  @ApiResponse({ status: 404, description: 'Plants not found.' })
  async findPlants(): Promise<Plant[]> {
    const plants = await this.plantService.findAll();
    if (plants.length === 0) {
      throw new NotFoundException({
        message: 'Plants not found',
        error: 'Not Found',
        statusCode: 404,
      });
    }
    return plants;
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a plant by ID' })
  @ApiResponse({
    status: 200,
    description: 'Return the plant with the given ID.',
  })
  @ApiResponse({ status: 404, description: 'Plant not found.' })
  async findPlantById(@Param('id', ParseIntPipe) id: number): Promise<Plant> {
    const plant = await this.plantService.findOne(id);
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
  @ApiOperation({ summary: 'Create a new plant' })
  @ApiResponse({
    status: 201,
    description: 'The plant has been successfully created.',
  })
  @ApiResponse({ status: 400, description: 'Invalid input.' })
  @UsePipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true }))
  async createPlant(@Body() createPlantDTO: CreatePlantDTO): Promise<Plant> {
    try {
      return this.plantService.create(createPlantDTO);
    } catch (error) {
      if (
        error instanceof QueryFailedError &&
        error.message.includes(
          'SQLITE_CONSTRAINT: FOREIGN KEY constraint failed',
        )
      ) {
        throw new BadRequestException('Plot not found');
      }
      throw error;
    }
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a plant by ID' })
  @ApiResponse({
    status: 204,
    description: 'The plant has been successfully deleted.',
  })
  @ApiResponse({ status: 404, description: 'Plant not found.' })
  async removePlant(@Param('id', ParseIntPipe) id: number): Promise<void> {
    await this.plantService.remove(id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update a plant by ID' })
  @ApiResponse({
    status: 200,
    description: 'The plant has been successfully updated.',
  })
  @ApiResponse({ status: 404, description: 'Plant not found.' })
  async updatePlant(
    @Param('id', ParseIntPipe) id: number,
    @Body() updatePlantDTO: CreatePlantDTO,
  ): Promise<Plant> {
    return await this.plantService.update(id, updatePlantDTO);
  }
  @Patch(':id')
  @ApiOperation({ summary: 'Move a plant to another plot' })
  @ApiResponse({
    status: 200,
    description: 'The plant has been successfully moved.',
  })
  @ApiResponse({ status: 404, description: 'Plant not found.' })
  async movePlant(
    @Param('id', ParseIntPipe) id: number,
    @Body() updatePlantDTO: CreatePlantDTO,
  ): Promise<Plant> {
    return await this.plantService.addPlantToPlot(
      id,
      updatePlantDTO.plotId,
      updatePlantDTO,
    );
  }
  @Post('import/:id')
  @ApiOperation({ summary: 'Import a plant from the external API' })
  @ApiResponse({
    status: 201,
    description: 'The plant has been successfully imported.',
  })
  @ApiResponse({ status: 404, description: 'Plant not found in external API.' })
  async importPlantFromExternalApi(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<Plant> {
    const externalPlantData = await this.permaPeopleService.getPlantById(id);
    const externalPlant = new ExternalPlantDTO(externalPlantData);
    const internalPlant =
      this.plantService.mapExternalToInternal(externalPlant);
    const createdPlant = await this.plantService.create(internalPlant);
    await this.plantService.insertPlantMapping(createdPlant.id, id);
    Logger.log(`Inserted plant mapping for plant ID ${createdPlant.id}`);
    Logger.log(`Imported plant with ID ${id}`);

    return createdPlant;
  }
  // Syncs all plants from the external API with the local database.
  // Imports new plants and updates existing ones.
  @Post('sync')
  @ApiOperation({ summary: 'Sync plants with external API' })
  @ApiResponse({
    status: 200,
    description: 'The plants have been successfully synced.',
  })
  async syncPlants(): Promise<SyncedPlantDTO[]> {
    return this.plantSyncService.syncPlants();
  }
}
