import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';
import { Plant } from '../../plant/entities/plant.entity';

@Entity()
export class Plot {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  length: number;

  @Column()
  width: number;

  @Column()
  location: string;

  @OneToMany(() => Plant, (plant) => plant.plot, { nullable: true })
  plants: Plant[];

  // Add a getter for the calculated area
  get area(): number {
    return this.length * this.width;
  }
}
