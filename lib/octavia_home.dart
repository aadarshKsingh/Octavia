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
  static List<Widget> tabs = [AllSongs(), Albums(), Artists(), Favorites()];

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
              ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MiniPlayer(),
                  ),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
        ),
      ]),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: context.isDarkMode ? Colors.black45 : Colors.white60,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -3,
                  blurRadius: 60,
                  color: Colors.black.withOpacity(.4),
                  offset: Offset(0, 25),
                )
              ],
            ),
            child: GNav(
              hoverColor: Colors.grey,
              rippleColor: Color(_constContr.colors[_constContr.getTabIndex])
                  .withOpacity(0.5),
              tabBorderRadius: 10,
              tabMargin: EdgeInsets.all(10),
              tabBackgroundColor:
                  Color(_constContr.colors[_constContr.getTabIndex]),
              tabs: [
                GButton(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  icon: Icons.music_note_outlined,
                  text: "Songs",
                ),
                GButton(
                  icon: Icons.album_outlined,
                  text: "Albums",
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: "Artists",
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                ),
                GButton(
                  icon: Icons.favorite_outline,
                  text: "Favorites",
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                )
              ],
              selectedIndex: _constContr.getTabIndex,
              onTabChange: (index) {
                _constContr.setTabIndex = index;
                pageController.animateToPage(index,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeIn);
              },
            ),
          ),
        ),
      ),
    );
  }
}
