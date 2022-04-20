import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouride_tv/utils/constants.dart';
import 'package:youtube_api/youtube_api.dart';

import 'AllPlayListScreen.dart';

class ReplayPage extends StatefulWidget {
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  ReplayPage({Key? key,this.ytApiPlaylist,required this.ytResultPlaylist,required this.ytResult,this.ytApi}) : super(key: key);

  @override
  _ReplayPageState createState() => _ReplayPageState();
}

class _ReplayPageState extends State<ReplayPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _refreshIndicatorKey,
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
        title: Text('Playlist',style: GoogleFonts.inter(color: ColorPalette.appColor,fontSize: 24,fontWeight: FontWeight.bold),),

      ),
      body: makeItemEmissions(),
    );
  }
  Widget makeItemEmissions() {
    final orientation = MediaQuery.of(context).orientation;
    return  GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {

        return GestureDetector(
          onTap: (){
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

            }
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
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
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: ColorPalette.appTextColor
                      ),maxLines: 2,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemCount: widget.ytResultPlaylist.length,
    );
  }
}
