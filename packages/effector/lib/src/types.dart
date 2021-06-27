typedef EventSubscription<Payload> = void Function(Payload? payload);

typedef StoreSubscription<T> = void Function(T state);
