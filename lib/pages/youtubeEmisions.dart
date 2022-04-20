import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import 'AllPlayListScreen.dart';

class YoutubeEmisionPage extends StatefulWidget {
  List<YT_APIPlaylist> ytResultPlaylist;
  YoutubeEmisionPage({Key? key,required this.ytResultPlaylist}) : super(key: key);

  @override
  _YoutubeEmisionPageState createState() => _YoutubeEmisionPageState();
}

class _YoutubeEmisionPageState extends State<YoutubeEmisionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.appBarColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorPalette.appColor),
        title: Text('Playlist',style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: makeItemEmissions(),
      ),
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
                              imageUrl: widget.ytResultPlaylist[position]
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
                                style: GoogleFonts.inter(fontSize: 13,
                                    color: ColorPalette.appTextColor),
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
      itemCount: widget.ytResultPlaylist == null ? 0 : widget.ytResultPlaylist.length,
    );
  }
}
