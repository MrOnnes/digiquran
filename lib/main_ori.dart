import 'package:digiquran/presentation/screen/asmaulhusna_page.dart';
import 'package:digiquran/presentation/screen/dua_page.dart';
import 'package:digiquran/presentation/screen/home_page.dart';
import 'package:digiquran/presentation/screen/intro.dart';
import 'package:digiquran/presentation/screen/qibla_page.dart';
import 'package:digiquran/presentation/screen/quran_page.dart';
import 'package:digiquran/presentation/screen/splash_page.dart';
// import 'package:digiquran/presentation/screen/video_page.dart';
// import 'package:digiquran/presentation/screen/videoplay_page.dart';
import 'package:digiquran/presentation/widget/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showAlertDialog = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(MyAlertObserver());
    checkPermission(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(MyAlertObserver());
    super.dispose();
  }

  void showMyAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selamat Datang'),
          content: Text('Ini adalah pesan selamat datang.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup AlertDialog
                // Lanjutkan dengan tindakan lain setelah AlertDialog ditutup
                // Contoh: Navigasi ke layar utama
                Navigator.of(context).pushReplacementNamed('/splash_page');
              },
            ),
          ],
        );
      },
    );
  }

  void checkPermission(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LocationPermission permission;
    bool? intro = (prefs.getBool('intro'));
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      debugPrint(
          'checkPermission location active, status prefs: ${intro.toString()}');
      prefs.setBool('intro', true);
    } else {
      debugPrint('checkPermision else $permission');
      await prominentDisclosure();
      await prefs.setBool('intro', false);
    }
    if (intro == null || !intro) {
      showMyAlertDialog(context);
    }
  }

  Future<void> prominentDisclosure() async {
    AlertDialog prominentDisclosureAlert = AlertDialog(
      title: const Text("Location Permission"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Nusantara Muslim collectes location data to enable Prayer Time, & Qibla Direction even when the app is closed or not in use, and it also used to support advertising'),
          const SizedBox(
            height: 8,
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'Prayer Times: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  text:
                      'Enable location permission to get precise prayer times for your current location, ensuring timely and accurate prayers.',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'Qibla Direction: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  text:
                      'Grant location access to determine the Qibla direction specific to your location, allowing you to perform prayers with confidence and accuracy.',
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No, Thanks")),
        ElevatedButton(
            // onPressed: () => Navigator.of(context).pop(),
            onPressed: () async {
              await Geolocator.requestPermission()
                  .then((value) => Navigator.of(context).pop());
            },
            child: const Text("Turn On")),
      ],
    );

    // await showDialog(
    //     context: context, builder: (context) => prominentDisclosureAlert);
    // return;
    await showDialog(
      context: context,
      builder: (context) => prominentDisclosureAlert,
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (_showAlertDialog) {
    //   showAboutDialog(context: context);
    //   _showAlertDialog = false;
    // }
    return MaterialApp(
        navigatorKey: MyApp.navigatorKey,
        // navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Nusantara Muslim',
        initialRoute: SplashPage.routeName,
        routes: {
          SplashPage.routeName: (context) => const SplashPage(),
          Intro.routeName: (context) => const Intro(),
          NavigationWidget.routeName: (context) => const NavigationWidget(),
          HomePage.routeName: (context) => const HomePage(),
          QuranPage.routeName: (context) => const QuranPage(),
          DuaPage.routeName: (context) => const DuaPage(),
          AsmaulHusnaPage.routeName: (context) => const AsmaulHusnaPage(),
          QiblaPage.routeName: (context) => const QiblaPage(),
        }
        // onGenerateRoute: (settings) {
        //   switch (settings.name) {
        //     case SplashPage.routeName:
        //       return MaterialPageRoute(builder: (context) => const SplashPage());
        //     case Intro.routeName:
        //       return MaterialPageRoute(builder: (context) => const Intro());
        //     case NavigationWidget.routeName:
        //       return MaterialPageRoute(
        //           builder: (context) => const NavigationWidget());
        //     case HomePage.routeName:
        //       return MaterialPageRoute(builder: (context) => const HomePage());
        //     case QuranPage.routeName:
        //       return MaterialPageRoute(builder: (context) => const QuranPage());
        //     case DuaPage.routeName:
        //       return MaterialPageRoute(builder: (context) => const DuaPage());
        //     case AsmaulHusnaPage.routeName:
        //       return MaterialPageRoute(
        //           builder: (context) => const AsmaulHusnaPage());
        //     case QiblaPage.routeName:
        //       return MaterialPageRoute(builder: (context) => const QiblaPage());
        //     case VideoPage.routeName:
        //       return MaterialPageRoute(builder: (context) => const VideoPage());
        //     case VideoPlayPage.routeName:
        //       String id = settings.arguments as String;
        //       return MaterialPageRoute(
        //           builder: (context) => VideoPlayPage(
        //                 videoID: id,
        //               ));
        //     default:
        //       return MaterialPageRoute(
        //           builder: (context) => const NavigationWidget());
        //   }
        // },
        );
  }
}

class MyAlertObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Panggil fungsi untuk menampilkan AlertDialog di sini
      // showMyAlertDialog();
    }
  }
}
