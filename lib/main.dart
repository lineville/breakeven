import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'blackjack.dart';
import 'gamestate.dart';


void main() {
  final store = new Store<GameState>(reducer, initialState: GameState());

  runApp(MyApp(
    title: 'BlackJack',
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final String title;
  final Store store;

  MyApp({ Key key, this.store, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(store : this.store, title: this.title),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final Store store;

  MyHomePage({Key key, this.store, this.title}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
      ),
      body: BlackJack(store: store),
    );
  }
}

