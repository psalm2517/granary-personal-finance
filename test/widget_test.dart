import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clearly/data/database.dart';
import 'package:clearly/main.dart';

void main() {
  testWidgets('first run shows profile setup', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const ClearlyApp(),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Clearly'), findsOneWidget);
  });
}
