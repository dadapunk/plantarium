import { Repository } from 'typeorm';
import { CreatePlotDTO } from './dto/create-plot.dto';
import { Plot } from './entities/plot.entity';
export declare class PlotService {
    private plotRepository;
    constructor(plotRepository: Repository<Plot>);
    create(createPlotDTO: CreatePlotDTO): Promise<Plot>;
    findAll(): Promise<Plot[]>;
    findOne(id: number): Promise<Plot>;
    update(id: number, updatePlotDTO: CreatePlotDTO): Promise<Plot>;
    remove(id: number): Promise<void>;
}
