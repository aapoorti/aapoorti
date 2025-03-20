import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class EdocsGSdata extends StatefulWidget {
  final String? item1, item2, item3;
  EdocsGSdata({this.item1, this.item2, this.item3});

  @override
  EdocsGSdataState createState() =>
      EdocsGSdataState(this.item1!, this.item2!, this.item3!);
}

class EdocsGSdataState extends State<EdocsGSdata> {
  String? item1, item2, item3;
  BuildContext? context1;
  List data = [];
  List<dynamic>? jsonResult;
  EdocsGSdataState(
    String item1,
    String item2,
    String item3,
  ) {
    this.item1 = item1;
    this.item2 = item2;
    this.item3 = item3;
  }
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchPostOrganisation();
    });
  }

  Future<void> fetchPostOrganisation() async {
    try {
      var u = AapoortiConstants.webServiceUrl + 'Docs/PublicDocs?ORGCODE=${this.item1}&ORGZONE=${this.item2}&DEPTCODE=${this.item3}';

      final response1 = await http.post(Uri.parse(u));


      setState(() {
        jsonResult = json.decode(response1.body);
        data = jsonResult!;
      });
    }
    on SocketException catch(e){
      AapoortiUtilities.showInSnackBar(context, "Please check your internet connection!!");
    }
    on Exception catch(ex){
      AapoortiUtilities.showInSnackBar(context, "Something unexpected happened, please try again.");
    }
  }

  @override
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('Public Documents',
                        style: TextStyle(color: Colors.white))),
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
            )),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 25.0,
                alignment: Alignment.center,
                child: Text(
                  "Goods and Services >> Document List",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.start,
                ),
                color: Colors.blueAccent,
              ),
              Expanded(child: jsonResult == null ? SpinKitFadingCircle(color: AapoortiConstants.primary, size: 120.0) : _myListView(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return jsonResult!.isEmpty ? Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/json/no_data.json',height: 120, width: 120),
          AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TyperAnimatedText('Data not found', speed: Duration(milliseconds: 150), textStyle: TextStyle(fontWeight: FontWeight.bold)),
              ])
        ],
      ),
    ) : ListView.builder(shrinkWrap: true, itemCount: jsonResult != null ? jsonResult!.length : 0, itemBuilder: (context, index) {return Container(
                  color: Colors.white,
                  child: Column(
                  children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          (index + 1).toString() + ". ",
                          style:
                              TextStyle(color: Colors.indigo, fontSize: 16),
                        ),
                        Container(
                          height: 30,
                          width: 100,
                          child: Text(
                            "Doc Desc",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          //height: 30,

                          child: Text(
                            jsonResult![index]['FILE_DESCRIPTION'] != null
                                ? jsonResult![index]['FILE_DESCRIPTION']
                                : "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ]),
                  Row(children: <Widget>[
                    Container(
                      height: 30,
                      width: 117,
                      child: Text(
                        "     Doc Type",
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 30,
                      child: Text(
                        jsonResult![index]['DOC_TYPE'] != null
                            ? jsonResult![index]['DOC_TYPE']
                            : "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ]),
                    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Container(
                      height: 30,
                      width: 117,
                      child: Text(
                        "     Uploaded",
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
                          jsonResult![index]['UPLOAD_TIME'] != null
                              ? (jsonResult![index]['UPLOAD_TIME'].toString())
                              : "",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ]),

                  Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Container(
                      height: 30,
                      width: 117,
                      child: Text(
                        "     File Details",
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      height: 30,
                      child: Text(
                        jsonResult![index]['FILE_SIZE'] != null
                            ? (jsonResult![index]['FILE_SIZE'].toString() +
                                "Kb/V1")
                            : "",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),

                    //),
                  ]),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Row(children: <Widget>[
                    Container(
                      height: 30,
                      width: 125,
                      child: Text(
                        "     PDF",
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if(jsonResult![index]['FILE_NAME'] != 'NA') {
                                  String url = jsonResult![index]['FILE_NAME'];
                                  url = 'https://ireps.gov.in' + url;
                                  var fileName = url.substring(url.lastIndexOf("/"));
                                  AapoortiUtilities.ackAlert(context, url, fileName);

                                } else {
                                  AapoortiUtilities.showInSnackBar(context, "No PDF attached with this Tender!!");
                                }
                              },
                              child: Container(
                                height: 30,
                                child: Image(
                                    image: AssetImage('images/pdf_home.png'),
                                    height: 30,
                                    width: 20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 0),
                            ),
                          ]),
                    ),
                  ]),
                  Container(
                    color: Colors.brown,
                    height: 1.5,
                  )
                ],
              ));
            },
          );
  }
}
