import { SettingsModel } from 'client/app/modules/settings/models/settings-model';
import Database from "tauri-plugin-sql-api";
import { StoreService } from './store.service';
import { Injectable } from '@angular/core';
import Swal from 'sweetalert2';
import { Router } from '@angular/router';

@Injectable({
  providedIn: 'root'
})
export class DatabaseService {

  public dbConnection:any;
  private dbConnectionInfo!:SettingsModel
  constructor(private storeService:StoreService, private router: Router) { }

  initializeDbConnection():Promise<any> {
    return new Promise(async (resolve,reject) => {

      this.dbConnectionInfo = await this.storeService.get("currentDbInfo")
      if(this.dbConnectionInfo == null) {
        this.dbConnectionInfo = await this.storeService.get("defaultDbInfo")
      } 

      const dbURL = 'mysql://' +
        `${this.dbConnectionInfo.DATABASE_USERNAME}:${this.dbConnectionInfo.DATABASE_PASSWORD}` +
        `@${this.dbConnectionInfo.DATABASE_HOST}:${this.dbConnectionInfo.DATABASE_PORT}/` +
        this.dbConnectionInfo.DATABASE_NAME; 
      
        try {
          this.dbConnection = await Database.load(dbURL);
        } catch (error) {
          this.showErrorAndRedirectToSettingsPage(error);
        }
      
      
      resolve(this.dbConnection);
    })
  }

  showErrorAndRedirectToSettingsPage(error: any) {
    let timerInterval: any;
    Swal.fire({
      title: 'Could Not Connect To Database!',
      html: `<span class="text-danger"> Error: ${error} 
        <p class="text-warning my-2"> Redirecting to Settings Page...</p>
        </span>`,
      timer: 4000,
      timerProgressBar: true,
      allowEscapeKey : false,
      allowOutsideClick: false,
      didOpen: () => {
        Swal.showLoading();
        const b = Swal.getHtmlContainer()?.querySelector(
          'b'
        ) as HTMLElement;
        timerInterval = setInterval(() => {
          b.textContent = Swal.getTimerLeft()?.toString() ?? '000000';
        }, 100);
      },
      willClose: () => {
        clearInterval(timerInterval);
      },
    }).then((result) => {
      if (result.dismiss === Swal.DismissReason.timer) {
        this.router.navigate(['settings'], {
          state: {
            error: error,
          },
        });
      }
    });
  }
}
