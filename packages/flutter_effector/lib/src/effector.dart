import 'package:effector/effector.dart';
import 'package:flutter/material.dart';

/// TODO: Remove this variable
final Map<EffectorWidget, Store> _watchers = <EffectorWidget, Store>{};

abstract class EffectorWidget extends StatefulWidget {
  T useStore<T>(Store<T> store) {
    _watchers[this] = store;
    return store.value;
  }

  Widget build(BuildContext context);

  @override
  _EffectorState createState() => _EffectorState();
}

class _EffectorState extends State<EffectorWidget> {
  @override
  Widget build(BuildContext context) {
    final Widget builded = widget.build(context);

    final Store? foundWatcher = _watchers[widget];

    if (foundWatcher != null) {
      foundWatcher.watch((dynamic state) {
        setState(() {});
      });
    }

    return builded;
  }
}
