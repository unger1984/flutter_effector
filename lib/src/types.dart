part of flutter_effector;

typedef Transform<State, Message> = State Function(State state,
    {Message? message});

typedef EventSubscription<T> = void Function({T? value});

typedef StoreSubscription<T> = void Function({T state});
