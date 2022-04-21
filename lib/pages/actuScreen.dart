import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';


import '../utils/constants.dart';
class ActuScreenPage extends StatefulWidget {
  var datas,titre,img;
   ActuScreenPage({Key? key,this.datas,this.titre,this.img}) : super(key: key);

  @override
  _ActuScreenPageState createState() => _ActuScreenPageState();
}

class _ActuScreenPageState extends State<ActuScreenPage> {
  double _height = 1;
  var logger =Logger();
  @override
  Widget build(BuildContext context) {
    logger.w('message',widget.datas);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorPalette.appBarColor,
        iconTheme: IconThemeData(color: ColorPalette.appColor),
        title: Text('Actualités',style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold),),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: MediaQuery.of(context).size.height,
          //padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                height: 100,
               decoration: BoxDecoration(
                 image: DecorationImage(
                   image: NetworkImage(widget.img)
                 )
               ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Wrap(
                      children: [
                        Container(

                            child: Card(
                              child: HtmlWidget('<br>${widget.datas}</br>'),)
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),




    );
  }
}
//<br>${widget.datas}</br>
