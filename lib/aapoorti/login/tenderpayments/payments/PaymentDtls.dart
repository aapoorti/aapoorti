// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
// import 'package:flutter_app/aapoorti/common/NoData.dart';
// import 'package:flutter_app/aapoorti/common/NoResponse.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// import 'Payments.dart';
//
// class PaymentDtls extends StatefulWidget {
//   get path => null;
//   String? tenderno,deptrlw,closingdate,tendertype,tenderoid;
//
//
//   @override
//   _PaymentDtlsState createState() => _PaymentDtlsState(tenderno!,deptrlw!,closingdate!,tendertype!,tenderoid!);
//
//   PaymentDtls(String tenderno,String deptrlw,String closingdate,String tendertype,String tenderoid)
//   {
//     this.tenderno=tenderno;
//     this.tendertype=tendertype;
//     this.deptrlw=deptrlw;
//     this.closingdate=closingdate;
//     this.tenderoid=tenderoid;
//   }
// }
//
// class _PaymentDtlsState extends State<PaymentDtls> {
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   String? tenderno,deptrlw,closingdate,tendertype,tenderoid;
//   String? tndrno;
//   List<dynamic>? jsonResult;
//   final dbHelper = DatabaseHelper.instance;
//   var rowCount=-1;
//   Color _backgroundColor=Colors.white;
//
//   void initState() {
//     super.initState();
//     callWebService();
//
//
//   }
//   void callWebService() async {
//     String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
//     String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA+","+tenderoid!;
//
//     jsonResult = await AapoortiUtilities.fetchPostPostLogin('Log/PaymentDtls', 'PaymentDtls' ,inputParam1, inputParam2, context) ;
//     print(jsonResult!.length);
//     print(jsonResult!.toString());
//     if(jsonResult!.length==0)
//     {
//       jsonResult=null;
//       Navigator.pop(context);
//       Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
//     }
//     else if(jsonResult![0]['ErrorCode']==3)
//     {
//       jsonResult=null;
//       Navigator.pop(context);
//       Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
//     }
//     setState(() {
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  WillPopScope(
//         onWillPop: () async {
//           return true;
//         },
//         child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             key: _scaffoldKey,
//             appBar: AppBar(
//               iconTheme: IconThemeData(color: Colors.white),
//
//               backgroundColor: Colors.teal,
//               title: Text('My Payments',
//                   style:TextStyle(
//                       color: Colors.white
//                   )
//               ),
//             ),
//             drawer :AapoortiUtilities.navigationdrawer(_scaffoldKey, context),
//             body: Column(
//
//               children: <Widget>[
//                 Container(
//
//                   decoration: BoxDecoration(color: Colors.teal[100]),
//
//                   child:
//                   ExpansionTile(
//
//
//
//                     title: Text('Tender Details',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontStyle:FontStyle.normal,
//                       fontWeight: FontWeight.bold,),
//                       ),
//                     backgroundColor: Colors.teal[100],
//                     onExpansionChanged: _onExpansion,
//                     children: <Widget>[
//
//                       Row(
//
//                           children: <Widget>[
//
//                             Container(
//                               height: 30,
//                               width: 125,
//
//                               child: Text("Tender No.",
//                                 style: TextStyle(
//                                     color: Colors.teal,
//                                     fontSize: 16),
//                               ),
//                             ),
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 tenderno!,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16),
//                               ),
//                             )
//                           ]
//                       ),
//                       Row(
//
//                           children: <Widget>[
//
//                             Container(
//                               height: 30,
//                               width: 125,
//
//                               child: Text("Rly.Unit/Dept.",
//                                 style: TextStyle(
//                                     color: Colors.teal,
//                                     fontSize: 16),
//                               ),
//                             ),
//                             Expanded(
//                                 child:   Container(
//                                   child: Text(
//                                     deptrlw!,
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 16),
//                                   ),
//                                 )
//                             )
//
//                           ]
//                       ),
//                       Row(
//
//                           children: <Widget>[
//
//                             Container(
//                               height: 30,
//                               width: 125,
//
//                               child: Text("Dept./Rly. Unit",
//                                 style: TextStyle(
//                                     color: Colors.teal,
//                                     fontSize: 16),
//                               ),
//                             ),
//                             Expanded(
//                                 child:        Container(
//                                   child: Text(
//                                     closingdate!,
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 16),
//                                   ),
//                                 )
//                             )
//
//                           ]
//                       ),
//                       Row(
//
//                           children: <Widget>[
//
//                             Container(
//                               height: 30,
//                               width: 125,
//
//                               child: Text("Closing Date",
//                                 style: TextStyle(
//                                     color: Colors.teal,
//                                     fontSize: 16),
//                               ),
//                             ),
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 closingdate!,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16),
//                               ),
//                             )
//                           ]
//                       ),
//                       Row(
//
//                           children: <Widget>[
//
//                             Container(
//                               height: 30,
//                               width: 125,
//
//                               child: Text("Payment Type",
//                                 style: TextStyle(
//                                     color: Colors.teal,
//                                     fontSize: 16),
//                               ),
//                             ),
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 tendertype!,
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16),
//                               ),
//                             )
//                           ]
//                       ),
//                     ],
//                   ),
//
//                 ),
//                 Container(
//                     child: Expanded(child: jsonResult == null  ?
//                     SpinKitFadingCircle(color: Colors.teal, size: 120.0):_myListView(context),)
//                 )
//               ],
//             )
//         )
//     );
//
//   }
//
//
//   Widget _myListView(BuildContext context) {
//     //Dismiss spinner
//     SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
//
//     return
//
//       ListView.separated(
//         itemCount: jsonResult != null ? jsonResult!.length:0,
//         itemBuilder: (context, index) {
//
//           return
//             Container(
//
//                 padding: EdgeInsets.all(10),
//                 child:InkWell(
//                     onTap: ()
//                     {
//                       print("calling tp functn");
//
//         //  Navigator.push(context,
//         //  MaterialPageRoute(builder: (context)=>PaymentDtls(tndrno,tndrno,tndrno)));
//                     },
//                     child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             (index + 1).toString() + ". ",
//                             style: TextStyle(
//                                 color: Colors.indigo,
//                                 fontSize: 16
//                             ),
//                           ),
//
//
//                           Expanded(
//
//                             child:Column(
//
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//
//                                   Row(
//
//                                       children: <Widget>[
//                                         Container(
//                                           // height: 50,
//                                           width: 125,
//
//                                           child: Text("IREPS Ref. No/Bank Txn ID",
//                                             style: TextStyle(
//                                                 color: Colors.teal,
//                                                 fontSize: 16),
//                                           ),
//                                         ),
//                                         Expanded(
//                                             child:    Container(
//                                               child: Text(
//                                                 jsonResult![index]['IREPS_REF_ID'] !=null || jsonResult![index]['BANK_SETTLEMENT_ID'] == null ? "${jsonResult![index]['IREPS_REF_ID']}" : jsonResult![index]['IREPS_REF_ID']+"/"+jsonResult![index]['BANK_SETTLEMENT_ID'].toString(),
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 16),
//                                               ),
//                                             )
//                                         )
//
//                                       ]
//                                   ),
//                                    SizedBox(height:5),
//
//
//                                   Row(
//                                       mainAxisSize: MainAxisSize.max,
//                                       children: <Widget>[
//                                         Container(
//                                           // height: 30,
//                                           width: 125,
//                                           child: Text("Validity Date",
//                                             style: TextStyle(
//                                                 color: Colors.teal,
//                                                 fontSize: 16),
//                                           ),
//                                         ),
//
//                                         Expanded(
//                                           child:Container(
//                                             // height: 30,
//                                             child: Text(
//                                               jsonResult![index]['INSTRUMENT_VALIDITY_DATE']!=null? jsonResult![index]['INSTRUMENT_VALIDITY_DATE'] : "",
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 16),
//                                               overflow: TextOverflow.ellipsis,
//
//                                             ),
//                                           ),
//                                         ),
//                                       ]
//                                   ),
//                                    SizedBox(height:5),
//
//
//                                   Row(
//                                       children: <Widget>[
//                                         Container(
//                                           // height: 50,
//                                           width: 125,
//                                           child: Text("Date/Time",
//                                             style: TextStyle(
//                                                 color: Colors.teal,
//                                                 fontSize: 16),
//                                           ),
//                                         ),
//                                         Container(
//                                           // height: 30,
//                                           child: Text(
//                                             jsonResult![index]['BANK_TXN_DATE']!=null? jsonResult![index]['BANK_TXN_DATE'] : "",
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 16),
//                                           ),
//                                         )
//                                       ]
//                                   ),
//                                    SizedBox(height:5),
//
//                                   Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: <Widget>[
//
//                                         Container(
//                                           // height: 30,
//                                           width: 125,
//                                           child: Text("Issue Name",
//                                             style: TextStyle(
//                                                 color: Colors.teal,
//                                                 fontSize: 16),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child:      Container(
//
//                                             child:Text(
//                                               jsonResult![index]['TXN_MADE_VIA']!=null? jsonResult![index]['TXN_MADE_VIA']+"-"+jsonResult![index]['TXN_BANK_NAME']: "",
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 16),
//                                             ),
//                                           ),
//                                         )
//
//                                       ]
//                                   ),
//                                    SizedBox(height:5),
//
//                                   Row(
//                                       children: <Widget>[
//                                         Container(
//                                           // height: 50,
//                                           width: 125,
//                                           child: Text("Amount/Bank Status",
//                                             style: TextStyle(
//                                                 color: Colors.teal,
//                                                 fontSize: 16),
//                                           ),
//                                         ),
//                                         Expanded(
//                                             child:Container(
//                                               // height: 30,
//                                               child: Text(
//                                                 jsonResult![index]['TXN_AMOUNT']!=null? jsonResult![index]['TXN_AMOUNT'].toString()+"INR"+"/"+jsonResult![index]['IREPS_TRANS_STATUS']: "0"+"/"+jsonResult![index]['IREPS_TRANS_STATUS'],
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 16),
//                                               ),
//                                             )
//                                         ),
//                                       ]
//
//                                   ),
//                                   SizedBox(height:5),
//
//                                   Row(
//                                       children: <Widget>[
//                                         Container(
//                                           // height: 30,
//                                           width: 125,
//                                           child: Text("IREPS Remarks",
//                                             style: TextStyle(
//                                                 color: Colors.teal,
//                                                 fontSize: 16),
//                                           ),
//                                         ),
//                                         Container(
//                                           // height: 30,
//                                           child: Text(
//                                             jsonResult![index]['USER_REMARKS']!=null? jsonResult![index]['USER_REMARKS'] : "",
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 16),
//                                           ),
//                                         )
//                                       ]
//                                   ),
//
//
//                                 ]
//                             ),
//                           ),
//
//                         ]
//                         )
//                 )
//             );
//         },
//
//         separatorBuilder: (_,indx)=>Divider(thickness:4),
//
//       );
//   }
//
//   _PaymentDtlsState(String tenderno,String deptrlw,String closingdate,String tendertype,String tenderoid)
//   {
//     this.tenderno=tenderno;
//     this.tendertype=tendertype;
//     this.deptrlw=deptrlw;
//     this.closingdate=closingdate;
//     this.tenderoid=tenderoid;
//   }
//   void _onExpansion(bool value) {
//     /// Change background color. The ExpansionTile doesn't change to the new
//     /// _backgroundColor value. The Text element does.
//     _backgroundColor=Colors.grey[100]!;
//     setState(() {
//       _backgroundColor = Colors.grey[100]!;
//     });
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Payments.dart';

