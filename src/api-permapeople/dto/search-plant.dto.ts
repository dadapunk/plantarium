import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class SearchPlantsDTO {
  @ApiProperty({ description: 'The search query for plants' })
  @IsNotEmpty()
  @IsString()
  query: string;
}
