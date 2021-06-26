part of flutter_effector;

abstract class Event {
  String get name;

  @override
  bool operator ==(other) => other is Event && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

abstract class RegularEvent extends Event {
  void watch(RegularEventSubscription subscription);
  void call();
}

abstract class IntentEvent<T> extends Event {
  void watch(IntentEventSubscription<T> subscription);
  void call(T intent);
}

class _RegularEvent extends RegularEvent {
  final String name;
  final _subscriptions = <RegularEventSubscription>[];

  _RegularEvent(this.name);

  void watch(RegularEventSubscription subscription) =>
      _subscriptions.add(subscription);

  void call() => _subscriptions.forEach((subscription) => subscription());
}

class _IntentEvent<T> extends IntentEvent<T> {
  final String name;
  final _subscriptions = <IntentEventSubscription<T>>[];

  _IntentEvent(this.name);

  void watch(IntentEventSubscription<T> subscription) =>
      _subscriptions.add(subscription);

  void call(T value) =>
      _subscriptions.forEach((subscription) => subscription(value));
}

RegularEvent createEvent([String? name]) =>
    _RegularEvent(name ?? nextUnitID());

IntentEvent<T> createIEvent<T>([String? name]) =>
    _IntentEvent<T>(name ?? nextUnitID());
