// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, prefer_const_declarations, prefer_typing_uninitialized_variables, sort_child_properties_last

import 'dart:convert';

import 'package:carbon_footprint/pages/ChatPage/mobileChatPage.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_tile.dart';
import 'package:carbon_footprint/pages/Home/home_page_desktop.dart';
import 'package:carbon_footprint/pages/Home/home_page_mobile.dart';
import 'package:carbon_footprint/pages/Home/home_page_tablet.dart';
import 'package:carbon_footprint/providers/pageControl.dart';
import 'package:carbon_footprint/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class MobileCarbonReduction extends StatefulWidget {
  const MobileCarbonReduction({Key? key}) : super(key: key);

  @override
  State<MobileCarbonReduction> createState() => _MobileCarbonReductionState();
}

// Future<void> sendPostRequest() async {

//   if (response.statusCode == 200) {
//     // If the server returns an OK response, parse the JSON
//     print('Response data: ${response.body}');
//   } else {
//     // If the server did not return a 200 OK response,
//     // throw an exception.
//     print('Failed to load data. Code: ${response.statusCode}');
//   }
// }

final fetchOptimizationsFuture = FutureProvider<List>(
  (ref) async {
    var extract;

    final url = 'http://159.65.240.201:8080/sequential_chain';
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'emailId': 'string',
      'state': 'string',
      'city': 'string',
      'vehicle_type': 'string',
      'commute_miles': 0,
      'commute_time': 0,
      'electrical_usage': 0,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    extract = jsonDecode(response.body);

    return Future.value(extract);
  },
);

final dataSet = [
  'Carpool to work',
  'Switch to electric vehicle',
  'Eliminate unnecessary trips',
  'Reduce vehicle use',
  'Travel in low traffic times'
];

// n\nAnswer:\n{\n    \"Suggestion1\": \"Carpool to work\",\n    \"Suggestion2\": \"Switch to electric vehicle\",\n    \"Suggestion3\": \"Reduce vehicle use\",\n    \"Suggestion4\": \"Take public transportation\",\n    \"Suggestion5\": \"Eliminate unnecessary trips\"\n}",
// "optimizations": "\n\nAnswer: Carpooling to work can reduce carbon emissions by 40-80%, switching to electric vehicles can reduce emissions by 70-90%, reducing vehicle use can reduce emissions by 30-50%, taking public transportation can reduce emissions by 30-40%, and eliminating unnecessary trips can reduce emissions by 30-40%. On average, these strategies can save any given person approximately 54% in carbon emissions."

class _MobileCarbonReductionState extends State<MobileCarbonReduction> {
  final pageControlProvider = ChangeNotifierProvider<PageControlNotifier>(
    (ref) => PageControlNotifier(),
  );
  String? _instruction;
  String? _platformVersion;
  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;
  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = true;
    // _navigationOption.initialLatitude = -95.402323;
    // _navigationOption.initialLongitude = 29.717138;
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
    MapBoxNavigation.instance.setDefaultOptions(_navigationOption);

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Map routePoints = {
    "Home": WayPoint(
        name: "Home",
        latitude: 29.720370,
        longitude: -95.404115,
        isSilent: false),
    "Gym": WayPoint(
        name: "Gym",
        latitude: 29.655929,
        longitude: -95.507283,
        isSilent: false),
    "Work": WayPoint(
        name: "School",
        latitude: 29.776273,
        longitude: -95.352333,
        isSilent: false),
  };

  // final _home = WayPoint(
  //     name: "Home",
  //     latitude: 37.77440680146262,
  //     longitude: -122.43539772352648,
  //     isSilent: false);

  // final _store = WayPoint(
  //     name: "Store",
  //     latitude: 37.76556957793795,
  //     longitude: -122.42409811526268,
  //     isSilent: false);

