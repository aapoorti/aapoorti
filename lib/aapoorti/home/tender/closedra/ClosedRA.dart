import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

String pageNumber = "1";

class CloseRA extends StatefulWidget {
  get path => null;
  @override
  _CloseRAState createState() => _CloseRAState();
}

class _CloseRAState extends State<CloseRA> {
  List<dynamic> jsonResult = [], _duplicateJsonResult = [];
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  String? pgno;
  int? total_records, no_pages;
  int flag = 0;
  int? initialValRange;
  int? initalValueRange;
  int recordsPerPageCounter = 0;
  int final_value = 0;
  int? calculated_value;
  var _snackKey = GlobalKey<ScaffoldState>();
  var respons;

  String ref= "Refresh";

  bool searchAction = false;

  final _textsearchController = TextEditingController();

  void initState() {
    super.initState();
    //fetchPost(pageNumber);
    getClosedRA();
  }

  @override
  void dispose() {
    jsonResult.clear();
    _duplicateJsonResult.clear();
    super.dispose();
  }

  void getClosedRA() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if(providedTime.isBefore(DateTime.now())){
      await fetchToken(context);
      getClosedRAData();
    }
    else{
      getClosedRAData();
    }
  }

  void getClosedRAData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      'input_type': 'GET_CLOSED_RA_MVIEW',
      'input': '',
      'key_ver': 'V2',
    });

    try {
      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);

      // Check the status code and print the response or handle errors
      if (response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        // Success, print the response
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        jsonResult.clear();
        _duplicateJsonResult.clear();
        setState(() {
          jsonResult = listJson;
          _duplicateJsonResult = listJson;
        });
        debugPrint('Response body CRA: ${response.body}');
        //setState(() {});
      } else {
        // Error, print the error response
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
        //AapoortiUtilities.showInSnackBar(context, json.decode(response.body)['errors']['detail_arguments']);
      }
    }
    on SocketException catch(ex){
      AapoortiUtilities.showInSnackBar(context, 'Please check your internet connection.');
    }
    catch (e) {
      // Handle any exceptions
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
    }
  }

  void getupdateClosedRAData() async{
    setState(() {
      ref = "Please wait";
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      'input_type': 'GET_CLOSED_RA',
      'input': '',
      'key_ver': 'V2',
    });

    try {
      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);

      // Check the status code and print the response or handle errors
      if (response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        // Success, print the response
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        jsonResult.clear();
        _duplicateJsonResult.clear();
        setState(() {
          jsonResult = listJson;
          _duplicateJsonResult = listJson;
          ref = "Refresh";
        });
        ToastMessage.success("Successfully refersh Closed Auctions(RA)");
        debugPrint('Response body CRA: ${response.body}');
      } else {
        setState(() {
           ref = "Refresh";
        });
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
        //AapoortiUtilities.showInSnackBar(context, json.decode(response.body)['errors']['detail_arguments']);
      }
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
          key: _snackKey,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            backgroundColor: AapoortiConstants.primary,
            title: searchAction == true ?  Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                cursorColor: Colors.indigo[300],
                controller: _textsearchController,
                autofocus: searchAction,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5.0),
                    prefixIcon: Icon(Icons.search, color: Colors.indigo[300]),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.indigo[300]),
                      onPressed: () {
                        changetoolbarUi(false);
                        _textsearchController.text = "";
                        searchingClosedRAData(_textsearchController.text.trim(), context);
                      },
                    ),
                    focusColor: Colors.indigo[300],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.indigo.shade300, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.indigo.shade300, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.indigo.shade300, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Search",
                    border: InputBorder.none),
                onChanged: (query) {
                  if(query.isNotEmpty) {
                    searchingClosedRAData(query, context);
                  } else {
                    changetoolbarUi(false);
                    _textsearchController.text = "";
                  }
                },
              ),
            ) : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white)),
                SizedBox(width: 10),
                Container(
                    height: size.height * 0.10,
                    width: size.width / 1.5,
                    child: Marquee(
                      text: " Closed Auctions(RA)",
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 30.0,
                      velocity: 100.0,
                      style: TextStyle(fontSize: 18,color: Colors.white),
                      pauseAfterRound: Duration(seconds: 1),
                      accelerationDuration: Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ))
              ],
            ),
            actions: [
              // searchAction == true ? SizedBox() : IconButton(icon: Icon(
              //   Icons.home,
              //   color: Colors.white,
              // ), onPressed: () {
              //   Navigator.of(context, rootNavigator: true).pop();
              // }),
              searchAction == true ? SizedBox() : IconButton(onPressed: (){
                changetoolbarUi(true);
              }, icon: Icon(Icons.search, color: Colors.white))
            ],
          ),
          body: Builder(
                builder: (context) => Material(
                  child: jsonResult.length == 0 ? SpinKitFadingCircle(color: AapoortiConstants.primary, size: 120.0) : jsonResult.isEmpty ? Container(
                height: size.height,
                  width: size.width,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          child: Lottie.asset('assets/json/no_data.json'),
                        ),
                        AnimatedTextKit(
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TyperAnimatedText("Data not found",
                                  speed: Duration(milliseconds: 150),
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ])
                      ],
                    ),
                  ),
                ): Column(children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.update, color: Colors.blue, size: 20),
                              SizedBox(width: 4),
                              Text(
                                'Last updated on:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 4),
                              RichText(text: TextSpan(
                                text: jsonResult[0]['key12'] == null || jsonResult[0]['key12'] == "NULL" ? DateFormat("dd/MM/yyyy ").format(DateTime.now()) : "${jsonResult[0]['key12'].toString().split(" ").first} ",
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: jsonResult[0]['key12'] == null || jsonResult[0]['key12'] == "NULL" ? DateFormat("HH:mm").format(DateTime.now()) : jsonResult[0]['key12'].toString().split(" ").last, style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ))
                            ],
                          ),
                          InkWell(
                            onTap: () async{
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
                              if(providedTime.isBefore(DateTime.now())){
                                await fetchToken(context);
                                getupdateClosedRAData();
                              }
                              else{
                                getupdateClosedRAData();
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  ref != 'Refresh' ? Icon(Icons.cloud_download_rounded, color: Colors.blue, size: 16) : Icon(Icons.refresh, color: Colors.blue, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    ref,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   height: 55,
                    //   color: Colors.cyan[50],
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: <Widget>[
                    //         Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text("Data Last Updated on:", style: TextStyle(fontWeight: FontWeight.bold)),
                    //             RichText(text: TextSpan(
                    //               text: jsonResult[0]['key12'] == null || jsonResult[0]['key12'] == "NULL" ? DateFormat("dd/MM/yyyy ").format(DateTime.now()) : "${jsonResult[0]['key12'].toString().split(" ").first} ",
                    //               style: DefaultTextStyle.of(context).style,
                    //               children: <TextSpan>[
                    //                 TextSpan(
                    //                     text: jsonResult[0]['key12'] == null || jsonResult[0]['key12'] == "NULL" ? DateFormat("HH:mm").format(DateTime.now()) : jsonResult[0]['key12'].toString().split(" ").last, style: TextStyle(fontWeight: FontWeight.bold)),
                    //               ],
                    //             ))
                    //           ],
                    //         ),
                    //         InkWell(
                    //           onTap: () async{
                    //             SharedPreferences prefs = await SharedPreferences.getInstance();
                    //             DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
                    //             if(providedTime.isBefore(DateTime.now())){
                    //               await fetchToken(context);
                    //               getupdateClosedRAData();
                    //             }
                    //             else{
                    //               getupdateClosedRAData();
                    //             }
                    //           },
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Icon(Icons.refresh, size: 25, color: Colors.black),
                    //               Text(ref, style: TextStyle(color: Colors.black))
                    //             ],
                    //           ),
                    //         )
                    //
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Container(child: Expanded(child: _myListView(context)))
              ]),
            ),
          )
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView.separated(
        itemCount: jsonResult.length != 0 ? jsonResult.length : 0,
        itemBuilder: (context, index) {
          return Container(
            child: Column(children: <Widget>[
              // Padding(padding: EdgeInsets.only(top: 0)),
              // Row(
              //   children: <Widget>[
              //     if (index == 0)
              //       Container(
              //         width: MediaQuery.of(context).size.width,
              //         color: Colors.cyan[700],
              //         child: Text(
              //           "  Closed RA of last 90 days ",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 18),
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //   ],
              // ),
              Padding(padding: EdgeInsets.all(3.0)),
              TenderCard(
                department: "${jsonResult[index]['key1'] != null ? "${index + 1}. ${jsonResult[index]['key1']}" : ""}",
                tenderNo: jsonResult[index]['key3'] ?? 'NA',
                title: jsonResult[index]['key4'] ?? 'NA',
                workArea: jsonResult[index]['key5'] ?? 'NA',
                startDate: jsonResult[index]['key6'] ?? 'NA',
                endDate: jsonResult[index]['key7'] ?? 'NA',
                nitlinks: jsonResult[index]['key8'],
                docslinks: jsonResult[index]['key9'],
                corrigendalinks: jsonResult[index]['key10'],
                //isLive: true,
              ),
            ]),
          );
        },
        separatorBuilder: (context, index) {
          return Container();
        });
  }

  void changetoolbarUi(bool actionvalue) {
    setState(() {
      searchAction = actionvalue;
    });
  }

  // --- Searching on Closed RA Data
  void searchingClosedRAData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0) {
      try{
        Future<List<dynamic>> data = fetchClosedRAData(_duplicateJsonResult, query);
        data.then((value) {
          jsonResult = value.toSet().toList();
          setState(() {});
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      jsonResult = _duplicateJsonResult;
      setState(() {});
    }
    else{
      jsonResult = _duplicateJsonResult;
      setState(() {});
    }
  }

  // --- Search Closed RA Data ----
  Future<List<dynamic>> fetchClosedRAData(List<dynamic> data, String query) async{
    if(query.isNotEmpty){
      jsonResult = data.where((element) => element['key1'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key2'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key3'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key4'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key5'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key6'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element['key10'].toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return jsonResult;
    }
    else{
      return data;
    }
  }
}

class TenderCard extends StatelessWidget {
  final String department;
  final String tenderNo;
  final String title;
  final String workArea;
  final String startDate;
  final String endDate;
  final String nitlinks;
  final String docslinks;
  final String corrigendalinks;
  //final bool isLive;

  const TenderCard({
    super.key,
    required this.department,
    required this.tenderNo,
    required this.title,
    required this.workArea,
    required this.startDate,
    required this.endDate,
    required this.nitlinks,
    required this.docslinks,
    required this.corrigendalinks
    //required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    department,
                    style: const TextStyle(
                      fontSize: 16, // Reduced from 18 to make it fit on one line
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                  // if(isLive)
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 8,
                  //     vertical: 4,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.green.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: const Text(
                  //     'LIVE',
                  //     style: TextStyle(
                  //       color: Colors.green,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 12,
                  //     ),
                  //   ),
                  // ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Tender No:', tenderNo),
            _buildInfoRow('Title:', title),
            _buildInfoRow('Work Area:', workArea),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Date',
                          style: TextStyle(
                            color: Colors.red, // Changed from grey to blue to match theme
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          startDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue, // Changed to blue to match theme
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'End Date',
                            style: TextStyle(
                              color: Colors.red, // Changed from grey to blue to match theme
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            endDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue, // Changed to blue to match theme
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.description, 'NIT', Colors.red, nitlinks, context),
                _buildActionButton(Icons.article, 'Docs', Colors.green, docslinks, context),
                _buildActionButton(Icons.edit_note, 'Corrigenda', Colors.brown, corrigendalinks, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, String links, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
           if(label == 'NIT'){
             if(links != 'NA') {
               var fileUrl = links.toString();
               var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
               if(Platform.isIOS){
                 AapoortiUtilities.openPdf(context, fileUrl, fileName);
               }
               else{
                 showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return AlertDialog(
                       backgroundColor: Colors.white,
                       contentPadding: EdgeInsets.all(20),
                       content: Stack(
                         clipBehavior: Clip.none,
                         children: [
                           Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                   Text(
                                     'Choose an option for file  ',
                                     style: TextStyle(
                                       fontSize: 18,
                                       fontWeight: FontWeight.bold,
                                       fontFamily: 'Roboto',
                                       color: Colors.black,
                                     ),
                                   ),
                                   GestureDetector(
                                     onTap: () {
                                       Navigator.of(context).pop();
                                     },
                                     child: Container(
                                       decoration: BoxDecoration(
                                         color: Colors.red,
                                         shape: BoxShape.circle,
                                       ),
                                       padding: EdgeInsets.all(4),
                                       child: Icon(
                                         Icons.close,
                                         color: Colors.white,
                                         size: 16,
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 8),
                               Text(
                                 fileName,
                                 style: TextStyle(
                                   fontSize: 18,
                                   fontWeight: FontWeight.bold,
                                   fontFamily: 'Roboto',
                                   color: Colors.lightBlue[700],
                                 ),
                               ),
                               SizedBox(height: 20),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: [
                                   ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                       backgroundColor: Colors.lightBlue[700],
                                       foregroundColor: Colors.white,
                                     ),
                                     onPressed: () {
                                       Navigator.of(context).pop();
                                       AapoortiUtilities.downloadpdf(fileUrl, fileName, context);
                                     },
                                     child: Text('Download'),
                                   ),
                                   ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                       backgroundColor: Colors.lightBlue[700],
                                       foregroundColor: Colors.white,
                                     ),
                                     onPressed: () {
                                       Navigator.of(context).pop();
                                       AapoortiUtilities.openPdf(context, fileUrl, fileName);
                                     },
                                     child: Text('Open'),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         ],
                       ),
                     );
                   },
                 );
               }
             } else {
               AapoortiUtilities.showInSnackBar(context, "No PDF attached with this Tender!!");
             }
           }
           else if(label == 'Docs'){
             if(links != 'NA' || links != "NULL") {
               showDialog(
                   context: context,
                   builder: (_) => Material(
                       type: MaterialType.transparency,
                       child: Center(
                           child: Container(
                               margin: EdgeInsets.only(top: 55),
                               padding: EdgeInsets.only(bottom: 50),
                               color: Color(0xAB000000),
                               child: Column(children: <Widget>[
                                 Expanded(
                                   child:
                                   Container(
                                     padding:
                                     EdgeInsets.only(bottom: 20),
                                     child:
                                     AapoortiUtilities.attachDocsListView(context, links.toString()),
                                   ),
                                 ),
                                 Align(
                                   alignment:
                                   Alignment.bottomCenter,
                                   child: GestureDetector(
                                       onTap: () {
                                         Navigator.of(context, rootNavigator: true).pop('dialog');
                                       },
                                       child: Image(
                                         image: AssetImage('images/close_overlay.png'),
                                         height: 50,
                                       )),
                                 )
                               ])))));
             }
             else {
               AapoortiUtilities.showInSnackBar(context, "No Documents attached with this Tender!!");
             }
           }
           else if(label == 'Corrigenda'){
             if(links.toString() == "NA" || links.toString() == "NULL") {
               AapoortiUtilities.showInSnackBar(context, "No corrigendum issued with this Tender!!");
             }
             else {
               showDialog(context: context, builder: (_) => Material(
                 type: MaterialType.transparency,
                 child: Center(
                     child: Container(
                         margin: EdgeInsets.only(top: 55),
                         padding: EdgeInsets.only(bottom: 50),
                         color: Color(0xAB000000),
                         child: Column(children: <Widget>[
                           Expanded(
                             child: Container(
                               padding: EdgeInsets.only(bottom: 20),
                               child: AapoortiUtilities.corrigendumListView(context, links.toString()),
                             ),
                           ),
                           Align(
                             alignment: Alignment.bottomCenter,
                             child: GestureDetector(
                                 onTap: () {
                                   Navigator.of(context, rootNavigator: true).pop('dialog');
                                 },
                                 child: Image(
                                   image: AssetImage('images/close_overlay.png'),
                                   height: 50,
                                 )),
                           )
                         ]))),
               ));
             }
           }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              label == 'NIT' ? Image.asset('images/pdf_home.png', height: 30, width: 20) : label == 'Docs' ? Icon(icon, color: Colors.green) : Icon(icon, color: Colors.brown),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
