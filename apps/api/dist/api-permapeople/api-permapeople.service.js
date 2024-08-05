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
var ApiPermapeopleService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.ApiPermapeopleService = void 0;
const common_1 = require("@nestjs/common");
const axios_1 = require("@nestjs/axios");
const config_1 = require("@nestjs/config");
const rxjs_1 = require("rxjs");
let ApiPermapeopleService = ApiPermapeopleService_1 = class ApiPermapeopleService {
    constructor(httpService, configService) {
        this.httpService = httpService;
        this.configService = configService;
        this.logger = new common_1.Logger(ApiPermapeopleService_1.name);
        this.apiKey = this.getConfigValue('PERMAPEOPLE_API_KEY');
        this.key = this.getConfigValue('PERMAPEOPLE_KEY');
        this.permaPeopleUrl = this.getConfigValue('PERMAPEOPLE_URL');
    }
    getConfigValue(key) {
        return this.configService.get(key);
    }
    createHeaders() {
        return {
            'x-permapeople-key-id': this.key,
            'x-permapeople-key-secret': this.apiKey,
        };
    }
    async fetchExternalPlants() {
        const headers = this.createHeaders();
        const params = {};
        try {
            const response = await (0, rxjs_1.firstValueFrom)(this.httpService.get(this.permaPeopleUrl + '/plants', {
                headers,
                params,
            }));
            return response.data;
        }
        catch (error) {
            this.logger.error('Error fetching external plants', error);
            throw error;
        }
    }
    async searchExternalPlants(query) {
        const headers = this.createHeaders();
        const body = { query };
        try {
            const response = await (0, rxjs_1.firstValueFrom)(this.httpService.post(this.permaPeopleUrl + '/search', body, {
                headers,
            }));
            return response.data;
        }
        catch (error) {
            this.logger.error('Error searching external plants', error);
            throw error;
        }
    }
    async getPlantById(id) {
        const headers = this.createHeaders();
        try {
            const response = await (0, rxjs_1.firstValueFrom)(this.httpService.get(this.permaPeopleUrl + `/plants/${id}`, {
                headers,
            }));
            return response.data;
        }
        catch (error) {
            this.logger.error('Error fetching external plants', error);
            throw error;
        }
    }
};
exports.ApiPermapeopleService = ApiPermapeopleService;
exports.ApiPermapeopleService = ApiPermapeopleService = ApiPermapeopleService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [axios_1.HttpService,
        config_1.ConfigService])
], ApiPermapeopleService);
//# sourceMappingURL=api-permapeople.service.js.map