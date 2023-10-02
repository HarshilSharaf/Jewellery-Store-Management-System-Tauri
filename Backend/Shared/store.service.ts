import { SettingsModel } from 'client/app/modules/settings/models/settings-model';
import { Store } from 'tauri-plugin-store-api';

import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class StoreService {

  private store:any

  constructor() { }

  initializeStore() :Promise<any> {
    return new Promise(async (resolve,reject) => {
      this.store = new Store('.settings.dat')
      const authData = await this.store.get("authData");
      const currentDate = new Date().getTime()
      const expirationDate = new Date(authData?.expiration).getTime()
      const dbInfo = await this.get('defaultDbInfo')
      if(!dbInfo || dbInfo == null) {
        // Add a fallback database to connect to
        const defaultDbInfo: SettingsModel = {
          DATABASE_NAME: 'JewelleryStore',
          DATABASE_USERNAME: 'sa',
          DATABASE_PASSWORD: '****PASSWORD****',
          DATABASE_PORT: 3306,
          DATABASE_HOST: 'localhost',
          LAST_UPDATED_ON: new Date().toUTCString(),
        };
        this.set('defaultDbInfo', defaultDbInfo);
      }

      //delete authData from store if it is expired
      if(authData && ( currentDate > expirationDate))
      {
        await this.store.delete('authData');
        await this.store.save();
      }
      resolve(this.store);
    })
  }

  get(key:string) {
    return this.store.get(key)
  }

  set(key:string, value:any) {
    return new Promise(async (resolve, reject) => {
      try {
        await this.store.set(key, value);
        await this.store.save()
        resolve(true)
      } catch (error) {
        reject(false)
      }
    })
  }

  delete(key:string) {
    return new Promise(async (resolve, reject) => {
      try {
        await this.store.delete(key);
        await this.store.save();
        resolve(true)
      } catch (error) {
        reject(false)
      }
    })
  }
}
