import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class LivUpcomRA extends StatefulWidget {
  @override
  _LivUpcomRAState createState() => _LivUpcomRAState();
}

class _LivUpcomRAState extends State<LivUpcomRA> {
  List<dynamic> jsonResult = [], _duplicateJsonResult = [];
  List<dynamic>? jsonResultUp;
  List<dynamic>? jsonResultLiv;
  int? resultCount;

  bool searchAction = false;

  final _textsearchController = TextEditingController();

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getliveUpcomingRA();
    });
  }

  @override
  void dispose() {
    jsonResult.clear();
    _duplicateJsonResult.clear();
    super.dispose();
  }

  void getliveUpcomingRA() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if(providedTime.isBefore(DateTime.now())){
      await fetchToken(context);
      getliveUpcomingRAData();
    }
    else{
      getliveUpcomingRAData();
    }
  }

  void getliveUpcomingRAData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P5/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      "input_type" : "LiveAndUpcoming",
      "input": "",
      "key_ver" : "V1"
    });

    try {
      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("live & upcoming ra ${json.decode(response.body)}");
      // Check the status code and print the response or handle errors
      if (response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        // Success, print the response
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        _duplicateJsonResult.clear();
        jsonResult.clear();
        setState(() {
          jsonResult = listJson;
          _duplicateJsonResult = listJson;
        });
        debugPrint('Response body livera: ${response.body}');
      } else {
        // Error, print the error response
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
      }
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
    }
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
            automaticallyImplyLeading: false,
            backgroundColor: AapoortiConstants.primary,
            title: searchAction == true ?  Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                cursorColor: Colors.indigo[300],
                controller: _textsearchController,
                autofocus: searchAction,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5.0),
                    prefixIcon: Icon(Icons.search, color: Colors.indigo[300]),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.indigo[300]),
                      onPressed: () {
                        changetoolbarUi(false);
                        _textsearchController.text = "";
                        searchingliveandUpData(_textsearchController.text.trim(), context);
                      },
                    ),
                    focusColor: Colors.indigo[300],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.indigo.shade300, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.indigo.shade300, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.indigo.shade300, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Search",
                    border: InputBorder.none),
                onChanged: (query) {
                  if(query.isNotEmpty) {
                    searchingliveandUpData(query, context);
                  } else {
                    changetoolbarUi(false);
                    _textsearchController.text = "";
                  }
                },
              ),
            ) : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white)),
                SizedBox(width: 10),
                Container(
                    height: size.height * 0.10,
                    width: size.width / 1.9,
                    child: Marquee(
                      text: " Live & Upcoming(RA)",
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 30.0,
                      velocity: 100.0,
                      style: TextStyle(fontSize: 18,color: Colors.white),
                      pauseAfterRound: Duration(seconds: 1),
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ))
              ],
            ),
            actions: [
              searchAction == true ? SizedBox() : IconButton(icon: Icon(
                Icons.home,
                color: Colors.white,
              ), onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              }),
              searchAction == true ? SizedBox() : IconButton(onPressed: (){
                changetoolbarUi(true);
              }, icon: Icon(Icons.search, color: Colors.white))
            ],
        ),
        body: Builder(
            builder: (context) => Material(
              child: jsonResult.length == 0 ? SpinKitFadingCircle(color: AapoortiConstants.primary, size: 120.0) : Column(children: <Widget>[
                Container(child: Expanded(child: _myListView(context)))
              ]),
            ),
          )
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
        itemCount: jsonResult.length != 0 ? jsonResult.length : 0,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: Container(
            child: Card(
              elevation: 4,
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(width: 1, color: Colors.grey[300]!),
              ),
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Text(
                              (index + 1).toString() + ". ",
                              style:
                                  TextStyle(color: Colors.indigo, fontSize: 16),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    jsonResult[index]['key1'] != null ? jsonResult[index]['key1'] : "",
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
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Tender No.",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    //height: 30,
                                    child: Text(
                                      jsonResult[index]['key2'] != null
                                          ? jsonResult[index]['key2']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  )
                                ]),
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                        height: 30,
                                        width: 125,
                                        child: Text(
                                          "Tender Title",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          //height: 30,
                                          child: Text(
                                            jsonResult[index]['key3'] !=
                                                    null
                                                ? jsonResult[index]
                                                    ['key3']
                                                : "",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Work Area",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult[index]['key4'] != null ? jsonResult[index]['key4'] : "",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Start Date",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult[index]['key5'] != null ? changeTimeZone(jsonResult[index]['key5']) : "",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 16),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "End Date",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult[index]['key6'] != null ? changeTimeZone(jsonResult[index]['key6']) : "",
                                      style: TextStyle(color: Colors.red, fontSize: 16),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Status",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: Text(
                                      jsonResult[index]['key10'] != null
                                          ? jsonResult[index]['key10']
                                          : "",
                                      style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ]),
                                Row(children: <Widget>[
                                  Container(
                                    height: 30,
                                    width: 125,
                                    child: Text(
                                      "Links",
                                      style: TextStyle(
                                          color: Colors.indigo, fontSize: 16),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                if(jsonResult[index]['key7'] == "NA" || jsonResult[index]['key7'] == "NULL") {
                                                  AapoortiUtilities.showInSnackBar(context, "No PDF attached with this Tender!!");
                                                } else {
                                                  var fileUrl = jsonResult[index]['key7'].toString();
                                                  var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                                  AapoortiUtilities.ackAlert(context, fileUrl, fileName);
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
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                                Container(
                                                  child: Text('NIT',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 9),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5)),
                                              ])),
                                          GestureDetector(
                                              onTap: () {
                                                if (jsonResult[index]['key8'] == "NA" || jsonResult[index]['key8'] == "NULL") {
                                                  AapoortiUtilities.showInSnackBar(context, "No Documents attached with this Tender!!");
                                                } else {
                                                  showDialog(context: context, builder: (_) => Material(
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
                                                                        child:
                                                                        AapoortiUtilities.attachDocsListView(context, jsonResult[index]['key8'].toString()),
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
                                                                  ])))));
                                                }
                                              },
                                              child: Column(children: <Widget>[
                                                Container(
                                                  height: 30,
                                                  child: Image(
                                                      image: AssetImage(
                                                          'images/attach_icon.png'),
                                                      color: jsonResult[index]['key8'] == "NA" || jsonResult[index]['key8'] == "NULL"
                                                          ? Colors.brown
                                                          : Colors.green,
                                                      height: 30,
                                                      width: 20),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                                Container(
                                                  child: Text('  DOCS',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 9),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5)),
                                              ])),
                                          GestureDetector(
                                              onTap: () {
                                                if(jsonResult[index]['key9'] == "NA" || jsonResult[index]['key9'] == "NULL") {
                                                  AapoortiUtilities.showInSnackBar(context, "No corrigendum issued with this Tender!!");

                                                } else {
                                                  showDialog(context: context, builder: (_) => Material(
                                                    type: MaterialType
                                                        .transparency,
                                                    child: Center(
                                                        child: Container(
                                                            margin: EdgeInsets.only(top: 55),
                                                            padding: EdgeInsets.only(bottom: 50),
                                                            color: Color(0xAB000000),

                                                            // Aligns the container to center
                                                            child: Column(children: <Widget>[
                                                              Expanded(
                                                                child:
                                                                Container(
                                                                  padding:
                                                                  EdgeInsets.only(bottom: 20),
                                                                  child: AapoortiUtilities.corrigendumListView(
                                                                      context,
                                                                      jsonResult[index]['key9'].toString()),
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
                                                }
                                              },
                                              child: Column(children: <Widget>[
                                                Container(
                                                  height: 30,
                                                  child: Text(
                                                    "C",
                                                    style: TextStyle(
                                                        color: jsonResult[index]['key9'] == "NA" || jsonResult[index]['key9'] == "NULL"
                                                            ? Colors.brown
                                                            : Colors.green,
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0)),
                                                Container(
                                                  child: Text(
                                                      '  CORRIGENDA',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey,
                                                          fontSize: 9),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 5)),
                                              ])),
                                          Padding(
                                            padding: EdgeInsets.only(right: 0),
                                          ),
                                        ]),
                                  ),
                                ]),
                              ]),
                        ),
                      ])
                ],
              ),
            ),
          ));
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 10,
          );
        });
  }

  void changetoolbarUi(bool actionvalue) {
    setState(() {
      searchAction = actionvalue;
    });
  }

  String changeTimeZone(String resdate){
    tz.initializeTimeZones();

    DateTime dateTime = DateTime.parse(resdate);

    // Convert the DateTime object to the Asia/Kolkata timezone (or any other Asia time zone)
    tz.Location kolkata = tz.getLocation('Asia/Kolkata');
    tz.TZDateTime kolkataTime = tz.TZDateTime.from(dateTime, kolkata);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(kolkataTime);
    return formattedDate;
  }

  // --- Searching on Live & Upcoming Data
  void searchingliveandUpData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0) {
      try{
        Future<List<dynamic>> data = fetchliveandUpData(_duplicateJsonResult, query);
        data.then((value) {
          jsonResult = value.toSet().toList();
          setState(() {});
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      jsonResult = _duplicateJsonResult;
      setState(() {});
    }
    else{
      jsonResult = _duplicateJsonResult;
      setState(() {});
    }
  }

  // --- Search Live & Upcoming  Data ----
  Future<List<dynamic>> fetchliveandUpData(List<dynamic> data, String query) async{
    if(query.isNotEmpty){
      jsonResult = data.where((element) => element['key1'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key2'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key3'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key4'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key5'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key6'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key10'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return jsonResult;
    }
    else{
      return data;
    }
  }
}
