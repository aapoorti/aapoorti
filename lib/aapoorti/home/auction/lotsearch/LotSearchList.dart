import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/home/auction/lotsearch/LotSearchLotDetails.dart';
import 'package:readmore/readmore.dart';

class LotSearchList extends StatefulWidget {
  final String? desc, depotUnit, railUnit;
  final int? lotType;

  LotSearchList({this.lotType, this.railUnit, this.depotUnit, this.desc});

  @override
  _LotSearchListState createState() => _LotSearchListState(
      this.lotType, this.railUnit, this.depotUnit, this.desc);
}

class _LotSearchListState extends State<LotSearchList> {
  String? desc, depotUnit, railUnit;
  int? lotType;
  String heading = "";

  _LotSearchListState(int? lotType, String? railUnit, String? depotUnit, String? desc) {
    this.lotType = lotType;
    this.railUnit = railUnit;
    this.depotUnit = depotUnit;
    this.desc = desc;
  }
  List<dynamic>? jsonResult;
  int? lotId;

  void initState() {
    super.initState();
    fetchPost();
  }

  List data = [];
  void fetchPost() async {
    var v = AapoortiConstants.webServiceUrl + 'Auction/Lotsearch?RLYID=${this.railUnit}&DEPOTID=${this.depotUnit}&DESC=${desc}&LOTTYPE=${lotType}';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);
    if(jsonResult![0]['ErrorCode'] == 3) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoData()));
    }
    else if (jsonResult![0]['ErrorCode'] == 4) {
      jsonResult = null;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NoResponse()));
    }
    setState(() {
      lotType == 0
          ? visibleYes = false
          : visibleYes = true; // setting visibility
      lotType == 0
          ? heading = "List of Lots(Published)"
          : heading = "List of Lots(Sold out)";
      data = jsonResult!;
    });
  }

//https://ireps.gov.in/Aapoorti/ServiceCallAuction/Lotsearch?RLYID=561&DEPOTID=-1&DESC=steel&LOTTYPE=1
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
            backgroundColor: AapoortiConstants.primary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Text('Lot Search(Sale)',
                        style: TextStyle(color: Colors.white))),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/common_screen", (route) => false);
                  },
                ),
              ],
            )),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: size.width,
                height: 30,
                color: Color(0xFF84FFFF),
                alignment: Alignment.center,
                child: Text(
                  heading,
                  style: TextStyle(
                      color: Colors.black45,
                      backgroundColor: Color(0xFF84FFFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: jsonResult == null
                      ? SpinKitFadingCircle(
                          color: AapoortiConstants.primary,
                          size: 120.0,
                        )
                      : _lotSearchList(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _lotSearchList(BuildContext context) {
    return Container(
      color: Colors.white, // Light grey background
      child: ListView.separated(
        itemCount: jsonResult != null ? jsonResult!.length : 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              lotId = jsonResult![index]['LOTID'];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LotSearchLotDetails(
                    lotId: lotId!,
                    lotType: lotType!,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              color: index % 2 == 0 ? Color(0xFFE3F2FD) : Colors.white, // Alternating card colors
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Spacing
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                side: BorderSide(
                    color: Colors.grey.shade400, width: 1), // Shaded border
              ),
              child: Padding(
                padding: EdgeInsets.all(8), // Padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${index + 1}. ${jsonResult![index]['ACCNM'] ?? ""}",
                      style: TextStyle(
                        color: Colors.lightBlue[800],
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),

                    // Location
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Location",
                            style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Roboto'),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            jsonResult![index]['LOC'] ?? "",
                            style: TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Roboto'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                    // Description
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Description",
                            style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Roboto'),
                          ),
                        ),
                        Expanded(
                          child: ReadMoreText(
                            jsonResult![index]['LOTDESC'] ?? "",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.deepOrangeAccent.shade200,
                            ),
                            trimLines: 2,
                            colorClickableText: Colors.blueGrey,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '... More',
                            trimExpandedText: '...less',
                          ),
                          // child: Text(
                          //   jsonResult![index]['LOTDESC'] ?? "",
                          //   style: TextStyle(
                          //     color: Colors.grey,
                          //     fontSize: 13,
                          //     fontFamily: 'Roboto',
                          //   ),
                          //   overflow: TextOverflow.ellipsis, // Prevents overflow issues
                          //   maxLines: 2, // Adjust the number of lines as needed
                          // ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 1); // Space between cards
        },
      ),
    );
  }

  // Widget _lotsearchlist(BuildContext context) {
  //   SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
  //   return ListView.separated(
  //     itemCount: jsonResult != null ? jsonResult!.length : 0,
  //     itemBuilder: (context, index) {
  //       return GestureDetector(
  //           child: Card(
  //             elevation: 4,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(5),
  //               side: BorderSide(width: 1, color: Colors.grey[300]!),
  //             ),
  //             child:
  //                 Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
  //                     Widget>[
  //               Text(
  //                 (index + 1).toString() + ". ",
  //                 style: TextStyle(
  //                     color: Colors.indigo,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //               Expanded(
  //                   child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                     Row(children: <Widget>[
  //                       Expanded(
  //                         //height: 30,
  //                         child: Text(
  //                           jsonResult![index]['ACCNM'] != null
  //                               ? jsonResult![index]['ACCNM']
  //                               : "",
  //                           style: TextStyle(
  //                               color: Colors.indigo,
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       )
  //                     ]),
  //                     Padding(
  //                       padding: EdgeInsets.all(5),
  //                     ),
  //                     Row(children: <Widget>[
  //                       Container(
  //                         height: 30,
  //                         width: 125,
  //                         child: Text(
  //                           "Location",
  //                           style:
  //                               TextStyle(color: Colors.indigo, fontSize: 16),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           jsonResult![index]['LOC'] != null ? jsonResult![index]['LOC'] : "",
  //                           style: TextStyle(color: Colors.grey, fontSize: 16),
  //                         ),
  //                       )
  //                     ]),
  //                     Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
  //                       Container(
  //                         height: 30,
  //                         width: 125,
  //                         child: Text(
  //                           "Description",
  //                           style:
  //                               TextStyle(color: Colors.indigo, fontSize: 16),
  //                         ),
  //                       ),
  //                     ]),
  //                     Row(children: <Widget>[
  //                       Expanded(
  //                         //height: 30,
  //                         child: Text(
  //                           jsonResult![index]['LOTDESC'] != null
  //                               ? jsonResult![index]['LOTDESC']
  //                               : "",
  //                           style: TextStyle(color: Colors.grey, fontSize: 16),
  //                         ),
  //                       )
  //                     ]),
  //                   ]))
  //             ]),
  //           ),
  //           onTap: () {
  //             lotId = jsonResult![index]['LOTID'];
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => LotSearchLotDetails(
  //                         lotId: lotId!,
  //                         lotType: lotType!))); //lotType:lotType)));
  //           });
  //     },
  //     separatorBuilder: (context, index) {
  //       return Container(
  //         height: 10,
  //       );
  //     },
  //   );
  // }
}
