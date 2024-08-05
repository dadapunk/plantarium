import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { ExternalPlantDTO } from 'src/plant/dto/external-plant.dto';
export declare class ApiPermapeopleService {
    private readonly httpService;
    private readonly configService;
    private readonly logger;
    private readonly apiKey;
    private readonly key;
    private readonly permaPeopleUrl;
    constructor(httpService: HttpService, configService: ConfigService);
    private getConfigValue;
    private createHeaders;
    fetchExternalPlants(): Promise<ExternalPlantDTO>;
    searchExternalPlants(query: string): Promise<ExternalPlantDTO>;
    getPlantById(id: number): Promise<ExternalPlantDTO>;
}
