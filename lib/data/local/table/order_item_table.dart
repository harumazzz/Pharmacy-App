import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/table/order_table.dart';
import 'package:pharmacy_app/data/local/table/product_table.dart';

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  IntColumn get orderId => integer().references(Orders, #id)();
  
  IntColumn get productId => integer().references(Products, #id)();
  
  IntColumn get quantity => integer()();
  RealColumn get price => real()(); 
}