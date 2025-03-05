import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readmore/readmore.dart';

List<dynamic>? jsonResult;
bool? visibleYes;

class LotSearchLotDetails extends StatefulWidget {
  final int? lotId, lotType;

  LotSearchLotDetails({this.lotId, this.lotType});
  @override
  LotSearchLotDetailsState createState() =>
      LotSearchLotDetailsState(this.lotId!, this.lotType!);
}

class LotSearchLotDetailsState extends State<LotSearchLotDetails> {
  List<dynamic>? jsonResult;
  int? lotId;
  int? lotType;
  String? heading = "";

  LotSearchLotDetailsState(int lotId, int lotType) {
    this.lotId = lotId;
    this.lotType = lotType;
  }

  void initState() {
    super.initState();
    this.fetchPost();
  }

  List data = [];

  Future<void> fetchPost() async {

    var v =
        AapoortiConstants.webServiceUrl + 'Auction/LotDesc?LOTID=${this.lotId}';

    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);

    setState(() {
      lotType == 0
          ? visibleYes = false
          : visibleYes = true; // setting visibility
      lotType == 0
          ? heading = "Lot Details(Published)"
          : heading = "Lot Details(Sold out)";
      data = jsonResult!;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    //Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            )),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 400,
                height: 30,
                color: Colors.cyan.shade600,
                alignment: Alignment.center,
                child: Text(
                  heading!,
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.cyan.shade600,
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
                      : _SoldLotDetailsListView(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool isFullWidth = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFullWidth)
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center, // Center text
            ),
          )
        else
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        if (!isFullWidth)
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          )
        else
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              softWrap: true,
            ),
          ),
      ],
    );
  }

  Widget _SoldLotDetailsListView(BuildContext context) {
    return Container(
      color: Color(0xFFE3F2FD),
      child: jsonResult!.isEmpty
          ? Container(
        height: 50.0,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Lot Details not found!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ),
      ) : ListView.separated(
        padding: EdgeInsets.all(5),
        itemCount: jsonResult != null ? jsonResult!.length : 0,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildAccountDepartmentRow(index),
                  Column(
                    children: [
                      Text(
                        "${jsonResult![index]['ACCNM'] ?? ""} / ${jsonResult![index]['DEPTNM'] ?? ""}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                      "Lot Number:", jsonResult![index]['LOTNO'] ?? ""),
                  _buildInfoRow(
                      "Custodian:", jsonResult![index]['CUST'] ?? ""),
                  _buildDivider(),
                  _buildInfoRow(
                    "PL No./Category ",
                    " ${jsonResult![index]['PLN'] ?? ""} / ${jsonResult![index]['CATNM'] ?? ""}",
                  ),
                  _buildDivider(),
                  _buildInfoRow("Qty/Sold Rate",
                      "${jsonResult![index]['LOTQTY']?.toString() ?? ""} / ${jsonResult![index]['SOLD_RATE']?.toString() ?? ""}"),
                  _buildDivider(),
                  _buildInfoRow(
                      "GST:", "${jsonResult![index]['GST'] ?? ""}%"),
                  _buildDivider(),
                  if (visibleYes!) ...[
                    _buildInfoRow("Bidder Name:",
                        jsonResult![index]['BIDDER_NAME'] ?? ""),
                  ],
                  _buildDivider(),
                  _buildInfoRow("Excluded Items:",
                      jsonResult![index]['EXCLDITMS'] ?? ""),
                  _buildDivider(),
                  _buildInfoRow(
                      "Location:", jsonResult![index]['LOC'] ?? ""),
                  _buildDivider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Special Condition:",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      ReadMoreText(
                        jsonResult![index]['SPCLCOND'] ?? "",
                        trimLines: 3,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                        colorClickableText: Colors.grey[800],
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '..More',
                        trimExpandedText: '..Less',
                      )
                    ],
                  ),
                  _buildDivider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description:",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      ReadMoreText(
                        jsonResult![index]['LOTMATDESC'] ?? "",
                        trimLines: 3,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                        colorClickableText: Colors.grey[800],
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '..More',
                        trimExpandedText: '..Less',
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 6),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[300], thickness: 1);
  }

