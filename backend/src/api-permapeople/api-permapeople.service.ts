import { Injectable, Logger } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { firstValueFrom } from 'rxjs';
import { ExternalPlantDTO } from 'src/plant/dto/external-plant.dto';

@Injectable()
export class ApiPermapeopleService {
  private readonly logger = new Logger(ApiPermapeopleService.name);
  private readonly apiKey: string;
  private readonly key: string;
  private readonly permaPeopleUrl: string;

  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
  ) {
    this.apiKey = this.getConfigValue('PERMAPEOPLE_API_KEY');
    this.key = this.getConfigValue('PERMAPEOPLE_KEY');
    this.permaPeopleUrl = this.getConfigValue('PERMAPEOPLE_URL');
  }
  private getConfigValue(key: string): string {
    return this.configService.get<string>(key);
  }

  private createHeaders(): Record<string, string> {
    return {
      'x-permapeople-key-id': this.key,
      'x-permapeople-key-secret': this.apiKey,
    };
  }

  async fetchExternalPlants(): Promise<ExternalPlantDTO> {
    const headers = this.createHeaders();
    const params: any = {};
    try {
      const response = await firstValueFrom(
        this.httpService.get(this.permaPeopleUrl + '/plants', {
          headers,
          params,
        }),
      );
      return response.data as ExternalPlantDTO;
    } catch (error) {
      this.logger.error('Error fetching external plants', error);
      throw error;
    }
  }
  // Search for specifics strings in plants
  async searchExternalPlants(query: string): Promise<ExternalPlantDTO> {
    const headers = this.createHeaders();
    const body = { query };
    try {
      const response = await firstValueFrom(
        this.httpService.post(this.permaPeopleUrl + '/search', body, {
          headers,
        }),
      );
      return response.data as ExternalPlantDTO;
    } catch (error) {
      this.logger.error('Error searching external plants', error);
      throw error;
    }
  }
  async getPlantById(id: number): Promise<ExternalPlantDTO> {
    const headers = this.createHeaders();
    try {
      const response = await firstValueFrom(
        this.httpService.get(this.permaPeopleUrl + `/plants/${id}`, {
          headers,
        }),
      );
      return response.data as ExternalPlantDTO;
    } catch (error) {
      this.logger.error('Error fetching external plants', error);
      throw error;
    }
  }
}
