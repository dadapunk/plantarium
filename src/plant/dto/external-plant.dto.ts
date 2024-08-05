import {
  IsNotEmpty,
  IsString,
  IsNumber,
  IsOptional,
  IsArray,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

export class ExternalPlantDTO {
  @IsNumber()
  @IsNotEmpty()
  id: number;

  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  slug: string;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsString()
  @IsNotEmpty()
  created_at: string;

  @IsString()
  @IsNotEmpty()
  updated_at: string;

  @IsString()
  @IsNotEmpty()
  scientific_name: string;

  @IsNumber()
  @IsOptional()
  parent_id: number | null;

  @IsNumber()
  @IsNotEmpty()
  adopter_id: number;

  @IsNumber()
  @IsNotEmpty()
  version: number;

  @IsString()
  @IsNotEmpty()
  type: string;

  @IsString()
  @IsNotEmpty()
  link: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => Object)
  data: Array<{ key: string; value: string }>;

  @ValidateNested()
  @Type(() => Object)
  images: { thumb: string; title: string };

  constructor(json: any) {
    this.id = json.id;
    this.name = json.name;
    this.slug = json.slug;
    this.description = json.description;
    this.created_at = json.created_at;
    this.updated_at = json.updated_at;
    this.scientific_name = json.scientific_name;
    this.parent_id = json.parent_id;
    this.adopter_id = json.adopter_id;
    this.version = json.version;
    this.type = json.type;
    this.link = json.link;
    this.data = json.data;
    this.images = json.images;
  }
}
