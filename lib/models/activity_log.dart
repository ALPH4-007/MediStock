/// A single entry in the app's activity log — e.g. a medicine being
/// added, stock changing, or an order being delivered. Purely a record
/// of what happened and when; it doesn't drive any business logic.
class ActivityLog {
  final int? id;
  final String
      type; // e.g. 'restock', 'low_stock', 'order_delivered', 'medicine_added', 'medicine_deleted'
  final String title;
  final String? subtitle;
  final DateTime timestamp;

  ActivityLog({
    this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()),
      type: map['type']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString(),
      timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
