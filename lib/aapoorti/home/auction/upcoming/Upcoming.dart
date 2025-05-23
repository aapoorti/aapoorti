import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/auction/upcoming/upcomingnextpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class Userup {
  final String? upid, category;
  const Userup({
    this.upid,
    this.category,
  });
}

class Upcoming extends StatefulWidget {
  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  List<dynamic>? jsonResult;
  var rowCount = -1;
  void openNewPage() {
    Navigator.of(context).pushNamed("/upcoming");
  }

  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() async {
    var v = AapoortiConstants.webServiceUrl + 'Auction/AucUpcoming?PAGECOUNTER=1';
    final response = await http.post(Uri.parse(v));
    debugPrint("upcoming resp ${response.body}");

    if(response.statusCode == 200) {
      try {
        final List<dynamic> responseBody = jsonDecode(response.body);

        if(responseBody.isNotEmpty && responseBody[0] is Map<String, dynamic>) {
          final data = responseBody[0];

          if(data.containsKey('ErrorCode')) {
            debugPrint("ErrorCode found: ${data['ErrorCode']}");
            setState(() {
              jsonResult = [];
            });
          }
          else {
            debugPrint("ErrorCode not found.");
            setState(() {
              jsonResult = json.decode(response.body);
            });
          }
        } else {
          setState(() {
            jsonResult = json.decode(response.body);
          });
        }
      } catch (e) {
        setState(() {
          jsonResult = [];
        });
      }
    }
    else {
      setState(() {
        jsonResult = [];
      });
    }
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
            title: Text('Upcoming Auctions (Sale)', style: TextStyle(color: Colors.white,fontSize: 18))),
        body: Center(
            child: jsonResult == null ? SpinKitFadingCircle(color: AapoortiConstants.primary, size: 120.0) : jsonResult!.isEmpty ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
                AnimatedTextKit(
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText("Data not found",
                          speed: Duration(milliseconds: 150),
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold)),
                    ])
              ],
            ) : _myListView(context)),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    if(jsonResult!.isEmpty) {
      AapoortiUtilities.showInSnackBar(context, "No Upcoming Tender");
    } else {
      return ListView.builder(
        itemCount: jsonResult!.length,
        itemBuilder: (context, index) {
          final item = jsonResult![index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index+1}.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(jsonResult![index]['DEPOT_NAME'] != null ? jsonResult![index]['DEPOT_NAME'] : "", style: Theme.of(context).textTheme.bodyMedium
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.receipt_outlined,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Catalogue No : ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        jsonResult![index]['CATALOG_NO'] != null ? jsonResult![index]['CATALOG_NO'] : "",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 4),
                          //   child: Container(
                          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          //     decoration: BoxDecoration(
                          //       color: Colors.green[50],
                          //       borderRadius: BorderRadius.circular(12),
                          //       border: Border.all(color: Colors.green[200]!),
                          //     ),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         Container(
                          //           width: 6,
                          //           height: 6,
                          //           decoration: BoxDecoration(
                          //             color: Colors.green[600],
                          //             shape: BoxShape.circle,
                          //           ),
                          //         ),
                          //         const SizedBox(width: 4),
                          //         Text(
                          //           'LIVE',
                          //           style: TextStyle(
                          //             color: Colors.green[700],
                          //             fontSize: 11,
                          //             fontWeight: FontWeight.w600,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(height: 1),
                      ),
                      // Time information - centered in the card
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Start time with label
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Start',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    jsonResult![index]['AUCTION_START_DATETIME'] != null ? jsonResult![index]['AUCTION_START_DATETIME'] : "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  height: 20,
                                  width: 1,
                                  color: Colors.grey[300],
                                ),
                              ),
                              // End time with label
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'End',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text((jsonResult![index]['AUCTION_END_DATETIME'] != null ? jsonResult![index]['AUCTION_END_DATETIME'] : ""),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Categories section with horizontal scrolling and lighter blue background
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[800]!.withOpacity(0.08),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 38,
                        child: Overlay(
                          context,
                          jsonResult![index]['DESCRIPTION'].toString(),
                          jsonResult![index]['CATALOG_ID'].toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return Container();
  }

  Widget Overlay(BuildContext context, String description, String catid) {
    var UpcomingArray = description.split('#');
    var upcomingcatid = catid;
    return ListView.builder(
        itemCount: description.isNotEmpty || description.length>0 ? UpcomingArray.length : 0,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              var route = MaterialPageRoute(
                builder: (BuildContext context) => upcoming2(value1: Userup(upid: upcomingcatid, category: UpcomingArray[index])),
              );
              Navigator.of(context).push(route);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.lightBlue[800]!.withOpacity(0.2)),
                ),
                child: Center(
                  child: Text(
                    UpcomingArray[index].toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
