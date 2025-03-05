import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/controllers/dashboard_controller.dart';
import 'package:flutter_app/mmis/controllers/profile_controller.dart';
import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/extention/extension_util.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/view/components/bottom_Nav/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  bool isLoginSaved = false;

  final profileController = Get.put(ProfileController(), );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Profile", style: TextStyle(color: Colors.white)),
          elevation: 4,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx((){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.indigo.shade400,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 45,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        (profileController.username!.value.isEmpty) ? SizedBox(height: 1, width: 1) : Text(profileController.username!.value, style: TextStyle(fontWeight: FontWeight.bold))
                        // Text(
                        //   'CRIS TEST 2022',
                        //   style: TextStyle(
                        //     fontSize: 28,
                        //     fontWeight: FontWeight.bold,
                        //     fontFamily: 'Roboto',
                        //     color: Colors.teal,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "User Details",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 15), _buildDetailsContainer([
                    _buildDetailRow(Icons.phone, Colors.green, profileController.mobile!.value),
                    _buildDetailRow(Icons.email, Colors.red, profileController.email!.value),
                    _buildDetailRow(Icons.account_circle, Colors.blue, profileController.usertype!.value),
                    _buildDetailRow(Icons.lock, Colors.orange, profileController.workarea!.value),
                    _buildDetailRow(Icons.apartment, Colors.purple,  profileController.firmname!.value),
                  ]),
                  SizedBox(height: 40), _buildDetailsContainer([
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.teal, size: 24),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Last Login Time",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(profileController.lastlogintime!.value,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade600)),
                          ],
                        ),
                      ],
                    ),
                  ]),
                ],
              );
            }
            ),
          ),
        ));
    // return Scaffold(
    //   floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    //   resizeToAvoidBottomInset: true,
    //   floatingActionButton: FloatingActionButton(
    //     mini: true,
    //     onPressed: () {
    //       Navigator.of(context).pop();
    //     },
    //     backgroundColor: Colors.white,
    //     elevation: 0,
    //     child: Align(
    //       alignment: Alignment.center,
    //       child: Padding(
    //         padding: const EdgeInsets.only(right: 4.0),
    //         child: Icon(
    //           Icons.arrow_back_ios_rounded,
    //           color: Colors.black,
    //         ),
    //       ),
    //     ),
    //   ),
    //   bottomNavigationBar: CustomBottomNav(currentIndex: 2),
    //   body: Container(
    //     height: Get.height,
    //     width: Get.width,
    //     child: Obx((){
    //       if(profileController.profileState.value == ProfileState.loading){
    //         Center(child: CircularProgressIndicator(strokeWidth: 3));
    //       }
    //       else{
    //         return Stack(
    //           children: [
    //             Positioned(
    //               top: 0,
    //               left: 0,
    //               child: Stack(
    //                 alignment: Alignment.center,
    //                 children: [
    //                   Container(
    //                     height: mediaQuery.size.height * 0.50,
    //                     width: mediaQuery.size.width,
    //                     decoration: BoxDecoration(
    //                       image: DecorationImage(
    //                         fit: BoxFit.fitHeight,
    //                         image: AssetImage('assets/images/welcome.jpg'),
    //                       ),
    //                     ),
    //                   ),
    //                   Positioned(
    //                     bottom: mediaQuery.size.height * 0.15,
    //                     child: FittedBox(
    //                       child: Column(
    //                         children: [
    //                           Container(
    //                             child: CircleAvatar(
    //                               radius: 50,
    //                               backgroundColor: Colors.transparent,
    //                               foregroundColor: Colors.black,
    //                               child: Padding(
    //                                 padding: const EdgeInsets.all(8.0),
    //                                 child: Text(
    //                                   profileController.initianame!.value,
    //                                   style: TextStyle(
    //                                     fontSize: 50,
    //                                     fontWeight: FontWeight.w300,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             decoration: BoxDecoration(
    //                               color: Colors.white60,
    //                               borderRadius: BorderRadius.circular(100),
    //                             ),
    //                           ),
    //                           SizedBox(height: 20),
    //                           Container(
    //                             height: 30,
    //                             // width: mediaQuery.size.width * 0.6,
    //                             width: 250,
    //                             child: FittedBox(
    //                               child: (profileController.username!.value.isEmpty) ? SizedBox(height: 1, width: 1) : Text(profileController.username!.value, style: TextStyle(fontWeight: FontWeight.bold),
    //                               ),
    //                             ),
    //                             decoration: BoxDecoration(
    //                               color: Colors.white60,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Positioned(
    //               bottom: 0,
    //               child: Container(
    //                 height: mediaQuery.size.height * 0.55,
    //                 width: mediaQuery.size.width,
    //                 decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(40),
    //                     topRight: Radius.circular(40),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Positioned(
    //               bottom: 0,
    //               child: Container(
    //                 height: mediaQuery.size.height * 0.55,
    //                 width: mediaQuery.size.width,
    //                 decoration: BoxDecoration(
    //                   color: Colors.blue,
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(40),
    //                     topRight: Radius.circular(40),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Positioned(
    //               bottom: 0,
    //               right: 0,
    //               child: Container(
    //                 height: mediaQuery.size.height * 0.55,
    //                 width: mediaQuery.size.width,
    //                 decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(40),
    //                     topRight: Radius.circular(40),
    //                   ),
    //                 ),
    //                 child: Padding(
    //                   padding:
    //                   const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
    //                   child: ListView(
    //                     children: [
    //                       Row(
    //                         children: [
    //                           Icon(Icons.phone, size: 25),
    //                           SizedBox(width: 25),
    //                           Expanded(
    //                             child: Text(
    //                               profileController.mobile!.value,
    //                               style: TextStyle(
    //                                 fontSize: 20,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 20),
    //                       Row(
    //                         children: [
    //                           Icon(Icons.email, size: 25),
    //                           SizedBox(width: 25),
    //                           Expanded(
    //                             child: (profileController.email!.value.isEmpty) ? SizedBox(width: 1, height: 1) : Text(profileController.email!.value,
    //                               style: TextStyle(
    //                                 fontSize: 20,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 20),
    //                       Row(
    //                         children: [
    //                           Image.asset(
    //                             'assets/images/name_profile.png',
    //                             width: 24,
    //                             height: 32,
    //                           ),
    //                           SizedBox(width: 25),
    //                           Expanded(
    //                             child: Text(
    //                               profileController.usertype!.value,
    //                               style: TextStyle(
    //                                 fontSize: 20,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 20),
    //                       Row(
    //                         children: [
    //                           Image.asset(
    //                             'assets/images/work_area.png',
    //                             width: 24,
    //                             height: 32,
    //                           ),
    //                           SizedBox(width: 25),
    //                           Expanded(
    //                             child: Text(
    //                               profileController.workarea!.value,
    //                               style: TextStyle(
    //                                 fontSize: 20,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 10),
    //                       Row(
    //                         children: [
    //                           // Expanded(
    //                           //   child: Divider(),
    //                           // ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Text(
    //                               'Organization Details',
    //                               style: TextStyle(
    //                                 fontWeight: FontWeight.bold,
    //                                 fontSize: 16,
    //                                 color: Colors.blue[900],
    //                               ),
    //                             ),
    //                           ),
    //                           Expanded(
    //                             child: Divider(),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 10),
    //
    //                       Row(
    //                         children: [
    //                           Image.asset(
    //                             'assets/images/firm_icon.png',
    //                             width: 24,
    //                             height: 32,
    //                           ),
    //                           SizedBox(width: 25),
    //                           Expanded(
    //                             child: Text(
    //                               profileController.firmname!.value,
    //                               style: TextStyle(
    //                                 fontSize: 20,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 10),
    //                       Row(
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Text(
    //                               'Last Login Time',
    //                               style: TextStyle(
    //                                 fontWeight: FontWeight.bold,
    //                                 fontSize: 16,
    //                                 color: Colors.blue[900],
    //                               ),
    //                             ),
    //                           ),
    //                           Expanded(
    //                             child: Divider(),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 10),
    //                       Row(
    //                         children: [
    //                           Image.asset(
    //                             'assets/images/login_time.png',
    //                             width: 24,
    //                             height: 32,
    //                           ),
    //                           SizedBox(width: 25),
    //                           Expanded(
    //                             child: Text(
    //                               profileController.lastlogintime!.value,
    //                               style: TextStyle(
    //                                 fontSize: 20,
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 20),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         );
    //       }
    //       return SizedBox();
    //     }),
    //   ),
    // );
  }

  Widget _buildDetailsContainer(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.4), spreadRadius: 3, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: children
            .map((child) => Column(children: [child, Divider(height: 20, thickness: 1.5)]))
            .expand((widget) => widget.children)
            .toList()
          ..removeLast(),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

