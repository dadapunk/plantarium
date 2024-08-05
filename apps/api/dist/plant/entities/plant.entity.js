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
exports.Plant = void 0;
const typeorm_1 = require("typeorm");
const plot_entity_1 = require("../../plot/entities/plot.entity");
let Plant = class Plant {
};
exports.Plant = Plant;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Plant.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Plant.prototype, "name", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Plant.prototype, "age", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Plant.prototype, "species", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Plant.prototype, "family", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Plant.prototype, "leafShape", void 0);
__decorate([
    (0, typeorm_1.Column)({
        type: 'date',
        default: () => 'CURRENT_TIMESTAMP',
        onUpdate: 'CURRENT_TIMESTAMP',
    }),
    __metadata("design:type", Date)
], Plant.prototype, "plantingDate", void 0);
__decorate([
    (0, typeorm_1.ManyToOne)(() => plot_entity_1.Plot, (plot) => plot.plants, { nullable: true }),
    __metadata("design:type", plot_entity_1.Plot)
], Plant.prototype, "plot", void 0);
exports.Plant = Plant = __decorate([
    (0, typeorm_1.Entity)()
], Plant);
//# sourceMappingURL=plant.entity.js.map