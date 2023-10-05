import { Injectable } from '@angular/core';
import { from } from 'rxjs';
import { DatabaseService } from '../../Shared/database.service';
import { ProductCategoryServiceInterface } from 'client/app/interfaces/Categories/ProductCategories/product-category-service-interface';

@Injectable({
  providedIn: 'root'
})
export class DbProductCategoriesService implements ProductCategoryServiceInterface{

  constructor(private databaseService: DatabaseService) { }

  getTopProductCategories(numberOfCategories:number) {
    return from(this.databaseService.dbConnection.select("call get_top_product_categories(?);",[
      numberOfCategories
    ]))
  }

  getProductCategories() {
    return from(this.databaseService.dbConnection.select("call get_product_categories();"))
  }

  addProductCategory(name: string, description: string) {
    return from(this.databaseService.dbConnection.execute("call add_product_category(?, ?);", [name, description || null]))
  }
}
