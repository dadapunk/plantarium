// src/garden-notes/garden-note.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateGardenNoteDTO } from './dto/create-garden-note.dto';
import { GardenNote } from './entities/garden-note.entity';
import { promises as fs } from 'fs';
import { join, basename } from 'path';
import * as chokidar from 'chokidar';

@Injectable()
export class GardenNoteService {
  private watcher: chokidar.FSWatcher;

  constructor(
    @InjectRepository(GardenNote)
    private gardenNoteRepository: Repository<GardenNote>,
  ) {
    this.setupWatcher();
  }

  private setupWatcher() {
    const notesDir = join(__dirname, '..', '..', 'garden notes');
    this.watcher = chokidar.watch(notesDir, {
      persistent: true,
    });

    this.watcher.on('change', async (path) => {
      console.log(`File ${path} has been changed`);

      const title = basename(path, '.md'); // Use 'basename' to extract the title
      //console.log(`Extracted title: ${title}`);

      const newContent = await fs.readFile(path, 'utf-8');
      //console.log(`New content: ${newContent}`);

      const note = await this.gardenNoteRepository.findOne({
        where: { title: title },
      });
      //console.log(`Found note: ${note}`);

      if (note && note.note !== newContent) {
        note.note = newContent;
        await this.gardenNoteRepository.save(note);
        console.log(`Note ${title} has been updated`);
      } else {
        console.log(`No update needed for note ${title}`);
      }
    });
  }

  async syncNotes(): Promise<void> {
    const notes = await this.gardenNoteRepository.find();
    for (const note of notes) {
      const filePath = join(
        __dirname,
        '..',
        '..',
        'garden notes',
        `${note.title}.md`,
      );
      const fileContent = await fs.readFile(filePath, 'utf-8');
      if (note.note !== fileContent) {
        note.note = fileContent;
        await this.gardenNoteRepository.save(note);
      }
    }
  }
  async findAll(): Promise<GardenNote[]> {
    return this.gardenNoteRepository.find();
  }
  async create(createGardenNoteDTO: CreateGardenNoteDTO): Promise<GardenNote> {
    const gardenNote = this.gardenNoteRepository.create(createGardenNoteDTO);
    const savedGardenNote = await this.gardenNoteRepository.save(gardenNote);

    // Create a .md file with the note's content
    const mdContent = `# ${savedGardenNote.title}\n\n${savedGardenNote.note}`;
    const filePath = join(
      __dirname,
      '..',
      '..',
      'garden notes',
      `${savedGardenNote.title}.md`,
    );
    await fs.writeFile(filePath, mdContent);

    return savedGardenNote;
  }
  // Return the selected garden note
  async findOne(id: number): Promise<GardenNote> {
    const gardenNote = await this.gardenNoteRepository.findOne({
      where: { id: id },
    });
    if (!gardenNote) {
      throw new Error('Garden note not found');
    }
    return gardenNote;
  }

  async remove(id: number): Promise<void> {
    await this.gardenNoteRepository.delete(id);
  }

  async update(
    id: number,
    updateGardenNoteDTO: CreateGardenNoteDTO,
  ): Promise<GardenNote> {
    const gardenNote = await this.gardenNoteRepository.preload({
      id: id,
      ...updateGardenNoteDTO,
    });
    if (!gardenNote) {
      throw new Error('Garden note not found');
    }
    return this.gardenNoteRepository.save(gardenNote);
  }
}
