import '../database/db_helper.dart';
import '../database/db_constants.dart';
import '../models/activity_log.dart';

class ActivityLogService {
  static Future<int> addEntry(ActivityLog entry) async {
    final db = await DBHelper.database;
    final payload = entry.toMap()..remove('id');
    return await db.insert(DBConstants.activityLogTable, payload);
  }

  /// Returns the most recent entries first, optionally capped by [limit].
  static Future<List<ActivityLog>> getRecent({int limit = 20}) async {
    final db = await DBHelper.database;
    final result = await db.query(
      DBConstants.activityLogTable,
      orderBy: '${DBConstants.colActivityTimestamp} DESC',
      limit: limit,
    );
    return result.map((e) => ActivityLog.fromMap(e)).toList();
  }
}
