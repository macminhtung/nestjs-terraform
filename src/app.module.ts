import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { TypeOrmModule } from '@nestjs/typeorm';

const { RDS_HOSTNAME, RDS_USERNAME, RDS_PASSWORD, RDS_DB_NAME } = process.env;

@Module({
  imports: [
    // TypeOrmModule.forRoot({
    //   type: 'postgres',
    //   host: RDS_HOSTNAME,
    //   port: 5432,
    //   username: RDS_USERNAME,
    //   password: RDS_PASSWORD,
    //   database: RDS_DB_NAME,
    //   entities: [],
    //   synchronize: true,
    // }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
