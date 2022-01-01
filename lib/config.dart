import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/constants.dart';
import 'package:scrollable_panel/scrollable_panel.dart';

class Config extends GetxController {
  RxList<String> songUri = [''].obs;
  RxBool isPlaying = false.obs;
  RxList<String> songName = [''].obs;
  RxList<String> artistName = [''].obs;
  RxList<int> id = [0].obs;
  RxList<int> duration = [0].obs;
  RxString currentUri = ''.obs;
  RxString currentSongName = 'No Song'.obs;
  RxString currentArtistName = 'No Artist'.obs;
  RxInt currentId = 0.obs;
  RxInt currentDuration = 0.obs;
  RxInt currentPosition = 0.obs;
  var status = 0;

  final Constants _constContr = Get.put(Constants());

  //favorites
  var favoriteUri = RxList<String>();
  var favoriteNames = RxList<String>();
  var favoriteArtist = RxList<String>();
  var favoriteId = RxList<int>();
  var favoriteDuration = RxList<int>();

  final ap = AudioPlayer();

  @override
  onInit() {
    _defaultSp();
    super.onInit();
  }

  @override
  onClose() {
    ap.dispose();
    super.dispose();
  }

  _defaultSp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUri.value = prefs.getString("currentUri") ?? "";
    currentSongName.value = prefs.getString("currentSongName") ?? "";
    currentArtistName.value = prefs.getString("currentArtistName") ?? "";
    currentId.value = prefs.getInt("currentId") ?? 0;
    currentDuration.value = prefs.getInt("currentDuration") ?? 0;
    currentPosition.value = prefs.getInt("currentPosition") ?? 0;
    favoriteNames.value = prefs.getStringList('favoriteNames') ?? [];
    favoriteArtist.value = prefs.getStringList('favoriteArtist') ?? [];
    favoriteUri.value = prefs.getStringList('favoriteUri') ?? [];

    favoriteDuration.value = prefs
            .getStringList('favoriteDuration')
            ?.map((e) => int.parse(e))
            .toList() ??
        [0];
    favoriteId.value =
        prefs.getStringList('favoriteId')?.map((e) => int.parse(e)).toList() ??
            [0];

    if (currentSongName != '') {
      _constContr.pc.value.open();
      _constContr.panelState.value = PanelState.open;
    }
  }

  _setSp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("currentUri", currentUri.value);
    prefs.setString("currentSongName", currentSongName.value);
    prefs.setString("currentArtistName", currentArtistName.value);
    prefs.setInt("currentId", currentId.value);
    prefs.setInt("currentDuration", currentDuration.value);
    prefs.setInt("currentPosition", currentPosition.value);
    prefs.setStringList('favoriteNames', favoriteNames);
    prefs.setStringList("favoriteArtist", favoriteArtist);
    prefs.setStringList('favoriteUri', favoriteUri);
    prefs.setStringList(
        'favoriteDuration', favoriteDuration.map((e) => e.toString()).toList());
    prefs.setStringList(
        'favoriteId', favoriteId.map((e) => e.toString()).toList());
  }

  setUri(var currentUri) {
    this.currentUri.value = currentUri;
  }

  setSong(var currentName) {
    this.currentSongName.value = currentName;
  }

  setArtist(var currentArtist) {
    this.currentArtistName.value = currentArtist;
  }

  setStatus(var status) {
    this.isPlaying.value = status;
  }

  setId(var id) {
    this.currentId.value = id;
  }

  setDuration(var duration) {
    this.currentDuration.value = duration;
  }

  setPosition(var duration) async {
    this.currentPosition.value = await duration;
  }

  play() async {
    var song = await ap.setUrl(currentUri.value);
    ap.play();
    ap.positionStream.listen((event) {
      currentPosition.value = event.inMilliseconds;
      if (event.inMilliseconds >= currentDuration.value) nextSong();
    });

    _setSp();
  }

  pause() async {
    ap.pause();
    status = 0;
  }

  previousSong() async {
    ap.pause();
    if (songUri.indexOf(currentUri.value) > 0) {
      currentSongName.value = songName[songUri.indexOf(currentUri.value) - 1];
      currentArtistName.value =
          artistName[songUri.indexOf(currentUri.value) - 1];
      currentUri.value = songUri[songUri.indexOf(currentUri.value) - 1];
      currentId.value = id[id.indexOf(currentId.value) - 1];
      currentDuration.value =
          duration[duration.indexOf(currentDuration.value) - 1];
    } else {
      currentSongName.value = songName[songName.length - 1];
      currentArtistName.value = artistName[artistName.length - 1];
      currentUri.value = songUri[songUri.length - 1];
      currentId.value = id[id.length - 1];
      currentDuration.value = duration[duration.length - 1];
    }
    play();
  }

  nextSong() async {
    ap.pause();
    if (songUri.indexOf(currentUri.value) < songUri.length - 1) {
      currentSongName.value = songName[songUri.indexOf(currentUri.value) + 1];
      currentArtistName.value =
          artistName[songUri.indexOf(currentUri.value) + 1];
      currentUri.value = songUri[songUri.indexOf(currentUri.value) + 1];
      currentId.value = id[id.indexOf(currentId.value) + 1];
      currentDuration.value =
          duration[duration.indexOf(currentDuration.value) + 1];
    } else {
      currentSongName.value = songName[0];
      currentArtistName.value = artistName[0];
      currentUri.value = songUri[0];
      currentId.value = id[0];
      currentDuration.value = duration[0];
    }
    play();
  }

  addToFavorites(
      String title, String uri, String artist, int id, int duration) async {
    favoriteNames.add(title);
    favoriteArtist.add(artist);
    favoriteId.add(id);
    favoriteDuration.add(duration);
    favoriteUri.add(uri);
    _setSp();
  }

  removeFromFavorites(
      String title, String uri, String artist, int id, int duration) async {
    favoriteNames.remove(title);
    favoriteArtist.remove(artist);
    favoriteId.remove(id);
    favoriteDuration.remove(duration);
    favoriteUri.remove(uri);
  }

  removeMiniPlayer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    currentArtistName.value = '';
    currentSongName.value = '';
    currentDuration.value = 0;
    currentPosition.value = 0;
    currentId.value = 0;
    currentUri.value = '';
    _setSp();
  }

  get geturi => currentUri.value;
  get getSongName => currentSongName.value;
  get getArtist => currentArtistName.value;
  get getStatus => isPlaying.value;
  get getId => currentId.value;
  get getDuration => currentDuration.value;
  get getCurrentPosition => currentPosition.value;
}
