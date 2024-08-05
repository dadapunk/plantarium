import { SyncedPlantDTO } from './dto/synced-plant.dto';
import { ApiPermapeopleService } from '../api-permapeople/api-permapeople.service';
import { PlantService } from './plant.service';
export declare class PlantSyncService {
    private readonly permaPeopleService;
    private readonly plantService;
    constructor(permaPeopleService: ApiPermapeopleService, plantService: PlantService);
    syncPlants(): Promise<SyncedPlantDTO[]>;
    private syncSinglePlant;
}
