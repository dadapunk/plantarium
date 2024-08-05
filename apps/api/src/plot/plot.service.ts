import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreatePlotDTO } from './dto/create-plot.dto';
import { Plot } from './entities/plot.entity';

@Injectable()
export class PlotService {
  constructor(
    @InjectRepository(Plot)
    private plotRepository: Repository<Plot>,
  ) {}

  async create(createPlotDTO: CreatePlotDTO): Promise<Plot> {
    const plot = this.plotRepository.create(createPlotDTO);
    return this.plotRepository.save(plot);
  }
  async findAll(): Promise<Plot[]> {
    return this.plotRepository.find({ relations: ['plants'] });
  }
  async findOne(id: number): Promise<Plot> {
    return this.plotRepository.findOne({ where: { id } });
  }
  async update(id: number, updatePlotDTO: CreatePlotDTO): Promise<Plot> {
    const plot = await this.plotRepository.findOne({ where: { id } });
    if (!plot) {
      throw new NotFoundException(`Plot with ID ${id} not found`);
    }
    const updatedPlot = this.plotRepository.merge(plot, updatePlotDTO);
    return this.plotRepository.save(updatedPlot);
  }
  async remove(id: number): Promise<void> {
    const plot = await this.plotRepository.findOne({ where: { id } });
    if (!plot) {
      throw new NotFoundException(`Plot with ID ${id} not found`);
    }
    await this.plotRepository.remove(plot);
  }
}
