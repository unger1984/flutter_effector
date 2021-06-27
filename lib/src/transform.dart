part of flutter_effector;

abstract class Transform<State, Message> {
  factory Transform.regular(RegularTransform<State> transform) =>
      _RegularTransform(transform);
  factory Transform.intent(IntentTransform<State, Message> transform) =>
      _IntentTransform(transform);

  Transform._();
}

class _RegularTransform<State, Message> extends Transform<State, Message> {
  final RegularTransform<State> transform;

  _RegularTransform(this.transform) : super._();

  State call(State state) => transform(state);
}

class _IntentTransform<State, Message> extends Transform<State, Message> {
  final IntentTransform<State, Message> transform;

  _IntentTransform(this.transform) : super._();

  State call(State state, Message message) => transform(state, message);
}
