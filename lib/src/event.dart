part of flutter_effector;

abstract class _EventInterface {
  String get name;

  @override
  bool operator ==(other) => other is _EventInterface && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

abstract class Event<T> extends _EventInterface {
  void watch(EventSubscription<T> subscription);
  void call([T? message]);
}

class _Event<T> extends Event<T> {
  final String name;
  final _subscriptions = <EventSubscription<T>>[];

  _Event(this.name);

  void watch(EventSubscription<T> subscription) =>
      _subscriptions.add(subscription);

  void call([T? message]) =>
      _subscriptions.forEach((subscription) => subscription(message));
}

Event<T> createEvent<T>(String? name) => _Event<T>(name ?? nextUnitID());
