import 'package:digiquran/common/color.dart';
import 'package:digiquran/common/font.dart';
import 'package:digiquran/data/controller/geolocator.dart';
import 'package:digiquran/data/model/location_model.dart';
import 'package:digiquran/data/model/schedule_model.dart';
import 'package:digiquran/data/repository/repostiory.dart';
import 'package:digiquran/presentation/screen/home_page.dart';
import 'package:digiquran/presentation/widget/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});
  static const routeName = '/intro-widget';

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 350,
                    child: Image(
                      image:
                          AssetImage('lib/assets/Current location-rafiki.png'),
                    ),
                  ),
                  Text(
                    'Nusantara Muslim Collects Location Data to Enable',
                    style: firaSansS1.copyWith(color: secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Automated Prayer Time Update, and Qibla Direction Detection even when the app is closed or not in use',
                    style: firaSansS2.copyWith(color: secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, NavigationWidget.routeName);
                        },
                        child: Container(
                          // width: 100,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Tolak',
                            style: firaSansH5.copyWith(
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await Geolocator.requestPermission().then((value) =>
                              Navigator.pushReplacementNamed(
                                  context, NavigationWidget.routeName));
                          // Navigator.pushReplacementNamed(
                          //     context, NavigationWidget.routeName);
                        },
                        child: Container(
                          // width: 100,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text('Izinkan',
                              style: firaSansH5.copyWith(
                                color: primaryColor,
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future getShalahSchedule() async {
    try {
      String address = await getLocation();
      List<String> parts = address.split(',');
      String cityName = parts[0].split(' ')[1];
      List<LocationModel> location =
          await Repository().postLocationList(city: cityName);
      String locationId = location[0].id;

      Schedule schedule = await Repository().getScheduleByCity(
        id: locationId,
        year: DateTime.now().year,
        month: DateTime.now().month,
        day: DateTime.now().day,
      );

      List<String> shalahSchedule = [];
      shalahSchedule.add(schedule.jadwal?.subuh ?? '00:00');
      shalahSchedule.add(schedule.jadwal?.dzuhur ?? '00:00');
      shalahSchedule.add(schedule.jadwal?.ashar ?? '00:00');
      shalahSchedule.add(schedule.jadwal?.maghrib ?? '00:00');
      shalahSchedule.add(schedule.jadwal?.isya ?? '00:00');
      setState(() {
        HomePage.shalahDataVariable = shalahSchedule;
      });
      return shalahSchedule;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('getShalahSchedule Error: $e'),
        ),
      );
      return [];
    }
  }

  Future getLocation() async {
    double latitude = 0;
    double longitude = 0;
    try {
      Position position = await getCurrentLocation();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      String address = await getAddress(latitude, longitude);
      setState(() {
        HomePage.addressVariable = address;
      });
      return address;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('getLocation Error: $e'),
        ),
      );
    }
  }
}
