import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/ComingSoonLogin.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/aapoorti/helpdesk/problemreport/ReportOpt.dart';
import 'package:flutter_app/aapoorti/localization/languageHelper.dart';
import 'package:flutter_app/aapoorti/login/home/UserHome.dart';
import 'package:flutter_app/aapoorti/provider/aapoorti_language_provider.dart';
import 'package:flutter_app/aapoorti/views/imp_link_screen.dart';
import 'package:flutter_app/aapoorti/widgets/confirm_dialog.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/dashboard/dashboard.dart';
import 'package:flutter_app/aapoorti/helpdesk/contactdetails/helpdesk.dart';
import 'package:flutter_app/aapoorti/home/home_screen.dart';
import 'package:flutter_app/aapoorti/login/Login.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';


class CommonScreen extends StatefulWidget {
  @override
  _CommonScreenState createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget>? _screens;
  int bottomIndex = 0;
  var param;
  String? logOutSucc;
  //This variable is used to stop set param from ModalRoute.of(context).settings.arguments
  var afterLogout = 0;
  String? localCurrVer;
  bool _isEnglish = true;
  String? globalCurrVer, globalLastAppVer;

  late AnimationController _animationController;
  late Animation<double> _animation;

  List<Map<String, dynamic>> _bottomnavData(BuildContext context) {
    AapoortiLanguageProvider language = Provider.of<AapoortiLanguageProvider>(context);
    return [
      {'label': language.text('home'), 'icon': Icons.home},
      {'label': language.text('login'), 'icon': Icons.person_pin},
      {'label': language.text('helpdesk'), 'icon': Icons.help},
      {'label': language.text('links'), 'icon': Icons.link},
    ];
  }

  // final List<Map<String, dynamic>> _bottomnavData = [
  //   {'label': 'Home', 'icon': Icons.home},
  //   {'label': 'Login', 'icon': Icons.person_pin},
  //   {'label': 'Helpdesk', 'icon': Icons.help},
  //   {'label': 'Links', 'icon': Icons.link},
  // ];



  void initState() {
    super.initState();
    //fetchVersion();
    //AapoortiUtilities().versionControl();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _checkLanguage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(afterLogout == 0) {
      param = ModalRoute.of(context)!.settings.arguments ?? [bottomIndex, ''];

      bottomIndex = param[0];
      logOutSucc = param[1].toString();
    }

