import 'package:digiquran/common/color.dart';
import 'package:digiquran/common/font.dart';
import 'package:digiquran/common/gap.dart';
import 'package:digiquran/presentation/screen/intro.dart';
import 'package:digiquran/presentation/widget/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const routeName = '/splash_page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // LocationPermission permission;
  void loadData() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool seen = (prefs.getBool('intro') ?? false);

    // if (seen) {
    //   await Future.delayed(const Duration(seconds: 3)).then((value) => {
    //         Navigator.pushReplacementNamed(context, NavigationWidget.routeName),
    //         // Navigator.pushReplacementNamed(context, Intro.routeName),
    //       });
    // } else {
    //   // await prefs.setBool('intro', true);
    //   await Future.delayed(const Duration(seconds: 3)).then((value) => {
    //         // Navigator.pushReplacementNamed(context, NavigationWidget.routeName),
    //         Navigator.pushReplacementNamed(context, Intro.routeName),
    //       });
    //   debugPrint('status _seen = $seen');
    // }

    await Future.delayed(const Duration(seconds: 3)).then(
      (value) => {
        Navigator.pushReplacementNamed(context, NavigationWidget.routeName),
      },
    );

    // debugPrint('status _seen = $seen');
  }

  // void checkPermission() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   LocationPermission permission;
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.always ||
  //       permission == LocationPermission.whileInUse) {
  //     debugPrint('checkPermission location active');
  //     await prefs.setBool('intro', true);
  //   } else {
  //     debugPrint('checkPermision else $permission');
  //     await prefs.setBool('intro', false);
  //   }
  //   loadData();
  // }

  @override
  void initState() {
    super.initState();
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.always) {
    //   await prefs.setBool('intro', true);
    // }
    // checkPermission();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nusantara',
              style: firaSansH1.copyWith(color: secondaryColor, fontSize: 40),
            ),
            const HorizontalGap5(),
            Container(
              decoration: const BoxDecoration(
                color: secondaryColor,
              ),
              padding: const EdgeInsets.all(2),
              child: Text(
                'Muslim',
                style: firaSansH1.copyWith(color: primaryColor, fontSize: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
