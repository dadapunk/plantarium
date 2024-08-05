import { CreateGardenNoteDTO } from './dto/create-garden-note.dto';
import { GardenNoteService } from './garden-note.service';
import { GardenNote } from './entities/garden-note.entity';
export declare class GardenNoteController {
    private readonly service;
    constructor(service: GardenNoteService);
    create(createGardenNoteDTO: CreateGardenNoteDTO): Promise<GardenNote>;
    findAll(): Promise<GardenNote[]>;
    findOne(id: string): Promise<GardenNote>;
    remove(id: string): Promise<void>;
    update(id: string, updateGardenNoteDTO: CreateGardenNoteDTO): Promise<GardenNote>;
}
