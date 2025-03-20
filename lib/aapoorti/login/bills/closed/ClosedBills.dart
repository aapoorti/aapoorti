// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
// import 'package:flutter_app/aapoorti/common/NoData.dart';
// import 'package:flutter_app/aapoorti/common/NoResponse.dart';
// import 'package:flutter_app/aapoorti/login/bills/closed/ClosedBillsDetails.dart';
// import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// class ClosedBill extends StatefulWidget {
//   get path => null;
//   @override
//   _ClosedBillState createState() => _ClosedBillState();
// }
//
// class _ClosedBillState extends State<ClosedBill> {
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
//     jsonResult = await AapoortiUtilities.fetchPostPostLogin('Login/ClosedBillList', 'ClosedBillList' ,inputParam1, inputParam2, context) ;
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
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         key: _scaffoldKey,
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: Colors.white),
//           backgroundColor: Colors.teal,
//           title: Text('My Closed Bills',
//               style:TextStyle(
//                   color: Colors.white
//               )
//           ),
//         ),
//        drawer : AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
//         body: Center(
//             child: jsonResult == null  ?
//             SpinKitFadingCircle(color: Colors.teal, size: 120.0)
//                 :_myListView(context)
//         ),
//       ),
//     );
//   }
//
//   Widget _myListView(BuildContext context) {
//     return ListView.separated(
//         itemCount: jsonResult != null ? jsonResult!.length:0,
//         itemBuilder: (context, index) {
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
//                             Padding(padding: EdgeInsets.all(3.0)),
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
//                                     AapoortiUtilities.customTextViewBold(jsonResult![index]['INVOICE_BILL_NO'], Colors.black),
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
//                                     child: Container(
//                                       height: 40,
//                                       child:
//                                       AapoortiUtilities.customTextViewBold(jsonResult![index]['BILL_STATUS_DESC'], Colors.black),
//                                     ),
//                                   )
//                                 ]
//                             ),
//
//                           ]
//                       ),
//                     ),
//                   ]
//               )]))),
//           onTap: () {
//            String pokey = jsonResult![index]['BIDDER_ACK_ID'].toString();
//            String desc = jsonResult![index]['BILL_STATUS_DESC'].toString();
//             print(pokey);
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => ClosedBillDetails(pokeyN: pokey,desc: desc,)));
//           });
//         },
//         separatorBuilder: (context, index) {
//           return Container();
//         }
//         );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:flutter_app/aapoorti/login/bills/closed/ClosedBillsDetails.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ClosedBill extends StatefulWidget {
  get path => null;
  @override
  _ClosedBillState createState() => _ClosedBillState();
}

class _ClosedBillState extends State<ClosedBill> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  final Color themeColor = Colors.blue[800]!;

  @override
  void initState() {
    super.initState();
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," + AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Login/ClosedBillList', 'ClosedBillList', inputParam1, inputParam2, context);

    if (jsonResult!.isEmpty) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoData()));
    } else if (jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NoResponse()));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: themeColor,
          title: Text(
            'My Closed Bills',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey, context),
        body: Container(
          color: Colors.grey[100],
          child: jsonResult == null
              ? Center(
            child: SpinKitFadingCircle(
              color: themeColor,
              size: 50.0,
            ),
          )
              : _myListView(context),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: jsonResult != null ? jsonResult!.length : 0,
      itemBuilder: (context, index) {
        // Get the status text for conditional formatting
        String statusText = jsonResult![index]['BILL_STATUS_DESC'];
        bool isPending = statusText.contains("Pending");

        // Determine status color based on the status text
        Color statusColor = isPending
            ? Colors.orange
            : statusText.contains("Approved")
            ? Colors.green
            : statusText.contains("Rejected")
            ? Colors.red
            : themeColor;

        return GestureDetector(
          onTap: () {
            String pokey = jsonResult![index]['BIDDER_ACK_ID'].toString();
            String desc = jsonResult![index]['BILL_STATUS_DESC'].toString();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClosedBillDetails(
                  pokeyN: pokey,
                  desc: desc,
                ),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.only(bottom: 10),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bill Number with index
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. Bill No: ",
                        style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          jsonResult![index]['INVOICE_BILL_NO'],
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Information grid to prevent overflow
                  Column(
                    children: [
                      // Row 1: Submission Date
                      _buildInfoRow(
                        "Submission Date",
                        jsonResult![index]['BILL_SUBMIT_DATE_DESC'],
                      ),
                      SizedBox(height: 8),

                      // Row 2: Contract No
                      _buildInfoRow(
                        "Contract No.",
                        jsonResult![index]['CONTRACT_NO'],
                      ),
                      SizedBox(height: 8),

                      // Row 3: Contract Date
                      _buildInfoRow(
                        "Contract Date",
                        jsonResult![index]['CONTRACT_DATE'],
                      ),
                      SizedBox(height: 8),

                      // Row 4: Submitted To
                      _buildInfoRow(
                        "Submitted To",
                        jsonResult![index]['BILL_PREPARE_DESIG'],
                      ),
                      SizedBox(height: 12),

                      // Status row - without border
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              "Status",
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  isPending
                                      ? Icons.pending_outlined
                                      : statusText.contains("Approved")
                                      ? Icons.check_circle_outline
                                      : statusText.contains("Rejected")
                                      ? Icons.cancel_outlined
                                      : Icons.info_outline,
                                  color: statusColor,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Show acknowledgment message if pending
                      if (isPending)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 120),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: Colors.grey[600], size: 14),
                              SizedBox(width: 4),
                              Text(
                                "Acknowledgement Pending",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to build info rows with overflow protection
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: themeColor,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
