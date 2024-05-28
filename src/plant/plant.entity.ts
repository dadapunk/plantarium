import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

Entity();
export class Plant {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  description: string;

  @Column()
  imageUrl: string;

  @Column()
  stock: number;
}
