
# State Controller

Liked the way GetX manages state, but don't want to use a big framework that does everything?
few lines of code with no dependency, wrapping `InheritedWidget` and `StreamBuilder` 

```dart
// provide the controller in higher point of the widgets tree
StateProvider(
  controller: Controller(),
  view: MaterialApp(
    home: const MyHomePage(),
  )
)
```

```dart
// controller
class Controller {
  Rx<int> counter = 0.obs;
  void increment() {
    counter.value++;
  }
}
```

```dart
// view
@override
Widget build(BuildContext context) {
  Controller controller = context.get();
  //
  return Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(title)),
    body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('You have pushed the button this many times:'),
        Obx(
          controller.counter,
          () => Text('${controller.counter.value}', style: Theme.of(context).textTheme.headlineMedium),
        ),
      ],
    ),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: controller.increment,
    tooltip: 'Increment',
    child: const Icon(Icons.add),
    ), 
  );
}

```