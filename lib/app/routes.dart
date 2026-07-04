import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._(); // Prevents creating instances

  // ---------------------------------------------------------------------
  // Route names
  // ---------------------------------------------------------------------

  // Authentication
  static const String splash = '/';
  static const String login = '/login';

  // Dashboard
  static const String dashboard = '/dashboard';

  // Inventory
  static const String inventory = '/inventory';
  static const String medicineDetails = '/medicine-details';
  static const String addMedicine = '/add-medicine';
  static const String editMedicine = '/edit-medicine';
  static const String barcodeScanner = '/barcode-scanner';

  // Suppliers
  static const String suppliers = '/suppliers';
  static const String addSupplier = '/add-supplier';

  // Orders
  static const String orders = '/orders';

  // Reports
  static const String reports = '/reports';

  // Notifications
  static const String notifications = '/notifications';

  // Settings
  static const String settings = '/settings';

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
    // splash: (_) => const SplashScreen(),
    // login: (_) => const LoginScreen(),
    // dashboard: (_) => const DashboardScreen(),
    // inventory: (_) => const InventoryScreen(),
    // medicineDetails: (_) => const MedicineDetailsScreen(),
    // addMedicine: (_) => const AddMedicineScreen(),
    // editMedicine: (_) => const EditMedicineScreen(),
    // barcodeScanner: (_) => const BarcodeScannerScreen(),
    // suppliers: (_) => const SuppliersScreen(),
    // addSupplier: (_) => const AddSupplierScreen(),
    // orders: (_) => const OrdersScreen(),
    // reports: (_) => const ReportsScreen(),
    // notifications: (_) => const NotificationsScreen(),
    // settings: (_) => const SettingsScreen(),
  };
}
