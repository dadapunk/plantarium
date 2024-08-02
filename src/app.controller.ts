import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { ApiExcludeEndpoint } from '@nestjs/swagger';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  //Check if the app is running
  @Get()
  @ApiExcludeEndpoint()
  getHello(): string {
    return this.appService.getHello();
  }

  //Check if the API is running
  @Get('api')
  @ApiExcludeEndpoint()
  getApiInfo(): string {
    return 'Plantarium API';
  }
}
