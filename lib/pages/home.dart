import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  int _angle = 90;
  bool _isRotated = true;
  AnimationController? _controller;
  Animation<double>? _animation;
  Animation<double>? _animation2;
  Animation<double>? _animation3;
  var scaffold = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _animation =  CurvedAnimation(
      parent: _controller!,
      curve:  const Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = CurvedAnimation(
      parent: _controller!,
      curve: Interval(0.5, 1.0, curve: Curves.linear),
    );

    _animation3 = CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.8, 1.0, curve: Curves.linear),
    );


    _controller!.reverse();
  }
  void _rotate(){
    setState((){
      if(_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller!.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller!.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        backgroundColor: ColorPalette.appBarColor,
        centerTitle: true,
        title: Text('Accueil',
          style: GoogleFonts.inter(
              color: ColorPalette.appColor,
              fontWeight: FontWeight.bold),
        ),
          leading: GestureDetector(
            onTap: (){
              scaffold.currentState?.openDrawer();
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/menu.png')
                  )
              ),
            ),
          )
      ),
      drawer: Drawer(),
      body: Stack(
        children: [
           Positioned(
              bottom: 200.0,
              right: 24.0,
              child:  Container(
                child:  Row(
                  children: <Widget>[
                     ScaleTransition(
                      scale: _animation3!,
                      alignment: FractionalOffset.center,
                      child:  Container(
                        margin:  EdgeInsets.only(right: 16.0),
                        child:  Text(
                          'foo1',
                          style:  TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color:  Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                     ScaleTransition(
                      scale: _animation3!,
                      alignment: FractionalOffset.center,
                      child:  Material(
                          color:  Color(0xFF9E9E9E),
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child:  GestureDetector(
                            child:  Container(
                                width: 40.0,
                                height: 40.0,
                                child:  InkWell(
                                  onTap: (){
                                    if(_angle == 45.0){
                                      print("foo1");
                                    }
                                  },
                                  child:  const Center(
                                    child:  Icon(
                                      Icons.add,
                                      color:  Color(0xFFFFFFFF),
                                    ),
                                  ),
                                )
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),

           Positioned(
              bottom: 144.0,
              right: 24.0,
              child:  Container(
                child:  Row(
                  children: <Widget>[
                     ScaleTransition(
                      scale: _animation2!,
                      alignment: FractionalOffset.center,
                      child:  Container(
                        margin:  EdgeInsets.only(right: 16.0),
                        child:  Text(
                          'foo2',
                          style:  TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color:  Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                     ScaleTransition(
                      scale: _animation2!,
                      alignment: FractionalOffset.center,
                      child:  Material(
                          color:  Color(0xFF00BFA5),
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child:  GestureDetector(
                            child:  Container(
                                width: 40.0,
                                height: 40.0,
                                child:  InkWell(
                                  onTap: (){
                                    if(_angle == 45.0){
                                      print("foo2");
                                    }
                                  },
                                  child:  const Center(
                                    child:  Icon(
                                      Icons.add,
                                      color:  Color(0xFFFFFFFF),
                                    ),
                                  ),
                                )
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
           Positioned(
              bottom: 88.0,
              right: 24.0,
              child:  Container(
                child:  Row(
                  children: <Widget>[
                     ScaleTransition(
                      scale: _animation!,
                      alignment: FractionalOffset.center,
                      child:  Container(
                        margin:  const EdgeInsets.only(right: 16.0),
                        child:  const Text(
                          'foo3',
                          style:  TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color:  Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                     ScaleTransition(
                      scale: _animation!,
                      alignment: FractionalOffset.center,
                      child:  Material(
                          color:  const Color(0xFFE57373),
                          type: MaterialType.circle,
                          elevation: 6.0,
                          child:  GestureDetector(
                            child:  Container(
                                width: 40.0,
                                height: 40.0,
                                child:  InkWell(
                                  onTap: (){
                                    if(_angle == 45.0){
                                      print("foo3");
                                    }
                                  },
                                  child:  const Center(
                                    child:  Icon(
                                      Icons.add,
                                      color:  Color(0xFFFFFFFF),
                                    ),
                                  ),
                                )
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
           Positioned(
            bottom: 16.0,
            right: 16.0,
            child:  Material(
                color:  Color(0xFFE57373),
                type: MaterialType.circle,
                elevation: 6.0,
                child:  GestureDetector(
                  child:  Container(
                      width: 56.0,
                      height: 56.00,
                      child:  InkWell(
                        onTap: _rotate,
                        child:  Center(
                            child:  RotationTransition(
                              turns:  AlwaysStoppedAnimation(_angle / 360),
                              child:  const Icon(
                                Icons.add,
                                color:  Color(0xFFFFFFFF),
                              ),
                            )
                        ),
                      )
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}
