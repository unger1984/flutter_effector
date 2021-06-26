part of flutter_effector;

typedef RegularTransform<State> = State Function(State state);
typedef IntentTransform<State, Message> = State Function(
    State state, Message message);

typedef RegularEventSubscription = void Function();
typedef IntentEventSubscription<T> = void Function(T value);

typedef StoreSubscription<T> = void Function(T state);
