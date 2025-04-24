import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class CreateGardenNoteDTO {
  @ApiProperty({ description: 'The title of the note' })
  @IsNotEmpty()
  @IsString()
  title: string;

  @ApiProperty({ description: 'The note content' })
  @IsNotEmpty()
  @IsString()
  note: string;

  @ApiProperty({ description: 'The date of the note' })
  @IsNotEmpty()
  date: Date;
}
