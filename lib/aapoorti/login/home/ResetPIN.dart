import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'package:flutter_app/main.dart';

class ResetPIN extends StatelessWidget
{
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Reset PIN"),backgroundColor: AapoortiConstants.primary,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: () {
              // Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen(scaffoldKey)));
             
              Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
            },),
          ],),

        body: Material(
            color: Colors.cyan[50],
            child:
            ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(35.0, 15.0, 30.0, 20.0)),
                Card(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(8.0)),
                      Row(
                        children: <Widget>[
                          Text("   To reset PIN for AAPOORTI: ",style: TextStyle(fontSize:15.0,fontWeight: FontWeight.normal),)
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      //new Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left:32.0)),
                          Text("1. Login to www.ireps.gov.in",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),
                          Padding(padding: EdgeInsets.only(left:35.0)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left:32.0)),
                          Text("2. Go to link on the right navigation (Enable\n    MobileApp Access for आपूर्ति)",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),
                          //Padding(padding: new EdgeInsets.only(bottom: 35.0)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left:32.0)),
                          Text("3. Select RESET PIN and complete the process.",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                    ],
                  ),
                ),

              ],
            )
        ),

      ),

    );


  }



}