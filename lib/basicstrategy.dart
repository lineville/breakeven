import 'dart:core';
import 'package:BreakEven/gamestate.dart';
import 'package:BreakEven/blackjack.dart';

enum Decision { Hit, Stay, Double, Split }

enum Suite { Hearts, Diamonds, Clubs, Spades }

final List<List<bool>> splitTable = [
  [false, false, true, true, true, true, false, false, false, false],
  [false, false, true, true, true, true, false, false, false, false],
  [false, false, false, false, false, false, false, false, false, false],
  [false, false, false, false, false, false, false, false, false, false],
  [true, true, true, true, true, false, false, false, false, false],
  [true, true, true, true, true, true, false, false, false, false],
  [true, true, true, true, true, true, true, true, true, true],
  [true, true, true, true, true, false, true, true, false, false],
  [false, false, false, false, false, false, false, false, false, false],
  [true, true, true, true, true, true, true, true, true, true],
];

final List<List<Decision>> softTable = [
  [
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Double,
    Decision.Double,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Double,
    Decision.Double,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Hit,
    Decision.Hit,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Hit,
    Decision.Hit,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Hit,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Stay,
    Decision.Stay,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Double,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay
  ],
  [
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay
  ],
];

final List<List<Decision>> hardTable = [
  [
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Hit,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Hit,
    Decision.Hit,
  ],
  [
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
    Decision.Double,
  ],
  [
    Decision.Hit,
    Decision.Hit,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit,
    Decision.Hit
  ],
  [
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay,
    Decision.Stay
  ],
];

bool shouldHit(List<PlayingCard> hand, PlayingCard dealerUpCard) {
  if (isHardHand(hand)) {
    return hardTable[computeScore(hand) - 8][dealerUpCard.value - 2] ==
            Decision.Hit ||
        hardTable[computeScore(hand) - 8][dealerUpCard.value - 2] ==
            Decision.Double;
  } else {
    List<PlayingCard> hardCards = hand.where((c) => c.name == "Ace");
    return softTable[computeScore(hardCards) - 2][dealerUpCard.value - 2] ==
            Decision.Hit ||
        softTable[computeScore(hardCards) - 2][dealerUpCard.value - 2] ==
            Decision.Double;
  }
}

bool shouldSplit(List<PlayingCard> hand, PlayingCard dealerUpCard) {
  if (hand.length == 2 && hand[0].name == hand[1].name) {
    return splitTable[hand[0].value - 2][dealerUpCard.value - 2];
  }

  return false;
}

bool shouldDouble(List<PlayingCard> hand, PlayingCard dealerUpCard) {
  if (hand.length == 2) {
    if (hand.where((c) => c.name == "Ace").length > 0) {
      PlayingCard notAce = hand.where((c) => c.name != "Ace").toList()[0];
      return softTable[notAce.value - 2][dealerUpCard.value - 2] == Decision.Double;
    } else {
      if (computeScore(hand) < 9 || computeScore(hand) > 11) {
        return false;
      }
      return hardTable[computeScore(hand) - 8][dealerUpCard.value - 2] == Decision.Double;
    }
  }

  return false;
}

Decision decideMove(List<PlayingCard> hand, PlayingCard dealerUpCard, bool canSplit) {
  if (canSplit && shouldSplit(hand, dealerUpCard)) {
    return Decision.Split;
  }

  if (computeScore(hand) > 17) {
    return Decision.Stay;
  }

  if (shouldDouble(hand, dealerUpCard)) {
    return Decision.Double;
  }

  if (shouldHit(hand, dealerUpCard)) {
    return Decision.Hit;
  }

  return Decision.Stay;
}