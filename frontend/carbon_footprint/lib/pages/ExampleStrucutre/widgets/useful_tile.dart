// ignore_for_file: prefer_const_constructors

import 'package:carbon_footprint/constants.dart';
import 'package:flutter/material.dart';

class UsefuleTile extends StatelessWidget {
  const UsefuleTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      height: 80,
      decoration: boxDecorations,
    );
  }
}
