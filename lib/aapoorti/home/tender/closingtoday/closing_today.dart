import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String pageNumber = "1";

class ClosingToday extends StatefulWidget {
  get path => null;

  @override
  _ClosingTodayState createState() => _ClosingTodayState();
}

class _ClosingTodayState extends State<ClosingToday> {
  List<dynamic> jsonResult = [], _duplicateJsonResult = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  String? pgno;
  int? lotid, id;
  int? total_records, no_pages;
  int flag = 0;
  int? initialValRange;
  int initalValueRange = 0;
  int recordsPerPageCounter = 0;
  int final_value = 0;
  int? calculated_value;
  int? finalvalue;
  ProgressDialog? pr;
  List data1 = [];
  List data2 = [];

  String ref = "Refresh";
  bool searchAction = false;

  final _textsearchController = TextEditingController();

  void initState() {
    super.initState();
    //fetchPost(pageNumber);
    gettenderclosingtoday();
  }

  @override
  void dispose() {
    jsonResult.clear();
    _duplicateJsonResult.clear();
    super.dispose();
  }

  void gettenderclosingtoday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if (providedTime.isBefore(DateTime.now())) {
      await fetchToken(context);
      gettenderclosingtodayData();
    } else {
      gettenderclosingtodayData();
    }
  }

  void gettenderclosingtodayData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url =
        Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      "input_type": "GET_TENDER_CLOSING_TODAY_LIST_MVIEW",
      "input": "",
      "key_ver": "V2"
    });

    try {
      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);

      // Check the status code and print the response or handle errors
      if (response.statusCode == 200 &&
          json.decode(response.body)['status'] == 'Success') {
        // Success, print the response
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        _duplicateJsonResult.clear();
        setState(() {
          jsonResult = listJson;
          _duplicateJsonResult = listJson;
        });
        debugPrint('Response tenderclosing: ${response.body}');
      } else {
        // Error, print the error response
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(
            context, 'Something went wrong, please try later.');
      }
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(
          context, 'Something went wrong, please try later.');
    }
  }

  void getupdatetenderclosingtodayData() async {
    setState(() {
      ref = "Please wait";
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url =
        Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      "input_type": "GET_TENDER_CLOSING_TODAY_LIST",
      "input": "",
      "key_ver": "V1"
    });

    try {
      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);

      // Check the status code and print the response or handle errors
      if (response.statusCode == 200 &&
          json.decode(response.body)['status'] == 'Success') {
        // Success, print the response
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        _duplicateJsonResult.clear();
        setState(() {
          jsonResult.clear();
          jsonResult = listJson;
          _duplicateJsonResult = listJson;
          ref = "Refresh";
        });
        ToastMessage.success("Successfully updated tender closing today");
        debugPrint('Response tenderclosing: ${response.body}');
      } else {
        setState(() {
          ref = "Refresh";
        });
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(
            context, 'Something went wrong, please try later.');
      }
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(
          context, 'Something went wrong, please try later.');
    }
  }

  // void fetchPost(String pageNumber) async {
  //   pgno = pageNumber;
  //   try {
  //     var v = AapoortiConstants.webServiceUrl + 'Tender/TenderClosingToday?PAGECOUNTER=${this.pgno}';
  //     final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
  //     if(response.body.isEmpty) {
  //       SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
  //       AapoortiUtilities.showInSnackBar(context, "Something went wrong, please try later.");
  //     }
  //     else {
  //       debugPrint("this is closing tender list ${response.body.toString()}");
  //       jsonResult = json.decode(response.body);
  //       debugPrint("this is closing tender list ${jsonResult.toString()}");
  //
  //       debugPrint(jsonResult!.length.toString() + "length is this");
  //       finalvalue = jsonResult![0]['TOTCOUNT'];
  //       if (this.mounted)
  //         setState(() {
  //           finalvalue = jsonResult![0]['TOTCOUNT'];
  //         });
  //     }
  //   }
  //   catch(e){
  //     SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
  //     AapoortiUtilities.showInSnackBar(context, "Something went wrong, please try later.");
  //   }
  //
  // }
  //
  // void fetchPost1(String pageNumber) async {
  //   pgno = pageNumber;
  //
  //   var v = AapoortiConstants.webServiceUrl + 'Tender/TenderClosingToday?PAGECOUNTER=${this.pgno}';
  //   final response = await http.post(Uri.parse(v));
  //   jsonResult = json.decode(response.body);
  //   debugPrint("this is closing tender list1 ${jsonResult.toString()}");
  //   //print(jsonResult);
  //   _progressHide();
  //   debugPrint(jsonResult!.length.toString() + "length is this");
  //   finalvalue = jsonResult![0]['TOTCOUNT'];
  //
  //   setState(() {
  //     finalvalue = jsonResult![0]['TOTCOUNT'];
  //   });
  // }

  // Future<void> getData() async {
  //   var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,RLY_UNITS_AUCTION';
  //   final response1 = await http.post(Uri.parse(u));
  //   jsonResult1 = json.decode(response1.body);
  //   data1 = jsonResult1!;
  //
  //   setState(() {
  //     data1 = jsonResult1!;
  //   });
  // }

  // Future<void> getDatasecond() async {
  //   debugPrint('Fetching from service first spinner');
  //   var u = AapoortiConstants.webServiceUrl + '/getData?input=AUCTION_PRELOGIN,DP_START_DATE,${this._mySelection1}';
  //   final response1 = await http.post(Uri.parse(u));
  //   jsonResult2 = json.decode(response1.body);
  //   data2 = jsonResult2!;
  //
  //   setState(() {
  //     data2 = jsonResult2!;
  //   });
  // }
  //
  // Future<void> getDatafirst() async {
  //   debugPrint('Fetching from service first spinner');
  //   var u = AapoortiConstants.webServiceUrl + '/getData?input=AUCTION_PRELOGIN,DP_START_DATE,-1';
  //
  //   final response1 = await http.post(Uri.parse(u));
  //   jsonResult2 = json.decode(response1.body);
  //   data2 = jsonResult2!;
  //
  //   setState(() {
  //     data2 = jsonResult2!;
  //   });
  // }

  _progressShow() {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: true,
      showLogs: true,
    );
    pr!.show();
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        debugPrint(isHidden.toString());
      });
    });
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
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            backgroundColor: AapoortiConstants.primary,
            title: searchAction == true
                ? Container(
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
                          prefixIcon:
                              Icon(Icons.search, color: Colors.indigo[300]),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: Colors.indigo[300]),
                            onPressed: () {
                              changetoolbarUi(false);
                              _textsearchController.text = "";
                              searchingtenderclosingData(
                                  _textsearchController.text.trim(), context);
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
                        if (query.isNotEmpty) {
                          searchingtenderclosingData(query, context);
                        } else {
                          changetoolbarUi(false);
                          _textsearchController.text = "";
                        }
                      },
                    ),
                  )
                : Row(
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
                          width: size.width / 1.5,
                          child: Marquee(
                            text: " Tenders Closing Today",
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 30.0,
                            velocity: 100.0,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            pauseAfterRound: Duration(seconds: 1),
                            accelerationDuration: Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          ))
                    ],
                  ),
            actions: [

              searchAction == true
                  ? SizedBox()
                  : IconButton(
                      onPressed: () {
                        changetoolbarUi(true);
                      },
                      icon: Icon(Icons.search, color: Colors.white))
            ],
          ),
          body: Builder(
            builder: (context) => Material(
              child: jsonResult.length == 0
                  ? SpinKitFadingCircle(
                      color: AapoortiConstants.primary, size: 120.0)
                  : Column(children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.update, color: Colors.blue, size: 20),
                                SizedBox(width: 4),
                                Text(
                                  'Last updated on:',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 4),
                                RichText(
                                    text: TextSpan(
                                  text: jsonResult[0]['key11'] == null
                                      ? DateFormat("dd/MM/yyyy ")
                                          .format(DateTime.now())
                                      : "${jsonResult[0]['key11'].toString().split(" ").first} ",
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: jsonResult[0]['key11'] == null
                                            ? DateFormat("HH:mm")
                                                .format(DateTime.now())
                                            : jsonResult[0]['key11']
                                                .toString()
                                                .split(" ")
                                                .last,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ))
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                DateTime providedTime = DateTime.parse(
                                    prefs.getString('checkExp')!);
                                if (providedTime.isBefore(DateTime.now())) {
                                  await fetchToken(context);
                                  getupdatetenderclosingtodayData();
                                } else {
                                  getupdatetenderclosingtodayData();
                                }
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    ref != 'Refresh'
                                        ? Icon(Icons.cloud_download_rounded,
                                            color: Colors.blue, size: 16)
                                        : Icon(Icons.refresh,
                                            color: Colors.blue, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      ref,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 55,
                      //   color: Colors.cyan[50],
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: <Widget>[
                      //         Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text("Data Last Updated on:",
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold)),
                      //             RichText(
                      //                 text: TextSpan(
                      //               text: jsonResult[0]['key11'] == null
                      //                   ? DateFormat("dd/MM/yyyy ")
                      //                       .format(DateTime.now())
                      //                   : "${jsonResult[0]['key11'].toString().split(" ").first} ",
                      //               style: DefaultTextStyle.of(context).style,
                      //               children: <TextSpan>[
                      //                 TextSpan(
                      //                     text: jsonResult[0]['key11'] == null
                      //                         ? DateFormat("HH:mm")
                      //                             .format(DateTime.now())
                      //                         : jsonResult[0]['key11']
                      //                             .toString()
                      //                             .split(" ")
                      //                             .last,
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold)),
                      //               ],
                      //             ))
                      //           ],
                      //         ),
                      //         InkWell(
                      //           onTap: () async {
                      //             SharedPreferences prefs =
                      //                 await SharedPreferences.getInstance();
                      //             DateTime providedTime = DateTime.parse(
                      //                 prefs.getString('checkExp')!);
                      //             if (providedTime.isBefore(DateTime.now())) {
                      //               await fetchToken(context);
                      //               getupdatetenderclosingtodayData();
                      //             } else {
                      //               getupdatetenderclosingtodayData();
                      //             }
                      //           },
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Icon(Icons.refresh,
                      //                   size: 25, color: Colors.black),
                      //               Text(ref,
                      //                   style: TextStyle(color: Colors.black))
                      //             ],
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Container(child: Expanded(child: _myListView(context)))
                    ]),
            ),
          )),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
        itemCount: jsonResult.length != 0 ? jsonResult.length : 0,
        itemBuilder: (context, index) {
          return Container(
            child: Column(children: <Widget>[
              Padding(padding: EdgeInsets.all(4.0)),
              TenderCard(
                department: "${jsonResult[index]['key1'] != null ? "${index + 1}. ${jsonResult[index]['key1']}" : ""}",
                tenderNo:  jsonResult[index]['key6'] != null ? jsonResult[index]['key6'] : "",
                title: jsonResult[index]['key3'] != null ? jsonResult[index]['key3'] : "",
                workArea: jsonResult[index]['key2'] != null ? jsonResult[index]['key2'] : "",
                date: jsonResult[index]['key4'] != null ? jsonResult[index]['key4'] : "",
                nitlinks: jsonResult[index]['key7'],
                docslinks: jsonResult[index]['key8'],
                corrigendalinks: jsonResult[index]['key9'],
              ),
              // Card(
              //   elevation: 4,
              //   surfaceTintColor: Colors.transparent,
              //   color: Colors.white,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(5),
              //     side: BorderSide(width: 1, color: Colors.grey[300]!),
              //   ),
              //   child: Column(
              //     children: <Widget>[
              //       Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
              //             Expanded(
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Column(
              //                     crossAxisAlignment:
              //                         CrossAxisAlignment.start,
              //                     children: <Widget>[
              //                       Row(children: <Widget>[
              //                         Padding(
              //                             padding: EdgeInsets.only(left: 2)),
              //                         Expanded(
              //                             child: Text(
              //                           jsonResult[index]['key1'] != null
              //                               ? "${index + 1}. ${jsonResult[index]['key1']}"
              //                               : "",
              //                           style: TextStyle(
              //                               color: Colors.indigo,
              //                               fontSize: 15,
              //                               fontWeight: FontWeight.w600),
              //                         ))
              //                       ]),
              //                       Padding(padding: EdgeInsets.all(5)),
              //                       Row(children: <Widget>[
              //                         Container(
              //                           height: 30,
              //                           width: 125,
              //                           child: Text(
              //                             "Date",
              //                             style: TextStyle(
              //                                 color: Colors.indigo,
              //                                 fontSize: 16),
              //                           ),
              //                         ),
              //                         Container(
              //                           height: 30,
              //                           child: Text(
              //                             jsonResult[index]['key4'] != null
              //                                 ? jsonResult[index]['key4']
              //                                 : "",
              //                             style: TextStyle(
              //                                 color: Colors.black,
              //                                 fontSize: 16),
              //                           ),
              //                         )
              //                       ]),
              //                       Row(
              //                           mainAxisSize: MainAxisSize.max,
              //                           children: <Widget>[
              //                             Container(
              //                               height: 30,
              //                               width: 125,
              //                               child: Text(
              //                                 "Tender No",
              //                                 style: TextStyle(
              //                                     color: Colors.indigo,
              //                                     fontSize: 16),
              //                               ),
              //                             ),
              //                             Expanded(
              //                               child: Container(
              //                                 height: 30,
              //                                 child: Text(
              //                                   jsonResult[index]['key6'] !=
              //                                           null
              //                                       ? jsonResult[index]
              //                                           ['key6']
              //                                       : "",
              //                                   style: TextStyle(
              //                                       color: Colors.black,
              //                                       fontSize: 16),
              //                                   overflow:
              //                                       TextOverflow.ellipsis,
              //                                 ),
              //                               ),
              //                             ),
              //                           ]),
              //                       Row(children: <Widget>[
              //                         Container(
              //                           height: 30,
              //                           width: 125,
              //                           child: Text(
              //                             "Work Area",
              //                             style: TextStyle(
              //                                 color: Colors.indigo,
              //                                 fontSize: 16),
              //                           ),
              //                         ),
              //                         Container(
              //                           height: 30,
              //                           child: Text(
              //                             jsonResult[index]['key2'] != null
              //                                 ? jsonResult[index]['key2']
              //                                 : "",
              //                             style: TextStyle(
              //                                 color: Colors.black,
              //                                 fontSize: 16),
              //                           ),
              //                         )
              //                       ]),
              //                       Row(
              //                           mainAxisSize: MainAxisSize.min,
              //                           children: <Widget>[
              //                             Container(
              //                               height: 30,
              //                               width: 125,
              //                               child: Text(
              //                                 "Title",
              //                                 style: TextStyle(
              //                                     color: Colors.indigo,
              //                                     fontSize: 16),
              //                               ),
              //                             ),
              //                             Expanded(
              //                               child: Text(
              //                                 jsonResult[index]['key3'] !=
              //                                         null
              //                                     ? jsonResult[index]['key3']
              //                                     : "",
              //                                 maxLines: 5,
              //                                 style: TextStyle(
              //                                     color: Colors.green,
              //                                     fontSize: 16),
              //                                 overflow: TextOverflow.ellipsis,
              //
              //                                 //),
              //                               ),
              //                             ),
              //                           ]),
              //                       Row(children: <Widget>[
              //                         Container(
              //                           height: 30,
              //                           width: 125,
              //                           child: Text(
              //                             "Links",
              //                             style: TextStyle(
              //                                 color: Colors.indigo,
              //                                 fontSize: 16),
              //                           ),
              //                         ),
              //                         Expanded(
              //                           child: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment
              //                                       .spaceBetween,
              //                               mainAxisSize: MainAxisSize.min,
              //                               children: <Widget>[
              //                                 GestureDetector(
              //                                     onTap: () {
              //                                       if (jsonResult[index]
              //                                                   ['key7'] ==
              //                                               "NA" ||
              //                                           jsonResult[index]
              //                                                   ['key7'] ==
              //                                               "NA") {
              //                                         AapoortiUtilities
              //                                             .showInSnackBar(
              //                                                 context,
              //                                                 "No PDF attached with this Tender!!");
              //                                       } else {
              //                                         var fileUrl =
              //                                             jsonResult[index]
              //                                                     ['key7']
              //                                                 .toString();
              //                                         var fileName = fileUrl
              //                                             .substring(fileUrl
              //                                                 .lastIndexOf(
              //                                                     "/"));
              //                                         AapoortiUtilities
              //                                             .ackAlert(
              //                                                 context,
              //                                                 fileUrl,
              //                                                 fileName);
              //                                       }
              //                                     },
              //                                     child: Column(
              //                                         children: <Widget>[
              //                                           Container(
              //                                             child: Image(
              //                                                 image: AssetImage(
              //                                                     'images/pdf_home.png'),
              //                                                 height: 30,
              //                                                 width: 20),
              //                                           ),
              //                                           Padding(
              //                                               padding:
              //                                                   EdgeInsets
              //                                                       .all(
              //                                                           0.0)),
              //                                           Container(
              //                                             child: Text(' NIT',
              //                                                 style: TextStyle(
              //                                                     color: Colors
              //                                                         .blueGrey,
              //                                                     fontSize:
              //                                                         9),
              //                                                 textAlign:
              //                                                     TextAlign
              //                                                         .center),
              //                                           ),
              //                                           Padding(
              //                                               padding: EdgeInsets
              //                                                   .only(
              //                                                       bottom:
              //                                                           5)),
              //                                         ])),
              //                                 GestureDetector(
              //                                     onTap: () {
              //                                       if (jsonResult[index]
              //                                                   ['key8'] ==
              //                                               "NA" ||
              //                                           jsonResult[index]
              //                                                   ['key8'] ==
              //                                               "NULL") {
              //                                         AapoortiUtilities
              //                                             .showInSnackBar(
              //                                                 context,
              //                                                 "No Documents attached with this Tender!!");
              //                                       } else {
              //                                         showDialog(
              //                                             context: context,
              //                                             builder: (_) => Material(
              //                                                 type: MaterialType.transparency,
              //                                                 child: Center(
              //                                                     child: Container(
              //                                                         margin: EdgeInsets.only(top: 55),
              //                                                         padding: EdgeInsets.only(bottom: 50),
              //                                                         color: Color(0xAB000000),
              //                                                         child: Column(children: <Widget>[
              //                                                           Expanded(
              //                                                             child:
              //                                                                 Container(
              //                                                               padding: EdgeInsets.only(bottom: 20),
              //                                                               child: AapoortiUtilities.attachDocsListView(context, jsonResult[index]['key8'].toString()),
              //                                                             ),
              //                                                           ),
              //                                                           Align(
              //                                                             alignment:
              //                                                                 Alignment.bottomCenter,
              //                                                             child: GestureDetector(
              //                                                                 onTap: () {
              //                                                                   Navigator.of(context, rootNavigator: true).pop('dialog');
              //                                                                 },
              //                                                                 child: Image(
              //                                                                   image: AssetImage('images/close_overlay.png'),
              //                                                                   height: 50,
              //                                                                 )),
              //                                                           )
              //                                                         ])))));
              //                                       }
              //                                     },
              //                                     child: Column(
              //                                         children: <Widget>[
              //                                           Container(
              //                                             height: 30,
              //                                             child: Image(
              //                                                 image: AssetImage(
              //                                                     'images/attach_icon.png'),
              //                                                 color: jsonResult[index]['key8'] ==
              //                                                             "NA" ||
              //                                                         jsonResult[index]['key8'] ==
              //                                                             "NULL"
              //                                                     ? Colors
              //                                                         .brown
              //                                                     : Colors
              //                                                         .green,
              //                                                 height: 30,
              //                                                 width: 20),
              //                                           ),
              //                                           Padding(
              //                                               padding:
              //                                                   EdgeInsets
              //                                                       .all(
              //                                                           0.0)),
              //                                           Container(
              //                                             child: Text(
              //                                                 '  DOCS',
              //                                                 style: TextStyle(
              //                                                     color: Colors
              //                                                         .blueGrey,
              //                                                     fontSize:
              //                                                         9),
              //                                                 textAlign:
              //                                                     TextAlign
              //                                                         .center),
              //                                           ),
              //                                           Padding(
              //                                               padding: EdgeInsets
              //                                                   .only(
              //                                                       bottom:
              //                                                           5)),
              //                                         ])),
              //                                 GestureDetector(
              //                                     onTap: () {
              //                                       if (jsonResult[index]
              //                                                   ['key9'] ==
              //                                               "NA" ||
              //                                           jsonResult[index]
              //                                                   ['key9'] ==
              //                                               "NULL") {
              //                                         AapoortiUtilities
              //                                             .showInSnackBar(
              //                                                 context,
              //                                                 "No corrigendum issued with this Tender!!");
              //                                       } else {
              //                                         showDialog(
              //                                             context: context,
              //                                             builder: (_) =>
              //                                                 Material(
              //                                                   type: MaterialType
              //                                                       .transparency,
              //                                                   child: Center(
              //                                                       child: Container(
              //                                                           margin: EdgeInsets.only(top: 55),
              //                                                           padding: EdgeInsets.only(bottom: 50),
              //                                                           color: Color(0xAB000000),
              //
              //                                                           // Aligns the container to center
              //                                                           child: Column(children: <Widget>[
              //                                                             Expanded(
              //                                                               child: Container(
              //                                                                 padding: EdgeInsets.only(bottom: 20),
              //                                                                 child: AapoortiUtilities.corrigendumListView(context, jsonResult[index]['key9'].toString()),
              //                                                               ),
              //                                                             ),
              //                                                             Align(
              //                                                               alignment: Alignment.bottomCenter,
              //                                                               child: GestureDetector(
              //                                                                   onTap: () {
              //                                                                     Navigator.of(context, rootNavigator: true).pop('dialog');
              //                                                                   },
              //                                                                   child: Image(
              //                                                                     image: AssetImage('images/close_overlay.png'),
              //                                                                     height: 50,
              //                                                                   )),
              //                                                             )
              //                                                           ]))),
              //                                                 ));
              //                                       }
              //                                     },
              //                                     child: Column(
              //                                         children: <Widget>[
              //                                           Container(
              //                                             height: 30,
              //                                             child: Text(
              //                                               "C",
              //                                               style: TextStyle(
              //                                                   color: jsonResult[index]['key9'] ==
              //                                                               "NA" ||
              //                                                           jsonResult[index]['key9'] ==
              //                                                               "NULL"
              //                                                       ? Colors
              //                                                           .brown
              //                                                       : Colors
              //                                                           .green,
              //                                                   fontSize: 23,
              //                                                   fontWeight:
              //                                                       FontWeight
              //                                                           .bold),
              //                                             ),
              //                                           ),
              //                                           Padding(
              //                                               padding:
              //                                                   EdgeInsets
              //                                                       .all(
              //                                                           0.0)),
              //                                           Container(
              //                                             child: Text(
              //                                                 '  CORRIGENDA',
              //                                                 style: TextStyle(
              //                                                     color: Colors
              //                                                         .blueGrey,
              //                                                     fontSize:
              //                                                         9),
              //                                                 textAlign:
              //                                                     TextAlign
              //                                                         .center),
              //                                           ),
              //                                           Padding(
              //                                               padding: EdgeInsets
              //                                                   .only(
              //                                                       bottom:
              //                                                           5)),
              //                                         ])),
              //                                 Padding(
              //                                     padding: EdgeInsets.only(
              //                                         right: 5)),
              //                               ]),
              //                         ),
              //                       ]),
              //                     ]),
              //               ),
              //             ),
              //           ])
              //     ],
              //   ),
              // ),
            ]),
          );
        },
        separatorBuilder: (context, index) {
          return Container();
        });
  }

  // void paginationFirstClick() {
  //   if (pageNumber == 1.toString()) {
  //     debugPrint("you are on the first page !");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("You are on the first page!"),
  //       duration: const Duration(seconds: 1),
  //       backgroundColor: Colors.redAccent[100],
  //     ));
  //   } else {
  //     _progressShow();
  //     pageNumber = "1";
  //     fetchPost1(pageNumber);
  //   }
  // }
  //
  // void paginationPrevClick() {
  //   if (pageNumber == 1.toString()) {
  //      debugPrint("you are on the first page !");
  //      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("You are on the first page!"),
  //       duration: const Duration(seconds: 1),
  //       backgroundColor: Colors.redAccent[100],
  //     ));
  //   } else {
  //     _progressShow();
  //     int counter = int.parse(pageNumber);
  //     counter += -1;
  //     pageNumber = counter.toString();
  //     fetchPost1(pageNumber);
  //   }
  // }
  //
  // void paginationNextClick() {
  //   if (pageNumber == no_pages.toString()) {
  //     debugPrint("you are on the last page !");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("You are on the last page!"),
  //       duration: const Duration(seconds: 1),
  //       backgroundColor: Colors.redAccent[100],
  //     ));
  //   } else {
  //     _progressShow();
  //     int counter = int.parse(pageNumber);
  //     counter += 1;
  //     pageNumber = counter.toString();
  //     fetchPost1(pageNumber);
  //   }
  // }
  //
  // void paginationLastClick() {
  //   if (pageNumber == no_pages.toString()) {
  //     debugPrint("you are on the last page !");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("You are on the last page!"),
  //       duration: const Duration(seconds: 1),
  //       backgroundColor: Colors.redAccent[100],
  //     ));
  //   } else {
  //     _progressShow();
  //     pageNumber = no_pages.toString();
  //     fetchPost1(pageNumber);
  //   }
  // }

  void changetoolbarUi(bool actionvalue) {
    setState(() {
      searchAction = actionvalue;
    });
  }

  // --- Searching on Tender Closing today Data
  void searchingtenderclosingData(String query, BuildContext context) {
    if (query.isNotEmpty && query.length > 0) {
      try {
        Future<List<dynamic>> data =
            fetchtenderclosingData(_duplicateJsonResult!, query);
        data.then((value) {
          jsonResult = value.toSet().toList();
          setState(() {});
        });
      } on Exception catch (err) {}
    } else if (query.isEmpty || query.length == 0 || query == "") {
      jsonResult = _duplicateJsonResult;
      setState(() {});
    } else {
      jsonResult = _duplicateJsonResult;
      setState(() {});
    }
  }

  // --- Search Tender Closing today Data ----
  Future<List<dynamic>> fetchtenderclosingData(
      List<dynamic> data, String query) async {
    if (query.isNotEmpty) {
      jsonResult = data
          .where((element) =>
              element['key1']
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains(query.toString().trim().toLowerCase()) ||
              element['key2']
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains(query.toString().trim().toLowerCase()) ||
              element['key3']
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains(query.toString().trim().toLowerCase()) ||
              element['key4']
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains(query.toString().trim().toLowerCase()) ||
              element['key5']
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains(query.toString().trim().toLowerCase()) ||
              element['key6']
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains(query.toString().trim().toLowerCase()) ||
              element['key10']
                  .toString()
                  .trim()
                  .toLowerCase()
                  .contains(query.toString().trim().toLowerCase()))
          .toList();
      return jsonResult!;
    } else {
      return data;
    }
  }
}

