// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:carbon_footprint/NavigationSidebar.dart';
import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_box.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_tile.dart';
import 'package:flutter/material.dart';

class HomePageTablet extends StatefulWidget {
  HomePageTablet({Key? key}) : super(key: key);

  @override
  State<HomePageTablet> createState() => _HomePageTabletState();
}

class _HomePageTabletState extends State<HomePageTablet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: rootAppbar,
      drawer: CustomDrawer(),
      body: Column(children: [
        AspectRatio(
          aspectRatio: 4,
          child: SizedBox(
            width: double.infinity,
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: 4,
              itemBuilder: (context, index) {
                return UsefulBox();
              },
            ),
          ),
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