    _screens = [
      HomeScreen(_scaffoldKey),
      LoginActivity(_scaffoldKey, logOutSucc ?? ''),
      Help(),
      ImplinkScreen()
      //Dashboard(),
    ];
  }

  @override
  void didUpdateWidget(covariant CommonScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  void checkBeforeLogin() async {
    if(Platform.isAndroid) {
      if(AapoortiConstants.ans == "true") {
        AapoortiUtilities.Progress(context);
        if (AapoortiConstants.check == "true" && DateTime.now().toString().compareTo(AapoortiConstants.date) < 0) {
          var jsonResult = null;
          var random = Random.secure();
          String ctoken = random.nextInt(100).toString();

          for (var i = 1; i < 10; i++) {
            ctoken = ctoken + random.nextInt(100).toString();
          }
          Map<String, dynamic> urlinput = {
            "userId": AapoortiConstants.loginUserEmailID,
            "pass": AapoortiConstants.hash,
            "cToken": "$ctoken",
            "sToken": "",
            "os": "Flutter~ios",
            "token4": "",
            "token5": ""
          };

          debugPrint(AapoortiConstants.hash + " <-hash");
          String urlInputString = json.encode(urlinput);
          String paramName = 'UserLogin';

          //Form Body For URL
          String formBody = paramName + '=' + Uri.encodeQueryComponent(urlInputString);

          var url = AapoortiConstants.webServiceUrl + 'Login/UserLogin';
          debugPrint("url = " + url);

          final response = await http.post(Uri.parse(url),
              headers: {
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded"
              },
              body: formBody,
              encoding: Encoding.getByName("utf-8"));
          jsonResult = json.decode(response.body);

          if(response.statusCode == 200) {
            if(jsonResult[0]['ErrorCode'] == null) {
              AapoortiUtilities.ProgressStop(context);
              AapoortiUtilities.setUserDetails(jsonResult); //To save user details in shared object
              AapoortiUtilities.user1 = jsonResult[0]['USER_TYPE'].toString();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome(AapoortiUtilities.user1!, AapoortiConstants.loginUserEmailID)));
            }
            else{
              AapoortiUtilities.ProgressStop(context);
              //AapoortiUtilities.showInSnackBar(context, "Something unexpected happened, please try again!!");
            }
          }
        } else {
          bottomIndex = 1;
        }
      }
      else {
        bottomIndex = 1;
      }
    }
    else {
      if(AapoortiConstants.ans == "true") {
        AapoortiUtilities.Progress(context);
        if (AapoortiConstants.check == "true" && DateTime.now().toString().compareTo(AapoortiConstants.date) < 0) {
          var jsonResult = null;
          var random = Random.secure();
          String ctoken = random.nextInt(100).toString();

          for (var i = 1; i < 10; i++) {
            ctoken = ctoken + random.nextInt(100).toString();
          }
          Map<String, dynamic> urlinput = {
            "userId": AapoortiConstants.loginUserEmailID,
            "pass": AapoortiConstants.hash,
            "cToken": "$ctoken",
            "sToken": "",
            "os": "Flutter~ios",
            "token4": "",
            "token5": ""
          };

          debugPrint(AapoortiConstants.hash + " <-hash");
          String urlInputString = json.encode(urlinput);
          String paramName = 'UserLogin';

          //Form Body For URL
          String formBody = paramName + '=' + Uri.encodeQueryComponent(urlInputString);

          var url = AapoortiConstants.webServiceUrl + 'Login/UserLogin';
          debugPrint("url = " + url);

          final response = await http.post(Uri.parse(url),
           headers: {
            "Accept": "application/json",
             "Content-Type": "application/x-www-form-urlencoded"
          },
              body: formBody,
              encoding: Encoding.getByName("utf-8"));
          jsonResult = json.decode(response.body);
          if(response.statusCode == 200) {
            debugPrint(jsonResult[0]['ErrorCode'].toString());
            if(jsonResult[0]['ErrorCode'] == null) {
              AapoortiUtilities.ProgressStop(context);
              AapoortiUtilities.setUserDetails(jsonResult); //To save user details in shared object
              AapoortiUtilities.user1 = jsonResult[0]['USER_TYPE'].toString();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHome(AapoortiUtilities.user1!, AapoortiConstants.loginUserEmailID)));
            }
            else{
              AapoortiUtilities.ProgressStop(context);
              //AapoortiUtilities.showInSnackBar(context, "Something unexpected happened, please try again!!");
            }
          }
        } else {
          bottomIndex = 1;
        }
      }
      else {
        bottomIndex = 1;
      }
    }
  }

  Future<bool> AapoortiCheckConnection() async {
    bool check = await AapoortiUtilities.checkConnection();
    return check;
  }

  void navigateFunction(int indx) {
    AapoortiUtilities.logoutBanner = false;
    switch (indx) {
      case 0:
        setState(() {
          bottomIndex = indx;
          afterLogout = 1;
        });
        break;
      case 1:
        checkBeforeLogin();
        setState(() {
          bottomIndex = indx;
        });
        break;
      case 2:
        ReportaproblemOpt.rec = "0";
        setState(() {
          bottomIndex = indx;
          afterLogout = 1;
        });
        break;
      case 3:
        AapoortiUtilities.checkConnection().then((check) {
          if(check == true) {
            setState(() {
              bottomIndex = indx;
              afterLogout = 1;
            });
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
          }
        });
        break;

      default:
    }
  }

  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
      if(_isEnglish) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
    _isEnglish ? Provider.of<AapoortiLanguageProvider>(context, listen: false).updateLanguage(Language.English) : Provider.of<AapoortiLanguageProvider>(context, listen: false).updateLanguage(Language.Hindi);
  }

  void _checkLanguage() {
    Language lan = Provider.of<AapoortiLanguageProvider>(context, listen: false).language;
    setState(() {
      Language.Hindi == lan ?  _isEnglish = false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    AapoortiLanguageProvider language = Provider.of<AapoortiLanguageProvider>(context);
    return WillPopScope(
      onWillPop: () async{
        if(bottomIndex != 0) {
          Future.delayed(Duration.zero, () => setState(() {bottomIndex = 0;}));
          return false;
        } else {
           //AapoortiUtilities.alertDialog(context, "IREPS");
           Future.delayed(Duration.zero, () => setState(() {bottomIndex = 0;  afterLogout = 1;}));
           AapoortiUtilities.showAlertDailog(context, "IREPS");
           return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D47A1), // Dark Blue
                  Color(0xFF1976D2), // Lighter Blue
                ],
              ),
            ),
            child: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent, // Make AppBar background transparent
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: _toggleLanguage,
                    child: Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4285F4),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: _isEnglish ? 5 : null,
                            right: _isEnglish ? null : 5,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _isEnglish ? 'A' : 'अ',
                                  style: TextStyle(
                                    color: const Color(0xFF1A73E8),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
              leading: InkWell(
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.grid_view_rounded, color: Colors.white),
                ),
              ),
              title: Text(
                language.text('ireps'),
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(kToolbarHeight),
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         colors: [
        //           Color(0xFF0D47A1), // Dark Blue
        //           Color(0xFF1976D2), // Lighter Blue
        //         ],
        //       ),
        //     ),
        //     child: AppBar(
        //       elevation: 0,
        //       backgroundColor: Colors.transparent, // Make AppBar background transparent
        //       iconTheme: const IconThemeData(color: Colors.white),
        //       leading: InkWell(
        //         onTap: () {
        //           _scaffoldKey.currentState!.openDrawer();
        //         },
        //         child: Container(
        //           margin: const EdgeInsets.all(8),
        //           padding: const EdgeInsets.all(8),
        //           decoration: BoxDecoration(
        //             color: Colors.white.withOpacity(0.2),
        //             borderRadius: BorderRadius.circular(8),
        //           ),
        //           child: const Icon(Icons.grid_view_rounded, color: Colors.white),
        //         ),
        //       ),
        //       title: const Text(
        //         'IREPS',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        backgroundColor: Colors.grey[200],
        drawer: AapoortiUtilities.navigationdrawerbeforLOgin(_scaffoldKey, context),
        body: _screens![bottomIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: bottomIndex,
          onTap: navigateFunction,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          selectedItemColor: Colors.lightBlue[800]!,
          items: List.generate(growable: false, _bottomnavData(context).length, (index) => BottomNavigationBarItem(
                icon: Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bottomIndex == index ? Colors.lightBlue[800]! : Colors.grey[300],
                ),
                child: Icon(
                  _bottomnavData(context)[index]['icon'],
                  size: 24.0,
                  color: bottomIndex == index ? Colors.white : Colors.black,
                ),
              ),
              label: _bottomnavData(context)[index]['label'], // Always display labels
            ),
          )),
        ),
    );
  }
}
