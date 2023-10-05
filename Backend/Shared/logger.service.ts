import { info, error } from 'tauri-plugin-log-api';
import { Injectable } from '@angular/core';
import { LoggerServiceInterface } from 'client/app/interfaces/Shared/logger-service-interface';

@Injectable({
  providedIn: 'root'
})
export class LoggerService implements LoggerServiceInterface{
  constructor() {}

  public LogInfo(infoString: string) {
    info(`[INFO FROM CLIENT] ${infoString}`);
  }

  public LogError(errorString: any ,errorFrom = '') {

    const errorObject = JSON.stringify(errorString)
    console.log({errorObject});
    
    if(errorFrom != '') {
      error(`[ERROR FROM CLIENT] ${errorFrom} threw an error: ${errorObject}`);
    }
    else {
      error(`[ERROR FROM CLIENT] ${errorObject}`);
    }
  }
}
