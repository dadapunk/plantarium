import { Repository } from 'typeorm';
import { CreateGardenNoteDTO } from './dto/create-garden-note.dto';
import { GardenNote } from './entities/garden-note.entity';
export declare class GardenNoteService {
    private gardenNoteRepository;
    private watcher;
    constructor(gardenNoteRepository: Repository<GardenNote>);
    private setupWatcher;
    syncNotes(): Promise<void>;
    findAll(): Promise<GardenNote[]>;
    create(createGardenNoteDTO: CreateGardenNoteDTO): Promise<GardenNote>;
    findOne(id: number): Promise<GardenNote>;
    remove(id: number): Promise<void>;
    update(id: number, updateGardenNoteDTO: CreateGardenNoteDTO): Promise<GardenNote>;
}
