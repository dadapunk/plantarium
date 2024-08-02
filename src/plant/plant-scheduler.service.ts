import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PlantSyncService } from './plant-sync.service';

@Injectable()
export class PlantSchedulerService {
  constructor(private readonly plantSyncService: PlantSyncService) {}

  //@Cron(CronExpression.EVERY_30_SECONDS)
  async handleCron() {
    Logger.log('Syncing plants', 'PlantSchedulerService');
    await this.plantSyncService.syncPlants();
  }
}
