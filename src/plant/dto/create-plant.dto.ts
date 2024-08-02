import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString, IsNumber } from 'class-validator';

export class CreatePlantDTO {
  @ApiProperty({ description: 'The name of the plant' })
  @IsNotEmpty()
  @IsString()
  name: string;

  @ApiProperty({ description: 'The age of the plant' })
  @IsNotEmpty()
  @IsNumber()
  age: number;

  @ApiProperty({ description: 'The species of the plant' })
  @IsNotEmpty()
  @IsString()
  species: string;

  @ApiProperty({ description: 'The family of the plant' })
  @IsNotEmpty()
  @IsString()
  family: string;

  @ApiProperty({ description: 'The leaf shape of the plant' })
  @IsNotEmpty()
  @IsString()
  leafShape: string;

  @ApiProperty({ description: 'The planting date of the plant' })
  @IsNotEmpty()
  plantingDate: Date;

  @ApiProperty({ description: 'The plot ID where the plant is located' })
  @IsOptional()
  @IsNumber()
  plotId?: number;
}
