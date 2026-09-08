import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:granary/widgets/common.dart';

void main() {
  test('emits after every stream has produced one value', () async {
    final a = StreamController<int>();
    final b = StreamController<int>();
    final events = <List<int>>[];
    final sub = combineLatest<int>([a.stream, b.stream]).listen(events.add);

    a.add(1);
    await Future<void>.delayed(Duration.zero);
    expect(events, isEmpty, reason: 'b has not emitted yet');

    b.add(10);
    await Future<void>.delayed(Duration.zero);
    expect(events, [
      [1, 10]
    ]);

    await sub.cancel();
    await a.close();
    await b.close();
  });

  test('re-emits when only one source stream changes — the bug StreamZip '
      'had, where nothing updates until every stream ticks', () async {
    final a = StreamController<int>();
    final b = StreamController<int>();
    final events = <List<int>>[];
    final sub = combineLatest<int>([a.stream, b.stream]).listen(events.add);

    a.add(1);
    b.add(10);
    await Future<void>.delayed(Duration.zero);
    expect(events.length, 1);

    // Only `a` changes — a real combine-latest still emits immediately.
    a.add(2);
    await Future<void>.delayed(Duration.zero);
    expect(events.length, 2);
    expect(events.last, [2, 10]);

    await sub.cancel();
    await a.close();
    await b.close();
  });
}
