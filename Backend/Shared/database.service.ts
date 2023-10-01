import { SettingsModel } from 'client/app/modules/settings/models/settings-model';
import Database from "tauri-plugin-sql-api";
import { StoreService } from './store.service';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class DatabaseService {

  public dbConnection:any;
  private dbConnectionInfo!:SettingsModel
  constructor(private storeService:StoreService) { }

  initializeDbConnection():Promise<any> {
    return new Promise(async (resolve,reject) => {

      this.dbConnectionInfo = await this.storeService.store.get("currentDbInfo")
      if(this.dbConnectionInfo == null) {
        this.dbConnectionInfo = await this.storeService.store.get("defaultDbInfo")
      } 

      const dbURL = 'mysql://' +
        `${this.dbConnectionInfo.DATABASE_USERNAME}:${this.dbConnectionInfo.DATABASE_PASSWORD}` +
        `@${this.dbConnectionInfo.DATABASE_HOST}:${this.dbConnectionInfo.DATABASE_PORT}/` +
        this.dbConnectionInfo.DATABASE_NAME; 
      
        try {
          this.dbConnection = await Database.load(dbURL);
        } catch (error) {
          let timerInterval: any;
          throw error
        }
      
      
      resolve(this.dbConnection);
    })
  }
}
