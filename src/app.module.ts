import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PlantModule } from './plant/plant.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'sqlite',
      database: '/database/plantarium.sqlite',
      autoLoadEntities: true,
      synchronize: true,
    }),
    PlantModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
