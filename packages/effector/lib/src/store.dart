import 'types.dart';
import 'update.dart';
import 'event.dart';

abstract class Store<State> {
  factory Store(State initial) => _Store<State>(initial);

  _Store<State> on<Payload>(
      Event<Payload> event, Update<State, Payload> update);

  _Store<State> reset<Payload>(Event<Payload> event);

  State get value;
}

class _Store<State> implements Store<State> {
  _Store(this._initial) : _state = _initial;

  final State _initial;
  State _state;

  /// TODO: Remove _updaters and leave only the _watchers
  // final _updaters = <EffectorWidget, void Function()>{};

  final List<StoreSubscription<State>> _watchers = <StoreSubscription<State>>[];

  @override
  _Store<State> on<Payload>(
      Event<Payload> event, Update<State, Payload> update) {
    event.watch((Payload? payload) {
      if (update is RegularUpdate<State, Payload>) {
        _setState(update(_state));
      }
      if (update is IntentUpdate<State, Payload>) {
        if (payload == null) throw Exception('Use "Update.regular"');
        _setState(update(_state, payload));
      }
    });

    return this;
  }

  @override
  _Store<State> reset<Payload>(Event<Payload> event) {
    event.watch((_) => _setState(_initial));

    return this;
  }

  @override
  State get value => _state;

  void _setState(State newState) {
    _state = newState;
    // _updaters.values.forEach((updater) => updater());
    _watchers.forEach((StoreSubscription<State> watcher) => watcher(_state));
  }

  void watch(StoreSubscription<State> subscription) =>
      _watchers.add(subscription);
}

Store<State> createStore<State>(State initial) {
  return Store(initial);
}
