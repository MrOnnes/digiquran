import 'package:carousel_slider/carousel_slider.dart';
import 'package:digiquran/common/color.dart';
import 'package:digiquran/common/font.dart';
import 'package:digiquran/common/gap.dart';
import 'package:digiquran/common/skeleton.dart';
import 'package:digiquran/common/static.dart';
import 'package:digiquran/data/controller/geolocator.dart';
import 'package:digiquran/data/model/location_model.dart';
import 'package:digiquran/data/model/schedule_model.dart';
import 'package:digiquran/data/repository/repostiory.dart';
import 'package:digiquran/presentation/widget/star_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/home-screen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  String addressVar = '';
  String timeId = '';
  List shalahData = [];
  HijriCalendar hijriToday = HijriCalendar.now();
  Stream<DateTime>? clockStream;

  @override
  void initState() {
    loadDone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: primaryColor),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            // width: double.infinity,
            // height: double.infinity,
            decoration: const BoxDecoration(color: primaryColor),

            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        'lib/assets/background.jpg',
                      ),
                      frontSection(context),
                      backSection(context)
                    ],
                  ),
                ),
              );
            }),

            // child: SingleChildScrollView(
            //   child: Stack(
            //     children: [
            //       Image.asset(
            //         'lib/assets/background.jpg',
            //       ),
            //       backSection(context),
            //       // StarWidget(
            //       //   top: 80,
            //       //   right: MediaQuery.of(context).size.width / 11.5,
            //       //   size: 10,
            //       // ),
            //       // StarWidget(
            //       //   top: 180,
            //       //   right: MediaQuery.of(context).size.width / 10,
            //       //   size: 10,
            //       // ),
            //       // StarWidget(
            //       //   top: 140,
            //       //   right: MediaQuery.of(context).size.width / 4.5,
            //       //   size: 12,
            //       // ),
            //       // StarWidget(
            //       //   top: 40,
            //       //   right: MediaQuery.of(context).size.width / 3.5,
            //       //   size: 5,
            //       // ),
            //       // StarWidget(
            //       //   top: 80,
            //       //   right: MediaQuery.of(context).size.width / 2,
            //       //   size: 16,
            //       // ),
            //       // StarWidget(
            //       //   top: 120,
            //       //   right: MediaQuery.of(context).size.width / 1.4,
            //       //   size: 8,
            //       // ),
            //       // StarWidget(
            //       //   top: 70,
            //       //   right: MediaQuery.of(context).size.width / 1.15,
            //       //   size: 4,
            //       // ),
            //       // StarWidget(
            //       //   top: 160,
            //       //   right: MediaQuery.of(context).size.width / 1.10,
            //       //   size: 12,
            //       // ),
            //       frontSection(context),
            //       // Container(
            //       //   height: MediaQuery.of(context).size.height,
            //       // ),
            //     ],
            //   ),
            // ),

            //   child: Container(
            // color: Colors.grey,
            // ),
          ),
        ),
      ),
    );

    //   return AnnotatedRegion<SystemUiOverlayStyle>(
    //     value: const SystemUiOverlayStyle(statusBarColor: primaryColor),
    //     child: SafeArea(
    //       child: MaterialApp(
    //         home: Scaffold(
    //           body: Container(
    //             decoration: const BoxDecoration(color: primaryColor),
    //             child: SingleChildScrollView(
    //                 child: Stack(
    //               children: [
    //                 backSection(context),
    //                 frontSection(context),
    //                 Container(
    //                   height: MediaQuery.of(context).size.height,
    //                 ) // Tambah Container agar bug tinggi bisa diakali
    //               ],
    //             )),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
  }

  Positioned frontSection(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2.525,
      // top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        // height: MediaQuery.of(context).size.height / 2,
        height: 500, //TODO HARDCODE ANGKA 500 KARENA BIKIN OVERFLOW
        color: primaryColor,
        padding: const EdgeInsets.only(top: 4),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: double.infinity,
            height: double.infinity, //TODO INI GK WORK HEIGHTNYA
            // height: 0,
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Column(
              //TODO : INI BIKIN OVERFLOW
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Features',
                  style: firaSansH2,
                ),
                const VerticalGap5(),
                // Skeleton(
                //   isLoading: isLoading,
                //   duration: const Duration(seconds: 2),
                //   themeMode: ThemeMode.light,
                //   shimmerGradient: LinearGradient(
                //     colors: [
                //       tertiaryColor.withOpacity(.25),
                //       tertiaryColor.withOpacity(.5),
                //       tertiaryColor.withOpacity(.25),
                //     ],
                //     begin: const Alignment(-1.0, -0.5),
                //     end: const Alignment(1.0, 0.5),
                //     stops: const [0.0, 0.5, 1.0],
                //     tileMode: TileMode.repeated,
                //   ),
                //   skeleton: const GridSkeleton(),
                //   child: SizedBox(
                //     width: double.infinity,
                //     height: 86,
                //     child: GridView.builder(
                //       gridDelegate:
                //           const SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 5,
                //         crossAxisSpacing: 4,
                //         mainAxisExtent: 86,
                //       ),
                //       padding: EdgeInsets.zero,
                //       shrinkWrap: true,
                //       itemCount: features.length,
                //       itemBuilder: (context, index) {
                //         return InkWell(
                //           onTap: () {
                //             // Function Button menu ada disini
                //             if (index == 0) {
                //               Navigator.pushNamed(context, featuresNav[0]).then(
                //                   (value) => debugPrint(value.toString()));
                //             } else if (index == 1) {
                //               Navigator.pushNamed(
                //                   context,
                //                   featuresNav[1].then(
                //                       (value) => debugPrint(value.toString())));
                //             } else if (index == 2) {
                //               Navigator.pushNamed(context, featuresNav[2]).then(
                //                   (value) => debugPrint(value.toString()));
                //             } else if (index == 4) {
                //               Navigator.pushNamed(context, featuresNav[4]).then(
                //                   (value) => debugPrint(value.toString()));
                //             } else {
                //               ScaffoldMessenger.of(context).showSnackBar(
                //                 const SnackBar(
                //                   content: Text('Coming Soon'),
                //                 ),
                //               );
                //             }
                //           },
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Container(
                //                 decoration: BoxDecoration(
                //                   color: primaryColor,
                //                   borderRadius: BorderRadius.circular(10),
                //                 ),
                //                 padding: const EdgeInsets.all(16),
                //                 child: Icon(
                //                   featuresIcon[index],
                //                   color: secondaryColor,
                //                   size: 24,
                //                 ),
                //               ),
                //               const VerticalGap5(),
                //               Expanded(
                //                 child: Text(
                //                   features[index],
                //                   style: firaSansS3.copyWith(
                //                     color: tertiaryColor,
                //                   ),
                //                   textAlign: TextAlign.center,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),
                Skeleton(
                  isLoading: isLoading,
                  duration: const Duration(seconds: 2),
                  themeMode: ThemeMode.light,
                  shimmerGradient: LinearGradient(
                    colors: [
                      tertiaryColor.withOpacity(.25),
                      tertiaryColor.withOpacity(.5),
                      tertiaryColor.withOpacity(.25),
                    ],
                    begin: const Alignment(-1.0, -0.5),
                    end: const Alignment(1.0, 0.5),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.repeated,
                  ),
                  skeleton: const GridSkeleton(),
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 4,
                          mainAxisExtent: 86,
                        ),
                        shrinkWrap: true,
                        itemCount: features.length,
                        itemBuilder: (context, index) {
                          return Flex(
                            direction: Axis.vertical,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (index == 3) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Coming Soon')));
                                  } else {
                                    // Navigator.pushNamed(context, '/quran-page');
                                    Navigator.pushNamed(
                                        context, featuresNav[index]);
                                    debugPrint('cliced ${featuresNav[index]} ');
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Icon(
                                    featuresIcon[index],
                                    color: secondaryColor,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const VerticalGap5(),
                              Expanded(
                                child: Text(
                                  features[index],
                                  style: firaSansS3.copyWith(
                                    color: tertiaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          );
                        }),
                  ),
                ),
                // GridView.builder(
                //     gridDelegate:
                //         const SliverGridDelegateWithFixedCrossAxisCount(
                //             crossAxisCount: 5),
                //     shrinkWrap: true,
                //     itemBuilder: (context, index) {
                //       return Placeholder(
                //         fallbackHeight: 100,
                //         fallbackWidth: 100,
                //       );
                //     }),
                const VerticalGap15(),
                Text(
                  'Daily Reminder',
                  style: firaSansH2,
                ),
                const VerticalGap5(),
                Skeleton(
                  isLoading: isLoading,
                  duration: const Duration(seconds: 2),
                  themeMode: ThemeMode.light,
                  shimmerGradient: LinearGradient(
                    colors: [
                      tertiaryColor.withOpacity(.25),
                      tertiaryColor.withOpacity(.5),
                      tertiaryColor.withOpacity(.25),
                    ],
                    begin: const Alignment(-1.0, -0.5),
                    end: const Alignment(1.0, 0.5),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.repeated,
                  ),
                  skeleton: const ImageSkeleton(),
                  child: FutureBuilder(
                    future: Repository().getReminderList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CarouselSlider.builder(
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 15),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 500,
                            ),
                            autoPlayCurve: Curves.easeIn,
                            aspectRatio: 16 / 9,
                            pauseAutoPlayOnTouch: true,
                            enlargeCenterPage: false,
                            viewportFraction: 1,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index, realIndex) {
                            final data = snapshot.data![index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '"${data.text}"',
                                            style: firaSansS2.copyWith(
                                              color: tertiaryColor,
                                            ),
                                          ),
                                          const VerticalGap5(),
                                          Text(
                                            data.reference,
                                            style: firaSansH4.copyWith(
                                              color: tertiaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    bottom: 24,
                                    right: 24,
                                    child: Icon(
                                      Bootstrap.moon_stars_fill,
                                      color: primaryColor,
                                      size: 24,
                                    ),
                                  ),
                                  const Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Icon(
                                      Bootstrap.sun_fill,
                                      color: primaryColor,
                                      size: 48,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container backSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2.5,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Skeleton(
            isLoading: isLoading,
            duration: const Duration(seconds: 2),
            themeMode: ThemeMode.light,
            shimmerGradient: LinearGradient(
              colors: [
                tertiaryColor.withOpacity(.25),
                tertiaryColor.withOpacity(.5),
                tertiaryColor.withOpacity(.25),
              ],
              begin: const Alignment(-1.0, -0.5),
              end: const Alignment(1.0, 0.5),
              stops: const [0.0, 0.5, 1.0],
              tileMode: TileMode.repeated,
            ),
            skeleton: const SmallSkeleton(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hijriToday.toFormat("dd MMMM yyyy"),
                      style: firaSansH2.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                    Text(
                      addressVar,
                      style: firaSansS2.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
                // TODO FUNCTION NOTIFICATION
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Bootstrap.bell_fill,
                //     color: secondaryColor,
                //     size: 20,
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Skeleton(
                        isLoading: isLoading,
                        duration: const Duration(seconds: 2),
                        themeMode: ThemeMode.light,
                        shimmerGradient: LinearGradient(
                          colors: [
                            tertiaryColor.withOpacity(.25),
                            tertiaryColor.withOpacity(.5),
                            tertiaryColor.withOpacity(.25),
                          ],
                          begin: const Alignment(-1.0, -0.5),
                          end: const Alignment(1.0, 0.5),
                          stops: const [0.0, 0.5, 1.0],
                          tileMode: TileMode.repeated,
                        ),
                        skeleton: const ClockSkeleton(),
                        child: StreamBuilder<DateTime>(
                          stream: clockStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                DateFormat('HH:mm').format(snapshot.data!),
                                style: firaSansH1.copyWith(
                                  color: secondaryColor,
                                  fontSize: 42,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Time Error',
                                style: firaSansH1.copyWith(
                                  color: secondaryColor,
                                  fontSize: 42,
                                ),
                              );
                            } else {
                              return Text(
                                '00:00',
                                style: firaSansH1.copyWith(
                                  color: secondaryColor,
                                  fontSize: 42,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const VerticalGap5(),
                      Skeleton(
                        isLoading: isLoading,
                        duration: const Duration(seconds: 2),
                        themeMode: ThemeMode.light,
                        shimmerGradient: LinearGradient(
                          colors: [
                            tertiaryColor.withOpacity(.25),
                            tertiaryColor.withOpacity(.5),
                            tertiaryColor.withOpacity(.25),
                          ],
                          begin: const Alignment(-1.0, -0.5),
                          end: const Alignment(1.0, 0.5),
                          stops: const [0.0, 0.5, 1.0],
                          tileMode: TileMode.repeated,
                        ),
                        skeleton: const TinySkeleton(),
                        child: Text(
                          getRemainingTime(),
                          style: firaSansS2.copyWith(
                            color: secondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Skeleton(
                  isLoading: isLoading,
                  duration: const Duration(seconds: 2),
                  themeMode: ThemeMode.light,
                  shimmerGradient: LinearGradient(
                    colors: [
                      tertiaryColor.withOpacity(.25),
                      tertiaryColor.withOpacity(.5),
                      tertiaryColor.withOpacity(.25),
                    ],
                    begin: const Alignment(-1.0, -0.5),
                    end: const Alignment(1.0, 0.5),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.repeated,
                  ),
                  skeleton: const GridSkeleton(),
                  child: SizedBox(
                      width: double.infinity,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 4,
                                  mainAxisExtent: 96),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: shalahData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: secondaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    sholatTime[index],
                                    style: firaSansS2.copyWith(
                                      color: secondaryColor,
                                    ),
                                  ),
                                  Icon(
                                    sholatTimeIcon[index],
                                    color: secondaryColor,
                                  ),
                                  Text(
                                    shalahData[index],
                                    style: firaSansS2.copyWith(
                                      color: secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // loadDone ini dijalanin pas init
  void loadDone() async {
    getLocation().then((value) => debugPrint('getLocation $value'));
    getHijriDate();
    debugPrint('getHijriDate ${hijriToday.toString()}');
    getTime();
    // debugPrint();
    getShalahSchedule().then((value) => debugPrint('getShalahSchedule $value'));
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  String getRemainingTime() {
    if (shalahData.isEmpty) {
      // debugPrint('shalahData isEmpty');
      return '';
    }

    DateTime now = DateTime.now();
    String remainingTime = '';

    List<String> prayerNames = ['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isha'];

    for (int i = 0; i < shalahData.length; i++) {
      DateTime prayerTime = DateTime.parse(
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${shalahData[i]}',
      );
      Duration remainingDuration = prayerTime.difference(now);

      if (remainingDuration.isNegative) {
        continue;
      }

      int remainingHours = remainingDuration.inHours;
      int remainingMinutes = remainingDuration.inMinutes.remainder(60);
      remainingTime +=
          '$remainingHours hours $remainingMinutes minutes remaining until ${prayerNames[i]}';

      break;
    }

    return remainingTime.trim();
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
        shalahData = shalahSchedule;
      });
      return shalahSchedule;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
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
        addressVar = address;
      });
      return address;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  void getHijriDate() {
    const String locale = 'en';
    setState(() {
      hijriToday = HijriCalendar.now();
      HijriCalendar.setLocal(locale);
    });
  }

  void getTime() {
    clockStream =
        Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
  }
}
