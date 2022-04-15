import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouride_tv/pages/splash.dart';

import 'configs/size_config.dart';

Future main() async {


  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(

      LayoutBuilder(   // Add LayoutBuilder
          builder: (context, constraints,) {
            return OrientationBuilder(   // Add OrientationBuilder
                builder: (context, orientation) {
                  SizeConfi().init(constraints, orientation); // SizeConfig initialization

                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: '',
                      theme: ThemeData(
                        primaryColor: Colors.blue[800],
                        accentColor: Colors.blue,
                        fontFamily: 'Poppins Light',
                        pageTransitionsTheme: const PageTransitionsTheme(builders: {
                          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                        }),
                      ),
                      home: const ProviderScope(child: SplashScreen(),)
                  );
                }
            );
          }
      )

  );
}


