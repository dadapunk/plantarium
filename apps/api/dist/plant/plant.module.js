"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PlantModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const plant_entity_1 = require("./entities/plant.entity");
const plant_mapping_entity_1 = require("./entities/plant-mapping.entity");
const plant_controller_1 = require("./plant.controller");
const plant_service_1 = require("./plant.service");
const plot_module_1 = require("../plot/plot.module");
const api_permapeople_service_1 = require("../api-permapeople/api-permapeople.service");
const config_1 = require("@nestjs/config");
const axios_1 = require("@nestjs/axios");
const plant_scheduler_service_1 = require("./plant-scheduler.service");
const plant_sync_service_1 = require("./plant-sync.service");
let PlantModule = class PlantModule {
};
exports.PlantModule = PlantModule;
exports.PlantModule = PlantModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forFeature([plant_entity_1.Plant, plant_mapping_entity_1.PlantMapping]),
            plot_module_1.PlotModule,
            config_1.ConfigModule,
            axios_1.HttpModule,
        ],
        controllers: [plant_controller_1.PlantController],
        providers: [
            plant_service_1.PlantService,
            api_permapeople_service_1.ApiPermapeopleService,
            plant_scheduler_service_1.PlantSchedulerService,
            plant_controller_1.PlantController,
            plant_sync_service_1.PlantSyncService,
        ],
    })
], PlantModule);
//# sourceMappingURL=plant.module.js.map