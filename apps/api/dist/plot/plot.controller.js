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
exports.PlotController = void 0;
const common_1 = require("@nestjs/common");
const create_plot_dto_1 = require("./dto/create-plot.dto");
const swagger_1 = require("@nestjs/swagger");
const plot_service_1 = require("./plot.service");
let PlotController = class PlotController {
    constructor(service) {
        this.service = service;
    }
    async findPlots() {
        return this.service.findAll();
    }
    async findPlotById(id) {
        const plot = await this.service.findOne(id);
        if (!plot) {
            throw new common_1.NotFoundException({
                message: `Plot with ID ${id} not found`,
                error: 'Not Found',
                statusCode: 404,
            });
        }
        return plot;
    }
    async createPlot(createPlotDTO) {
        return this.service.create(createPlotDTO);
    }
    async removePlot(id) {
        await this.service.remove(id);
    }
    async updatePlot(id, plot) {
        return this.service.update(id, plot);
    }
};
exports.PlotController = PlotController;
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get all plots' }),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Return all plots.' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], PlotController.prototype, "findPlots", null);
__decorate([
    (0, common_1.Get)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Get a plot by ID' }),
    (0, swagger_1.ApiResponse)({
        status: 200,
        description: 'Return the plot with the given ID.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Plot not found.' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], PlotController.prototype, "findPlotById", null);
__decorate([
    (0, common_1.Post)(),
    (0, swagger_1.ApiOperation)({ summary: 'Create a new plot' }),
    (0, swagger_1.ApiResponse)({
        status: 201,
        description: 'The plot has been successfully created.',
    }),
    (0, swagger_1.ApiResponse)({ status: 400, description: 'Invalid input.' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_plot_dto_1.CreatePlotDTO]),
    __metadata("design:returntype", Promise)
], PlotController.prototype, "createPlot", null);
__decorate([
    (0, common_1.Delete)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Delete a plot by ID' }),
    (0, swagger_1.ApiResponse)({
        status: 204,
        description: 'The plot has been successfully deleted.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Plot not found.' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], PlotController.prototype, "removePlot", null);
__decorate([
    (0, common_1.Put)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Update a plot by ID' }),
    (0, swagger_1.ApiResponse)({
        status: 200,
        description: 'The plot has been successfully updated.',
    }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Plot not found.' }),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, create_plot_dto_1.CreatePlotDTO]),
    __metadata("design:returntype", Promise)
], PlotController.prototype, "updatePlot", null);
exports.PlotController = PlotController = __decorate([
    (0, swagger_1.ApiTags)('plots'),
    (0, common_1.Controller)({ path: 'plot' }),
    __metadata("design:paramtypes", [plot_service_1.PlotService])
], PlotController);
//# sourceMappingURL=plot.controller.js.map