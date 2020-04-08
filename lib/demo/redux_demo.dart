import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ReduxDemo extends StatelessWidget {
  final store =
      Store<CountState>(reducer, initialState: CountState.initState());

  @override
  Widget build(BuildContext context) {
    return StoreProvider<CountState>(store: store, child: ReduxDemoHome());
  }
}

class ReduxDemoHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ReduxDemo'),
      ),
      body: CounterHomeWapper(),
      floatingActionButton: FloatingActionButtonWrapper(),
    );
  }
}

class FloatingActionButtonWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<CountState, VoidCallback>(
      converter: (store) {
        return () => store.dispatch(Action.increment);
      },
      builder: (context, callback) {
        return FloatingActionButton(
          onPressed: callback,
          child: StoreConnector<CountState, int>(
            converter: (store) => store.state.count,
            builder: (context, count) {
              return Text(count.toString());
            },
          ),
        );
      },
    );
  }
}

class CounterHomeWapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StoreConnector<CountState, int>(
        converter: (store) => store.state.count,
        builder: (context, count) {
          return StoreConnector<CountState,VoidCallback>(
            converter: (store){
              return ()=>store.dispatch(Action.increment);
            },
            builder: (context,callback){
              return ActionChip(
                label:Text(count.toString(),
                  style: Theme.of(context).textTheme.display1, ),
                onPressed: callback,
              );
            },
          );
        },
      ),
    );
  }
}

enum Action { increment }

@immutable
class CountState {
  int _count = 0;

  get count => _count;

  CountState(this._count);

  CountState.initState() : _count = 0;
}

CountState reducer(CountState state, action) {
  switch (action) {
    case Action.increment:
      return CountState(state.count + 1);
  }
}
