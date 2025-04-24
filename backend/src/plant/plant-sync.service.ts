import { Injectable, Logger } from '@nestjs/common';
import { SyncedPlantDTO } from './dto/synced-plant.dto';
import { ApiPermapeopleService } from '../api-permapeople/api-permapeople.service';
import { CreatePlantDTO } from './dto/create-plant.dto';
import { PlantService } from './plant.service';

@Injectable()
export class PlantSyncService {
  constructor(
    private readonly permaPeopleService: ApiPermapeopleService,
    private readonly plantService: PlantService,
  ) {}

  // Sync plants with the external API.
  async syncPlants(): Promise<SyncedPlantDTO[]> {
    const importedPlants = await this.plantService.getImportedPlants();
    Logger.log('Getting imported plants');

    const syncTasks = importedPlants.map((plant) =>
      this.syncSinglePlant(plant),
    );
    return Promise.all(syncTasks);
  }

  private async syncSinglePlant(plant: SyncedPlantDTO): Promise<any> {
    try {
      const externalPlant = await this.permaPeopleService.getPlantById(
        plant.externalPlantId,
      );
      Logger.log(`Searching for plant with ID ${plant.externalPlantId}`);
      const internalPlant =
        this.plantService.mapExternalToInternal(externalPlant);
      await this.plantService.update(plant.id, internalPlant);
      return internalPlant;
    } catch (error) {
      Logger.error(
        `Error syncing plant with ID ${plant.externalPlantId}: ${error}`,
      );
      return null; // Or handle the error as appropriate
    }
  }
}
