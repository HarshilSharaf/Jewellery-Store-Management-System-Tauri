import { Injectable } from "@angular/core";
import { DatabaseService } from "../Shared/database.service";
import { AuthServiceInterface } from "client/app/interfaces/Auth/auth-service-interface";


@Injectable({
    providedIn: 'root'
  })
export class Auth implements AuthServiceInterface{
      
 public constructor(private dbService:DatabaseService) {}

 async loginUser(userName:string) {
    return await this.dbService.dbConnection.select(`call loginUser('${userName}');`);
 }

}
