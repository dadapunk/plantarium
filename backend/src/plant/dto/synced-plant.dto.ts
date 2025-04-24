import { Plant } from '../entities/plant.entity';

export class SyncedPlantDTO extends Plant {
  externalPlantId: number;
}
