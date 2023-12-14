import 'dart:async';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'package:scrollable_panel/scrollable_panel.dart';
import '../config.dart';
import '../constants/constants.dart';

class SongFromAlbum extends StatelessWidget {
  late final String? album;
  SongFromAlbum({Key? key, this.album}) : super(key: key);

  // @override
  // bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final Config _playerContr = Get.put(Config());
    final Constants _constContr = Get.put(Constants());
    return FutureBuilder<List<SongModel>>(
      future: getSongsforAlbum(album),
      builder: (context, item) => ListView.builder(
        itemCount: item.data?.length,
        itemBuilder: (context, index) => Wrap(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              leading: QueryArtworkWidget(
                keepOldArtwork: true,
                id: item.data?[index].id ?? 0,
                size: 500,
                artworkBorder: BorderRadius.all(Radius.circular(100)),
                type: ArtworkType.AUDIO,
              ),
              title: Text(item.data?[index].title ?? ''),
              subtitle: Text(item.data?[index].artist ?? ''),
              trailing: Text(
                _constContr.format(
                  Duration(milliseconds: item.data?[index].duration ?? 0),
                ),
              ),
              onTap: () {
                _playerContr.setUri(item.data![index].data);
                _playerContr.setSong(item.data![index].title);
                _playerContr.setArtist(item.data![index].artist);
                _playerContr.setId(item.data![index].id);
                _playerContr.setStatus(true);
                _playerContr.setDuration(item.data![index].duration);
                _playerContr.play();
                _constContr.pc.value.open();
                _constContr.changeState = PanelState.open;
                Navigator.pop(context);
              },
            ),
          ),
        ]),
      ),
    );
  }
}

Future<List<SongModel>> getSongsforAlbum(String? album) async {
  List<dynamic> stringList = await OnAudioQuery().queryWithFilters(
      album.toString(), WithFiltersType.AUDIOS,
      args: AudiosArgs.ALBUM);
  return stringList.toSongModel();
}
