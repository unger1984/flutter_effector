typedef RegularTransform<State> = State Function(State state);

typedef IntentTransform<State, Payload> = State Function(
  State state,
  Payload payload,
);

abstract class Update<State, Payload> {
  factory Update.regular(RegularTransform<State> transform) =>
      RegularUpdate<State, Payload>(transform);

  factory Update.intent(IntentTransform<State, Payload> transform) =>
      IntentUpdate<State, Payload>(transform);

  Update._();
}

class RegularUpdate<State, Payload> extends Update<State, Payload> {
  RegularUpdate(this.transform) : super._();

  final RegularTransform<State> transform;

  State call(State state) => transform(state);
}

class IntentUpdate<State, Payload> extends Update<State, Payload> {
  IntentUpdate(this.transform) : super._();

  final IntentTransform<State, Payload> transform;

  State call(State state, Payload payload) => transform(state, payload);
}
