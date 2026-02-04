import 'dart:async';
import 'package:flutter/cupertino.dart';

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
  T _value;
  final StreamController<T> _controller;
  Rx(T seed) : _value = seed, _controller = StreamController<T>.broadcast();
  //Stream<T> get stream => _controller.stream;

  T get value => _value;

  set value(T v) {
    _value = v;
    _controller.add(v);
  }

  // stream that immediately emits current value, then subsequent updates
  Stream<T> get stream async* {
    yield _value;
    yield* _controller.stream;
  }

  // subscribe convenience
  StreamSubscription<T> listen(
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  Future<void> close() => _controller.close();

  void update() {
    _controller.add(_value);
  }
}

extension ObservableObjectExt<O> on O {
  Rx<O> get obs => Rx<O>(this);
}

class Obx<S> extends StatelessWidget {
  final Rx<S> rx;
  final Widget Function() builder;

  const Obx(this.rx, this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: rx.stream, initialData: rx.value, builder: (context, snapshot) => builder());
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
