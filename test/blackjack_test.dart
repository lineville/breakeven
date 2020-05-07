import 'package:flutter_test/flutter_test.dart';
import 'package:BreakEven/main.dart';
import 'package:redux/redux.dart';
import 'package:BreakEven/gamestate.dart';
import 'package:BreakEven/blackjack.dart';

void main() {
  testWidgets('Black Jack Buttons', (WidgetTester tester) async {
    final store = new Store<GameState>(reducer, initialState: GameState());

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      title: 'BlackJack',
      store: store,
    ));

    expect(find.text('Hit'), findsOneWidget);
    expect(find.text('Stay'), findsOneWidget);
    expect(find.text('Split'), findsOneWidget);
    expect(find.text('Double'), findsOneWidget);
  });

  group('computeScore', () {
    test('should be 21', () {
      List<PlayingCard> hand = new List<PlayingCard>();
      hand.add(PlayingCard(name: "Ace", value: 11, suite: 'H'));
      hand.add(PlayingCard(name: "King", value: 10, suite: 'H'));
      expect(computeScore(hand), 21);
    });

    test('should be 16', () {
      List<PlayingCard> hand = new List<PlayingCard>();
      hand.add(PlayingCard(name: "Ace", value: 11, suite: 'H'));
      hand.add(PlayingCard(name: "King", value: 10, suite: 'H'));
      hand.add(PlayingCard(name: "Five", value: 5, suite: 'H'));
      expect(computeScore(hand), 16);
    });
  });

  group('cardCount', () {
    test('should be -1', () {
      expect(cardCount(PlayingCard(name: "Jack", value: 10, suite: 'H')), -1);
    });

    test('should be 0', () {
      expect(cardCount(PlayingCard(name: "Eight", value: 8, suite: 'H')), 0);
    });

    test('should be 1', () {
      expect(cardCount(PlayingCard(name: "Five", value: 5, suite: 'H')), 1);
    });
  });

  group('isHardHand', () {
    test('should be false', () {
      List<PlayingCard> hand = new List<PlayingCard>();
      hand.add(PlayingCard(name: "Ace", value: 11, suite: 'H'));
      hand.add(PlayingCard(name: "Seven", value: 7, suite: 'H'));
      expect(isHardHand(hand), false);
    });

    test('should be true', () {
      List<PlayingCard> hand = new List<PlayingCard>();
      hand.add(PlayingCard(name: "Ten", value: 10, suite: 'H'));
      hand.add(PlayingCard(name: "Seven", value: 7, suite: 'H'));
      expect(isHardHand(hand), true);
    });
  });

  group('isBusted', () {
    test('should be true', () {
      List<PlayingCard> hand = new List<PlayingCard>();
      hand.add(PlayingCard(name: "Ten", value: 10, suite: 'H'));
      hand.add(PlayingCard(name: "Seven", value: 7, suite: 'H'));
      hand.add(PlayingCard(name: "Seven", value: 7, suite: 'H'));
      expect(isBusted(hand), true);
    });

    test('should be true', () {
      List<PlayingCard> hand = new List<PlayingCard>();
      hand.add(PlayingCard(name: "Ten", value: 10, suite: 'H'));
      hand.add(PlayingCard(name: "Seven", value: 7, suite: 'H'));
      hand.add(PlayingCard(name: "Ace", value: 11, suite: 'H'));
      expect(isBusted(hand), false);
    });
  });



}
