import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/controllers/dashboard_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/extention/extension_util.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/view/components/bottom_Nav/bottom_nav.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/view/screens/dashboard/graph_screen.dart';
import 'package:flutter_app/mmis/view/screens/dashboard/summary_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PerformanceDashBoard extends StatefulWidget {

  @override
  State<PerformanceDashBoard> createState() => _PerformanceDashBoardState();
}

class _PerformanceDashBoardState extends State<PerformanceDashBoard> with SingleTickerProviderStateMixin{

  final controller = Get.put(DashBoardController());

  final themeController =  Get.find<ThemeController>();
  final networkController = Get.put(NetworkController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  List<String> yearRanges = [];

  Widget _buildTab(String text, int index) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
            _tabController.animateTo(index);
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        AapoortiUtilities().showAlertDailog(context, "MMIS");
        //_onBackPressed();
        return true;
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
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.only(right: 8.0),
              //     child: GestureDetector(
              //       onTap: _toggleLanguage,
              //       child: Container(
              //         width: 60,
              //         height: 40,
              //         decoration: BoxDecoration(
              //           color: const Color(0xFF4285F4),
              //           borderRadius: BorderRadius.circular(20),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black.withOpacity(0.2),
              //               blurRadius: 4,
              //               offset: const Offset(0, 2),
              //             ),
              //           ],
              //         ),
              //         child: Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             AnimatedPositioned(
              //               duration: const Duration(milliseconds: 300),
              //               curve: Curves.easeInOut,
              //               left: _isEnglish ? 5 : null,
              //               right: _isEnglish ? null : 5,
              //               child: Container(
              //                 width: 30,
              //                 height: 30,
              //                 decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   shape: BoxShape.circle,
              //                   boxShadow: [
              //                     BoxShadow(
              //                       color: Colors.black.withOpacity(0.1),
              //                       blurRadius: 4,
              //                       offset: const Offset(0, 2),
              //                     ),
              //                   ],
              //                 ),
              //                 child: Center(
              //                   child: Text(
              //                     _isEnglish ? 'A' : 'अ',
              //                     style: TextStyle(
              //                       color: const Color(0xFF1A73E8),
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   )
              // ],
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
                "CRIS MMIS",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        // appBar: AppBar(
        //     backgroundColor: AapoortiConstants.primary,
        //     iconTheme: IconThemeData(color: Colors.white),
        //     centerTitle: true,
        //     title: Text("CRIS MMIS", style : TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic,fontSize: 18.0))),
        drawer: navDrawer(context, _scaffoldKey, controller, themeController),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // TabBar(
              //   unselectedLabelColor: Colors.white,
              //   labelColor: Colors.black,
              //   //indicatorColor: Colors.white,
              //   indicatorSize: TabBarIndicatorSize.tab,
              //   indicatorWeight: 0,
              //   indicatorPadding: EdgeInsets.zero,
              //   isScrollable: false,
              //   padding: EdgeInsets.zero,
              //   onTap: (tabindex) {
              //     //_activeindex = tabindex;
              //   },
              //   indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
              //   controller: _tabController,
              //   tabs: [
              //     Tab(child: Text("Summary")),
              //     Tab(child: Text("Graph"))
              //   ],
              // ),
              Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  children: [
                    _buildTab("Summary", 0),
                    _buildTab("Graph", 1),
                  ],
                ),
              ),
              Expanded(child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    SummaryScreen(),
                    GraphScreen()
                  ]
              ))
            ],
          ),
        ),

      ),
    );
  }
}

Widget navDrawer(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey, DashBoardController dashBoardController, ThemeController themeController) {
  return Drawer(
    child: Column(
      children: [
        Expanded(
          child: Container(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(height: 180.0),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: AapoortiConstants.primary,
                    //image: DecorationImage(image: AssetImage('assets/welcome.jpg'), fit: BoxFit.cover),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed(Routes.profileScreen);
                    },
                    child: Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: AapoortiConstants.primary,
                              ),
                            ),
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            //SizedBox(height: 4.0),
                            Obx(() => Text(
                                dashBoardController.username.value,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0))),
                            SizedBox(height: 2.0),
                            Obx(() => Text(dashBoardController.email.value,
                                style:
                                TextStyle(color: Colors.white, fontSize: 15.0)))
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  height: 2.0,
                ),
                // drawerTile(Iconic.lock, 'changepin'.tr, () {
                //   //Navigator.pop(context);
                //   _scaffoldKey.currentState!.closeDrawer();
                //   Get.toNamed(Routes.changepinScreen);
                // }),
                // drawerTile(Iconic.star, 'rateus'.tr, () {
                //   //Navigator.pop(context);
                //   _scaffoldKey.currentState!.closeDrawer();
                //   AapoortiUtilities.openStore(context);
                // }),
              ],
            ),
          ),
        ),
        Column(
          children: [
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 5.0),
            //     child: Container(
            //       height: 80.0,
            //       width: 80.0,
            //       decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey), borderRadius: BorderRadius.circular(40)),
            //       child: Image.asset('assets/images/crisnew.png', fit: BoxFit.cover, width: 80, height: 80),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 2.0),
            InkWell(
              onTap: () {
                if (_scaffoldKey.currentState!.isDrawerOpen) {
                  _scaffoldKey.currentState!.closeDrawer();
                  AapoortiUtilities().showAlertDailog(context, "MMIS");
                  //_showConfirmationDialog(context);
                  //WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
                  //callWebServiceLogout();
                }
              },
              child: Container(
                height: 45,
                color: AapoortiConstants.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Logout",
                        style: TextStyle(fontSize: 16, color: Colors.white))
                  ],
                ),
              ),
            )
          ],
        ),
        //SizedBox(height: 15),
      ],
    ),
  );
}

ListTile drawerTile(IconData icon, String title, VoidCallback ontap) {
  return ListTile(
    onTap: ontap,
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
    horizontalTitleGap: 10,
    leading: Icon(
      icon,
      color: Colors.black,
    ),
    title: Text(
      title,
      style: const TextStyle(color: Colors.black),
    ),
  );
}




