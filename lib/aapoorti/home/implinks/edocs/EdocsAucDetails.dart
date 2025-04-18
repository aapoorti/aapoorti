import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class EdocAucDetails extends StatefulWidget {
  final String? id;
  EdocAucDetails({this.id});

  @override
  EdocAucDetailsState createState() => EdocAucDetailsState(this.id!);
}

class EdocAucDetailsState extends State<EdocAucDetails> {
  @override
  String? ID;
  List<dynamic>? jsonResult;

  EdocAucDetailsState(String id) {
    this.ID = id;
  }

  void initState() {
    super.initState();
    this.fetchPost();
  }

  List data = [];

  Future<void> fetchPost() async {
    var v = AapoortiConstants.webServiceUrl +
        'Docs/PublicDocsAuction?ACCOUNTID=${this.ID}';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);

    setState(() {
      data = jsonResult!;
    });
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AapoortiConstants.primary,
            // actions: [
            //   IconButton(
            //     icon: new Icon(
            //       Icons.home,
            //       color: Colors.white,
            //     ),
            //     onPressed: () {
            //       Navigator.pushNamedAndRemoveUntil(
            //           context, "/common_screen", (route) => false);
            //     },
            //   ),
            // ],
            title: Text('Public Documents',
                style: TextStyle(color: Colors.white))),
        body: Center(
            child: jsonResult == null
                ? SpinKitFadingCircle(
                    color: AapoortiConstants.primary,
                    size: 120.0,
                  )
                : _myListView(context)),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    return jsonResult!.isEmpty
        ? Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
          AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TyperAnimatedText('Data not found',
                    speed: Duration(milliseconds: 150),
                    textStyle:
                    TextStyle(fontWeight: FontWeight.bold)),
              ]
          )
        ],
      ),
    )
        : ListView.separated(
            itemCount: jsonResult != null ? jsonResult!.length : 0,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          (index + 1).toString() + ". ",
                          style: TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Row(children: <Widget>[
                                Container(
                                  child: Text(
                                    "Dept Name   ",
                                    style: TextStyle(
                                        color: Colors.indigo, fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    jsonResult![index]['DEPOT_NAME'] != null
                                        ? jsonResult![index]['DEPOT_NAME']
                                        : "",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ]),
                              SizedBox(height: 5),
//

                              Row(children: <Widget>[
                                Container(
                                  // height: 30,

                                  child: Text(
                                    "Doc Desc.     ",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  // height: 40,
                                  child: Text(
                                    jsonResult![index]['FILE_DESCRIPTION'] !=
                                            null
                                        ? (jsonResult![index]
                                            ['FILE_DESCRIPTION'])
                                        : "",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ))
                              ]),

                              // Padding(padding: EdgeInsets.only(top: 10.0)),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
//
                                  Container(
                                    // height: 30,
                                    child: Text(
                                      "Uploaded     ",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),

                                  Container(
                                    // height: 30,
                                    child: Text(
                                      jsonResult![index]['CREATION_TIME'] != null
                                          ? jsonResult![index]['CREATION_TIME']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Container(
                                    // height: 30,
                                    child: Text(
                                      "File Size        ",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              // height: 30,
                                              child: Text(
                                                jsonResult![index]
                                                            ['FILE_SIZE'] !=
                                                        null
                                                    ? (jsonResult![index]
                                                            ['FILE_SIZE'])
                                                        .toString()
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                var fileurl = AapoortiConstants
                                                        .contextPath +
                                                    jsonResult![index]
                                                        ['FILE_NAME'];
                                                print(fileurl);
                                                var fileName =
                                                    fileurl.substring(fileurl
                                                        .lastIndexOf("/"));
                                                AapoortiUtilities.ackAlert(
                                                    context, fileurl, fileName);
                                              },
                                              child: Container(
                                                  child: Image.asset(
                                                'assets/pdf_home.png',
                                                width: 25,
                                                height: 25,
                                              )),
                                            )
                                          ]),
                                    ),
                                  ),

                                  // new Padding(padding: EdgeInsets.only(left: 150)),
                                ],
                              )
                            ]))
                      ]));

/*
            onTap: () {
              var fileurl=AapoortiConstants.contextPath+jsonResult[index]['FILE_NAME'];
 print(fileurl);
              var fileName = fileurl.substring(fileurl.lastIndexOf("/"));
              AapoortiUtilities.openPdf(context, fileurl, fileName);

            }*/
              //);
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 2.0,
                color: Colors.cyan,
              );
            },
          );
  }
}
