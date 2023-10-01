import { Injectable } from '@angular/core';
import { from } from 'rxjs';
import { DatabaseService } from '../../Shared/database.service';

@Injectable({
  providedIn: 'root'
})
export class DbMasterCategoriesService {

  constructor(private databaseService:DatabaseService) { }

  getMasterCategories(){
    return from(this.databaseService.dbConnection.select("call get_master_categories();"))
  }

  addMasterCategory(name:string,description:string) {
    return from(this.databaseService.dbConnection.execute("call add_master_category(?, ?);", [name, description || null]))
  }
}
