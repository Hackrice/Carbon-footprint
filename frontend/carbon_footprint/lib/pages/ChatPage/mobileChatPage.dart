// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'package:carbon_footprint/pages/Home/home_page_desktop.dart';
import 'package:carbon_footprint/pages/Home/home_page_mobile.dart';
import 'package:carbon_footprint/pages/Home/home_page_tablet.dart';
import 'package:carbon_footprint/pages/NavigationPage/navigation_page.dart';
import 'package:carbon_footprint/providers/pageControl.dart';
import 'package:carbon_footprint/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class MessageSend extends StatelessWidget {
  const MessageSend(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            // width: 300,
            // height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      width: 320,
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 15),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: Colors.amber[200],
                //     borderRadius: BorderRadius.only(
                //       bottomRight: Radius.circular(10),
                //       bottomLeft: Radius.circular(10),
                //     ),
                //   ),
                //   // width: 100,
                //   height: 40,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       Icon(
                //         Icons.question_mark_rounded,
                //         size: 20,
                //       ),
                //       Text('Suggestion: Commute before or after rush hour'),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageResponse extends StatelessWidget {
  const MessageResponse(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 340,
            // height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: 320,
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 15),
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MobileChatPage extends StatefulWidget {
  const MobileChatPage({Key? key}) : super(key: key);

  @override
  State<MobileChatPage> createState() => _MobileChatPageState();
}

class _MobileChatPageState extends State<MobileChatPage> {
  final pageControlProvider = ChangeNotifierProvider<PageControlNotifier>(
    (ref) => PageControlNotifier(),
  );

  List messages = [];

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NavigationDestinationLabelBehavior labelBehavior =
        NavigationDestinationLabelBehavior.alwaysShow;
    int pageIndex = 2;
    return Consumer(
      builder: (context, ref, child) {
        final pageControlState = ref.watch(pageControlProvider);
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            labelBehavior: labelBehavior,
            selectedIndex: pageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                if (index != 2) {
                  pageControlState.pageIndex = index;

                  if (index == 1) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) {
                          return ResponsiveLayout(
                            mobileScaffold: MobileCarbonReduction(),
                            tabletScaffold: HomePageTablet(),
                            desktopScaffold: HomePageDesktop(),
                          );
                        },
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  }
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
                }
              });
            },
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.data_thresholding_outlined),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.commute),
                label: 'Reduction Options',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_outlined),
                label: 'Carbon Chat',
              ),
            ],
          ),
          backgroundColor: Colors.grey[300],
          body: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Carbonaid Personal Chat',
                  style: TextStyle(fontFamily: 'BebasNeue', fontSize: 40),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, right: 10),
                margin: EdgeInsets.all(10),
                width: double.infinity,
                height: 550,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [...messages],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * .7,
                      child: TextFormField(controller: messageController),
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          messages.add(MessageSend(messageController.text));
                        });
                        messageController.clear();
                        final response = await http.post(Uri.parse(
                            'http://159.65.240.201:8080/selfprompt?prompt=${messageController.text}'));

                        setState(() {
                          messages.add(MessageResponse(response.body));
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        color: Colors.grey[200],
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Icon(Icons.send),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
