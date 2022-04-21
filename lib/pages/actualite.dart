import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mouride_tv/utils/constants.dart';
import 'package:wakelock/wakelock.dart';
import 'package:xml2json/xml2json.dart';
import '../configs/size_config.dart';
import '../network/news.dart';
import 'actuScreen.dart';

class ActualitePage extends StatefulWidget {
  var actuUrl;
  ActualitePage({Key? key,this.actuUrl}) : super(key: key);

  @override
  _ActualitePageState createState() => _ActualitePageState();
}

class _ActualitePageState extends State<ActualitePage> with SingleTickerProviderStateMixin{
  APIItems? apiItems;
  var logger = Logger();
  var data;
  var actuUrl;
  var indexs =0;
  var test = 0;
  int curentindex =0;
  final screens = [

  ];

  Future<void> getall() async {
    bool loadRemoteDatatSucceed = false;
    try {
      var response = await http
          .get(Uri.parse(widget.actuUrl.allitems![2].feedUrl))
          .timeout(const Duration(seconds: 10), onTimeout: () {

        throw TimeoutException("connection time out try agian");
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //logger.w(listChannelsbygroup);

        setState(() {
          actuUrl = jsonDecode(response.body);
        });

        loadRemoteDatatSucceed = true;
        /*logger.i('message',actuUrl);*/
        getJsonFromXMLUrl(actuUrl['newsrss'][0]['feed_url']);
      } else {

        return null;
      }

    } on TimeoutException catch (_) {
    }

  }
  Future<void> fetchActualite() async {
    var postListUrl =
    Uri.parse(widget.actuUrl.allitems![2].feedUrl);
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //logger.w(listChannelsbygroup);
      apiItems = APIItems.fromJson(data);

      logger.i("actu url",apiItems?.newsrss![0].title);
      setState(() {
        actuUrl =apiItems?.newsrss![0].feedUrl;
      });
      getJsonFromXMLUrl(actuUrl);
      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  final myTransformer = Xml2Json();
  Future<void> getJsonFromXMLUrl(String url) async {
    final Xml2Json xml2Json = Xml2Json();
     //url = "${widget.apiItems.actu[1].feedUrl}";
    try {
      var response = await http.get(Uri.parse(url));
      xml2Json.parse(response.body);

      var jsonString = xml2Json.toParker();

      data = jsonDecode(jsonString)['rss']/*['channel']['item']*/;
      logger.i(data,'tgghjklm');
      setState(() {
        data;
      });
      logger.i(data,'gfhgjhkjl');
     // logger.d(data['channel']['title'],"nnnnnnnnn");
      //logger.d(data['channel']['image']['url'],"nnnnnnnnn");
      return jsonDecode(jsonString);
    } catch (e) {
      print(e);
    }
    ///logger.i('ytyuiuioù',url);
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchActualite();
      //getUrl();
    /*if (apiItems !=null && apiItems.actu.length !=0) {

    }else{
      logger.i("message1234",actuUrl);
    }*/


    //logger.i(data['channel'],'sdggfghh');   //converter.parse(getUrl());
    //run();
    //logger.i("xml ",getUrl());
    //getJsonFromXMLUrl("https://actunet.net/feed/");
    logger.d(data,"nnnnnnnnn",actuUrl);


  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //logger.i(data['channel']['image']['url'],'build');
    Wakelock.enable();
    return data !=null?Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorPalette.appBarColor,
        iconTheme: IconThemeData(color: ColorPalette.appColor),
        title: Text('Actualités',style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        //padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            cardActu(),
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Wrap(
                    children: [
                      carousel(),
                      dernierVideo(),
                      SizedBox(height: 5,),
                      makeItemEpecial(),

                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    ):Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorPalette.appBarColor,
        iconTheme: IconThemeData(color: ColorPalette.appColor),
        title: Text('Actualités',style: GoogleFonts.inter(color: ColorPalette.appColor,fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: CircularProgressIndicator(color: ColorPalette.appColor,),
      ),
    );
  }
  Widget cardActu(){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      height: 40,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: apiItems!.newsrss!.length,
          itemBuilder: (context,index){
            return Container(
              alignment: Alignment.center,
              width: SizeConfi.screenWidth! /4,

              child: GestureDetector(
                onTap: (){
                  setState(() {
                    apiItems!.newsrss![index].feedUrl;
                    test =index;
                  });
                  getJsonFromXMLUrl(apiItems!.newsrss![index].feedUrl.toString());
                  logger.i(' Ghost-Elite ',apiItems!.newsrss![index].feedUrl.toString());
                },
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  strutStyle: StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                    //style: GoogleFonts.roboto(color: indexs==0 ?Palette.color4:Palette.colorBlack),
                    style: GoogleFonts.roboto(
                        color: test==index ? ColorPalette.appActuColor: ColorPalette.appTextColor
                    ),
                    text:
                    "${apiItems!.newsrss![index].title}",),
                ),
              ),
            );
          }),
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

      items: [1,2,3,4,5].map((i) {
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
                              image: NetworkImage("${data['channel']['image']['url']}"),
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
                                  "${data['channel']['item'][i]['title']}",
                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                  maxLines: 3,
                                ),
                              ),
                              onTap: () {


                              }
                          ),

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
  Widget makeItemEpecial() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return GestureDetector(
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => ActuScreenPage(
                    datas: data['channel']['item'][position],
                    img: data['channel']['image']['url'],
                    titre: data['channel']['item'][position]['title'],
                  )
              ),
            );

            var  logger = Logger();
            logger.i("Ghost-Elite : ",data['channel']['item'][position]['description']);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(

                  width: MediaQuery.of(context).size.width,

                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 4.0,
                    shadowColor: Colors.grey,
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${/*data['channel'] >0?*/ data['channel']['item'][position]['title']}',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: ColorPalette.appTextColor),maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            /*GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: 140,
                                height: 80,
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: *//*data['channel'] >0?*//*data['channel']['image']['url'],
                                    fit: BoxFit.fitWidth,
                                    width: 140,
                                    height: 80,
                                    placeholder: (context, url) =>
                                        Image.asset(
                                          "assets/images/vignete.jpeg",fit: BoxFit.cover
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          "assets/images/vignete.jpeg",fit: BoxFit.cover
                                        ),
                                  ),
                                ),
                              ),
                            ),*/
                            Container(
                              width: 100,
                              height: 70,
                              child: ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  width: 100,
                                  height: 70,
                                  imageUrl: data['channel']['image']['url'],
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: data['channel'].length>8?8:data['channel'].length>0?data['channel'].length:0,
    );
  }
  Widget dernierVideo() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            "Dernières infos",
            style: GoogleFonts.inter(
              color: ColorPalette.appTextColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          child: IconButton(
            icon: Icon(
                Icons.arrow_forward_ios,
              size: 15,
              color: ColorPalette.appIconPlayColor,
            ),
            onPressed: (){

            },
          ),
        )
      ],

    );
  }
}



//data['channel']['image']['url'] data['channel']['item'][i]['title']
