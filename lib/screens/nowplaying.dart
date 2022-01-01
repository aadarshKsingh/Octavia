import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../config.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({Key? key}) : super(key: key);

  format(Duration d) => d.toString().substring(2, 7);
  @override
  Widget build(BuildContext context) {
    final Config _playerContr = Get.find();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Now Playing",
          style: TextStyle(fontSize: 25, color: Colors.white.withOpacity(0.9)),
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Obx(
            () => QueryArtworkWidget(
              nullArtworkWidget: Container(
                decoration: BoxDecoration(color: Colors.grey[800]),
                child: Icon(
                  Icons.music_note,
                  size: Get.height * 0.25,
                ),
              ),
              id: _playerContr.getId,
              type: ArtworkType.AUDIO,
              size: 500,
              artworkBorder: BorderRadius.all(Radius.zero),
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 50.0, sigmaY: 50.0, tileMode: TileMode.clamp),
          child: Container(
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => QueryArtworkWidget(
                nullArtworkWidget: Container(
                  height: Get.height * 0.3,
                  width: Get.height * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: Colors.grey[850],
                    size: 150,
                  ),
                ),
                id: _playerContr.getId,
                type: ArtworkType.AUDIO,
                artworkHeight: Get.height * 0.3,
                artworkWidth: Get.height * 0.3,
                size: 500,
              ),
            ),
            SizedBox(
              height: Get.height * 0.1,
            ),
            Wrap(children: [
              Column(
                children: [
                  Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        _playerContr.getSongName,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Obx(
                    () => Text(
                      _playerContr.getArtist,
                      style: TextStyle(
                          fontSize: 20, color: Colors.white.withOpacity(0.9)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ]),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Obx(
                    () => Text(
                      format(Duration(
                          milliseconds: _playerContr.getCurrentPosition)),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Obx(
                    () => Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 0.5,
                          activeTrackColor: Colors.grey.shade200,
                          inactiveTrackColor: Colors.grey.shade900,
                          thumbShape: SliderComponentShape.noThumb,
                          trackShape: RoundedRectSliderTrackShape(),
                        ),
                        child: Slider(
                            min: 0.0,
                            max: _playerContr.getDuration.toDouble() + 1.0,
                            value: _playerContr.getCurrentPosition.toDouble(),
                            onChanged: (value) {
                              _playerContr.ap
                                  .seek(Duration(milliseconds: value.toInt()));
                            }),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      format(Duration(milliseconds: _playerContr.getDuration)),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async =>
                          _playerContr.ap.setLoopMode(LoopMode.one),
                      icon: Icon(Icons.repeat),
                      color: Colors.white),
                ),
                Container(
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      _playerContr.previousSong();
                      _playerContr.setStatus(true);
                    },
                    icon: Icon(Icons.navigate_before_outlined,
                        size: 45, color: Colors.white),
                  ),
                ),
                Container(
                  child: IconButton(
                    iconSize: 70,
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      if (_playerContr.getStatus) {
                        _playerContr.setStatus(false);
                        _playerContr.pause();
                      } else {
                        _playerContr.setStatus(true);
                        if (_playerContr.getCurrentPosition == 0) {
                          _playerContr.play();
                        } else {
                          await _playerContr.ap.seek(Duration(
                              milliseconds: _playerContr.getCurrentPosition));
                          await _playerContr.ap.play();
                        }
                      }
                    },
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 400),
                      child: Obx(
                        () => _playerContr.getStatus
                            ? Icon(
                                Icons.pause_circle,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.play_arrow_sharp,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      _playerContr.nextSong();
                      _playerContr.setStatus(true);
                    },
                    icon: Icon(
                      Icons.navigate_next_outlined,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                ),
                Obx(
                  () => _playerContr.favoriteNames
                          .contains(_playerContr.getSongName)
                      ? Container(
                          child: IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () => _playerContr.removeFromFavorites(
                                  _playerContr.getSongName,
                                  _playerContr.geturi,
                                  _playerContr.getArtist,
                                  _playerContr.getId,
                                  _playerContr.getDuration),
                              icon: Icon(Icons.favorite_outlined),
                              color: Colors.white),
                        )
                      : Container(
                          child: IconButton(
                              onPressed: () => _playerContr.addToFavorites(
                                  _playerContr.getSongName,
                                  _playerContr.geturi,
                                  _playerContr.getArtist,
                                  _playerContr.getId,
                                  _playerContr.getDuration),
                              icon: Icon(Icons.favorite_border_outlined),
                              color: Colors.white),
                        ),
                )
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
