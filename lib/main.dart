import 'package:digiquran/presentation/screen/asmaulhusna_page.dart';
import 'package:digiquran/presentation/screen/dua_page.dart';
import 'package:digiquran/presentation/screen/home_page.dart';
import 'package:digiquran/presentation/screen/qibla_page.dart';
import 'package:digiquran/presentation/screen/quran_page.dart';
import 'package:digiquran/presentation/screen/splash_page.dart';
import 'package:digiquran/presentation/widget/navigation_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nusantara Muslim',
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (context) => const SplashPage(),
        NavigationWidget.routeName: (context) => const NavigationWidget(),
        HomePage.routeName: (context) => const HomePage(),
        QuranPage.routeName: (context) => const QuranPage(),
        DuaPage.routeName: (context) => const DuaPage(),
        AsmaulHusnaPage.routeName: (context) => const AsmaulHusnaPage(),
        QiblaPage.routeName: (context) => const QiblaPage(),
      },
    );
  }
}
