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
exports.CreatePlantDTO = void 0;
const swagger_1 = require("@nestjs/swagger");
const class_validator_1 = require("class-validator");
class CreatePlantDTO {
}
exports.CreatePlantDTO = CreatePlantDTO;
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'The name of the plant' }),
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], CreatePlantDTO.prototype, "name", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'The age of the plant' }),
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsNumber)(),
    __metadata("design:type", Number)
], CreatePlantDTO.prototype, "age", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'The species of the plant' }),
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], CreatePlantDTO.prototype, "species", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'The family of the plant' }),
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], CreatePlantDTO.prototype, "family", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'The leaf shape of the plant' }),
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], CreatePlantDTO.prototype, "leafShape", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'The planting date of the plant' }),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Date)
], CreatePlantDTO.prototype, "plantingDate", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'The plot ID where the plant is located' }),
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsNumber)(),
    __metadata("design:type", Number)
], CreatePlantDTO.prototype, "plotId", void 0);
//# sourceMappingURL=create-plant.dto.js.map