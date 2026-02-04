import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class StateProvider<C> extends InheritedWidget {
  final C controller;

  const StateProvider({required Widget view, required this.controller, super.key}) : super(child: view);

  // Called when dependents should rebuild if data changed.
  @override
  bool updateShouldNotify(covariant StateProvider oldWidget) {
    return oldWidget.controller != controller;
  }

  // Convenience static method to access the nearest instance.
  static Controller of<Controller>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StateProvider<Controller>>()!.controller;
  }
}

extension ContextExt<Controller> on BuildContext {
  Controller get<Controller>() {
    return dependOnInheritedWidgetOfExactType<StateProvider<Controller>>()!.controller;
  }
}

class Rx<T> {
  late BehaviorSubject<T> _subject;
  Rx(T value) {
    this._subject = BehaviorSubject.seeded(value);
  }

  ValueStream<T> get stream => _subject.stream;

  T get value => _subject.value;

  set value(T v) => _subject.add(v);
}

extension ObservableObjectExt<O> on O {
  Rx<O> get obs => Rx<O>(this);
}

class Obx<S> extends StatelessWidget {
  final Rx<S> rx;
  final Widget Function() builder;

  const Obx(this.rx, this.builder, {super.key,});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: rx.stream,
      initialData: rx.value,
      builder: (context, snapshot) => builder(),
    );
  }
}

class ObxValue<S> extends StatelessWidget {
  final Rx<S> rx;
  final Widget Function(BuildContext context, S? value) builder;

  const ObxValue({super.key, required this.rx, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: rx.stream,
      initialData: rx.value,
      builder: (context, snapshot) => builder(context, snapshot.data),
    );
  }
}
