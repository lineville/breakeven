import 'package:flutter/cupertino.dart';

class GameState {
  final int count;
  final String action;
  List<PlayingCard> userCards;
  List<PlayingCard> dealerCards;

  GameState({this.count = 100, this.action = "...", this.userCards = const <PlayingCard>[], this.dealerCards = const <PlayingCard>[]});

  GameState copyWith({count, action, userCards, dealerCards}) {
    return new GameState(
      count: count ?? this.count,
      action: action ?? this.action,
      userCards: userCards ?? this.userCards,
      dealerCards: dealerCards ?? this.dealerCards,
    );
  }
}

class PlayingCard {
  final int value;
  final String name;
  final String suite;
  int optionalValue;

  PlayingCard({ this.value,  this.name,  this.suite}) {
    optionalValue = value == 11 ? 1 : null;
  }

  String image() {
    if (this.value > 9) {
      return this.name[0] + this.suite;
    } else {
      return this.value.toString() + this.suite;
    }
  }
}
