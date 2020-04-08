import 'dart:async';

import 'package:flutter/material.dart';

class BlocDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CountBloc>(
      child: BlocDemoHome(),
      bloc: CountBloc(),
    );
  }
}

class BlocDemoHome extends StatelessWidget {
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
    final CountBloc bloc = BlocProvider.of(context);
    return StreamBuilder<int>(
        stream: bloc.stream,
        initialData: bloc.value,
        builder: (context, snapshot) {
          return FloatingActionButton(
            onPressed: () {
              bloc.increment();
            },
            child: Text('${snapshot.data}'),
          );
        });
  }
}

class CounterHomeWapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CountBloc bloc = BlocProvider.of(context);
    return Center(
      child: StreamBuilder<int>(
          stream: bloc.stream,
          initialData: bloc.value,
          builder: (context, snapshot) {
            return ActionChip(
              label: Text('${snapshot.data}'),
              onPressed: (){bloc.increment();},
            );
          }),
    );
  }
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }): super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context){
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;

}

class _BlocProviderState<T> extends State<BlocProvider> {
  @override
  void dispose(){
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return widget.child;
  }
}

abstract class BlocBase{
  void dispose();
}

class CountBloc extends BlocBase{
  int _count;
  StreamController<int> _controller;

  CountBloc() {
    _count = 0;
    _controller = new StreamController<int>.broadcast();
  }

  void dispose() {
    _controller.close();
  }

  void increment() async {
    //模拟耗时操作,实际场景经常会出现,有时候我们需要使用RxDart去除多余触发事件
    await Future.delayed(Duration(seconds: 2));
    _controller.sink.add(++_count);
  }

  Stream<int> get stream => _controller.stream;

  int get value => _count;
}
