import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

List<dynamic>? jsonResult;

class HighValueStatus extends StatefulWidget {
  final String? item1, item2, item3, item4, item5, item6, item7;
  HighValueStatus(
      {this.item1,
      this.item2,
      this.item3,
      this.item4,
      this.item5,
      this.item6,
      this.item7});

  @override
  HighValueStatusState createState() => HighValueStatusState(this.item1!,
      this.item2!, this.item3!, this.item4!, this.item5!, this.item6!, this.item7!);
}

class HighValueStatusState extends State<HighValueStatus> {
  String? item1, item2, item3, item4, item5, item6, item7;
  List? data = [];
  HighValueStatusState(String item1, String item2, String item3, String item4,
      String item5, String item6, String item7) {
    this.item1 = item1;
    this.item2 = item2;
    this.item3 = item3;
    this.item4 = item4;
    this.item5 = item5;
    this.item6 = item6;
    this.item7 = item7;
    debugPrint("item1 orgcode--- " + item1);
    debugPrint("item2 zonecode--- " + item2);
    debugPrint("item3 deptcode--- " + item3);
    debugPrint("item4 unitcode--- " + item4);
    debugPrint("item5 workarea--- " + item5);
    debugPrint("item6 datefrom--- " + item6);
    debugPrint("item7 dateto--- " + item7);
  }
  void initState() {
    super.initState();
    data = null;
    jsonResult = null;
    this.fetchPostOrganisation();
  }

  Future<void> fetchPostOrganisation() async {
    debugPrint('Fetching from service first spinner');
    var u = AapoortiConstants.webServiceUrl + 'Tender/HighValuePr?param=${this.item6},${this.item7},${this.item5},${this.item1},${this.item2},${this.item3},${this.item4}';
    debugPrint("ur1-----" + u);

    final response1 = await http.post(Uri.parse(u));
    jsonResult = json.decode(response1.body);
    debugPrint("jsonresult1===");
    debugPrint(jsonResult.toString());
    setState(() {
      data = jsonResult;
    });
  }

