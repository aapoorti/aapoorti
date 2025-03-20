// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
// import 'package:flutter_app/aapoorti/common/NoData.dart';
// import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
// import 'package:flutter_app/aapoorti/common/NoResponse.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// import 'PendingBillsDetails.dart';
//
// class PendingBill extends StatefulWidget {
//   get path => null;
//
//   @override
//   _PendingBillState createState() => _PendingBillState();
// }
//
// class _PendingBillState extends State<PendingBill> {
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   List<dynamic>? jsonResult;
//   final dbHelper = DatabaseHelper.instance;
//   var rowCount=-1;
//
//   void initState() {
//     super.initState();
//     callWebService();
//   }
//
//   void callWebService() async {
//     String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
//     String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA;
//     jsonResult = await AapoortiUtilities.fetchPostPostLogin('Login/PendingBillList', 'PendingBillList' ,inputParam1, inputParam2, context) ;
//     if(jsonResult!.length==0)    {
//       jsonResult=null;
//       Navigator.pop(context);
//       Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
//     }    else if(jsonResult![0]['ErrorCode']==3)    {
//       jsonResult=null;
//       Navigator.pop(context);
//       Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
//     }
//     setState(() {
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  WillPopScope(
//       onWillPop: () async {
//         return true;
//         // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHome('','')));
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         key: _scaffoldKey,
//         appBar: AppBar(
//           iconTheme: new IconThemeData(color: Colors.white),
//           backgroundColor: Colors.teal,
//           title: Text('Pending Bills',
//               style:TextStyle(
//                   color: Colors.white
//               )
//           ),
//         ),
//        drawer :AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
//         body: Center(
//             child: jsonResult == null  ?
//             SpinKitFadingCircle(color: Colors.teal, size: 120.0,)
//                 :_myListView(context)
//         ),
//       ),
//     );
//   }
//
//
//   Widget _myListView(BuildContext context) {
//     //Dismiss spinner
//     SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
//     return ListView.separated(
//         itemCount: jsonResult != null ? jsonResult!.length:0,
//         itemBuilder: (context, index) {
//
//           return GestureDetector(
//               child: Container(
//               padding: EdgeInsets.all(10),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5),
//                   side: BorderSide(
//                       width: 1,
//                       color: Colors.grey[300]!
//                   ),
//                 ),
//                 child: Column(
//                     children: <Widget>[
//                       Padding(padding: EdgeInsets.only(top:8)),
//                       Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             new Padding(padding: new EdgeInsets.all(3.0)),
//                             Text(
//                               (index + 1).toString() + ". ",
//                               style: TextStyle(
//                                   color: Colors.teal,
//                                   fontSize: 16
//                               ),
//                             ),
//
//                             Expanded(
//                       child:Column(
//
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//
//                             Row(
//
//                                 children: <Widget>[
//                                   Container(
//                                     height: 30,
//                                     width: 125,
//
//                                     child:
//                                     AapoortiUtilities.customTextView("Bill No.", Colors.teal),
//                                   ),
//                                   Container(
//                                     height: 30,
//                                     child:
//                                     AapoortiUtilities.customTextView(jsonResult![index]['INVOICE_BILL_NO'], Colors.black),
//
//                                   )
//                                 ]
//                             ),
//
//
//                             Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   Container(
//                                     height: 30,
//                                     width: 125,
//                                     child:
//                                     AapoortiUtilities.customTextView("Submission Date", Colors.teal),
//                                   ),
//
//                                   Expanded(
//                                     child:Container(
//                                       height: 30,
//                                       child:
//                                       AapoortiUtilities.customTextView(jsonResult![index]['BILL_SUBMIT_DATE_DESC'], Colors.black),
//                                     ),
//                                   ),
//                                 ]
//                             ),
//
//
//                             Row(
//                                 children: <Widget>[
//                                   Container(
//                                     height: 30,
//                                     width: 125,
//                                     child:
//                                     AapoortiUtilities.customTextView("Contract No.", Colors.teal),
//                                   ),
//                                   Container(
//                                     height: 30,
//                                     child:
//                                     AapoortiUtilities.customTextView(jsonResult![index]['CONTRACT_NO'], Colors.black),
//                                   )
//                                 ]
//                             ),
//
//                             Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: <Widget>[
//
//                                   Container(
//                                     height: 30,
//                                     width: 125,
//                                     child:
//                                     AapoortiUtilities.customTextView("Contract Date", Colors.teal),
//                                   ),
//
//                                   Container(
//                                     height: 30,
//
//                                     child:
//                                     AapoortiUtilities.customTextView(jsonResult![index]['CONTRACT_DATE'], Colors.black),
//                                   )
//                                 ]
//                             ),
//
//                             Row(
//                                 children: <Widget>[
//                                   Container(
//                                     height: 30,
//                                     width: 125,
//                                     child:
//                                     AapoortiUtilities.customTextView("Submitted To", Colors.teal),
//                                   ),
//                                   Container(
//                                     height: 30,
//                                     child:
//                                     AapoortiUtilities.customTextView(jsonResult![index]['BILL_PREPARE_DESIG'], Colors.black),
//                                   )
//                                 ]
//                             ),
//                             Row(
//                                 children: <Widget>[
//                                   Container(
//                                     height: 30,
//                                     width: 125,
//                                     child:
//                                     AapoortiUtilities.customTextView("Status", Colors.teal),
//                                   ),
//                                   Expanded(
//                                                                       child: Container(
//                                       height: 30,
//                                       child:
//                                       AapoortiUtilities.customTextView(jsonResult![index]['BILL_STATUS_DESC'], Colors.black),
//                                     ),
//                                   )
//                                 ]
//                             ),
//
//                           ]
//                       ),
//                     ),
//                   ]
//               )]
//               ),
//               )
//               ),
//               onTap: () {
//                 String pokey = jsonResult![index]['BIDDER_ACK_ID'].toString();
//                 String desc = jsonResult![index]['BILL_STATUS_DESC'].toString();
//                 print(pokey);
//                 Navigator.push(context, MaterialPageRoute(
//                     builder: (context) => PendingBillDetails(pokeyN: pokey,desc: desc,)));
//
//           });
//         }
//
//
//         ,
//         separatorBuilder: (context, index) {
//           return Container();
//         }
//
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'PendingBillsDetails.dart';

class PendingBill extends StatefulWidget {
  get path => null;

  @override
  _PendingBillState createState() => _PendingBillState();
}

class _PendingBillState extends State<PendingBill> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult;
  List<dynamic>? filteredResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  String searchQuery = '';
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," + AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA;
    jsonResult = await AapoortiUtilities.fetchPostPostLogin(
        'Login/PendingBillList', 'PendingBillList', inputParam1, inputParam2, context);
    if (jsonResult!.length == 0) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
    setState(() {
      filteredResult = jsonResult;
    });
  }

  void filterBills(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty || jsonResult == null) {
        filteredResult = jsonResult;
      } else {
        filteredResult = jsonResult!.where((bill) {
          return bill['INVOICE_BILL_NO'].toString().toLowerCase().contains(query.toLowerCase()) ||
              bill['CONTRACT_NO'].toString().toLowerCase().contains(query.toLowerCase()) ||
              bill['BILL_PREPARE_DESIG'].toString().toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search bills...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16),
      onChanged: filterBills,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define color scheme
    final darkTealColor = const Color(0xFF0D47A1); // Blue shade 800 for AppBar
    final lightTealColor = const Color(0xFF64B5F6); // Lighter blue for card elements
    final veryLightTealColor = const Color(0xFFBBDEFB); // Very light blue for backgrounds
    final billTextColor = const Color(0xFF1976D2); // Blue for text
    final billNumberColor = const Color(0xFF0D47A1); // Dark blue for bill number

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: darkTealColor,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: isSearching
              ? buildSearchField()
              : const Text(
            'Pending Bills',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: isSearching ? const Icon(Icons.close) : const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchQuery = '';
                    filteredResult = jsonResult;
                  }
                });
              },
            ),
          ],
        ),
        drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey, context),
        body: Center(
          child: jsonResult == null
              ? const SpinKitFadingCircle(color: Color(0xFF0D47A1), size: 120.0)
              : filteredResult!.isEmpty
              ? Center(
            child: Text(
              'No bills found matching "$searchQuery"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          )
              : buildBillList(context, darkTealColor, lightTealColor, veryLightTealColor, billTextColor, billNumberColor),
        ),
      ),
    );
  }

  Widget buildBillList(BuildContext context, Color darkTealColor, Color lightTealColor,
      Color veryLightTealColor, Color billTextColor, Color billNumberColor) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredResult!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            String pokey = filteredResult![index]['BIDDER_ACK_ID'].toString();
            String desc = filteredResult![index]['BILL_STATUS_DESC'].toString();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PendingBillDetails(pokeyN: pokey, desc: desc)),
            );
          },
          child: BillCard(
            index: index + 1,
            billData: filteredResult![index],
            tealColor: lightTealColor,
            darkTealColor: darkTealColor,
            veryLightTealColor: veryLightTealColor,
            billTextColor: billTextColor,
            billNumberColor: billNumberColor,
          ),
        );
      },
    );
  }
}

