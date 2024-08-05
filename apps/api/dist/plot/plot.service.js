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
exports.PlotService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const plot_entity_1 = require("./entities/plot.entity");
let PlotService = class PlotService {
    constructor(plotRepository) {
        this.plotRepository = plotRepository;
    }
    async create(createPlotDTO) {
        const plot = this.plotRepository.create(createPlotDTO);
        return this.plotRepository.save(plot);
    }
    async findAll() {
        return this.plotRepository.find({ relations: ['plants'] });
    }
    async findOne(id) {
        return this.plotRepository.findOne({ where: { id } });
    }
    async update(id, updatePlotDTO) {
        const plot = await this.plotRepository.findOne({ where: { id } });
        if (!plot) {
            throw new common_1.NotFoundException(`Plot with ID ${id} not found`);
        }
        const updatedPlot = this.plotRepository.merge(plot, updatePlotDTO);
        return this.plotRepository.save(updatedPlot);
    }
    async remove(id) {
        const plot = await this.plotRepository.findOne({ where: { id } });
        if (!plot) {
            throw new common_1.NotFoundException(`Plot with ID ${id} not found`);
        }
        await this.plotRepository.remove(plot);
    }
};
exports.PlotService = PlotService;
exports.PlotService = PlotService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(plot_entity_1.Plot)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], PlotService);
//# sourceMappingURL=plot.service.js.map