import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'gamestate.dart';
import 'package:BreakEven/basicstrategy.dart';

enum Actions { Hit, Stay, Split, Double, DrawCard, ShuffleDeck, DealNewHand }

GameState reducer(GameState state, dynamic action) {
  switch (action) {
    case Actions.Hit:
      {
        List<PlayingCard> updatedHand = state.userCards.length < 8
            ? [...state.userCards, state.deck[0]]
            : state.userCards;

        return state.copyWith(
            userCards: updatedHand,
            deck: state.deck.length > 15
                ? state.deck.sublist(1)
                : shuffle(newDeck()),
            locked: isBusted(updatedHand),
            userWon: !isBusted(updatedHand),
            push: !isBusted(updatedHand),
            splitAvailable: false,
            hint: decisionToHint(decideMove(state.userCards, state.dealerCards[0], state.splitAvailable)));
      }
      break;

    case Actions.Stay:
      {
        return state.copyWith(
            locked: true,
            dealerCards: playOutDealerHand(state.dealerCards, state.deck),
            userWon: isBusted(state.dealerCards) ||
                computeScore(state.userCards) >
                    computeScore(state.dealerCards) ||
                computeScore(state.userCards) == 21,
            push: computeScore(state.userCards) ==
                computeScore(state.dealerCards),
            balance: isBusted(state.dealerCards) ||
                    computeScore(state.userCards) >
                        computeScore(state.dealerCards) ||
                    computeScore(state.userCards) == 21
                ? state.balance + (state.bet * (state.doubledDown ? 2 : 1))
                : computeScore(state.userCards) ==
                        computeScore(state.dealerCards)
                    ? state.balance + state.bet
                    : state.balance,
            hint: decisionToHint(decideMove(state.userCards, state.dealerCards[0], state.splitAvailable)));
      }
      break;

    case Actions.Split:
      {
        // * HANDLE ME PLZ :)
        return state;
      }
      break;

    case Actions.Double:
      {
        List<PlayingCard> updatedHand = [...state.userCards, state.deck[0]];
        return state.copyWith(
            locked: true,
            doubledDown: true,
            userCards: updatedHand,
            deck: state.deck.sublist(1),
            dealerCards:
                playOutDealerHand(state.dealerCards, state.deck.sublist(1)),
            userWon: !isBusted(updatedHand) && isBusted(state.dealerCards) ||
                computeScore(updatedHand) > computeScore(state.dealerCards) ||
                computeScore(updatedHand) == 21,
            push: computeScore(updatedHand) == computeScore(state.dealerCards),
            balance: isBusted(state.dealerCards) ||
                    computeScore(updatedHand) >
                        computeScore(state.dealerCards) ||
                    computeScore(updatedHand) == 21
                ? state.balance + (state.bet * (state.doubledDown ? 4 : 2))
                : computeScore(updatedHand) == computeScore(state.dealerCards)
                    ? state.balance + state.bet
                    : state.balance,
            hint: decisionToHint(decideMove(state.userCards, state.dealerCards[0], state.splitAvailable)));
      }
      break;

    case Actions.ShuffleDeck:
      {
        return state.copyWith(deck: shuffle(newDeck()));
      }
      break;

    case Actions.DealNewHand:
      {
        List<PlayingCard> userHand = new List<PlayingCard>();
        List<PlayingCard> dealerHand = new List<PlayingCard>();
        userHand.add(state.deck[0]);
        dealerHand.add(state.deck[1]);
        userHand.add(state.deck[2]);
        dealerHand.add(state.deck[3]);
        return state.copyWith(
          userCards: userHand,
          dealerCards: dealerHand,
          deck: state.deck.sublist(4),
          locked: false,
          splitAvailable: userHand[0].name == userHand[1].name,
          splitHands: false,
          leftHand: List<PlayingCard>(),
          rightHand: List<PlayingCard>(),
          bet: state.doubledDown ? state.bet * 2 : state.bet,
          balance: state.balance - state.bet,
          doubledDown: false
          // hint: decisionToHint(decideMove(state.userCards, state.dealerCards.length > 0 ? state.dealerCards[0] : dealerHand[0], state.splitAvailable)),
        );
      }
      break;

    default:
      {
        return state;
      }
      break;
  }
}

