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
exports.PlantSyncService = void 0;
const common_1 = require("@nestjs/common");
const api_permapeople_service_1 = require("../api-permapeople/api-permapeople.service");
const plant_service_1 = require("./plant.service");
let PlantSyncService = class PlantSyncService {
    constructor(permaPeopleService, plantService) {
        this.permaPeopleService = permaPeopleService;
        this.plantService = plantService;
    }
    async syncPlants() {
        const importedPlants = await this.plantService.getImportedPlants();
        common_1.Logger.log('Getting imported plants');
        const syncTasks = importedPlants.map((plant) => this.syncSinglePlant(plant));
        return Promise.all(syncTasks);
    }
    async syncSinglePlant(plant) {
        try {
            const externalPlant = await this.permaPeopleService.getPlantById(plant.externalPlantId);
            common_1.Logger.log(`Searching for plant with ID ${plant.externalPlantId}`);
            const internalPlant = this.plantService.mapExternalToInternal(externalPlant);
            await this.plantService.update(plant.id, internalPlant);
            return internalPlant;
        }
        catch (error) {
            common_1.Logger.error(`Error syncing plant with ID ${plant.externalPlantId}: ${error}`);
            return null;
        }
    }
};
exports.PlantSyncService = PlantSyncService;
exports.PlantSyncService = PlantSyncService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [api_permapeople_service_1.ApiPermapeopleService,
        plant_service_1.PlantService])
], PlantSyncService);
//# sourceMappingURL=plant-sync.service.js.map