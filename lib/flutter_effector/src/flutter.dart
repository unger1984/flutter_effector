part of flutter_effector;

/// TODO: Remove this variable
final _watchers = <EffectorWidget, _Store>{};

abstract class EffectorWidget extends StatefulWidget {
  T useStore<T>(_Store<T> store) {
    _watchers[this] = store;
    return store.value;
  }

  Widget build(BuildContext context);

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