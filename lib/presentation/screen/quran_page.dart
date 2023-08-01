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
  int surahNumber = 1;
  late List<String> surahLatin = [];
  late List<String> surahTransliteration = [];
  List<String> filteredList = [];
  bool search = false;

  Future<List<String>> getSurahLatin() async {
    List<String> surahLatin = [];

    List<Surah> value = await Repository().getSurahList();

    for (var item in value) {
      surahLatin.add(item.latin.toString());
      surahTransliteration.add(item.transliteration.toString());
    }

    return surahLatin;
  }

  @override
  void initState() {
    getSurahLatin().then((value) {
      setState(() {
        surahLatin = value;
        filteredList = surahLatin;
      });
    });

    tabController = TabController(length: 114, vsync: this);
    tabController.addListener(() {
      int nomorSurah =
          getIndexByValue(surahLatin, filteredList[tabController.index]);
      if (nomorSurah != -1) {
        debugPrint(
            'nomor surah ${filteredList[tabController.index]}, adalah ${nomorSurah + 1}');
      } else {
        debugPrint(
            'nomor surah ${filteredList[tabController.index]}, tidak ditemukan');
      }
      setState(() {
        // surahNumber = tabController.index + 1;
        surahNumber = nomorSurah + 1;
      });
    });

    super.initState();
  }

  void filterDataList(String query) {
    List<String> filteredLiteration = [];
    List<String> enhancedFilterList = [];
    if (query.isNotEmpty) {
      setState(() {
        filteredList = surahLatin
            .where((data) => data.toLowerCase().contains(query.toLowerCase()))
            .toSet()
            .toList();
        filteredLiteration = surahTransliteration
            .where((data) => data.toLowerCase().contains(query.toLowerCase()))
            .toList();
        for (var i = 0; i < surahTransliteration.length; i++) {
          if (filteredLiteration.contains(surahTransliteration[i])) {
            enhancedFilterList.add(surahLatin[i]);
            filteredList = enhancedFilterList;
          }
        }
      });
    } else {
      debugPrint('query is empty');
      setState(() {
        filteredList = surahLatin;
      });
    }
  }

  int getIndexByValue(List<String> values, String targetValue) {
    for (int i = 0; i < values.length; i++) {
      if (values[i] == targetValue) {
        return i;
      }
    }
    return -1;
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
      body: NestedScrollView(
          headerSliverBuilder: (context, index) {
            return [
              SliverAppBar(
                pinned: true,
                backgroundColor: secondaryColor,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_left_rounded),
                  color: tertiaryColor,
                  iconSize: 40,
                ),
                title: search
                    ? TextField(
                        onChanged: filterDataList,
                        decoration:
                            const InputDecoration(labelText: 'Search surah'),
                      )
                    : Text(
                        'Quran',
                        style: firaSansH2.copyWith(
                          color: tertiaryColor,
                        ),
                      ),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          search = !search;
                        });
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
                      onTap: (index) {
                        tabController.animateTo(index);
                        int nomorSurah = getIndexByValue(
                            surahLatin, filteredList[tabController.index]);
                        setState(() {
                          surahNumber = nomorSurah + 1;
                        });
                      },
                      tabs: List<Widget>.generate(
                          filteredList.isNotEmpty ? filteredList.length : 1,
                          (index) {
                        return Tab(
                          child: Text(
                            filteredList.isNotEmpty
                                ? filteredList[index]
                                : 'Not Found',
                            style: firaSansH5,
                          ),
                        );
                      })),
                ),
              )
            ];
          },
          body: FutureBuilder(
            future: Repository()
                .getSurahByNumber(surahNumber: surahNumber.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No Internet Connection')));
                });
                return Text('Error: ${snapshot.error}');
              } else {
                final data = snapshot.data;
                return TabBarView(
                  controller: tabController,
                  children: filteredList.map((e) {
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
                                style:
                                    firaSansH3.copyWith(color: secondaryColor),
                              ),
                              Text(
                                '${data.totalAyat} Aya, ${data.location}',
                                style:
                                    firaSansH4.copyWith(color: secondaryColor),
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
                                          color: primaryColor),
                                      textAlign: TextAlign.right,
                                    )),
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
                                )
                              ],
                            );
                          },
                        )),
                      ],
                    );
                  }).toList(),
                );
              }
            },
          )),
    );
  }
}
