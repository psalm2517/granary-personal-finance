import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'reminder.dart';

/// Local notifications for payment reminders. Deliberately simple: it shows
/// a notification when the app finds something due, rather than trying to
/// schedule ahead.
///
/// The reason is platform behaviour. On Linux the notification daemon has no
/// concept of a scheduled notification that survives the app exiting, so
/// anything "scheduled" would only fire while Clearly happens to be open.
/// Showing on launch is honest about that, and the in-app reminders panel on
/// the dashboard is the reliable surface either way.
class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  bool _supported = true;

  /// Ids already shown this run, so re-entering the dashboard does not
  /// re-notify for the same thing.
  final _shown = <String>{};

  Future<void> init() async {
    if (_ready) return;
    try {
      const linux = LinuxInitializationSettings(defaultActionName: 'Open');
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(
        settings: const InitializationSettings(linux: linux, android: android),
      );
      if (Platform.isAndroid) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }
      _ready = true;
    } catch (_) {
      // A missing notification daemon should never take the app down; the
      // in-app panel still works.
      _supported = false;
    }
  }

  Future<void> showReminder(Reminder reminder, {DateTime? now}) async {
    if (!_supported) return;
    await init();
    if (!_ready) return;
    if (!_shown.add(reminder.dedupeKey)) return;

    final days = reminder.daysUntil(now ?? DateTime.now());
    final when = switch (days) {
      <= 0 => 'due today',
      1 => 'due tomorrow',
      _ => 'due in $days days',
    };
    final what = switch (reminder.kind) {
      ReminderKind.bill => 'Bill',
      ReminderKind.cardPayment => 'Card payment',
      ReminderKind.loanPayment => 'Loan payment',
      ReminderKind.annualFee => 'Annual fee',
    };

    try {
      await _plugin.show(
        id: reminder.dedupeKey.hashCode & 0x7fffffff,
        title: '$what $when: ${reminder.title}',
        body: _formatCents(reminder.amountCents),
        notificationDetails: const NotificationDetails(
          linux: LinuxNotificationDetails(),
          android: AndroidNotificationDetails(
            'homebase_reminders',
            'Payment reminders',
            channelDescription: 'Bills and payments coming due',
            importance: Importance.defaultImportance,
          ),
        ),
      );
    } catch (_) {
      _supported = false;
    }
  }

  static String _formatCents(int cents) =>
      '\$${(cents / 100).toStringAsFixed(2)}';
}
