import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'AllPlayListScreen.dart';
class PlaylistYoutube extends StatefulWidget {
  List<YT_APIPlaylist> ytResultPlaylist = [];

  PlaylistYoutube({Key? key,required this.ytResultPlaylist}) : super(key: key);

  @override
  _PlaylistYoutubeState createState() => _PlaylistYoutubeState();
}

class _PlaylistYoutubeState extends State<PlaylistYoutube> {
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  var logger =Logger();
  var dataVOD;
  Future<void> getVODPrograms(String url) async {
    final response = await http.get(Uri.parse(url));
    setState(() {
      dataVOD = json.decode(response.body);
    });
    //getDirect(dataVOD['allitems'][0]['feed_url']);

    //logger.i(' Ghost-Elite 2022 ',dataVOD['allitems']);
    return dataVOD;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _refreshIndicatorKey,
      appBar: AppBar(
        backgroundColor: ColorPalette.appBarColor,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: ColorPalette.appColor),
            onPressed: () {
              //PlayerInit(widget.dataUrls);
              //PlayerInit();
              Navigator.of(context).pop();
            }
        ),
        title: Text('Playlist',style: GoogleFonts.inter(color: ColorPalette.appColor,fontSize: 24,fontWeight: FontWeight.bold),),
      ),
      body: makeItemEmissions(),
    );
  }
  Widget makeItemEmissions() {
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      padding: EdgeInsets.only(top: 5),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        logger.i('ghost',widget.ytResultPlaylist[position].thumbnail['high']['url']);
        return GestureDetector(
          onTap: (){
            logger.i('message',widget.ytResultPlaylist[1].thumbnail);
            if(widget.ytResultPlaylist !=null || widget.ytResultPlaylist==0){
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AllPlayListScreen(
                      ytResult:widget.ytResultPlaylist[position],
                      //apikey: API_Key,
                    ),
                  ),
                      (Route<dynamic> route) => true);
            }else{
              logger.i('test video');
            }
          },
          child: SizedBox(
            height: 140,
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
                        height: 140,
                        width: MediaQuery.of(context).size.width,
                        child: GestureDetector(
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: widget.ytResultPlaylist[position].thumbnail['medium']['url'],
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
                    '${widget.ytResultPlaylist[position].title}',textAlign: TextAlign.center,
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
      },
      itemCount: widget.ytResultPlaylist.length,
    );
  }
}

/*


*/