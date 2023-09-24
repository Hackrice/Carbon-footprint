// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_tile.dart';
import 'package:carbon_footprint/pages/Home/widgets/LocalLineChart.dart';
import 'package:carbon_footprint/NavigationSidebar.dart';
import 'package:carbon_footprint/constants.dart';
import 'package:flutter/material.dart';

class HomePageDesktop extends StatefulWidget {
  HomePageDesktop({Key? key}) : super(key: key);

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        // appBar: rootAppbar,
        body: Row(
          children: [
            CustomDrawer(),
            Expanded(
              flex: 2,
              child: Column(children: [
                AspectRatio(
                  aspectRatio: 4,
                  child: LocalCarbonUsageLineChart(),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return UsefuleTile();
                  },
                ))
              ]),
            ),
            Expanded(
              flex: 1,
              child: Container(color: layerOneColor),
            )
          ],
        ));
    ;
  }
}
