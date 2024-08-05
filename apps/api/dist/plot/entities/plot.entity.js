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
exports.Plot = void 0;
const typeorm_1 = require("typeorm");
const plant_entity_1 = require("../../plant/entities/plant.entity");
let Plot = class Plot {
    get area() {
        return this.length * this.width;
    }
};
exports.Plot = Plot;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Plot.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Plot.prototype, "name", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Plot.prototype, "length", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Plot.prototype, "width", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Plot.prototype, "location", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => plant_entity_1.Plant, (plant) => plant.plot, { nullable: true }),
    __metadata("design:type", Array)
], Plot.prototype, "plants", void 0);
exports.Plot = Plot = __decorate([
    (0, typeorm_1.Entity)()
], Plot);
//# sourceMappingURL=plot.entity.js.map