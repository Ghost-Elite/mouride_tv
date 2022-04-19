import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_api_v3/youtube_api_v3.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

import '../configs/size_config.dart';
import '../utils/constants.dart';


class youtubeplayerListPage extends StatefulWidget {
  String url,titre,image,desc;
  var data;
  YT_APIPlaylist? ytResult;
  youtubeplayerListPage({Key? key,required this.url,required this.titre,required this.image,required this.desc,this.data}) : super(key: key);

  @override
  _youtubeplayerListPageState createState() => _youtubeplayerListPageState();
}

class _youtubeplayerListPageState extends State<youtubeplayerListPage> {

  List<PlayListItem> videos = [];
  late YoutubePlayerController _controller;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  var data;
  String? uri,tite;
  var logger = Logger();
  List<YT_APIPlaylist> ytResultPlaylist = [];
  Future<List> getData() async {
    final response = await http.get(Uri.parse("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId="+widget.ytResult!.id+"&maxResults=10&key=AIzaSyC3Oj2o7fWNXEGcGIkiqVQPTRPVnzI43Wo"));
    data = json.decode(response.body);
    //this.videos.addAll(data["items"]);
    //logger.i(data["items"]==null?0:data["items"].length);

    //logger.i(data["items"][1]["snippet"]["title"]);
   // logger.i(data["items"]);

    setState(() {
    });

    return data["items"];
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //logger.i(widget.image);

    _controller = YoutubePlayerController(
      initialVideoId: widget.url.replaceAll("https://www.youtube.com/watch?v=", ""),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    _playerState = PlayerState.unknown;
    tite = widget.titre;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

 /* @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: ColorPalette.appBarColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ColorPalette.appColor),
              onPressed: () {
                //PlayerInit(widget.dataUrls);
                //PlayerInit();
                Navigator.of(context).pop();
              }
          ),
          title: Text('Lecteur',style: GoogleFonts.inter(color: ColorPalette.appColor,fontSize: 24,fontWeight: FontWeight.bold),),

        ),
        body: Container(

          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                //padding: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 89,
                    ),

                    Container(
                      width: double.infinity,
                      child: player,
                    ),
                    card(),
                    const SizedBox(
                      height: 5,
                    ),
                    videoSimilaire(),
                    Expanded(
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 2 ,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(10),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 4,
                          children: List.generate(widget.data==null?0:widget.data["items"].length, (index) {
                            return Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      //uri =data["items"][index]["snippet"]["resourceId"]["videoId"];
                                      uri = widget.data["items"][index]["snippet"]["title"];

                                    });
                                    _controller.load(widget.data['items'][index]["snippet"]["resourceId"]["videoId"]);
                                    tite = widget.data["items"][index]["snippet"]["title"];

                                  },
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          width: 150,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${widget.data["items"][index]["snippet"]["thumbnails"]["medium"]["url"]}'),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Center(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.play_circle_fill,
                                                size: 37,
                                                color: ColorPalette.appIconPlayColor,
                                              ), onPressed: () {  },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Text(
                                      "${widget.data["items"][index]["snippet"]["title"]}",
                                      style: GoogleFonts.inter(fontSize: 11,
                                          color: ColorPalette.appTextColor),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget videoSimilaire() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 10.2),
          //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: const Text(
                  "Vidéos Similaires",
                  style: TextStyle(
                    color: ColorPalette.appTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "helvetica",
                  ),
                ),
              ),
            ],
          ),
        ),


      ],
    );
  }
  Widget card() {
    return Container(
      width: SizeConfi.screenWidth,
      height: SizeConfi.screenHeight! / 20,
      decoration: const BoxDecoration(
          color: ColorPalette.appColor,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "${tite}",
                style: GoogleFonts.inter(color: ColorPalette.appWhiteColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
