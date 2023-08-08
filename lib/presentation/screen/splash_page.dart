import 'package:digiquran/common/color.dart';
import 'package:digiquran/common/font.dart';
import 'package:digiquran/common/gap.dart';
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
  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  void checkPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LocationPermission permission;
    bool? intro = (prefs.getBool('intro'));
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      debugPrint(
          'checkPermission location active, status prefs: ${intro.toString()}');
      prefs.setBool('intro', true);
      loadData();
    } else {
      debugPrint('checkPermision else $permission');
      await prominentDisclosure();
      await prefs.setBool('intro', false);
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
            onPressed: () {
              Navigator.of(context).pop();
              loadData();
            },
            child: const Text("No, Thanks")),
        ElevatedButton(
            onPressed: () async {
              await Geolocator.requestPermission()
                  .then((value) => Navigator.of(context).pop());
              loadData();
            },
            child: const Text("Turn On")),
      ],
    );

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: prominentDisclosureAlert),
    );
  }

  void loadData() async {
    await Future.delayed(const Duration(seconds: 2)).then(
      (value) => {
        Navigator.pushReplacementNamed(context, NavigationWidget.routeName),
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
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
