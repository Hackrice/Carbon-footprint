// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:carbon_footprint/pages/ChatPage/mobileChatPage.dart';
import 'package:carbon_footprint/pages/Home/home_page_desktop.dart';
import 'package:carbon_footprint/pages/Home/home_page_tablet.dart';
import 'package:carbon_footprint/pages/Home/widgets/LocalLineChart.dart';
import 'package:carbon_footprint/pages/NavigationPage/navigation_page.dart';
import 'package:carbon_footprint/providers/pageControl.dart';
import 'package:carbon_footprint/responsive/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({Key? key}) : super(key: key);

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  final pageControlProvider = ChangeNotifierProvider<PageControlNotifier>(
    (ref) => PageControlNotifier(),
  );

  final getHomeCityYearEmissions = FutureProvider<List>(
    (ref) async {
      var extract;

      final response = await http.post(Uri.parse(
          'http://159.65.240.201:8080/getCityYearEmissions?city=Houston&year=2022'));
      extract = jsonDecode(response.body);

      return Future.value(extract);
    },
  );

  final getHomeCityRanking = FutureProvider<List>(
    (ref) async {
      var extract;

      final response = await http.post(Uri.parse(
          'http://159.65.240.201:8080/getCityMonthYearPercentile?month=10&year=2023'));
      extract = jsonDecode(response.body);

      return Future.value(extract);
    },
  );

  int dataSelection = 0;

  int findCityId(List<dynamic> data, String cityName) {
    for (var item in data) {
      if (item[1].toString().toLowerCase() == cityName.toLowerCase()) {
        return item[0];
      }
    }
    return 40; // return null if city is not found
  }

  @override
  Widget build(BuildContext context) {
    NavigationDestinationLabelBehavior labelBehavior =
        NavigationDestinationLabelBehavior.alwaysShow;
    int pageIndex = 0;
    return Consumer(
      builder: (context, ref, child) {
        final cityYearEmissions = ref.watch(getHomeCityYearEmissions);
        final pageControlState = ref.watch(pageControlProvider);
        final homeCityRanking = ref.watch(getHomeCityRanking);
        String userCity = 'Houston';
        String locationRank = '20';
        String localRank = '40%';

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/form');
            },
          ),
          bottomNavigationBar: NavigationBar(
            labelBehavior: labelBehavior,
            selectedIndex: pageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                if (index != 0) {
                  pageControlState.pageIndex = index;

                  if (index == 1) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) {
                          return ResponsiveLayout(
                            mobileScaffold: MobileCarbonReduction(),
                            tabletScaffold: HomePageTablet(),
                            desktopScaffold: HomePageDesktop(),
                          );
                        },
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  }
                  if (index == 2) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) {
                          return ResponsiveLayout(
                            mobileScaffold: MobileChatPage(),
                            tabletScaffold: HomePageTablet(),
                            desktopScaffold: HomePageDesktop(),
                          );
                        },
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  }
                }
              });
            },
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.data_thresholding_outlined),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.commute),
                label: 'Carbon Reduction',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_outlined),
                label: 'Carbon Chat',
              ),
            ],
          ),
          backgroundColor: Colors.grey[300],

          // drawer: CustomDrawer(),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .09,
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Carbon Footprint',
                      style: TextStyle(fontFamily: 'BebasNeue', fontSize: 40),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              color: Colors.grey[200],
                              width: 300,
                              height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        FirebaseAuth.instance.signOut();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 40),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 200,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          'Logout',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey[900],
                                              fontFamily: 'Rounded MPlus',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.settings,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(10),
                height: 320,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Carbon Dioxide Emissions in Metric Tons',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    cityYearEmissions.when(
                      loading: () {
                        return AspectRatio(
                          aspectRatio: 1.70,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 18,
                              left: 12,
                              top: 24,
                              bottom: 12,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        );
                      },
                      data: (data) {
                        return LocalCarbonUsageLineChart();
                      },
                      error: (error, stackTrace) {
                        return LocalCarbonUsageLineChart();
                        // return AspectRatio(
                        //   aspectRatio: 1.70,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(
                        //       right: 18,
                        //       left: 12,
                        //       top: 24,
                        //       bottom: 12,
                        //     ),
                        //     child: Center(
                        //       child: CircularProgressIndicator(
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ),
                        // );
                      },
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              pageIndex = 0;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: dataSelection == 0
                                  ? Colors.blue
                                  : Colors.blue[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            height: 30,
                            width: 150,
                            child: Center(
                              child: Text(
                                'Local Usage',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: dataSelection == 0
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              pageIndex = 1;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: dataSelection == 1
                                  ? Colors.blue
                                  : Colors.blue[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            height: 30,
                            width: 150,
                            child: Center(
                              child: Text(
                                'Personal  Usage',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: dataSelection == 1
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(10),
                      // height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Carbon Footprint Ranking',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[900],
                                    fontFamily: 'Rounded MPlus',
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      padding: EdgeInsets.only(
                                          top: 5, left: 5, right: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: 300,
                                      height: 50,
                                      child: homeCityRanking.when(
                                        loading: () {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.blue,
                                            ),
                                          );
                                        },
                                        error: (error, stackTrace) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                        data: (data) {
                                          final cityRank =
                                              findCityId(data, userCity);
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Your City: ${userCity}',
                                                    style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontFamily:
                                                            'Rounded MPlus',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    'Ranked Top ${cityRank} in Carbon Usage',
                                                    style: TextStyle(
                                                        color: Colors.grey[900],
                                                        fontFamily:
                                                            'Rounded MPlus',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Icon(Icons.trending_up_rounded,
                                                  size: 30, color: Colors.red),
                                            ],
                                          );
                                        },
                                      )),
                                  Container(
                                    width: 80,
                                    height: 40,
                                    margin: EdgeInsets.only(top: 10, left: 10),
                                    padding: EdgeInsets.only(
                                        top: 5, left: 5, right: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.green[300],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Learn More',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.only(
                                        top: 5, left: 5, right: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    width: 300,
                                    height: 75,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Your Raking Compared to Local',
                                              style: TextStyle(
                                                  color: Colors.grey[900],
                                                  fontFamily: 'Rounded MPlus',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              width: 250,
                                              child: Text(
                                                'Ranked in the bottom ${localRank} in carbon usage in your area',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.grey[900],
                                                    fontFamily: 'Rounded MPlus',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.trending_down,
                                            size: 30, color: Colors.green),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    height: 40,
                                    margin: EdgeInsets.only(top: 10, left: 10),
                                    padding: EdgeInsets.only(
                                        top: 5, left: 5, right: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.green[300],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Learn More',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
