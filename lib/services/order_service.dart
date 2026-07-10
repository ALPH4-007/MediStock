import '../database/db_constants.dart';
import '../database/db_helper.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class OrderService {
  Future<List<Order>> fetchAll() async {
    final db = await DBHelper.database;
    final orderRows = await db.query(
      DBConstants.ordersTable,
      orderBy: '${DBConstants.colOrderId} DESC',
    );

    final orders = <Order>[];
    for (final row in orderRows) {
      final items = await _fetchItemsForOrder(row['id'] as int);
      orders.add(Order.fromMap(row, items: items));
    }
    return orders;
  }

  Future<List<OrderItem>> _fetchItemsForOrder(int orderId) async {
    final db = await DBHelper.database;
    final itemRows = await db.query(
      DBConstants.orderItemsTable,
      where: '${DBConstants.colOrderItemOrderId} = ?',
      whereArgs: [orderId],
    );
    return itemRows.map((row) => OrderItem.fromMap(row)).toList();
  }

  Future<void> add(Order order) async {
    final db = await DBHelper.database;

    await db.transaction((txn) async {
      final orderId = await txn.insert(
        DBConstants.ordersTable,
        order.toMap()..remove('id'),
      );

      for (final item in order.items) {
        await txn.insert(
          DBConstants.orderItemsTable,
          item.toMap()
            ..remove('id')
            ..['orderId'] = orderId,
        );
      }
    });
  }

  Future<void> update(Order order) async {
    if (order.id == null) return;

    final db = await DBHelper.database;

    await db.transaction((txn) async {
      await txn.update(
        DBConstants.ordersTable,
        order.toMap(),
        where: '${DBConstants.colOrderId} = ?',
        whereArgs: [order.id],
      );

      await txn.delete(
        DBConstants.orderItemsTable,
        where: '${DBConstants.colOrderItemOrderId} = ?',
        whereArgs: [order.id],
      );

      for (final item in order.items) {
        await txn.insert(
          DBConstants.orderItemsTable,
          item.toMap()
            ..remove('id')
            ..['orderId'] = order.id,
        );
      }
    });
  }

  Future<void> delete(int? id) async {
    if (id == null) return;

    final db = await DBHelper.database;

    await db.transaction((txn) async {
      await txn.delete(
        DBConstants.orderItemsTable,
        where: '${DBConstants.colOrderItemOrderId} = ?',
        whereArgs: [id],
      );
      await txn.delete(
        DBConstants.ordersTable,
        where: '${DBConstants.colOrderId} = ?',
        whereArgs: [id],
      );
    });
  }
}
