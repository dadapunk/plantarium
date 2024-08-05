import { CreatePlantDTO } from './dto/create-plant.dto';
import { PlantService } from './plant.service';
import { Plant } from './entities/plant.entity';
import { ApiPermapeopleService } from '../api-permapeople/api-permapeople.service';
import { SyncedPlantDTO } from './dto/synced-plant.dto';
import { PlantSyncService } from './plant-sync.service';
export declare class PlantController {
    private readonly plantService;
    private readonly permaPeopleService;
    private readonly plantSyncService;
    constructor(plantService: PlantService, permaPeopleService: ApiPermapeopleService, plantSyncService: PlantSyncService);
    findPlants(): Promise<Plant[]>;
    findPlantById(id: number): Promise<Plant>;
    createPlant(createPlantDTO: CreatePlantDTO): Promise<Plant>;
    removePlant(id: number): Promise<void>;
    updatePlant(id: number, updatePlantDTO: CreatePlantDTO): Promise<Plant>;
    movePlant(id: number, updatePlantDTO: CreatePlantDTO): Promise<Plant>;
    importPlantFromExternalApi(id: number): Promise<Plant>;
    syncPlants(): Promise<SyncedPlantDTO[]>;
}
