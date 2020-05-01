import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'gamestate.dart';

enum Actions { Hit, Stay, Split, Double }

GameState reducer(GameState state, dynamic action) {
  switch (action) {
    case Actions.Hit:
      {
        return state.copyWith(
            action: 'Hit',
            count: state.count + 1,
            userCards: state.userCards.length < 8 ? [
              ...state.userCards,
              PlayingCard(value: 11, name: "Ace", suite: "S")
            ] : state.userCards);
      }
      break;

    case Actions.Stay:
      {
        return state.copyWith(
            action: 'Stay',
            count: state.count - 1,
            dealerCards: state.dealerCards.length < 8 ? [
              ...state.dealerCards,
              PlayingCard(value: 10, name: "King", suite: "S")
            ] : state.dealerCards);
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

    default:
      {
        return state;
      }
      break;
  }
}

class BlackJack extends StatelessWidget {
  final Store<GameState> store;
  final int maxCardsPerRow = 4;

  BlackJack({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GameState>(
      store: store,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new StoreConnector<GameState, List<PlayingCard>>(
                  converter: (store) => store.state.dealerCards.toList(),
                  builder: (context, dealerCards) {
                    if (dealerCards.length > maxCardsPerRow) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: dealerCards
                                .sublist(0, maxCardsPerRow)
                                .map((card) => playingCard(
                                    context, card, dealerCards.length))
                                .toList(),
                          ),
                          Row(
                            children: dealerCards
                                .sublist(maxCardsPerRow)
                                .map((card) => playingCard(
                                    context, card, dealerCards.length))
                                .toList(),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: dealerCards
                          .map((card) =>
                              playingCard(context, card, dealerCards.length))
                          .toList(),
                    );
                  },
                ),
                new StoreConnector<GameState, List<PlayingCard>>(
                  converter: (store) => store.state.userCards.toList(),
                  builder: (context, userCards) {
                    if (userCards.length > maxCardsPerRow) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: userCards
                                .sublist(0, maxCardsPerRow)
                                .map((card) => playingCard(
                                    context, card, userCards.length))
                                .toList(),
                          ),
                          Row(
                            children: userCards
                                .sublist(maxCardsPerRow)
                                .map((card) => playingCard(
                                    context, card, userCards.length))
                                .toList(),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: userCards
                          .map((card) =>
                              playingCard(context, card, userCards.length))
                          .toList(),
                    );
                  },
                ),
                new StoreConnector<GameState, String>(
                  converter: (store) => store.state.count.toString(),
                  builder: (context, count) {
                    return new Text(
                      "Balance: \$" + count,
                      style: Theme.of(context).textTheme.display1,
                    );
                  },
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controlBar(context),
          ),
        ),
      ),
    );
  }

  List<Widget> controlBar(BuildContext context) {
    return <Widget>[
      // Stay
      StoreConnector<GameState, VoidCallback>(
          converter: (store) => () => store.dispatch(Actions.Stay),
          builder: (context, callback) {
            return new RaisedButton(
                color: Color.fromRGBO(255, 87, 51, 0.5),
                padding: EdgeInsets.all(4.0),
                onPressed: callback,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        FontAwesomeIcons.handPaper,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("Stay",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ));
          }),

      // Split
      StoreConnector<GameState, VoidCallback>(
          converter: (store) => () => store.dispatch(Actions.Split),
          builder: (context, callback) {
            return new RaisedButton(
                color: Color.fromRGBO(219, 255, 51, 0.5),
                padding: EdgeInsets.all(4.0),
                onPressed: callback,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("Split",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ));
          }),

      // Double Down
      StoreConnector<GameState, VoidCallback>(
          converter: (store) => () => store.dispatch(Actions.Double),
          builder: (context, callback) {
            return new RaisedButton(
                color: Color.fromRGBO(117, 255, 51, 0.5),
                padding: EdgeInsets.all(4.0),
                onPressed: callback,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        FontAwesomeIcons.coins,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("Double",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ));
          }),

      // Hit
      StoreConnector<GameState, VoidCallback>(
          converter: (store) => () => store.dispatch(Actions.Hit),
          builder: (context, callback) {
            return new RaisedButton(
                color: Color.fromRGBO(51, 255, 189, 0.5),
                padding: EdgeInsets.all(4.0),
                onPressed: callback,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        FontAwesomeIcons.handHoldingMedical,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("Hit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ));
          }),
    ];
  }

  Widget playingCard(BuildContext context, PlayingCard card, int cards) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image(
              image: AssetImage('assets/images/' + card.image() + '.jpg'),
              width: 75,
              height: 110,
              fit: BoxFit.fill),
        ));
  }
}
