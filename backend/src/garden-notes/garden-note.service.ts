// src/garden-notes/garden-note.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateGardenNoteDTO } from './dto/create-garden-note.dto';
import { GardenNote } from './entities/garden-note.entity';
import { promises as fs } from 'fs';
import { join, basename, dirname } from 'path';
import * as chokidar from 'chokidar';

@Injectable()
export class GardenNoteService {
  private watcher: chokidar.FSWatcher;
  private readonly logger = new Logger(GardenNoteService.name);

  constructor(
    @InjectRepository(GardenNote)
    private gardenNoteRepository: Repository<GardenNote>,
  ) {
    this.setupWatcher();
  }

  private setupWatcher() {
    const notesDir = join(__dirname, '..', '..', '..', 'garden notes');
    this.logger.log(`Setting up watcher for directory: ${notesDir}`);
    
    // Log the absolute path for debugging
    this.logger.log(`Absolute path resolved to: ${require('path').resolve(notesDir)}`);
    
    // Check if directory exists
    fs.access(notesDir).then(
      () => this.logger.log(`Directory exists: ${notesDir}`),
      (err) => this.logger.error(`Directory does not exist: ${notesDir}, Error: ${err.message}`)
    );

    this.watcher = chokidar.watch(notesDir, {
      persistent: true,
    });

    this.watcher.on('change', async (path) => {
      this.logger.log(`File ${path} has been changed`);

      const title = basename(path, '.md');
      this.logger.debug(`Extracted title: ${title}`);

      try {
        const newContent = await fs.readFile(path, 'utf-8');
        this.logger.debug(`Read new content (${newContent.length} chars)`);

        const note = await this.gardenNoteRepository.findOne({
          where: { title: title },
        });
        
        if (note) {
          this.logger.debug(`Found note with ID: ${note.id}`);
          
          if (note.note !== newContent) {
            note.note = newContent;
            await this.gardenNoteRepository.save(note);
            this.logger.log(`Note "${title}" (ID: ${note.id}) has been updated in database`);
          } else {
            this.logger.log(`No update needed for note "${title}" (ID: ${note.id})`);
          }
        } else {
          this.logger.warn(`No note found with title "${title}" in database`);
        }
      } catch (error) {
        this.logger.error(`Error processing file ${path}: ${error.message}`);
      }
    });
  }

  async syncNotes(): Promise<void> {
    const notes = await this.gardenNoteRepository.find();
    this.logger.log(`Syncing ${notes.length} notes from database to files`);
    
    // Group notes by title to detect duplicates
    const notesByTitle = new Map<string, GardenNote[]>();
    for (const note of notes) {
      if (!notesByTitle.has(note.title)) {
        notesByTitle.set(note.title, []);
      }
      notesByTitle.get(note.title)!.push(note);
    }
    
    for (const note of notes) {
      // Determine if we need to use ID in filename
      const notesWithSameTitle = notesByTitle.get(note.title) || [];
      const needsIdInFilename = notesWithSameTitle.length > 1;
      
      const filename = needsIdInFilename ? `${note.title}_${note.id}` : note.title;
      
      const filePath = join(
        __dirname,
        '..',
        '..',
        '..',
        'garden notes',
        `${filename}.md`,
      );
      this.logger.debug(`Syncing note "${note.title}" (ID: ${note.id}) to file: ${filePath}`);
      
      try {
        // Check if file exists
        try {
          await fs.access(filePath);
          const fileContent = await fs.readFile(filePath, 'utf-8');
          
          if (note.note !== fileContent) {
            note.note = fileContent;
            await this.gardenNoteRepository.save(note);
            this.logger.log(`Updated note "${note.title}" in database from file`);
          } else {
            this.logger.debug(`No sync needed for note "${note.title}"`);
          }
        } catch (error) {
          // File doesn't exist, create it
          this.logger.warn(`File for note "${note.title}" doesn't exist, creating it at: ${filePath}`);
          const dirPath = dirname(filePath);
          
          try {
            await fs.access(dirPath);
          } catch (err) {
            this.logger.warn(`Directory doesn't exist, creating: ${dirPath}`);
            await fs.mkdir(dirPath, { recursive: true });
          }
          
          const mdContent = `# ${note.title}\n\n${note.note}`;
          await fs.writeFile(filePath, mdContent);
          this.logger.log(`Created file for note "${note.title}" at: ${filePath}`);
        }
      } catch (error) {
        this.logger.error(`Error syncing note "${note.title}": ${error.message}`);
      }
    }
  }
  
