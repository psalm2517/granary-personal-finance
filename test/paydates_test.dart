import 'package:flutter_test/flutter_test.dart';
import 'package:granary/data/database.dart';
import 'package:granary/data/repository.dart';

PaycheckSchedule _schedule(PayFrequency freq, DateTime anchor) =>
    PaycheckSchedule(
      id: 1,
      profileId: 1,
      name: 'Job',
      frequency: freq,
      anchorDate: anchor,
      amountCents: 185000,
      active: true,
    );

void main() {
  test('bi-weekly paydates step by 14 days', () {
    final dates = HomebaseRepository.paydatesFor(
        _schedule(PayFrequency.biweekly, DateTime(2026, 8, 21)),
        DateTime(2026, 9, 30));
    expect(dates, [
      DateTime(2026, 8, 21),
      DateTime(2026, 9, 4),
      DateTime(2026, 9, 18),
    ]);
  });

  test('semi-monthly alternates 1st and 15th', () {
    final dates = HomebaseRepository.paydatesFor(
        _schedule(PayFrequency.semimonthly, DateTime(2026, 8, 1)),
        DateTime(2026, 9, 30));
    expect(dates, [
      DateTime(2026, 8, 1),
      DateTime(2026, 8, 15),
      DateTime(2026, 9, 1),
      DateTime(2026, 9, 15),
    ]);
  });

  test('monthly keeps the day of month', () {
    final dates = HomebaseRepository.paydatesFor(
        _schedule(PayFrequency.monthly, DateTime(2026, 8, 5)),
        DateTime(2026, 10, 31));
    expect(dates,
        [DateTime(2026, 8, 5), DateTime(2026, 9, 5), DateTime(2026, 10, 5)]);
  });
}
