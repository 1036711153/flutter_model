import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => new Counter(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => new Counter2(),
        ),
      ],
      child: ProviderDemoHome(),
    );
  }
}

class ProviderDemoHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BlocDemo'),
      ),
      body: CounterHomeWapper(),
      floatingActionButton: FloatingActionButtonWrapper(),
    );
  }
}

class FloatingActionButtonWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Counter, Counter2>(
      builder:
          (BuildContext context, Counter model, Counter2 model2, Widget child) {
        return FloatingActionButton(
          onPressed: () {
            model.increment();
            model2.increment();
          },
          child: Text('${model.count},' + '${model2.count}'),
        );
      },
    );
  }
}

class CounterHomeWapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Counter model = Provider.of<Counter>(context);
    final Counter2 model2 = Provider.of<Counter2>(context);
    return Center(
      child: ActionChip(
        label: Text('${model.count},' + '${model2.count}'),
        onPressed: () {
          model.increment();
          model2.increment();
        },
      ),
    );
  }
}

class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class Counter2 with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    _count++;
    notifyListeners();
  }
}

