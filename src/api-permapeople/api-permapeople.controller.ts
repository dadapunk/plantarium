import {
  Body,
  Controller,
  Get,
  Logger,
  NotFoundException,
  Param,
  ParseIntPipe,
  Post,
} from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { ApiPermapeopleService } from '../api-permapeople/api-permapeople.service';
import { SearchPlantsDTO } from './dto/search-plant.dto';
import { ExternalPlantDTO } from 'src/plant/dto/external-plant.dto';

@ApiTags('API PermaPeople')
@Controller('external')
export class ApiPermaPeopleController {
  private readonly logger = new Logger(ApiPermaPeopleController.name);
  constructor(private readonly permaPeopleService: ApiPermapeopleService) {}

  @Get('plants')
  @ApiOperation({ summary: 'Fetch external plants' })
  @ApiResponse({
    status: 200,
    description: 'Return external plants.',
  })
  @ApiResponse({ status: 404, description: 'Could not fetch external plants.' })
  async fetchExternalPlants(): Promise<any> {
    try {
      const response = await this.permaPeopleService.fetchExternalPlants();

      return response;
    } catch (error) {
      throw new NotFoundException('Could not fetch external plants');
    }
  }
  @Post('search')
  @ApiOperation({ summary: 'Search plants' })
  @ApiResponse({
    status: 200,
    description: 'Return searched plants.',
  })
  @ApiResponse({ status: 404, description: 'Could not find plants.' })
  async searchPlants(@Body() searchPlantsDTO: SearchPlantsDTO): Promise<any> {
    try {
      const response = await this.permaPeopleService.searchExternalPlants(
        searchPlantsDTO.query,
      );
      return response;
    } catch (error) {
      throw new NotFoundException('Could not find plants');
    }
  }
  @Get(':id')
  @ApiOperation({ summary: 'Get a plant by ID' })
  @ApiResponse({
    status: 200,
    description: 'Return the plant with the given ID.',
  })
  @ApiResponse({ status: 404, description: 'Plant not found.' })
  async findPlantById(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ExternalPlantDTO> {
    const plant = await this.permaPeopleService.getPlantById(id);
    if (!plant) {
      throw new NotFoundException({
        message: `Plant with ID ${id} not found`,
        error: 'Not Found',
        statusCode: 404,
      });
    }
    return plant;
  }
}
