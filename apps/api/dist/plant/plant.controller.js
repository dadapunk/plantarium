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
exports.PlantController = void 0;
const common_1 = require("@nestjs/common");
const create_plant_dto_1 = require("./dto/create-plant.dto");
const swagger_1 = require("@nestjs/swagger");
const plant_service_1 = require("./plant.service");
const typeorm_1 = require("typeorm");
const api_permapeople_service_1 = require("../api-permapeople/api-permapeople.service");
const plant_sync_service_1 = require("./plant-sync.service");
const external_plant_dto_1 = require("./dto/external-plant.dto");
let PlantController = class PlantController {
    constructor(plantService, permaPeopleService, plantSyncService) {
        this.plantService = plantService;
        this.permaPeopleService = permaPeopleService;
        this.plantSyncService = plantSyncService;
    }
    async findPlants() {
        const plants = await this.plantService.findAll();
        if (plants.length === 0) {
            throw new common_1.NotFoundException({
                message: 'Plants not found',
                error: 'Not Found',
                statusCode: 404,
            });
        }
        return plants;
    }
    async findPlantById(id) {
        const plant = await this.plantService.findOne(id);
        if (!plant) {
            throw new common_1.NotFoundException({
                message: `Plant with ID ${id} not found`,
                error: 'Not Found',
                statusCode: 404,
            });
        }
        return plant;
    }
    async createPlant(createPlantDTO) {
        try {
            return this.plantService.create(createPlantDTO);
        }
        catch (error) {
            if (error instanceof typeorm_1.QueryFailedError &&
                error.message.includes('SQLITE_CONSTRAINT: FOREIGN KEY constraint failed')) {
                throw new common_1.BadRequestException('Plot not found');
            }
            throw error;
        }
    }
    async removePlant(id) {
        await this.plantService.remove(id);
    }
    async updatePlant(id, updatePlantDTO) {
        return await this.plantService.update(id, updatePlantDTO);
    }
    async movePlant(id, updatePlantDTO) {
        return await this.plantService.addPlantToPlot(id, updatePlantDTO.plotId, updatePlantDTO);
    }
    async importPlantFromExternalApi(id) {
        const externalPlantData = await this.permaPeopleService.getPlantById(id);
        const externalPlant = new external_plant_dto_1.ExternalPlantDTO(externalPlantData);
        const internalPlant = this.plantService.mapExternalToInternal(externalPlant);
        const createdPlant = await this.plantService.create(internalPlant);
        await this.plantService.insertPlantMapping(createdPlant.id, id);
        common_1.Logger.log(`Inserted plant mapping for plant ID ${createdPlant.id}`);
        common_1.Logger.log(`Imported plant with ID ${id}`);
        return createdPlant;
    }
    async syncPlants() {
        return this.plantSyncService.syncPlants();
    }
};
exports.PlantController = PlantController;
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get all plants' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Return all plants.' }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Plants not found.' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], PlantController.prototype, "findPlants", null);
__decorate([
    (0, common_1.Get)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Get a plant by ID' }),
    (0, swagger_1.ApiResponse)({
        status: 200,
        description: 'Return the plant with the given ID.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Plant not found.' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], PlantController.prototype, "findPlantById", null);
__decorate([
    (0, common_1.Post)(),
    (0, swagger_1.ApiOperation)({ summary: 'Create a new plant' }),
    (0, swagger_1.ApiResponse)({
        status: 201,
        description: 'The plant has been successfully created.',
    }),
    (0, swagger_1.ApiResponse)({ status: 400, description: 'Invalid input.' }),
    (0, common_1.UsePipes)(new common_1.ValidationPipe({ whitelist: true, forbidNonWhitelisted: true })),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_plant_dto_1.CreatePlantDTO]),
    __metadata("design:returntype", Promise)
], PlantController.prototype, "createPlant", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Delete a plant by ID' }),
    (0, swagger_1.ApiResponse)({
        status: 204,
        description: 'The plant has been successfully deleted.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Plant not found.' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], PlantController.prototype, "removePlant", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Update a plant by ID' }),
    (0, swagger_1.ApiResponse)({
        status: 200,
        description: 'The plant has been successfully updated.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Plant not found.' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, create_plant_dto_1.CreatePlantDTO]),
    __metadata("design:returntype", Promise)
], PlantController.prototype, "updatePlant", null);
__decorate([
    (0, common_1.Patch)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Move a plant to another plot' }),
    (0, swagger_1.ApiResponse)({
        status: 200,
        description: 'The plant has been successfully moved.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Plant not found.' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, create_plant_dto_1.CreatePlantDTO]),
    __metadata("design:returntype", Promise)
], PlantController.prototype, "movePlant", null);
__decorate([
    (0, common_1.Post)('import/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Import a plant from the external API' }),
    (0, swagger_1.ApiResponse)({
        status: 201,
        description: 'The plant has been successfully imported.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Plant not found in external API.' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], PlantController.prototype, "importPlantFromExternalApi", null);
__decorate([
    (0, common_1.Post)('sync'),
    (0, swagger_1.ApiOperation)({ summary: 'Sync plants with external API' }),
    (0, swagger_1.ApiResponse)({
        status: 200,
        description: 'The plants have been successfully synced.',
    }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], PlantController.prototype, "syncPlants", null);
exports.PlantController = PlantController = __decorate([
    (0, swagger_1.ApiTags)('plants'),
    (0, common_1.Controller)({ path: 'plant' }),
    __metadata("design:paramtypes", [plant_service_1.PlantService,
        api_permapeople_service_1.ApiPermapeopleService,
        plant_sync_service_1.PlantSyncService])
], PlantController);
//# sourceMappingURL=plant.controller.js.map