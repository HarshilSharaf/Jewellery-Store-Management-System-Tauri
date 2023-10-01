import { Injectable } from '@angular/core';
import * as dayjs from 'dayjs';
import { from } from 'rxjs';
import { CustomerDetails } from 'client/app/modules/customers/models/customerDetails';
import { DatabaseService } from '../Shared/database.service';

@Injectable({
  providedIn: 'root'
})
export class DbCustomersService {

  constructor(private databaseService:DatabaseService) { }

  getTotalCustomers() {
    return from(this.databaseService.dbConnection.select("call get_total_customers();"))
  }

  getAllCustomers(fetchImage:boolean, itemsPerPage:number, pageNumber = 1, searchQuery = '', fetchAll = false) {
    return from(this.databaseService.dbConnection.select(`call get_all_customers(?, ?, ?, ?, ?);`,[
      fetchImage ? 1 : 0,
      itemsPerPage,
      pageNumber,
      fetchAll ? 1: 0,
      searchQuery
    ]))
  }

  addCustomer(customerDetails: CustomerDetails) {
    return from(this.databaseService.dbConnection.select("call add_customer(?,?,?,?,?,?,?,?,?);",
    [customerDetails.firstName,
    customerDetails.lastName,
    dayjs(customerDetails.dateOfBirth).format('YYYY-MM-DD'),
    customerDetails.gender,
    customerDetails.address,
    customerDetails.city,
    customerDetails.email || null,
    customerDetails.phoneNumber,
    customerDetails.imagePath]))
  }

  deleteCustomer(customerGuid:string, hardDelete = 0) {
    return from(this.databaseService.dbConnection.execute("call delete_customer(?, ?);", [
      hardDelete,
      customerGuid
    ])
    )
  }

  getCustomerDetails(customerGuid:string) {
    return from(this.databaseService.dbConnection.select("call get_customer_details(?);", [
      customerGuid
    ]))
  }

  getCustomerImage(customerGuid:string) {
    return from(this.databaseService.dbConnection.select("call get_customer_image(?);", [
      customerGuid
    ]))
  }

  updateCustomerImage(customerGuid:string, imagePath:string) {
    return from(this.databaseService.dbConnection.select("call update_customer_image(?, ?);", [
      customerGuid,
      imagePath
    ]))
  }

  deleteCustomerImage(customerGuid:string) {
    return from(this.databaseService.dbConnection.select("call delete_customer_image(?);", [
      customerGuid
    ]))
  }


  updateCustomerDetails(customerDetails:any) {
    return from(this.databaseService.dbConnection.execute("call update_customer_details(?,?,?,?,?,?,?,?,?);",
    [
      customerDetails.customerGuid,
      customerDetails.firstName,
      customerDetails.lastName,
      dayjs(customerDetails.dob).format('YYYY-MM-DD'),
      customerDetails.address || null,
      customerDetails.city,
      customerDetails.email || null,
      customerDetails.phone,
      customerDetails.gender
    ]))
  }

  getTotalAmountOfProductsBoughtForCustomer(customerGuid:string){
    return from(this.databaseService.dbConnection.select("call get_total_amount_of_products_bought_for_customer(?);",[
      customerGuid
    ]))
  }

  getCustomerOrders(customerGuid:string, itemsPerPage:number, pageNumber = 1, searchQuery= '', getCancelledOrders = 1) {
    return from(this.databaseService.dbConnection.select("call get_customer_orders (? ,?, ?, ?, ?);",[
      getCancelledOrders,
      customerGuid,
      itemsPerPage,
      pageNumber,
      searchQuery
    ]))
  }
}