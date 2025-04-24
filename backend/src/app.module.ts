import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PlantModule } from './plant/plant.module';
import { PlotModule } from './plot/plot.module';
import { GardenNoteModule } from './garden-notes/garden-note.module';
import { HttpModule } from '@nestjs/axios';
import { ApiPermapeopleModule } from './api-permapeople/api-permapeople.module';
import { ConfigModule } from '@nestjs/config';
import { ApiPermapeopleService } from './api-permapeople/api-permapeople.service';
import { ScheduleModule } from '@nestjs/schedule';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'sqlite',
      database: './database/plantarium.sqlite',
      autoLoadEntities: true,
      synchronize: true,
      migrations: ['./migrations/*{.ts,.js}'],
      migrationsTableName: '_migrations',
      migrationsRun: true, // Auto-run migrations
    }),
    PlantModule,
    PlotModule,
    GardenNoteModule,
    ApiPermapeopleModule,
    HttpModule,
    ConfigModule.forRoot(),
    ScheduleModule.forRoot(),
  ],
  controllers: [AppController],
  providers: [AppService, ApiPermapeopleService],
})
export class AppModule {}
