import { Test, TestingModule } from '@nestjs/testing';
import { PlantController } from './plant.controller';
import { PlantService } from './plant.service';
import { NotFoundException } from '@nestjs/common';
import { Plant } from './entities/plant.entity';
import { ApiPermapeopleService } from '../api-permapeople/api-permapeople.service';
import { HttpModule } from '@nestjs/axios';
import { ConfigModule } from '@nestjs/config';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PlotService } from '../plot/plot.service';
import { Plot } from '../plot/entities/plot.entity';
import { PlantMapping } from './entities/plant-mapping.entity';
import { PlantSyncService } from './plant-sync.service';

describe('PlantController', () => {
  let controller: PlantController;
  let service: PlantService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [HttpModule, ConfigModule],
      controllers: [PlantController],
      providers: [
        PlantService,
        ApiPermapeopleService,
        PlotService,
        PlantSyncService,

        {
          provide: getRepositoryToken(Plant),
          useClass: Repository,
        },
        {
          provide: getRepositoryToken(Plot),
          useClass: Repository,
        },
        {
          provide: getRepositoryToken(PlantMapping),
          useClass: Repository,
        },
      ],
    }).compile();

    controller = module.get<PlantController>(PlantController);
    service = module.get<PlantService>(PlantService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('findPlantById', () => {
    it('should return a plant if found', async () => {
      const plant: Plant = {
        id: 1,
        name: 'Rose',
        age: 2,
        species: 'Rosa',
        family: 'Rosaceae',
        plot: null,
        leafShape: 'Oval',
        plantingDate: new Date(),
      };
      jest.spyOn(service, 'findOne').mockResolvedValue(plant);

      expect(await controller.findPlantById(1)).toEqual(plant);
    });

    it('should throw NotFoundException if plant not found', async () => {
      jest.spyOn(service, 'findOne').mockResolvedValue(null);

      await expect(controller.findPlantById(1)).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
