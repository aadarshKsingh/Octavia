import 'package:flutter/material.dart';
import 'package:octaviax/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:scrollable_panel/scrollable_panel.dart';
import '../config.dart';
import 'package:get/get.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Config _playerContr = Get.put(Config());
    final Constants _constContr = Get.put(Constants());
    return Obx(
      () => _playerContr.favoriteNames.length == 0
          ? Center(child: Text("No Favorites"))
          : ListView.builder(
              padding: EdgeInsets.only(bottom: Get.height * 0.13),
              itemCount: _playerContr.favoriteNames.length,
              itemBuilder: (context, index) => ListTile(
                leading: QueryArtworkWidget(
                    nullArtworkWidget: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: Icon(
                        Icons.music_note,
                      ),
                    ),
                    keepOldArtwork: true,
                    size: 500,
                    id: _playerContr.favoriteId[index],
                    type: ArtworkType.AUDIO),
                title: Text(_playerContr.favoriteNames[index]),
                subtitle: Text(_playerContr.favoriteArtist[index] == "<unknown>"
                    ? "Unknown Artist"
                    : _playerContr.favoriteArtist[index]),
                trailing: IconButton(
                    onPressed: () => _playerContr.removeFromFavorites(
                        _playerContr.favoriteNames[index],
                        _playerContr.favoriteUri[index],
                        _playerContr.favoriteArtist[index],
                        _playerContr.favoriteId[index],
                        _playerContr.favoriteDuration[index]),
                    icon: Icon(Icons.favorite_outlined)),
                onTap: () {
                  _playerContr.setUri(_playerContr.favoriteUri[index]);
                  _playerContr.setSong(_playerContr.favoriteNames[index]);
                  _playerContr.setArtist(_playerContr.favoriteArtist[index]);
                  _playerContr.setId(_playerContr.favoriteId[index]);
                  _playerContr.setStatus(true);
                  _playerContr
                      .setDuration(_playerContr.favoriteDuration[index]);
                  _playerContr.getStatus
                      ? _playerContr.play()
                      : _playerContr.pause();
                  _constContr.pc.value.open();
                  _constContr.changeState = PanelState.open;
                  Navigator.push(context, _constContr.getRoute);
                  _playerContr.update();
                },
              ),
            ),
    );
  }
}
