import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Plant } from './entities/plant.entity';
import { PlantMapping } from './entities/plant-mapping.entity';
import { PlantController } from './plant.controller';
import { PlantService } from './plant.service';
import { PlotModule } from '../plot/plot.module';
import { ApiPermapeopleService } from 'src/api-permapeople/api-permapeople.service';
import { ConfigModule } from '@nestjs/config';
import { HttpModule } from '@nestjs/axios';
import { PlantSchedulerService } from './plant-scheduler.service';
import { PlantSyncService } from './plant-sync.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([Plant, PlantMapping]),
    PlotModule,
    ConfigModule,
    HttpModule,
  ],
  controllers: [PlantController],
  providers: [
    PlantService,
    ApiPermapeopleService,
    PlantSchedulerService,
    PlantController,
    PlantSyncService,
  ],
})
export class PlantModule {}
