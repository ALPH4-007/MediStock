import 'package:flutter/foundation.dart';

import '../models/activity_log.dart';
import '../services/activity_log_service.dart';

class ActivityLogProvider extends ChangeNotifier {
  List<ActivityLog> _entries = [];
  bool _isLoading = false;

  List<ActivityLog> get entries => List.unmodifiable(_entries);
  bool get isLoading => _isLoading;

  Future<void> loadRecent({int limit = 20}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      _entries = await ActivityLogService.getRecent(limit: limit);
    } catch (error) {
      debugPrint('ACTIVITY LOG LOAD ERROR: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logs a new activity entry and refreshes the in-memory list so the
  /// dashboard reflects it immediately, without a manual reload elsewhere.
  Future<void> log({
    required String type,
    required String title,
    String? subtitle,
  }) async {
    try {
      await ActivityLogService.addEntry(
        ActivityLog(
          type: type,
          title: title,
          subtitle: subtitle,
          timestamp: DateTime.now(),
        ),
      );
      await loadRecent();
    } catch (error) {
      debugPrint('ACTIVITY LOG WRITE ERROR: $error');
    }
  }
}
