import { Injectable } from '@angular/core';
import { from } from 'rxjs';
import { DatabaseService } from '../Shared/database.service';

@Injectable({
  providedIn: 'root'
})
export class DbInventoryService {

  constructor(private databaseService:DatabaseService) { }

  getTotalStock() {
    return from(this.databaseService.dbConnection.select("call get_total_stock();"))
  }

  getTotalStockOfMasterCategory(mid:number) {
    return from(this.databaseService.dbConnection.select("call get_total_stock_of_master_category(?);",[
      mid
    ]))
  }

  getAllProducts(itemsPerPage:number, pageNumber = 1, searchQuery:string = '', fetchSoldProducts = 0) {
    return from(this.databaseService.dbConnection.select("call get_all_products(?, ?, ?, ?);",[
      fetchSoldProducts,
      itemsPerPage,
      pageNumber,
      searchQuery
    ]))
  }

  addProduct(addProductFormData:any) {
    return from(this.databaseService.dbConnection.select("call add_product(?, ?, ?, ?, ?, ?);",[
      addProductFormData.productWeight,
      addProductFormData.productDescription || null,
      addProductFormData.productCategoryId,
      addProductFormData.subCategoryId,
      addProductFormData.masterCategoryId,
      addProductFormData.imagePath
    ]))
  }

  deleteProduct(productGuid:string, hardDelete=0) {
    return from(this.databaseService.dbConnection.execute("call delete_product(?, ?);", [
      hardDelete,
      productGuid
    ]))
  }

  deleteProductImage(productGuid:string) {
    return from(this.databaseService.dbConnection.select("call delete_product_image(?);",[
      productGuid
    ]))
  }

  getProductDetails(productGuid:string) {
    return from(this.databaseService.dbConnection.select("call get_product_details(?);",[
      productGuid
    ]))
  }

  getProductImage(productGuid:string) {
    return from(this.databaseService.dbConnection.select("call get_product_image(?);",[
      productGuid
    ]))
  }

  updateProductDetails(productDetails:any) {
    return from(this.databaseService.dbConnection.execute("call update_product_details(?,?,?,?,?,?)",[
      productDetails.productGuid,
      productDetails.productDescription,
      productDetails.productWeight,
      productDetails.masterCategoryId,
      productDetails.subCategoryId,
      productDetails.productCategoryId
    ]))
  }

  updateProductImage(productGuid:string, imagePath:string){
    return from(this.databaseService.dbConnection.select("call update_product_image(?, ?);",[
      productGuid,
      imagePath
    ]))
  }
}
