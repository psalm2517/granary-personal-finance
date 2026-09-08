import 'dart:async';

/// Combines streams by latest value, re-emitting whenever *any* of them
/// produces a new event — unlike [StreamZip], which pairs events
/// positionally and stalls until every stream has a fresh value queued.
/// Emits nothing until every stream has emitted at least once.
Stream<List<T>> combineLatest<T>(List<Stream<T>> streams) {
  late StreamController<List<T>> controller;
  final latest = List<T?>.filled(streams.length, null);
  final hasValue = List<bool>.filled(streams.length, false);
  final subscriptions = <StreamSubscription<T>>[];

  void emitIfReady() {
    if (hasValue.every((v) => v)) {
      controller.add(List<T>.from(latest));
    }
  }

  controller = StreamController<List<T>>.broadcast(
    onListen: () {
      for (var i = 0; i < streams.length; i++) {
        subscriptions.add(
          streams[i].listen((value) {
            latest[i] = value;
            hasValue[i] = true;
            emitIfReady();
          }, onError: controller.addError),
        );
      }
    },
    onCancel: () async {
      for (final s in subscriptions) {
        await s.cancel();
      }
      subscriptions.clear();
    },
  );
  return controller.stream;
}
