import 'package:flutter/material.dart';

import '../screens/add_medicine/add_medicine_screen.dart';
import '../screens/add_order/add_order_screen.dart';
import '../screens/add_suppliers/add_suppliers_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/register_screen.dart';
import '../screens/notificatons/notifications_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../profile/profile_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/scan/scan_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/suppliers/suppliers_screen.dart';
import '../widgets/auth_guard.dart';

class AppRoutes {
  AppRoutes._();

  // Authentication
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

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
  static const String addOrder = '/add-order';

  // Reports
  static const String reports = '/reports';

  // Notifications
  static const String notifications = '/notifications';

  // Settings
  static const String settings = '/settings';

  // Profile
  static const String profile = '/profile';

  // Future / not built yet — uncomment when you add these screens
  // static const String about = '/about';
  // static const String help = '/help';

  // ---------------------------------------------------------------------
  // Route map
  // ---------------------------------------------------------------------
  // Splash and Login are public — everything else is wrapped in AuthGuard,
  // so it's unreachable without a logged-in session, no matter how the
  // navigation was triggered.
  //
  // editMedicine and medicineDetails are intentionally NOT registered
  // below — both screens require a Medicine object, which a parameterless
  // WidgetBuilder can't supply. Both are reached via direct
  // Navigator.push(MaterialPageRoute(...)) from InventoryScreen instead.
  // The route name constants above are kept for reference / possible
  // future onGenerateRoute use.
  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    dashboard: (_) => const AuthGuard(child: DashboardScreen()),
    inventory: (_) => const AuthGuard(child: InventoryScreen()),
    addMedicine: (_) => const AuthGuard(child: AddMedicineScreen()),
    barcodeScanner: (_) => const AuthGuard(child: ScanScreen()),
    suppliers: (_) => const AuthGuard(child: SuppliersScreen()),
    addSupplier: (_) => const AuthGuard(child: AddSupplierScreen()),
    orders: (_) => const AuthGuard(child: OrdersScreen()),
    addOrder: (_) => const AuthGuard(child: AddOrderScreen()),
    reports: (_) => const AuthGuard(child: ReportsScreen()),
    notifications: (_) => const AuthGuard(child: NotificationsScreen()),
    settings: (_) => const AuthGuard(child: SettingsScreen()),
    profile: (_) => const AuthGuard(child: ProfileScreen()),
  };
}

