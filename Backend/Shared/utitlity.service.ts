import { convertFileSrc } from "@tauri-apps/api/tauri";
import { relaunch } from '@tauri-apps/api/process';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})

export class UtilityService {
    
    constructor() {}

    getFilePath(imagePath: string) {
        return convertFileSrc(imagePath)
    }

    async relaunch() {
        await relaunch()
    }
}