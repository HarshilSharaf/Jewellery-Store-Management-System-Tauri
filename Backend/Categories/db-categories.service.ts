import { Injectable } from '@angular/core';
import { from } from 'rxjs';
import { DatabaseService } from '../Shared/database.service';

@Injectable({
  providedIn: 'root'
})
export class DbCategoriesService {

  constructor(private databaseService:DatabaseService) { }

  getAllCategories() {
    return from(this.databaseService.dbConnection.select("call get_all_categories();"))
  }
}
