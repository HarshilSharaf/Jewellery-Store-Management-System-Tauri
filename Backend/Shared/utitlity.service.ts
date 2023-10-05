import { convertFileSrc } from "@tauri-apps/api/tauri";
import { relaunch } from '@tauri-apps/api/process';
import { Injectable } from '@angular/core';
import { UtilityServiceInterface } from "client/app/interfaces/Shared/utility-service-interface";

@Injectable({
  providedIn: 'root'
})

export class UtilityService implements UtilityServiceInterface {
    
    constructor() {}

    getFilePath(imagePath: string) {
        return convertFileSrc(imagePath)
    }

    async relaunch() {
        await relaunch()
    }
}