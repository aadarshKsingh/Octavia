import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'songFromAlbum.dart';
import 'package:get/get.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<AlbumModel>>(
      future: OnAudioQuery().queryAlbums(
          sortType: AlbumSortType.ALBUM,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL),
      builder: (context, item) => GridView.builder(
        padding: EdgeInsets.only(bottom: Get.height * 0.13),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 0, crossAxisSpacing: 0),
        itemCount: item.data?.length ?? 0,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.all(2.0),
          elevation: 0,
          child: GestureDetector(
            child: Stack(
              fit: StackFit.expand,
              children: [
                QueryArtworkWidget(
                    nullArtworkWidget: Container(
                      color: Colors.grey[800],
                      child: Icon(
                        Icons.music_note,
                        color: Colors.grey[900],
                        size: 100,
                      ),
                    ),
                    keepOldArtwork: true,
                    id: item.data![index].id,
                    type: ArtworkType.ALBUM,
                    size: 500,
                    artworkBorder: BorderRadius.zero,
                    artworkClipBehavior: Clip.antiAlias),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: item.data![index].album + "\n",
                        style: TextStyle(
                            // color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: item.data![index].numOfSongs.toString(),
                              style: TextStyle(fontSize: 11))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () => showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                context: context,
                builder: (context) =>
                    SongFromAlbum(album: item.data![index].album)),
          ),
        ),
      ),
    );
  }
}
