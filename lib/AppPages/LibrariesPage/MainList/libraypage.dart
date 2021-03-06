import 'package:cadenza/AppPages/LibrariesPage/MainList/playlistsgrid.dart';
import 'package:cadenza/SizeConfig.dart';
import 'package:cadenza/modules/library.dart';
import 'package:cadenza/modules/playlist.dart';
import 'package:cadenza/presentation/cutsom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'playlistcarousel.dart';

List<Playlist> playlistsExample = [
  Playlist(
    imageUrl: "assets/AlbumImages/art15.jpg",
    playlistName: "Beyond",
    description:
        " Enjoy the best music done by artists who are beyond amazeballz",
  ),
  Playlist(
    imageUrl: "assets/AlbumImages/playlist1.jpg",
    playlistName: "Luminate",
    description:
        " Enjoy the best music done by artists who are beyond amazeballz",
  ),
  Playlist(
    imageUrl: "assets/AlbumImages/playlist2.jpg",
    playlistName: "Beatz",
    description:
        " Enjoy the best music done by artists who are beyond amazeballz",
  ),
  Playlist(
    imageUrl: "assets/AlbumImages/playlist3.jpg",
    playlistName: "Hayooo!",
    description:
        " Enjoy the best music done by artists who are beyond amazeballz",
  ),
];

class LibraryPage extends StatefulWidget {
  final Function(String) changePage;
  final Function(Playlist) showPlaylist;

  const LibraryPage({Key key, this.changePage, this.showPlaylist})
      : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  SizeConfig _sizeConfig = SizeConfig();
  bool _firstBuild = true;
  Widget _playlist;
  bool _playlistMinimized = true;

  @override
  Widget build(BuildContext context) {
    _sizeConfig.init(context);
    bool playlistsReady = Provider.of<Library>(context, listen: false).playlistsReady;
    Widget _libraryText = Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical,
        left: SizeConfig.blockSizeHorizontal * 4,
        bottom: SizeConfig.blockSizeVertical * 3.5,
      ),
      child: Text(
        "Library",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 34,
        ),
      ),
    );

    Widget _playlistText = Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 4,
        bottom: SizeConfig.blockSizeVertical * 2,
      ),
      child: Text(
        "Playlists",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );

    Widget _songsText = FlatButton(
      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
      onPressed: () {
        widget.changePage("songs");
      },
      child: Row(
        children: <Widget>[
          Icon(
            CutsomIcons.songs,
            size: 32,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
            child: Text(
              "Songs",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );

    Widget _albumsText = FlatButton(
      onPressed: () {
        widget.changePage("albums");
      },
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 4,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            CutsomIcons.album,
            size: 32,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
            child: Text(
              "Albums",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );

    Widget _genresText = FlatButton(
      onPressed: () {
        widget.changePage("genres");
      },
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 4,
        // top: SizeConfig.blockSizeVertical * 2,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            CutsomIcons.genre,
            size: 32,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
            child: Text(
              "Genres",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );

    Widget _artistsText = FlatButton(
      onPressed: () {
        widget.changePage("artists");
      },
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 4,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            CutsomIcons.microphone,
            size: 32,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
            child: Text(
              "Artists",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );

    if (playlistsReady) {
      PlaylistsCarousel _playlistsCarousel = PlaylistsCarousel(
        items: Provider.of<Library>(context).playlists,
        showPlaylists: widget.showPlaylist,
      );

      PlaylistsGrid _playlistsGrid = PlaylistsGrid(
        items: Provider.of<Library>(context).playlists,
        showPlaylist: widget.showPlaylist,
      );

      Widget _playlistArrow = IconButton(
        icon: Icon(
          _playlistMinimized
              ? CutsomIcons.chevron_down
              : CutsomIcons.chevron_up,
          size: 32,
          color: Colors.black,
        ),
        onPressed: () {
          setState(() {
            _playlistMinimized = !(_playlistMinimized);
          });
        },
      );

      return CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _libraryText,
                _playlistText,
              ],
            ),
          ),
          _playlistMinimized
              ? SliverToBoxAdapter(child: _playlistsCarousel)
              : _playlistsGrid,
          SliverList(
            delegate: SliverChildListDelegate([
              _playlistArrow,
              _songsText,
              _albumsText,
              _genresText,
              _artistsText,
            ]),
          ),
        ],
      );
    }
    return FutureBuilder(
      future: Provider.of<Library>(context, listen: false).fetchPlaylists(),
      builder: (con, finishedFetching) {
        if (finishedFetching.connectionState == ConnectionState.waiting ||
            finishedFetching.hasError)
          return Center(child: CircularProgressIndicator());
        else {
          PlaylistsCarousel _playlistsCarousel = PlaylistsCarousel(
            items: Provider.of<Library>(context).playlists,
            showPlaylists: widget.showPlaylist,
          );

          PlaylistsGrid _playlistsGrid = PlaylistsGrid(
            items: Provider.of<Library>(context).playlists,
            showPlaylist: widget.showPlaylist,
          );

          Widget _playlistArrow = IconButton(
            icon: Icon(
              _playlistMinimized
                  ? CutsomIcons.chevron_down
                  : CutsomIcons.chevron_up,
              size: 32,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _playlistMinimized = !(_playlistMinimized);
              });
            },
          );

          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _libraryText,
                    _playlistText,
                  ],
                ),
              ),
              _playlistMinimized
                  ? SliverToBoxAdapter(child: _playlistsCarousel)
                  : _playlistsGrid,
              SliverList(
                delegate: SliverChildListDelegate([
                  _playlistArrow,
                  _songsText,
                  _albumsText,
                  _genresText,
                  _artistsText,
                ]),
              ),
            ],
          );
        }
      },
    );
  }
}
