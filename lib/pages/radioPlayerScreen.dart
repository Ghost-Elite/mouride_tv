import 'dart:convert';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:volume/volume.dart';
import 'package:wakelock/wakelock.dart';

import '../configs/size_config.dart';
import '../utils/constants.dart';




// ignore: must_be_immutable

class RadioPlayerScreen extends StatefulWidget {
  final String? mesg;
  var radioUrl;

  RadioPlayerScreen({Key? key, this.mesg,this.radioUrl})
      : super(key: key);
  var volume = 0.8;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<RadioPlayerScreen> with WidgetsBindingObserver {
  AssetsAudioPlayer? _player = AssetsAudioPlayer.newPlayer();
  String _platformVersion = 'Unknown';
  bool a = false;
  String? radiourl;
  int? maxVol, currentVol;
  int curentindex =0;
  var logger =Logger();
  final screens = [

  ];
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _player?.dispose();
    }
  }
  @override
  void didUpdateWidget(RadioPlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
  @override
  void initState() {
    super.initState();
    //fetchDirect();
    // radiourl = widget.radioApi.allitems[0].streamUrl;
    initPlatformState();
    initAudioStreamType();
    updateVolumes();
    _init();
    new MethodChannel("flutter.temp.channel").setMethodCallHandler(platformCallHandler);
    WidgetsBinding.instance!.addObserver(this);

  }
  Future<dynamic> platformCallHandler(MethodCall call) async {
    if (call.method == "destroy"){
      logger.i("destroy");
      dispose();
    }
  }
  Future<void> initPlatformState() async {
    String? platformVersion;

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion!;
    });
  }
  int index =0;



  void _init() async {
    //print(leral.allitems[0].mesg);

    try {
      _player!.onErrorDo = (error) {
        error.player.stop();
        if (_player != null) _player!.dispose();
      };
      await _player!.open(
        Audio.liveStream(widget.radioUrl,
            metas: Metas(
                title: "Mouride24 Radio",
                artist: "Live",
                image: MetasImage.asset("assets/images/vignete.jpeg"))),
        autoStart: true,
        showNotification: true,
        notificationSettings: NotificationSettings(
            nextEnabled: false, prevEnabled: false, stopEnabled: true),
      );
    } catch (t) {
      print(t);
    }
  }
  setVol(int i) async {
    await Volume.setVol(i, showVolumeUI: ShowVolumeUI.SHOW);
  }
  Future<void> initAudioStreamType() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }
  updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    setState(() {});
  }

  @override
  void dispose() {
    _player?.dispose();
    _player = null;

    super.dispose();
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    _player?.dispose();
    _player = null;
    logger.i(widget.radioUrl);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    logger.i("message ghost ",widget.radioUrl);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    Wakelock.enable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return  Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ColorPalette.appRadioColor,
        elevation: 0,
        centerTitle: true,

        title: Text("Radio",style: GoogleFonts.roboto(fontSize: 22,fontWeight: FontWeight.bold),),
      ),

      body: Container(
        padding: const EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/radio.png",
              ),
              fit: BoxFit.cover
          ),
        ),

        child: Stack(
          children: <Widget>[
            SizedBox(height: SizeConfi.screenHeight,),

            Container(
              height: SizeConfi.screenHeight,
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  SizedBox(height: MediaQuery.of(context).size.height*0.6,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {

                        },
                        child: IconButton(
                          icon: const Icon(Icons.info,color: ColorPalette.appWhiteColor,),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                          PlayerBuilder.isBuffering(
                          player: _player!,
                          builder: (context, isBuffering) {

                            if (isBuffering) {
                              return Column(
                                children: const [
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  )
                                ],
                              );
                            } else {
                              return SizedBox(); //empty
                            }
                          },
                        ),
                            PlayerBuilder.isPlaying(
                              player: _player!,
                              builder: (context, isPlaying) {
                                return GestureDetector(
                                    onTap: () async {
                                      //if(_player !=null)_player.dispose();

                                      try {
                                        await _player!.playOrPause();

                                        //await _player.pause();
                                      } catch (t) {

                                        print(t);
                                      }
                                      //if(_player !=null)_player.isPlaying;
                                    },
                                    child: isPlaying
                                        ? const Image(
                                      image: AssetImage(
                                          "assets/images/pause.png"),

                                      height: 54,
                                      //color: Color(0xFF148BA4),
                                    )
                                        : const Image(
                                      image: AssetImage(
                                          "assets/images/player.png"),
                                      height: 54,
                                      //color: Color(0xFF148BA4),
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: (){
                            updateVolumes();

                          },
                          icon: const Icon(
                            Icons.volume_up,
                            color: Colors.white,
                          )
                      )
                    ],
                  ),
                  const SizedBox(height: 40,),
                  PlayerBuilder.isPlaying(
                      player: _player!,
                      builder: (context, isPlaying) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          //padding: EdgeInsets.only(bottom: 10.0),
                          height: isPlaying
                              ? Platform.isIOS
                              ? 130
                              : 150
                              : 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: isPlaying
                                  ? const AssetImage(
                                  "assets/images/equalizer.gif")
                                  : const AssetImage(
                                  "assets/images/equalizerOff.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),


          ],
        ),
      ),
      //bottomNavigationBar: bottomNavigationBars,
    );
  }


}
