import { CreatePlotDTO } from './dto/create-plot.dto';
import { PlotService } from './plot.service';
import { Plot } from './entities/plot.entity';
export declare class PlotController {
    private readonly service;
    constructor(service: PlotService);
    findPlots(): Promise<Plot[]>;
    findPlotById(id: number): Promise<Plot>;
    createPlot(createPlotDTO: CreatePlotDTO): Promise<Plot>;
    removePlot(id: number): Promise<void>;
    updatePlot(id: number, plot: CreatePlotDTO): Promise<Plot>;
}