List<PlayingCard> playOutDealerHand(
    List<PlayingCard> hand, List<PlayingCard> deck) {
  while (!isBusted(hand) && computeScore(hand) < 17) {
    hand.add(deck[0]);
    deck = deck.sublist(1);
  }
  return hand;
}

List<PlayingCard> newDeck() {
  List<PlayingCard> result = new List<PlayingCard>();
  const suites = ['H', 'D', 'C', 'S'];
  suites.forEach((suite) => {
        for (int i = 2; i <= 14; i++) {result.add(indexToCard(i, suite))}
      });
  return result;
}

List<PlayingCard> shuffle(List<PlayingCard> deck) {
  deck.shuffle();
  return deck;
}

PlayingCard indexToCard(int index, String suite) {
  switch (index) {
    case 2:
      {
        return PlayingCard(value: 2, name: "Two", suite: suite);
      }
      break;

    case 3:
      {
        return PlayingCard(value: 3, name: "Three", suite: suite);
      }
      break;

    case 4:
      {
        return PlayingCard(value: 4, name: "Four", suite: suite);
      }
      break;

    case 5:
      {
        return PlayingCard(value: 5, name: "Five", suite: suite);
      }
      break;

    case 6:
      {
        return PlayingCard(value: 6, name: "Six", suite: suite);
      }
      break;

    case 7:
      {
        return PlayingCard(value: 7, name: "Seven", suite: suite);
      }
      break;

    case 8:
      {
        return PlayingCard(value: 8, name: "Eight", suite: suite);
      }
      break;

    case 9:
      {
        return PlayingCard(value: 9, name: "Nine", suite: suite);
      }
      break;

    case 10:
      {
        return PlayingCard(value: 10, name: "Ten", suite: suite);
      }
      break;

    case 11:
      {
        return PlayingCard(value: 10, name: "Jack", suite: suite);
      }
      break;

    case 12:
      {
        return PlayingCard(value: 10, name: "Queen", suite: suite);
      }
      break;

    case 13:
      {
        return PlayingCard(value: 10, name: "King", suite: suite);
      }
      break;

    case 14:
      {
        return PlayingCard(value: 11, name: "Ace", suite: suite);
      }
      break;
    default:
      {
        return PlayingCard(value: 11, name: "Ace", suite: suite);
      }
      break;
  }
}

int computeScore(List<PlayingCard> hand) {
  int highestScore = hand.fold(0, (p, c) => p + c.value);
  if (highestScore <= 21) {
    return highestScore;
  }

  int numAces =
      hand.where((card) => card.optionalValue != null).toList().length;

  for (int i = 0; i < numAces; i++) {
    highestScore -= 10;
    if (highestScore <= 21) {
      return highestScore;
    }
  }
  return highestScore;
}

int cardCount(PlayingCard card) {
  if (card.value < 7) {
    return 1;
  }

  if (card.value > 9) {
    return -1;
  }

  return 0;
}

bool isHardHand(List<PlayingCard> hand) {
  if (hand.where((card) => card.name == "Ace").length == 0) {
    return true;
  } else {
    List<PlayingCard> hardCards =
        hand.where((card) => card.name != "Ace").toList();
    if (computeScore(hardCards) > 9) {
      return true;
    }
  }
  return false;
}

bool isBusted(List<PlayingCard> hand) {
  return computeScore(hand) > 21;
}

String decisionToHint(Decision decision) {
  switch (decision) {
    case Decision.Hit:
      {
        return "The smart thing to do here is to hit!";
      }

    case Decision.Stay:
      {
        return "Better to play it safe on this one and stay";
      }

    case Decision.Double:
      {
        return "Things are looking good I'd double down on this one 💰!";
      }

    case Decision.Split:
      {
        return "Splitting looks like your best option!";
      }
  }
  return "Default Hint";
}

class BlackJack extends StatelessWidget {
  final Store<GameState> store;
  final int maxCardsPerRow = 4;

