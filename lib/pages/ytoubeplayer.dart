

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../configs/size_config.dart';
import '../utils/constants.dart';
import 'home.dart';
/// Homepage
class YtoubePlayerPage extends StatefulWidget {

  var dataUrls;
 String? apiKey,
      channelId,
      videoId,
      texte,
      lien,
      url,
      title,
      img,
      date,
      related;
  final List<YT_API> ytResult;
  var data;
  YtoubePlayerPage(
      {Key? key,
       this.apiKey,this.data,
      this.channelId,
      this.videoId,
      required this.ytResult,
      this.texte,
      this.lien,
      this.url,
      this.title,
      this.img,
      this.date,
      this.related,this.dataUrls,
      required List videos})
      : super(key: key);

  @override
  _YtoubePlayerPageState createState() => _YtoubePlayerPageState();
}

class _YtoubePlayerPageState extends State<YtoubePlayerPage> {


  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String? uri,tite,lien,test;
  var logger =Logger();
  bool? videoLoading;
  late YoutubePlayerController _controller= YoutubePlayerController(initialVideoId: '');
  var data;
  var datas;
  var dataUrl;
  VoidCallback? listeners;
  GlobalKey _betterPlayerKey = GlobalKey();

  youtubePlayer(){
    lien =widget.videoId;
    _controller = YoutubePlayerController(
      initialVideoId:
      lien!.split("=")[1],
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,

      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    tite = widget.title;
  }

  @override
  void initState() {
    super.initState();
    youtubePlayer();
    //PlayerInit(widget.dataUrls);
    logger.i("initState");
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      logger.i("WidgetsBinding");
    });
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      logger.i("SchedulerBinding");
    });
    listeners = () {
      setState(() {
      });
    };
  }

  void listener() {
    if (_isPlayerReady && mounted && _controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

/*  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }*/

/*  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    logger.i(' message 2022',Jiffy(widget.ytResult[0].publishedAt,
        "yyyy-MM-ddTHH:mm:ssZ").format("dd/MM/yyyy a HH:mm"));
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
         //iconTheme: IconThemeData(color: ColorPalette.),
          title: Text('YouTube',style: GoogleFonts.inter(color: ColorPalette.appColor,fontSize: 24,fontWeight: FontWeight.bold),),

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
                      height: 82,
                    ),
                    Container(
                      width: SizeConfi.screenWidth,
                      height: 190,
                      child: _controller !=null?player:Container(),
                    ),
                    card(),
                    const SizedBox(
                      height: 10,
                    ),
                    videoSimilaire(),
                    Expanded(
                        child: listVideos(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget listVideos(){
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: widget.ytResult.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            setState(() {
              uri = widget.ytResult[index].url;
              //lien = widget.ytResult[index].url;
            });
            _controller.load(widget.ytResult[index].url.split("=")[1]);
            tite = widget.ytResult[index].title;
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 1,bottom: 3),
            child: Container(
              width: SizeConfi.screenWidth,
              height: 70,
              decoration: const BoxDecoration(
                color: ColorPalette.appWhiteColor,
                boxShadow: [
                  BoxShadow(
                      color: ColorPalette.appDivider,
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 1)
                  ),

                ],
              ),
              child: Row(
                children: [

                  Flexible(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${widget.ytResult[index].title}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,color: ColorPalette.appTextColor
                            ),maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 3,),
                        Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.topLeft,
                          //margin: EdgeInsets.all(5),
                          child: Text(
                            '${Jiffy(widget.ytResult[index].publishedAt,
                                "yyyy-MM-ddTHH:mm:ssZ").format("dd/MM/yyyy a HH:mm")} ',
                            style: GoogleFonts.poppins(
                                fontSize: 9.0,color: ColorPalette.appTextColor),maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )

                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        width: 100,
                        height: 70,
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            width: 100,
                            height: 70,
                            imageUrl: widget.ytResult[index].thumbnail["medium"]["url"],
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Image.asset(
                                  "assets/images/vignete.jpeg",
                                  width: 100,height: 70,fit: BoxFit.cover,
                                ),
                            errorWidget: (context, url, error) =>
                                Image.asset(
                                  "assets/images/vignete.jpeg",width: 100,height: 70,fit: BoxFit.cover,
                                ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 70,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/carreImage.png'),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              icon: Icon(
                                Icons.play_circle_fill,
                                color: ColorPalette.appIconPlayColor,
                              ),
                              onPressed: () {  },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget makeItemEpecial() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  //elevation: 4.0,
                  shadowColor: ColorPalette.appBarColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          /*Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      YtoubePlayerPage(
                                        videoId: widget.ytResult[position].url,
                                        title:widget.ytResult[position].title,

                                        related: "",
                                        ytResult: widget.ytResult,
                                      )),
                                  (Route<dynamic> route) => true);*/
                          setState(() {
                            uri = widget.ytResult[position].url;
                            //lien = widget.ytResult[index].url;
                          });
                          _controller.load(widget.ytResult[position].url.split("=")[1]);
                          tite = widget.ytResult[position].title;
                        },
                        child: Stack(
                          children: [
                            GestureDetector(

                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: 140,
                                height: 80,
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:widget.ytResult[position].thumbnail["medium"]["url"],
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 80,
                                    placeholder: (context, url) =>
                                        Image.asset(
                                          "assets/images/vignete.jpeg",fit: BoxFit.cover,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            "assets/images/vignete.jpeg",fit: BoxFit.cover
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: IconButton(
                                    icon: Icon(
                                        Icons.play_circle_fill,
                                      color: ColorPalette.appIconPlayColor,
                                    ),
                                    onPressed: () {  },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${widget.ytResult[position].title}',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: ColorPalette.appBarColor),maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                           /* const SizedBox(height: 3,),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: Text(
                                '${widget.ytResult[position].description}',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    color: ColorPalette.appBarColor),maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )*/
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: widget.ytResult.length>24?24:widget.ytResult.length,
    );

  }
  Widget videoSimilaire() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
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
              // SizedBox(width: 3,),

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
                style: const TextStyle(
                  color: ColorPalette.appWhiteColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: "helvetica",
                ),
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
