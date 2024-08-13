import { Test, TestingModule } from '@nestjs/testing';
import { ApiPermaPeopleController } from './api-permapeople.controller';
import { ApiPermapeopleService } from '../api-permapeople/api-permapeople.service';
import { NotFoundException } from '@nestjs/common';
import { ExternalPlantDTO } from 'src/plant/dto/external-plant.dto';

describe('ApiPermaPeopleController', () => {
  let controller: ApiPermaPeopleController;
  let service: ApiPermapeopleService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ApiPermaPeopleController],
      providers: [
        {
          provide: ApiPermapeopleService,
          useValue: {
            getPlantById: jest.fn(),
            searchExternalPlants: jest.fn(),
            fetchExternalPlants: jest.fn(),
          },
        },
      ],
    }).compile();

    controller = module.get<ApiPermaPeopleController>(ApiPermaPeopleController);
    service = module.get<ApiPermapeopleService>(ApiPermapeopleService);
  });

  describe('findPlantById', () => {
    it('should return a plant if found', async () => {
      const plantId = 1;
      const plant: ExternalPlantDTO = {
        id: 0,
        name: '',
        slug: '',
        description: '',
        created_at: '',
        updated_at: '',
        scientific_name: '',
        parent_id: 0,
        adopter_id: 0,
        version: 0,
        type: '',
        link: '',
        data: [],
        images: {
          thumb: '',
          title: '',
        },
      };
      jest.spyOn(service, 'getPlantById').mockResolvedValue(plant);

      expect(await controller.findPlantById(plantId)).toBe(plant);
    });

    it('should throw NotFoundException if plant not found', async () => {
      const plantId = 1;
      jest.spyOn(service, 'getPlantById').mockResolvedValue(null);

      await expect(controller.findPlantById(plantId)).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
