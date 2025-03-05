import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/auction/live/livenextpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class User {
  final String? catid, category;
  const User({
    this.catid,
    this.category,
  });
}

class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  List<dynamic>? jsonResult;


  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() async {
    try{
      var v = AapoortiConstants.webServiceUrl + 'Auction/AucLive?PAGECOUNTER=1';
      final response = await http.post(Uri.parse(v));
      if(response.body.isNotEmpty){
        setState(() {
          jsonResult = json.decode(response.body);
        });
      }
    }
    on SocketException catch(ex){
      AapoortiUtilities.showInSnackBar(context, "Please check your internet connection!!");
    }
    on Exception catch(e){
      AapoortiUtilities.showInSnackBar(context, "Something went wrong, please try later.");
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
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AapoortiConstants.primary,
            title: Text('Live Auctions (Sale)', style: TextStyle(color: Colors.white,fontSize: 18))),
        body: Center(
            child: jsonResult == null ? SpinKitFadingCircle(color: AapoortiConstants.primary, size: 120.0) : _myListView(context)),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    if(jsonResult!.isEmpty) {
      AapoortiUtilities.showInSnackBar(context, "No Live Tender");
      return SizedBox(); // Return an empty widget or a placeholder here
    }
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
                              Text((item['ACCNAME'] != null && item['DEPTNM'] != null) ? "${item['ACCNAME']} / ${item['DEPTNM']}" : "", style: Theme.of(context).textTheme.bodyMedium
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
                                      item['CATNO'] ?? "",
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
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.green[600],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

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
                                  item['AUCSTRTDT'] ?? "",
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
                                Text(
                                  item['AUCENDDT'] ?? "",
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
                      child: livelistListView(
                        context,
                        item['DESCRIPTION'].toString(),
                        item['CATID'].toString(),
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


  Widget livelistListView(BuildContext context, String liveString, String catid) {
    var liveArray = liveString.split('#');
    var livecatid = catid;

    return ListView.builder(
        itemCount: liveString.isNotEmpty || liveString.length>0 ? liveArray.length : 0,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              debugPrint("live url===" + liveArray[index]);
              var route = MaterialPageRoute(
                builder: (BuildContext context) => live2(
                    value: User(
                      catid: livecatid,
                      category: liveArray[index],
                    )),
              );
              Navigator.of(context).push(route);
              debugPrint("catid===" + livecatid);
              debugPrint("category===" + liveArray[index]);
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
                    liveArray[index].toString(),
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

  String changeDateFormat(String datetime){
    // Parse the string into DateTime object
    DateTime dateTime = DateFormat("dd/MM/yyyy HH:mm:ss").parse(datetime);

    // Format the DateTime into the desired format
    String formattedDate = DateFormat("dd/MM/yyyy HH:mm").format(dateTime);

    return formattedDate;
  }
}
