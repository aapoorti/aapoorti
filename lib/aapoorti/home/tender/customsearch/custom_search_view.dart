import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:flutter_app/aapoorti/models/CustomSearchData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'custom_search_filter.dart';
import 'package:dio/dio.dart';

class Custom_search_view extends StatefulWidget {
  final String? workarea,
      SearchForstring,
      RailZoneIn,
      Dt1In,
      Dt2In,
      searchOption,
      OrgCode,
      ClDate,
      dept,
      unit;

  Custom_search_view(
      {this.workarea,
      this.SearchForstring,
      this.RailZoneIn,
      this.Dt1In,
      this.Dt2In,
      this.searchOption,
      this.OrgCode,
      this.ClDate,
      this.dept,
      this.unit});
  @override
  _CustomSearchViewState createState() => _CustomSearchViewState(
      this.workarea!,
      this.SearchForstring!,
      this.RailZoneIn!,
      this.Dt1In!,
      this.Dt2In!,
      this.searchOption!,
      this.OrgCode!,
      this.ClDate!,
      this.dept!,
      this.unit!);
}

class _CustomSearchViewState extends State<Custom_search_view>
    implements Exception {
  bool vis = false;
  int i = -1;
  List<dynamic>? jsonResult;
  List<dynamic>? jsonResultUp;
  List<dynamic>? jsonResultLiv;
  int? resultCount;
  final dbHelper = DatabaseHelper.instance;
  var rowCount = -1;
  int count = 0;
  List data = [];
  static bool sfilter = false, keyboardOpen = false;
  String? workarea,
      SearchForstring,
      RailZoneIn,
      Dt1In,
      Dt2In,
      searchOption,
      OrgCode,
      ClDate,
      dept,
      unit;

  List<CustomSearchData> customSearchData = [];

  _CustomSearchViewState(
      String workare,
      String SearchForString,
      String RailZoneIn,
      String Dt1In,
      String Dt2In,
      String searchOption,
      String OrgCode,
      String ClDate,
      String dept,
      String unit) {
    this.workarea = workare;
    this.SearchForstring = SearchForString; //"supply";
    this.RailZoneIn = RailZoneIn; //"561";
    this.Dt1In = Dt1In; //"12/Aug/2019";
    this.Dt2In = Dt2In; //"10/Sep/2019";
    this.searchOption = searchOption; //"2";
    this.OrgCode = OrgCode; //"01";
    this.ClDate = ClDate; // "0";
    this.dept = dept; // "-1";
    this.unit = unit; //"-1";*/

    debugPrint("workarea " + this.workarea!);
    debugPrint("SearchForString " + this.SearchForstring!);
    debugPrint("RailZoneIn " + this.RailZoneIn!);
    debugPrint("Dt1In " + this.Dt1In!);
    debugPrint("Dt2In " + this.Dt2In!);
    debugPrint("searchOption " + this.searchOption!);
    debugPrint("OrgCode " + this.OrgCode!);
    debugPrint("ClDate " + this.ClDate!);
    debugPrint("dept " + this.dept!);
    debugPrint("unit " + this.unit!);
  }

  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() async {
    try {
      if (workarea == '#') {
        debugPrint("Custom search view 1");
        rowCount = (await dbHelper.rowCountCustomSearch())!;
        if (rowCount > 0) {
          debugPrint('Fetching from local DB');
          jsonResult = await dbHelper.getcustomsearchFilterData(
              SearchForstring!, RailZoneIn!, Dt1In!);
          debugPrint(jsonResult.toString());
          rowCount = jsonResult!.length;
          setState(() {
            data = jsonResult!;
          });
        }
      } else {
        debugPrint("Custom search view 2");
        try {
          var v = AapoortiConstants.webServiceUrl +
              'Tender/CustomSearch?WorkArea=${this.workarea}&SearchForString=${this.SearchForstring}&RailZoneIn=${this.RailZoneIn}&Dt1In=${this.Dt1In}&Dt2In=${this.Dt2In}&searchOption=${this.searchOption}&OrgCode=${this.OrgCode}&ClDate=${this.ClDate}&dept=${this.dept}&unit=${this.unit}';
          debugPrint("my url==>$v");
          final response =
              await http.post(Uri.parse(v)).timeout(Duration(seconds: 30));
          debugPrint("here is response now ${json.decode(response.body)} ");
          if (response.statusCode == 200) {
            jsonResult = json.decode(response.body);

            final rowsDeleted = await dbHelper.deleteCustomSearch(rowCount);
            debugPrint('json Result ${jsonResult.toString()}');
            debugPrint('deleted $rowsDeleted row(s): row $rowCount');

            debugPrint("delete count : data deleted, new data inserted ");
            rowCount = jsonResult!.length;
            if (rowCount == 0)
              keyboardOpen = true;
            else
              keyboardOpen = false;
            for (int index = 0; index < jsonResult!.length; index++) {
              Map<String, dynamic> row = {
                DatabaseHelper.COLUMN_SrNo: index.toString(),
                DatabaseHelper.COLUMN_DeptRly: jsonResult![index]['ACC_NAME'],
                DatabaseHelper.COLUMN_WorkArea: jsonResult![index]['WORK_ARA'],
                DatabaseHelper.COLUMN_TenderTitle: jsonResult![index]
                    ['TENDER_DESCRIPTION'],
                DatabaseHelper.COLUMN_TenderOPDate: jsonResult![index]
                    ['TENDER_OPDATE'],
                DatabaseHelper.COLUMN_oid: jsonResult![index]['OID'],
                DatabaseHelper.COLUMN_TenderNo: jsonResult![index]
                    ['TENDER_NUMBER'],
                DatabaseHelper.COLUMN_pdf: jsonResult![index]['PDFURL'],
                DatabaseHelper.COLUMN_Attachdocs: jsonResult![index]
                    ['ATTACH_DOCS'],
                DatabaseHelper.COLUMN_Cor: jsonResult![index]['CORRI_DETAILS'],
                DatabaseHelper.COLUMN_TenderStatus: jsonResult![index]
                    ['TENDER_STATUS'],
                DatabaseHelper.COLUMN_Type: jsonResult![index]['TENDER_TYPE'],
                DatabaseHelper.COLUMN_BiddingSystem: jsonResult![index]
                    ['BIDDING_SYSTEM'],
              };
              final id = dbHelper.insertCustomSearch(row);
              debugPrint('inserted row id: ' + index.toString());
            }
            setState(() {
              data = jsonResult!;
            });
          } else {
            setState(() {
              jsonResult = [];
            });
          }
        } catch (e) {
          AapoortiUtilities.showInSnackBar(context, e.toString());
        }
      }
    } catch (e) {
      if (e is SocketException) {
        AapoortiUtilities.showInSnackBar(
            context, "Check your internet connection!!");
      } else {
        AapoortiUtilities.showInSnackBar(
            context, "Something Unexpected happened! Please try again.");
      }
    }
  }

  Future<List<CustomSearchData>> getData(String url) async {
    final response =
        await http.post(Uri.parse(url)).timeout(Duration(seconds: 30));
    var data = json.decode(response.body);
    if(data != null) {
      customSearchData = data.map<CustomSearchData>((val) => CustomSearchData.fromJson(val)).toList();
      return customSearchData;
    } else {
      return customSearchData;
    }
  }

  var _snackKey = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _snackKey,
          appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: AapoortiConstants.primary,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: Text('Custom Search',
                          style: TextStyle(color: Colors.white))),
                  IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/common_screen", (route) => false);
                      })
                ],
              )),
          body: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    "    List of e-Tender as per " +
                        ((this.ClDate == "0")
                            ? "Closing Dates ( "
                            : " Uploading Dates ( ") +
                        (rowCount != -1 ? rowCount.toString() : "0") +
                        " ) ",
                    style: TextStyle(
                        color: Colors.indigo,
                        backgroundColor: Colors.cyan[50],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: jsonResult == null ? SpinKitFadingCircle(color: AapoortiConstants.primary, size: 120.0) : jsonResult!.isEmpty ? Container(
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
                  ) : _myListView(context),
                ),
              ],
            ),
          ),
          floatingActionButton: keyboardOpen
              ? SizedBox()
              : FloatingActionButton(
                  onPressed: () {
                    sfilter = true;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Custom_search_filter()));
                  },
                  tooltip: 'Custom Search Filter',
                  elevation: 12,
                  backgroundColor: AapoortiConstants.primary,
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked),
    );
  }

  Widget _myListView(BuildContext context) {
    //Dismiss spinner
    SpinKitWave(color: Colors.red, type: SpinKitWaveType.end);
    return jsonResult!.isEmpty
        ? Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
              AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
                TyperAnimatedText("Data not found",
                    speed: Duration(milliseconds: 150),
                    textStyle: TextStyle(fontWeight: FontWeight.bold)),
              ])
            ],
          ))
        : ListView.builder(
            itemCount: jsonResult == null ? 0 : jsonResult!.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey.shade200,
                child: Column(children: <Widget>[
                  Padding(padding: EdgeInsets.all(4.0)),
                  TenderCard(
                    department:
                        "${jsonResult![index]['ACC_NAME'] != null ? "${index + 1}. ${jsonResult![index]['ACC_NAME']}" : ""}",
                    tenderNo: jsonResult![index]['TENDER_NUMBER'] != null
                        ? jsonResult![index]['TENDER_NUMBER']
                        : "",
                    title: jsonResult![index]['TENDER_DESCRIPTION'] != null
                        ? jsonResult![index]['TENDER_DESCRIPTION']
                        : "",
                    workArea: jsonResult![index]['WORK_ARA'] != null
                        ? jsonResult![index]['WORK_ARA']
                        : "",
                    date: jsonResult![index]['TENDER_OPDATE'] != null
                        ? jsonResult![index]['TENDER_OPDATE']
                        : "",
                    status: jsonResult![index]['TENDER_STATUS'] != null
                        ? jsonResult![index]['TENDER_STATUS']
                        : "",
                    nitlinks: jsonResult![index]['PDFURL'],
                    docslinks: jsonResult![index]['ATTACH_DOCS'],
                    corrigendalinks: jsonResult![index]['CORRI_DETAILS'],
                  ),
                ]),
              );
            });
  }
}

