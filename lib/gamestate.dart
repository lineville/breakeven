import 'package:flutter/rendering.dart';

class GameState {
  List<PlayingCard> deck;
  List<PlayingCard> userCards;
  List<PlayingCard> dealerCards;
  List<PlayingCard> leftHand;
  List<PlayingCard> rightHand;

  int balance;
  int bet;
  int insuranceBet;
  int deckCount;
  int handsPlayed;
  int correctDecisions;

  bool peekDealer;
  bool locked;
  bool splitAvailable;
  bool splitHands;
  bool hintOn;
  bool userWon;
  bool push;
  bool leftHandComplete;
  bool rightHandComplete;
  bool infoMessageOn;
  bool infoTipOn;
  bool insuranceAvailable;
  bool insuranceAccepted;
  bool insuranceWon;
  bool doubledDown;

  String hint;
  Color hintColor;

  GameState({
    this.deck = const <PlayingCard>[],
    this.userCards = const <PlayingCard>[],
    this.dealerCards = const <PlayingCard>[],
    this.leftHand = const <PlayingCard>[],
    this.rightHand = const <PlayingCard>[],
    this.balance = 110,
    this.bet = 10,
    this.insuranceBet = 5,
    this.deckCount = 0,
    this.handsPlayed = 1,
    this.correctDecisions = 1,
    this.peekDealer = false,
    this.locked = false,
    this.splitAvailable = false,
    this.splitHands = false,
    this.hintOn = false,
    this.userWon = false,
    this.push = false,
    this.leftHandComplete = false,
    this.rightHandComplete = false,
    this.infoMessageOn = false,
    this.infoTipOn = false,
    this.insuranceAvailable = false,
    this.insuranceAccepted = false,
    this.insuranceWon = false,
    this.doubledDown = false,
    this.hint = "Default Hint",
    this.hintColor = const Color(0xFFFFFF),
  });

  GameState copyWith({
    deck,
    userCards,
    dealerCards,
    leftHand,
    rightHand,
    balance,
    bet,
    insuranceBet,
    deckCount,
    handsPlayed,
    correctDecisions,
    peekDealer,
    locked,
    splitAvailable,
    splitHands,
    hintOn,
    userWon,
    push,
    leftHandComplete,
    rightHandComplete,
    infoMessageOn,
    infoTipOn,
    insuranceAvailable,
    insuranceAccepted,
    insuranceWon,
    doubledDown,
    hint,
    hintColor
  }) {
    return new GameState(
      deck: deck ?? this.deck,
      userCards: userCards ?? this.userCards,
      dealerCards: dealerCards ?? this.dealerCards,
      leftHand: leftHand ?? this.leftHand,
      rightHand: rightHand ?? this.rightHand,
      balance: balance ?? this.balance,
      bet: bet ?? this.bet,
      insuranceBet: insuranceBet ?? this.insuranceBet,
      deckCount: deckCount ?? this.deckCount,
      handsPlayed: handsPlayed ?? this.handsPlayed,
      correctDecisions: correctDecisions ?? this.correctDecisions,
      peekDealer: peekDealer ?? this.peekDealer,
      locked: locked ?? this.locked,
      splitAvailable: splitAvailable ?? this.splitAvailable,
      splitHands: splitHands ?? this.splitHands,
      hintOn: hintOn ?? this.hintOn,
      userWon: userWon ?? this.userWon,
      push: push ?? this.push,
      leftHandComplete: leftHandComplete ?? this.leftHandComplete,
      rightHandComplete: rightHandComplete ?? this.rightHandComplete,
      infoMessageOn: infoMessageOn ?? this.infoMessageOn,
      infoTipOn: infoTipOn ?? this.infoTipOn,
      insuranceAvailable: insuranceAvailable ?? this.insuranceAvailable,
      insuranceAccepted: insuranceAccepted ?? this.insuranceAccepted,
      insuranceWon: insuranceWon ?? this.insuranceWon,
      doubledDown: doubledDown ?? this.doubledDown,
      hint: hint ?? this.hint,
      hintColor: hintColor ?? this.hintColor,
    );
  }

}

class PlayingCard {
  final int value;
  final String name;
  final String suite;
  int optionalValue;

  PlayingCard({this.value, this.name, this.suite}) {
    optionalValue = value == 11 ? 1 : null;
  }

  String image() {
    if (this.value > 9 && this.name != "Ten") {
      return this.name[0] + this.suite;
    } else {
      return this.value.toString() + this.suite;
    }
  }
}
