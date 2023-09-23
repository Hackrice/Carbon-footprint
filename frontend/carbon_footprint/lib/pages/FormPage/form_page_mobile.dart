// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_brace_in_string_interps

import 'package:carbon_footprint/NavigationSidebar.dart';
import 'package:carbon_footprint/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormPageMobile extends StatefulWidget {
  const FormPageMobile({Key? key}) : super(key: key);

  @override
  State<FormPageMobile> createState() => _FormPageMobileState();
}

double formWidth(BuildContext context) {
  final deviceSize = MediaQuery.of(context).size;

  if (deviceSize.width < 500) {
    return deviceSize.width * .8;
  }
  if (deviceSize.width < 1100) {
    return deviceSize.width * .4;
  } else {
    return deviceSize.width * .4;
  }
}

class CustomFormField extends StatefulWidget {
  const CustomFormField(
      {required this.fieldController,
      required this.fieldLabel,
      required this.fieldKey,
      required this.labelUnit,
      required this.fieldFormData,
      super.key});
  final TextEditingController fieldController;
  final String fieldLabel;
  final String fieldKey;
  final String labelUnit;
  final Map fieldFormData;
  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    double formHeight = 70;
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      height: formHeight,
      width: formWidth(context),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: widget.fieldController,
        enabled: true,
        cursorColor: Colors.grey[900],
        style: TextStyle(
            color: Colors.grey[900],
            fontFamily: 'Rounded MPlus',
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: widget.fieldLabel,
            labelStyle: TextStyle(
                color: Colors.grey,
                fontFamily: 'Rounded MPlus',
                fontWeight: FontWeight.bold)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill this value';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          setState(() {
            widget.fieldFormData[widget.fieldKey] = value!;
          });
        },
      ),
    );
  }
}

class _FormPageMobileState extends State<FormPageMobile> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final List<bool> _selectedVehicleType = <bool>[true, false, false, false];
  List<Widget> fruits = <Widget>[
    Text(
      'Hybrid',
      style: TextStyle(
        fontFamily: 'Rounded MPlus',
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      'Sedan',
      style: TextStyle(
        fontFamily: 'Rounded MPlus',
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      'SUV',
      style: TextStyle(
        fontFamily: 'Rounded MPlus',
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      'Truck',
      style: TextStyle(
        fontFamily: 'Rounded MPlus',
        fontWeight: FontWeight.w600,
      ),
    )
  ];

  Map<int, dynamic> questionSet = {
    1: {
      'carType': 'Sedan',
      'dayTimeDriven': '',
      'dayMilesDriven': '',
    },
    2: {
      'electricalUsage': '',
    },
    3: {
      'dietType': '',
    }
  };

  Map<String, String> fieldForm = {
    'dayTimeDriven': '',
    'dayMilesDriven': '',
  };

  double _currentSliderValue = 500;

  @override
  Widget build(BuildContext context) {
    final TextEditingController milesFormController = TextEditingController();
    final TextEditingController timeFormController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: rootAppbar,
      drawer: CustomDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(40),
            child: Text(
              textAlign: TextAlign.center,
              'Before you continue to the next page please fill out the form to calculate your Carbon footprint value.',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[900],
                  fontFamily: 'Rounded MPlus',
                  fontWeight: FontWeight.bold),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          children: [
                            Text('Vehicle Type'),
                            const SizedBox(height: 5),
                            ToggleButtons(
                              direction: Axis.horizontal,
                              onPressed: (int index) {
                                setState(() {
                                  // The button that is tapped is set to true, and the others to false.
                                  for (int i = 0;
                                      i < _selectedVehicleType.length;
                                      i++) {
                                    _selectedVehicleType[i] = i == index;
                                  }
                                });
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              selectedBorderColor: Colors.grey[700],
                              selectedColor: Colors.white,
                              fillColor: Colors.green,
                              color: Colors.black,
                              constraints: const BoxConstraints(
                                minHeight: 40.0,
                                minWidth: 80.0,
                              ),
                              isSelected: _selectedVehicleType,
                              children: fruits,
                            ),
                          ],
                        ),
                      ),

                      CustomFormField(
                          fieldFormData: fieldForm,
                          fieldController: milesFormController,
                          fieldLabel: 'Daily Estimated Miles Commuted',
                          fieldKey: 'dayMilesDriven',
                          labelUnit: 'Miles'),
                      CustomFormField(
                          fieldFormData: fieldForm,
                          fieldController: timeFormController,
                          fieldLabel: 'Daily Estimated Time Driving',
                          fieldKey: 'dayTimeDriven',
                          labelUnit: 'Minutes'),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          'Estimated Montly Electrical Usage: ${_currentSliderValue} KW/H',
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontFamily: 'Rounded MPlus',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Slider(
                        value: _currentSliderValue,
                        max: 1000,
                        min: 300,
                        divisions: 20,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: formWidth(context),
                        decoration: boxDecorations,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }

                            Map formData = {
                              'carType': 'Sedan',
                              'dayTimeDriven': '',
                              'dayMilesDriven': '',
                              'electricalUsage': '',
                              'dietType': '',
                            };

                            // http.get(Uri.parse('uri?vehicleType=${}&dayTimeDriven=${}&dayMilesDriven=${}&electricalUsage=${}&dietType=${}'));
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[900],
                                fontFamily: 'Rounded MPlus',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                      // CustomFormField(
                      //   fieldFormData: fieldForm,
                      //   fieldController: milesFormController,
                      //   fieldLabel: 'Daily Estimated Miles Commuted',
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
