import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:octaviax/screens/albums.dart';
import 'package:octaviax/screens/artists.dart';
import 'package:octaviax/screens/favorites.dart';
import 'config.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'screens/allsongs.dart';
import 'constants/constants.dart';
import 'screens/miniplayer.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class OctaviaHome extends StatefulWidget {
  const OctaviaHome({Key? key}) : super(key: key);

  @override
  _OctaviaHomeState createState() => _OctaviaHomeState();
}

class _OctaviaHomeState extends State<OctaviaHome> {
  // late String? nowPlaying = '';
  // String? songName = 'check';
  // String? artist = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  format(Duration d) => d.toString().substring(2, 7);
  static List<Widget> tabs = [
    AllSongs(),
    const Albums(),
    Artists(),
    const Favorites()
  ];

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final Constants _constContr = Get.put(Constants());
    final Config _playerContr = Get.put(Config());

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Octavia",
            style: GoogleFonts.biryani(
                color: Colors.grey[600],
                letterSpacing: 10,
                fontWeight: FontWeight.w100,
                fontSize: 25),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () async {
                Get.isDarkMode
                    ? Get.changeThemeMode(ThemeMode.light)
                    : Get.changeThemeMode(ThemeMode.dark);
                _constContr.theme
                    .write('darkmode', !_constContr.theme.read('darkmode'));
              },
              icon: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: _constContr.theme.read('darkmode')
                    ? Icon(
                        Icons.dark_mode_sharp,
                        color: Colors.grey[600],
                      )
                    : Icon(Icons.dark_mode_outlined, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        body: Stack(children: [
          PageView.builder(
            itemCount: 4,
            controller: pageController,
            itemBuilder: (context, position) => tabs.elementAt(position),
            onPageChanged: (page) {
              _constContr.setTabIndex = page;
              pageController.animateToPage(page,
                  duration: Duration(milliseconds: 50),
                  curve: Curves.fastOutSlowIn);
            },
          ),
          Obx(
            () => _playerContr.getSongName != ''
                ? const Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: MiniPlayer(),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ),
        ]),
        bottomNavigationBar: SafeArea(
          child: Obx(
            () => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: context.isDarkMode ? Colors.black45 : Colors.white60,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: -3,
                    blurRadius: 60,
                    color: Colors.black.withOpacity(.4),
                    offset: const Offset(0, 25),
                  ),
                ],
              ),
              child: SnakeNavigationBar.color(
                behaviour: SnakeBarBehaviour.floating,
                snakeShape: SnakeShape.indicator,
                snakeViewColor:
                    Color(_constContr.colors[_constContr.getTabIndex]),
                selectedItemColor:
                    Color(_constContr.colors[_constContr.getTabIndex]),
                unselectedItemColor:
                    context.isDarkMode ? Colors.white : Colors.black,
                currentIndex: _constContr.getTabIndex,
                onTap: (index) {
                  _constContr.setTabIndex = index;
                  pageController.jumpToPage(
                    index,
                  );
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.music_note_outlined),
                    label: "Songs",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.album_outlined),
                    label: "Albums",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: "Artists",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outline),
                    label: "Favorites",
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
