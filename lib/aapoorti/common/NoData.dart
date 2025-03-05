import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:lottie/lottie.dart';

class NoData extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(   resizeToAvoidBottomInset: false,
          appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: AapoortiConstants.primary,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                      child: Text('IREPS', style:TextStyle(
                          color: Colors.white
                      ))),
                ],
              )),

      body:Center(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
            AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText('Oops! No record found.',
                      speed: Duration(milliseconds: 150),
                      textStyle:
                      TextStyle(fontWeight: FontWeight.bold)),
                ]
            )
          ],
        ))
    )
    );
  }
}