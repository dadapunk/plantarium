import { ApiProperty } from '@nestjs/swagger';

export class CreatePlotDTO {
  @ApiProperty({ description: 'The name of the plot' })
  name: string;

  @ApiProperty({ description: 'The length of the plot' })
  length: number;

  @ApiProperty({ description: 'The width of the plot' })
  width: number;

  @ApiProperty({ description: 'The location of the plot' })
  location: string;
}
