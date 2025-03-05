import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class LivUpcomRA extends StatefulWidget {
  @override
  _LivUpcomRAState createState() => _LivUpcomRAState();
}

class _LivUpcomRAState extends State<LivUpcomRA> {
  List<dynamic> jsonResult = [], _duplicateJsonResult = [];
  List<dynamic>? jsonResultUp;
  List<dynamic>? jsonResultLiv;
  int? resultCount;

  bool searchAction = false;

  final _textsearchController = TextEditingController();

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getliveUpcomingRA();
    });
  }

  @override
  void dispose() {
    jsonResult.clear();
    _duplicateJsonResult.clear();
    super.dispose();
  }

  void getliveUpcomingRA() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if(providedTime.isBefore(DateTime.now())){
      await fetchToken(context);
      getliveUpcomingRAData();
    }
    else{
      getliveUpcomingRAData();
    }
  }

  void getliveUpcomingRAData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P5/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      "input_type" : "LiveAndUpcoming",
      "input": "",
      "key_ver" : "V1"
    });

    try {
      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("live & upcoming ra ${json.decode(response.body)}");
      // Check the status code and print the response or handle errors
      if (response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        // Success, print the response
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        _duplicateJsonResult.clear();
        jsonResult.clear();
        setState(() {
          jsonResult = listJson;
          _duplicateJsonResult = listJson;
        });
        debugPrint('Response body livera: ${response.body}');
      } else {
        // Error, print the error response
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
      }
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
    }
  }

  var _snackKey = GlobalKey<ScaffoldState>();

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
                        searchingliveandUpData(_textsearchController.text.trim(), context);
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
                    searchingliveandUpData(query, context);
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
                      text: " Live & Upcoming(RA)",
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
              child: jsonResult.length == 0 ? SpinKitFadingCircle(color: AapoortiConstants.primary, size: 120.0) : Column(children: <Widget>[
                Container(child: Expanded(child: _myListView(context)))
              ]),
            ),
       )
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return ListView.separated(
        itemCount: jsonResult.length != 0 ? jsonResult.length : 0,
        itemBuilder: (context, index) {
          return Container(
            child: TenderCard(
              department: "${jsonResult[index]['key1'] != null ? "${index + 1}. ${jsonResult[index]['key1']}" : ""}",
              tenderNo: jsonResult[index]['key2'] != null ? jsonResult[index]['key2'] : "",
              title: jsonResult[index]['key3'] != null ? jsonResult[index]['key3'] : "",
              workArea: jsonResult[index]['key4'] != null ? jsonResult[index]['key4'] : "",
              startDate: jsonResult[index]['key5'] != null ? changeTimeZone(jsonResult[index]['key5']) : "",
              endDate: jsonResult[index]['key6'] != null ? changeTimeZone(jsonResult[index]['key6']) : "",
              nitlinks: jsonResult[index]['key7'],
              docslinks: jsonResult[index]['key8'],
              corrigendalinks: jsonResult[index]['key9'],
              isLive : jsonResult[index]['key10'] != null ? jsonResult[index]['key10'] : "",
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(height: 10);
        });
  }

  void changetoolbarUi(bool actionvalue) {
    setState(() {
      searchAction = actionvalue;
    });
  }

  String changeTimeZone(String resdate){
    tz.initializeTimeZones();

    DateTime dateTime = DateTime.parse(resdate);

    // Convert the DateTime object to the Asia/Kolkata timezone (or any other Asia time zone)
    tz.Location kolkata = tz.getLocation('Asia/Kolkata');
    tz.TZDateTime kolkataTime = tz.TZDateTime.from(dateTime, kolkata);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(kolkataTime);
    return formattedDate;
  }

  // --- Searching on Live & Upcoming Data
  void searchingliveandUpData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0) {
      try{
        Future<List<dynamic>> data = fetchliveandUpData(_duplicateJsonResult, query);
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

  // --- Search Live & Upcoming  Data ----
  Future<List<dynamic>> fetchliveandUpData(List<dynamic> data, String query) async{
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
  final String isLive;

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
    required this.corrigendalinks,
    required this.isLive
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isLive,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Tender No', tenderNo),
            _buildInfoRow('Work Area', workArea),
            _buildInfoRow('Title', title),
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
                _buildActionButton(Icons.article, 'Docs', docslinks == "NA" || docslinks == "NULL" ? Colors.brown : Colors.green, docslinks, context),
                _buildActionButton(Icons.edit_note, 'Corrigenda', corrigendalinks == "NA" || corrigendalinks == "NULL" ? Colors.brown : Colors.green, corrigendalinks, context),
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
            child: label == 'Title' ? ReadMoreText(
              value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              trimLines: 2,
              colorClickableText: Colors.brown[300],
              trimMode: TrimMode.Line,
              trimCollapsedText: '...more',
              trimExpandedText: '...less',
              delimiter: '',
            ) : Text(
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
                                "NIT",
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
            }
            else {
              AapoortiUtilities.showInSnackBar(context, "No PDF attached with this Tender!!");
            }
          }
          else if(label == 'Docs'){
            if(links == "NA" || links == "NULL") {
              AapoortiUtilities.showInSnackBar(context, "No Documents attached with this Tender!!");
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
              label == 'NIT' ? Image.asset('images/pdf_home.png', height: 30, width: 20) : Icon(icon, color: color),
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
