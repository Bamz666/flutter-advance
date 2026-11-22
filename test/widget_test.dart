import 'package:eatik_app/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('menampilkan halaman awal Eatik', (tester) async {
    await tester.pumpWidget(const EatikApp());

    expect(find.text('Eatik App'), findsOneWidget);
  });
}
