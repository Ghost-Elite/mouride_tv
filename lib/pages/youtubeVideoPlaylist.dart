import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:mouride_tv/pages/youtubeEmisions.dart';
import 'package:mouride_tv/pages/ytoubeplayer.dart';
import 'package:youtube_api/youtube_api.dart';


import '../utils/constants.dart';
import 'AllPlayListScreen.dart';
import 'YoutubeChannelScreen.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class YoutubeVideoPlayList extends StatefulWidget {
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  YoutubeVideoPlayList({Key? key,this.ytApi,this.ytApiPlaylist,required this.ytResultPlaylist,required this.ytResult })
      : super(key: key);

  @override
  _YoutubeVideoPlayListState createState() => new _YoutubeVideoPlayListState();
}

class _YoutubeVideoPlayListState extends State<YoutubeVideoPlayList>
    with AutomaticKeepAliveClientMixin<YoutubeVideoPlayList> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();




  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());

    //print('hello');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      primary: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorPalette.appBarColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorPalette.appColor,),
        title: Text('YouTube',style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold)),

      ),
      body: Container(
          child: Stack(
            children: [
              /*traitWidget(),*/

              ConstrainedBox(
                constraints: BoxConstraints(),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Nouveautés",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold),
                            ),
                          ),
                          //(height: 20,),
                          Container(child: makeItemVideos()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(right: 10),
                                    child:  Text(
                                      "Voir Plus...",
                                      style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold),
                                    )),
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            YoutubeChannelScreen(
                                             ytResultPlaylist: widget.ytResultPlaylist,
                                              ytResult: widget.ytResult,

                                            ),
                                      ));

                                },
                              )
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child:  Text(
                              "Nos Playlists",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold),
                            ),
                          ),
                          /*traitWidget(),*/
                          makeItemEmissions(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "Voir Plus...",
                                      style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold),
                                    )),
                                onTap: () {
                                  Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => YoutubeEmisionPage(
                                              ytResultPlaylist: widget.ytResultPlaylist,
                                            )
                                        ),
                                      );
                                  var  logger = Logger();
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget makeGridView() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 95.0, 0, 0),
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          crossAxisSpacing: 8,
          mainAxisSpacing: 4,
          children: List.generate(
              widget.ytResultPlaylist == null ? 0 :  widget.ytResultPlaylist.length, (index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => AllPlayListScreen(
                            ytResult:  widget.ytResultPlaylist[index],
                            //apikey: API_Key,
                          ),
                        ),
                        (Route<dynamic> route) => true);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      child: CachedNetworkImage(
                        imageUrl:  widget.ytResultPlaylist[index].thumbnail['high']
                            ['url'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          "assets/images/vignete.jpeg",
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/vignete.jpeg",
                          width: 150,
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
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "${ widget.ytResultPlaylist[index].title}",
                      style: GoogleFonts.inter(color: ColorPalette.appTextColor,fontWeight: FontWeight.bold,fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            );
          }),
        ));
  }

  Widget makeItemVideos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 210,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
      itemBuilder: (context, position) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => YtoubePlayerPage(
                          videoId:  widget.ytResult[position].url,
                          title:  widget.ytResult[position].title,
                          ytResult:  widget.ytResult, videos: [],
                        )),
                        (Route<dynamic> route) => true);
              },
              child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              height: 120,
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
                              errorWidget: (context, url, error) =>
                                  Image.asset(
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
                              padding: EdgeInsets.all(5),
                              child: Text(
                                widget.ytResult[position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(color: ColorPalette.appTextColor,fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Positioned(
              top: 40,
              left: 70,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => YtoubePlayerPage(
                              videoId:  widget.ytResult[position].url,
                              title:  widget.ytResult[position].title,
                              ytResult:  widget.ytResult, videos: [],
                            )),
                            (Route<dynamic> route) => true);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/jouer.png")
                        )
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
      itemCount:  widget.ytResult.length > 8 ? 8 :  widget.ytResult.length,
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
                    ytResult:  widget.ytResultPlaylist[position],
                    //apikey: API_Key,
                  ),
                ),
                (Route<dynamic> route) => true);
          },
          child: Container(
              margin: EdgeInsets.all(10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl:  widget.ytResultPlaylist[position]
                                  .thumbnail["medium"]["url"],
                              fit: BoxFit.cover,
                              width: 150,
                              height: 110,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/vignete.jpeg",fit: BoxFit.cover
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/vignete.jpeg",fit: BoxFit.cover
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
                                style: GoogleFonts.inter(color: ColorPalette.appTextColor,fontWeight: FontWeight.bold,fontSize: 13),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.playlist_play,
                                  size: 25,
                                  color: ColorPalette.appColor,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
      itemCount:  widget.ytResultPlaylist == null ? 0 :  widget.ytResultPlaylist.length,
    );
  }

}
