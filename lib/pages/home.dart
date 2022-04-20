import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:mouride_tv/pages/playlisYoutube.dart';
import 'package:mouride_tv/pages/radioPlayerScreen.dart';
import 'package:mouride_tv/pages/ytoubeplayer.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/youtube_api.dart';
import '../configs/size_config.dart';
import '../network/api.dart';
import '../utils/constants.dart';
import 'AllPlayListScreen.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  var dataUrl,radioUrl;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  HomePage({Key? key,this.dataUrl,required this.ytResult,this.ytApi,required this.ytResultPlaylist,this.ytApiPlaylist,this.radioUrl}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  GlobalKey _betterPlayerKey = GlobalKey();
  var scaffold = GlobalKey<ScaffoldState>();
  int _angle = 90;
  bool _isRotated = true;
  AnimationController? _controller;
  Animation<double>? _animation;
  Animation<double>? _animation2;
  Animation<double>? _animation3;
  BetterPlayerController? betterPlayerController;
  late final bool  videoLoading;
  ApiService? apiService;
  var logger=Logger();
  late var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    translations: [
      BetterPlayerTranslations(
        languageCode: "fr",
        generalDefaultError: "Impossible de lire la vidéo",
        generalNone: "Rien",
        generalDefault: "Défaut",
        generalRetry: "Réessayez",
        playlistLoadingNextVideo: "Chargement de la vidéo suivante",
        controlsNextVideoIn: "Vidéo suivante dans",
        overflowMenuPlaybackSpeed: "Vitesse de lecture",
        overflowMenuSubtitles: "Sous-titres",
        overflowMenuQuality: "Qualité",
        overflowMenuAudioTracks: "Audio",
        qualityAuto: "Auto",
      ),
    ],
    deviceOrientationsAfterFullScreen: [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    //autoDispose: true,
    controlsConfiguration: const BetterPlayerControlsConfiguration(
      /*loadingWidget: SizedBox(
          width: 100,
          child: Lottie.asset(
            kLoading,
            width: 60,
            repeat: true,
            reverse: true,
          )
      ),*/
      iconsColor: ColorPalette.appWhiteColor,
      //controlBarColor: colorPrimary,
      controlBarColor: Colors.transparent,
      liveTextColor: Colors.red,
      playIcon: Icons.play_arrow,
      enablePip: true,
      enableFullscreen: true,
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: ColorPalette.appWhiteColor,
      enableSkips: false,
      overflowMenuIconsColor: ColorPalette.appWhiteColor,
    ),
  );
  Future<ApiService?> fetchConnexion() async {

    try {
      var postListUrl =
      Uri.parse("https://acangroup.org/aar/mouride24/mouride24json.php");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print(data);
        setState(() {
          apiService = ApiService.fromJson(jsonDecode(response.body));

        });
        PlayerInit(apiService!.allitems![0].hlsUrl.toString());
      }
    } catch (error, stacktrace) {
      //internetProblem();

      return ApiService.withError("Data not found / Connection issue");
    }


  }
  void PlayerInit(String url){
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      liveStream: true,
      /*notificationConfiguration: const BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: "Elephant dream",
        author: "Some author",
        imageUrl:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/African_Bush_Elephant.jpg/1200px-African_Bush_Elephant.jpg",
      ),*/
    );
    //betterPlayerController.setupDataSource(dataSource);
    betterPlayerController?.setBetterPlayerGlobalKey(_betterPlayerKey);
    betterPlayerController?.setupDataSource(dataSource)
        .then((response) {
      //s.logger.i(' Ghost-Elite ',dataSource);
      videoLoading = false;
    })
        .catchError((error) async {
      // Source did not load, url might be invalid
      inspect(error);
    });
  }
  Future<void> retryMethode() async {
    // Create an HttpClient.
    final client = HttpClient();

    try {
      // Get statusCode by retrying a function
      final statusCode = await retry(
            () async {
          // Make a HTTP request and return the status code.
          final request = await client
              .getUrl(Uri.parse('https://www.google.com'))
              .timeout(Duration(seconds: 5));
          final response = await request.close().timeout(Duration(seconds: 5));
          await response.drain();
          return response.statusCode;
        },
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      // Print result from status code
      if (statusCode == 200) {
        logger.i('google.com is running');
        fetchConnexion();
      } else {
        logger.i('google.com is not availble...');
      }
    } finally {
      // Always close an HttpClient from dart:io, to close TCP connections in the
      // connection pool. Many servers has keep-alive to reduce round-trip time
      // for additional requests and avoid that clients run out of port and
      // end up in WAIT_TIME unpleasantries...
      client.close();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _animation =  CurvedAnimation(
      parent: _controller!,
      curve:  const Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = CurvedAnimation(
      parent: _controller!,
      curve: Interval(0.5, 1.0, curve: Curves.linear),
    );

    _animation3 = CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.8, 1.0, curve: Curves.linear),
    );


    _controller!.reverse();

    betterPlayerController = BetterPlayerController(betterPlayerConfiguration)..addEventsListener((error) => {
      if(error.betterPlayerEventType.index==9){
        logger.i(error.betterPlayerEventType.index,"index event"),
        retryMethode(),

        betterPlayerController!.retryDataSource()
      }
    });
    retryMethode();
  }
  void _rotate(){
    setState((){
      if(_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller!.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller!.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.w('message',widget.radioUrl);
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        backgroundColor: ColorPalette.appBarColor,
        centerTitle: true,
        title: Text('Accueil',
          style: GoogleFonts.inter(
              color: ColorPalette.appColor,
              fontWeight: FontWeight.bold),
        ),
          leading: GestureDetector(
            onTap: (){
              scaffold.currentState?.openDrawer();
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/menu.png')
                  )
              ),
            ),
          )
      ),
      drawer: DrawerPage(
        ytResult: widget.ytResult,
        ytResultPlaylist: widget.ytResultPlaylist,
        ytApiPlaylist: widget.ytApiPlaylist,
        dataUrl: widget.dataUrl,
        radioUrl: widget.radioUrl,
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: SizeConfi.screenWidth,
                    height: 190,
                    color: Colors.black,
                    child: betterPlayerController !=null?
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      key: _betterPlayerKey,
                      child: BetterPlayer(controller: betterPlayerController!),
                    ):Container(),
                  ),
                  Container(
                    width: SizeConfi.screenWidth,
                    height: SizeConfi.screenHeight! / 20,
                    decoration: const BoxDecoration(
                        color: ColorPalette.appColor,

                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 45),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          IconButton(onPressed: (){

                          },
                              icon: const Icon(
                                Icons.tv,size: 30,color: ColorPalette.appWhiteColor,
                              )
                          ),
                          Text('Mouride24 en Direct',style: GoogleFonts.inter(fontSize: 19,fontWeight: FontWeight.bold,color:ColorPalette.appWhiteColor),),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => YtoubePlayerPage(
                                  videoId: widget.ytResult[0].url,
                                  title: widget.ytResult[0].title,

                                  ytResult: widget.ytResult, videos: [],
                                  //apikey: API_Key,
                                ),
                              )
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 10,left: 10),
                          child: Text(
                            'Dernieres Videos',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: ColorPalette.appTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: ColorPalette.appIconPlayColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => YtoubePlayerPage(
                                  videoId: widget.ytResult[0].url,
                                  title: widget.ytResult[0].title,

                                  ytResult: widget.ytResult, videos: [],
                                  //apikey: API_Key,
                                ),
                              )
                          );

                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  carousel(),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10,left: 10,bottom: 5),
                        child: Text(
                          'Playlists',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: ColorPalette.appTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: ColorPalette.appTextColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlaylistYoutube(
                                  ytResultPlaylist: widget.ytResultPlaylist,
                                  //apikey: API_Key,
                                ),
                              )
                          );

                        },
                      )
                    ],
                  ),
                  makeMostPopular()
                ],
              ),
            ),
          ),
           Positioned(
              bottom: 200.0,
              right: 24.0,
              child:  Container(
                child:  Row(
                  children: <Widget>[
                     ScaleTransition(
                      scale: _animation3!,
                      alignment: FractionalOffset.center,
                      child:  Container(
                        margin:  EdgeInsets.only(right: 16.0),
                        child:  Text(
                          'foo1',
                          style:  TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color:  Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                     ScaleTransition(
                      scale: _animation3!,
                      alignment: FractionalOffset.center,
                      child:  Material(
                          color:  Color(0xFF9E9E9E),
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child:  GestureDetector(
                            child:  Container(
                                width: 40.0,
                                height: 40.0,
                                child:  InkWell(
                                  onTap: (){
                                    if(_angle == 45.0){
                                      print("foo1");
                                    }
                                  },
                                  child:  const Center(
                                    child:  Icon(
                                      Icons.add,
                                      color:  Color(0xFFFFFFFF),
                                    ),
                                  ),
                                )
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
           Positioned(
              bottom: 144.0,
              right: 20.0,
              child:  Container(
                child:  Row(
                  children: <Widget>[
                     /*ScaleTransition(
                      scale: _animation2!,
                      alignment: FractionalOffset.center,
                      child:  Container(
                        margin:  EdgeInsets.only(right: 16.0),
                        child:  Text(
                          'foo2',
                          style:  TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color:  Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )*/

                     ScaleTransition(
                      scale: _animation2!,
                      alignment: FractionalOffset.center,
                      child:  Material(
                          color:  ColorPalette.appWhiteColor,
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child:  GestureDetector(
                            child:  Container(
                                width: 50.0,
                                height: 50.0,
                                child:  InkWell(
                                  onTap: (){
                                    if(_angle == 50.0){
                                      print("foo2");
                                    }
                                  },
                                  child:  Stack(
                                    children: [
                                      Positioned(
                                        bottom: 9,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.radio,
                                            color: ColorPalette.appColor,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => RadioPlayerScreen(
                                                radioUrl: widget.radioUrl,
                                              ),
                                              ),

                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 6,
                                        left: 10,
                                        child: Container(
                                          child: Text('Actu',style: GoogleFonts.inter(color: ColorPalette.appTextColor,fontSize: 12),),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
           Positioned(
              bottom: 88.0,
              right: 19.0,
              child:  Container(
                child:  Row(
                  children: <Widget>[
                     /*ScaleTransition(
                      scale: _animation!,
                      alignment: FractionalOffset.center,
                      child:  Container(
                        margin:  const EdgeInsets.only(right: 16.0),
                        child:  const Text(
                          'foo3',
                          style:  TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color:  Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),*/

                     ScaleTransition(
                      scale: _animation!,
                      alignment: FractionalOffset.center,
                      child:  Material(
                          color:   ColorPalette.appWhiteColor,
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child:  GestureDetector(
                            child:  Container(
                                width: 50.0,
                                height: 50.0,
                                child:  InkWell(
                                  onTap: (){
                                    if(_angle == 50.0){
                                      print("foo3");
                                    }
                                  },
                                  child:  Stack(
                                    children: [
                                      Positioned(
                                        bottom: 9,
                                        child: IconButton(
                                          icon: const FaIcon(
                                            FontAwesomeIcons.book,
                                            size: 19,
                                            color: ColorPalette.appColor,
                                          ),
                                          onPressed: () {

                                          },
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 6,
                                        left: 10,
                                        child: Container(
                                          child: Text('Actu',style: GoogleFonts.inter(color: ColorPalette.appTextColor,fontSize: 12),),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
           Positioned(
            bottom: 16.0,
            right: 16.0,
            child:  Material(
                color:  ColorPalette.appColor,
                type: MaterialType.circle,
                elevation: 6.0,
                child:  GestureDetector(
                  child:  Container(
                      width: 56.0,
                      height: 56.00,
                      child:  InkWell(
                        onTap: _rotate,
                        child:  Center(
                            child:  RotationTransition(
                              turns:  AlwaysStoppedAnimation(_angle / 360),
                              child:  const Icon(
                                Icons.add,
                                color:  Color(0xFFFFFFFF),
                              ),
                            )
                        ),
                      )
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
  Widget carousel() {
    return CarouselSlider(
      options: CarouselOptions(
        // height: 240.0,
        //aspectRatio: 16/9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,

        scrollDirection: Axis.horizontal,
      ),

      items: [1,2,3,4,5,].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.black,
              child: SizedBox(
                width: SizeConfi.screenWidth,
                height: 150,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: SizeConfi.screenWidth,
                      height: 150,
                      color: Colors.white,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("${widget.ytResult[i].thumbnail["medium"]["url"]}"),
                              fit: BoxFit.cover
                          )
                      ),
                      child: Stack(
                        children: [
                          GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.bottomCenter,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/degrade.png"),
                                        fit: BoxFit.cover
                                    )
                                ),
                                child: Text(
                                  "${widget.ytResult[i].title}",
                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                  maxLines: 1,
                                ),
                              ),
                              onTap: () {


                              }
                          ),
                          Positioned.fill(
                            child: Center(
                              child: InkWell(
                                  child: Icon(
                                    Icons.play_circle,
                                    color: ColorPalette.appIconPlayColor,
                                    size: 60,

                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => YtoubePlayerPage(
                                            videoId: widget.ytResult[i].url,
                                            title: widget.ytResult[i].title,

                                            ytResult: widget.ytResult, videos: [],
                                            //apikey: API_Key,
                                          ),
                                        )
                                        );


                                  }
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),

            );


          },
        );
      }).toList(),
    );
  }
  Widget makeMostPopular() {
    return Container(
        height: 160,
        child: ListView.builder(
            itemCount: widget.ytResultPlaylist.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => AllPlayListScreen(
                          ytResult:widget.ytResultPlaylist[i],
                          //apikey: API_Key,
                        ),
                      ),
                          (Route<dynamic> route) => true);
                },
                child: SizedBox(
                  height: 160,
                  width: 140,
                  //margin: const EdgeInsets.only(left: 6,  top: 10, bottom: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 2,left: 2),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: 109,
                              width: MediaQuery.of(context).size.width,
                              child: GestureDetector(
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.ytResultPlaylist[i].thumbnail['medium']['url'],
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
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '${widget.ytResultPlaylist[i].title}',textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: ColorPalette.appTextColor
                          ),maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
    );
  }
}
