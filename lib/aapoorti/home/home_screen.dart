import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonParamData.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/aapoorti/helpdesk/problemreport/ReportOpt.dart';
import 'package:flutter_app/aapoorti/home/auction/lease_payment_status/lease_payment_status_screen.dart';
import 'package:flutter_app/aapoorti/home/generate_otp.dart';
import 'package:flutter_app/aapoorti/home/tender/closedra/ClosedRA.dart';
import 'package:flutter_app/aapoorti/provider/aapoorti_language_provider.dart';
import 'package:flutter_app/aapoorti/views/search_po_oz_screen.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:flutter_app/udm/screens/login_screen.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/mmis/helpers/di_services.dart' as di_service;

class HomeScreen extends StatefulWidget {
  static var projectVersion;
  static var isLoading = true;
  final GlobalKey<ScaffoldState> scaffoldKey;
  HomeScreen(this.scaffoldKey);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<dynamic>? jsonResult;
  int? rowCount;
  bool visibilityClosing = true;
  bool visibilityClosed = true;
  bool visibilityLive = true;
  bool visibilityUp = true;
  bool visibilitySched = true;
//---------------COMMON-PARAM-DATA---------------------------------------------//

  String? localCurrVer, globalCurrVer, globalLastAppVer;

  // Future<void> fetchPost() async {
  //   try {
  //     var v = AapoortiConstants.webServiceUrl + 'Common/CommonParam';
  //     List<dynamic> jsonResult;
  //     final response = await http.post(Uri.parse(v));
  //     debugPrint("fetchPost body ${json.decode(response.body)}");
  //     jsonResult = json.decode(response.body);
  //     if(json.decode(response.body).toString() == "[{ErrorCode: 4}]"){
  //       fetchPost();
  //     }
  //     else{
  //       String paramValue = jsonResult.toString();
  //       List paramList = paramValue.split("#");
  //
  //       String ForceUpFlagStr = paramList[0];
  //       List ForceUpFlagVal = ForceUpFlagStr.split("=");
  //       CommonParamData.ForceUpFlagVal = ForceUpFlagVal[1].trim();
  //       //print(ForceUpFlagVal);
  //
  //       String LiveAucCountStr = paramList[1];
  //       List LiveAucCountVal = LiveAucCountStr.split("=");
  //       CommonParamData.LiveAucCountVal = LiveAucCountVal[1].trim();
  //       //print(LiveAucCountVal);
  //
  //       String UpAucCountStr = paramList[3];
  //       List UpAucCountVal = UpAucCountStr.split("=");
  //       CommonParamData.UpAucCountVal = UpAucCountVal[1].trim();
  //       //print(UpAucCountVal);
  //
  //       String AucSchedCountStr = paramList[5];
  //       List AucSchedCountVal = AucSchedCountStr.split("=");
  //       CommonParamData.AucSchedCountVal = AucSchedCountVal[1].trim();
  //       //print(AucSchedCountVal);
  //
  //       String ClosingtodayCountStr = paramList[7];
  //       List ClosingTodayCountVal = ClosingtodayCountStr.split("=");
  //       CommonParamData.ClosingTodayCountVal = ClosingTodayCountVal[1].trim();
  //       //print(ClosingTodayCountVal);
  //
  //       String dashboardUpdateStr = paramList[9];
  //       List dashboardUpdateFlag = dashboardUpdateStr.split("=");
  //       CommonParamData.dashboardUpdateFlag = dashboardUpdateFlag[1].trim();
  //       //print(dashboardUpdateFlag);
  //
  //       String bannedfirmsCountStr = paramList[10];
  //       List bannedFirmsCount = bannedfirmsCountStr.split("=");
  //       CommonParamData.bannedFirmsCount = bannedFirmsCount[1].trim();
  //       //print(bannedFirmsCount);
  //
  //       String closedRACountStr = paramList[11];
  //       List closedRACount = closedRACountStr.split("=");
  //       CommonParamData.closedRACount = closedRACount[1].trim();
  //       //print(closedRACount);
  //
  //       //For pagination starts
  //       String LiveAucPagesStr = paramList[2];
  //       List LiveAucPageVal = LiveAucPagesStr.split("=");
  //       CommonParamData.LiveAucPageVal = LiveAucPageVal[1].trim();
  //       //print(LiveAucPageVal);
  //
  //       String UpAucPagesStr = paramList[4];
  //       List UpAucPageVal = UpAucPagesStr.split("=");
  //       CommonParamData.UpAucPageVal = UpAucPageVal[1].trim();
  //       //print(UpAucPageVal);
  //
  //       String AucSchedPagesStr = paramList[6];
  //       List AucSchedPageVal = AucSchedPagesStr.split("=");
  //       CommonParamData.AucSchedPageVal = AucSchedPageVal[1].trim();
  //       //print(AucSchedPageVal);
  //
  //       String closingTodayPagesStr = paramList[8];
  //       List ClosingTodayPageVal = closingTodayPagesStr.split("=");
  //       CommonParamData.ClosingTodayPageVal = ClosingTodayPageVal[1].trim();
  //       //print(ClosingTodayPageVal);
  //       //For pagination ends
  //       if(this.mounted)
  //         setState(() {
  //           HomeScreen.isLoading = HomeScreen.isLoading & false;
  //         });
  //     }
  //   } on Exception catch (_) {
  //     fetchPost();
  //   }
  // }

  //**********DASHBOARD*****************

