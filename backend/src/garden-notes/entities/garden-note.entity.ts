// a garden note entity
import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';
@Entity()
export class GardenNote {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @Column()
  note: string;

  @Column({
    type: 'date',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
  })
  date: Date;
}
