import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../config.dart';
import 'package:scrollable_panel/scrollable_panel.dart';
import '../constants/constants.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Config _playerContr = Get.find();
    final Constants _constContr = Get.find();
    return Obx(
      () => GestureDetector(
        child: ScrollablePanel(
          controller: _constContr.pc.value,
          maxPanelSize: 1.0,
          minPanelSize: 0,
          defaultPanelSize: 0.13,
          defaultPanelState: _constContr.panelState.value,
          builder: (context, sc) => Card(
            elevation: 10,
            child: Stack(children: [
              QueryArtworkWidget(
                nullArtworkWidget:
                    Center(child: Icon(Icons.music_note_rounded)),
                id: _playerContr.getId,
                type: ArtworkType.AUDIO,
                size: 1000,
                artworkHeight: Get.height * 0.13,
                artworkWidth: Get.width,
                artworkBorder: BorderRadius.all(Radius.circular(5)),
                artworkQuality: FilterQuality.high,
              ),
              ClipRRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      height: 200,
                      width: Get.width,
                    )),
              ),
              Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      alignment: Alignment.topCenter,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Wrap(
                                clipBehavior: Clip.antiAlias,
                                children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _playerContr.getSongName,
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          _playerContr.getArtist,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                            Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        splashRadius: 5,
                                        onPressed: () =>
                                            _playerContr.previousSong(),
                                        icon: Icon(
                                            Icons.navigate_before_outlined),
                                      ),
                                      Obx(
                                        () => IconButton(
                                          splashRadius: 5,
                                          onPressed: () async {
                                            if (_playerContr.getStatus) {
                                              _playerContr.setStatus(false);
                                              _playerContr.pause();
                                            } else {
                                              _playerContr.setStatus(true);
                                              if (_playerContr
                                                      .getCurrentPosition ==
                                                  0) {
                                                _playerContr.play();
                                              } else {
                                                await _playerContr.ap.seek(Duration(
                                                    milliseconds: _playerContr
                                                        .getCurrentPosition));
                                                await _playerContr.ap.play();
                                              }
                                            }
                                          },
                                          icon: AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 400),
                                            child: _playerContr.getStatus
                                                ? Icon(Icons.pause_circle)
                                                : Icon(Icons.play_arrow_sharp),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        splashRadius: 5,
                                        onPressed: () =>
                                            _playerContr.nextSong(),
                                        icon:
                                            Icon(Icons.navigate_next_outlined),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // NowPlaying()
                ],
              ),
            ]),
          ),
        ),
        onPanUpdate: (details) => {
          if (details.delta.dy > 0 ||
              details.delta.dx > 0 ||
              details.delta.dx < 0)
            {
              _playerContr.ap.pause(),
              _constContr.pc.value.close(),
              _constContr.panelState.value = PanelState.close,
              _playerContr.removeMiniPlayer()
            }
          else
            Navigator.push(context, _constContr.getRoute)
        },
        onTap: () => Navigator.push(context, _constContr.getRoute),
      ),
    );
  }
}
