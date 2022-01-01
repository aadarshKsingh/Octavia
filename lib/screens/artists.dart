import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'songFromArtist.dart';

class Artists extends StatefulWidget {
  Artists({Key? key, this.artist}) : super(key: key);
  final String? artist;

  @override
  State<Artists> createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<ArtistModel>>(
      future: OnAudioQuery().queryArtists(),
      builder: (context, item) => ListView.builder(
        padding: EdgeInsets.only(bottom: Get.height * 0.13),
        itemCount: item.data?.length ?? 0,
        itemBuilder: (context, artistIndex) => ListTile(
          leading: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Icon(
              Icons.person_outline,
            ),
          ),
          title: Text(item.data![artistIndex].artist == "<unknown>"
              ? "Unknown Artist"
              : item.data![artistIndex].artist.toString()),
          subtitle: Text(
            item.data![artistIndex].numberOfTracks.toString(),
          ),
          onTap: () => showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            context: context,
            builder: (context) =>
                SongFromArtist(artist: item.data![artistIndex].artist),
          ),
        ),
      ),
    );
  }
}
