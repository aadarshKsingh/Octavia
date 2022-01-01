import 'package:flutter/material.dart';
import 'octavia_home.dart';
import 'package:get/get.dart';
// import 'package:just_audio_background/just_audio_background.dart';
import 'constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  await GetStorage.init();
  // WIP notification stuff
  // await JustAudioBackground.init(
  //     androidNotificationChannelName: 'com.ryanheise.bg_demo.channel.audio',
  //     androidNotificationChannelId: 'Audio Playback',
  //     androidNotificationOngoing: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;
  final Constants _constContr = Get.put(Constants());
  Rx<bool> status = false.obs;

  @override
  void initState() {
    getPerm();
    super.initState();
  }

  void getPerm() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        _constContr.setPerm();
      });
    } else
      openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    _constContr.theme.writeIfNull('darkmode', false);
    bool isDarkMode = _constContr.theme.read('darkmode');
    super.build(context);
    return GetMaterialApp(
        title: 'Octavia',
        darkTheme: ThemeData.dark(),
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: OctaviaHome());
  }
}
