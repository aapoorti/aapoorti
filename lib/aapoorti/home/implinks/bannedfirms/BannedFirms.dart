// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
//
// class BannedFirms extends StatefulWidget {
//   @override
//   _BannedFirmsState createState() => _BannedFirmsState();
// }
//
// class _BannedFirmsState extends State<BannedFirms> {
//   List<dynamic>? jsonResult;
//   List<dynamic>? jsonResult1;
//   ProgressDialog? pr;
//
//   void initState() {
//     super.initState();
//     fetchPost();
//     if(AapoortiConstants.count == '0' || DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0)
//       fetchSavedBF();
//   }
//
//   _progressShow() {
//     pr = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
//     pr!.show();
//   }
//
//   ProgressStop(context) {
//     ProgressDialog pr = ProgressDialog(context);
//
//     Future.delayed(Duration(milliseconds: 100), () {
//       pr.hide().then((isHidden) {
//         debugPrint(isHidden.toString());
//       });
//     });
//   }
//
//   _progressHide() {
//     Future.delayed(Duration(milliseconds: 100), () {
//       pr!.hide().then((isHidden) {
//         debugPrint(isHidden.toString());
//       });
//     });
//   }
//
//   void onTap() {
//     fetchPostTap();
//     if (AapoortiConstants.count == '0' ||
//         DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0)
//       fetchSavedBF();
//   }
//
//   final dbHelper = DatabaseHelper.instance;
//   void fetchSavedBF() async {
//     AapoortiConstants.date2 = DateTime.now().add(Duration(days: 1)).toString();
//     AapoortiConstants.count = '1';
//     var v = "https://ireps.gov.in/Aapoorti/ServiceCallHD/bannedFirms?TYPE=0";
//     final response = await http.post(Uri.parse(v));
//     jsonResult1 = json.decode(response.body);
//     AapoortiConstants.jsonResult2 = jsonResult1!;
//     await dbHelper.deleteBanned(1);
//     for (int index = 0; index < jsonResult1!.length; index++) {
//       Map<String, dynamic> row = {
//         DatabaseHelper.Tblb_Col1_Title: jsonResult1![index]['VNAME'],
//         DatabaseHelper.Tblb_Col2_Letter: jsonResult1![index]['LET_NO'],
//         DatabaseHelper.Tblb_Col3_Date: jsonResult1![index]['LET_DT_S'],
//         DatabaseHelper.Tblb_Col4_Address: jsonResult1![index]['VADDRESS'],
//         DatabaseHelper.Tblb_Col5_Type: jsonResult1![index]['SUBJ'],
//         DatabaseHelper.Tblb_Col6_Banned: jsonResult1![index]['BAN_UPTO'],
//         DatabaseHelper.Tblb_Col7_Remarks: jsonResult1![index]['REMARKS'],
//         DatabaseHelper.Tblb_Col8_Id: jsonResult1![index]['DOC_ID'],
//         DatabaseHelper.Tblb_Col9_view: jsonResult1![index]['DOC_PATH'],
//         DatabaseHelper.Tblb_Col10_Date: AapoortiConstants.date2.toString(),
//         DatabaseHelper.Tblb_Col11_Count: AapoortiConstants.count,
//       };
//       final id = dbHelper.insertBanned(row);
//     }
//   }
//
//   void fetchPost() async {
//     var v = "https://ireps.gov.in/Aapoorti/ServiceCallHD/bannedFirms?TYPE=0";
//
//     if(AapoortiConstants.jsonResult2 != null && DateTime.now().toString().compareTo(AapoortiConstants.date2) < 0) {
//       jsonResult = AapoortiConstants.jsonResult2;
//     }
//     else if(DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0) {
//       AapoortiConstants.count = '0';
//       await dbHelper.deleteBanned(1);
//       final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
//       jsonResult = json.decode(response.body);
//     } else {
//       await dbHelper.deleteBanned(1);
//       final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
//       jsonResult = json.decode(response.body);
//     }
//     setState(() {});
//   }
//
//   void fetchPostTap() async {
//     var v = "https://ireps.gov.in/Aapoorti/ServiceCallHD/bannedFirms?TYPE=0";
//
//     await dbHelper.deleteBanned(1);
//     final response = await http.post(Uri.parse(v));
//     jsonResult = json.decode(response.body);
//     _progressHide();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.of(context, rootNavigator: true).pop();
//         return false;
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//             iconTheme: IconThemeData(color: Colors.white),
//             backgroundColor: AapoortiConstants.primary,
//             actions: [
//               IconButton(
//                 icon: Icon(
//                   Icons.home,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
//                 },
//               ),
//             ],
//             title: Text('Banned/Suspended Firms', maxLines: 1, style: TextStyle(color: Colors.white, fontSize: 18))
//         ),
//         backgroundColor: Colors.grey[200],
//         body: Column(
//           children: <Widget>[
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: 30,
//               color: Colors.white12,
//               padding: const EdgeInsets.only(top: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   MaterialButton(
//                       child: RichText(
//                         text: TextSpan(
//                           text: 'To view latest data, click here',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.teal[900],
//                           ),
//                         ),
//                       ),
//                       onPressed: () async {
//                         _progressShow();
//                         await dbHelper.deleteBanned(1);
//                         AapoortiConstants.count = '0';
//                         AapoortiConstants.jsonResult2 = null;
//                         onTap();
//                       }),
//                 ],
//               ),
//             ),
//             Container(
//                 child: Expanded(
//                     child: jsonResult == null
//                         ? SpinKitFadingCircle(
//                             color: AapoortiConstants.primary,
//                             size: 130.0,
//                           )
//                         : _BannedFirmsListView(context)))
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _BannedFirmsListView(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       itemCount: jsonResult != null ? jsonResult!.length : 0,
//       itemBuilder: (context, index) {
//         return Card(
//           color: Colors.white,
//           surfaceTintColor: Colors.white,
//           child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
//               Widget>[
//             Text(
//               "\n" + (index + 1).toString() + ".       ",
//               style: TextStyle(color: Colors.indigo, fontSize: 16),
//             ),
//             Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(children: <Widget>[
//                       Expanded(
//                           child: Text(
//                         jsonResult![index]['VNAME'] != null
//                             ? ("\n" + jsonResult![index]['VNAME'])
//                             : "",
//                         style: TextStyle(
//                             color: Colors.indigo,
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                       ))
//                     ]),
//                     Padding(
//                       padding: EdgeInsets.all(5),
//                     ),
//                     Row(children: <Widget>[
//                       Container(
//                         height: 30,
//                         width: 125,
//                         child: Text(
//                           "Letter No",
//                           style: TextStyle(
//                             color: Colors.indigo,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 30,
//                         child: Text(
//                           jsonResult![index]['LET_NO'] != null
//                               ? jsonResult![index]['LET_NO']
//                               : "",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 15,
//                           ),
//                         ),
//                       )
//                     ]),
//                     Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
//                       Container(
//                         height: 30,
//                         width: 125,
//                         child: Text(
//                           "Date",
//                           style: TextStyle(
//                             color: Colors.indigo,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           height: 30,
//                           child: Text(
//                             jsonResult![index]['LET_DT_S'] != null
//                                 ? jsonResult![index]['LET_DT_S']
//                                 : "",
//                             style: TextStyle(color: Colors.black, fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     ]),
//                     Row(children: <Widget>[
//                       Container(
//                         height: 30,
//                         width: 125,
//                         child: Text(
//                           "Address",
//                           style: TextStyle(
//                             color: Colors.indigo,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ]),
//                     Row(children: <Widget>[
//                       Expanded(
//                           child: Container(
//                         //height: 30,
//                         child: Text(
//                           jsonResult![index]['VADDRESS'] != null
//                               ? jsonResult![index]['VADDRESS']
//                               : "",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         ),
//                       ))
//                     ]),
//                     Padding(padding: EdgeInsets.only(top: 15.0)),
//                     Row(children: <Widget>[
//                       Container(
//                         height: 30,
//                         width: 125,
//                         child: Text(
//                           "Type",
//                           style: TextStyle(
//                             color: Colors.indigo,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 30,
//                         child: Text(
//                           jsonResult![index]['SUBJ'] != null
//                               ? (jsonResult![index]['SUBJ'] == 'Banning'
//                                   ? "Banned"
//                                   : jsonResult![index]['SUBJ'])
//                               : "---",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         ),
//                       )
//                     ]),
//                     Row(children: <Widget>[
//                       Container(
//                         height: 30,
//                         width: 125,
//                         child: Text(
//                           "Banned Upto",
//                           style: TextStyle(
//                             color: Colors.indigo,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 30,
//                         child: Text(
//                           jsonResult![index]['BAN_UPTO'] != null
//                               ? jsonResult![index]['BAN_UPTO']
//                               : "---",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         ),
//                       )
//                     ]),
//                     Row(children: <Widget>[
//                       Container(
//                         height: 30,
//                         width: 125,
//                         child: Text(
//                           "Remarks",
//                           style: TextStyle(
//                             color: Colors.indigo,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ]),
//                     Row(children: <Widget>[
//                       Expanded(
//                           child: Container(
//                         child: Text(
//                           jsonResult![index]['REMARKS'] != null
//                               ? jsonResult![index]['REMARKS']
//                               : "---",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         ),
//                       ))
//                     ]),
//                     Row(children: <Widget>[
//                       Container(
//                         height: 30,
//                         width: 125,
//                         child: Text(
//                           "View Letter",
//                           style: TextStyle(color: Colors.indigo, fontSize: 15),
//                         ),
//                       ),
//                       Expanded(
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               if (jsonResult![index]['DOC_PATH'].toString() !=
//                                   'NA')
//                                 GestureDetector(
//                                   onTap: () {
//                                     //if(jsonResult[index]['DOC_PATH']!='NA'){
//                                     var fileUrl =
//                                         AapoortiConstants.contextPath +
//                                             jsonResult![index]['DOC_PATH']
//                                                 .toString();
//                                     var fileName = fileUrl
//                                         .substring(fileUrl.lastIndexOf("/"));
//                                     AapoortiUtilities.ackAlert(
//                                         context, fileUrl, fileName);
//                                   },
//                                   child: Container(
//                                     height: 30,
//                                     child: Image(
//                                         image:
//                                             AssetImage('images/pdf_home.png'),
//                                         height: 30,
//                                         width: 20),
//                                   ),
//                                 )
//                               else
//                                 Container(
//                                   height: 30,
//                                   child: Text("---"),
//                                 ),
//                             ]),
//                       ),
//                     ])
//                   ]),
//             ),
//           ]),
//         );
//       },
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/view/components/text/read_more_text.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:marquee/marquee.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class BannedFirms extends StatefulWidget {
  @override
  _BannedFirmsState createState() => _BannedFirmsState();
}

class _BannedFirmsState extends State<BannedFirms> {
  List<dynamic>? jsonResult;
  List<dynamic>? jsonResult1;
  List<dynamic>? _duplicatejsonResult;
  ProgressDialog? pr;

  bool searchAction = false;
  final _textsearchController = TextEditingController();

  void initState() {
    super.initState();
    fetchPost();
    if(AapoortiConstants.count == '0' || DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0)
      fetchSavedBF();
  }

  _progressShow() {
    pr = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr!.show();
  }

  ProgressStop(context) {
    ProgressDialog pr = ProgressDialog(context);

    Future.delayed(Duration(milliseconds: 100), () {
      pr.hide().then((isHidden) {
        debugPrint(isHidden.toString());
      });
    });
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        debugPrint(isHidden.toString());
      });
    });
  }

  void onTap() {
    fetchPostTap();
    if (AapoortiConstants.count == '0' ||
        DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0)
      fetchSavedBF();
  }

  final dbHelper = DatabaseHelper.instance;
  void fetchSavedBF() async {
    AapoortiConstants.date2 = DateTime.now().add(Duration(days: 1)).toString();
    AapoortiConstants.count = '1';
    var v = "https://ireps.gov.in/Aapoorti/ServiceCallHD/bannedFirms?TYPE=0";
    final response = await http.post(Uri.parse(v));
    jsonResult1 = json.decode(response.body);
    _duplicatejsonResult = json.decode(response.body);
    AapoortiConstants.jsonResult2 = jsonResult1!;
    await dbHelper.deleteBanned(1);
    for (int index = 0; index < jsonResult1!.length; index++) {
      Map<String, dynamic> row = {
        DatabaseHelper.Tblb_Col1_Title: jsonResult1![index]['VNAME'],
        DatabaseHelper.Tblb_Col2_Letter: jsonResult1![index]['LET_NO'],
        DatabaseHelper.Tblb_Col3_Date: jsonResult1![index]['LET_DT_S'],
        DatabaseHelper.Tblb_Col4_Address: jsonResult1![index]['VADDRESS'],
        DatabaseHelper.Tblb_Col5_Type: jsonResult1![index]['SUBJ'],
        DatabaseHelper.Tblb_Col6_Banned: jsonResult1![index]['BAN_UPTO'],
        DatabaseHelper.Tblb_Col7_Remarks: jsonResult1![index]['REMARKS'],
        DatabaseHelper.Tblb_Col8_Id: jsonResult1![index]['DOC_ID'],
        DatabaseHelper.Tblb_Col9_view: jsonResult1![index]['DOC_PATH'],
        DatabaseHelper.Tblb_Col10_Date: AapoortiConstants.date2.toString(),
        DatabaseHelper.Tblb_Col11_Count: AapoortiConstants.count,
      };
      final id = dbHelper.insertBanned(row);
    }
  }

  void fetchPost() async {
    var v = "https://ireps.gov.in/Aapoorti/ServiceCallHD/bannedFirms?TYPE=0";
    if (AapoortiConstants.jsonResult2 != null && DateTime.now().toString().compareTo(AapoortiConstants.date2) < 0) {
      jsonResult = AapoortiConstants.jsonResult2;
    } else if (DateTime.now().toString().compareTo(AapoortiConstants.date2) > 0) {
      AapoortiConstants.count = '0';
      await dbHelper.deleteBanned(1);
      final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
      debugPrint("banned firm ${json.decode(response.body)}");
      jsonResult = json.decode(response.body);
      _duplicatejsonResult = json.decode(response.body);
    } else {
      await dbHelper.deleteBanned(1);
      final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
      jsonResult = json.decode(response.body);
      _duplicatejsonResult = json.decode(response.body);
    }
    setState(() {});
  }

  void fetchPostTap() async {
    var v = "https://ireps.gov.in/Aapoorti/ServiceCallHD/bannedFirms?TYPE=0";
    await dbHelper.deleteBanned(1);
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    _progressHide();
    setState(() {});
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
                      searchingBannedFirmData(_textsearchController.text.trim(), context);
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
                  searchingBannedFirmData(query, context);
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
                    text: " Banned/Suspended Firms",
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
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              color: Colors.white12,
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                      child: RichText(
                        text: TextSpan(
                          text: 'To view latest data, click here',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue[800],
                          ),
                        ),
                      ),
                      onPressed: () async {
                        _progressShow();
                        await dbHelper.deleteBanned(1);
                        AapoortiConstants.count = '0';
                        AapoortiConstants.jsonResult2 = null;
                        onTap();
                      }),
                ],
              ),
            ),
            Container(
                child: Expanded(
                    child: jsonResult == null
                        ? SpinKitWave(
                            color: Colors.lightBlue[800],
                            size: 30.0,
                          )
                        : _BannedFirmsListView(context)))
          ],
        ),
      ),
    );
  }

  Widget _BannedFirmsListView(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.symmetric(
                horizontal: 10, vertical: 3), // Reduced vertical spacing
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Shadow color
                  spreadRadius: 1, // Spread the shadow
                  blurRadius: 1, // Blur radius
                  offset: Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: Card(
                elevation: 3,
                color: index % 2 == 0 ? Color(0xFFF0F8FF) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  side: BorderSide(
                      color: Colors.grey.shade400, width: 1), // Shaded border
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5.0, top: 1.0), // Add left and top padding
                        child: Text(
                          "\n" + (index + 1).toString() + ".       ",
                          style: TextStyle(
                              color: Colors.lightBlue[800], fontSize: 15),
                        ),
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                jsonResult![index]['VNAME'] != null
                                    ? ("\n" + jsonResult![index]['VNAME'])
                                    : "",
                                style: TextStyle(
                                    color: Colors.lightBlue[800],
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ))
                            ]),
                            Row(
                              children: <Widget>[
                                if (jsonResult![index]['SUBJ'] !=
                                    null) // Show only if SUBJ is not null
                                  Text(
                                    " ( " + (jsonResult![index]['SUBJ'] == 'Banning' ? "Banned" : jsonResult![index]['SUBJ']) + " ) ",
                                    style: TextStyle(
                                      color: Colors.red, // Blue color
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                            Row(children: <Widget>[
                              Container(
                                height: 30,
                                width: 76,
                                child: Text(
                                  "Letter No",
                                  style: TextStyle(
                                    color: Colors.lightBlue[800],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                child: Text(
                                  jsonResult![index]['LET_NO'] != null ? jsonResult![index]['LET_NO'] : "",
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
                                width: 76,
                                child: Text(
                                  "Date",
                                  style: TextStyle(
                                    color: Colors.lightBlue[800],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 30,
                                  child: Text(
                                    jsonResult![index]['LET_DT_S'] != null
                                        ? jsonResult![index]['LET_DT_S']
                                        : "",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                              ),
                            ]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Address label
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          3), // Space between label and value
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                      color: Colors.lightBlue[800],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                // Address value
                                ReadMoreText(
                                  jsonResult![index]['VADDRESS'] != null
                                      ? jsonResult![index]['VADDRESS']
                                      : "",
                                  trimLines: 2,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  colorClickableText: Colors.grey,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '..More',
                                  trimExpandedText: '..Less',
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 4.0)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Title "Remarks"
                                Container(
                                  height: 20,
                                  child: Text(
                                    "Remarks",
                                    style: TextStyle(
                                      color: Colors.lightBlue[800],
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                // Value of Remarks
                                SizedBox(
                                    height: 0), // Space between title and value
                                ReadMoreText(
                                  jsonResult![index]['REMARKS'] != null
                                      ? jsonResult![index]['REMARKS']
                                      : "---",
                                  trimLines: 2,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  colorClickableText: Colors.grey,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '..More',
                                  trimExpandedText: '..Less',
                                ),
                              ],
                            ),
                            Row(children: <Widget>[
                              Container(
                                height: 30,
                                width: 100,
                                child: Text(
                                  "Banned Upto",
                                  style: TextStyle(
                                    color: Colors.lightBlue[800],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                height: 30,
                                child: Text(
                                  jsonResult![index]['BAN_UPTO'] != null
                                      ? jsonResult![index]['BAN_UPTO']
                                      : "---",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              )
                            ]),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      if (jsonResult![index]['DOC_PATH'].toString() != 'NA')
                                        SizedBox.shrink()
                                      else
                                        Container(
                                          height: 15,
                                        ),
                                      SizedBox(
                                          height:
                                              3), // Space between the URL and the text
                                      GestureDetector(
                                        onTap: () {
                                          if(jsonResult![index]['DOC_PATH'].toString() != 'NA') {
                                            var fileUrl = AapoortiConstants.contextPath + jsonResult![index]['DOC_PATH'].toString();
                                            var fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
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
                                                              "$fileName",
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
                                          }
                                          else {
                                            AapoortiUtilities.showInSnackBar(context, "File not available as it was not uploaded by the Railway Department.");
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 10,
                                              bottom:
                                                  10), // Space between text and card boundary
                                          child: Column(
                                            children: [
                                              Image(
                                                  image: AssetImage(
                                                      'images/pdf_home.png'),
                                                  height: 30,
                                                  width: 20),
                                              Text(
                                                "View Letter",
                                                style: TextStyle(
                                                  color: jsonResult![index]['DOC_PATH'].toString() != 'NA' ? Colors.green : Colors.red,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ]))
                    ])));
      },
    );
  }

  void changetoolbarUi(bool actionvalue) {
    setState(() {
      searchAction = actionvalue;
    });
  }

  // --- Banned Firm Data
  void searchingBannedFirmData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0) {
      try{
        Future<List<dynamic>> data = fetchBannedFirmData(_duplicatejsonResult!, query);
        data.then((value) {
          jsonResult = value.toSet().toList();
          setState(() {});
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      jsonResult = _duplicatejsonResult;
      setState(() {});
    }
    else{
      jsonResult = _duplicatejsonResult;
      setState(() {});
    }
  }

  // --- Banned Firm Data ----
  Future<List<dynamic>> fetchBannedFirmData(List<dynamic> data, String query) async{
    if(query.isNotEmpty){
      jsonResult = data.where((element) => element['SUBJ'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['LET_NO'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['VADDRESS'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['REMARKS'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['BAN_UPTO'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['VNAME'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return jsonResult!;
    }
    else{
      return data;
    }
  }
}
