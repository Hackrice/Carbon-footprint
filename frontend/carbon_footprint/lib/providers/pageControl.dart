import 'package:flutter/material.dart';

class PageControlNotifier extends ChangeNotifier {
  int pageIndex = 0;

  void changePage(int newIndex, BuildContext context) {
    pageIndex = newIndex;
    notifyListeners();
  }
}
