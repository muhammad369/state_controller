import 'package:flutter/material.dart';
import 'package:state_controller/state_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StateProvider(
      controller: Controller(),
      view: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    //var controller = Provider.of<Controller>(context);
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
            Obx(controller.list, () => SizedBox(height: 200, child: ListView(children: controller.list.value.map((i) => Text('$i')).toList()))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Controller {
  Rx<int> counter = 0.obs;
  Rx<List<int>> list = [0].obs;

  void increment() {
    counter.value++;
    list.value.add(counter.value);
    list.update();
  }
}
