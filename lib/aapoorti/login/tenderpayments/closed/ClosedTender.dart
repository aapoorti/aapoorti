// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
// import 'package:flutter_app/aapoorti/common/NoData.dart';
// import 'package:flutter_app/aapoorti/common/NoResponse.dart';
// import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
//
// class ClosedTender extends StatefulWidget {
//   get path => null;
//   @override
//   _ClosedTenderState createState() => _ClosedTenderState();
// }
//
// class _ClosedTenderState extends State<ClosedTender> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   List<dynamic>? jsonResult = null;
//   final dbHelper = DatabaseHelper.instance;
//   var rowCount = -1;
//   String worka = "";
//   String name = "";
//   List<String> temp = ["1", "2" "3"];
//   late BuildContext context1;
//   bool visibility1 = true;
//   bool visibility2 = true;
//   bool visibility3 = false;
//   bool visibility4 = false;
//   ProgressDialog? pr;
//
//   void initState() {
//     super.initState();
//     //temp = ["1", "2" "3"];
//     // temp[0]="1";
//     // temp[1]="2";
//     // temp[2]="3";
//     if (this.mounted)
//       setState(() {
//         context1 = context;
//       });
//     pr = ProgressDialog(context1);
//     callWebService();
//   }
//
//   void callWebService() async {
//     String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
//         "," +
//         AapoortiUtilities.user!.S_TOKEN +
//         ",Flutter,0,0";
//     String inputParam2 = AapoortiUtilities.user!.MAP_ID +
//         "," +
//         AapoortiUtilities.user!.CUSTOM_WK_AREA;
//     jsonResult = await AapoortiUtilities.fetchPostPostLogin('Login/ClosedTenderList', 'ClosedTenderList', inputParam1, inputParam2, context);
//     debugPrint(" " + jsonResult!.length.toString());
//     debugPrint(jsonResult.toString());
//     if(jsonResult!.length == 0) {
//       //jsonResult = '' as List;
//       Navigator.pop(context);
//       Navigator.push(context, MaterialPageRoute(builder: (context) => NoData()));
//     }
//     else if (jsonResult![0]['ErrorCode'] == 3) {
//       jsonResult = null;
//       Navigator.pop(context);
//       Navigator.push(context, MaterialPageRoute(builder: (context) => NoResponse()));
//       //AapoortiUtilities.stopProgress(pr!);
//     }
//     if(this.mounted) setState(() {});
//     //AapoortiUtilities.stopProgress(pr!);
//   }
//
//   /* void fetchPost() async {
//     print('Fetching from service');
// //    var v = "https://ireps.gov.in/Aapoorti/ServiceCallLog/PendingBillList?PendingBillList="+ '{"param1":"87014271368745345742,921C6C01A29EDBBCE05340011E0A70C3,Android,0,0","param2":"1486485732,PT,"}';
//    // var v1='https://trial.ireps.gov.in/Aapoorti/ServiceCallLog/LiveTenderList?LiveTenderList={"param1":"61813473666154124344,921DB39C59F6F661E05340011E0AD822,Android,0,0","param2":"1486485732,PT,"}';
//
//     String inputParam1 = AapoortiUtilities.user.C_TOKEN + "," +AapoortiUtilities.user.S_TOKEN + ",Flutter,0,0";
//     String inputParam2 = AapoortiUtilities.user.MAP_ID + "," + AapoortiUtilities.user.CUSTOM_WK_AREA;
//
//     jsonResult = await AapoortiUtilities.fetchPostPostLogin('Log/LiveTenderList', 'LiveTenderList' ,inputParam1, inputParam2) ;
//    */ /* final response =   await http.post(v1,headers: {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     }, encoding: Encoding.getByName("utf-8"));
//     print('url formed $v1');
//     print('respnse is $response and');
//     jsonResult = json.decode(response.body);*/ /*
//
//     //Delete Data in DB before insert starts
// //    final rowsDeleted = await dbHelper.delete(rowCount);
// //    print('deleted $rowsDeleted row(s): row $rowCount');
//     //Delete Data in DB before insert ends
//
//
//     //DB Insertion starts
//     */ /* for(int index=0; index<jsonResult.length; index++) {
//         Map<String, dynamic> row = {
//           DatabaseHelper.Tbl9_Col1_SrNo: index.toString(),
//           DatabaseHelper.Tbl9_Col2_RlyDept: jsonResult[index]['RLY_DEPT'],
//           DatabaseHelper.Tbl9_Col3_tenderNo: jsonResult[index]['TENDER_NUMBER'],
//           DatabaseHelper.Tbl9_Col4_tendertitle: jsonResult[index]['TENDER_TITLE'],
//           DatabaseHelper.Tbl9_Col5_workArea: jsonResult[index]['WORK_AREA'],
//           DatabaseHelper.Tbl9_Col6_StrtDate: jsonResult[index]['RA_START_DT'],
//           DatabaseHelper.Tbl9_Col7_EnDDate: jsonResult[index]['RA_CLOSE_DT'],
//           DatabaseHelper.Tbl9_Col8_NitPdfUrl: jsonResult[index]['NIT_PDF_URL'],
//           DatabaseHelper.Tbl9_Col9_StatusRA: jsonResult[index]['STATUS'],
//           DatabaseHelper.Tbl9_Col10_DocsRA: jsonResult[index]['ATTACH_DOCS'],
//           DatabaseHelper.Tbl9_Col11_CorrigendumRA: jsonResult[index]['CORRI_DETAILS'],
//         };96
//         final id = dbHelper.insert(row);
//         print('inserted row id: ' + index.toString());
//       }
//       //DB Insertion ends
//
// */ /*
//
//     setState(() {
//
//     });
//
//   }*/
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         key: _scaffoldKey,
//         resizeToAvoidBottomInset: false,
//         //resizeToAvoidBottomPadding: true,
//         appBar: AppBar(
//           backgroundColor: Colors.blue.shade800,
//           iconTheme: IconThemeData(color: Colors.white),
//           title:
//               Text('My Closed Tenders', style: TextStyle(color: Colors.white)),
//         ),
//         drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
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
//                   InkWell(
//                     child: Text(
//                       "Work Area: " + workarea(),
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//                 child: Expanded(
//                     child: jsonResult == null || jsonResult!.isEmpty
//                         ? SpinKitFadingCircle(color: Colors.teal, size: 120.0)
//                         : _myListView(context)))
//           ],
//         ),
//       ),
//     );
//   }
//
//   String workarea() {
//     if(AapoortiUtilities.user!.CUSTOM_WK_AREA == 'PT') {
//       worka = "Goods and Services";
//     } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == 'WT') {
//       worka = "Works";
//     } else if (AapoortiUtilities.user!.CUSTOM_WK_AREA == 'LT') {
//       worka = "Earning/Leasing";
//     }
//     return worka;
//   }
//
//   Widget _myListView(BuildContext context) {
//     //Dismiss spinner
//     SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
//     return ListView.separated(
//         itemCount: jsonResult != null ? jsonResult!.length : 0,
//         itemBuilder: (context, index) {
//           print((jsonResult![index]['TENDER_STATUS'].toString() == "3"));
//           print(jsonResult![index]['TENDER_STATUS']);
//           if (jsonResult![index]['TENDER_STATUS'].toString() == "0" ||
//               jsonResult![index]['TENDER_STATUS'].toString() == "6" ||
//               jsonResult![index]['TENDER_STATUS'].toString() == "7") {
//             visibility1 = false;
//             visibility2 = false;
//             visibility3 = false;
//             visibility4 = false;
//           } else if (jsonResult![index]['TENDER_STATUS'].toString() == "2" ||
//               jsonResult![index]['TENDER_STATUS'].toString() == "4") {
//             visibility1 = true;
//             visibility2 = true;
//             visibility3 = true;
//             visibility4 = true;
//           } else if (jsonResult![index]['TENDER_STATUS'].toString() == "1" ||
//               jsonResult![index]['TENDER_STATUS'].toString() == "5") {
//             visibility1 = true;
//             visibility2 = false;
//             visibility3 = false;
//             visibility4 = false;
//           } else if (jsonResult![index]['TENDER_STATUS'].toString() == "3" ||
//               jsonResult![index]['TENDER_STATUS'].toString() == "8") {
//             visibility1 = true;
//             visibility2 = false;
//             visibility3 = true;
//             visibility4 = true;
//           }
//
//           return Container(
//               padding: EdgeInsets.all(10),
//               child: Card(
//                 elevation: 4,
//                 surfaceTintColor: Colors.white,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5),
//                   side: BorderSide(width: 1, color: Colors.grey[300]!),
//                 ),
//                 child: Column(children: <Widget>[
//                   Padding(padding: EdgeInsets.only(top: 8)),
//                   Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         new Padding(padding: new EdgeInsets.all(3.0)),
//                         Text(
//                           (index + 1).toString() + ". ",
//                           style: TextStyle(color: Colors.teal, fontSize: 16),
//                         ),
//                         Expanded(
//                           child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Row(children: <Widget>[
//                                   Expanded(
//                                     child: Text(
//                                       jsonResult![index]['RAILWAY_ZONE'] != null
//                                           ? jsonResult![index]['RAILWAY_ZONE'] +
//                                               "/" +
//                                               jsonResult![index]['DEPARTMENT']
//                                           : "",
//                                       style: TextStyle(
//                                           color: Colors.teal,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16),
//                                     ),
//                                   )
//                                 ]),
//                                 Padding(
//                                   padding: EdgeInsets.all(5),
//                                 ),
//                                 Row(
//                                     mainAxisSize: MainAxisSize.max,
//                                     children: <Widget>[
//                                       Container(
//                                         height: 30,
//                                         width: 125,
//                                         child: Text(
//                                           "Date/Time",
//                                           style: TextStyle(
//                                               color: Colors.teal, fontSize: 16),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                           height: 30,
//                                           child: Text(
//                                             jsonResult![index][
//                                                         'TENDER_OPENING_DATE'] !=
//                                                     null
//                                                 ? jsonResult![index]
//                                                     ['TENDER_OPENING_DATE']
//                                                 : "",
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 16),
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ),
//                                     ]),
//                                 Row(children: <Widget>[
//                                   Container(
//                                     height: 30,
//                                     width: 125,
//                                     child: Text(
//                                       "Tender No.",
//                                       style: TextStyle(
//                                           color: Colors.teal, fontSize: 16),
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 30,
//                                     child: Text(
//                                       jsonResult![index]['TENDER_NUMBER'] !=
//                                               null
//                                           ? jsonResult![index]['TENDER_NUMBER']
//                                           : "",
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 16),
//                                     ),
//                                   )
//                                 ]),
//                                 Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       Container(
//                                         height: 30,
//                                         width: 125,
//                                         child: Text(
//                                           "WorkArea",
//                                           style: TextStyle(
//                                               color: Colors.teal, fontSize: 16),
//                                         ),
//                                       ),
//                                       Container(
//                                         height: 30,
//                                         child: Text(
//                                           jsonResult![index]['WORK_AREA'] !=
//                                                   null
//                                               ? jsonResult![index]['WORK_AREA']
//                                               : "",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 16),
//                                         ),
//                                       )
//                                     ]),
//                                 Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       Container(
//                                         height: 30,
//                                         width: 125,
//                                         child: Text(
//                                           "Tender Title",
//                                           style: TextStyle(
//                                               color: Colors.teal, fontSize: 16),
//                                         ),
//                                       ),
//                                       Expanded(
//                                           child: Container(
//                                         height: 50,
//                                         child: Text(
//                                           jsonResult![index]
//                                                       ['TENDER_DESCRIPTION'] !=
//                                                   null
//                                               ? jsonResult![index]
//                                                   ['TENDER_DESCRIPTION']
//                                               : "",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 16),
//                                         ),
//                                       )),
//                                     ]),
//                                 Row(children: <Widget>[
//                                   Container(
//                                     height: 30,
//                                     width: 125,
//                                     child: Text(
//                                       "Type",
//                                       style: TextStyle(
//                                           color: Colors.teal, fontSize: 16),
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 30,
//                                     child: Text(
//                                       jsonResult![index]['TYPE'] != null
//                                           ? jsonResult![index]['TYPE']
//                                           : "",
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 16),
//                                     ),
//                                   )
//                                 ]),
//                                 Row(children: <Widget>[
//                                   Padding(
//                                       padding: EdgeInsets.only(top: 15.0)),
//                                   Container(
//                                     height: 30,
//                                     width: 125,
//                                     child: Text(
//                                       "Links",
//                                       style: TextStyle(
//                                           color: Colors.teal, fontSize: 16),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: <Widget>[
//                                           Visibility(
//                                             child: GestureDetector(
//                                                 onTap: () {
//                                                   if (jsonResult![index][
//                                                           'SUMM_REPORT_LINK'] !=
//                                                       'NA') {
//                                                     name = "NIT";
//                                                     var fileUrl = jsonResult![
//                                                                 index]
//                                                             ['SUMM_REPORT_LINK']
//                                                         .toString();
//                                                     var fileName = fileUrl
//                                                         .substring(fileUrl
//                                                             .lastIndexOf("/"));
//                                                     AapoortiUtilities
//                                                         .openPdfSheet(
//                                                             context1,
//                                                             fileUrl,
//                                                             fileName,
//                                                             name);
//                                                   } else {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(SnackBar(
//                                                       content: Text(
//                                                           "No PDF attached with this tender!"),
//                                                       duration: const Duration(
//                                                           seconds: 1),
//                                                       backgroundColor:
//                                                           Colors.redAccent[100],
//                                                     ));
//                                                     // AapoortiUtilities.showInSnackBar(context,"No PDF attached with this Tender!!");
//                                                   }
//                                                 },
//                                                 child:
//                                                     Column(children: <Widget>[
//                                                   Container(
//                                                     child: Image(
//                                                         image: AssetImage(
//                                                             'images/pdf_home.png'),
//                                                         height: 30,
//                                                         width: 20),
//                                                   ),
//                                                   Padding(
//                                                       padding:
//                                                           EdgeInsets.all(0.0)),
//                                                   Container(
//                                                     child: Text('  NIT',
//                                                         style: TextStyle(
//                                                             color:
//                                                                 Colors.blueGrey,
//                                                             fontSize: 9),
//                                                         textAlign:
//                                                             TextAlign.center),
//                                                   ),
//                                                 ])),
//                                             maintainSize: false,
//                                             maintainAnimation: false,
//                                             maintainState: false,
//                                             visible: visibility1,
//                                           ),
//                                           if (visibility2)
//                                             Visibility(
//                                               child: GestureDetector(
//                                                   onTap: () {
//                                                     if(jsonResult![index]['TABULATION_LINK'] !='NA') {
//                                                       name = "FIN-TAB";
//                                                       var fileUrl = jsonResult![index]['TABULATION_LINK'].toString();
//                                                       var fileName = fileUrl
//                                                           .substring(fileUrl
//                                                               .lastIndexOf(
//                                                                   "/"));
//                                                       AapoortiUtilities
//                                                           .openPdfSheet(
//                                                               context1,
//                                                               fileUrl,
//                                                               fileName,
//                                                               name);
//                                                     } else {
//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .showSnackBar(
//                                                               SnackBar(
//                                                         content: Text(
//                                                             "No PDF attached with this tender!"),
//                                                         duration:
//                                                             const Duration(
//                                                                 seconds: 1),
//                                                         backgroundColor: Colors
//                                                             .redAccent[100],
//                                                       ));
//                                                       //AapoortiUtilities.showInSnackBar(context,"No PDF attached with this Tender!!");
//                                                     }
//                                                   },
//                                                   child:
//                                                       Column(children: <Widget>[
//                                                     Container(
//                                                       child: Image(
//                                                           image: AssetImage(
//                                                               'images/pdf_home.png'),
//                                                           height: 30,
//                                                           width: 20),
//                                                     ),
//                                                     Padding(
//                                                         padding: EdgeInsets.all(
//                                                             0.0)),
//                                                     Container(
//                                                       child: Text(
//                                                           '  FIN-TAB',
//                                                           style: TextStyle(
//                                                               color: Colors
//                                                                   .blueGrey,
//                                                               fontSize: 9),
//                                                           textAlign:
//                                                               TextAlign.center),
//                                                     ),
//                                                   ])),
//                                               maintainSize: false,
//                                               maintainAnimation: false,
//                                               maintainState: false,
//                                               visible: visibility2,
//                                             ),
//                                           Visibility(
//                                             child: GestureDetector(
//                                                 onTap: () {
//                                                   if (jsonResult![index]
//                                                           ['OFFER_LINK'] !=
//                                                       'NA') {
//                                                     name = "TECH-TAB";
//                                                     var fileUrl =
//                                                         jsonResult![index]
//                                                                 ['OFFER_LINK']
//                                                             .toString();
//                                                     var fileName = fileUrl
//                                                         .substring(fileUrl
//                                                             .lastIndexOf("/"));
//                                                     AapoortiUtilities
//                                                         .openPdfSheet(
//                                                             context1,
//                                                             fileUrl,
//                                                             fileName,
//                                                             name);
//                                                   } else {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(SnackBar(
//                                                       content: Text(
//                                                           "No PDF attached with this tender!"),
//                                                       duration: const Duration(
//                                                           seconds: 1),
//                                                       backgroundColor:
//                                                           Colors.redAccent[100],
//                                                     ));
//                                                     //AapoortiUtilities.showInSnackBar(context,"No PDF attached with this Tender!!");
//                                                   }
//                                                 },
//                                                 child:
//                                                     Column(children: <Widget>[
//                                                   Container(
//                                                     child: Image(
//                                                         image: AssetImage(
//                                                             'images/pdf_home.png'),
//                                                         height: 30,
//                                                         width: 20),
//                                                   ),
//                                                   Padding(
//                                                       padding:
//                                                           EdgeInsets.all(0.0)),
//                                                   Container(
//                                                     child: Text('  TECH-TAB',
//                                                         style: TextStyle(
//                                                             color:
//                                                                 Colors.blueGrey,
//                                                             fontSize: 9),
//                                                         textAlign:
//                                                             TextAlign.center),
//                                                   ),
//                                                 ])),
//                                             maintainSize: false,
//                                             maintainAnimation: false,
//                                             maintainState: false,
//                                             visible: visibility3,
//                                           ),
//                                           Visibility(
//                                             child: GestureDetector(
//                                                 onTap: () {
//                                                   if (jsonResult![index]
//                                                           ['URLOFFER'] !=
//                                                       'NA') {
//                                                     name = "OFFER";
//                                                     var fileUrl =
//                                                         jsonResult![index]
//                                                                 ['URLOFFER']
//                                                             .toString();
//                                                     var fileName = fileUrl
//                                                         .substring(fileUrl
//                                                             .lastIndexOf("/"));
//                                                     AapoortiUtilities
//                                                         .openPdfSheet(
//                                                             context1,
//                                                             fileUrl,
//                                                             fileName,
//                                                             name);
//                                                   } else {
//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(SnackBar(
//                                                       content: Text(
//                                                           "No PDF attached with this tender!"),
//                                                       duration: const Duration(
//                                                           seconds: 1),
//                                                       backgroundColor:
//                                                           Colors.redAccent[100],
//                                                     )); //AapoortiUtilities.showInSnackBar(context,"No PDF attached with this Tender!!");
//                                                   }
//                                                 },
//                                                 child:
//                                                     Column(children: <Widget>[
//                                                   Container(
//                                                     child: Image(
//                                                         image: AssetImage(
//                                                             'images/pdf_home.png'),
//                                                         height: 30,
//                                                         width: 20),
//                                                   ),
//                                                   new Padding(
//                                                       padding:
//                                                           EdgeInsets.all(0.0)),
//                                                   new Container(
//                                                     child: new Text('  OFFER',
//                                                         style: new TextStyle(
//                                                             color:
//                                                                 Colors.blueGrey,
//                                                             fontSize: 9),
//                                                         textAlign:
//                                                             TextAlign.center),
//                                                   ),
//                                                 ])),
//                                             maintainSize: false,
//                                             maintainAnimation: false,
//                                             maintainState: false,
//                                             visible: visibility4,
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(right: 0),
//                                           ),
//                                         ]),
//                                   ),
//                                 ]),
//                               ]),
//                         ),
//                       ])
//                 ]),
//               ));
//         },
//         separatorBuilder: (context, index) {
//           return Container();
//         });
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ClosedTender extends StatefulWidget {
  get path => null;
  @override
  _ClosedTenderState createState() => _ClosedTenderState();
}

