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
Object.defineProperty(exports, "__esModule", { value: true });
exports.PlantMapping = void 0;
const typeorm_1 = require("typeorm");
const plant_entity_1 = require("./plant.entity");
let PlantMapping = class PlantMapping {
};
exports.PlantMapping = PlantMapping;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], PlantMapping.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], PlantMapping.prototype, "localPlantId", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], PlantMapping.prototype, "externalPlantId", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)(),
    __metadata("design:type", Date)
], PlantMapping.prototype, "createdDate", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)(),
    __metadata("design:type", Date)
], PlantMapping.prototype, "updatedDate", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => plant_entity_1.Plant),
    (0, typeorm_1.JoinColumn)({ name: 'localPlantId' }),
    __metadata("design:type", plant_entity_1.Plant)
], PlantMapping.prototype, "plant", void 0);
exports.PlantMapping = PlantMapping = __decorate([
    (0, typeorm_1.Entity)('plant_mapping')
], PlantMapping);
//# sourceMappingURL=plant-mapping.entity.js.map