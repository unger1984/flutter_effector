import 'package:flutter/material.dart';
import 'package:flutter_effector/flutter_effector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: CounterScreen());
}

final increment = createEvent('increment');
final decrement = createEvent('decrement');
final resetCounter = createEvent('reset counter');

final counter = createStore<int>(0)
    .on<dynamic>(increment, (state, {message}) => state + 1)
    .on<dynamic>(decrement, (state, {message}) => state - 1)
    .reset(resetCounter);

class CounterScreen extends EffectorWidget {
  @override
  Widget build(BuildContext context) {
    final value = useStore(counter);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value.toString()),
            OutlinedButton(
              onPressed: () {
                increment(null);
              },
              child: Text('Increment'),
            ),
            OutlinedButton(
              onPressed: () {
                decrement(null);
              },
              child: Text('Decrement'),
            ),
            OutlinedButton(
              onPressed: () {
                resetCounter(null);
              },
              child: Text('Reset'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UppercaseScreen()),
              ),
              child: Text('Navigate to uppercase'),
            ),
          ],
        ),
      ),
    );
  }
}

class UppercaseModel {
  final String currentText;
  final bool isUppercased;
  UppercaseModel({required this.currentText, required this.isUppercased});
}

final updateText = createEvent<String>("update text");
final toggleUppercase = createEvent("toggle uppercase");
final resetUppercase = createEvent("reset uppercase");

final uppercaseStore =
    createStore(UppercaseModel(currentText: "", isUppercased: false))
        .on<String>(
          updateText,
          (state, {message}) => UppercaseModel(
            currentText: message ?? '',
            isUppercased: state.isUppercased,
          ),
        )
        .on<void>(
          toggleUppercase,
          (state, {message}) => UppercaseModel(
            currentText: state.currentText,
            isUppercased: !state.isUppercased,
          ),
        )
        .reset(resetUppercase);

class UppercaseScreen extends EffectorWidget {
  @override
  Widget build(BuildContext context) {
    final value = useStore(uppercaseStore);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: updateText,
            ),
            SizedBox(height: 20),
            Text(
              value.isUppercased
                  ? value.currentText.toUpperCase()
                  : value.currentText,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                toggleUppercase(null);
              },
              child: Text("Toggle uppercase"),
            )
          ],
        ),
      ),
    );
  }
}
