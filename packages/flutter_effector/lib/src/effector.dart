import 'package:flutter/material.dart';

import 'package:effector/effector.dart';

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
    final builded = widget.build(context);

    final foundWatcher = _watchers[widget];

    if (foundWatcher != null) {
      foundWatcher._updaters[widget] = () => setState(() {});
    }

    return builded;
  }
}