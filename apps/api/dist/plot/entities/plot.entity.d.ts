import { Plant } from '../../plant/entities/plant.entity';
export declare class Plot {
    id: number;
    name: string;
    length: number;
    width: number;
    location: string;
    plants: Plant[];
    get area(): number;
}
