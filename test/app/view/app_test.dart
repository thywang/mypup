import 'package:flutter_test/flutter_test.dart';
import 'package:my_pup_simple/src/app/app.dart';
import 'package:my_pup_simple/home/home.dart';

void main() {
  group('App', () {
    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
