// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carbon_footprint/pages/ChatPage/mobileChatPage.dart';
import 'package:carbon_footprint/pages/Home/home_page_desktop.dart';
import 'package:carbon_footprint/pages/Home/home_page_tablet.dart';
import 'package:carbon_footprint/pages/Home/widgets/LocalLineChart.dart';
import 'package:carbon_footprint/pages/NavigationPage/navigation_page.dart';
import 'package:carbon_footprint/providers/pageControl.dart';
import 'package:carbon_footprint/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({Key? key}) : super(key: key);

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  final pageControlProvider = ChangeNotifierProvider<PageControlNotifier>(
    (ref) => PageControlNotifier(),
  );

  int dataSelection = 0;

  @override
  Widget build(BuildContext context) {
    NavigationDestinationLabelBehavior labelBehavior =
        NavigationDestinationLabelBehavior.alwaysShow;
    int pageIndex = 0;
    return Consumer(
      builder: (context, ref, child) {
        final pageControlState = ref.watch(pageControlProvider);
        String userCity = 'Houston';
        String locationRank = '20';
        String localRank = '40%';

        return Scaffold(
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
                label: 'Reduction Options',
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
                height: MediaQuery.of(context).size.height * .06,
              ),
              Text(
                'Carbon Footprint Usage',
                style: TextStyle(fontFamily: 'BebasNeue', fontSize: 40),
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
                    LocalCarbonUsageLineChart(),
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
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Your City: ${userCity}',
                                              style: TextStyle(
                                                  color: Colors.grey[900],
                                                  fontFamily: 'Rounded MPlus',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              'Ranked Top ${locationRank} in Carbon Usage',
                                              style: TextStyle(
                                                  color: Colors.grey[900],
                                                  fontFamily: 'Rounded MPlus',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.trending_up_rounded,
                                            size: 30, color: Colors.red),
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
