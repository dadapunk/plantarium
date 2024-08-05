"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const app_controller_1 = require("./app.controller");
const app_service_1 = require("./app.service");
const typeorm_1 = require("@nestjs/typeorm");
const plant_module_1 = require("./plant/plant.module");
const plot_module_1 = require("./plot/plot.module");
const garden_note_module_1 = require("./garden-notes/garden-note.module");
const axios_1 = require("@nestjs/axios");
const api_permapeople_module_1 = require("./api-permapeople/api-permapeople.module");
const config_1 = require("@nestjs/config");
const api_permapeople_service_1 = require("./api-permapeople/api-permapeople.service");
const schedule_1 = require("@nestjs/schedule");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forRoot({
                type: 'sqlite',
                database: './database/plantarium.sqlite',
                autoLoadEntities: true,
                synchronize: true,
                migrations: ['./migrations/*{.ts,.js}'],
                migrationsTableName: '_migrations',
                migrationsRun: true,
            }),
            plant_module_1.PlantModule,
            plot_module_1.PlotModule,
            garden_note_module_1.GardenNoteModule,
            api_permapeople_module_1.ApiPermapeopleModule,
            axios_1.HttpModule,
            config_1.ConfigModule.forRoot(),
            schedule_1.ScheduleModule.forRoot(),
        ],
        controllers: [app_controller_1.AppController],
        providers: [app_service_1.AppService, api_permapeople_service_1.ApiPermapeopleService],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map