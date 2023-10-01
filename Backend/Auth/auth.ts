import { Injectable } from "@angular/core";
import { DatabaseService } from "../Shared/database.service";


@Injectable({
    providedIn: 'root'
  })
export class Auth {
      
 public constructor(private dbService:DatabaseService) {}

 async loginUser(userName:string) {
    return await this.dbService.dbConnection.select(`call loginUser('${userName}');`);
 }

}
