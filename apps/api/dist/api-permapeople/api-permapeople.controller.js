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
var ApiPermaPeopleController_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.ApiPermaPeopleController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const api_permapeople_service_1 = require("../api-permapeople/api-permapeople.service");
const search_plant_dto_1 = require("./dto/search-plant.dto");
let ApiPermaPeopleController = ApiPermaPeopleController_1 = class ApiPermaPeopleController {
    constructor(permaPeopleService) {
        this.permaPeopleService = permaPeopleService;
        this.logger = new common_1.Logger(ApiPermaPeopleController_1.name);
    }
    async fetchExternalPlants() {
        try {
            const response = await this.permaPeopleService.fetchExternalPlants();
            return response;
        }
        catch (error) {
            throw new common_1.NotFoundException('Could not fetch external plants');
        }
    }
    async searchPlants(searchPlantsDTO) {
        try {
            const response = await this.permaPeopleService.searchExternalPlants(searchPlantsDTO.query);
            return response;
        }
        catch (error) {
            throw new common_1.NotFoundException('Could not find plants');
        }
    }
    async findPlantById(id) {
        const plant = await this.permaPeopleService.getPlantById(id);
        if (!plant) {
            throw new common_1.NotFoundException({
                message: `Plant with ID ${id} not found`,
                error: 'Not Found',
                statusCode: 404,
            });
        }
        return plant;
    }
};
exports.ApiPermaPeopleController = ApiPermaPeopleController;
__decorate([
    (0, common_1.Get)('plants'),
    (0, swagger_1.ApiOperation)({ summary: 'Fetch external plants' }),
    (0, swagger_1.ApiResponse)({
        status: 200,
        description: 'Return external plants.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Could not fetch external plants.' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], ApiPermaPeopleController.prototype, "fetchExternalPlants", null);
__decorate([
    (0, common_1.Post)('search'),
    (0, swagger_1.ApiOperation)({ summary: 'Search plants' }),
    (0, swagger_1.ApiResponse)({
        status: 200,
        description: 'Return searched plants.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Could not find plants.' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [search_plant_dto_1.SearchPlantsDTO]),
    __metadata("design:returntype", Promise)
], ApiPermaPeopleController.prototype, "searchPlants", null);
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
], ApiPermaPeopleController.prototype, "findPlantById", null);
exports.ApiPermaPeopleController = ApiPermaPeopleController = ApiPermaPeopleController_1 = __decorate([
    (0, swagger_1.ApiTags)('API PermaPeople'),
    (0, common_1.Controller)('external'),
    __metadata("design:paramtypes", [api_permapeople_service_1.ApiPermapeopleService])
], ApiPermaPeopleController);
//# sourceMappingURL=api-permapeople.controller.js.map