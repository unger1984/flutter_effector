part of flutter_effector;

abstract class Store<State> {
  _Store<State> on<T>(Event<T> event, Transform<State, T?> transform);
  _Store<State> reset(_EventInterface event);
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
    _watchers.forEach((watcher) => watcher(state: _state));
  }

  _Store<State> on<T>(Event<T> event, Transform<State, T> transform) {
    event.watch(({value}) => _setState(transform(_state, message: value)));
    return this;
  }

  _Store<State> reset(_EventInterface event) {
    if (event is Event) {
      event.watch(({value}) => _setState(_initial));
    }
    return this;
  }

  void watch(StoreSubscription<State> subscription) =>
      _watchers.add(subscription);

  State get value => _state;
}

Store<State> createStore<State>(State initial) {
  return _Store(initial);
}
