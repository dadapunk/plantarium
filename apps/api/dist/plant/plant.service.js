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
exports.PlantService = void 0;
const common_1 = require("@nestjs/common");
const plant_entity_1 = require("./entities/plant.entity");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const plot_service_1 = require("../plot/plot.service");
const plant_mapping_entity_1 = require("./entities/plant-mapping.entity");
let PlantService = class PlantService {
    constructor(plantRepository, plotService, plantMappingRepository) {
        this.plantRepository = plantRepository;
        this.plotService = plotService;
        this.plantMappingRepository = plantMappingRepository;
    }
    async create(createPlantDTO) {
        const plant = this.plantRepository.create(createPlantDTO);
        return this.plantRepository.save(plant);
    }
    async findAll() {
        return this.plantRepository.find();
    }
    async findOne(id) {
        return this.plantRepository.findOne({ where: { id } });
    }
    async update(id, updatePlantDTO) {
        const plant = await this.plantRepository.findOne({ where: { id } });
        if (!plant) {
            throw new common_1.NotFoundException(`Plant with ID ${id} not found`);
        }
        if (updatePlantDTO.plotId) {
            const plot = await this.plotService.findOne(updatePlantDTO.plotId);
            if (!plot) {
                throw new common_1.NotFoundException(`Plot with ID ${updatePlantDTO.plotId} not found`);
            }
            plant.plot = plot;
        }
        const updatedPlant = this.plantRepository.merge(plant, updatePlantDTO);
        return this.plantRepository.save(updatedPlant);
    }
    async addPlantToPlot(id, plotId, updatePlantDTO) {
        const plant = await this.plantRepository.findOne({ where: { id } });
        if (!plant) {
            throw new common_1.NotFoundException(`Plant with ID ${id} not found`);
        }
        const plot = await this.plotService.findOne(plotId);
        if (!plot) {
            throw new common_1.NotFoundException(`Plot with ID ${plotId} not found`);
        }
        plant.plot = plot;
        return this.plantRepository.save(plant);
    }
    async remove(id) {
        const plant = await this.plantRepository.findOne({ where: { id } });
        if (!plant) {
            throw new common_1.NotFoundException(`Plant with ID ${id} not found`);
        }
        await this.plantRepository.remove(plant);
    }
    async insertPlantMapping(plantId, externalId) {
        const plantMapping = new plant_mapping_entity_1.PlantMapping();
        plantMapping.localPlantId = plantId;
        plantMapping.externalPlantId = externalId;
        await this.plantMappingRepository.save(plantMapping);
    }
    async getImportedPlants() {
        const plantMappings = await this.plantMappingRepository.find();
        const plantIds = plantMappings.map((mapping) => mapping.localPlantId);
        const importedPlants = await this.plantRepository.findByIds(plantIds);
        return importedPlants.map((plant) => {
            const mapping = plantMappings.find((mapping) => mapping.localPlantId === plant.id);
            return {
                ...plant,
                externalPlantId: mapping ? mapping.externalPlantId : null,
            };
        });
    }
    mapExternalToInternal(externalPlant) {
        return {
            name: externalPlant.name,
            age: this.calculatePlantAge(externalPlant.created_at),
            species: externalPlant.scientific_name,
            family: this.getDataValue(externalPlant.data, 'Family'),
            leafShape: this.getDataValue(externalPlant.data, 'Leaf shape') || 'Unknown',
            plantingDate: new Date(externalPlant.created_at),
        };
    }
    getDataValue(data, key) {
        const item = data.find((d) => d.key === key);
        return item ? item.value : 'Unknown';
    }
    calculatePlantAge(createdAt) {
        const createdDate = new Date(createdAt);
        const currentDate = new Date();
        const ageInMilliseconds = currentDate.getTime() - createdDate.getTime();
        return Math.floor(ageInMilliseconds / (1000 * 60 * 60 * 24 * 365));
    }
};
exports.PlantService = PlantService;
exports.PlantService = PlantService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(plant_entity_1.Plant)),
    __param(2, (0, typeorm_1.InjectRepository)(plant_mapping_entity_1.PlantMapping)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        plot_service_1.PlotService,
        typeorm_2.Repository])
], PlantService);
//# sourceMappingURL=plant.service.js.map