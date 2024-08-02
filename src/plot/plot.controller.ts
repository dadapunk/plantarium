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
} from '@nestjs/common';
import { CreatePlotDTO } from './dto/create-plot.dto';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { PlotService } from './plot.service';
import { Plot } from './entities/plot.entity';

@ApiTags('plots')
@Controller({ path: 'plot' })
export class PlotController {
  constructor(private readonly service: PlotService) {}

  @Get()
  @ApiOperation({ summary: 'Get all plots' })
  @ApiResponse({ status: 200, description: 'Return all plots.' })
  async findPlots(): Promise<Plot[]> {
    return this.service.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a plot by ID' })
  @ApiResponse({
    status: 200,
    description: 'Return the plot with the given ID.',
  })
  @ApiResponse({ status: 404, description: 'Plot not found.' })
  async findPlotById(@Param('id', ParseIntPipe) id: number): Promise<Plot> {
    const plot = await this.service.findOne(id);
    if (!plot) {
      throw new NotFoundException({
        message: `Plot with ID ${id} not found`,
        error: 'Not Found',
        statusCode: 404,
      });
    }
    return plot;
  }
  @Post()
  @ApiOperation({ summary: 'Create a new plot' })
  @ApiResponse({
    status: 201,
    description: 'The plot has been successfully created.',
  })
  @ApiResponse({ status: 400, description: 'Invalid input.' })
  async createPlot(@Body() createPlotDTO: CreatePlotDTO): Promise<Plot> {
    return this.service.create(createPlotDTO);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a plot by ID' })
  @ApiResponse({
    status: 204,
    description: 'The plot has been successfully deleted.',
  })
  @ApiResponse({ status: 404, description: 'Plot not found.' })
  async removePlot(@Param('id', ParseIntPipe) id: number): Promise<void> {
    await this.service.remove(id);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update a plot by ID' })
  @ApiResponse({
    status: 200,
    description: 'The plot has been successfully updated.',
  })
  @ApiResponse({ status: 404, description: 'Plot not found.' })
  async updatePlot(
    @Param('id', ParseIntPipe) id: number,
    @Body() plot: CreatePlotDTO,
  ): Promise<Plot> {
    return this.service.update(id, plot);
  }
}
