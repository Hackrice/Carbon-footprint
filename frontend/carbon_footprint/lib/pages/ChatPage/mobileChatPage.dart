// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_tile.dart';
import 'package:carbon_footprint/pages/Home/home_page_desktop.dart';
import 'package:carbon_footprint/pages/Home/home_page_mobile.dart';
import 'package:carbon_footprint/pages/Home/home_page_tablet.dart';
import 'package:carbon_footprint/pages/NavigationPage/navigation_page.dart';
import 'package:carbon_footprint/providers/pageControl.dart';
import 'package:carbon_footprint/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileChatPage extends StatefulWidget {
  const MobileChatPage({Key? key}) : super(key: key);

  @override
  State<MobileChatPage> createState() => _MobileChatPageState();
}

class _MobileChatPageState extends State<MobileChatPage> {
  final pageControlProvider = ChangeNotifierProvider<PageControlNotifier>(
    (ref) => PageControlNotifier(),
  );

  @override
  Widget build(BuildContext context) {
    NavigationDestinationLabelBehavior labelBehavior =
        NavigationDestinationLabelBehavior.alwaysShow;
    int pageIndex = 2;
    return Consumer(
      builder: (context, ref, child) {
        final pageControlState = ref.watch(pageControlProvider);
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            labelBehavior: labelBehavior,
            selectedIndex: pageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                if (index != 2) {
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
                  if (index == 0) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) {
                          return ResponsiveLayout(
                            mobileScaffold: HomePageMobile(),
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
          body: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return UsefuleTile();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
