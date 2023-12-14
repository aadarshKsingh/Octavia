import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'package:scrollable_panel/scrollable_panel.dart';
import '../config.dart';
import '../constants/constants.dart';

class SongFromArtist extends StatelessWidget {
  late final String? artist;
  SongFromArtist({Key? key, this.artist}) : super(key: key);

  // @override
  // bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    final Config _playerContr = Get.put(Config());
    final Constants _constContr = Get.put(Constants());
    return FutureBuilder<List<SongModel>>(
        future: getSongsforArtist(artist),
        builder: (context, item) {
          return ListView.builder(
            padding: EdgeInsets.only(bottom: Get.height * 0.13),
            shrinkWrap: true,
            itemCount: item.data?.length,
            itemBuilder: (context, index) => Wrap(children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  leading: QueryArtworkWidget(
                    id: item.data?[index].id ?? 0,
                    size: 500,
                    artworkBorder: BorderRadius.all(Radius.circular(100)),
                    type: ArtworkType.AUDIO,
                  ),
                  title: Text(
                    item.data?[index].title ?? "No Song",
                  ),
                  subtitle: Text(item.data?[index].album ?? ''),
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
                    _playerContr.getStatus
                        ? _playerContr.play()
                        : _playerContr.pause();
                    _constContr.pc.value.open();
                    _constContr.changeState = PanelState.open;
                    Navigator.pop(context);
                    Navigator.push(context, _constContr.getRoute);
                    _playerContr.update();
                  },
                ),
              ),
            ]),
          );
        });
  }
}

Future<List<SongModel>> getSongsforArtist(String? artist) async {
  List<dynamic> stringList = await OnAudioQuery().queryWithFilters(
      artist.toString(), WithFiltersType.AUDIOS,
      args: AudiosArgs.ARTIST);
  List<SongModel> converted = stringList.toSongModel();
  return converted;
}
