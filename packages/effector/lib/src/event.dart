import 'id.dart' show nextUnitID;
import 'types.dart';

Event<Payload> createEvent<Payload>(String? name) =>
    Event<Payload>(name ?? nextUnitID());

abstract class Event<Payload> {
  factory Event(String name) => _Event<Payload>(name);

  void watch(EventSubscription<Payload> subscription);
  void call([Payload? payload]);
}

class _Event<Payload> implements Event<Payload> {
  _Event(this.name);

  final String name;

  final List<EventSubscription<Payload>> _subscriptions =
      <EventSubscription<Payload>>[];

  @override
  void watch(EventSubscription<Payload> subscription) =>
      _subscriptions.add(subscription);

  @override
  void call([Payload? payload]) => _subscriptions.forEach(
      (EventSubscription<Payload> subscription) => subscription(payload));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _Event<Payload> && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
