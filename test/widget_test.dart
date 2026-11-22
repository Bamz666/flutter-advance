import 'package:eatik_app/app/app.dart';
import 'package:eatik_app/features/menu/presentation/widgets/menu_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('menampilkan daftar menu', (tester) async {
    await tester.pumpWidget(const EatikApp());
    await tester.pumpAndSettle();

    expect(find.text('Menu Eatik'), findsOneWidget);
    expect(find.byType(MenuCard), findsWidgets);
  });
}
