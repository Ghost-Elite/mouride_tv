
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouride_tv/pages/ytoubeplayer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'AllPlayListScreen.dart';





class YoutubeChannelScreen extends StatefulWidget {

  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];

  YoutubeChannelScreen({Key? key,required this.ytResult,this.ytApiPlaylist,this.ytApi,required this.ytResultPlaylist}) : super(key: key);

  @override
  _YoutubeChannelScreenState createState() => _YoutubeChannelScreenState();
}

class _YoutubeChannelScreenState extends State<YoutubeChannelScreen> with AutomaticKeepAliveClientMixin<YoutubeChannelScreen>{
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState!.show());

    //print('hello');
  }
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.appBarColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: ColorPalette.appColor,),
          title: Text('Playlist',style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold),),

        ),
      body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    makeItemVideos(),
                  ],
                ),
              ),

            ],
          )
      ),
    );

  }

  Widget makeItemVideos() {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
      itemBuilder: (context, position) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => YtoubePlayerPage(
                      videoId: widget.ytResult[position].url,
                      title: widget.ytResult[position].title,

                      ytResult: widget.ytResult, videos: [],
                    )),
                    (Route<dynamic> route) => true);
          },
          child: Stack(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [

                            CachedNetworkImage(
                              height: 110,
                              width: MediaQuery.of(context).size.width,
                              imageUrl:  widget.ytResult[position].thumbnail['medium']
                              ['url'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/vignete.jpeg",
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                //color: colorPrimary,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/vignete.jpeg",
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                //color: colorPrimary,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Container(
                        child: Flexible(
                          child: Container(
                            child: Container(
                              alignment: Alignment.center,
                              //height: 70,
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                widget.ytResult[position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(color: ColorPalette.appTextColor,fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Positioned.fill(
                bottom: 60,
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/jouer.png"))),
                  ),
                ),
              )
            ],
          ),
        );
      },
      itemCount: widget.ytResult.length>8?8:widget.ytResult.length,
    );
  }



  Widget makeItemEmissions() {
    return ListView.builder(
      shrinkWrap: true,
      /* gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*/
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, position) {

        return GestureDetector(
          onTap: () {

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => AllPlayListScreen(
                    ytResult: widget.ytResultPlaylist[position],
                    //apikey:API_Key,

                  )),
                  (Route<dynamic> route) => true,);
          },
          child: Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,

              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      //alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: widget.ytResultPlaylist[position].thumbnail["medium"]["url"],
                              fit: BoxFit.cover,
                              width: 150,
                              height: 110,
                              placeholder: (context, url) =>
                                  Image.asset(
                                    "assets/images/vignete.jpeg",fit: BoxFit.cover
                                  ),
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    "assets/images/vignete.jpeg",fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                widget.ytResultPlaylist[position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.appBarColor),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
      itemCount: 5,
    );
  }



  Widget makeVideos(){
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      crossAxisSpacing: 8,
      mainAxisSpacing: 5,
      children: List.generate(widget.ytResult.length, (index) {
        return Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage('${widget.ytResult[index]
                                .thumbnail["medium"]["url"]}'),
                            fit: BoxFit.cover
                        ),

                      ),
                      /*child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "${model.allitems[index].logo}",width: 250,height: 160,),
              ),*/
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/play_button.png")
                              )
                          ),
                        ),
                      ),
                    )
                  ],
                ),


                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              YtoubePlayerPage(
                                videoId: widget.ytResult[index].url,
                                title: widget.ytResult[index].title,

                                related: "",
                                ytResult: widget.ytResult, videos: [],
                              )),
                          (Route<dynamic> route) => true);
                }
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: const EdgeInsets.fromLTRB(17, 0, 10, 0),
                child: Text("${widget.ytResult[index].title}",
                  style: const TextStyle(
                      fontSize: 13,
                      color: ColorPalette.appColor
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        );
      }),
    );
  }
  Widget makeGridView(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 95.0, 0, 0),
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2 ,
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        children: List.generate(widget.ytResultPlaylist==null?0:widget.ytResultPlaylist.length,(index){
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            AllPlayListScreen(
                              ytResult: widget.ytResultPlaylist[index],
                              //apikey:API_Key,


                            ),

                      ),
                          (Route<dynamic> route) => true);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(

                    child: CachedNetworkImage(
                      imageUrl: widget.ytResultPlaylist[index].thumbnail['high']['url'],width: 100,height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/vignete.jpeg",width: 150,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/vignete.jpeg",width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                  ),
                ),

              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text("${widget.ytResultPlaylist[index].title}",
                    style: const TextStyle(
                        fontSize: 14,
                        color: ColorPalette.appColor
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          );
        }
        ),
      )
    );
  }

}


