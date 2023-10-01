import * as tauriFS from '@tauri-apps/api/fs';
import { pictureDir } from '@tauri-apps/api/path';
import * as base64js from 'base64-js'
import { NgxImageCompressService } from 'ngx-image-compress';
import { DOC_ORIENTATION } from 'ngx-image-compress';
import { LoggerService } from './logger.service';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class FileSystemService {

  private imagesParentDirectoryForApp = 'Jewellery-Store-Management-System'
  private customerImagesDirectoryName = 'customerImages'
  public customerImagesDir = ''
  private productImagesDirectoryName = 'productImages'
  public productImagesDir = ''
  public userImagesDir = ''
  public userImagesDirectoryName = 'userImages'

  constructor(
    // private http: HttpClient,
    private imageCompressService: NgxImageCompressService,
    private loggerService: LoggerService
  ) {
    // In tauri.conf.json need to add path like this so that it can access the $PITCURES folder 
    // Refer following comment: https://github.com/tauri-apps/tauri/issues/5854#issuecomment-1364662094
    pictureDir().then((path)=> {
      this.customerImagesDir = path + `${this.imagesParentDirectoryForApp}\\` + this.customerImagesDirectoryName
      this.productImagesDir  = path + `${this.imagesParentDirectoryForApp}\\` + this.productImagesDirectoryName
      this.userImagesDir = path + `${this.imagesParentDirectoryForApp}\\` + this.userImagesDirectoryName
    })
  }

  async deleteFileIfExists(dirPath:string, fileName:string) {

    try {
      if (await tauriFS.exists(`${dirPath}\\${fileName}`)) {
        await tauriFS.removeFile(`${dirPath}\\${fileName}`);
      }
    } catch (error) {
      this.loggerService.LogError(`Error to delete file: ${fileName} from path: ${dirPath}`)
      throw error;
    }
  }

  async compressAndSaveImage(savePath:string, imageFile:any, funcName:string) {
    return new Promise<void>((resolve, reject) => {
      const fileReader = new FileReader()
      fileReader.onload = async (event:any) => {
        try {
          const result = await this.imageCompressService.compressFile(event.target.result, DOC_ORIENTATION.Default, 50, 60)
          await tauriFS.writeBinaryFile(savePath, base64js.toByteArray(result.split(',')[1]), {
            dir: tauriFS.BaseDirectory.Picture
          })
          console.log("File successfully saved:")
          resolve()
        } catch (error) {
          console.log(`Error occured from ${funcName}():`, error)
          reject(error)
        }
      }
      fileReader.readAsDataURL(imageFile)
    })
  }

  async getCustomerImageInBase64(imageFileName:string):Promise<string> {
    if (imageFileName) {
      try {
        const imageFile = await tauriFS.readBinaryFile(`${this.customerImagesDir}\\${imageFileName}`)

        // Convert the Uint8Array to Base64
        const base64String = base64js.fromByteArray(imageFile)


        const imageString = 'data:image/jpeg;base64,' + base64String

        return imageString
      }
      catch (error) {
        throw error
      }
    }
    else {
      return ''
      // return new Promise((resolve, reject) => {
      //   this.http.get('/assets/img/No-Image-Icon.png', { responseType: 'blob' }).subscribe({
      //     next: (response) => {
      //       const reader = new FileReader();
      //       reader.readAsDataURL(response);
      //       reader.onloadend = () => {
      //         resolve(reader.result as string);
      //       };
      //       reader.onerror = () => {
      //         reject(reader.error);
      //       };
      //     },
      //     error: (err) => {
      //       reject('')
      //     }
      //   })
      // });
    }
  }

  async getProductImageInBase64(imageFileName:string):Promise<string> {
    if (imageFileName) {
      try {
        const imageFile = await tauriFS.readBinaryFile(`${this.productImagesDir}\\${imageFileName}`)

        // Convert the Uint8Array to Base64
        const base64String = base64js.fromByteArray(imageFile)


        const imageString = 'data:image/jpeg;base64,' + base64String

        return imageString
      }
      catch (error) {
        throw error
      }
    }
    else {
      return ''
      // return new Promise((resolve, reject) => {
      //   this.http.get('/assets/img/No-Image-Icon.png', { responseType: 'blob' }).subscribe({
      //     next: (response) => {
      //       const reader = new FileReader();
      //       reader.readAsDataURL(response);
      //       reader.onloadend = () => {
      //         resolve(reader.result as string);
      //       };
      //       reader.onerror = () => {
      //         reject(reader.error);
      //       };
      //     },
      //     error: (err) => {
      //       reject('')
      //     }
      //   })
      // });
    }
  }


  async imageFileToUint8Array(file: File): Promise<Uint8Array> {
    return new Promise<Uint8Array>((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => {
        const arrayBuffer = reader.result as ArrayBuffer;
        const uint8Array = new Uint8Array(arrayBuffer);
        resolve(uint8Array);
      };
      reader.onerror = reject;
      reader.readAsArrayBuffer(file);
    });
  }
  

 async saveCustomerImage(imageFile:any, imageFileName:string): Promise<void> {

  const customerImagesDirPath = this.imagesParentDirectoryForApp + '\\' + this.customerImagesDirectoryName

  const saveToPath = customerImagesDirPath + '\\' + imageFileName
  
    //create directory if not exists
      if (!await tauriFS.exists(customerImagesDirPath, { dir: tauriFS.BaseDirectory.Picture })) {
        await tauriFS.createDir(customerImagesDirPath, { dir: tauriFS.BaseDirectory.Picture })
    }

  return this.compressAndSaveImage(saveToPath, imageFile, 'saveCustomerImage')
}

  async saveProductImage(imageFile:any, imageFileName:string) {

    const productImagesDirPath = this.imagesParentDirectoryForApp + '\\' + this.productImagesDirectoryName

    const saveToPath = productImagesDirPath + '\\' + imageFileName

    //create directory if not exists
    if (!await tauriFS.exists(productImagesDirPath, { dir: tauriFS.BaseDirectory.Picture })) {
        await tauriFS.createDir(productImagesDirPath, { dir: tauriFS.BaseDirectory.Picture })
    }
    return this.compressAndSaveImage(saveToPath, imageFile,'saveProductImage')

  }


  async updateCustomerImage(oldFileName:string, newFileName:string, imageFile:any) {

    try {

      await this.deleteFileIfExists(this.customerImagesDir, oldFileName)

      await this.saveCustomerImage(imageFile, newFileName)

    } catch (error) {
        throw error;
    }

  }

  async updateProductImage(oldFileName:string, newFileName:string, imageFile:any) {

    try {

      await this.deleteFileIfExists(this.productImagesDir, oldFileName)

      await this.saveProductImage(imageFile, newFileName)

    } catch (error) {
      throw error
    }

  }

  async deleteCustomerImage(fileName:string) {
    
    try {
      await this.deleteFileIfExists(this.customerImagesDir, fileName)
    } catch (error) {
      throw error
    }
  }

  async deleteProductImage(fileName:string) {
    
    try {
      await this.deleteFileIfExists(this.productImagesDir, fileName)
    } catch (error) {
        throw error
    }
  }

  async saveUserImage(imageFile:any, imageFileName:string) {

    const saveToPath = this.userImagesDir + '\\' + imageFileName

    //create directory if not exists
    if (!await tauriFS.exists(this.userImagesDir, { dir: tauriFS.BaseDirectory.Picture })) {
        await tauriFS.createDir(this.userImagesDir, { dir: tauriFS.BaseDirectory.Picture })
    }
    return this.compressAndSaveImage(saveToPath, imageFile, 'saveUserImage')

  }



  async updateUserImage(oldFileName:string, newFileName:string, imageFile:any) {
    
    try {

      await this.deleteFileIfExists(this.userImagesDir, oldFileName)

      await this.saveUserImage(imageFile, newFileName);
    } catch (error) {
      throw error
    }

  }

  async deleteUserImage(fileName:string) {
    
    try {
      await this.deleteFileIfExists(this.userImagesDir, fileName)
    } catch (error) {
      throw error
    }
  }


}