  async findAll(): Promise<GardenNote[]> {
    const notes = await this.gardenNoteRepository.find();
    this.logger.debug(`Found ${notes.length} notes in database`);
    return notes;
  }
  
  async create(createGardenNoteDTO: CreateGardenNoteDTO): Promise<GardenNote> {
    this.logger.log(`Creating new garden note with title: "${createGardenNoteDTO.title}"`);
    
    const gardenNote = this.gardenNoteRepository.create(createGardenNoteDTO);
    const savedGardenNote = await this.gardenNoteRepository.save(gardenNote);
    this.logger.log(`Saved garden note to database with ID: ${savedGardenNote.id}`);

    // Create a .md file with the note's content
    const notesDir = join(__dirname, '..', '..', '..', 'garden notes');
    
    // Check if a note with same title already exists in the db
    const existingNotes = await this.gardenNoteRepository.find({
      where: { title: savedGardenNote.title },
    });
    
    // If multiple notes with the same title, append ID to filename
    let filename = savedGardenNote.title;
    if (existingNotes.length > 1) {
      filename = `${savedGardenNote.title}_${savedGardenNote.id}`;
      this.logger.log(`Found duplicate title, using "${filename}" as filename to avoid overwrites`);
    }
    
    const filePath = join(notesDir, `${filename}.md`);
    this.logger.log(`Creating markdown file at: ${filePath}`);

    try {
      // Ensure directory exists
      try {
        await fs.access(notesDir);
      } catch (err) {
        this.logger.warn(`Garden notes directory doesn't exist, creating: ${notesDir}`);
        await fs.mkdir(notesDir, { recursive: true });
      }
      
      const mdContent = `# ${savedGardenNote.title}\n\n${savedGardenNote.note}`;
      await fs.writeFile(filePath, mdContent);
      this.logger.log(`Successfully wrote markdown file for note: "${savedGardenNote.title}"`);
    } catch (error) {
      this.logger.error(`Failed to write markdown file: ${error.message}`);
      // Continue anyway since the database record was created
    }

    return savedGardenNote;
  }
  
  // Return the selected garden note
  async findOne(id: number): Promise<GardenNote> {
    this.logger.debug(`Finding garden note with ID: ${id}`);
    
    const gardenNote = await this.gardenNoteRepository.findOne({
      where: { id: id },
    });
    
    if (!gardenNote) {
      this.logger.warn(`Garden note with ID ${id} not found`);
      throw new Error('Garden note not found');
    }
    
    return gardenNote;
  }

  async remove(id: number): Promise<void> {
    this.logger.log(`Removing garden note with ID: ${id}`);
    
    // Find the note first to get the title for file deletion
    const note = await this.gardenNoteRepository.findOne({
      where: { id },
    });
    
    if (note) {
      // Delete from database
      await this.gardenNoteRepository.delete(id);
      this.logger.log(`Deleted note with ID ${id} from database`);
      
      // Delete the markdown file if it exists
      const filePath = join(__dirname, '..', '..', '..', 'garden notes', `${note.title}.md`);
      
      try {
        await fs.access(filePath);
        await fs.unlink(filePath);
        this.logger.log(`Deleted markdown file: ${filePath}`);
      } catch (error) {
        this.logger.warn(`Could not delete markdown file ${filePath}: ${error.message}`);
      }
    } else {
      this.logger.warn(`Attempted to delete non-existent note with ID: ${id}`);
    }
  }

