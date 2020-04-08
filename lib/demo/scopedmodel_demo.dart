import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ScopedModelDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MixModel>(
      model: MixModel(),
      child: ScopedModelHome(),
    );
  }
}

class ScopedModelHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScopedModelDemo'),
      ),
      body: CounterHome(),
      floatingActionButton: FloatingActionButtonWrapper(),
    );
  }
}

class FloatingActionButtonWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MixModel>(
      builder: (BuildContext context, Widget child, MixModel model) {
        return FloatingActionButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${model.count}'),
              model.iconWidget,
            ],
          ),
          onPressed: () {
            model.change();
          },
        );
      },
    );
  }
}

class CounterHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CounterWrapper(),
    );
  }
}

class CounterWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MixModel>(
      builder: (BuildContext context, Widget child, MixModel model) {
        print('ScopedModelDescendant CounterWrapper build');
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            model.iconWidget,
            ActionChip(
              label: Text('${model.count}'),
              onPressed: () {
                model.change();
              },
            )
          ],
        );
      },
    );
  }
}

class MixModel extends Model with CounterModel, IconModel {
  void change() {
    increment();
    changeIcon(count);
    notifyListeners();
  }
}

class CounterModel extends Object {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
  }
}

class IconModel extends Object {
  Widget _iconWidget = Icon(Icons.title);

  Widget get iconWidget => _iconWidget;

  void changeIcon(int count) {
    _iconWidget = count % 2 == 0 ? Icon(Icons.ac_unit) : Icon(Icons.title);
  }
}
