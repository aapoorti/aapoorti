import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

String pageNumber = "1";

class CloseRA extends StatefulWidget {
  get path => null;
  @override
  _CloseRAState createState() => _CloseRAState();
}

class _CloseRAState extends State<CloseRA> {
  List<dynamic> jsonResult = [], _duplicateJsonResult = [];
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  String? pgno;
  int? total_records, no_pages;
  int flag = 0;
  int? initialValRange;
  int? initalValueRange;
  int recordsPerPageCounter = 0;
  int final_value = 0;
  int? calculated_value;
  var _snackKey = GlobalKey<ScaffoldState>();
  var respons;

  String ref= "refresh";

  bool searchAction = false;

  final _textsearchController = TextEditingController();

  void initState() {
    super.initState();
    //fetchPost(pageNumber);
    getClosedRA();
  }

  @override
  void dispose() {
    jsonResult.clear();
    _duplicateJsonResult.clear();
    super.dispose();
  }

  void getClosedRA() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if(providedTime.isBefore(DateTime.now())){
      await fetchToken(context);
      getClosedRAData();
    }
    else{
      getClosedRAData();
    }
  }

  void getClosedRAData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      'input_type': 'GET_CLOSED_RA_MVIEW',
      'input': '',
      'key_ver': 'V2',
    });

    try {
      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);

      // Check the status code and print the response or handle errors
      if (response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        // Success, print the response
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        jsonResult.clear();
        _duplicateJsonResult.clear();
        setState(() {
          jsonResult = listJson;
          _duplicateJsonResult = listJson;
        });
        debugPrint('Response body CRA: ${response.body}');
        //setState(() {});
      } else {
        // Error, print the error response
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
        //AapoortiUtilities.showInSnackBar(context, json.decode(response.body)['errors']['detail_arguments']);
      }
    }
    on SocketException catch(ex){
      AapoortiUtilities.showInSnackBar(context, 'Please check your internet connection.');
    }
    catch (e) {
      // Handle any exceptions
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
    }
  }

  void getupdateClosedRAData() async{
    setState(() {
      ref = "Please wait...";
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      'input_type': 'GET_CLOSED_RA',
      'input': '',
      'key_ver': 'V2',
    });

    try {
      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);

      // Check the status code and print the response or handle errors
      if (response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        // Success, print the response
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        jsonResult.clear();
        _duplicateJsonResult.clear();
        setState(() {
          jsonResult = listJson;
          _duplicateJsonResult = listJson;
          ref = "refresh";
        });
        ToastMessage.success("Successfully refersh Closed Auctions(RA)");
        debugPrint('Response body CRA: ${response.body}');
      } else {
        setState(() {
           ref = "refresh";
        });
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
        //AapoortiUtilities.showInSnackBar(context, json.decode(response.body)['errors']['detail_arguments']);
      }
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
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
                        searchingClosedRAData(_textsearchController.text.trim(), context);
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
                    searchingClosedRAData(query, context);
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
                      text: " Closed Auctions(RA)",
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
                    Container(
                      height: 55,
                      color: Colors.cyan[50],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Data Last Updated on:", style: TextStyle(fontWeight: FontWeight.bold)),
                                RichText(text: TextSpan(
                                  text: jsonResult[0]['key12'] == null || jsonResult[0]['key12'] == "NULL" ? DateFormat("dd/MM/yyyy ").format(DateTime.now()) : "${jsonResult[0]['key12'].toString().split(" ").first} ",
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: jsonResult[0]['key12'] == null || jsonResult[0]['key12'] == "NULL" ? DateFormat("HH:mm").format(DateTime.now()) : jsonResult[0]['key12'].toString().split(" ").last, style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ))
                              ],
                            ),
                            InkWell(
                              onTap: () async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
                                if(providedTime.isBefore(DateTime.now())){
                                  await fetchToken(context);
                                  getupdateClosedRAData();
                                }
                                else{
                                  getupdateClosedRAData();
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh, size: 25, color: Colors.black),
                                  Text(ref, style: TextStyle(color: Colors.black))
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                    Container(child: Expanded(child: _myListView(context)))
              ]),
            ),
          )
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView.separated(
        itemCount: jsonResult.length != 0 ? jsonResult.length : 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              child: Column(children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 0)),
                Row(
                  children: <Widget>[
                    if (index == 0)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.cyan[700],
                        child: Text(
                          "  Closed RA of last 90 days ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(3.0)),
                Card(
                  elevation: 4,
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
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
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(left: 8)),
                                Text(
                                  (index + 1).toString() + ". ",
                                  style: TextStyle(
                                      color: Colors.indigo, fontSize: 16),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Expanded(
                                          child:
                                          AapoortiUtilities.customTextView(
                                              jsonResult[index]['key1'] ?? 'NA',
                                              Colors.indigo))
                                    ]),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Row(children: <Widget>[
                                      Container(
                                          height: 30,
                                          width: 125,
                                          child:
                                              AapoortiUtilities.customTextView(
                                                  "Tender No.", Colors.indigo)),
                                      Expanded(
                                          child:
                                          AapoortiUtilities.customTextView(
                                              jsonResult[index]
                                              ['key3'] ?? 'NA',
                                              Colors.black))
                                      // Expanded(
                                      //     child:
                                      //         AapoortiUtilities.customTextView(
                                      //             jsonResult![index]
                                      //                 ['TENDER_NUMBER'],
                                      //             Colors.black))
                                    ]),
                                    Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Container(
                                              height: 30,
                                              width: 125,
                                              child: AapoortiUtilities
                                                  .customTextView(
                                                      "Tender Title",
                                                      Colors.indigo)),
                                          Expanded(
                                              child: Container(
                                                  height: 30,
                                                  child: AapoortiUtilities
                                                      .customTextView(
                                                      jsonResult[index]
                                                      ['key4'] ?? 'NA',
                                                      Colors.black))),
                                        ]),
                                    Row(children: <Widget>[
                                      Container(
                                          height: 30,
                                          width: 125,
                                          child:
                                              AapoortiUtilities.customTextView(
                                                  "Work Area", Colors.indigo)),
                                      Container(
                                          height: 30,
                                          child:
                                          AapoortiUtilities.customTextView(
                                              jsonResult[index]
                                              ['key5'] ?? 'NA',
                                              Colors.black))
                                    ]),
                                    Row(children: <Widget>[
                                      Container(
                                          height: 30,
                                          width: 125,
                                          child:
                                              AapoortiUtilities.customTextView(
                                                  "Start Date", Colors.indigo)),
                                      Container(
                                          height: 30,
                                          child:
                                          AapoortiUtilities.customTextView(
                                              jsonResult[index]
                                              ['key6'] ?? 'NA',
                                              Colors.green))
                                    ]),
                                    Row(children: <Widget>[
                                      Container(
                                          height: 30,
                                          width: 125,
                                          child:
                                              AapoortiUtilities.customTextView(
                                                  "End Date", Colors.indigo)),
                                      Container(
                                          height: 30,
                                          child:
                                          AapoortiUtilities.customTextView(
                                              jsonResult[index]
                                              ['key7'] ?? 'NA',
                                              Colors.red))
                                    ]),
                                    Row(children: <Widget>[
                                      Container(
                                          height: 30,
                                          width: 125,
                                          child:
                                              AapoortiUtilities.customTextView(
                                                  "Links", Colors.indigo)),
                                      Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  if(jsonResult[index]
                                                          ['key8'] !=
                                                      'NA') {
                                                    var fileUrl =
                                                        jsonResult[index]
                                                                ['key8']
                                                            .toString();
                                                    var fileName = fileUrl
                                                        .substring(fileUrl
                                                            .lastIndexOf("/"));
                                                    AapoortiUtilities.ackAlert(
                                                        context,
                                                        fileUrl,
                                                        fileName);
                                                  } else {
                                                    AapoortiUtilities
                                                        .showInSnackBar(context,
                                                            "No PDF attached with this Tender!!");
                                                  }
                                                },
                                                child: Container(
                                                    child: Column(children: <
                                                            Widget>[
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
                                                    child: Text('  NIT',
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
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    if (jsonResult[index]
                                                            ['key9'] !=
                                                        'NA' || jsonResult[index]['key9'] != "NULL") {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) => Material(
                                                              type: MaterialType.transparency,
                                                              child: Center(
                                                                  child: Container(
                                                                      margin: EdgeInsets.only(top: 55),
                                                                      padding: EdgeInsets.only(bottom: 50),
                                                                      color: Color(0xAB000000),
                                                                      child: Column(children: <Widget>[
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: 20),
                                                                            child:
                                                                                AapoortiUtilities.attachDocsListView(context, jsonResult[index]['key9'].toString()),
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
                                                    } else {
                                                      AapoortiUtilities
                                                          .showInSnackBar(
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
                                                          color: jsonResult[index]['key9'] != 'NA' || jsonResult[index]['key9'] != "NULL"
                                                              ? Colors.green
                                                              : Colors.brown,
                                                          height: 30,
                                                          width: 20),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.all(
                                                            0.0)),
                                                    Container(
                                                      child: Text('  DOCS',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueGrey,
                                                              fontSize: 9),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5)),
                                                  ])),
                                              GestureDetector(
                                                  onTap: () {
                                                    debugPrint("corri result ${jsonResult[index]['key10']}");
                                                    if(jsonResult[index]['key10'].toString() == "NA" || jsonResult[index]['key10'].toString() == "NULL") {
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
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(bottom: 20),
                                                                      child: AapoortiUtilities.corrigendumListView(context, jsonResult[index]['key10'].toString()),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                    alignment: Alignment.bottomCenter,
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
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      height: 30,
                                                      child: Text(
                                                        "C",
                                                        style: TextStyle(
                                                            color: jsonResult[index]['key10'] == "NA" || jsonResult[index]['key10'] == "NULL"
                                                                ? Colors.brown
                                                                : Colors.green,
                                                            fontSize: 23,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.all(
                                                            0.0)),
                                                    Container(
                                                      child: Text(
                                                          '  CORRIGENDA',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueGrey,
                                                              fontSize: 9),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5)),
                                                  ])
                                                  ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 0),
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

                //padding: EdgeInsets.all(10),
              ]),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container();
        });
  }

  void changetoolbarUi(bool actionvalue) {
    setState(() {
      searchAction = actionvalue;
    });
  }

  // --- Searching on Closed RA Data
  void searchingClosedRAData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0) {
      try{
        Future<List<dynamic>> data = fetchClosedRAData(_duplicateJsonResult, query);
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

  // --- Search Closed RA Data ----
  Future<List<dynamic>> fetchClosedRAData(List<dynamic> data, String query) async{
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