  @override
  Widget build(BuildContext context) {
    NavigationDestinationLabelBehavior labelBehavior =
        NavigationDestinationLabelBehavior.alwaysShow;
    int pageIndex = 1;
    return Consumer(
      builder: (context, ref, child) {
        final pageControlState = ref.watch(pageControlProvider);
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            labelBehavior: labelBehavior,
            selectedIndex: pageIndex,
            onDestinationSelected: (int index) {
              setState(
                () {
                  if (index != 1) {
                    pageControlState.pageIndex = index;

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
                },
              );
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .09,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Carbon Reduction Methods',
                  style: TextStyle(fontFamily: 'BebasNeue', fontSize: 40),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 380,
                    child: MapBoxNavigationView(
                      options: _navigationOption,
                      onRouteEvent: _onEmbeddedRouteEvent,
                      onCreated:
                          (MapBoxNavigationViewController controller) async {
                        _controller = controller;
                        controller.initialize();
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  'Carbon Friendly Routes',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ),
              _routeBuilt
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carbon route will save you ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[900],
                                fontFamily: 'Rounded MPlus',
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '7 ',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.grey[900],
                                    fontFamily: 'Rounded MPlus',
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Minutes & reduce C02 by 3% on this trip ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[900],
                                    fontFamily: 'Rounded MPlus',
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (_routeBuilt) {
                                  _controller?.clearRoute();
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.amber[100],
                              ),
                              height: 30,
                              child: Center(
                                child: Text(
                                  'Cancel Route',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
              !_routeBuilt
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        InkWell(
                          onTap: _isNavigating
                              ? null
                              : () {
                                  if (_routeBuilt) {
                                    _controller?.clearRoute();
                                  } else {
                                    var wayPoints = <WayPoint>[];
                                    wayPoints.add(routePoints['Home']);
                                    wayPoints.add(routePoints['Work']);
                                    _isMultipleStop = wayPoints.length > 2;
                                    _controller?.buildRoute(
                                        wayPoints: wayPoints,
                                        options: _navigationOption);
                                  }
                                },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            color: Colors.grey[200],
                            // width: 100,
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.roundabout_right_rounded),
                                Text(_routeBuilt && !_isNavigating
                                    ? "Cancel Route"
                                    : 'Route to Work'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: _isNavigating
                              ? null
                              : () {
                                  if (_routeBuilt) {
                                    _controller?.clearRoute();
                                  } else {
                                    var wayPoints = <WayPoint>[];
                                    wayPoints.add(routePoints['Home']);
                                    wayPoints.add(routePoints['Gym']);
                                    _isMultipleStop = wayPoints.length > 2;
                                    _controller?.buildRoute(
                                        wayPoints: wayPoints,
                                        options: _navigationOption);
                                  }
                                },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            color: Colors.grey[200],
                            // width: 100,
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.roundabout_right_rounded),
                                Text(_routeBuilt && !_isNavigating
                                    ? "Cancel Route"
                                    : 'Route to the Gym')
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'Methods to Reduce Carbon Footprint',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: Colors.grey[200],
              //   ),
              //   margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              //   padding: EdgeInsets.only(left: 10, top: 10),
              //   width: MediaQuery.of(context).size.width,
              //   height: 60,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Carpool to work',
              //         style: TextStyle(
              //             fontSize: 18,
              //             color: Colors.grey[900],
              //             fontFamily: 'Rounded MPlus',
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: Container(
                        padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Center(
                              child: Text(
                                dataSet[index],
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w800),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (_routeBuilt) {
                                    _controller?.clearRoute();
                                  }
                                });
                              },
                              child: Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.green[100],
                                  ),
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      'Learn More',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        margin: EdgeInsets.all(5),
                        // width: 100,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              )
              // Consumer(
              //   builder: (context, ref, child) {
              //     final fetchOptimizationsProvider =
              //         ref.watch(fetchOptimizationsFuture);
              //     return fetchOptimizationsProvider.when(
              //       data: (data) {
              //         // print(data);
              //         return Expanded(
              //           child: ListView.builder(
              //             itemCount: 5,
              //             itemBuilder: (context, index) {
              //               return Container(
              //                 margin: EdgeInsets.all(5),
              //                 width: 50,
              //                 height: 50,
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(10),
              //                 ),
              //                 color: Colors.grey[100],
              //               );
              //             },
              //           ),
              //         );
              //       },
              //       error: (error, stackTrace) {
              //         return Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       },
              //       loading: () {
              //         return Center(
              //           child: CircularProgressIndicator(),
              //         );
              //       },
              //     );
              //   },
              // )
            ],
          ),
        );
      },
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
