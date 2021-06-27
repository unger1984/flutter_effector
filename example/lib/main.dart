import 'package:flutter/material.dart';

import 'package:effector/effector.dart';
import 'package:flutter_effector/flutter_effector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: CounterScreen());
}

final Event<void> increment = createEvent<void>('increment');
final Event<void> decrement = createEvent<void>('decrement');
final Event<void> resetCounter = createEvent<void>('reset counter');

final Store<int> counter = createStore(0)
    .on<void>(increment, Update<int, void>.regular((int state) => state + 1))
    .on<void>(decrement, Update<int, void>.regular((int state) => state - 1))
    .reset(resetCounter);

class CounterScreen extends EffectorWidget {
  @override
  Widget build(BuildContext context) {
    final int value = useStore(counter);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(value.toString()),
            OutlinedButton(
              onPressed: increment,
              child: const Text('Increment'),
            ),
            OutlinedButton(
              onPressed: decrement,
              child: const Text('Decrement'),
            ),
            OutlinedButton(
              onPressed: resetCounter,
              child: const Text('Reset'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (BuildContext  context) => UppercaseScreen()),
              ),
              child: const Text('Navigate to uppercase'),
            ),
          ],
        ),
      ),
    );
  }
}

class UppercaseModel {
  UppercaseModel({required this.currentText, required this.isUppercased});

  final String currentText;
  final bool isUppercased;
}

final Event<String> updateText = createEvent<String>('update text');
final Event<void> toggleUppercase = createEvent<void>('toggle uppercase');
final Event<void> resetUppercase = createEvent<void>('reset uppercase');

final Store<UppercaseModel> uppercaseStore =
    createStore(UppercaseModel(currentText: '', isUppercased: false))
        .on<String>(
          updateText,
          Update<UppercaseModel, String>.intent((UppercaseModel state, String message) => UppercaseModel(
                currentText: message,
                isUppercased: state.isUppercased,
              )),
        )
        .on<void>(
          toggleUppercase,
          Update<UppercaseModel, void>.regular((UppercaseModel state) => UppercaseModel(
                currentText: state.currentText,
                isUppercased: !state.isUppercased,
              )),
        )
        .reset(resetUppercase);

class UppercaseScreen extends EffectorWidget {
  @override
  Widget build(BuildContext context) {
    final UppercaseModel value = useStore(uppercaseStore);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: updateText,
            ),
            const SizedBox(height: 20),
            Text(
              value.isUppercased
                  ? value.currentText.toUpperCase()
                  : value.currentText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: toggleUppercase,
              child: const Text('Toggle uppercase'),
            )
          ],
        ),
      ),
    );
  }
}
