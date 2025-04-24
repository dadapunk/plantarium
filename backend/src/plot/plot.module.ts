import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Plot } from './entities/plot.entity';
import { PlotController } from './plot.controller';
import { PlotService } from './plot.service';

@Module({
  imports: [TypeOrmModule.forFeature([Plot])],
  controllers: [PlotController],
  providers: [PlotService],
  exports: [PlotService], // Ensure PlotService is exported
})
export class PlotModule {}
