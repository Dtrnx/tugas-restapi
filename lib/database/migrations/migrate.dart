import 'dart:io';
import 'package:vania/vania.dart';
import 'customers_table.dart';
import 'vendors_table.dart';
import 'products_table.dart';
import 'product_notes_table.dart';
import 'orders_table.dart';
import 'order_items_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();

  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }

  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  Future<void> registry() async {
    await CreateCustomersTable().up();
    await CreateVendorsTable().up();
    await CreateProductsTable().up();
    await CreateOrdersTable().up();
    await CreateOrderItemsTable().up();
    await CreateProductNotesTable().up();
  }

  Future<void> dropTables() async {
    await CreateProductNotesTable().down();
    await CreateOrderItemsTable().down();
    await CreateOrdersTable().down();
    await CreateProductsTable().down();
    await CreateVendorsTable().down();
    await CreateCustomersTable().down();
  }
}
