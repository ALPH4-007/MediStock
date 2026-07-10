class DBConstants {
  static const String dbName = 'medistock.db';
  static const int dbVersion = 7;

  static const String medicinesTable = 'medicines';
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colBarcode = 'barcode';
  static const String colBatchNumber = 'batchNumber';
  static const String colManufacturer = 'manufacturer';
  static const String colCategory = 'category';
  static const String colQuantity = 'quantity';
  static const String colMinimumStock = 'minimumStock';
  static const String colExpiryDate = 'expiryDate';
  static const String colPurchasePrice = 'purchasePrice';
  static const String colSellingPrice = 'sellingPrice';
  static const String colSupplierId = 'supplierId';
  static const String colLocation = 'location';
  static const String colDescription = 'description';
  static const String colCreatedAt = 'createdAt';
  static const String colPhotoPath = 'photoPath';

  static const String suppliersTable = 'suppliers';
  static const String colSupplierContactPerson = 'contactPerson';
  static const String colSupplierPhone = 'phone';
  static const String colSupplierEmail = 'email';
  static const String colSupplierAddress = 'address';
  static const String colSupplierNotes = 'notes';

  static const String activityLogTable = 'activity_log';
  static const String colActivityId = 'id';
  static const String colActivityType = 'type';
  static const String colActivityTitle = 'title';
  static const String colActivitySubtitle = 'subtitle';
  static const String colActivityTimestamp = 'timestamp';

  static const String ordersTable = 'orders';
  static const String colOrderId = 'id';
  static const String colOrderSupplierId = 'supplierId';
  static const String colOrderSupplierName = 'supplierName';
  static const String colOrderStatus = 'status';
  static const String colOrderDate = 'orderDate';
  static const String colOrderNotes = 'notes';

  static const String orderItemsTable = 'order_items';
  static const String colOrderItemId = 'id';
  static const String colOrderItemOrderId = 'orderId';
  static const String colOrderItemMedicineId = 'medicineId';
  static const String colOrderItemMedicineName = 'medicineName';
  static const String colOrderItemQuantity = 'quantity';
  static const String colOrderItemUnitPrice = 'unitPrice';
}
