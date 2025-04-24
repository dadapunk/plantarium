// src/garden-notes/garden-notes.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GardenNoteController } from './garden-note.controller';
import { GardenNoteService } from './garden-note.service';
import { GardenNote } from './entities/garden-note.entity';

@Module({
  imports: [TypeOrmModule.forFeature([GardenNote])],
  controllers: [GardenNoteController],
  providers: [GardenNoteService],
})
export class GardenNoteModule {}