Widget navDrawer(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey,
    DashBoardController dashBoardController, ThemeController themeController) {
  return Drawer(
    child: Column(
      children: [
        Expanded(
          child: Container(
            child: ListView(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(height: 180.0),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/welcome.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      SizedBox(height: 4.0),
                      Obx(() => Text(
                          dashBoardController.username!.value
                              .capitalizeFirstLetter(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0))),
                      SizedBox(height: 2.0),
                      Obx(() => Text(dashBoardController.email!.value,
                          style:
                              TextStyle(color: Colors.white, fontSize: 15.0)))
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.black,
                  height: 2.0,
                ),
                drawerTile(Iconic.lock, 'changepin'.tr, () {
                  //Navigator.pop(context);
                  _scaffoldKey.currentState!.closeDrawer();
                  Get.toNamed(Routes.changepinScreen);
                }),
                drawerTile(Iconic.star, 'rateus'.tr, () {
                  //Navigator.pop(context);
                  _scaffoldKey.currentState!.closeDrawer();
                  AapoortiUtilities.openStore(context);
                }),
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
                  AapoortiUtilities.showAlertDailog(context, "MMIS");
                  //_showConfirmationDialog(context);
                  //WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
                  //callWebServiceLogout();
                }
              },
              child: Container(
                height: 45,
                color: Colors.indigo.shade500,
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
