// src/garden-notes/garden-note.controller.ts
import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { CreateGardenNoteDTO } from './dto/create-garden-note.dto';
import { GardenNoteService } from './garden-note.service';
import { GardenNote } from './entities/garden-note.entity';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('garden-notes')
@Controller('garden-notes')
export class GardenNoteController {
  constructor(private readonly service: GardenNoteService) {}

  @Post()
  async create(@Body() createGardenNoteDTO: CreateGardenNoteDTO): Promise<GardenNote> {
    return this.service.create(createGardenNoteDTO);
  }

  @Get()
  async findAll(): Promise<GardenNote[]> {
    return this.service.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<GardenNote> {
    return this.service.findOne(+id);
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<void> {
    return this.service.remove(+id);
  }

  @Put(':id')
  async update(@Param('id') id: string, @Body() updateGardenNoteDTO: CreateGardenNoteDTO): Promise<GardenNote> {
    return this.service.update(+id, updateGardenNoteDTO);
  }
}