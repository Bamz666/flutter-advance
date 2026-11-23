import 'package:eatik_app/app/app.dart';
import 'package:eatik_app/features/menu/presentation/providers/antrian_dapur_provider.dart';
import 'package:eatik_app/features/menu/presentation/widgets/menu_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('menampilkan daftar menu dan antrian dapur', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          antrianDapurProvider.overrideWith((ref) => Stream.value(0)),
        ],
        child: const EatikApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Menu Eatik'), findsOneWidget);
    expect(find.text('Antrian 0'), findsOneWidget);
    expect(find.byType(MenuCard), findsWidgets);
  });
}