class TenderCard extends StatelessWidget {
  final String department;
  final String tenderNo;
  final String title;
  final String workArea;
  final String date;
  final String status;
  final String nitlinks;
  final String docslinks;
  final String corrigendalinks;
  //final bool isLive;

  const TenderCard(
      {super.key,
      required this.department,
      required this.tenderNo,
      required this.title,
      required this.workArea,
      required this.date,
      required this.status,
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
                      fontSize:
                          16, // Reduced from 18 to make it fit on one line
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
            _buildInfoRow('Tender No', tenderNo),
            _buildInfoRow('Date', date),
            _buildInfoRow('Work Area', workArea),
            _buildInfoRow('Tender Status', status),
            _buildInfoRow('Title', title),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                    Icons.description, 'NIT', Colors.red, nitlinks, context),
                _buildActionButton(
                    Icons.article,
                    'Docs',
                    docslinks == "NA" || docslinks == "NULL"
                        ? Colors.brown
                        : Colors.green,
                    docslinks,
                    context),
                _buildActionButton(
                    Icons.edit_note,
                    'Corrigenda',
                    corrigendalinks == "NA" || corrigendalinks == "NULL" ? Colors.brown : Colors.green,
                    corrigendalinks,
                    context),
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

  Widget _buildActionButton(IconData icon, String label, Color color,
      String links, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (label == 'NIT') {
            if (links != 'NA') {
              var fileUrl = links.toString();
              var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
              if (Platform.isIOS) {
                AapoortiUtilities.openPdf(context, fileUrl, fileName);
              } else {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlue[700],
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      AapoortiUtilities.downloadpdf(
                                          fileUrl, fileName, context);
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
                                      AapoortiUtilities.openPdf(
                                          context, fileUrl, fileName);
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
              AapoortiUtilities.showInSnackBar(
                  context, "No PDF attached with this Tender!!");
            }
          } else if (label == 'Docs') {
            if (links == "NA" || links == "NULL") {
              AapoortiUtilities.showInSnackBar(context, "No Documents attached with this Tender!!");
            } else {
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
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: AapoortiUtilities.attachDocsListView(
                                        context, links.toString()),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop('dialog');
                                      },
                                      child: Image(
                                        image: AssetImage(
                                            'images/close_overlay.png'),
                                        height: 50,
                                      )),
                                )
                              ])))));
            }
          } else if (label == 'Corrigenda') {
            if (links.toString() == "NA" || links.toString() == "NULL") {
              AapoortiUtilities.showInSnackBar(
                  context, "No corrigendum issued with this Tender!!");
            } else {
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
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child:
                                          AapoortiUtilities.corrigendumListView(
                                              context, links.toString()),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                        },
                                        child: Image(
                                          image: AssetImage(
                                              'images/close_overlay.png'),
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
              label == 'NIT'
                  ? Image.asset('images/pdf_home.png', height: 30, width: 20)
                  : Icon(icon, color: color),
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
