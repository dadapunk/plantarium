// src/external/external.module.ts
import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { ConfigModule } from '@nestjs/config';
import { ApiPermaPeopleController } from './api-permapeople.controller';
import { ApiPermapeopleService } from './api-permapeople.service';

@Module({
  imports: [HttpModule, ConfigModule],
  controllers: [ApiPermaPeopleController],
  providers: [ApiPermapeopleService],
})
export class ApiPermapeopleModule {}