class BillCard extends StatelessWidget {
  final int index;
  final dynamic billData;
  final Color tealColor;
  final Color darkTealColor;
  final Color veryLightTealColor;
  final Color billTextColor;
  final Color billNumberColor;

  const BillCard({
    Key? key,
    required this.index,
    required this.billData,
    required this.tealColor,
    required this.darkTealColor,
    required this.veryLightTealColor,
    required this.billTextColor,
    required this.billNumberColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bill number header with reduced padding
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            width: double.infinity,
            child: Text(
              "${index}. Bill No: ${billData['INVOICE_BILL_NO']}",
              style: TextStyle(
                color: billNumberColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // Bill details
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.6),
                1: FlexColumnWidth(2.4),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                buildTableRow("Submission Date", billData['BILL_SUBMIT_DATE_DESC'] ?? ""),
                buildTableRow("Contract No.", billData['CONTRACT_NO'] ?? ""),
                buildTableRow("Contract Date", billData['CONTRACT_DATE'] ?? ""),
                buildTableRow("Submitted To", billData['BILL_PREPARE_DESIG'] ?? ""),
              ],
            ),
          ),

          // Status at bottom right
          Container(
            padding: const EdgeInsets.only(right: 16, top: 0, bottom: 8),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.orange.shade800,
                ),
                const SizedBox(width: 4),
                Text(
                  billData['BILL_STATUS_DESC'] ?? "",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: billTextColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}
