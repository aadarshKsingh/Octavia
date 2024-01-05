import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../config.dart';

class NowPlaying extends StatelessWidget {
  NowPlaying({Key? key}) : super(key: key);

  final Config _playerContr = Get.find();

  Duration _duration = Duration.zero;

  Duration _position = Duration.zero;

  format(Duration d) => d.toString().substring(2, 7);

  @override
  Widget build(BuildContext context) {
    // final Config _playerContr = Get.find();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
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
        SizedBox(
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
              artworkBorder: const BorderRadius.all(Radius.zero),
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 50.0, sigmaY: 50.0, tileMode: TileMode.clamp),
          child: const SizedBox(
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
                    borderRadius: const BorderRadius.all(
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
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  const SizedBox(height: 10),
                  Obx(
                    () => Text(
                      _playerContr.getArtist,
                      style: TextStyle(
                          fontSize: 20, color: Colors.white.withOpacity(0.9)),
                    ),
                  ),
                  const SizedBox(
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StreamBuilder(
                    stream: _playerContr.ap.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration>(
                          stream: _playerContr.ap.positionStream,
                          builder: (context, snapshot) {
                            var position = snapshot.data ?? Duration.zero;
                            _position = position;
                            // if (position > duration) {
                            //   position = duration;
                            // }
                            return Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    format(_playerContr.ap.position),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SliderTheme(
                                      data: SliderThemeData(
                                        trackHeight: 2,
                                        activeTrackColor: Colors.red,
                                        secondaryActiveTrackColor: Colors.red,
                                        inactiveTrackColor:
                                            Colors.grey.shade900,
                                        thumbShape:
                                            SliderComponentShape.noThumb,
                                        trackShape:
                                            const RoundedRectSliderTrackShape(),
                                      ),
                                      child: Expanded(
                                        child: Slider(
                                          min: 0.0,
                                          max: _playerContr.getDuration
                                                  .toDouble() +
                                              1.0,
                                          value: _playerContr
                                              .ap.position.inMilliseconds
                                              .toDouble(),
                                          onChanged: (value) {
                                            _playerContr.ap.seek(Duration(
                                                milliseconds: value.toInt()));
                                            _playerContr.setCurrentPosition =
                                                _playerContr
                                                    .ap.position.inMilliseconds;
                                            _playerContr.setCurrentPosition =
                                                value;
                                          },
                                        ),
                                      )),
                                  Text(
                                    format(Duration(
                                        milliseconds:
                                            _playerContr.getDuration)),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () async =>
                          _playerContr.ap.setLoopMode(LoopMode.one),
                      icon: const Icon(Icons.repeat),
                      color: Colors.white),
                ),
                SizedBox(
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      _playerContr.previousSong();
                      _playerContr.setStatus(true);
                    },
                    icon: const Icon(Icons.navigate_before_outlined,
                        size: 45, color: Colors.white),
                  ),
                ),
                SizedBox(
                  child: IconButton(
                    iconSize: 70,
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      if (_playerContr.getStatus) {
                        _playerContr.setStatus(false);
                        _playerContr.pause();
                      } else {
                        _playerContr.setStatus(true);
                        //DO NOT TOUCH THIS
                        // IT WORKS BUT IDK WHY
                        await _playerContr.ap.play();
                        await _playerContr.ap.seek(Duration(
                            milliseconds:
                                _playerContr.ap.position.inMilliseconds));
                        //////////////////////
                        _playerContr.setCurrentPosition =
                            _playerContr.ap.position.inMilliseconds;
                      }
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Obx(
                        () => _playerContr.getStatus
                            ? const Icon(
                                Icons.pause_circle,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.play_arrow_sharp,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      _playerContr.nextSong();
                      _playerContr.setStatus(true);
                    },
                    icon: const Icon(
                      Icons.navigate_next_outlined,
                      size: 45,
                      color: Colors.white,
                    ),
                  ),
                ),
                Obx(
                  () => _playerContr.favoriteNames
                          .contains(_playerContr.getSongName)
                      ? SizedBox(
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () => _playerContr.removeFromFavorites(
                                  _playerContr.getSongName,
                                  _playerContr.geturi,
                                  _playerContr.getArtist,
                                  _playerContr.getId,
                                  _playerContr.getDuration),
                              icon: const Icon(Icons.favorite_outlined),
                              color: Colors.white),
                        )
                      : SizedBox(
                          child: IconButton(
                              onPressed: () => _playerContr.addToFavorites(
                                  _playerContr.getSongName,
                                  _playerContr.geturi,
                                  _playerContr.getArtist,
                                  _playerContr.getId,
                                  _playerContr.getDuration),
                              icon: const Icon(Icons.favorite_border_outlined),
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
