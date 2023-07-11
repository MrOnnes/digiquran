import 'package:digiquran/common/color.dart';
import 'package:digiquran/common/font.dart';
import 'package:digiquran/common/gap.dart';
import 'package:digiquran/data/repository/repostiory.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:digiquran/data/model/surah_model.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});
  static const routeName = '/quran-page';

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> with TickerProviderStateMixin {
  late TabController tabController;
  bool isLoading = true;
  int surahNumber = 1;
  late List<String> surahLatin = [];

  // void getSurahLatin() {
  //   Repository().getSurahList().then((value) {
  //     for (var item in value) {
  //       surahLatin.add(item.latin.toString());
  //     }
  //   });
  //   // if (surahLatin.isNotEmpty) {
  //   //   print(surahLatin[0]);
  //   // }
  // }

  Future<List<String>> getSurahLatin() async {
    List<String> surahLatin = [];
    // setState(() {
    //   isLoading = true;
    // });
    // print(isLoading.toString());

    List<Surah> value = await Repository().getSurahList();

    for (var item in value) {
      surahLatin.add(item.latin.toString());
    }

    // Repository().getSurahList().then((value) {
    //   debugPrint('isi item nya: ${value[1].latin.toString()}');
    //   //disini itemnya udah dapet dari repo
    //   for (var item in value) {
    //     surahLatin.add(item.latin.toString());
    //   }
    //   surahLatin.isNotEmpty ? print(surahLatin[2]) : print('surahLatin Empty');
    //   //surahLatin juga sudah ter Add disini
    // });

    if (surahLatin.isNotEmpty) {
      // print(surahLatin[0]);
      // setState(() {
      //   isLoading = false;
      // });
      // print(isLoading.toString());

      debugPrint('surah latin ter get dan is not empty');
    } else {
      debugPrint('surah latin gagal terget dan is empty');
    }
    return surahLatin;
  }

  // void getTabSurah() async {
  //   debugPrint('surahLatin.length async: ${surahLatin.length}');
  // }

  @override
  void initState() {
    // getSurahLatin().then((value) => surahLatin.isNotEmpty
    //     ? print('surah di pas init is not empty')
    //     : print('surah di pas init empty'));
    getSurahLatin().then((value) {
      setState(() {
        surahLatin = value;
      });
      debugPrint('surah di pas init is not empty');
    });
    tabController = TabController(length: 114, vsync: this);
    tabController.addListener(() {
      setState(() {
        surahNumber = tabController.index + 1;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: FutureBuilder(
          future: Repository()
              .getSurahByNumber(surahNumber: surahNumber.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //tester
              // surahLatin.isNotEmpty
              //     ? print('surah isnotempty')
              //     : print('surah emty');
              // DISINI SURAH PASTI SELALU EMPTY KARENA MEMANG TIDAK DITARIK SAAT DISINI
              // return const Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     CircularProgressIndicator(
              //       color: primaryColor,
              //     ),
              //   ],
              // );
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ); // Widget saat Future sedang dalam proses loading
            } else if (snapshot.hasError) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No Internet connection'),
                  ),
                );
              });
              // return Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text('on Error'),
              //     Text(snapshot.toString()),
              //   ],
              // );
              return Text('Error: ${snapshot.error}');
              // Widget saat Futur // Widget saat Future mengalami error
            } else {
              // //tester
              // surahLatin.isNotEmpty
              //     ? print(surahLatin[0])
              //     : print('surah emty');
              // Jika completed
              final data = snapshot.data;
              return NestedScrollView(
                headerSliverBuilder: (context, index) {
                  // if (index.length > 0)
                  return [
                    //penyebab error ada disini
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: secondaryColor,
                      elevation: 0,
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_left_rounded,
                          color: tertiaryColor,
                          size: 40,
                        ),
                      ),
                      title: Text(
                        surahLatin.isNotEmpty ? 'Quran' : 'Empty',
                        style: firaSansH2.copyWith(
                          color: tertiaryColor,
                        ),
                      ),
                      centerTitle: true,
                      actions: [
                        IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Coming Soon')));
                            },
                            icon: const Icon(
                              Bootstrap.search,
                              color: tertiaryColor,
                              size: 20,
                            ))
                      ],
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(44),
                        child: TabBar(
                          controller: tabController,
                          automaticIndicatorColorAdjustment: true,
                          indicator: UnderlineTabIndicator(
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            insets: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          indicatorPadding: EdgeInsets.zero,
                          isScrollable: true,
                          indicatorWeight: 0,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: primaryColor,
                          labelColor: primaryColor,
                          // unselectedLabelColor: tertiaryColor, //biarin abu2 yang unselected
                          tabs: List.generate(
                              surahLatin.length > 0
                                  ? surahLatin.length
                                  : 114, //dikasih default value jika surahLatin.length error 0 lagi
                              //TODO ERROR KARENA SURAHLATIN.LENGTH KADANG BELUM TERLOAD

                              (index) => Tab(
                                    child: Text(
                                      surahLatin.isNotEmpty
                                          ? surahLatin[index]
                                          : 'empty',
                                      style: firaSansH5,
                                    ),
                                  )),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                    controller: tabController,
                    children: surahLatin.map((e) {
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data!.arabic.toString(),
                                  style: firaSansH3.copyWith(
                                      color: secondaryColor),
                                ),
                                Text(
                                  '${data.totalAyat} Aya, ${data.location}',
                                  style: firaSansH4.copyWith(
                                      color: secondaryColor),
                                )
                              ],
                            ),
                          ),
                          const VerticalGap10(),
                          Expanded(
                              child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            separatorBuilder: (context, index) => const Divider(
                              thickness: 1.25,
                            ),
                            itemCount: data.ayat!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          data.ayat![index].arabic.toString(),
                                          style: firaSansH3.copyWith(
                                            color: primaryColor,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const VerticalGap10(),
                                  Text(
                                    data.ayat![index].latin.toString(),
                                    style: firaSansH5.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                  const VerticalGap10(),
                                  Text(
                                    data.ayat![index].translation.toString(),
                                    style: firaSansS3.copyWith(
                                      color: tertiaryColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ))
                        ],
                      );
                    }).toList()),
              ); // Widget saat Futur // Widget saat Future berhasil menghasilkan nilai
            }
          }),
    );
  }
}
