import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/CommonScreen.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:flutter_app/udm/providers/network_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../udm/helpers/shared_data.dart';
import '../../udm/providers/versionProvider.dart';
import '../../udm/screens/pdfVIewForPoSeach.dart';
import '../../udm/widgets/dailog.dart';
import 'AapoortiConstants.dart';
import 'AapoortiUtilities.dart';
import 'DatabaseHelper.dart';
import 'package:flutter_app/udm/helpers/error.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {


  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  List<dynamic>? jsonResult1;
  int? rowCount;
  int count = 0;
  final dbhelper = DatabaseHelper.instance;
  Map<String, String> versionResult = {};

  String? localCurrVer, globalCurrVer, globalLastAppVer;
  var finalDate;
  Error? _error;

  // var app_store_url = 'https://apps.apple.com/in/app/ireps/1462024189';

  var play_store_url = 'https://play.google.com/store/apps/details?id=in.gov.ireps';

  late NetworkProvider? _networkProvider;

  //-------- New variables declared --------
  late AnimationController _controller;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late final Animation<double> _preloaderAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Logo fade-in animation
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Logo scale-up animation
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Text fade-in animation
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Text scale-up animation
    _textScaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );

    _preloaderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward(); // Start the animation

    _networkProvider = Provider.of<NetworkProvider>(context, listen: false);
  }

  @override
  Future<void> didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textScaleAnimation.addStatusListener((status) {
      try {
        if(status == AnimationStatus.completed) {
          if(prefs.containsKey('exp_time')) {
            var expTime = prefs.getString('exp_time');
            var today = DateTime.now();
            DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
            var currentTime = dateFormat.format(today);
            var expTimeformat = dateFormat.format(dateFormat.parse(expTime!));
            if(currentTime.compareTo(expTimeformat) > 0) {
              fetchToken(context).then((value) => checkVersion());
            }
            else {
              Future.delayed(Duration(seconds: 0), () async {
                Navigator.of(context).pushReplacementNamed("/common_screen");
              });
            }
          }
          else {
            fetchToken(context).then((value) => checkVersion());
          }
        }
      }
      catch(e) {
        Timer.run(() => showDialog(
            context: context,
            builder: (_) => CommonDailog(
              title: "Alert!!",
              contentText: "Something went wrong, please try again",
              type: 'Exception',
              action: action,
            )));
      }
    });
    super.didChangeDependencies();
    _networkProvider?.addListener(_handleConnectivityChange);
  }

  // Method to handle connectivity changes
  void _handleConnectivityChange() async{
    if(Provider.of<NetworkProvider>(context, listen: false).status == ConnectivityStatus.Offline) {
      //UdmUtilities.showWarningFlushBar(context, Provider.of<LanguageProvider>(context, listen: false).text('checkconnection'));
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('exp_time')) {
        var expTime = prefs.getString('exp_time');
        var today = DateTime.now();
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        var currentTime = dateFormat.format(today);
        var expTimeformat=dateFormat.format(dateFormat.parse(expTime!));
        if(currentTime.compareTo(expTimeformat) > 0){
          fetchToken(context);
        }
        else{
          Future.delayed(Duration(seconds: 0), () async {
            Navigator.of(context).pushReplacementNamed("/common_screen");
            //Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          });
        }
      }
      else{
        fetchToken(context).then((value) => Provider.of<VersionProvider>(context, listen: false).fetchVersion(context));
      }
    }
  }

  void checkVersion() async{
     try{
       Uri default_url = Uri.parse(IRUDMConstants.downTimeUrl);
       var response = await http.get(default_url);
       if(response.statusCode == 200) {
         Navigator.pop(context);
         Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(IRUDMConstants.downTimeUrl)));
       }
       else {
         await Provider.of<VersionProvider>(context, listen: false).fetchVersion(context);
         _error = Provider.of<VersionProvider>(context, listen: false).error;
         debugPrint("Check Version Error ${_error!.title}");
         if(_error!.title == "Exception") {
           Timer.run(() => showDialog(
               context: context,
               builder: (_) => CommonDailog(
                 title: "Alert!!",
                 contentText: "Something went wrong, please try again",
                 type: 'Exception',
                 action: action,
               )));
         }
         else if(_error!.title.contains("Error")) {
           Timer.run(() => showDialog(
               context: context,
               builder: (_) => CommonDailog(
                 title: "Alert!!",
                 contentText: "Something went wrong, please try again",
                 //title: _error!.title,
                 //contentText: _error!.description,
                 type: 'Error',
                 action: action,
               )));
         }
         else if(_error!.title.contains("Update")) {
           Timer.run(() => showDialog(
               context: context,
               builder: (_) => CommonDailog(
                 title: _error!.title,
                 contentText: _error!.description,
                 type: 'Error',
                 action: action,
               )));
         }
         else if(_error!.title.contains('title2')) {
           Navigator.of(context).pushReplacementNamed('/common_screen');
         }
       }
     }
     on SocketException catch(e){
       debugPrint("CheckVersion internet ${e.toString()}");
       AapoortiUtilities.showInSnackBar(context, "Please check your internet connection!!");
     }
     on HttpException catch(ex){
       debugPrint("Http response exception ${ex.toString()}");
       AapoortiUtilities.showInSnackBar(context, "Something Unexpected happened! Please try again.");
     }
  }

  void action(){
    if(_error!.title.contains('Error')){}
    else if(_error!.title.contains('Exception')){}
    else if(_error!.title.contains('Update')){
      AapoortiUtilities.openStore(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _networkProvider?.removeListener(_handleConnectivityChange);
    super.dispose();
  }

  Future<void> checkConnection() async {
    try {
      var connectivityresult = await Connectivity().checkConnectivity();
      //var connResult = await InternetAddress.lookup('www.google.com').timeout(Duration(seconds: 5));

      if(!connectivityresult.contains(ConnectivityResult.wifi) || !connectivityresult.contains(ConnectivityResult.mobile)){
        _showInternetDialog(context);
      }
    } on SocketException catch (_) {
      _showInternetDialog(context);
    } on TimeoutException catch (_) {
      _showInternetDialog(context);
    }
  }

  Future<void> _showInternetDialog(BuildContext context) async {
    final String title = "Connectivity Error!";
    final String message = "Please check your internet connection.";
    final String btnLabel = "Retry";

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if(Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(btnLabel),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Handle retry logic
                  await checkConnection(); // Consider handling this async operation if needed
                },
              ),
            ],
          );
        }
        else {
          return AlertDialog(
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(
                  btnLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Handle retry logic
                  await checkConnection();
                },
              ),
            ],
          );
        }
      },
    );
  }

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
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlue[800]!,
                  Colors.lightBlue[800]!
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo with fade-in and scale
                      Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Container(
                              height: 90,
                              width:  90,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(45),
                                  color: Colors.white
                              ),
                              child: Image.asset(
                                'assets/nlogo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _textFadeAnimation.value),
                            child: Opacity(
                              opacity: _textFadeAnimation.value,
                              child: const Text(
                                'IREPS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      //const SizedBox(height: 10),
                      const Text(
                        'INDIAN RAILWAYS',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const CircularProgressIndicator(
                        //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        // ),
                        AnimatedBuilder(
                          animation: _preloaderAnimation,
                          builder: (context, child) {
                            return Container(
                              width: double.infinity,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(25),
                                borderRadius: BorderRadius.zero,
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _preloaderAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF6B6B), Color(0xFFFFB746)],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Efficiency - Transparency - Ease of doing business",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

  }
}