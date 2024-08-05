import { Plot } from '../../plot/entities/plot.entity';
export declare class Plant {
    id: number;
    name: string;
    age: number;
    species: string;
    family: string;
    leafShape: string;
    plantingDate: Date;
    plot: Plot;
}
