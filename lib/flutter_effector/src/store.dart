part of flutter_effector;

abstract class Store<State> {
  _Store<State> on(RegularEvent event, RegularTransform<State> transform);
  _Store<State> onI<Message>(
      IntentEvent<Message> event, IntentTransform<State, Message> transform);
  _Store<State> reset(Event event);
  State get value;
}

class _Store<State> extends Store<State> {
  final State _initial;
  State _state;

  _Store(this._initial) : _state = _initial;

  /// TODO: Remove _updaters and leave only the _watchers
  final _updaters = <EffectorWidget, void Function()>{};

  final _watchers = <StoreSubscription<State>>[];

  void _setState(State newState) {
    _state = newState;
    _updaters.values.forEach((updater) => updater());
    _watchers.forEach((watcher) => watcher(_state));
  }

  _Store<State> on(RegularEvent event, RegularTransform<State> transform) {
    event.watch(() => _setState(transform(_state)));
    return this;
  }

  _Store<State> onI<Message>(
      IntentEvent<Message> event, IntentTransform<State, Message> transform) {
    event.watch((message) => _setState(transform(_state, message)));
    return this;
  }

  _Store<State> reset(Event event) {
    if (event is RegularEvent) {
      event.watch(() => _setState(_initial));
    }
    if (event is IntentEvent) {
      event.watch((_) => _setState(_initial));
    }
    return this;
  }

  void watch(StoreSubscription<State> subscription) =>
      _watchers.add(subscription);

  State get value => _state;
}

Store<State> createStore<State>(State initial) {
  print("Created store with value $initial");
  return _Store(initial);
}
