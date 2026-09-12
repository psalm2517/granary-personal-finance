import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/util/money.dart';

void main() {
  test('regular suffixes', () {
    expect(ordinalDay(1), '1st');
    expect(ordinalDay(2), '2nd');
    expect(ordinalDay(3), '3rd');
    expect(ordinalDay(4), '4th');
    expect(ordinalDay(21), '21st');
    expect(ordinalDay(22), '22nd');
    expect(ordinalDay(23), '23rd');
    expect(ordinalDay(31), '31st');
  });

  test('the teens all take th, despite ending in 1, 2 and 3', () {
    expect(ordinalDay(11), '11th');
    expect(ordinalDay(12), '12th');
    expect(ordinalDay(13), '13th');
  });

  test('every day of a month has a sensible suffix', () {
    for (var day = 1; day <= 31; day++) {
      expect(ordinalDay(day), matches(RegExp(r'^\d{1,2}(st|nd|rd|th)$')),
          reason: 'day $day');
    }
    // Spot-check the full sequence for the first twenty.
    expect([for (var d = 1; d <= 20; d++) ordinalDay(d)], [
      '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th',
      '11th', '12th', '13th', '14th', '15th', '16th', '17th', '18th',
      '19th', '20th',
    ]);
  });
}
