import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

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
}