  var _snackKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _snackKey,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AapoortiConstants.primary,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
                },
              ),
            ],
            title: Text('High Value Tender', style: TextStyle(color: Colors.white))),
            body: Container(
             child: Column(
              children: <Widget>[
                Container(
                width: size.width,
                height: 30,
                color: Colors.cyan.shade50,
                alignment: Alignment.center,
                child: Text(
                  'High Value Tenders( Above 100 Cr.)',
                  style: TextStyle(
                      color: Colors.indigo,
                      backgroundColor: Colors.cyan.shade50,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(child: jsonResult == null ? SpinKitFadingCircle(color: AapoortiConstants.primary, size: 120.0) : jsonResult!.isEmpty ? Container(
                  height: size.height,
                  width: size.width,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          child: Lottie.asset('assets/json/no_data.json'),
                        ),
                        AnimatedTextKit(
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TyperAnimatedText("Data not found",
                                  speed: Duration(milliseconds: 150),
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ])
                      ],
                    ),
                  ),
                ) : _myListView(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {

    return ListView.separated(
            itemCount: jsonResult != null ? jsonResult!.length : 0,
            itemBuilder: (context, index) {
              return Container(
                  color: Colors.white,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text(
                      (index + 1).toString() + ".       ",
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Container(
                                height: 30,
                                width: 125,
                                child: Text(
                                  "Zone",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(child: Container(
                                child: Text((jsonResult![index]['ZONE'] != null ? jsonResult![index]['ZONE'] : "") + '/ ' + (jsonResult![index]['DEPT'] != null ? jsonResult![index]['DEPT'] : "") + '/ ' +
                                      (jsonResult![index]['DEPT_NAME'] != null
                                          ? jsonResult![index]['DEPT_NAME']
                                          : ""),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ))
                            ]),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Tender Number",
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      child: Text(
                                        jsonResult![index]['TENDER_NUMBER'] !=
                                                null
                                            ? jsonResult![index]['TENDER_NUMBER']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ]),
                            Row(children: <Widget>[
                              Container(
                                height: 30,
                                width: 125,
                                child: Text(
                                  "Closing Date",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                height: 30,
                                child: Text(
                                  jsonResult![index]['TENDER_OPENING_DATE_N'] != null ? jsonResult![index]['TENDER_OPENING_DATE_N'] : "",
                                  style: TextStyle(color: Colors.grey, fontSize: 15),
                                ),
                              )
                            ]),
                            Row(children: <Widget>[
                              Container(
                                height: 30,
                                width: 125,
                                child: Text(
                                  "Tender Desc.",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 20,
                                  child: Text(
                                    jsonResult![index]['TENDER_DESCRIPTION'] !=
                                            null
                                        ? jsonResult![index]
                                            ['TENDER_DESCRIPTION']
                                        : "---",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                ),
                              ),
                            ]),
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "EST Value",
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      child: Text(
                                        jsonResult![index]['ESTIMATED_VALUE'] !=
                                                null
                                            ? jsonResult![index]
                                                ['ESTIMATED_VALUE']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ]),
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Tender Type",
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      child: Text(
                                        jsonResult![index]['TENDER_DETAILS'] !=
                                                null
                                            ? jsonResult![index]
                                                ['TENDER_DETAILS']
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ]),
                            Row(children: <Widget>[
                              Container(
                                  height: 30,
                                  width: 125,
                                  child: Text(
                                    "Links",
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  )),
                              Expanded(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            if (jsonResult![index]['URL'] !=
                                                'NA') {
                                              var fileUrl = jsonResult![index]
                                                      ['URL']
                                                  .toString();
                                              var fileName = fileUrl.substring(
                                                  fileUrl.lastIndexOf("/"));
                                              AapoortiUtilities.ackAlert(
                                                  context, fileUrl, fileName);

                                            } else {
                                              AapoortiUtilities.showInSnackBar(
                                                  context,
                                                  "No PDF attached with this Tender!!");
                                            }
                                          },
                                          child: Column(children: <Widget>[
                                            Container(
                                              child: Image(
                                                  image: AssetImage(
                                                      'images/pdf_home.png'),
                                                  height: 30,
                                                  width: 20),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(0.0)),
                                            Container(
                                              child: Text('  NIT',
                                                  style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 9),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ])),
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
                                                                      top: 55),
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
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            Navigator.of(context, rootNavigator: true).pop('dialog');
                                                                          },
                                                                          child: Image(
                                                                            image:
                                                                                AssetImage('images/close_overlay.png'),
                                                                            height:
                                                                                50,
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
                                                  color: jsonResult![index]
                                                              ['ATTACH_DOCS'] !=
                                                          'NA'
                                                      ? Colors.green
                                                      : Colors.brown,
                                                  height: 30,
                                                  width: 20),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(0.0)),
                                            Container(
                                              child: Text('  DOCS',
                                                  style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 9),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ])),
                                      GestureDetector(
                                          onTap: () {
                                            if (jsonResult![index]['CORRI_DETAILS'] != 'NA') {
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
                                                                          child: AapoortiUtilities.corrigendumListView(
                                                                              context,
                                                                              jsonResult![index]['CORRI_DETAILS'].toString()),
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
                                                                              image: AssetImage('images/close_overlay.png'),
                                                                              height: 50,
                                                                            )),
                                                                      )
                                                                    ]))),
                                                      ));
                                            } else {
                                              AapoortiUtilities.showInSnackBar(context, "No corrigendum issued with this Tender!!");
                                            }
                                          },
                                          child: Column(children: <Widget>[
                                            Container(
                                              height: 30,
                                              child: Text(
                                                "C",
                                                style: TextStyle(
                                                    color: jsonResult![index]['CORRI_DETAILS'] != 'NA'
                                                        ? Colors.green
                                                        : Colors.brown,
                                                    fontSize: 23,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.all(0.0)),
                                            Container(
                                              child: Text('  CORRIGENDA',
                                                  style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontSize: 9),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ])),
                                      Padding(
                                        padding: EdgeInsets.only(right: 0),
                                      ),
                                    ]),
                              ),
                            ]),
                          ]),
                    ),
                  ]));
            },
            separatorBuilder: (context, index) {
              return Divider(color: Colors.blue, height: 20);
            },
          );
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text('No letter attached with this Firm!!', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white)),
    ),
  );
}
