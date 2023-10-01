import { Injectable } from '@angular/core';
import { from } from 'rxjs';
import { DatabaseService } from '../Shared/database.service';

@Injectable({
  providedIn: 'root'
})
export class DbUserService {

  constructor(private dbService:DatabaseService) { }

  getUserDetails(userId:number) {
    return from(this.dbService.dbConnection.select("call get_user_details(?);",[
      userId
    ]))
  }

  updateUserDetails(userDetails:any) {
    return from(this.dbService.dbConnection.execute("call update_user_details(?, ?, ?, ?);",[
      userDetails.uid,
      userDetails.userName,
      userDetails.password,
      userDetails.email
    ]))
  }

  getUserImage(uid:number) {
    return from(this.dbService.dbConnection.select("call get_user_image(?);", [
      uid
    ]))
  }

  updateUserImage(uid:number, imageFileName:string ) {
    return from(this.dbService.dbConnection.select("call update_user_image(?, ?);",[
      uid,
      imageFileName
    ]))
  }

  deleteUserImage(uid:number) {
    return from(this.dbService.dbConnection.select("call delete_user_image(?);",[
      uid
    ]))
  }
}
