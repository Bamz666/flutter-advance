import 'package:eatik_app/app/theme/app_theme.dart';
import 'package:eatik_app/features/menu/presentation/pages/menu_page.dart';
import 'package:flutter/material.dart';

class EatikApp extends StatelessWidget {
  const EatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eatik',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const MenuPage(),
    );
  }
}
