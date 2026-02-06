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

extension ObservableListExt<T> on List<T> {
  RxList<T> get obs => RxList<T>(this);
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

class RxList<T> extends Rx<List<T>>{
  RxList(super.seed);

  int get length => _value.length;

  T get first => _value.first;

  T get last => _value.last;

  Iterable<Y> map<Y>(Y Function(T) toElement) => _value.map(toElement);

  List<Widget> mapToWidgets(Widget Function(T) toWidget) => _value.map((i)=> toWidget(i)).toList();

  T operator[](int index)=> _value[index];

  void operator []=(int index, T value){
    _value[index] = value;
    update();
  }

  void add(T item){
    _value.add(item);
    update();
  }

  void addAll(Iterable<T> item){
    _value.addAll(item);
    update();
  }

  void clear(){
    _value.clear();
    update();
  }

  void insert(int index, T element){
    _value.insert(index, element);
    update();
  }

  void insertAll(int index, Iterable<T> elements){
    _value.insertAll(index, elements);
    update();
  }

  void setAll(int index, Iterable<T> elements){
    _value.setAll(index, elements);
    update();
  }

  void remove(T? item){
    _value.remove(item);
    update();
  }

  T removeAt(int index){
    var i =_value.removeAt(index);
    update();
    return i;
  }

  T removeLast(){
    var i =_value.removeLast();
    update();
    return i;
  }

  void removeWhere(bool Function(T element) test){
    _value.removeWhere(test);
    update();
  }

  void retainWhere(bool Function(T element) test){
    _value.retainWhere(test);
    update();
  }

  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]){
    _value.setRange(start, end, iterable, skipCount);
    update();
  }

  void removeRange(int start, int end){
    _value.removeRange(start, end);
    update();
  }

  void fillRange(int start, int end, [T? fillValue]){
    _value.fillRange(start, end, fillValue);
    update();
  }

  void replaceRange(int start, int end, Iterable<T> replacements){
    _value.replaceRange(start, end, replacements);
    update();
  }

}