import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

List<dynamic>? jsonResult;

class Status extends StatefulWidget {
  final String? content, id, Date;
  Status({
    this.Date,
    this.content,
    this.id,
  });

  @override
  StatusState createState() => StatusState(this.Date!, this.content!, this.id!);
}

class StatusState extends State<Status> {
  String? date1;
  var u, z;
  String? datedate;
  List<dynamic>? jsonResult;
  String? date, tendno, railid;
  String? yyyy, mm, dd;
  StatusState(String date, String content, String railid) {
    this.date = date;
    debugPrint("====" + date);
    tendno = content;
    this.railid = railid;
    if(date == "-1") {
      date1 = "-1";
      u = 'https://ireps.gov.in/Aapoorti/ServiceCallTender/TenderSearch?param=${this.date1},${this.tendno},${this.railid}';
    } else {
      date1 = (this.date)!.replaceRange(11, 23, " ").trimRight().replaceAll("-", "/");
      debugPrint(date1);
      yyyy = date1!.substring(0, 4);
      mm = date1!.substring(5, 7);
      dd = date1!.substring(8, 10);
      debugPrint("act");
      debugPrint(dd! + "/" + mm! + "/" + yyyy!);
      datedate = dd! + "/" + mm! + "/" + yyyy!;
      debugPrint("act");
      debugPrint(datedate);
      u = 'https://ireps.gov.in/Aapoorti/ServiceCallTender/TenderSearch?param=${this.datedate},${this.tendno},${this.railid}';
    }
  }
  String? a;
  void initState() {
    super.initState();
    this.fetchPost(u);
  }

  List data = [];
  Future<void> fetchPost(String url) async {
    var v = url;
    // var v = 'https://ireps.gov.in/Aapoorti/ServiceCallTender/TenderSearch?param=${dd+"/"+mm+"/"+yyyy},${this.tendno},${this.railid}';
    debugPrint("URL==>" + v);
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    debugPrint("response ${jsonResult}");
    if(jsonResult!.length >= 1){
      debugPrint(jsonResult.toString());
      setState(() {
        data = jsonResult!;
      });
    }
    else{
      setState(() {
        data = [];
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: AapoortiConstants.primary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Tender Status Search',
                  style: TextStyle(color: Colors.white)),
              IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/common_screen", (route) => false);
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.cyan.shade50,
        body: Container(child: jsonResult == null ? SpinKitFadingCircle(color: AapoortiConstants.primary, size: 130.0) : jsonResult!.isEmpty ? Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
            AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText("Data not found",
                      speed: Duration(milliseconds: 150),
                      textStyle:
                      TextStyle(fontWeight: FontWeight.bold)),
                ]
            )
          ],
        )) : _myListView(context), color: Colors.cyan[50]),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return jsonResult!.isEmpty ? Container(height: 40.0, width: 500,
            child: Card(
              margin: EdgeInsets.only(top: 20.0, left: 15, right: 15),
              child: Text(
                "Tender Details not found! ",
                style: TextStyle(fontSize: 17, color: Colors.indigo),
                textAlign: TextAlign.center,
              ),
            )) : ListView.builder(
            itemCount: jsonResult != null ? jsonResult!.length : 0,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    "Details of e-Tender",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ))
                                ]),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Container(
                                  height: 65.0,
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          "\n Account",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      ]),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(child: Text(
                                          jsonResult![index]['DEPTNM'] != null ? " " + jsonResult![index]['DEPTNM'] : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      ]),
                                    ],
                                  ),
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Container(
                                  //height: 65.0,
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        /*Expanded(
                                          child:*/
                                        Text(
                                          "\n Tender Number",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3)),
                                        GestureDetector(
                                            onTap: () {
                                              if(jsonResult![index]['PDFPATH'] != 'NA') {
                                                var fileUrl = jsonResult![index]['PDFPATH'].toString();
                                                var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                                AapoortiUtilities.ackAlert(context, fileUrl, fileName);
                                              } else {
                                                AapoortiUtilities.showInSnackBar(
                                                    context,
                                                    "No PDF attached with this Tender!");
                                              }
                                            },
                                            child: Column(children: <Widget>[
                                              Container(
                                                child: Image(
                                                    image: AssetImage(
                                                        'images/pdf_home.png'),
                                                    height: 30,
                                                    width: 25),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(0.0)),
                                              Container(
                                                child: Text('  NIT',
                                                    style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 9),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ])),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    10)),
                                        GestureDetector(
                                            onTap: () {
                                              if (jsonResult![index]
                                                      ['ATTACH_DOCS'] !=
                                                  'NA') {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Center(
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            55),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            50),
                                                                color: Color(
                                                                    0xAB000000),

                                                                child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.only(bottom: 20),
                                                                          child: AapoortiUtilities.attachDocsListView(
                                                                              context,
                                                                              jsonResult![index]['ATTACH_DOCS'].toString()),
                                                                        ),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.bottomCenter,
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                            },
                                                                            child: Image(
                                                                              image: AssetImage('assets/close_overlay.png'),
                                                                              height: 50,
                                                                              width: 50.0,
                                                                            )),
                                                                      )
                                                                    ])))));
                                              } else {
                                                AapoortiUtilities.showInSnackBar(
                                                    context,
                                                    "No Documents attached with this Tender!!");
                                              }
                                            },
                                            child: Column(children: <Widget>[
                                              Container(
                                                height: 30,
                                                child: Image(
                                                    image: AssetImage(
                                                        'images/attach_icon.png'),
                                                    color: jsonResult![index][
                                                                'ATTACH_DOCS'] !=
                                                            'NA'
                                                        ? Colors.green
                                                        : Colors.brown,
                                                    height: 30,
                                                    width: 25),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(0.0)), Container(
                                                child: Text(' DOCS',
                                                    style: TextStyle(
                                                        color: Colors.blueGrey,
                                                        fontSize: 9),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ])),
                                      ]),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                                child: Text(
                                              jsonResult![index]['TENDNUM'] !=
                                                      null
                                                  ? " " +
                                                      jsonResult![index]
                                                          ['TENDNUM']
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ))
                                          ]),
                                    ],
                                  ),
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Container(
                                  //height: 65.0,
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          "\n Tender Title",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        )),
                                      ]),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          jsonResult![index]['DESC1'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        )
                                            ),
                                      ]),
                                    ],
                                  ),
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Container(
                                  height: 65.0,
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          "\n Work Area",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      ]),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          jsonResult![index]['WRKAREA'] != null
                                              ? " " +
                                                  jsonResult![index]['WRKAREA']
                                              : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      ]),
                                    ],
                                  ),
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Container(
                                  height: 65.0,
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          "\n Opening Date",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      ]),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          jsonResult![index]['OPNDATE'] != null
                                              ? " " +
                                                  jsonResult![index]['OPNDATE']
                                              : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      ]),
                                    ],
                                  ),
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Container(
                                  height: 65.0,
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          "\n Tender Status",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      ]),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Text(
                                          jsonResult![index]['STATUS'] != null
                                              ? " " +
                                                  jsonResult![index]['STATUS']
                                              : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      ]),
                                    ],
                                  ),
                                  color: Colors.white,
                                ),
                              ]),
                        ),
                      ]),
                ),
              );
            },
          );
  }
}
