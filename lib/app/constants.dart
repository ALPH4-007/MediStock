
class AppConstants {
  AppConstants._(); // Prevents creating instances

  // ---------------------------------------------------------------------
  // Application
  // ---------------------------------------------------------------------

  static const String appName = 'MediStock';
  static const String appVersion = '1.0.0';

  // ---------------------------------------------------------------------
  // Padding
  // ---------------------------------------------------------------------

  static const double paddingXS = 4;
  static const double paddingSM = 8;
  static const double paddingMD = 16;
  static const double paddingLG = 24;
  static const double paddingXL = 32;

  // ---------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------

  static const double spaceXS = 4;
  static const double spaceSM = 8;
  static const double spaceMD = 16;
  static const double spaceLG = 24;
  static const double spaceXL = 32;

  // ---------------------------------------------------------------------
  // Animations
  // ---------------------------------------------------------------------

  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // ---------------------------------------------------------------------
  // Pagination
  // ---------------------------------------------------------------------

  static const int pageSize = 20;

  // ---------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------

  static const Duration searchDelay = Duration(milliseconds: 400);

  // ---------------------------------------------------------------------
  // Barcode Scanner (future)
  // ---------------------------------------------------------------------

  static const Duration scannerTimeout = Duration(seconds: 30);
}
