"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GardenNoteService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const garden_note_entity_1 = require("./entities/garden-note.entity");
const fs_1 = require("fs");
const path_1 = require("path");
const chokidar = require("chokidar");
let GardenNoteService = class GardenNoteService {
    constructor(gardenNoteRepository) {
        this.gardenNoteRepository = gardenNoteRepository;
        this.setupWatcher();
    }
    setupWatcher() {
        const notesDir = (0, path_1.join)(__dirname, '..', '..', 'garden notes');
        this.watcher = chokidar.watch(notesDir, {
            persistent: true,
        });
        this.watcher.on('change', async (path) => {
            console.log(`File ${path} has been changed`);
            const title = (0, path_1.basename)(path, '.md');
            const newContent = await fs_1.promises.readFile(path, 'utf-8');
            const note = await this.gardenNoteRepository.findOne({
                where: { title: title },
            });
            if (note && note.note !== newContent) {
                note.note = newContent;
                await this.gardenNoteRepository.save(note);
                console.log(`Note ${title} has been updated`);
            }
            else {
                console.log(`No update needed for note ${title}`);
            }
        });
    }
    async syncNotes() {
        const notes = await this.gardenNoteRepository.find();
        for (const note of notes) {
            const filePath = (0, path_1.join)(__dirname, '..', '..', 'garden notes', `${note.title}.md`);
            const fileContent = await fs_1.promises.readFile(filePath, 'utf-8');
            if (note.note !== fileContent) {
                note.note = fileContent;
                await this.gardenNoteRepository.save(note);
            }
        }
    }
    async findAll() {
        return this.gardenNoteRepository.find();
    }
    async create(createGardenNoteDTO) {
        const gardenNote = this.gardenNoteRepository.create(createGardenNoteDTO);
        const savedGardenNote = await this.gardenNoteRepository.save(gardenNote);
        const mdContent = `# ${savedGardenNote.title}\n\n${savedGardenNote.note}`;
        const filePath = (0, path_1.join)(__dirname, '..', '..', 'garden notes', `${savedGardenNote.title}.md`);
        await fs_1.promises.writeFile(filePath, mdContent);
        return savedGardenNote;
    }
    async findOne(id) {
        const gardenNote = await this.gardenNoteRepository.findOne({
            where: { id: id },
        });
        if (!gardenNote) {
            throw new Error('Garden note not found');
        }
        return gardenNote;
    }
    async remove(id) {
        await this.gardenNoteRepository.delete(id);
    }
    async update(id, updateGardenNoteDTO) {
        const gardenNote = await this.gardenNoteRepository.preload({
            id: id,
            ...updateGardenNoteDTO,
        });
        if (!gardenNote) {
            throw new Error('Garden note not found');
        }
        return this.gardenNoteRepository.save(gardenNote);
    }
};
exports.GardenNoteService = GardenNoteService;
exports.GardenNoteService = GardenNoteService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(garden_note_entity_1.GardenNote)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], GardenNoteService);
//# sourceMappingURL=garden-note.service.js.map