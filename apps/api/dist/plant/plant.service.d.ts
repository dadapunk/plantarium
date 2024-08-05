import { Plant } from './entities/plant.entity';
import { CreatePlantDTO } from './dto/create-plant.dto';
import { Repository } from 'typeorm';
import { PlotService } from '../plot/plot.service';
import { PlantMapping } from './entities/plant-mapping.entity';
import { SyncedPlantDTO } from './dto/synced-plant.dto';
import { ExternalPlantDTO } from './dto/external-plant.dto';
export declare class PlantService {
    private plantRepository;
    private plotService;
    private plantMappingRepository;
    queryRunner: any;
    constructor(plantRepository: Repository<Plant>, plotService: PlotService, plantMappingRepository: Repository<PlantMapping>);
    create(createPlantDTO: CreatePlantDTO): Promise<Plant>;
    findAll(): Promise<Plant[]>;
    findOne(id: number): Promise<Plant>;
    update(id: number, updatePlantDTO: CreatePlantDTO): Promise<Plant>;
    addPlantToPlot(id: number, plotId: number, updatePlantDTO: CreatePlantDTO): Promise<Plant>;
    remove(id: number): Promise<void>;
    insertPlantMapping(plantId: number, externalId: number): Promise<void>;
    getImportedPlants(): Promise<SyncedPlantDTO[]>;
    mapExternalToInternal(externalPlant: ExternalPlantDTO): CreatePlantDTO;
    private getDataValue;
    private calculatePlantAge;
}
