import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { Plant } from './entities/plant.entity';
import { CreatePlantDTO } from './dto/create-plant.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PlotService } from '../plot/plot.service';
import { PlantMapping } from './entities/plant-mapping.entity';
import { SyncedPlantDTO } from './dto/synced-plant.dto';
import { ExternalPlantDTO } from './dto/external-plant.dto';

@Injectable()
export class PlantService {
  queryRunner: any;
  constructor(
    @InjectRepository(Plant)
    private plantRepository: Repository<Plant>,
    private plotService: PlotService,
    @InjectRepository(PlantMapping)
    private plantMappingRepository: Repository<PlantMapping>,
  ) {}

  async create(createPlantDTO: CreatePlantDTO): Promise<Plant> {
    const plant = this.plantRepository.create(createPlantDTO);
    return this.plantRepository.save(plant);
  }

  async findAll(): Promise<Plant[]> {
    return this.plantRepository.find();
  }

  async findOne(id: number): Promise<Plant> {
    return this.plantRepository.findOne({ where: { id } });
  }
  // Updates a plant in the database by its ID.
  // Throws a NotFoundException if the plant with the specified ID does not exist.
  async update(id: number, updatePlantDTO: CreatePlantDTO): Promise<Plant> {
    const plant = await this.plantRepository.findOne({ where: { id } });
    if (!plant) {
      throw new NotFoundException(`Plant with ID ${id} not found`);
    }

    if (updatePlantDTO.plotId) {
      const plot = await this.plotService.findOne(updatePlantDTO.plotId);
      if (!plot) {
        throw new NotFoundException(
          `Plot with ID ${updatePlantDTO.plotId} not found`,
        );
      }
      plant.plot = plot;
    }
    const updatedPlant = this.plantRepository.merge(plant, updatePlantDTO);
    return this.plantRepository.save(updatedPlant);
  }
  // Adds a plant to a specific plot and saves it to the database.
  // Throws a NotFoundException if the specified plot does not exist.
  async addPlantToPlot(
    id: number,
    plotId: number,
    updatePlantDTO: CreatePlantDTO,
  ): Promise<Plant> {
    const plant = await this.plantRepository.findOne({ where: { id } });
    if (!plant) {
      throw new NotFoundException(`Plant with ID ${id} not found`);
    }
    const plot = await this.plotService.findOne(plotId);
    if (!plot) {
      throw new NotFoundException(`Plot with ID ${plotId} not found`);
    }
    plant.plot = plot;
    return this.plantRepository.save(plant);
  }

  // Removes a plant from the database by its ID.
  // Throws a NotFoundException if the plant with the specified ID does not exist.
  //ToDo: Implement the remove method from PlantMappingRepository
  async remove(id: number): Promise<void> {
    const plant = await this.plantRepository.findOne({ where: { id } });
    if (!plant) {
      throw new NotFoundException(`Plant with ID ${id} not found`);
    }
    await this.plantRepository.remove(plant);
  }

  // Inserts a mapping between a local plant ID and an external plant ID into the plant_mapping table.
  // This is useful for keeping track of plant identifiers across different systems or databases.
  async insertPlantMapping(plantId: number, externalId: number): Promise<void> {
    const plantMapping = new PlantMapping();
    plantMapping.localPlantId = plantId;
    plantMapping.externalPlantId = externalId;
    // Insert plants ids to the plant_mapping table
    await this.plantMappingRepository.save(plantMapping);
  }
  // Collects all the plants id imported from the external API and returns the ids as an array of Plant objects.
  async getImportedPlants(): Promise<SyncedPlantDTO[]> {
    const plantMappings = await this.plantMappingRepository.find();
    const plantIds = plantMappings.map((mapping) => mapping.localPlantId);
    const importedPlants = await this.plantRepository.findByIds(plantIds);
    return importedPlants.map((plant) => {
      const mapping = plantMappings.find(
        (mapping) => mapping.localPlantId === plant.id,
      );
      return {
        ...plant,
        externalPlantId: mapping ? mapping.externalPlantId : null,
      };
    });
  }
  mapExternalToInternal(externalPlant: ExternalPlantDTO): CreatePlantDTO {
    return {
      name: externalPlant.name,
      age: this.calculatePlantAge(externalPlant.created_at),
      species: externalPlant.scientific_name,
      family: this.getDataValue(externalPlant.data, 'Family'),
      leafShape:
        this.getDataValue(externalPlant.data, 'Leaf shape') || 'Unknown',
      plantingDate: new Date(externalPlant.created_at),
    };
  }

  private getDataValue(data: any[], key: string): string {
    const item = data.find((d) => d.key === key);
    return item ? item.value : 'Unknown';
  }

  private calculatePlantAge(createdAt: string): number {
    const createdDate = new Date(createdAt);
    const currentDate = new Date();
    const ageInMilliseconds = currentDate.getTime() - createdDate.getTime();
    return Math.floor(ageInMilliseconds / (1000 * 60 * 60 * 24 * 365));
  }
}
