import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'gamestate.dart';

enum Actions { Hit, Stay, Split, Double, Increment, Decrement }

GameState reducer(GameState state, dynamic action) {
  switch (action) {
    case Actions.Hit:
      {
        return state.copyWith(action: 'Hit');
      }
      break;

    case Actions.Stay:
      {
        return state.copyWith(action: 'Stay');
      }
      break;

    case Actions.Split:
      {
        return state.copyWith(action: 'Split');
      }
      break;

    case Actions.Double:
      {
        return state.copyWith(action: 'Double');
      }
      break;
    case Actions.Increment:
      {
        return state.copyWith(count: state.count + 1, action: 'Increment');
      }
      break;
    case Actions.Decrement:
      {
        return state.copyWith(count: state.count - 1, action: 'Decrement');
      }
      break;

    default:
      {
        return state;
      }
      break;
  }
}

class BlackJack extends StatelessWidget {
  final Store<GameState> store;

  BlackJack({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GameState>(
        store: store,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Action:',
                ),
                new StoreConnector<GameState, String>(
                    converter: (store) => store.state.action.toString(),
                    builder: (context, action) {
                      return Text(
                        action,
                        style: Theme.of(context).textTheme.display1,
                      );
                    }),
                Text(
                  'Count:',
                ),
                new StoreConnector<GameState, String>(
                    converter: (store) => store.state.count.toString(),
                    builder: (context, count) {
                      return Text(
                        count,
                        style: Theme.of(context).textTheme.display1,
                      );
                    }),
                ButtonBar(
                  children: <Widget>[
                    // Decrement
                    StoreConnector<GameState, VoidCallback>(
                        converter: (store) => () => store.dispatch(Actions.Decrement),
                        builder: (context, callback) {
                          return new FlatButton(
                            onPressed: callback,
                            child: Icon(Icons.remove),
                          );
                        }),
                     // Increment
                    StoreConnector<GameState, VoidCallback>(
                        converter: (store) => () => store.dispatch(Actions.Increment),
                        builder: (context, callback) {
                          return new FlatButton(
                            onPressed: callback,
                            child: Icon(Icons.add),
                          );
                        }),
                    // Split
                    StoreConnector<GameState, VoidCallback>(
                        converter: (store) =>
                            () => store.dispatch(Actions.Split),
                        builder: (context, callback) {
                          return new FlatButton(
                            onPressed: callback,
                            child: Text('Split'),
                          );
                        }),
                    // Stay
                    StoreConnector<GameState, VoidCallback>(
                        converter: (store) =>
                            () => store.dispatch(Actions.Stay),
                        builder: (context, callback) {
                          return new FlatButton(
                            onPressed: callback,
                            child: Text('Stay'),
                          );
                        }),
                    // Hit
                    StoreConnector<GameState, VoidCallback>(
                        converter: (store) => () => store.dispatch(Actions.Hit),
                        builder: (context, callback) {
                          return new FlatButton(
                            onPressed: callback,
                            child: Text('Hit'),
                          );
                        }),
                    // Double Down
                    StoreConnector<GameState, VoidCallback>(
                        converter: (store) =>
                            () => store.dispatch(Actions.Double),
                        builder: (context, callback) {
                          return new FlatButton(
                            onPressed: callback,
                            child: Text('Double'),
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
