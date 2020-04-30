import 'package:flutter/foundation.dart';
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

    // Tap the Hit button and trigger a frame.
    await tester.tap(find.text('Hit'));
    await tester.pump();
    expect(store.state.action, 'Hit');
    expect(find.text('Hit'), findsNWidgets(2));

    // Tap the Stay button and trigger a frame.
    await tester.tap(find.text('Stay'));
    await tester.pump();
    expect(store.state.action, 'Stay');
    expect(find.text('Stay'), findsNWidgets(2));

    // Tap the Split button and trigger a frame.
    await tester.tap(find.text('Split'));
    await tester.pump();
    expect(store.state.action, 'Split');
    expect(find.text('Split'), findsNWidgets(2));


    // Tap the Double button and trigger a frame.
    await tester.tap(find.text('Double'));
    await tester.pump();
    expect(store.state.action, 'Double');
    expect(find.text('Double'), findsNWidgets(2));

  });
}