  async update(
    id: number,
    updateGardenNoteDTO: CreateGardenNoteDTO,
  ): Promise<GardenNote> {
    this.logger.log(`Updating garden note with ID: ${id}`);
    this.logger.debug(`Update data: ${JSON.stringify(updateGardenNoteDTO)}`);
    
    // Get the old note to compare titles
    const oldNote = await this.gardenNoteRepository.findOne({
      where: { id },
    });
    
    if (!oldNote) {
      this.logger.warn(`Garden note with ID ${id} not found for update`);
      throw new Error('Garden note not found');
    }
    
    const oldTitle = oldNote.title;
    const newTitle = updateGardenNoteDTO.title;
    
    // Update in database
    const gardenNote = await this.gardenNoteRepository.preload({
      id: id,
      ...updateGardenNoteDTO,
    });
    
    if (!gardenNote) {
      this.logger.warn(`Failed to preload garden note with ID ${id} for update`);
      throw new Error('Garden note not found');
    }
    
    const updatedNote = await this.gardenNoteRepository.save(gardenNote);
    this.logger.log(`Updated note in database with ID: ${updatedNote.id}`);
    
    // Handle markdown file update
    const notesDir = join(__dirname, '..', '..', '..', 'garden notes');
    
    // Check if multiple notes with the same title exist
    let oldFilename = oldTitle;
    let newFilename = newTitle;
    
    // If title didn't change, check if we need to use ID in filename
    if (oldTitle === newTitle) {
      const notesWithSameTitle = await this.gardenNoteRepository.find({
        where: { title: newTitle },
      });
      
      if (notesWithSameTitle.length > 1) {
        oldFilename = `${oldTitle}_${id}`;
        newFilename = `${newTitle}_${id}`;
        this.logger.log(`Found duplicate title, using "${newFilename}" as filename to avoid overwrites`);
      }
    } else {
      // Title changed, check if new title has duplicates
      const notesWithNewTitle = await this.gardenNoteRepository.find({
        where: { title: newTitle },
      });
      
      // Check if we need ID for old filename
      const notesWithOldTitle = await this.gardenNoteRepository.find({
        where: { title: oldTitle },
      });
      
      if (notesWithOldTitle.length > 1) {
        oldFilename = `${oldTitle}_${id}`;
      }
      
      if (notesWithNewTitle.length > 1) {
        newFilename = `${newTitle}_${id}`;
        this.logger.log(`Found duplicate title after rename, using "${newFilename}" as filename to avoid overwrites`);
      }
    }
    
    const oldFilePath = join(notesDir, `${oldFilename}.md`);
    const newFilePath = join(notesDir, `${newFilename}.md`);
    
    try {
      // Ensure directory exists
      try {
        await fs.access(notesDir);
      } catch (err) {
        this.logger.warn(`Garden notes directory doesn't exist, creating: ${notesDir}`);
        await fs.mkdir(notesDir, { recursive: true });
      }
      
      // If title changed, rename the file
      if (oldTitle !== newTitle || oldFilename !== newFilename) {
        this.logger.log(`Title changed from "${oldTitle}" to "${newTitle}", updating file name`);
        
        try {
          await fs.access(oldFilePath);
          // Delete the old file if title changed
          await fs.unlink(oldFilePath);
          this.logger.log(`Deleted old file: ${oldFilePath}`);
        } catch (error) {
          this.logger.warn(`Old file not found or could not be deleted: ${error.message}`);
        }
      }
      
      // Write the new/updated file
      const mdContent = `# ${newTitle}\n\n${updatedNote.note}`;
      await fs.writeFile(newFilePath, mdContent);
      this.logger.log(`Wrote updated markdown file: ${newFilePath}`);
    } catch (error) {
      this.logger.error(`Failed to update markdown file: ${error.message}`);
    }
    
    return updatedNote;
  }
}
