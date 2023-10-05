import { Injectable } from '@angular/core';
import { from } from 'rxjs';
import { DatabaseService } from '../Shared/database.service';
import { CategoryServiceInterface } from 'client/app/interfaces/Categories/category-service-interface';

@Injectable({
  providedIn: 'root'
})
export class DbCategoriesService implements CategoryServiceInterface {

  constructor(private databaseService:DatabaseService) { }

  getAllCategories() {
    return from(this.databaseService.dbConnection.select("call get_all_categories();"))
  }
}
