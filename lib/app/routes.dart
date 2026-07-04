import 'package:flutter/material.dart';
import '../screens/add_medicine/add_medicine_screen.dart';
import '../screens/add_suppliers/add_suppliers_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/edit_medicine/edit_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/medicine_details/medicine_details_screen.dart';
import '../screens/notificatons/notification_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/scan/scan_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/suppliers/suppliers_screen.dart';

class AppRoutes {
  AppRoutes._(); // Prevents creating instances

  // ---------------------------------------------------------------------
  // Route names
  // ---------------------------------------------------------------------

  // Authentication
  static const String splashScreen = '/';
  static const String loginScreen = '/login';

  // Dashboard
  static const String dashboardScreen = '/dashboard';

  // Inventory
  static const String inventoryScreen = '/inventory';
  static const String medicineDetailsScreen = '/medicine-details';
  static const String addMedicineScreen = '/add-medicine';
  static const String editMedicineScreen = '/edit-medicine';
  static const String barcodeScannerScreen = '/barcode-scanner';

  // Suppliers
  static const String suppliersScreen = '/suppliers';
  static const String addSupplierScreen = '/add-supplier';

  // Orders
  static const String ordersScreen = '/orders';

  // Reports
  static const String reportsScreen = '/reports';

  // Notifications
  static const String notificationsScreen = '/notifications';

  // Settings
  static const String settingsScreen = '/settings';

  // Backward-compatible aliases
  static const String splash = splashScreen;
  static const String login = loginScreen;
  static const String dashboard = dashboardScreen;
  static const String inventory = inventoryScreen;
  static const String medicineDetails = medicineDetailsScreen;
  static const String addMedicine = addMedicineScreen;
  static const String editMedicine = editMedicineScreen;
  static const String barcodeScanner = barcodeScannerScreen;
  static const String suppliers = suppliersScreen;
  static const String addSupplier = addSupplierScreen;
  static const String orders = ordersScreen;
  static const String reports = reportsScreen;
  static const String notifications = notificationsScreen;
  static const String settings = settingsScreen;

  // Future / not built yet — uncomment when you add these screens
  // static const String profile = '/profile';
  // static const String about = '/about';
  // static const String help = '/help';

  // ---------------------------------------------------------------------
  // Route map
  // ---------------------------------------------------------------------
  // Uncomment each line as you build the matching screen. Keeping them
  // commented (rather than deleting) means the route name already exists
  // and you just have to wire up the widget when it's ready.
  static final Map<String, WidgetBuilder> routes = {
    splashScreen: (_) => const SplashScreen(),
    loginScreen: (_) => const LoginScreen(),
    dashboardScreen: (_) => const DashboardScreen(),
    inventoryScreen: (_) => const InventoryScreen(),
    medicineDetailsScreen: (_) => const MedicineDetailsScreen(),
    addMedicineScreen: (_) => const AddMedicineScreen(),
    editMedicineScreen: (_) => const EditMedicineScreen(),
    barcodeScannerScreen: (_) => const ScanScreen(),
    suppliersScreen: (_) => const SuppliersScreen(),
    addSupplierScreen: (_) => const AddSupplierScreen(),
    ordersScreen: (_) => const OrdersScreen(),
    reportsScreen: (_) => const ReportsScreen(),
    notificationsScreen: (_) => const NotificationsScreen(),
    settingsScreen: (_) => const SettingsScreen(),
  };
}
