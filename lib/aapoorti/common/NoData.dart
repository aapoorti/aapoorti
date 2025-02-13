import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';

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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(image:AssetImage("assets/nodatafound.png"),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,),
              ),
              Text('Oops! No record found.',textAlign: TextAlign.center,style: TextStyle(fontSize: 16),)
            ],
          ))
    )
    );
  }
}