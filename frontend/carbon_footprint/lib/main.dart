// ignore_for_file: prefer_const_constructors
import 'package:carbon_footprint/Auth/AuthPage.dart';
import 'package:carbon_footprint/pages/CalanderPage/calanderPage.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/desktop_scaffold.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/mobile_scaffold.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/tablet_scaffold.dart';
import 'package:carbon_footprint/pages/FormPage/form_page_mobile.dart';
import 'package:carbon_footprint/pages/Home/home_page_desktop.dart';
import 'package:carbon_footprint/pages/Home/home_page_mobile.dart';
import 'package:carbon_footprint/pages/Home/home_page_tablet.dart';
import 'package:carbon_footprint/responsive/responsive_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Setup for firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Setup hive local db
  await Hive.initFlutter();
  await Hive.openBox("local");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/exampleResponsiveLayout': (BuildContext context) => ResponsiveLayout(
              mobileScaffold: MobileScaffold(),
              tabletScaffold: TabletScaffold(),
              desktopScaffold: DesktopScaffold(),
            ),

        //?    ___             ___          __  _             ___            __
        //?   / _ | ___  ___  / (_)______ _/ /_(_)__  ___    / _ \___  __ __/ /____ ___
        //?  / __ |/ _ \/ _ \/ / / __/ _ `/ __/ / _ \/ _ \  / , _/ _ \/ // / __/ -_|_-<
        //? /_/ |_/ .__/ .__/_/_/\__/\_,_/\__/_/\___/_//_/ /_/|_|\___/\_,_/\__/\__/___/
        //?      /_/  /_/
        '/auth': (BuildContext context) => AuthPage(),
        '/home': (BuildContext context) => ResponsiveLayout(
              mobileScaffold: HomePageMobile(),
              tabletScaffold: HomePageTablet(),
              desktopScaffold: HomePageDesktop(),
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ResponsiveLayout(
            mobileScaffold: HomePageMobile(),
            tabletScaffold: HomePageTablet(),
            desktopScaffold: HomePageDesktop(),
          );
        } else {
          return AuthPage();
        }
      },
    );
  }
}
