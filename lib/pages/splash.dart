import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:youtube_api/youtube_api.dart';
import '../network/api.dart';
import '../utils/constants.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ApiService? apiService;
  var logger =Logger();
  bool isLoading = false;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoadingPlaylist = true;
  String API_Key = 'AIzaSyDNYc6e906fgd6ZkRY63aMLCSQS0trbsew';
  String API_CHANEL = 'UC-fP6AKyxBso2x6sGaG1J1w';
  Future<void> callAPI() async {
    //print('UI callled');
    //await Jiffy.locale("fr");
    ytResult = await ytApi!.channel(API_CHANEL);
    setState(() {
      //print('UI Updated');
      isLoading = false;
      callAPIPlaylist();
    });
  }
  Future<void> callAPIPlaylist() async {
    //print('UI callled');
    //await Jiffy.locale("fr");
    ytResultPlaylist = await ytApiPlaylist!.playlist(API_CHANEL);
    setState(() {
      print('UI Updated');
      print(ytResultPlaylist[0].title);
      isLoadingPlaylist = false;
    });
  }
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

      }
    } catch (error, stacktrace) {
      //internetProblem();

      return ApiService.withError("Data not found / Connection issue");
    }


  }
  /*Object internetProblem() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorPalette.appBarColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        title: Column(
          children: [
            SizedBox(
                width: 90,
                child: Lottie.asset(
                  kLoadingError,
                  width: 20,
                  height: 40,
                  repeat: true,
                  reverse: true,
                )
            ),
            Text('Precious TV',
              textAlign: TextAlign.center,style: GoogleFonts.lato(fontWeight: FontWeight.bold,fontSize: 20,color: ColorPalette.appYellowColor),)
          ],
        ),
        content:  Text(
          "Internet access problem, please check your connection and try again !!!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 18,color: ColorPalette.appYellowColor),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const SplashScreen(

                      )));

                },
                child: Container(
                  width: 120,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorPalette.appYellowColor,
                      borderRadius: BorderRadius.circular(35)),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child:  Text(
                    "Try again",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 16,color: ColorPalette.appBarColor),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );

  }*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ytApi = YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist = YoutubeAPI(API_Key, maxResults: 50, type: "playlist");
    callAPI();
    fetchConnexion();
    startTime();
  }
  startTime() async {
    var _duration = const Duration(seconds: 5);

    return Timer(_duration, navigationPage);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var bg = Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/SplashScreen.png"),
                fit: BoxFit.cover
            ),
          ),
        ),

      ],
    ); //<- Creates a widget that displays an image.

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          bg,
          Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Platform.isIOS?200:300,),

                ],
              )
          ),
        ],
        ), //<- place where the image appears
      ),
    );
  }
  Future<void> navigationPage()async {
    if(apiService !=null && apiService!=0){
      logger.i('Ghost-Elite',apiService!.allitems![0].hlsUrl);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(
          dataUrl: apiService!.allitems![0].hlsUrl,
          ytApi: ytApi,
          ytResult: ytResult,
          ytResultPlaylist: ytResultPlaylist,
        ),
        ),
            (Route<dynamic> route) => false,
      );
    }else{

    }

  }
}
