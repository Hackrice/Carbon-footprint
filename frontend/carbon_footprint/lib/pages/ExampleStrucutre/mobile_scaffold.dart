// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carbon_footprint/NavigationSidebar.dart';
import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_box.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_tile.dart';
import 'package:flutter/material.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: rootAppbar,
      drawer: CustomDrawer(),
      body: Column(children: [
        AspectRatio(
          aspectRatio: 1,
          child: SizedBox(
            width: double.infinity,
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
