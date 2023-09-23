// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carbon_footprint/NavigationSidebar.dart';
import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_tile.dart';
import 'package:carbon_footprint/pages/Home/widgets/lineChart.dart';
import 'package:flutter/material.dart';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({Key? key}) : super(key: key);

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: rootAppbar,
      drawer: CustomDrawer(),
      body: Column(children: [
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
  }
}
