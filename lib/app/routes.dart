import 'package:flutter/material.dart';

import '../screens/add_medicine/add_medicine_screen.dart';
import '../screens/add_suppliers/add_suppliers_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/medicine_details/medicine_details_screen.dart';
import '../screens/notificatons/notifications_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/scan/scan_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/suppliers/suppliers_screen.dart';
import '../widgets/auth_guard.dart';

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
  // Splash and Login are public — everything else is wrapped in AuthGuard,
  // so it's unreachable without a logged-in session, no matter how the
  // navigation was triggered.
  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    dashboard: (_) => const AuthGuard(child: DashboardScreen()),
    inventory: (_) => const AuthGuard(child: InventoryScreen()),
    medicineDetails: (_) => const AuthGuard(child: MedicineDetailsScreen()),
    addMedicine: (_) => const AuthGuard(child: AddMedicineScreen()),
    // editMedicine: (_) => const AuthGuard(child: EditMedicineScreen()),
    barcodeScanner: (_) => const AuthGuard(child: ScanScreen()),
    suppliers: (_) => const AuthGuard(child: SuppliersScreen()),
    addSupplier: (_) => const AuthGuard(child: AddSupplierScreen()),
    orders: (_) => const AuthGuard(child: OrdersScreen()),
    reports: (_) => const AuthGuard(child: ReportsScreen()),
    notifications: (_) => const AuthGuard(child: NotificationsScreen()),
    settings: (_) => const AuthGuard(child: SettingsScreen()),
  };
}
