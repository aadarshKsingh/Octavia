import 'package:flutter/material.dart';
import 'package:octaviax/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:scrollable_panel/scrollable_panel.dart';
import '../config.dart';
import 'package:get/get.dart';

class AllSongs extends StatefulWidget {
  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Config _playerContr = Get.put(Config());
  final Constants _constContr = Get.put(Constants());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<SongModel>>(
      future: OnAudioQuery().querySongs(
          sortType: SongSortType.DISPLAY_NAME,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL),
      builder: (context, item) {
        if (item.data == null) return const CircularProgressIndicator();
        if (item.data!.isEmpty) return const Text("Nothing found");
        _playerContr.songName.clear();
        _playerContr.artistName.clear();
        _playerContr.songUri.clear();
        _playerContr.id.clear();
        _playerContr.duration.clear();
        for (var song in item.data!) {
          _playerContr.songName.add(song.title);
          song.artist == '<unknown>'
              ? _playerContr.artistName.add("Unknown Artist")
              : _playerContr.artistName.add(song.artist.toString());

          _playerContr.songUri.add(song.data);
          _playerContr.id.add(song.id);
          _playerContr.duration.add(song.duration ?? 0);
        }

        return item.data != null
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: Get.height * 0.13),
                itemCount: item.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(item.data![index].title),
                    subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.data![index].artist == "<unknown>"
                              ? "Unknown Artist"
                              : item.data![index].artist.toString()),
                        ]),
                    trailing: IconButton(
                      onPressed: () {
                        _playerContr.addToFavorites(
                            item.data![index].title,
                            item.data![index].data,
                            item.data![index].artist.toString(),
                            item.data![index].id,
                            item.data![index].duration ?? 0);
                      },
                      icon: Obx(() => _playerContr.favoriteNames
                              .contains(item.data![index].title)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_outline)),
                    ),
                    leading: QueryArtworkWidget(
                        keepOldArtwork: true,
                        nullArtworkWidget: Container(
                          padding: const EdgeInsets.all(13.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: const Icon(
                            Icons.music_note,
                          ),
                        ),
                        id: item.data![index].id,
                        type: ArtworkType.AUDIO),
                    onTap: () async {
                      _playerContr.setUri(item.data![index].data);
                      _playerContr.setSong(item.data![index].title);
                      _playerContr.setArtist(item.data![index].artist);
                      _playerContr.setId(item.data![index].id);
                      _playerContr.setStatus(true);
                      _playerContr.setDuration(item.data![index].duration);
                      _playerContr.play();
                      _constContr.pc.value.open();
                      _constContr.panelState.value = PanelState.open;
                    },
                  );
                },
              )
            : const Center(
                child: Text("No Songs Found :("),
              );
      },
    );
  }
}
