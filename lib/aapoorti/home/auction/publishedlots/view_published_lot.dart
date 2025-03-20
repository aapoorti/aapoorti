// import 'package:flutter/material.dart';
// class PublishedLot extends StatefulWidget {
//   const PublishedLot({super.key});
//
//   @override
//   State<PublishedLot> createState() => _PublishedLotState();
// }
//
// class _PublishedLotState extends State<PublishedLot> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

// import 'dart:convert';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
//
// import 'package:flutter_app/aapoorti/home/auction/publishedlots/vie_published_lot_details.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:lottie/lottie.dart';
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
//
// import 'dart:async';
//
// String pageNumber = "1";
//
// class PublishedLot extends StatefulWidget {
//   get path => null;
//
//   @override
//   _PublishedLotState createState() => _PublishedLotState();
// }
//
// class _PublishedLotState extends State<PublishedLot> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   List<dynamic>? jsonResult, jsonResult1, jsonResult2;
//   String _mySelection = "-1";
//   String _mySelection1 = "-1";
//   String _mySelection2 = "-1";
//   bool _isVisible = true;
//   ProgressDialog? pr;
//   List data2 = [];
//   List data3 = [];
//   List data1 = [];
//   List<json5> items = <json5>[];
//   String pgno = "1";
//   int? lotid, id;
//   int? total_records, no_pages;
//   int initalValueRange = 0;
//   int recordsPerPageCounter = 0;
//   int final_value = 0;
//   int? calculated_value;
//   int flag = 0;
//   int? initialValRange;
//   json5? j1;
//
//   int? finalwritevalue;
//   bool keyboardOpen = false, dateSelection = true;
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       fetchPost(pageNumber);
//     });
//   }
//
//   void fetchPost(String pageNumber) async {
//     try{
//     pgno = pageNumber;
//     var v = "https://www.ireps.gov.in/Aapoorti/ServiceCall/getData?input=AUCTION_PRELOGIN,VIEW_PUBLISHED_LOTS," +
//         _mySelection1.toString() + "," + _mySelection.toString() + "," +
//         _mySelection2.toString() + "," + pgno;
//
//     final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 50));
//     jsonResult = json.decode(response.body);
//
//     finalwritevalue = jsonResult![0][':B6'];
//     if (this.mounted)
//       setState(() {
//         if ((jsonResult != null) &
//         (!jsonResult.toString().contains('[{ErrorCode:'))) {
//           keyboardOpen = true;
//
//           finalwritevalue = jsonResult![0][':B6'];
//
//           initalValueRange = jsonResult![0]['SR'];
//
//           total_records = jsonResult![0][':B6'];
//           while (initalValueRange < total_records!) {
//             if (flag == 0) {
//               initialValRange = jsonResult![0]['SR'];
//               flag = 1;
//             }
//             initalValueRange++;
//             no_pages = jsonResult![0][':B7'];
//           }
//           if (pgno == 1.toString()) {
//             initialValRange = jsonResult![0]['SR'];
//             final_value = jsonResult!.length;
//           } else if (int.parse(pgno) < no_pages!) {
//             initialValRange = jsonResult![0]['SR'];
//             final_value = 250 + (250 * (int.parse(pgno) - 1));
//           } else {
//             initialValRange = jsonResult![0]['SR'];
//             final_value = total_records!;
//           }
//         } else {
//           if (!keyboardOpen) keyboardOpen = false;
//         }
//       });
//    }
//    on FormatException catch(ex){
//       AapoortiUtilities.showInSnackBar(context, "Something unexpected happend! please try again.");
//    }
//     on Exception catch(e){
//       AapoortiUtilities.showInSnackBar(context, "Something unexpected happend! please try again.");
//     }
//   }
//
//   void fetchPost1(String pageNumber) async {
//     try {
//       pgno = pageNumber;
//       var v = "https://www.ireps.gov.in/Aapoorti/ServiceCall/getData?input=AUCTION_PRELOGIN,VIEW_PUBLISHED_LOTS," +
//           _mySelection1.toString() + "," + _mySelection.toString() + "," +
//           _mySelection2.toString() + "," + pgno;
//
//       final response = await http.post(Uri.parse(v)).timeout(
//           Duration(seconds: 50));
//       jsonResult = json.decode(response.body);
//       finalwritevalue = jsonResult![0][':B6'];
//       _progressHide();
//       setState(() {
//         if (jsonResult != null) {
//           keyboardOpen = true;
//
//           finalwritevalue = jsonResult![0][':B6'];
//
//           initalValueRange = jsonResult![0]['SR'];
//
//           total_records = jsonResult![0][':B6'];
//           while (initalValueRange < total_records!) {
//             if (flag == 0) {
//               initialValRange = jsonResult![0]['SR'];
//               flag = 1;
//             }
//             initalValueRange++;
//             no_pages = jsonResult![0][':B7'];
//           }
//
//           if (pgno == 1.toString()) {
//             initialValRange = jsonResult![0]['SR'];
//             final_value = jsonResult!.length;
//           } else if (int.parse(pgno) < no_pages!) {
//             initialValRange = jsonResult![0]['SR'];
//             final_value = 250 + (250 * (int.parse(pgno) - 1));
//           } else {
//             initialValRange = jsonResult![0]['SR'];
//             final_value = total_records!;
//           }
//         } else {
//           if (!keyboardOpen) keyboardOpen = false;
//         }
//       });
//     }
//     on Exception catch(e){
//       AapoortiUtilities.showInSnackBar(context, "Something unexpected happend! please try again.");
//     }
//   }
//
//   Future<void> getData(Function setState) async {
//     try {
//       var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,RLY_UNITS_AUCTION';
//       final response1 = await http.post(Uri.parse(u)).timeout(Duration(seconds: 50));
//       jsonResult1 = json.decode(response1.body);
//       data1 = jsonResult1!;
//       setState(() {
//         data1 = jsonResult1!;
//       });
//     } catch (_) {}
//   }
//
//   void splitDate(Function setState) {
//     String? start_date;
//     String depot_id;
//     int index;
//     items.clear();
//     for (index = jsonResult2!.length - 1; index >= 0; index--) {
//       depot_id = jsonResult2![index]["DEPOT_ID"].toString();
//       if (depot_id == _mySelection) {
//         start_date = jsonResult2![index]["START_DATE"] ?? '';
//         if (start_date == "Select Start Date") {
//           start_date = null;
//         }
//         if (!["", null, false, 0].contains(start_date)) {
//           List<String> s = start_date!.split("#");
//           dateSelection = true;
//           for (int j = s.length - 1; j >= 0; j--) {
//             j1 = json5(
//               start_date: s[j].replaceFirst('_', ' '),
//               depot_id: s[j],
//             );
//             items.add(j1!);
//           }
//           break;
//         }
//       }
//     }
//
//     if (index == -1 && items.length == 0) {
//       dateSelection = false;
//       _mySelection2 = "-1";
//     }
//     items.add(json5(start_date: 'Select Date', depot_id: '-1'));
//   }
//
//   Future<void> getDatasecond(Function setState, String selectedValue1) async {
//
//     var u = AapoortiConstants.webServiceUrl + '/getData?input=AUCTION_PRELOGIN,DP_START_DATE,$selectedValue1';
//
//
//     _progressShow();
//     jsonResult2 = [];
//     final response1 = await http.post(Uri.parse(u)).timeout(Duration(seconds: 50));
//     setState(() {
//       data2.clear();
//       _mySelection = '-1';
//       _mySelection2 = '-1';
//       jsonResult2 = json.decode(response1.body);
//       data2 = jsonResult2!;
//       _progressHide();
//       data2 = jsonResult2!;
//       _mySelection1 = selectedValue1;
//     });
//   }
//
//   Future<void> getDatafirst(Function setState) async {
//     var u = AapoortiConstants.webServiceUrl + '/getData?input=AUCTION_PRELOGIN,DP_START_DATE,-1';
//
//     _progressShow();
//     jsonResult2 = [];
//     final response1 = await http.post(Uri.parse(u)).timeout(Duration(seconds: 50));
//     jsonResult2 = json.decode(response1.body);
//     data2 = jsonResult2!;
//
//     _progressHide();
//     setState(() {
//       data2 = jsonResult2!;
//     });
//   }
//
//   _progressShow() {
//     pr = ProgressDialog(
//       context,
//       type: ProgressDialogType.normal,
//       isDismissible: true,
//       showLogs: true,
//     );
//     pr!.show();
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
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//          Navigator.of(context, rootNavigator: true).pop();
//          return false;
//       },
//       child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           key: _scaffoldKey,
//           appBar: AppBar(
//             iconTheme: IconThemeData(color: Colors.white),
//             backgroundColor: AapoortiConstants.primary,
//             title: Text('Published Lots (Sale)', style: TextStyle(color: Colors.white, fontSize: 18)),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.tune),
//                 onPressed: _showFilterDialog,
//                 tooltip: 'Filter',
//               ),
//             ],
//           ),
//           body: Builder(
//             builder: (context) => Material(
//               child: jsonResult == null
//                   ? SpinKitFadingCircle(
//                       color: AapoortiConstants.primary,
//                       size: 120.0,
//                     )
//                   : Column(children: <Widget>[
//                       if(finalwritevalue != null && finalwritevalue! > 250)
//                         Container(
//                           color: Colors.cyan[50],
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: <Widget>[
//                               IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_back,
//                                     color: Colors.teal,
//                                   ),
//                                   onPressed: () {
//                                     paginationFirstClick();
//                                   }),
//                               IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_back_ios,
//                                     color: Colors.teal,
//                                   ),
//                                   onPressed: () {
//                                     paginationPrevClick();
//                                   }),
//                               IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_forward_ios,
//                                     color: Colors.teal,
//                                   ),
//                                   onPressed: () {
//                                     paginationNextClick();
//                                   }),
//                               IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_forward,
//                                     color: Colors.teal,
//                                   ),
//                                   onPressed: () {
//                                     paginationLastClick();
//                                   })
//                             ],
//                           ),
//                         ),
//                       Container(child: Expanded(child: _myListView(context)))
//                     ]),
//             ),
//           ),
//           floatingActionButton: Visibility(
//             visible: keyboardOpen,
//             child: FloatingActionButton(
//               onPressed: () {
//                 overlay_Dialog();
//               },
//               backgroundColor: AapoortiConstants.primary,
//               elevation: 12,
//               child: const Icon(
//                 Icons.filter_list,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           floatingActionButtonLocation: FloatingActionButtonLocation.endDocked),
//     );
//   }
//
//   Widget _myListView(BuildContext context) {
//     return (jsonResult == null || jsonResult![0]['ErrorCode'] == 3)
//         ? Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
//           AnimatedTextKit(
//               isRepeatingAnimation: false,
//               animatedTexts: [
//                 TyperAnimatedText("Data not found",
//                     speed: Duration(milliseconds: 150),
//                     textStyle:
//                     TextStyle(fontWeight: FontWeight.bold)),
//               ]
//           )
//         ],
//       ))
//         : ListView.separated(
//             itemCount: jsonResult != null ? jsonResult!.length : 0,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 child: Container(
//                   child: Column(
//                     children: <Widget>[
//                       Row(
//                         children: <Widget>[
//                           if(index == 0)
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               color: Colors.cyan[700],
//                               child: Text(
//                                 "            " +
//                                     initialValRange.toString() +
//                                     " - " +
//                                     final_value.toString() +
//                                     " of " +
//                                     total_records.toString() +
//                                     " Records                                  ",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             )
//                         ],
//                       ),
//                       Padding(padding: EdgeInsets.all(4.0)),
//                       Card(
//                           elevation: 4,
//                           color: Colors.white,
//                           surfaceTintColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                             side: BorderSide(width: 1, color: Colors.grey[300]!),
//                           ),
//                           child: Column(
//                             children: <Widget>[
//                               Padding(padding: EdgeInsets.only(top: 8)),
//                               Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Row(
//                                       children: <Widget>[
//                                         Padding(
//                                             padding: EdgeInsets.only(left: 8)),
//                                         Text(
//                                           jsonResult![index]['SR'] != null
//                                               ? (jsonResult![index]['SR'])
//                                                       .toString() +
//                                                   "  "
//                                               : "",
//                                           style: TextStyle(
//                                               color: Colors.indigo,
//                                               fontSize: 16),
//                                         ),
//                                       ],
//                                     ),
//                                     Expanded(
//                                         child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: <Widget>[
//                                           Row(children: <Widget>[
//                                             Container(
//                                               height: 30,
//                                               width: 125,
//                                               child: Text(
//                                                 "Railway",
//                                                 style: TextStyle(
//                                                     color: Colors.indigo,
//                                                     fontSize: 16),
//                                               ),
//                                             ),
//                                             Container(
//                                               height: 30,
//                                               child: Text(
//                                                 jsonResult![index]['RAILWAY_NAME'] != null ? jsonResult![index]['RAILWAY_NAME'] : "",
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 16),
//                                               ),
//                                             )
//                                           ]),
//                                           Padding(
//                                             padding: EdgeInsets.all(5),
//                                           ),
//                                           Row(children: <Widget>[
//                                             Container(
//                                               height: 30,
//                                               width: 125,
//                                               child: Text(
//                                                 "Depot Name",
//                                                 style: TextStyle(
//                                                     color: Colors.indigo,
//                                                     fontSize: 16),
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: Text(
//                                                 jsonResult![index]
//                                                             ['DEPOT_NAME'] !=
//                                                         null
//                                                     ? jsonResult![index]
//                                                         ['DEPOT_NAME']
//                                                     : "",
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 16),
//                                               ),
//                                             )
//                                           ]),
//                                           Row(
//                                               mainAxisSize: MainAxisSize.max,
//                                               children: <Widget>[
//                                                 Container(
//                                                   height: 30,
//                                                   width: 125,
//                                                   child: Text(
//                                                     "Lot No",
//                                                     style: TextStyle(
//                                                         color: Colors.indigo,
//                                                         fontSize: 16),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Container(
//                                                     height: 30,
//                                                     child: Text(
//                                                       jsonResult![index]
//                                                                   ['LOT_NO'] !=
//                                                               null
//                                                           ? jsonResult![index]
//                                                               ['LOT_NO']
//                                                           : "",
//                                                       style: TextStyle(
//                                                           color: Colors.black,
//                                                           fontSize: 16),
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ]),
//                                           Row(children: <Widget>[
//                                             Container(
//                                               height: 30,
//                                               width: 125,
//                                               child: Text(
//                                                 "Category",
//                                                 style: TextStyle(
//                                                     color: Colors.indigo,
//                                                     fontSize: 16),
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: Text(
//                                                 jsonResult![index]
//                                                             ['CATEGORY_NAME'] !=
//                                                         null
//                                                     ? jsonResult![index]
//                                                         ['CATEGORY_NAME']
//                                                     : "",
//                                                 maxLines: 4,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 16),
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             )
//                                           ]),
//                                           Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: <Widget>[
//                                                 Container(
//                                                   height: 30,
//                                                   width: 125,
//                                                   child: Text(
//                                                     "Min Incr",
//                                                     style: TextStyle(
//                                                         color: Colors.indigo,
//                                                         fontSize: 16),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   height: 30,
//                                                   child: Text(
//                                                     jsonResult![index][
//                                                                 'MIN_INCR_AMT'] !=
//                                                             null
//                                                         ? (jsonResult![index][
//                                                                 'MIN_INCR_AMT'])
//                                                             .toString()
//                                                         : "",
//                                                     style: TextStyle(
//                                                         color: Colors.green,
//                                                         fontSize: 16),
//                                                   ),
//                                                 )
//                                               ]),
//                                           Row(children: <Widget>[
//                                             Container(
//                                               height: 30,
//                                               width: 125,
//                                               child: Text(
//                                                 "Lot Published",
//                                                 style: TextStyle(
//                                                     color: Colors.indigo,
//                                                     fontSize: 16),
//                                               ),
//                                             ),
//                                             Container(
//                                               height: 30,
//                                               child: Text(
//                                                 jsonResult![index][
//                                                             'LOT_PUBLISH_DATE'] !=
//                                                         null
//                                                     ? jsonResult![index]
//                                                         ['LOT_PUBLISH_DATE']
//                                                     : "",
//                                                 style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 16),
//                                               ),
//                                             )
//                                           ]),
//                                           Row(children: <Widget>[
//                                             Container(
//                                               height: 30,
//                                               width: 125,
//                                               child: Text(
//                                                 "Material Desc",
//                                                 style: TextStyle(
//                                                   color: Colors.indigo,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                             ),
//                                           ]),
//                                           Row(children: <Widget>[
//                                             Expanded(
//                                                 child: Container(
//                                               height: 55,
//                                               child: Text(
//                                                 jsonResult![index][
//                                                             'LOT_MATERIAL_DESC'] !=
//                                                         null
//                                                     ? jsonResult![index]
//                                                         ['LOT_MATERIAL_DESC']
//                                                     : "",
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 16),
//                                               ),
//                                             ))
//                                           ]),
//                                         ]))
//                                   ]),
//                             ],
//                           ))
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   _isVisible = false;
//                   lotid = jsonResult![index]['LOT_ID'];
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               PublishedLotDetails(id: lotid)));
//
//                 },
//               );
//             },
//             separatorBuilder: (context, index) {
//               return Container();
//             });
//   }
//
//   void paginationFirstClick() {
//     if (pageNumber == 1.toString()) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("You are on the first page!"),
//         duration: const Duration(seconds: 1),
//         backgroundColor: Colors.redAccent[100],
//       ));
//     } else {
//       _progressShow();
//       pageNumber = "1";
//       fetchPost1(pageNumber);
//     }
//   }
//
//   void paginationPrevClick() {
//     if (pageNumber == 1.toString()) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("You are on the first page!"),
//         duration: const Duration(seconds: 1),
//         backgroundColor: Colors.redAccent[100],
//       ));
//
//     } else {
//       _progressShow();
//       int counter = int.parse(pageNumber);
//       counter += -1;
//       pageNumber = counter.toString();
//
//       fetchPost1(pageNumber);
//     }
//   }
//
//   void paginationNextClick() {
//     if (pageNumber == no_pages.toString()) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("You are on the last page!"),
//         duration: const Duration(seconds: 1),
//         backgroundColor: Colors.redAccent[100],
//       ));
//     } else {
//       _progressShow();
//       int counter = int.parse(pageNumber);
//       counter += 1;
//       pageNumber = counter.toString();
//
//       fetchPost1(pageNumber);
//     }
//   }
//
//   void paginationLastClick() {
//     if (pageNumber == no_pages.toString()) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("You are on the last page!"),
//         duration: const Duration(seconds: 1),
//         backgroundColor: Colors.redAccent[100],
//       ));
//
//     } else {
//       _progressShow();
//       pageNumber = no_pages.toString();
//       fetchPost1(pageNumber);
//     }
//   }
//
//   overlay_Dialog() async {
//     await getData(setState);
//     return showDialog(
//         context: context,
//         builder: (context) {
//           String contentText = "Content of Dialog";
//           print(contentText);
//           return StatefulBuilder(
//             builder: (context, setState) {
//               return Material(
//                 type: MaterialType.transparency,
//                 child: Container(
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                           height: 300,
//                           width: 600,
//                           margin: EdgeInsets.only(
//                               top: 200, bottom: 50, left: 30, right: 30),
//                           padding: EdgeInsets.only(
//                               top: 30, bottom: 0, left: 30, right: 30),
//                           color: Colors.white,
//                           // Aligns the container to center
//                           child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: <Widget>[
//                                 Container(
//                                     padding: EdgeInsets.only(top: 3, bottom: 5),
//                                     child: Row(
//                                       children: <Widget>[
//                                         Icon(
//                                           Icons.train,
//                                           color: Colors.black,
//                                         ),
//                                         SizedBox(width: 5),
//                                         Expanded(
//                                           child: DropdownButton(
//                                             isExpanded: true,
//                                             hint: Text(
//                                                 '     Select Organization       '),
//                                             items: data1.map((item) {
//                                               return DropdownMenuItem(
//                                                   child: Text(
//                                                     item['NAME'],
//                                                     style:
//                                                         TextStyle(fontSize: 12),
//                                                     overflow: TextOverflow.clip,
//                                                   ),
//                                                   value: item['ID'].toString());
//                                             }).toList(),
//                                             onChanged: (newVal1) {
//                                               getDatasecond(setState, newVal1 as String);
//                                             },
//                                             value: _mySelection1,
//                                           ),
//                                         ),
//                                       ],
//                                     )),
//                                 Expanded(
//                                   child: Container(
//                                       child: Row(
//                                     children: <Widget>[
//                                       Image.asset(
//                                         'images/depot.png',
//                                         width: 20,
//                                         height: 20,
//                                       ),
//                                       SizedBox(width: 5),
//                                       Expanded(
//                                         child: DropdownButton(
//                                           isExpanded: true,
//                                           hint: Text(
//                                               '     Select Depot Name       '),
//                                           items: data2.map((item) {
//                                             return DropdownMenuItem(
//                                               child: Text(
//                                                 item['DEPOT_NAME'].toString(),
//                                                 style: TextStyle(fontSize: 12),
//                                               ),
//                                               value:
//                                                   item['DEPOT_ID'].toString(),
//                                             );
//                                           }).toList(),
//                                           onChanged: (newVal) {
//                                             // Navigator.of(context).pop();
//                                             setState(() {
//                                               _mySelection = newVal as String;
//                                               _mySelection2 = '-1';
//                                               items.clear();
//
//                                               splitDate(setState);
//                                             });
//                                           },
//                                           value: _mySelection,
//                                         ),
//                                       ),
//                                     ],
//                                   )),
//                                 ),
//                                 (dateSelection)
//                                     ? Expanded(
//                                         child: Container(
//                                             child: Row(
//                                           children: <Widget>[
//                                             Icon(
//                                               Icons.calendar_today,
//                                               color: Colors.black,
//                                             ),
//                                             Expanded(
//                                               child: DropdownButton(
//                                                 isExpanded: true,
//                                                 hint: Text(
//                                                     '     Select Date                '),
//                                                 items: items.map((item) {
//                                                   return DropdownMenuItem(
//                                                       child: Text(
//                                                         item.start_date
//                                                                 .toString() +
//                                                             "                      ",
//                                                         style: TextStyle(
//                                                             fontSize: 12),
//                                                       ),
//                                                       value: item.depot_id
//                                                           .toString());
//                                                 }).toList(),
//                                                 onChanged: (newVal1) {
//                                                   setState(() {
//                                                     _mySelection2 = newVal1 as String;
//                                                     debugPrint("my selection first2" + _mySelection2);
//                                                   });
//                                                 },
//                                                 value: _mySelection2,
//                                               ),
//                                             ),
//                                           ],
//                                         )),
//                                       )
//                                     : Expanded(child: Container()),
//                                 Container(
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: <Widget>[
//                                       MaterialButton(
//                                           height: 40,
//                                           padding: EdgeInsets.fromLTRB(
//                                               25.0, 5.0, 25.0, 5.0),
//                                           // padding: const EdgeInsets.only(left:110.0,right:110.0),
//                                           child: Text(
//                                             'Apply',
//                                             textAlign: TextAlign.center,
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                           onPressed: () {
//                                             fetchPost(pageNumber);
//                                             //  keyboardOpen = true;
//                                             Navigator.of(context,
//                                                     rootNavigator: true)
//                                                 .pop('dialog');
//                                           },
//                                           color: Colors.black26),
//                                     ],
//                                   ),
//                                 ),
//                               ])),
//                       Container(
//                         child: Align(
//                           alignment: Alignment.bottomCenter,
//                           child: GestureDetector(
//                               onTap: () {
//                                 Navigator.of(context, rootNavigator: true)
//                                     .pop('dialog');
//                               },
//                               child: Image(
//                                 image: AssetImage('assets/close_overlay.png'),
//                                 color: Colors.white,
//                                 height: 50,
//                               )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }
//
//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String tempRailway = _selectedRailway;
//         String tempDepot = _selectedDepot;
//         String tempDate = _selectedDate;
//
//         return StatefulBuilder(
//           builder: (context, dialogSetState) {
//             final uniqueRailways = _allScrapLots
//                 .map((lot) => lot.railway)
//                 .toSet()
//                 .toList()
//               ..sort()
//               ..insert(0, 'All');
//
//             final depotOptions = tempRailway == 'All'
//                 ? _allScrapLots.map((lot) => lot.depotName).toSet().toList()
//                 : _allScrapLots
//                 .where((lot) => lot.railway == tempRailway)
//                 .map((lot) => lot.depotName)
//                 .toSet()
//                 .toList()
//               ..sort()
//               ..insert(0, 'All');
//
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.filter_list, color: Colors.blue[800], size: 20),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Advanced Filters',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue[800],
//                               ),
//                             ),
//                           ],
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close, color: Colors.blue[800], size: 20),
//                           onPressed: () => Navigator.of(context).pop(),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     DropdownButtonFormField<String>(
//                       value: tempRailway,
//                       decoration: InputDecoration(
//                         labelText: 'Railway',
//                         prefixIcon: Icon(Icons.train, color: Colors.blue[800], size: 18),
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                       ),
//                       items: uniqueRailways.map((railway) => DropdownMenuItem(
//                         value: railway,
//                         child: Text(railway, overflow: TextOverflow.ellipsis),
//                       )).toList(),
//                       onChanged: (value) {
//                         dialogSetState(() {
//                           tempRailway = value ?? 'All';
//                           tempDepot = 'All';
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 8),
//                     DropdownButtonFormField<String>(
//                       value: tempDepot,
//                       decoration: InputDecoration(
//                         labelText: 'Depot',
//                         prefixIcon: Icon(Icons.warehouse, color: Colors.blue[800], size: 18),
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                       ),
//                       items: depotOptions.map((depot) => DropdownMenuItem(
//                         value: depot,
//                         child: Text(depot, overflow: TextOverflow.ellipsis),
//                       )).toList(),
//                       onChanged: tempRailway == 'All'
//                           ? null
//                           : (value) {
//                         dialogSetState(() {
//                           tempDepot = value ?? 'All';
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'Date',
//                         prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[800], size: 18),
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                       ),
//                       controller: TextEditingController(text: tempDate),
//                       readOnly: true,
//                       onTap: () async {
//                         final DateTime? picked = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2020),
//                           lastDate: DateTime(2026),
//                         );
//                         if (picked != null) {
//                           final formattedDate =
//                               "${picked.day.toString().padLeft(2, '0')}-"
//                               "${picked.month.toString().padLeft(2, '0')}-"
//                               "${picked.year}";
//                           dialogSetState(() {
//                             tempDate = formattedDate;
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 15),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           TextButton(
//                             style: TextButton.styleFrom(
//                               side: BorderSide(color: Colors.blue[800]!, width: 1),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             onPressed: () {
//                               dialogSetState(() {
//                                 tempRailway = 'All';
//                                 tempDepot = 'All';
//                                 tempDate = '';
//                               });
//                             },
//                             child: Text('Reset', style: TextStyle(color: Colors.blue[800])),
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue[800],
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 //_selectedRailway = tempRailway;
//                                 //_selectedDepot = tempDepot;
//                                 //_selectedDate = tempDate;
//                                 //_currentPage = 0;
//                               });
//                               Navigator.of(context).pop();
//                             },
//                             child: const Text('Apply'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// class json5 {
//   String? start_date;
//   String? depot_id;
//   json5({this.start_date, this.depot_id});
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/auction/publishedlots/vie_published_lot_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PublishedLot extends StatefulWidget {
  const PublishedLot({Key? key}) : super(key: key);

  @override
  _PublishedLotState createState() => _PublishedLotState();
}

class _PublishedLotState extends State<PublishedLot> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult;
  List<dynamic>? railwaysList;
  List<dynamic> depotsList = [];

  // Pagination variables
  String currentPage = "1";
  int? totalPages;
  int? totalRecords;
  bool isLoading = true;
  bool depotloding = false;

  // Filter values
  String selectedRailway = "All";
  String selectedDepot = "All";
  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    fetchPublishedLots();
    fetchRailwaysList();
  }

  Future<void> fetchPublishedLots({String? page, Map<String, String>? filters}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final pageNumber = page ?? currentPage;

      // Base URL
      var url = "https://www.ireps.gov.in/Aapoorti/ServiceCall/getData?input=AUCTION_PRELOGIN,VIEW_PUBLISHED_LOTS";

      // Add filters if provided
      final railwayFilter = filters != null ? filters['railway'] ?? selectedRailway : selectedRailway;
      final depotFilter = filters != null ? filters['depot'] ?? selectedDepot : selectedDepot;
      final dateFilter = filters != null ? filters['date'] ?? selectedDate : selectedDate;

      // Add filters to URL if they're not "All"
      if (railwayFilter != "All") {
        url += ",$railwayFilter";
      } else {
        url += ",-1";
      }

      if (depotFilter != "All") {
        url += ",$depotFilter";
      } else {
        url += ",-1";
      }

      if (dateFilter.isNotEmpty) {
        url += ",$dateFilter";
      } else {
        url += ",-1";
      }

      // Add page number
      url += ",$pageNumber";

      final response = await http.post(Uri.parse(url)).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        setState(() {
          jsonResult = result;
          currentPage = pageNumber;

          // Extract pagination info if available
          if (result.isNotEmpty) {
            totalRecords = result[0][':B6'];
            totalPages = result[0][':B7'];
          }

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load published lots');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      AapoortiUtilities.showInSnackBar(context, "Something unexpected happened! Please try again.");
    }
  }

  Future<void> fetchRailwaysList() async {
    try {
      final url = "${AapoortiConstants.webServiceUrl}/getData?input=SPINNERS,RLY_UNITS_AUCTION";
      final response = await http.post(Uri.parse(url)).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        setState(() {
          railwaysList = json.decode(response.body);
        });
      }
    } catch (e) {
      AapoortiUtilities.showInSnackBar(context, "Failed to load railways list. Please try again.");
    }
  }

  Future<void> fetchDepotsList(String railwayId) async {
    debugPrint("calling depot $railwayId");
    try {
      final url = "${AapoortiConstants.webServiceUrl}/getData?input=AUCTION_PRELOGIN,DP_START_DATE,$railwayId";
      final response = await http.post(Uri.parse(url)).timeout(const Duration(seconds: 30));

      if(response.statusCode == 200) {
        setState(() {
          depotsList.clear();
          depotsList = json.decode(response.body);
          selectedDepot = "All"; // Reset depot selection when railway changes
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      AapoortiUtilities.showInSnackBar(context, "Failed to load depots list. Please try again. $e");
    }
  }

  void showAdvancedFilters(BuildContext context) {
    String tempRailway = selectedRailway;
    String tempDepot = selectedDepot;
    String tempDate = selectedDate;
    depotsList.clear();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing while loading
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                children: [
                  // Main Dialog Content
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AbsorbPointer( // Prevents interactions while loading
                      absorbing: isLoading,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // **Header with Close Button**
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.filter_list, color: Colors.blue[800], size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Advanced Filters',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.blue[800], size: 20),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // **Railway Dropdown**
                          DropdownButtonFormField<String>(
                            value: tempRailway,
                            decoration: InputDecoration(
                              labelText: 'Railway',
                              prefixIcon: Icon(Icons.train, color: Colors.blue[800], size: 18),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            ),
                            items: [
                              const DropdownMenuItem(value: "All", child: Text("All")),
                              if (railwaysList != null)
                                ...railwaysList!
                                    .where((railway) => railway['NAME'].toString().toLowerCase() != "all")
                                    .map((railway) => DropdownMenuItem(
                                  value: railway['ID'].toString(),
                                  child: Text(railway['NAME'], overflow: TextOverflow.ellipsis),
                                ))
                                    .toList(),
                            ],
                            onChanged: (value) {
                              setDialogState(() {
                                tempRailway = value ?? 'All';
                                tempDepot = 'All';
                                depotloding = true; // Show loading indicator
                              });

                              fetchDepotsList(value!).then((_) {
                                setDialogState(() {
                                  depotloding = false; // Hide loading indicator
                                });
                              });
                            },
                          ),

                          const SizedBox(height: 8),

                          // **Depot Dropdown**
                          DropdownButtonFormField<String>(
                            value: tempDepot,
                            decoration: InputDecoration(
                              labelText: 'Depot',
                              prefixIcon: Icon(Icons.warehouse, color: Colors.blue[800], size: 18),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            ),
                            items: [
                              const DropdownMenuItem(value: "All", child: Text("All")),
                              if(depotsList.isNotEmpty)
                                ...depotsList.where((depot) => depot['DEPOT_NAME'].toString().toLowerCase() != "all")
                                    .map((depot) => DropdownMenuItem(
                                  value: depot['DEPOT_ID'].toString(),
                                  child: Text(depot['DEPOT_NAME'], overflow: TextOverflow.ellipsis),
                                ))
                                    .toList(),
                            ],
                            onChanged: (value) {
                              setDialogState(() {
                                tempDepot = value ?? 'All';
                              });
                            },
                          ),

                          const SizedBox(height: 8),

                          // **Date Picker**
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[800], size: 18),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            ),
                            controller: TextEditingController(text: tempDate),
                            readOnly: true,
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2026),
                              );
                              if (picked != null) {
                                final formattedDate =
                                    "${picked.day.toString().padLeft(2, '0')}-"
                                    "${picked.month.toString().padLeft(2, '0')}-"
                                    "${picked.year}";
                                setDialogState(() {
                                  tempDate = formattedDate;
                                });
                              }
                            },
                          ),

                          const SizedBox(height: 15),

                          // **Buttons**
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    side: BorderSide(color: Colors.blue[800]!, width: 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    setDialogState(() {
                                      tempRailway = 'All';
                                      tempDepot = 'All';
                                      tempDate = '';
                                    });
                                  },
                                  child: Text('Reset', style: TextStyle(color: Colors.blue[800])),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[800],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    fetchPublishedLots(filters: {
                                      'railway': tempRailway,
                                      'depot': tempDepot,
                                      'date': tempDate,
                                    });
                                  },
                                  child: const Text('Apply'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // **Circular Progress Indicator (Overlay)**
                  if(depotloding)
                    Container(
                      //color: Colors.black.withOpacity(0.3), // Dim background
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.blue,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final startRecord = jsonResult != null && jsonResult!.isNotEmpty && totalRecords != null
        ? jsonResult![0]['SR']
        : 0;
    final endRecord = jsonResult != null && jsonResult!.isNotEmpty && totalRecords != null
        ? jsonResult![0]['SR'] + jsonResult!.length - 1
        : 0;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AapoortiConstants.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
          title: const Text(
              'Published Lots (Sale)',
              style: TextStyle(color: Colors.white, fontSize: 18)
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: (){showAdvancedFilters(context);},
              tooltip: 'Filter',
            ),
          ],
        ),
        body: isLoading ? Center(
          child: SpinKitFadingCircle(
            color: AapoortiConstants.primary,
            size: 120.0,
          ),
        ) : Column(
          children: [
            // Pagination controls and record counter
            if (jsonResult != null && totalPages != null && totalPages! > 1)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                color: Colors.blue.shade50,
                child: Row(
                  children: [
                    // Pagination controls
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.first_page, size: 20),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                          onPressed: int.parse(currentPage) > 1
                              ? () => fetchPublishedLots(page: "1")
                              : null,
                          color: Colors.blue.shade800,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 20),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                          onPressed: int.parse(currentPage) > 1
                              ? () => fetchPublishedLots(page: (int.parse(currentPage) - 1).toString())
                              : null,
                          color: Colors.blue.shade800,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, size: 20),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                          onPressed: int.parse(currentPage) < totalPages!
                              ? () => fetchPublishedLots(page: (int.parse(currentPage) + 1).toString())
                              : null,
                          color: Colors.blue.shade800,
                        ),
                        IconButton(
                          icon: const Icon(Icons.last_page, size: 20),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                          onPressed: int.parse(currentPage) < totalPages!
                              ? () => fetchPublishedLots(page: totalPages.toString())
                              : null,
                          color: Colors.blue.shade800,
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Record counter
                    if (jsonResult != null && totalRecords != null)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          totalRecords == 0
                              ? '0 Records'
                              : '$startRecord-$endRecord of $totalRecords',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            // Lot listings
            Expanded(
              child: jsonResult == null || jsonResult!.isEmpty ? const Center(
                child: Text(
                  'No Published Lots Found',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ) : ListView.builder(
                itemCount: jsonResult!.length,
                itemBuilder: (context, index) => _buildLotCard(jsonResult![index], index + 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLotCard(dynamic lot, int indexNumber) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          final lotId = lot['LOT_ID'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PublishedLotDetails(id: lotId),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with index and railway
              Row(
                children: [
                  Text(
                    "$indexNumber. ${lot['RAILWAY_NAME'] ?? ''}",
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, height: 16),

              // Details rows with consistent styling
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Depot", lot['DEPOT_NAME'] ?? ''),
                  const SizedBox(height: 4),
                  _buildInfoRow("Lot No", lot['LOT_NO'] ?? ''),
                  const SizedBox(height: 4),
                  _buildInfoRow("Category", lot['CATEGORY_NAME'] ?? ''),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    "Min Incr",
                    "₹${lot['MIN_INCR_AMT']?.toString() ?? ''}",
                    valueColor: Colors.green.shade700,
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    "Published",
                    lot['LOT_PUBLISH_DATE'] ?? '',
                    dateColor: Colors.indigo.shade600,
                    timeColor: Colors.indigo.shade600,
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    "Material",
                    lot['LOT_MATERIAL_DESC'] ?? '',
                    isMaterial: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {Color? valueColor, Color? dateColor, Color? timeColor, bool isMaterial = false}) {

    // Split date and time for different colors if applicable
    List<String> dateTimeParts = label == 'Published' && value.contains(' ')
        ? value.split(' ')
        : [value];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Fixed-width label container
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
        // Content with appropriate styling
        Expanded(
          child: label == 'Published' && dateTimeParts.length > 1
              ? RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: dateTimeParts[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: dateColor ?? Colors.black,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: ' ${dateTimeParts[1]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: timeColor ?? Colors.black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
              : Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
              fontSize: 13,
            ),
            overflow: isMaterial ? TextOverflow.ellipsis : TextOverflow.visible,
            maxLines: isMaterial ? 2 : 1,
          ),
        ),
      ],
    );
  }
}
