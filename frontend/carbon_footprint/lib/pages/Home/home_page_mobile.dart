// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/pages/ChatPage/mobileChatPage.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_tile.dart';
import 'package:carbon_footprint/pages/Home/home_page_desktop.dart';
import 'package:carbon_footprint/pages/Home/home_page_tablet.dart';
import 'package:carbon_footprint/pages/Home/widgets/lineChart.dart';
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

  @override
  Widget build(BuildContext context) {
    NavigationDestinationLabelBehavior labelBehavior =
        NavigationDestinationLabelBehavior.alwaysShow;
    int pageIndex = 0;
    return Consumer(
      builder: (context, ref, child) {
        final pageControlState = ref.watch(pageControlProvider);

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
          body: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            AspectRatio(
              aspectRatio: 1,
              child: CarbonUsageLineChart(),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return UsefuleTile();
              },
            ))
          ]),
        );
      },
    );
  }
}
