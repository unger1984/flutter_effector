part of flutter_effector;

typedef RegularTransform<State> = State Function(State state);
typedef IntentTransform<State, Message> = State Function(
    State state, Message message);

typedef EventSubscription<Message> = void Function(Message? message);

typedef StoreSubscription<T> = void Function(T state);