  BlackJack({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.store.dispatch(Actions.ShuffleDeck);
    this.store.dispatch(Actions.DealNewHand);
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
                    return Text("Dealer Hand: " +
                        computeScore(store.state.dealerCards).toString());
                  },
                ),
                new StoreConnector<GameState, List<PlayingCard>>(
                  converter: (store) => store.state.dealerCards.toList(),
                  builder: (context, dealerCards) {
                    if (dealerCards.length > maxCardsPerRow) {
                      return Column(
                        children: <Widget>[
                          Row(
                            children: dealerCards
                                .sublist(0, maxCardsPerRow)
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              PlayingCard card = entry.value;
                              return playingCard(
                                  context,
                                  card,
                                  dealerCards.length,
                                  index == 0 && !store.state.locked);
                            }).toList(),
                          ),
                          Row(
                            children: dealerCards
                                .sublist(maxCardsPerRow)
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              PlayingCard card = entry.value;
                              return playingCard(
                                  context,
                                  card,
                                  dealerCards.length,
                                  index == 0 && !store.state.locked);
                            }).toList(),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: dealerCards.asMap().entries.map((entry) {
                        int index = entry.key;
                        PlayingCard card = entry.value;
                        return playingCard(context, card, dealerCards.length,
                            index == 0 && !store.state.locked);
                      }).toList(),
                    );
                  },
                ),
                new StoreConnector<GameState, List<PlayingCard>>(
                  converter: (store) => store.state.userCards.toList(),
                  builder: (context, userCards) {
                    return Text("Your Hand: " +
                        computeScore(store.state.userCards).toString());
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
                                    context, card, userCards.length, false))
                                .toList(),
                          ),
                          Row(
                            children: userCards
                                .sublist(maxCardsPerRow)
                                .map((card) => playingCard(
                                    context, card, userCards.length, false))
                                .toList(),
                          ),
                        ],
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: userCards
                            .map((card) => playingCard(
                                context, card, userCards.length, false))
                            .toList(),
                      ),
                    );
                  },
                ),
                new StoreConnector<GameState, String>(
                  converter: (store) => store.state.balance.toString(),
                  builder: (context, balance) {
                    return new Text(
                      "Balance: \$" + balance,
                      style: Theme.of(context).textTheme.display1,
                    );
                  },
                ),
                new StoreConnector<GameState, bool>(
                    converter: (store) => store.state.locked,
                    builder: (context, locked) {
                      if (locked) {
                        String notificationText = store.state.userWon
                            ? 'You won! 💰'
                            : store.state.push
                                ? "It's a push! 😐"
                                : "You Lost! 😭";
                        Color notificationColor = store.state.userWon
                            ? Colors.green
                            : store.state.push ? Colors.blue : Colors.red;
                        return AnimatedContainer(
                          width: 350.0,
                          height: 100.0,
                          color: notificationColor,
                          alignment: Alignment.bottomCenter,
                          duration: Duration(seconds: 1),
                          curve: Curves.bounceInOut,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(notificationText +
                                    '  Bet: \$' +
                                    store.state.bet.toString()),
                                Padding(padding: EdgeInsets.all(14.0)),
                                StoreConnector<GameState, VoidCallback>(
                                    converter: (store) => () =>
                                        store.dispatch(Actions.DealNewHand),
                                    builder: (context, callback) {
                                      return new RaisedButton(
                                          color: notificationColor,
                                          padding: EdgeInsets.all(4.0),
                                          onPressed: callback,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text("Next Hand",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Icon(
                                                  FontAwesomeIcons.chevronRight,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ));
                                    }),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container(width: 0, height: 0);
                    }),
                new StoreConnector<GameState, String>(
                    converter: (store) => store.state.hint,
                    builder: (context, hint) {
                      return Container(
                        // color: store.state.hintColor,
                        color: Color(0x000000),
                        alignment: Alignment.bottomCenter,
                        child: Text(hint),
                      );
                    })
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
                onPressed: store.state.locked ? null : callback,
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
                onPressed: !store.state.splitAvailable || store.state.splitHands
                    ? null
                    : callback,
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
                onPressed:
                    store.state.locked || store.state.userCards.length > 2
                        ? null
                        : callback,
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
                onPressed: store.state.locked ? null : callback,
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

  Widget playingCard(
      BuildContext context, PlayingCard card, int cards, bool hidden) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image(
              image: AssetImage('assets/images/' +
                  (hidden ? 'Gray_back' : card.image()) +
                  '.jpg'),
              width: 75,
              height: 110,
              fit: BoxFit.fill),
        ));
  }
}