//   Widget _SoldLotDetailsListView(BuildContext context) {
//     SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
//
//     return jsonResult!.isEmpty
//         ? Container(
//             height: 40.0,
//             width: 500,
//             child: Card(
//               margin: EdgeInsets.only(top: 20.0, left: 15, right: 15),
//               child: Text(
//                 "Lot Details not found!",
//                 style: TextStyle(fontSize: 17, color: Colors.indigo),
//                 textAlign: TextAlign.center,
//               ),
//             ))
//         : ListView.separated(
//             itemCount: jsonResult != null ? jsonResult!.length : 0,
//             itemBuilder: (context, index) {
//               return Container(
//                 padding: EdgeInsets.all(10),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 jsonResult![index]['ACCNM'] != null
//                                     ? jsonResult![index]['ACCNM'] + "/"
//                                     : "",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 jsonResult![index]['DEPTNM'] != null
//                                     ? jsonResult![index]['DEPTNM']
//                                     : "",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ]),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 "Lot Number                ",
//                                 style: TextStyle(
//                                     color: Colors.indigo, fontSize: 16),
//                               ),
//                             ),
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 jsonResult![index]['LOTNO'] != null
//                                     ? jsonResult![index]['LOTNO']
//                                     : "",
//                                 style: TextStyle(
//                                     color: Colors.teal[900],
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             )
//                           ]),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Row(children: <Widget>[
//                             Container(
//                               // height: 30,
//
//                               child: Text(
//                                 "Category/Part             ",
//                                 style: TextStyle(
//                                     color: Colors.indigo, fontSize: 16),
//                               ),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 // height: 30,
//                                 child: Text(
//                                   jsonResult![index]['CATNM'] != null
//                                       ? jsonResult![index]['CATNM']
//                                       : "",
//                                   style: TextStyle(
//                                       color: Colors.grey, fontSize: 16),
//                                 ),
//                               ),
//                             )
//                           ]),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 "PL Number                  ",
//                                 style: TextStyle(
//                                     color: Colors.indigo, fontSize: 16),
//                               ),
//                             ),
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 jsonResult![index]['PLN'] != null
//                                     ? jsonResult![index]['PLN']
//                                     : "",
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 16),
//                               ),
//                             )
//                           ]),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Column(children: <Widget>[
//                             Row(
//                               children: <Widget>[
//                                 Container(
//                                   height: 30,
//                                   child: Text(
//                                     "Description",
//                                     style: TextStyle(
//                                         color: Colors.indigo, fontSize: 16),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Expanded(
//                                     child: Text(
//                                   jsonResult![index]['LOTMATDESC'] != null
//                                       ? jsonResult![index]['LOTMATDESC']
//                                       : "",
//                                   style: TextStyle(
//                                       color: Colors.grey, fontSize: 16),
//                                 )),
//                               ],
//                             ),
// //
//                           ]),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Column(children: <Widget>[
//                             Row(
//                               children: <Widget>[
//                                 Container(
//                                   // height: 30,
//                                   width: 125,
//
//                                   child: Text(
//                                     "Special Condition",
//                                     style: TextStyle(
//                                         color: Colors.indigo, fontSize: 16),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Text(
//                                     jsonResult![index]['SPCLCOND'] != null
//                                         ? jsonResult![index]['SPCLCOND']
//                                         : "",
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 16),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ]),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 "Custodian                   ",
//                                 style: TextStyle(
//                                     color: Colors.indigo, fontSize: 16),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 jsonResult![index]['CUST'] != null
//                                     ? jsonResult![index]['CUST']
//                                     : "",
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 16),
//                               ),
//                             )
//                           ]),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 "Location                      ",
//                                 style: TextStyle(
//                                     color: Colors.indigo, fontSize: 16),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 jsonResult![index]['LOC'] != null
//                                     ? jsonResult![index]['LOC']
//                                     : "",
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 16),
//                               ),
//                             )
//                           ]),
//                           new Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 "GST                               ",
//                                 style: TextStyle(
//                                     color: Colors.indigo, fontSize: 16),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 jsonResult![index]['GST'] != null
//                                     ? jsonResult![index]['GST'].toString() + "%"
//                                     : "",
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 16),
//                               ),
//                             )
//                           ]),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 "Excluded items           ",
//                                 style: TextStyle(
//                                     color: Colors.indigo, fontSize: 16),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 jsonResult![index]['EXCLDITMS'] != null
//                                     ? jsonResult![index]['EXCLDITMS']
//                                     : "",
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 16),
//                               ),
//                             )
//                           ]),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               child: Text(
//                                 "Approx Lot Qty            ",
//                                 style: TextStyle(
//                                     color: Colors.indigo, fontSize: 16),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 jsonResult![index]['LOTQTY'] != null
//                                     ? jsonResult![index]['LOTQTY'].toString()
//                                     : "",
//                                 style:
//                                     TextStyle(color: Colors.grey, fontSize: 16),
//                               ),
//                             )
//                           ]),
//                           new Divider(
//                             color: Colors.blueAccent,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Visibility(
//                             child: Row(children: <Widget>[
//                               Container(
//                                 // height: 30,
//                                 child: Text(
//                                   "Bidder Name           ",
//                                   style: TextStyle(
//                                       color: Colors.indigo, fontSize: 16),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   jsonResult![index]['BIDDER_NAME'] != null
//                                       ? jsonResult![index]['BIDDER_NAME']
//                                           .toString()
//                                       : "",
//                                   style: TextStyle(
//                                       color: Colors.grey, fontSize: 16),
//                                 ),
//                               )
//                             ]),
//                             visible: visibleYes!,
//                           ),
//                           Divider(
//                             color: Colors.grey,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(5),
//                           ),
//                           Visibility(
//                             child: Row(children: <Widget>[
//                               Container(
//                                 height: 30,
//                                 child: Text(
//                                   "Sold Rate           ",
//                                   style: TextStyle(
//                                       color: Colors.indigo, fontSize: 16),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   jsonResult![index]['SOLD_RATE'] != null
//                                       ? jsonResult![index]['SOLD_RATE']
//                                           .toString()
//                                       : "",
//                                   style: TextStyle(
//                                       color: Colors.grey, fontSize: 16),
//                                 ),
//                               )
//                             ]),
//                             visible: visibleYes!,
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) {
//                return Divider();
//             },
//           );
//   }
}
