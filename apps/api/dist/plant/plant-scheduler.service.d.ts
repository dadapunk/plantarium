import { PlantSyncService } from './plant-sync.service';
export declare class PlantSchedulerService {
    private readonly plantSyncService;
    constructor(plantSyncService: PlantSyncService);
    handleCron(): Promise<void>;
}
