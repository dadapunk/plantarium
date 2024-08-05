"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GardenNoteModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const garden_note_controller_1 = require("./garden-note.controller");
const garden_note_service_1 = require("./garden-note.service");
const garden_note_entity_1 = require("./entities/garden-note.entity");
let GardenNoteModule = class GardenNoteModule {
};
exports.GardenNoteModule = GardenNoteModule;
exports.GardenNoteModule = GardenNoteModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([garden_note_entity_1.GardenNote])],
        controllers: [garden_note_controller_1.GardenNoteController],
        providers: [garden_note_service_1.GardenNoteService],
    })
], GardenNoteModule);
//# sourceMappingURL=garden-note.module.js.map