  final dbHelper = DatabaseHelper.instance;
  // void fetchPostDS() async {
  //   try {
  //     if(await AapoortiUtilities.check() == false) {
  //       rowCount = await dbHelper.rowCountd();
  //       if (rowCount! > 0) {
  //         debugPrint('Fetching from local DB');
  //         jsonResult = await dbHelper.fetchd();
  //         AapoortiConstants.jsonResult1 = jsonResult!;
  //       }
  //     } else {
  //       var v = AapoortiConstants.webServiceUrl + 'Common/DashboardData';
  //       debugPrint(v);
  //       final response = await http.post(Uri.parse(v));
  //       jsonResult = json.decode(response.body);
  //       AapoortiConstants.jsonResult1 = jsonResult!;
  //       debugPrint("my data 1 ${jsonResult.toString()}");
  //
  //       for (int index = 0; index < jsonResult!.length; index++) {
  //         Map<String, dynamic> row = {
  //           DatabaseHelper.Tbld_Col1_MODULE: jsonResult![index]['MODULE'],
  //           DatabaseHelper.Tbld_Col2_UNIQUEGRAPHID: jsonResult![index]['UNIQUEGRAPHID'],
  //           DatabaseHelper.Tbld_Col3_HEADING: jsonResult![index]['HEADING'],
  //           DatabaseHelper.Tbld_Col4_XAXIS: jsonResult![index]['XAXIS'],
  //           DatabaseHelper.Tbld_Col5_YAXIS: jsonResult![index]['YAXIS'],
  //           DatabaseHelper.Tbld_Col6_LEGEND: jsonResult![index]['LEGEND'],
  //           DatabaseHelper.Tbld_Col7_LASTUPDATEDON: jsonResult![index]['LASTUPDATEDON'],
  //           DatabaseHelper.Tbld_Col9_UPDATEDFLAG: jsonResult![index]['UPDATEDFLAG'],
  //           DatabaseHelper.Tbld_Col8_CREATION_TIME: jsonResult![index]['CREATION_TIME'],
  //         };
  //         final id = dbHelper.insertd(row);
  //       }
  //     }
  //     if (this.mounted)
  //       setState(() {
  //         HomeScreen.isLoading = HomeScreen.isLoading & false;
  //       });
  //   } on Exception catch (_) {}
  // }

  Color getDarkerShade(Color color, String route) {
    if (route == '/e-tender/generate-otp' ||
        route == '/e-tender/closing-today' ||
        route == '/e-auction-1/parcel-payment' ||
        route == '/e-tender/ra-live' ||
        route == '/e-auction-1/published-lot' ||
        route == '/e-auction-1/e-sale') {
      return AapoortiConstants.darkGreen;
    }

    HSLColor hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.5).clamp(0.0, 1.0)).toColor();
  }

  //----------------------------COMMON-PARAM-DATA------------------------------------//
  //Version Control
  var appVersion, sqfliteVersion, webServiceVersion;

  Future<void> fetchVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String version = packageInfo.version;
      localCurrVer = packageInfo.buildNumber;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var v = await Network.postDataWithAPIM('UDMAPPVersion/V1.0.0/UDMAPPVersion', 'UDMAPPVersion', '', prefs.getString('token'));
      //var v = AapoortiConstants.webServiceUrl + 'Common/GetVersionDtls?input=GetVersionDtls,' + version;
      debugPrint(v);
      List<dynamic> jsonResult;
      final response = await http.post(Uri.parse(v));
      jsonResult = json.decode(response.body);

      debugPrint("json result data ${jsonResult.toString()}");
      // if(jsonResult.isEmpty) {
      //   Timer(Duration(seconds: 2), () => Navigator.of(context).pushReplacementNamed("/common_screen"));
      // }
      // else {
      //   int index = 0;
      //   for (index = 0; index < jsonResult.length; index++) {
      //     print(jsonResult[index]["PARAM_NAME"]);
      //     print(jsonResult[index]["PARAM_VALUE"]);
      //
      //     if (jsonResult[index]["PARAM_NAME"].toString() == "Appdaysleft") {
      //       finalDate = jsonResult[index]["PARAM_VALUE"];
      //     }
      //     if(jsonResult[index]["PARAM_NAME"].toString() == "CurrentVersionCode")
      //     {
      //       globalCurrVer = jsonResult[index]["PARAM_VALUE"];
      //       if(globalCurrVer?.compareTo(localCurrVer!) == 0) {
      //         Timer(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CommonScreen())));
      //       }
      //     }
      //     if (jsonResult[index]["PARAM_NAME"].toString() == "LastVersionCode") {
      //       globalLastAppVer = jsonResult[index]["PARAM_VALUE"];
      //       if (globalLastAppVer?.compareTo(localCurrVer!) == 0) {
      //         var now = DateTime.now();
      //         DateTime finalDatecomp = DateTime.parse(finalDate);
      //         print(now.toIso8601String());
      //         print(finalDatecomp.toIso8601String());
      //         if(now.toIso8601String().compareTo(finalDatecomp.toIso8601String()) > 0) {
      //           Navigator.of(context).pop();
      //           _showVersionDDialog(context);
      //         } else {
      //           _showVersionDialog(context);
      //           count = 1;
      //         }
      //       }
      //       print("daman");
      //       print(globalLastAppVer);
      //       print(localCurrVer);
      //
      //       print(int.parse(globalLastAppVer!) > int.parse(localCurrVer!));
      //
      //       if (int.parse(globalLastAppVer!) > int.parse(localCurrVer!)) {
      //         _showVersionDDialog(context);
      //       }
      //     }
      //   }
      //   if((index == jsonResult.length) && !(int.parse(globalLastAppVer!) > int.parse(localCurrVer!))) if (count == 1) {}
      //   else {
      //     count = 0;
      //     Timer(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CommonScreen())));
      //   }
      // }
    } catch (e) {
      Timer(Duration(seconds: 2), () => Navigator.of(context).pushReplacementNamed("/common_screen"));
      debugPrint("splash screen exception ${e.toString()}");
    }
  }

  void versionControl() async {
    //final dbhelper = DatabaseHelper.instance;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.buildNumber;
    debugPrint("appVersion = " + appVersion);
    HomeScreen.projectVersion =
        "${packageInfo.version}(${packageInfo.buildNumber})";
    AapoortiUtilities.version = HomeScreen.projectVersion;
    debugPrint("Version = " + HomeScreen.projectVersion);
  }

  //AnimationController? _controller;
  //Animation<double>? _animation;

  //----------------
  late AnimationController _animationController;
  late Animation<Offset> _leftButtonAnimation;
  late Animation<Offset> _rightButtonAnimation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final mobileController = TextEditingController();

  void _countvisible(bool visibility, String field) {
    setState(() {
      if(field == "fetched") {
        visibilityClosing = visibility;
        visibilityClosed = visibility;
        visibilityLive = visibility;
        visibilityUp = visibility;
        visibilitySched = visibility;
      } else {
        visibilityClosing = false;
        visibilityClosed = false;
        visibilityLive = false;
        visibilityUp = false;
        visibilitySched = false;
      }
    });
  }

  void requestWritePermission() async {
    PermissionStatus permissionStatus = await Permission.storage.request();
    if(permissionStatus != true) {
      debugPrint("status  not true");
      bool isshown = await Permission.storage.shouldShowRequestRationale;
      debugPrint(isshown.toString());

      Map<Permission, PermissionStatus> permissions = await [Permission.storage].request();
      if (this.mounted) setState(() {});
    } else {
      if(this.mounted)
        setState(() {});
    }
  }

