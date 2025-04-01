// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
// import 'package:flutter_app/aapoorti/common/NoData.dart';
// import 'package:flutter_app/aapoorti/common/NoResponse.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
//
//
// class ReverseAuction extends StatefulWidget {
//   get path => null;
//
//   @override
//   _ReverseAuctionState createState() => _ReverseAuctionState();
// }
//
// class _ReverseAuctionState extends State<ReverseAuction> {
//
//   final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
//
//   List<dynamic>? jsonResult;
//   final dbHelper = DatabaseHelper.instance;
//   var rowCount = -1;
//
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero,(){
//         callWebService();
//     });
//
//   }
//
//   void callWebService() async {
//     String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
//     String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA;
//
//     jsonResult = await AapoortiUtilities.fetchPostPostLogin('Login/RAList', 'RAList' ,inputParam1, inputParam2, context).timeout(Duration(seconds:10)) ;
//     debugPrint(jsonResult!.length.toString());
//     debugPrint(jsonResult.toString());
//     if(jsonResult!.length==0)
//     {
//       jsonResult = null;
//       Navigator.pop(context);
//       Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
//     }
//     else if(jsonResult![0]['ErrorCode']==3)
//       {
//         jsonResult=null;
//         Navigator.pop(context);
//         Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
//       }
//     if(this.mounted)
//     setState(() {
//
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: MaterialApp(
//
//       debugShowCheckedModeBanner: false,
//        title: 'Reverse Auction',
//        theme: ThemeData(
//         primarySwatch: Colors.teal,
//        ),
//         home: Scaffold(
//         key: _scaffoldkey,
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: Colors.white),
//           backgroundColor: Colors.teal,
//           title: Text('Reverse Auction',
//               style:TextStyle(
//                   color: Colors.white
//               )
//           ),
//         ),
//         drawer :AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
//         body: Center(
//             child: jsonResult == null  ?
//             SpinKitFadingCircle(color: Colors.teal, size: 120.0) :_myListView(context)
//         ),
//
//       ),
//     ),
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
//           return Container(
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
//                     Text(
//                       (index + 1).toString() + ". ",
//                       style: TextStyle(
//                           color: Colors.teal,
//                           fontSize: 16
//                       ),
//                     ),
//
//                     Expanded(
//                       child:Column(
//
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//
//                             Row(
//                                 children: <Widget>[
//                                   Expanded(
//                                     child:
//                                     Text(jsonResult![index]['RAILWAY_ZONE']!=null? jsonResult![index]['RAILWAY_ZONE']+"/"+jsonResult![index]['DEPARTMENT']: "",
//                                       style: TextStyle(
//                                           color: Colors.teal,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16
//                                       ),),
//                                   )
//                                 ]
//                             ),
//                             Padding(padding: EdgeInsets.all(5),),
//
//                             Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: <Widget>[
//                                   Container(
//                                     // height: 30,
//                                     width: 125,
//                                     child: Text("RA Date",
//                                       style: TextStyle(
//                                           color: Colors.teal,
//                                           fontSize: 16),
//                                     ),
//                                   ),
//
//                                   Expanded(
//                                     child:Container(
//                                       // height: 30,
//                                       child: Text(
//                                         jsonResult![index]['TENDER_OPENING_DATE']!=null? jsonResult![index]['TENDER_OPENING_DATE'] : "",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 16),
//                                         overflow: TextOverflow.ellipsis,
//
//                                       ),
//                                     ),
//                                   ),
//                                 ]
//                             ),
//                              SizedBox(height:5),
//
//                             Row(
//                                 children: <Widget>[
//                                   Container(
//                                     // height: 30,
//                                     width: 125,
//                                     child: Text("Tender No.",
//                                       style: TextStyle(
//                                           color: Colors.teal,
//                                           fontSize: 16),
//                                     ),
//                                   ),
//                                   Container(
//                                     // height: 30,
//                                     child: Text(
//                                       jsonResult![index]['TENDER_NUMBER']!=null? jsonResult![index]['TENDER_NUMBER'] : "",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 16),
//                                     ),
//                                   )
//                                 ]
//                             ),
//                             SizedBox(height:5),
//
//                             Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: <Widget>[
//
//                                   Container(
//                                     // height: 30,
//                                     width: 125,
//                                     child: Text("WorkArea",
//                                       style: TextStyle(
//                                           color: Colors.teal,
//                                           fontSize: 16),
//                                     ),
//                                   ),
//
//                                   Container(
//                                     // height: 30,
//
//                                     child:Text(
//                                       jsonResult![index]['WORK_AREA']!=null? jsonResult![index]['WORK_AREA'] : "",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 16),
//                                     ),
//                                   )
//                                 ]
//                             ),
//                              SizedBox(height:5),
//
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Container(
//                                     // height: 30,
//                                     width: 125,
//                                     child: Text("Tender Title",
//                                       style: TextStyle(
//                                           color: Colors.teal,
//                                           fontSize: 16),
//                                     ),
//                                   ),
//                                   Expanded(
//                                       child:Container(
//                                         // height: 50,
//                                         child: Text(
//                                           jsonResult![index]['TENDER_DESCRIPTION']!=null? jsonResult![index]['TENDER_DESCRIPTION'] : "",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 16),
//                                         ),
//                                       )
//                                   ),
//                                 ]
//
//                             ),
//                              SizedBox(height:5),
//
//                             Row(
//                                 children: <Widget>[
//                                   Container(
//                                     // height: 30,
//                                     width: 125,
//                                     child: Text("Type",
//                                       style: TextStyle(
//                                           color: Colors.teal,
//                                           fontSize: 16),
//                                     ),
//                                   ),
//                                   Container(
//                                     // height: 30,
//                                     child: Text(
//                                       jsonResult![index]['TENDER_STATUS']!=null? jsonResult![index]['TENDER_STATUS'] : "",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 16),
//                                     ),
//                                   )
//                                 ]
//                             ),
//                              SizedBox(height:5),
//                             Row(
//                                 children: <Widget>[
//                                   Container(
//                                     // height: 30,
//                                     width: 125,
//                                     child: Text("Links",
//                                       style: TextStyle(
//                                           color: Colors.teal,
//                                           fontSize: 16),
//                                     ),
//                                   ),
//
//                                   Expanded(
//                                     child:Row(
//
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: <Widget>[
//                                           GestureDetector(
//                                             onTap: ()  {
//                                               if(jsonResult![index]['SUMM_REPORT_LINK']!='NA') {
//                                                 String name="NIT";
// //                                                showDialog(
// //                                                  context: context,
// //                                                  barrierDismissible: false,
// //
// //
// //                                                  child: new Dialog(
// //                                                    backgroundColor: Colors.transparent,
// //
// //                                                    child: new Row(
// //                                                      mainAxisAlignment: MainAxisAlignment.center,
// //                                                      mainAxisSize: MainAxisSize.min,
// //                                                      children: [
// //                                                        new CircularProgressIndicator(backgroundColor: Colors.white,),
// //                                                        Padding(padding: EdgeInsets.all(10),),
// //                                                        new Text("Loading",style: TextStyle(color: Colors.white,fontSize: 24),),
// //                                                      ],
// //                                                    ),
// //                                                  ),
// //                                                );
//                                                 var fileUrl = jsonResult![index]['SUMM_REPORT_LINK'].toString();
//                                                 var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
//                                                 AapoortiUtilities.ackAlertLogin(context, fileUrl, fileName,name);
//
//
//                                                 //Dismiss dialog
//                                               //  Navigator.of(context, rootNavigator: true).pop('dialog');
//                                               }
//
//                                               else {
//                                                 AapoortiUtilities.showInSnackBar(context,"No PDF attached with this Tender!!");
//                                               }
//
//                                             },
//
//                                             child: Column(children:<Widget>[Container(
//                                               // height: 30,
//
//                                               child: Image(
//                                                   image: AssetImage('images/pdf_home.png'),
//                                                   height: 30,
//                                                   width: 20
//                                               ),
//
//                                             ),
//                                               new Padding(padding: EdgeInsets.all(0.0)),
//                                               new Container(
//                                                 child:   new Text('NIT', style: new TextStyle(
//                                                     color: Colors.blueGrey, fontSize: 9),
//                                                     textAlign: TextAlign.center),
//                                               ),]),
//                                           ),
//
//
//
//
//
//                                           Padding(padding: EdgeInsets.only(right: 0),),
//                                         ]
//                                     ),
//                                   ),
//
//
//
//
//
//
//
//                                 ]
//                             ),
//                              SizedBox(height:3),
//                           ]
//                       ),
//                     ),
//                   ]
//               )]
//           ),
//               )
//           );
//         },
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
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';


class ReverseAuction extends StatefulWidget {
  get path => null;

  @override
  _ReverseAuctionState createState() => _ReverseAuctionState();
}

class _ReverseAuctionState extends State<ReverseAuction> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  List<dynamic>? jsonResult;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;

  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      callWebService();
    });
  }

  void callWebService() async {
    String inputParam1 = AapoortiUtilities.user!.C_TOKEN + "," +AapoortiUtilities.user!.S_TOKEN + ",Flutter,0,0";
    String inputParam2 = AapoortiUtilities.user!.MAP_ID + "," + AapoortiUtilities.user!.CUSTOM_WK_AREA;

    jsonResult = await AapoortiUtilities.fetchPostPostLogin('Login/RAList', 'RAList' ,inputParam1, inputParam2, context).timeout(Duration(seconds:10)) ;
    debugPrint(jsonResult!.length.toString());
    debugPrint(jsonResult.toString());
    if(jsonResult!.length==0)
    {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoData()));
    }
    else if(jsonResult![0]['ErrorCode']==3)
    {
      jsonResult=null;
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>NoResponse()));
    }
    if(this.mounted)
      setState(() {

      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: const Text('Reverse Auction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          backgroundColor: Colors.blue.shade800,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer : AapoortiUtilities.navigationdrawer(_scaffoldkey,context),
        body: Center(
          child: jsonResult == null
              ? SpinKitFadingCircle(color: Colors.blue.shade700, size: 120.0)
              : _buildAuctionList(context),
        ),
      ),
    );
  }

  Widget _buildAuctionList(BuildContext context) {
    // Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: List.generate(
          jsonResult!.length,
              (index) => _buildAuctionItemCard(index),
        ),
      ),
    );
  }

  Widget _buildAuctionItemCard(int index) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.blue.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and PDF icon
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${index + 1}.',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    jsonResult![index]['RAILWAY_ZONE'] != null
                        ? jsonResult![index]['RAILWAY_ZONE'] + "/" + jsonResult![index]['DEPARTMENT']
                        : "",
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (jsonResult![index]['SUMM_REPORT_LINK'] != 'NA') {
                      String name = "NIT";
                      var fileUrl = jsonResult![index]['SUMM_REPORT_LINK'].toString();
                      var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                      AapoortiUtilities.ackAlertLogin(context, fileUrl, fileName, name);
                    } else {
                      AapoortiUtilities.showInSnackBar(context, "No PDF attached with this Tender!!");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red.shade100, width: 0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.picture_as_pdf, color: Colors.red, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'PDF',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info section with all details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('RA Date', jsonResult![index]['TENDER_OPENING_DATE'] ?? ""),
                const Divider(height: 16, thickness: 0.5),
                _buildInfoRow('Tender No.', jsonResult![index]['TENDER_NUMBER'] ?? ""),
                const Divider(height: 16, thickness: 0.5),
                _buildInfoRow('WorkArea', jsonResult![index]['WORK_AREA'] ?? ""),
                const Divider(height: 16, thickness: 0.5),
                _buildInfoRow('Tender Title', jsonResult![index]['TENDER_DESCRIPTION'] ?? ""),
                const Divider(height: 16, thickness: 0.5),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'Type',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue.shade200, width: 0.5),
                      ),
                      child: Text(
                        jsonResult![index]['TENDER_STATUS'] ?? "",
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}