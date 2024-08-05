import { Entity, Column, PrimaryGeneratedColumn, ManyToOne } from 'typeorm';
import { Plot } from '../../plot/entities/plot.entity';
@Entity()
export class Plant {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  age: number;

  @Column()
  species: string;

  @Column()
  family: string;

  @Column()
  leafShape: string;

  @Column({
    type: 'date',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
  })
  plantingDate: Date;

  @ManyToOne(() => Plot, (plot) => plot.plants, { nullable: true })
  plot: Plot;
}
