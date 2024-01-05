import 'package:get/get.dart';
import 'package:scrollable_panel/scrollable_panel.dart';
import 'package:flutter/material.dart';
import '../screens/nowplaying.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class Constants extends GetxController {
  static RxInt _selectedIndex = 0.obs;
  get getTabIndex => _selectedIndex.value;
  set setTabIndex(int value) => _selectedIndex.value = value;
  Rx<PanelState> panelState = PanelState.close.obs;
  Rx<PanelController> pc = PanelController().obs;
  set changeState(PanelState ps) => panelState.value = ps;
  format(Duration d) => d.toString().substring(2, 7);

  setPerm() async {
    await Permission.audio.request();
  }

  final theme = GetStorage();

  final List<int> colors = [
    0xFFEF9A9A,
    0xFF90CAF9,
    0xFFB39DDB,
    0xFF9CCC65,
  ];

  Route _nowPlayingRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => NowPlaying(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  get getRoute => _nowPlayingRoute();
}
