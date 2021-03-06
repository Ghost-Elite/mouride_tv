import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouride_tv/pages/radioPlayerScreen.dart';
import 'package:mouride_tv/pages/replayPage.dart';
import 'package:mouride_tv/pages/youtubeVideoPlaylist.dart';
import 'package:youtube_api/youtube_api.dart';

import '../configs/size_config.dart';
import '../utils/constants.dart';
import 'actualite.dart';
import 'home.dart';

class DrawerPage extends StatefulWidget {
  var dataUrl;
  var radioUrl;
  var actuUrl;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  DrawerPage({Key? key,required this.ytResult,this.ytApiPlaylist,required this.ytResultPlaylist,this.ytApi,this.dataUrl,this.radioUrl,this.actuUrl}) : super(key: key);

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: SizeConfi.screenWidth,
        height: SizeConfi.screenHeight,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/drawler.png'),
                fit: BoxFit.fill
            )
        ),
        child: ListView(
          children: [
            const DrawerHeader(child: null,
            ),
            const SizedBox(height: 50),
            ListTile(
              onTap: (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(
                    dataUrl: widget.dataUrl,
                    ytApi: widget.ytApi,
                    ytResult: widget.ytResult,
                    ytResultPlaylist: widget.ytResultPlaylist,
                  ),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.7)),
                    ]
                ),
                child: Center(
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.tv,
                      size: 20,
                      color: ColorPalette.appColor,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(
                          dataUrl: widget.dataUrl,
                          ytApi: widget.ytApi,
                          ytResult: widget.ytResult,
                          ytResultPlaylist: widget.ytResultPlaylist,
                        ),
                        ),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
              ),
              title:  Text(
                "Direct",
                style: GoogleFonts.inter(
                    color: ColorPalette.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColor
                ),
                onPressed: () {

                },
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReplayPage(
                    ytResult: widget.ytResult,
                    ytResultPlaylist: widget.ytResultPlaylist,
                    ytApiPlaylist: widget.ytApiPlaylist,
                    ytApi: widget.ytApi,
                  ),
                  ),

                );
              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.7)),
                    ]
                ),
                child: Center(
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.reply,
                      size: 20,
                      color: ColorPalette.appColor,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ),
              title:  Text(
                "Replay ",
                style: GoogleFonts.inter(
                    color: ColorPalette.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColor
                ),
                onPressed: () {

                },
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RadioPlayerScreen(
                      radioUrl: widget.radioUrl,
                  ),
                  ),

                );
              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.7)),
                    ]
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.radio,
                      color: ColorPalette.appColor,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ),
              title:  Text(
                "Radio",
                style: GoogleFonts.inter(
                    color: ColorPalette.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColor
                ),
                onPressed: () {

                },
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActualitePage(
                    actuUrl: widget.actuUrl,
                  ),
                  ),

                );
              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.7)),
                    ]
                ),
                child: Center(
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.book,
                      size: 20,
                      color: ColorPalette.appColor,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ),
              title:  Text(
                "Actualit??s",
                style: GoogleFonts.inter(
                    color: ColorPalette.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColor
                ),
                onPressed: () {

                },
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YoutubeVideoPlayList(
                    ytResult: widget.ytResult,
                    ytResultPlaylist: widget.ytResultPlaylist,
                    ytApi: widget.ytApi,
                    ytApiPlaylist: widget.ytApiPlaylist,
                  ),
                  ),

                );
              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.7)),
                    ]
                ),
                child: Center(
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.youtube,
                      size: 20,
                      color: ColorPalette.appColor,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ),
              title:  Text(
                "YouTube",
                style: GoogleFonts.inter(
                    color: ColorPalette.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColor
                ),
                onPressed: () {

                },
              ),
            ),
            ListTile(
              onTap: (){

              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.7)),
                    ]
                ),
                child: Center(
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      size: 20,
                      color: ColorPalette.appColor,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ),
              title:  Text(
                "Facebook",
                style: GoogleFonts.inter(
                    color: ColorPalette.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColor
                ),
                onPressed: () {

                },
              ),
            ),
            ListTile(
              onTap: (){

              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.7)),
                    ]
                ),
                child: Center(
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.lock,
                      size: 20,
                      color: ColorPalette.appColor,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ),
              title:  Text(
                "Politique de confidentialit??",
                style: GoogleFonts.inter(
                    color: ColorPalette.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColor
                ),
                onPressed: () {

                },
              ),
            ),
            ListTile(
              onTap: (){

              },
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                          color: Colors.grey.withOpacity(0.7)),
                    ]
                ),
                child: Center(
                  child: IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.exclamationCircle,
                      size: 20,
                      color: ColorPalette.appColor,
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ),
              title:  Text(
                "A propos",
                style: GoogleFonts.inter(
                    color: ColorPalette.appTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                ),
              ),
              trailing: IconButton(
                icon: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: 17,
                    color: ColorPalette.appColor
                ),
                onPressed: () {

                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
