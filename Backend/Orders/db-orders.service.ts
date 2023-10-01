import { Injectable } from '@angular/core';
import { from, Observable } from 'rxjs';
import { DatabaseService } from '../Shared/database.service';

@Injectable({
  providedIn: 'root'
})
export class DbOrdersService {

  constructor(private databaseService:DatabaseService) { }

  getSalesAndLabour(timeInterval:number) {
    return from(this.databaseService.dbConnection.select("call get_sales_labour(?);",[
      timeInterval
    ]))
  }

  getRecentOrders(numberOfOrders:number) {
    return from(this.databaseService.dbConnection.select("call get_recent_orders(?);",[
      numberOfOrders
    ]))
  }

  getTotalRevenueInLast6Months() {
    return from(this.databaseService.dbConnection.select("call get_revenue_of_six_months();"))
  }

  getAllOrders(itemsPerPage:number , pageNumber:number, searchQuery= ''):Observable<any> {
    return from(this.databaseService.dbConnection.select('call get_all_orders(?, ?, ?);',
    [
      itemsPerPage,
      pageNumber,
      searchQuery
    ]))
  }

  getOrderDetails(orderGuid:string):Observable<any> {
    return from(this.databaseService.dbConnection.select(`call get_order_details('${orderGuid}');`))
  }

  saveOrder(orderData:any) {
    return from(this.databaseService.dbConnection.select("call save_order(?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",[
      orderData.totalAmountWithGST,
      orderData.totalAmountWithoutGst,
      orderData.totalDiscount,
      orderData.totalLabour,
      orderData.totalGST,
      null,
      orderData.customerId,
      orderData.amountPaid,
      orderData.paymentMethod,
      orderData.productsData
    ]))
  }

  cancelOrder(orderGuid:string) {
    return from(this.databaseService.dbConnection.select("call cancel_order(?);",[
      orderGuid
    ]))
  }

  recordPayment(paymentData:any) {
    return from(this.databaseService.dbConnection.select("call record_payment(?, ?, ?, ?, ?);",[
      paymentData.orderGuid,
      paymentData.paymentType,
      paymentData.remarks || null,
      paymentData.paymentAmount,
      paymentData.paymentDate
    ]))
  }
}
