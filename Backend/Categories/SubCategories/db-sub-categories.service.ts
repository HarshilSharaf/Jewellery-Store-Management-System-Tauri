import { Injectable } from '@angular/core';
import { from } from 'rxjs';
import { DatabaseService } from '../../Shared/database.service';
import { SubCategoryServiceInterface } from 'client/app/interfaces/Categories/SubCategories/sub-category-service-interface';

@Injectable({
  providedIn: 'root'
})
export class DbSubCategoriesService implements SubCategoryServiceInterface{

  constructor(private databaseService: DatabaseService) { }

  getSubCategories() {
    return from(this.databaseService.dbConnection.select("call get_sub_categories();"))
  }

  addSubCategory(name: string, description: string) {
    return from(this.databaseService.dbConnection.execute("call add_sub_category(?, ?);", [name, description || null]))
  }
}