//----------------------------EXIT-APP-SHEET------------------------------------//
  void _onBackPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 150,
            child: Container(
              child: _buildBottomNavigationMenu(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Column _buildBottomNavigationMenu() {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 20)),
        Text(
          "Do you want to exit from application?",
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 40.0, top: 30.0)),
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "No",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              color: AapoortiConstants.primary,
              minWidth: 150,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0, top: 40.0)),
            MaterialButton(
              onPressed: () => SystemNavigator.pop(),
              //exit(0)/*Navigator.of(context).pop(true)*/,
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              color: AapoortiConstants.primary,
              minWidth: 150,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 65.0, top: 40.0)),
            MaterialButton(
              child: Text("Rate Us",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              onPressed: () {
                AapoortiUtilities.openStore(context);
                // LaunchReview.launch(
                //   //StoreRedirect.redirect(
                //   androidAppId: "in.gov.ireps",
                //   iOSAppId: "1462024189",
                // );
              },
            ),
            Padding(padding: EdgeInsets.only(left: 70.0, top: 40.0)),
            MaterialButton(
              onPressed: () {
                ReportaproblemOpt.rec = "0";
                Navigator.pushNamed(context, "/report");
              },
              child: Text("Report Problem",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            )
          ],
        )
      ],
    );
  }
