// ignore_for_file: prefer_const_constructors

import 'package:carbon_footprint/NavigationSidebar.dart';
import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_box.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_tile.dart';

import 'package:flutter/material.dart';

class DesktopScaffold extends StatefulWidget {
  DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Row(
          children: [
            CustomDrawer(),
            Expanded(
              flex: 2,
              child: Column(children: [
                AspectRatio(
                  aspectRatio: 4,
                  child: SizedBox(
                    width: double.infinity,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
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
