import { ApiPermapeopleService } from '../api-permapeople/api-permapeople.service';
import { SearchPlantsDTO } from './dto/search-plant.dto';
import { ExternalPlantDTO } from 'src/plant/dto/external-plant.dto';
export declare class ApiPermaPeopleController {
    private readonly permaPeopleService;
    private readonly logger;
    constructor(permaPeopleService: ApiPermapeopleService);
    fetchExternalPlants(): Promise<any>;
    searchPlants(searchPlantsDTO: SearchPlantsDTO): Promise<any>;
    findPlantById(id: number): Promise<ExternalPlantDTO>;
}
