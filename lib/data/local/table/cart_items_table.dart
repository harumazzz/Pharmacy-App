import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/table/product_table.dart';
import 'package:pharmacy_app/data/local/table/user_table.dart';

class CartItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  IntColumn get userId => integer().references(Users, #id)();
  
  IntColumn get productId => integer().references(Products, #id)();
  
  IntColumn get quantity => integer()();
}