class PaymentDtls extends StatefulWidget {
  get path => null;
  String? tenderno, deptrlw, closingdate, tendertype, tenderoid;

  @override
  _PaymentDtlsState createState() => _PaymentDtlsState(tenderno!, deptrlw!, closingdate!, tendertype!, tenderoid!);

  PaymentDtls(String tenderno, String deptrlw, String closingdate, String tendertype, String tenderoid) {
    this.tenderno = tenderno;
    this.tendertype = tendertype;
    this.deptrlw = deptrlw;
    this.closingdate = closingdate;
    this.tenderoid = tenderoid;
  }
}

class _PaymentDtlsState extends State<PaymentDtls> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? tenderno, deptrlw, closingdate, tendertype, tenderoid;
  String? tndrno;
  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;

  // Updated theme colors
  final Color themeColor = Colors.blue.shade800;
  final Color secondaryColor = Colors.teal;
  final Color backgroundColor = Colors.grey.shade50;
  final Color cardColor = Colors.white;
  final Color textDarkColor = Colors.grey.shade800;
  final Color textMediumColor = Colors.grey.shade700;
  final Color textLightColor = Colors.grey.shade600;

  // Track position of floating back button
  Offset _buttonPosition = const Offset(20, 100);

  @override
  void initState() {
    super.initState();
    callWebService();
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," + AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA + "," + tenderoid!;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Log/PaymentDtls', 'PaymentDtls', inputParam1, inputParam2, context);
    print(jsonResult!.length);
    print(jsonResult!.toString());
    if (jsonResult!.length == 0) {
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

  // Function to handle back navigation
  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeColor,
          foregroundColor: Colors.white,
          title: Text(
            'My Payments',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _goBack,
          ),
        ),
        drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey, context),
        body: jsonResult == null
            ? Center(
          child: SpinKitFadingCircle(
            color: themeColor,
            size: 60.0,
          ),
        )
            : SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Tender Details Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                    color: themeColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tender No: $tenderno',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: textDarkColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: themeColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Closing Date: $closingdate',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: textMediumColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: secondaryColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            tendertype!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Department info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 16,
                          color: themeColor.withOpacity(0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            deptrlw!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: textMediumColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Payment List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: jsonResult != null ? jsonResult!.length : 0,
                      itemBuilder: (context, index) {
                        return _buildPaymentCard(index);
                      },
                    ),
                  ),
                ],
              ),

              // Draggable floating back button
              Positioned(
                left: _buttonPosition.dx,
                top: _buttonPosition.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _buttonPosition = Offset(
                        (_buttonPosition.dx + details.delta.dx).clamp(0, screenSize.width - 50),
                        (_buttonPosition.dy + details.delta.dy).clamp(50, screenSize.height - 100),
                      );
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: _goBack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(int index) {
    // Extract the data we need
    final refId = jsonResult![index]['IREPS_REF_ID'] ?? "";
    final bankId = jsonResult![index]['BANK_SETTLEMENT_ID'] ?? "";
    final validityDate = jsonResult![index]['INSTRUMENT_VALIDITY_DATE'] ?? "";
    final txnDate = jsonResult![index]['BANK_TXN_DATE'] ?? "";
    final txnVia = jsonResult![index]['TXN_MADE_VIA'] ?? "";
    final bankName = jsonResult![index]['TXN_BANK_NAME'] ?? "";
    final txnAmount = jsonResult![index]['TXN_AMOUNT'] ?? "0";
    final status = jsonResult![index]['IREPS_TRANS_STATUS'] ?? "";
    final remarks = jsonResult![index]['USER_REMARKS'] ?? "";

    // Determine status color based on status text
    Color statusColor;
    if (status.toLowerCase().contains("success")) {
      statusColor = Colors.green;
    } else if (status.toLowerCase().contains("fail") || status.toLowerCase().contains("reject")) {
      statusColor = Colors.red;
    } else if (status.toLowerCase().contains("pend")) {
      statusColor = Colors.orange;
    } else {
      statusColor = themeColor;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with index and ref number
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: themeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IREPS Ref/Bank Txn ID',
                        style: TextStyle(
                          color: textLightColor,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        bankId == null || bankId.isEmpty ? refId : "$refId/$bankId",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: textDarkColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Payment details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Validity Date', validityDate),
                  const SizedBox(height: 8),
                  _buildDetailRow('Date/Time', txnDate),
                  const SizedBox(height: 8),
                  _buildDetailRow('Bank', txnVia.isNotEmpty && bankName.isNotEmpty ? '$txnVia-$bankName' : ''),
                  const SizedBox(height: 8),
                  _buildDetailRow('Amount', '₹$txnAmount INR', isAmount: true),
                ],
              ),
            ),

            // Remarks section if available
            if (remarks.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 14,
                    color: themeColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Remarks',
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  remarks,
                  style: TextStyle(
                    color: textDarkColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: textLightColor,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isAmount ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
              color: isAmount ? themeColor : textDarkColor,
            ),
          ),
        ),
      ],
    );
  }

  _PaymentDtlsState(String tenderno, String deptrlw, String closingdate, String tendertype, String tenderoid) {
    this.tenderno = tenderno;
    this.tendertype = tendertype;
    this.deptrlw = deptrlw;
    this.closingdate = closingdate;
    this.tenderoid = tenderoid;
  }
}
