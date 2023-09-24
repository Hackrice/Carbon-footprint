// ignore_for_file: prefer_final_fields, constant_identifier_names, avoid_print, file_names, use_key_in_widget_constructors, must_be_immutable, sort_child_properties_last, prefer_const_constructors, library_private_types_in_public_api, unnecessary_string_interpolations

import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AuthMode { Signup, Login }

enum DeviceType { Mobile, Tablet, Desktop }

final userChangeProvider =
    ChangeNotifierProvider<AuthState>((ref) => AuthState());

class AuthPage extends ConsumerWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = MediaQuery.of(context).size;
    final AuthState userProvider = ref.watch(userChangeProvider);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              color: defaultBackground,
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 0.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'CarbonAid',
                        style: TextStyle(
                          fontSize: 60,
                          fontFamily: 'BebasNeue',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(userProvider),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  AuthCard(this.userProvider);
  AuthState userProvider;

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'username': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _userIdController = TextEditingController();

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  late FToast fToast;

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Widget authToast(String message, bool isError) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: isError ? Colors.red : Colors.green[300],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isError ? Icons.warning_amber_rounded : Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              message,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    DeviceType deviceType() {
      if (deviceSize.width < 500) {
        return DeviceType.Mobile;
      }
      if (deviceSize.width < 1100) {
        return DeviceType.Tablet;
      } else {
        return DeviceType.Desktop;
      }
    }

    double formWidth() {
      if (deviceSize.width < 500) {
        return deviceSize.width * .6;
      }
      if (deviceSize.width < 1100) {
        return deviceSize.width * .4;
      } else {
        return deviceSize.width * .4;
      }
    }

    return Container(
      height: _authMode == AuthMode.Signup ? 600 : 220,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Container(
            width: deviceType() == DeviceType.Mobile
                ? deviceSize.width * .75
                : deviceSize.width * .4,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (_authMode == AuthMode.Signup)
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        width: formWidth(),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          controller: _userIdController,
                          enabled: _authMode == AuthMode.Signup,
                          cursorColor: Colors.grey[900],
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontFamily: 'Rounded MPlus',
                              fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Rounded MPlus',
                                  fontWeight: FontWeight.bold)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a Username';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            _authData['username'] = value!;
                          },
                        ),
                      ),
                    //! STATE INFORMATION
                    if (_authMode == AuthMode.Signup)
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        width: formWidth(),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          controller: _stateController,
                          enabled: _authMode == AuthMode.Signup,
                          cursorColor: Colors.grey[900],
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontFamily: 'Rounded MPlus',
                              fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'State',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Rounded MPlus',
                                  fontWeight: FontWeight.bold)),
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value == '' || value!.isEmpty) {
                                    fToast.showToast(
                                      child: authToast(
                                          'Please Fill a Value For The State! ',
                                          true),
                                      gravity: ToastGravity.BOTTOM,
                                      toastDuration: Duration(seconds: 4),
                                    );
                                    return 'Please Fill a Value For The State!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    if (_authMode == AuthMode.Signup)
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        width: formWidth(),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          controller: _cityController,
                          enabled: _authMode == AuthMode.Signup,
                          cursorColor: Colors.grey[900],
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontFamily: 'Rounded MPlus',
                              fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'City',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Rounded MPlus',
                                  fontWeight: FontWeight.bold)),
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value == '' || value!.isEmpty) {
                                    fToast.showToast(
                                      child: authToast(
                                          'Please Fill a Value For The City!',
                                          true),
                                      gravity: ToastGravity.BOTTOM,
                                      toastDuration: Duration(seconds: 4),
                                    );
                                    return 'Please Fill a Value For The City';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),

                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 10),
                      height: 50,
                      width: formWidth(),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        cursorColor: Colors.grey[900],
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: 'Rounded MPlus',
                            fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: 'E-Mail',
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Rounded MPlus',
                                fontWeight: FontWeight.bold)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                          // return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 10),
                      height: 50,
                      width: formWidth(),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
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
                            focusColor: Colors.grey[900],
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Rounded MPlus',
                                fontWeight: FontWeight.bold)),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                      ),
                    ),
                    if (_authMode == AuthMode.Signup)
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        width: formWidth(),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          controller: _passwordConfirmController,
                          enabled: _authMode == AuthMode.Signup,
                          cursorColor: Colors.grey[900],
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontFamily: 'Rounded MPlus',
                              fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Rounded MPlus',
                                  fontWeight: FontWeight.bold)),
                          obscureText: true,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    fToast.showToast(
                                      child: authToast(
                                          'Passwords do not match!', true),
                                      gravity: ToastGravity.BOTTOM,
                                      toastDuration: Duration(seconds: 4),
                                    );
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            child: Text(
                              _authMode == AuthMode.Login
                                  ? 'Sign In'
                                  : 'Register',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Rounded MPlus',
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: _authMode == AuthMode.Login
                                ? () {
                                    setState(
                                      () {
                                        widget.userProvider
                                            .login(_emailController.text.trim(),
                                                _passwordController.text.trim())
                                            .then(
                                          (result) {
                                            result['isError']
                                                ? fToast.showToast(
                                                    child: authToast(
                                                        result['message'],
                                                        result['isError']),
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    toastDuration:
                                                        Duration(seconds: 4),
                                                  )
                                                : print(result.runtimeType);
                                            print(_emailController.text);
                                            print(_passwordController.text);
                                          },
                                        );
                                      },
                                    );
                                  }
                                : () {
                                    setState(
                                      () {
                                        widget.userProvider
                                            .signUp(
                                                _userIdController.text,
                                                _emailController.text,
                                                _passwordController.text,
                                                _passwordConfirmController.text)
                                            .then(
                                          (result) async {
                                            // if (result['isError']) {
                                            //   fToast.showToast(
                                            //     child: authToast(
                                            //         result['message'],
                                            //         result['isError']),
                                            //     gravity: ToastGravity.BOTTOM,
                                            //     toastDuration:
                                            //         Duration(seconds: 4),
                                            //   );
                                            // }
                                            var lazyBox = Hive.box('local');

                                            print('LOCAL STORE AFTER AUTH ');
                                            print(
                                                await lazyBox.get('formData'));
                                          },
                                        );
                                      },
                                    );
                                  },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          TextButton(
                            child: Text(
                              '${_authMode == AuthMode.Login ? 'Register' : 'Sign In'}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Rounded MPlus',
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: _switchAuthMode,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     widget.userProvider.anonLogin();
          //   },
          //   child: Text(
          //     'Sign in as Guest',
          //     style: TextStyle(color: Colors.grey[600]),
          //   ),
          // )
        ],
      ),
    );
  }
}