class _ClosedTenderState extends State<ClosedTender> {
  List<dynamic>? jsonResult = null;
  final dbHelper = DatabaseHelper.instance;
  late BuildContext context1;
  bool visibility1 = true;
  bool visibility2 = true;
  bool visibility3 = false;
  bool visibility4 = false;

  void initState() {
    super.initState();
    if (this.mounted)
      setState(() {
        context1 = context;
      });
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
        "," +
        AapoortiUtilities.user!.S_TOKEN +
        ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID +
        "," +
        AapoortiUtilities.user!.CUSTOM_WK_AREA;
    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Login/ClosedTenderList', 'ClosedTenderList', inputParam1, inputParam2, context);

    if (jsonResult == null || jsonResult!.isEmpty) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoData()));
    }
    else if (jsonResult!.isNotEmpty && jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
    if (this.mounted) setState(() {});
  }

  String getWorkAreaName(String workArea) {
    if (workArea == 'PT') {
      return "Goods and Services";
    } else if (workArea == 'WT') {
      return "Works";
    } else if (workArea == 'LT') {
      return "Earning/Leasing";
    }
    return workArea;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
              'My Closed Tenders',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              )
          ),
        ),
        body: jsonResult == null || jsonResult!.isEmpty
            ? Center(
            child: SpinKitFadingCircle(
                color: Colors.blue[800],
                size: 50.0
            )
        )
            : _buildTenderList(),
      ),
    );
  }

  Widget _buildTenderList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        // Set visibility flags based on tender status
        _updateVisibilityFlags(index);
        return _buildTenderCard(index);
      },
    );
  }

  void _updateVisibilityFlags(int index) {
    String status = jsonResult![index]['TENDER_STATUS'].toString();

    if (status == "0" || status == "6" || status == "7") {
      visibility1 = false;
      visibility2 = false;
      visibility3 = false;
      visibility4 = false;
    } else if (status == "2" || status == "4") {
      visibility1 = true;
      visibility2 = true;
      visibility3 = true;
      visibility4 = true;
    } else if (status == "1" || status == "5") {
      visibility1 = true;
      visibility2 = false;
      visibility3 = false;
      visibility4 = false;
    } else if (status == "3" || status == "8") {
      visibility1 = true;
      visibility2 = false;
      visibility3 = true;
      visibility4 = true;
    }
  }

  Widget _buildTenderCard(int index) {
    // Get the department and railway zone data
    String departmentInfo = "";
    if (jsonResult![index]['RAILWAY_ZONE'] != null && jsonResult![index]['DEPARTMENT'] != null) {
      departmentInfo = "${jsonResult![index]['RAILWAY_ZONE']}/${jsonResult![index]['DEPARTMENT']}";
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with numerical indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue[400],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(

                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    departmentInfo.isNotEmpty ? departmentInfo : "IREPS-TESTING",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tender details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("RA Date", jsonResult![index]['TENDER_OPENING_DATE'] ?? ""),
                Divider(height: 16),
                _buildDetailRow("Tender No.", jsonResult![index]['TENDER_NUMBER'] ?? ""),
                Divider(height: 16),
                _buildDetailRow("WorkArea",
                    jsonResult![index]['WORK_AREA'] != null
                        ? jsonResult![index]['WORK_AREA']
                        : getWorkAreaName(AapoortiUtilities.user!.CUSTOM_WK_AREA)
                ),
                Divider(height: 16),
                _buildDetailRow("Tender Title", jsonResult![index]['TENDER_DESCRIPTION'] ?? ""),
                Divider(height: 16),
                _buildDetailRow("Type", jsonResult![index]['TYPE'] ?? ""),
              ],
            ),
          ),

          // Documents section - only show if at least one document is available
          if (visibility1 || visibility2 || visibility3 || visibility4)
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (visibility1 && jsonResult![index]['SUMM_REPORT_LINK'] != 'NA')
                      _buildDocumentButton("NIT", jsonResult![index]['SUMM_REPORT_LINK']),
                    if (visibility1 && jsonResult![index]['SUMM_REPORT_LINK'] != 'NA')
                      SizedBox(width: 12),
                    if (visibility2 && jsonResult![index]['TABULATION_LINK'] != 'NA')
                      _buildDocumentButton("FIN-TAB", jsonResult![index]['TABULATION_LINK']),
                    if (visibility2 && jsonResult![index]['TABULATION_LINK'] != 'NA')
                      SizedBox(width: 12),
                    if (visibility3 && jsonResult![index]['OFFER_LINK'] != 'NA')
                      _buildDocumentButton("TECH-TAB", jsonResult![index]['OFFER_LINK']),
                    if (visibility3 && jsonResult![index]['OFFER_LINK'] != 'NA')
                      SizedBox(width: 12),
                    if (visibility4 && jsonResult![index]['URLOFFER'] != 'NA')
                      _buildDocumentButton("OFFER", jsonResult![index]['URLOFFER']),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentButton(String docType, String fileUrl) {
    return InkWell(
      onTap: () {
        if (fileUrl != 'NA') {
          //var fileName = fileUrl.toString().substring(fileUrl.toString().lastIndexOf("/"));
          var fileName = fileUrl.split('/').last;
          AapoortiUtilities.pdfDialog(context1, fileUrl.toString(), fileName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("No PDF attached with this tender!"),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red[400],
          ));
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.red[700], size: 16),
            SizedBox(width: 6),
            Text(
              docType,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
