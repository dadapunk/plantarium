import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TypeORMError } from 'typeorm';
import { Plant } from './entities/plant.entity';
import { PlantController } from './plant.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Plant])],
  controllers: [PlantController],
})
export class PlantModule {}
