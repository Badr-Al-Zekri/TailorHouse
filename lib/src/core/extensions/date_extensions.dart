import 'package:intl/intl.dart';

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  // ============================================================================
  // Formatting
  // ============================================================================

  /// Format: Jan 5, 2024
  String get formatted => DateFormat.yMMMd().format(this);

  /// Format: January 5, 2024
  String get formattedLong => DateFormat.yMMMMd().format(this);

  /// Format: 05/01/2024
  String get formattedShort => DateFormat('dd/MM/yyyy').format(this);

  /// Format: 05 Jan 2024
  String get formattedMedium => DateFormat('dd MMM yyyy').format(this);

  /// Format: 10:30 AM
  String get formattedTime => DateFormat.jm().format(this);

  /// Format: 10:30:45 AM
  String get formattedTimeWithSeconds => DateFormat.jms().format(this);

  /// Format: Jan 5, 2024 at 10:30 AM
  String get formattedDateTime => '${DateFormat.yMMMd().format(this)} at ${DateFormat.jm().format(this)}';

  /// Format: 2024-01-05
  String get isoDate => DateFormat('yyyy-MM-dd').format(this);

  /// Format: 2024-01-05T10:30:00
  String get isoDateTime => toIso8601String();

  // ============================================================================
  // Comparison
  // ============================================================================

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool get isThisYear {
    return year == DateTime.now().year;
  }

  bool get isPast => isBefore(DateTime.now());

  bool get isFuture => isAfter(DateTime.now());

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  // ============================================================================
  // Manipulation
  // ============================================================================

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfMonth => DateTime(year, month, 1);

  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  DateTime get startOfYear => DateTime(year, 1, 1);

  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  DateTime addDays(int days) => add(Duration(days: days));

  DateTime subtractDays(int days) => subtract(Duration(days: days));

  DateTime addMonths(int months) => DateTime(year, month + months, day, hour, minute, second);

  DateTime addYears(int years) => DateTime(year + years, month, day, hour, minute, second);

  // ============================================================================
  // Relative time
  // ============================================================================

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  String get smartDate {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isTomorrow) return 'Tomorrow';
    if (isThisWeek) return DateFormat.EEEE().format(this);
    if (isThisYear) return DateFormat.MMMd().format(this);
    return formatted;
  }

  // ============================================================================
  // Age calculation
  // ============================================================================

  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}

