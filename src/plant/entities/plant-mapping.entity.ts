import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Plant } from './plant.entity';

@Entity('plant_mapping')
export class PlantMapping {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  localPlantId: number;

  @Column()
  externalPlantId: number;

  @CreateDateColumn()
  createdDate: Date;

  @UpdateDateColumn()
  updatedDate: Date;

  @ManyToOne(() => Plant)
  @JoinColumn({ name: 'localPlantId' })
  plant: Plant;
}