class TenderCard extends StatelessWidget {
  final String department;
  final String tenderNo;
  final String title;
  final String workArea;
  final String date;
  final String nitlinks;
  final String docslinks;
  final String corrigendalinks;
  //final bool isLive;

  const TenderCard({
    super.key,
    required this.department,
    required this.tenderNo,
    required this.title,
    required this.workArea,
    required this.date,
    required this.nitlinks,
    required this.docslinks,
    required this.corrigendalinks
    //required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    department,
                    style: const TextStyle(
                      fontSize: 16, // Reduced from 18 to make it fit on one line
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                // if(isLive)
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 8,
                //     vertical: 4,
                //   ),
                //   decoration: BoxDecoration(
                //     color: Colors.green.withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: const Text(
                //     'LIVE',
                //     style: TextStyle(
                //       color: Colors.green,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 12,
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Tender No', tenderNo),
            _buildInfoRow('Date', date),
            _buildInfoRow('Work Area', workArea),
            _buildInfoRow('Title', title),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.description, 'NIT', Colors.red, nitlinks, context),
                _buildActionButton(Icons.article, 'Docs', docslinks == "NA" || docslinks == "NULL" ? Colors.brown : Colors.green, docslinks, context),
                _buildActionButton(Icons.edit_note, 'Corrigenda', corrigendalinks == "NA" || corrigendalinks == "NULL" ? Colors.brown : Colors.green, corrigendalinks, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: label == 'Title' ? ReadMoreText(
              value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              trimLines: 2,
              colorClickableText: Colors.brown[300],
              trimMode: TrimMode.Line,
              trimCollapsedText: '...more',
              trimExpandedText: '...less',
              delimiter: '',
              ) : Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, String links, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if(label == 'NIT'){
            if(links != 'NA') {
              var fileUrl = links.toString();
              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
              if(Platform.isIOS){
                AapoortiUtilities.openPdf(context, fileUrl, fileName);
              }
              else{
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      contentPadding: EdgeInsets.all(20),
                      content: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Choose an option for file  ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "NIT",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Colors.lightBlue[700],
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlue[700],
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      AapoortiUtilities.downloadpdf(fileUrl, fileName, context);
                                    },
                                    child: Text('Download'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlue[700],
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      AapoortiUtilities.openPdf(context, fileUrl, fileName);
                                    },
                                    child: Text('Open'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            } else {
              AapoortiUtilities.showInSnackBar(context, "No PDF attached with this Tender!!");
            }
          }
          else if(label == 'Docs'){
            if(links == "NA" || links == "NULL") {
              AapoortiUtilities.showInSnackBar(context, "No Documents attached with this Tender!!");
            }
            else {
              showDialog(context: context, builder: (_) => Material(
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
                                    AapoortiUtilities.attachDocsListView(context, links.toString()),
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
          }
          else if(label == 'Corrigenda'){
            if(links.toString() == "NA" || links.toString() == "NULL") {
              AapoortiUtilities.showInSnackBar(context, "No corrigendum issued with this Tender!!");
            }
            else {
              showDialog(context: context, builder: (_) => Material(
                type: MaterialType.transparency,
                child: Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 55),
                        padding: EdgeInsets.only(bottom: 50),
                        color: Color(0xAB000000),
                        child: Column(children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: AapoortiUtilities.corrigendumListView(context, links.toString()),
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
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              label == 'NIT' ? Image.asset('images/pdf_home.png', height: 30, width: 20) : Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