//----------------------------EXIT-APP-SHEET------------------------------------//

  //----------------------------IMAGE-SLIDESHOW------------------------------------//
  //CarouselSlider? carouselSlider;
  //final CarouselController carouselController = CarouselController();
  int _current = 0;
  List imgList = [
    'assets/vandebharat.jpg',
    'assets/image22.png',
    'assets/image29.jpg',
    'assets/image32.jpg',
    'assets/image36.png',
    'assets/image40.png',
  ];

  List<Map<String, String>> etenderitems(BuildContext context) {
    AapoortiLanguageProvider language = Provider.of<AapoortiLanguageProvider>(context);
    return [
      {"image": "assets/search.png", "text": language.text('customsearch')},
      {"image": "assets/closingtoday.png", "text": language.text('closingtoday')},
      {"image": "assets/pohome.jpeg", "text": language.text('tenderstatus')},
      {"image": "assets/highvaluetender.png", "text": language.text('highvaluetender')},
      {"image": "assets/live.png", "text": language.text('rlu')},
      {"image": "assets/closed_tender_login.png", "text": language.text('raclosed')},
      {"image": "assets/search_po_z.png", "text": language.text('searchpo')},
      {"image": "assets/images/phoneotp.png", "text": language.text('generateotp')},
    ];
  }

  // final List<Map<String, String>> etenderitems = [
  //   {"image": "assets/search.png", "text": "Custom\nSearch"},
  //   {"image": "assets/closingtoday.png", "text": "Closing\nToday"},
  //   {"image": "assets/pohome.jpeg", "text": "Tender\nStatus"},
  //   {"image": "assets/highvaluetender.png", "text": "High Value\nTender"},
  //   {"image": "assets/live.png", "text": "Live &\nUpcoming-RA"},
  //   {"image": "assets/closed_tender_login.png", "text": "Closed-RA"},
  //   {"image": "assets/search_po_z.png", "text": "Search PO"},
  //   {"image": "assets/images/phoneotp.png", "text": "Generate\nOTP"},
  // ];

  final List<Map<String, String>> eauctionitems = [
    {"image": "assets/bill.png", "text": "Parcel Payment"},
    {"image": "assets/radio.png", "text": "Live"},
    {"image": "assets/live.png", "text": "Upcoming"},
    {"image": "assets/vpl.png", "text": "Published Lot"},
    {"image": "assets/closingtoday.png", "text": "Schedules"},
    {"image": "assets/search.png", "text": "Lot Search"},
    {"image": "assets/pdf.png", "text": "e-Sale Condition"},
    {"image": "assets/pdf.png", "text": "Auctioning Units"},
  ];

  ProgressDialog? pr;

  @override
  void initState() {
    super.initState();
    //this.fetchPost();
    //this.fetchPostDS();
    //fetchVersion();
    requestWritePermission();
    //version-control
    versionControl();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1400), // Animation duration
      vsync: this,
    );

    // Define the animations for the buttons
    _leftButtonAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start off-screen to the left
      end: const Offset(0.0, 0.0),    // End at the center
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Smooth easing for the animation
    ));

    _rightButtonAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start off-screen to the right
      end: const Offset(0.0, 0.0),   // End at the center
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Smooth easing for the animation
    ));

    // Start the animation when the screen is loaded
    _animationController.forward();

    pr = ProgressDialog(context);

    //_showOverlay(context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchPostBF();
    fetchLoginDtls();
  }

  @override
  void dispose() {
    //_controller!.dispose();
    _animationController.dispose(); // Dispose the animation controller
    mobileController.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, String route, AapoortiLanguageProvider language) {
      if (route == '/e-tender/custom-search') {
        Navigator.pushNamed(context, "/custom");
      }
      else if (route == '/e-tender/closing-today') {
        if (CommonParamData.ClosingTodayCountVal == "0") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Presently there is no tender closing today!"),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.redAccent[100]));
        } else {
          Navigator.pushNamed(context, "/closing_today");
        }
      }
      else if (route == '/e-tender/tender-status') {
        Navigator.pushNamed(context, "/tender_status");
      }
      else if (route == '/e-tender/high-value'){
        Navigator.pushNamed(context, "/high_tender");
      }
      else if(route == '/e-tender/ra-live'){
        Navigator.pushNamed(context, "/live_upcoming_ra");
      }
      else if(route == '/e-tender/ra-closed'){
        if(CommonParamData.closedRACount == "0") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Presently there is no closed RA!"), duration: const Duration(seconds: 1), backgroundColor: Colors.redAccent[100]));
        }
        else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CloseRA()));
        }
      }
      else if(route == '/e-tender/search-po'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPoOtherZonalScreen()));
      }
      else if(route == '/e-tender/generate-otp'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateOtpScreen()));
      }
      else if(route == '/e-auction-1/parcel-payment'){
        Navigator.pushNamed(context, LeasePaymentStatus.routeName);
      }
      else if(route == '/e-auction-1/live'){
        if (CommonParamData.LiveAucCountVal == "0") {
          AapoortiUtilities.showInSnackBar(context, "Presently there is no Live Auction!");
        } else{
          Navigator.pushNamed(context, "/live_auction");
        }
      }
      else if(route == '/e-auction-1/upcoming'){
        if(CommonParamData.UpAucCountVal == "0") {
          AapoortiUtilities.showInSnackBar(context, "Presently there is no Upcoming Auction!");
        } else{
          Navigator.pushNamed(context, "/upcoming");
        }
      }
      else if(route == '/e-auction-1/published-lot'){
        Navigator.pushNamed(context, "/published_lot");
      }
      else if(route == '/e-auction-1/schedules') {
        if(CommonParamData.AucSchedCountVal == "0") {
          AapoortiUtilities.showInSnackBar(context, "Presently there is no auction scheduled!");
        }
        else{
          Navigator.pushNamed(context, "/schedule");
        }
      }
      else if(route == '/e-auction-1/lot-search'){
        Navigator.pushNamed(context, "/lot_search");
      }
      else if(route == '/e-auction-1/e-sale'){
        var fileUrl = "https://www.ireps.gov.in/ireps/upload/resources/Uniform_E_Sale_condition.pdf";
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
                            Expanded(
                              child: Text(
                                '${language.text('cof')}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
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
                          language.text('esalecond'),
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
                                fixedSize: Size(85, 40),
                                backgroundColor: Colors.lightBlue[700],
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                AapoortiUtilities.downloadpdf(fileUrl, fileName, context);
                              },
                              child: Text(language.text('dwnd')),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(85, 40),
                                backgroundColor: Colors.lightBlue[700],
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                AapoortiUtilities.openPdf(context, fileUrl, fileName);
                              },
                              child: Text(language.text('open')),
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
      else if(route == '/e-auction-1/auction-units'){
        var fileUrl = "https://www.ireps.gov.in/ireps/upload/resources/DepotContactDetails.pdf";
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
                            Expanded(
                              child: Text(
                                '${language.text('cof')}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
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
                          language.text('aucunitsd'),
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
                                fixedSize: Size(85, 40),
                                backgroundColor: Colors.lightBlue[700],
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                AapoortiUtilities.downloadpdf(fileUrl, fileName, context);
                              },
                              child: Text(language.text('dwnd')),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(85, 40),
                                backgroundColor: Colors.lightBlue[700],
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                AapoortiUtilities.openPdf(context, fileUrl, fileName);
                              },
                              child: Text(language.text('open')),
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

      //--- UDM & CRIS MMIS -----
      else if(route == '/udm'){
        Navigator.pushNamed(context, LoginScreen.routeName);
      }
      else if(route == '/cris-mmis'){
        Get.toNamed(Routes.loginScreen);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen()));
      }
  }


  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final dbhelper = DatabaseHelper.instance;
  List<dynamic>? jsonResult1;
  void fetchLoginDtls() async {
    int? n = await dbhelper.rowCountLoginUser();
    AapoortiConstants.n = n!;
    debugPrint("Login row count = " + n.toString());
    if (n > 0) {
      List<dynamic> tblResult = await dbhelper.fetchLoginUser();
      List<dynamic> tb2Result = await dbhelper.fetchSaveLoginUser();
      AapoortiConstants.loginUserEmailID = tblResult[0]['EmailId'].toString();
      AapoortiConstants.hash = tb2Result[0]['Hash'].toString();
      AapoortiConstants.date = tb2Result[0]['Date'].toString();
      AapoortiConstants.ans = tb2Result[0]['Ans'].toString();
      AapoortiConstants.check = tb2Result[0]['Log'].toString();

      debugPrint('Value from table = ' +
          tblResult[0]['EmailId'].toString() +
          "  ,  " +
          tblResult[0]['LoginFlag'].toString() +
          " , " +
          tb2Result[0]['Hash'].toString() +
          " , " +
          tb2Result[0]['Date'].toString() +
          " , " +
          tb2Result[0]['Ans'].toString() +
          " , " +
          tb2Result[0]['Log'].toString());
      if (tblResult[0]['LoginFlag'].toString() == "1") {
        AapoortiUtilities.loginflag = true;
        debugPrint("login flag " + tblResult[0]['LoginFlag'].toString());
      } else {
        debugPrint("tb result-------------------------" + tblResult[0]['LoginFlag'].toString());
      }
    }
  }

  void fetchPostBF() async {
    rowCount = await dbhelper.rowCountBanned();
    if (rowCount! > 0) {
      jsonResult1 = await dbhelper.fetchBanned();
      debugPrint("fetchBanned ${jsonResult1.toString()}");
      AapoortiConstants.jsonResult2 = jsonResult1!;
      AapoortiConstants.count = jsonResult1![0]['Count'];
      AapoortiConstants.date2 = jsonResult1![0]['Date1'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AapoortiLanguageProvider language = Provider.of<AapoortiLanguageProvider>(context);
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.white30,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(language.text('etender')),
                  const SizedBox(height: 8),
                  _buildGridSection([
                    GridItem(language.text('customsearch'), Icons.tune, AapoortiConstants.cardColor1, '/e-tender/custom-search', true),
                    GridItem(language.text('closingtoday'), Icons.event_available, AapoortiConstants.cardColor2, '/e-tender/closing-today', true),
                    GridItem(language.text('tenderstatus'), Icons.pending_actions, AapoortiConstants.cardColor3, '/e-tender/tender-status', true),
                    GridItem(language.text('highvaluetender'), Icons.bar_chart, AapoortiConstants.cardColor1, '/e-tender/high-value', true),
                    GridItem(language.text('rlu'), Icons.stream, AapoortiConstants.cardColor2, '/e-tender/ra-live', true),
                    GridItem(language.text('raclosed'), Icons.lock_clock, AapoortiConstants.cardColor3, '/e-tender/ra-closed', true),
                    GridItem(language.text('searchpo'), Icons.find_in_page, AapoortiConstants.cardColor1, '/e-tender/search-po', true),
                    GridItem(language.text('generateotp'), 'OTP', AapoortiConstants.cardColor2, '/e-tender/generate-otp', true, isText: true),
                  ], 0, language, scale: 0.9),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: AapoortiConstants.dividerColor, height: 3.0, thickness: 5.0),
                  ),

                  _buildSectionTitle(language.text('els')),
                  const SizedBox(height: 8),
                  _buildGridSection([
                    GridItem(language.text('parcelpymt'), Icons.inventory_2, AapoortiConstants.cardColor2, '/e-auction-1/parcel-payment', true),
                    GridItem(language.text('liveauc'), Icons.sensors, AapoortiConstants.cardColor3, '/e-auction-1/live', true),
                    GridItem(language.text('upcomingauction'), Icons.upcoming, AapoortiConstants.cardColor1, '/e-auction-1/upcoming', true),
                    GridItem(language.text('publishedauc'), Icons.preview, AapoortiConstants.cardColor2, '/e-auction-1/published-lot', true),
                    GridItem(language.text('secheduleauc'), Icons.event_note, AapoortiConstants.cardColor3, '/e-auction-1/schedules', true),
                    GridItem(language.text('lotsearch'), Icons.grid_view, AapoortiConstants.cardColor1, '/e-auction-1/lot-search', true),
                    GridItem(language.text('esalecon'), Icons.document_scanner, AapoortiConstants.cardColor2, '/e-auction-1/e-sale', true),
                    GridItem(language.text('aucunits'), Icons.device_hub, AapoortiConstants.cardColor3, '/e-auction-1/auction-units', true),
                  ], 1, language, scale: 0.86),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60,
            child: Container(
              color: AapoortiConstants.backgroundLight,
            ),
          ),

          Positioned(
            left: 10,
            right: 10,
            bottom: 5,
            child: Row(
              children: [
                Expanded(
                  child: _buildModuleButton(
                    language.text('udmtitle'), () => _navigateToPage(context, '/udm', language),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModuleButton(
                    language.text('crismmistitle'), () => _navigateToPage(context, '/cris-mmis', language),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // return Container(
    //   height: size.height,
    //   width: size.width,
    //   child: ListView(
    //     children: <Widget>[
    //       Container(
    //         child: Column(
    //           children: <Widget>[
    //             Card(
    //               elevation: 0,
    //               color: Colors.white,
    //               surfaceTintColor: Colors.transparent,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(5),
    //                 side: BorderSide(width: 1, color: Colors.grey[300]!),
    //               ),
    //               child: Column(
    //                 children: <Widget>[
    //                   Container(
    //                     height: 40,
    //                     width: MediaQuery.of(context).size.width,
    //                     padding: EdgeInsets.only(left: 5.0),
    //                     alignment: Alignment.centerLeft,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.only(
    //                           topLeft: Radius.circular(8.0),
    //                           topRight: Radius.circular(8.0)),
    //                       color: Colors.cyan[700],
    //                     ),
    //                     child: Text(
    //                       'E-Tender',
    //                       style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 15,
    //                           fontWeight: FontWeight.bold),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                   SizedBox(height: 10),
    //                   Container(
    //                     height: size.height * 0.30,
    //                     width: size.width,
    //                     child: GridView.builder(
    //                         padding: EdgeInsets.zero,
    //                         physics: NeverScrollableScrollPhysics(),
    //                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                           childAspectRatio: 0.85,
    //                           crossAxisCount: 4, // Number of items per row
    //                           crossAxisSpacing: 0.0, // Horizontal space between items
    //                           mainAxisSpacing: 16.0, // Vertical space between items
    //                         ),
    //                         itemCount: etenderitems.length,
    //                         itemBuilder: (context, index) {
    //                           return InkWell(
    //                             child: Column(
    //                               children: <Widget>[
    //                                 Card(
    //                                   elevation: 0,
    //                                   color: Colors.white,
    //                                   surfaceTintColor: Colors.transparent,
    //                                   shape: RoundedRectangleBorder(
    //                                     borderRadius: BorderRadius.circular(3),
    //                                     side: BorderSide(
    //                                       width: 1,
    //                                       color: Colors.white,
    //                                     ),
    //                                   ),
    //                                   child: Column(
    //                                     children: <Widget>[
    //                                       SizedBox(height: 5.0),
    //                                       Image.asset(
    //                                           etenderitems[index]['image']!,
    //                                           width: 30,
    //                                           height: 30),
    //                                       SizedBox(height: 5.0),
    //                                       Row(
    //                                         mainAxisAlignment: MainAxisAlignment.center,
    //                                         crossAxisAlignment: CrossAxisAlignment.center,
    //                                         children: [
    //                                           Expanded(child: Text(
    //                                               etenderitems[index]['text']! == "Closing\nToday" ? 'Closing\nToday(${CommonParamData.ClosingTodayCountVal.trim()})' :
    //                                               etenderitems[index]['text']! == "Closed-RA" ? 'Closed-RA\n(${CommonParamData.closedRACount.replaceAll("}]", "")})' : etenderitems[index]['text']!,
    //                                               textAlign: TextAlign.center,
    //                                               overflow: TextOverflow.ellipsis,
    //                                               maxLines: 3,
    //                                               style: TextStyle(color: Colors.black, fontSize: 12)))
    //                                         ],
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                             onTap: () async {
    //                               bool check = await AapoortiUtilities.checkConnection();
    //                               if (check == true) {
    //                                 if (etenderitems[index]['text'] == "Custom\nSearch") {
    //                                   Navigator.pushNamed(context, "/custom");
    //                                 }
    //                                 else if(etenderitems[index]['text'] == "Closing\nToday") {
    //                                   if(CommonParamData.ClosingTodayCountVal.trim() == "") {
    //                                     this.fetchPost();
    //                                     if(CommonParamData.ClosingTodayCountVal.trim() != "") {
    //                                       this.fetchPost();
    //                                       _countvisible(true, "fetched");
    //                                     }
    //                                     ScaffoldMessenger.of(context)
    //                                         .showSnackBar(SnackBar(
    //                                       content: Text("Please try again!"),
    //                                       duration: const Duration(seconds: 1),
    //                                       backgroundColor:
    //                                           Colors.redAccent[100],
    //                                     ));
    //                                   } else {
    //                                     if (CommonParamData.ClosingTodayCountVal == "0") {
    //                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                                         content: Text("Presently there is no tender closing today!"),
    //                                         duration: const Duration(seconds: 1),
    //                                         backgroundColor: Colors.redAccent[100],
    //                                       ));
    //                                     } else
    //                                       Navigator.pushNamed(context, "/closing_today");
    //                                   }
    //                                 }
    //                                 else if(etenderitems[index]['text'] == "Tender\nStatus"){
    //                                   Navigator.pushNamed(context, "/tender_status");
    //                                 }
    //                                 else if(etenderitems[index]['text'] == "High Value\nTender"){
    //                                   Navigator.pushNamed(context, "/high_tender");
    //                                 }
    //                                 else if(etenderitems[index]['text'] ==  "Live &\nUpcoming-RA"){
    //                                   Navigator.pushNamed(context, "/live_upcoming_ra");
    //                                 }
    //                                 else if(etenderitems[index]['text'] == "Closed-RA"){
    //                                   if(CommonParamData.closedRACount.trim() == "") {
    //                                      if(CommonParamData.closedRACount.trim() != "") {
    //                                        _countvisible(true, "fetched");
    //                                      }
    //                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please try again!"), duration: const Duration(seconds: 1), backgroundColor: Colors.redAccent[100],));
    //                                      }
    //                                      else {
    //                                        if(CommonParamData.closedRACount == "0") {
    //                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                                                         content: Text("Presently there is no closed RA!"),
    //                                                         duration: const Duration(seconds: 1),
    //                                                         backgroundColor: Colors.redAccent[100],
    //                                             ));
    //                                          }
    //                                          else
    //                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CloseRA()));
    //                                     }
    //                                 }
    //                                 else if(etenderitems[index]['text'] == "Search PO"){
    //                                   Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPoOtherZonalScreen()));
    //                                 }
    //                                 else if(etenderitems[index]['text'] == "Generate\nOTP"){
    //                                   Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateOtpScreen()));
    //                                 }
    //                               }
    //                               else {
    //                                 Navigator.push(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                         builder: (context) =>
    //                                             NoConnection()));
    //                               }
    //                             },
    //                           );
    //                         }),
    //                   )
    //                 ],
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   //Left Button with animation
    //                   SlideTransition(
    //                     position: _leftButtonAnimation,
    //                     child: ElevatedButton(
    //                       onPressed: () {
    //                         Navigator.pushNamed(context, LoginScreen.routeName);
    //                       },
    //                       style: ElevatedButton.styleFrom(
    //                         foregroundColor: Colors.white,
    //                         backgroundColor: Colors.red.shade300, // Text color
    //                         padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
    //                         shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(10), // Rounded corners
    //                         ),
    //                         side: const BorderSide(color: Colors.black, width: 1), // Border
    //                         elevation: 10, // Elevation for shadow effect
    //                       ),
    //                       child: const Text('UDM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    //                     ),
    //                   ),
    //
    //                   // Right Button with animation
    //                   SlideTransition(
    //                     position: _rightButtonAnimation,
    //                     child: ElevatedButton(
    //                       onPressed: (){
    //                          //Get.toNamed(Routes.performanceDB);
    //                          //await di_service.init();
    //                          Get.toNamed(Routes.loginScreen);
    //                         //Get.toNamed(Routes.homeScreen);
    //                       },
    //                       style: ElevatedButton.styleFrom(
    //                         foregroundColor: Colors.white,
    //                         backgroundColor: Colors.indigo.shade600,
    //                         padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
    //                         shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(10), // Rounded corners
    //                         ),
    //                         side: const BorderSide(color: Colors.black, width: 1), // Border
    //                         elevation: 10, // Elevation for shadow effect
    //                       ),
    //                       child: const Text('CRIS MMIS',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Card(
    //               elevation: 0,
    //               color: Colors.white,
    //               surfaceTintColor: Colors.transparent,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(5),
    //                 side: BorderSide(width: 1, color: Colors.grey[300]!),
    //               ),
    //               child: Column(
    //                 children: <Widget>[
    //                   Container(
    //                     height: 40,
    //                     width: MediaQuery.of(context).size.width,
    //                     padding: EdgeInsets.only(left: 5.0),
    //                     alignment: Alignment.centerLeft,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.only(
    //                           topLeft: Radius.circular(8.0),
    //                           topRight: Radius.circular(8.0)),
    //                       color: Colors.cyan[700],
    //                     ),
    //                     child: Text(
    //                       'E-Auction (Leasing & Sale)',
    //                       style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 15,
    //                           fontWeight: FontWeight.bold),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                   SizedBox(height: 10),
    //                   Container(
    //                     height: size.height * 0.30,
    //                     width: size.width,
    //                     child: GridView.builder(
    //                         padding: EdgeInsets.zero,
    //                         physics: NeverScrollableScrollPhysics(),
    //                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                           childAspectRatio: 0.85,
    //                           crossAxisCount: 4, // Number of items per row
    //                           crossAxisSpacing: 0.0, // Horizontal space between items
    //                           mainAxisSpacing: 16.0, // Vertical space between items
    //                         ),
    //                         itemCount: eauctionitems.length,
    //                         itemBuilder: (context, index) {
    //                           return InkWell(
    //                             child: Column(
    //                               children: <Widget>[
    //                                 Card(
    //                                   elevation: 0,
    //                                   color: Colors.white,
    //                                   surfaceTintColor: Colors.transparent,
    //                                   shape: RoundedRectangleBorder(
    //                                     borderRadius: BorderRadius.circular(3),
    //                                     side: BorderSide(
    //                                       width: 1,
    //                                       color: Colors.white,
    //                                     ),
    //                                   ),
    //                                   child: Column(
    //                                     children: <Widget>[
    //                                       SizedBox(height: 5.0),
    //                                       Image.asset(
    //                                           eauctionitems[index]['image']!,
    //                                           width: 30,
    //                                           height: 30),
    //                                       SizedBox(height: 5.0),
    //                                       Row(
    //                                         mainAxisAlignment: MainAxisAlignment.center,
    //                                         crossAxisAlignment: CrossAxisAlignment.center,
    //                                         children: [
    //                                           Expanded(child: Text(
    //                                               eauctionitems[index]['text']! == "Live" ? 'Live\n(${CommonParamData.LiveAucCountVal.trim()})' :
    //                                               eauctionitems[index]['text']! == "Upcoming" ? 'Upcoming\n(${CommonParamData.UpAucCountVal.trim()})' :
    //                                               eauctionitems[index]['text']! == "Schedules" ? 'Schedules\n(${CommonParamData.AucSchedCountVal.trim()})' : eauctionitems[index]['text']!,
    //                                               textAlign: TextAlign.center,
    //                                               overflow: TextOverflow.ellipsis,
    //                                               maxLines: 3,
    //                                               style: TextStyle(
    //                                                   color: Colors.black,
    //                                                   fontSize: 12)))
    //                                         ],
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                             onTap: () async {
    //                               bool check = await AapoortiUtilities.checkConnection();
    //                               if (check == true) {
    //                                 if (eauctionitems[index]['text'] == "Parcel Payment") {
    //                                   Navigator.pushNamed(context, LeasePaymentStatus.routeName);
    //                                   //Navigator.pushNamed(context, "/custom");
    //                                 }
    //                                 else if(eauctionitems[index]['text'] == "Live") {
    //                                   if (CommonParamData.LiveAucCountVal
    //                                       .trim() ==
    //                                       "") {
    //                                     this.fetchPost();
    //                                     if (CommonParamData.LiveAucCountVal
    //                                         .trim() !=
    //                                         "") {
    //                                       this.fetchPost();
    //                                       _countvisible(true, "fetched");
    //                                     }
    //                                     ScaffoldMessenger.of(context)
    //                                         .showSnackBar(SnackBar(
    //                                       content: Text("Please try again!"),
    //                                       duration: const Duration(seconds: 1),
    //                                       backgroundColor: Colors.redAccent[100],
    //                                     ));
    //                                   } else {
    //                                     if (CommonParamData.LiveAucCountVal ==
    //                                         "0") {
    //                                       ScaffoldMessenger.of(context)
    //                                           .showSnackBar(SnackBar(
    //                                         content: Text(
    //                                             "Presently there is no Live Auction!"),
    //                                         duration: const Duration(seconds: 1),
    //                                         backgroundColor:
    //                                         Colors.redAccent[100],
    //                                       ));
    //                                     } else
    //                                       Navigator.pushNamed(
    //                                           context, "/live_auction");
    //                                   }
    //                                 }
    //                                 else if(eauctionitems[index]['text'] == "Upcoming") {
    //                                   if (CommonParamData.UpAucCountVal.trim() == "") {
    //                                     this.fetchPost();
    //                                     if(CommonParamData.UpAucCountVal.trim() != "") {
    //                                       this.fetchPost();
    //                                       _countvisible(true, "fetched");
    //                                     }
    //                                     ScaffoldMessenger.of(context)
    //                                         .showSnackBar(SnackBar(
    //                                       content: Text("Please try again!"),
    //                                       duration: const Duration(seconds: 1),
    //                                       backgroundColor: Colors.redAccent[100],
    //                                     ));
    //                                   } else {
    //                                     if (CommonParamData.UpAucCountVal ==
    //                                         "0") {
    //                                       ScaffoldMessenger.of(context)
    //                                           .showSnackBar(SnackBar(
    //                                         content: Text(
    //                                             "Presently there is no Upcoming Auction!"),
    //                                         duration: const Duration(seconds: 1),
    //                                         backgroundColor:
    //                                         Colors.redAccent[100],
    //                                       ));
    //                                     } else
    //                                       Navigator.pushNamed(context, "/upcoming");
    //                                   }
    //                                 }
    //                                 else if(eauctionitems[index]['text'] == "Published Lot"){
    //                                   Navigator.pushNamed(context, "/published_lot");
    //                                 }
    //                                 else if(eauctionitems[index]['text'] ==  "Schedules"){
    //                                   if (CommonParamData.AucSchedCountVal
    //                                       .trim() ==
    //                                       "") {
    //                                     this.fetchPost();
    //                                     if (CommonParamData.AucSchedCountVal
    //                                         .trim() !=
    //                                         "") {
    //                                       this.fetchPost();
    //                                       _countvisible(true, "fetched");
    //                                     }
    //                                     ScaffoldMessenger.of(context)
    //                                         .showSnackBar(SnackBar(
    //                                       content: Text("Please try again!"),
    //                                       duration: const Duration(seconds: 1),
    //                                       backgroundColor: Colors.redAccent[100],
    //                                     ));
    //                                   } else {
    //                                     if (CommonParamData.AucSchedCountVal ==
    //                                         "0") {
    //                                       ScaffoldMessenger.of(context)
    //                                           .showSnackBar(SnackBar(
    //                                         content: Text(
    //                                             "Presently there is no auction scheduled!"),
    //                                         duration: const Duration(seconds: 1),
    //                                         backgroundColor:
    //                                         Colors.redAccent[100],
    //                                       ));
    //                                     } else
    //                                       Navigator.pushNamed(
    //                                           context, "/schedule");
    //                                 }}
    //                                 else if(eauctionitems[index]['text'] == "Lot Search"){
    //                                   Navigator.pushNamed(context, "/lot_search");
    //                                 }
    //                                 else if(eauctionitems[index]['text'] == "e-Sale Condition"){
    //                                   var fileUrl = "https://www.ireps.gov.in//ireps/upload/resources/Uniform_E_Sale_condition.pdf";
    //                                   var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
    //                                   AapoortiUtilities.ackAlert(context, fileUrl, fileName);
    //                                 }
    //                                 else if(eauctionitems[index]['text'] == "Auctioning Units"){
    //                                   var fileUrl = "https://www.ireps.gov.in//ireps/upload/resources/DepotContactDetails.pdf";
    //                                   var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
    //                                   AapoortiUtilities.ackAlert(context, fileUrl, fileName);
    //                                 }
    //                               }
    //                               else {
    //                                 Navigator.push(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                         builder: (context) =>
    //                                             NoConnection()));
    //                               }
    //                             },
    //                           );
    //                         }),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  Widget _buildModuleButton(String title, VoidCallback onTap) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF37E5B), // Changed from primary to orange using the accent color
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(GridItem item, int index, double scale, AapoortiLanguageProvider language) {
    final titleParts = item.title.split('\n');
    return InkWell(
      onTap: () async{
        bool connectionstatus = await AapoortiUtilities.check();
        if(connectionstatus){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
          if(providedTime.isBefore(DateTime.now())){
            await fetchToken(context);
            _navigateToPage(context, item.route, language);
          }
          else{
            _navigateToPage(context, item.route, language);
          }
        }
        else{
          AapoortiUtilities.showInSnackBar(context, "Please check your internet connection!!");
          //Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipPath(
            clipper: CustomCornerClipper(),
            child: Container(
              width: 55 * scale,
              height: 55 * scale,
              decoration: BoxDecoration(
                color: item.backgroundColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: item.isText
                  ? Center(
                child: Text(
                  item.icon as String,
                  style: TextStyle(
                    color: getDarkerShade(item.backgroundColor, item.route),
                    fontSize: 20 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : Icon(
                item.icon as IconData,
                color: getDarkerShade(item.backgroundColor, item.route),
                size: 28 * scale,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2 * scale),
            child: Column(
              children: [
                Text(
                  titleParts[0],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13 * scale,
                    color: AapoortiConstants.textColor,
                    fontWeight: FontWeight.w500,
                    height: 0.9,
                    letterSpacing: -0.2,
                  ),
                ),
                if (titleParts.length > 1) ...[
                  const SizedBox(height: 3),
                  Text(
                    titleParts[1],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13 * scale,
                      color: AapoortiConstants.textColor,
                      fontWeight: FontWeight.w500,
                      height: 0.9,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 25,
          color: AapoortiConstants.primary,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AapoortiConstants.primary,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  Widget _buildGridSection(List<GridItem> items, int sectionIndex, AapoortiLanguageProvider language, {double scale = 1.0}) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 8,
        childAspectRatio: 0.77 * scale,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildGridItem(items[index], sectionIndex * 100 + index, scale, language);
      },
    );
  }
}

void setStateL(Null Function() param0) {}

class GridItem {
  final String title;
  final dynamic icon;
  final Color backgroundColor;
  final String route;
  final bool isMultiLine;
  final bool isText;

  GridItem(this.title, this.icon, this.backgroundColor, this.route, this.isMultiLine, {this.isText = false});
}

class CustomCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final radius = 12.0;
    final smallRadius = 4.0; // Small radius for the previously sharp corners

    // Start from top-left with a small curve
    path.moveTo(smallRadius, 0);
    path.quadraticBezierTo(0, 0, 0, smallRadius);

    // Left side
    path.lineTo(0, h - radius);

    // Bottom-left curve (existing)
    path.quadraticBezierTo(0, h, radius, h);

    // Bottom side
    path.lineTo(w - smallRadius, h);

    // Bottom-right with a small curve
    path.quadraticBezierTo(w, h, w, h - smallRadius);

    // Right side
    path.lineTo(w, radius);

    // Top-right curve (existing)
    path.quadraticBezierTo(w, 0, w - radius, 0);

    // Top side
    path.lineTo(smallRadius, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomCornerClipper oldClipper) => false;
}
