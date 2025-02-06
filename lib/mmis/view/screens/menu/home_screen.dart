import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/extention/extension_util.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/view/components/bottom_Nav/bottom_nav.dart';
import 'package:flutter_app/mmis/view/screens/noInternet.dart';
import 'package:flutter_app/mmis/widgets/logout_dialog.dart';
import 'package:flutter_app/mmis/widgets/switch_language_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fluttericon/iconic_icons.dart';

import 'package:get/get.dart';
import 'package:flutter_app/mmis/controllers/home_controller.dart';
import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';

//poonam.crismmis@gmail.com

class HomeScreen extends StatelessWidget {

  final themeController = Get.find<ThemeController>();
  final networkController = Get.put(NetworkController());
  final controller = Get.put(HomeController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool onPop) {
        AapoortiUtilities.alertDialog(context, "MMIS");
      },
      child: Obx(() => networkController.connectionStatus.value == 0 ? const NoInternet() : Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.grey.shade400,
              drawer: navDrawer(context, _scaffoldKey, controller, themeController),
              bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
              appBar: AppBar(
               backgroundColor: MyColor.primaryColor,
               iconTheme: IconThemeData(color: Colors.white),
               centerTitle: true,
               title: Text('appName'.tr, style : TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic,fontSize: 18.0))),
               body: Container(
                 height: Get.height,
                 width: Get.width,
                 color: Colors.white,
                 child: Column(
                   children: [
                      Container(
                       width: Get.width,
                       height: 200,
                       child: Padding(
                         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                         child: GridView.count(
                           crossAxisCount: 2,
                           crossAxisSpacing: 16.0,
                           mainAxisSpacing: 16.0,
                           children: [
                             _buildTile(
                               context,
                               title: 'Search Demand',
                               icon: Icons.analytics_outlined,
                               color: Colors.lightBlue.shade100,
                               onTap: () {
                                 Get.toNamed(Routes.searchDemandsScreen);
                               },
                             ),
                             _buildTile(
                               context,
                               title: 'Search PO',
                               icon: Icons.receipt_long_outlined,
                               color: Colors.lightGreen.shade100,
                               onTap: () {
                                 //poonam.mishra@cris.gov.in
                                 ToastMessage.showSnackBar("Information!!","Comming Soon", Colors.blue);
                               },
                             ),
                           ],
                         ),
                       )
                      ),
                      Column(
                        children: [
                          Text("Pending Cases", style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Container(
                           height: 60,
                           width: Get.width * 0.50,
                           child: InkWell(
                             onTap: (){
                                if(controller.crismmispendingcases.value == "0" || controller.crismmispendingcases.value == "0.0"){
                                   AapoortiUtilities.showInSnackBar(context, "No Pending Demands in CRIS MMIS");
                                }else {
                                    Get.toNamed(Routes.crismmispendingcaseScreen);
                                }
                             },
                             child: Card(
                               color: Colors.white,
                               shape: RoundedRectangleBorder(
                                 side: BorderSide(color: Colors.grey, width: 1),
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text("CRIS MMIS"),
                                   PendingCaseState.success == controller.pendingcaseState.value ?
                                     Text(controller.crismmispendingcases.value == "0" ? "No Pending Demands" : controller.crismmispendingcases.value, style: TextStyle(color: controller.crismmispendingcases.value == "0" ? Colors.red : Colors.blue, fontWeight: FontWeight.bold)) :
                                     Text("----", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                 ],
                               ),
                             ),
                           ),
                         ),
                         Container(
                           height: 60,
                           width: Get.width * 0.50,
                           child: InkWell(
                             onTap: (){
                               if(controller.oldimmspendingcases.value == "0" || controller.oldimmspendingcases.value == "0.0") {
                                AapoortiUtilities.showInSnackBar(context, "No Pending Demands in Old iMMS");
                               }
                              else {
                                Get.toNamed(Routes.oldimmspendingcaseScreen);
                               }
                             },
                             child: Card(
                               color: Colors.white,
                               shape: RoundedRectangleBorder(
                                 side: BorderSide(color: Colors.grey, width: 1),
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text("OLD iMMS"),
                                   PendingCaseState.success == controller.pendingcaseState.value ?
                                   Text(controller.oldimmspendingcases.value == "0" ? "No Pending Demands" : controller.oldimmspendingcases.value, style: TextStyle(color: controller.oldimmspendingcases.value == "0" ? Colors.red : Colors.blue, fontWeight: FontWeight.bold)) :
                                   Text("----", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                 ],
                               ),
                             ),
                           ),
                         ),
                         //Text("Pending Cases:", style: TextStyle(color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold)),
                         // SizedBox(width: 5),
                         // Column(
                         //   //mainAxisAlignment: MainAxisAlignment.spaceAround,
                         //   children: [
                         //     Obx((){
                         //       if(controller.pendingcaseState == PendingCaseState.loading){
                         //         return Text("CRIS MMIS [...]");
                         //       }
                         //       else if(controller.pendingcaseState == PendingCaseState.success){
                         //         return InkWell(
                         //           onTap: (){
                         //             if(controller.crismmispendingcases.value == "0" || controller.crismmispendingcases.value == "0.0"){
                         //               AapoortiUtilities.showInSnackBar(context, "No Pending Demands in CRIS MMIS");
                         //               //Get.toNamed(Routes.crismmispendingcaseScreen);
                         //             }
                         //             else {
                         //               Get.toNamed(Routes.crismmispendingcaseScreen);
                         //             }
                         //           },
                         //           child: RichText(text: TextSpan(
                         //             text: 'CRIS-MMIS:- ',
                         //             style: TextStyle(color: Colors.black, fontSize: 18),
                         //             children: <TextSpan>[
                         //               TextSpan(
                         //                 text: controller.crismmispendingcases.value,
                         //                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                         //               ),
                         //               // TextSpan(
                         //               //   text: ']',
                         //               //   style: TextStyle(color: Colors.black, fontSize: 18),
                         //               // ),
                         //             ],
                         //           )),
                         //         );
                         //       }
                         //       else if(controller.pendingcaseState == PendingCaseState.failure){
                         //         return Text("CRIS MMIS [...]");
                         //       }
                         //       return Text("CRIS MMIS [...]");
                         //     }),
                         //     SizedBox(height: 8.0),
                         //     Obx((){
                         //       if(controller.pendingcaseState == PendingCaseState.loading){
                         //         return Text("OLD iMMS [...]");
                         //       }
                         //       else if(controller.pendingcaseState == PendingCaseState.success){
                         //         return InkWell(
                         //           onTap: (){
                         //             if(controller.oldimmspendingcases.value == "0" || controller.oldimmspendingcases.value == "0.0"){
                         //               AapoortiUtilities.showInSnackBar(context, "No Pending Demands in Old iMMS");
                         //               //Get.toNamed(Routes.oldimmspendingcaseScreen);
                         //             }
                         //             else {
                         //               Get.toNamed(Routes.oldimmspendingcaseScreen);
                         //             }
                         //           },
                         //           child: RichText(text: TextSpan(
                         //             text: 'OLD iMMS:- ',
                         //             style: TextStyle(color: Colors.black, fontSize: 18),
                         //             children: <TextSpan>[
                         //               TextSpan(
                         //                 text: controller.oldimmspendingcases.value,
                         //                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                         //               ),
                         //               // TextSpan(
                         //               //   text: ']',
                         //               //   style: TextStyle(color: Colors.black, fontSize: 18),
                         //               // ),
                         //             ],
                         //           )),
                         //         );
                         //       }
                         //       else if(controller.pendingcaseState == PendingCaseState.failure){
                         //         return Text("OLD iMMS [...]");
                         //       }
                         //       return Text("OLD iMMS [...]");
                         //     }),
                         //   ],
                         // ),
                       ],
                     ),
                      //Divider(color: Colors.black),
                      // Expanded(child: GridView.builder(
                      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //       childAspectRatio: 1.0,
                      //       crossAxisCount: 2, // Number of items per row
                      //       crossAxisSpacing: 10.0, // Horizontal space between items
                      //       mainAxisSpacing: 10.0, // Vertical space between items
                      //     ),
                      //     itemCount: controller.getlist.length,
                      //     padding: EdgeInsets.zero,
                      //     itemBuilder: (BuildContext ctx, index) {
                      //       return Padding(
                      //         padding: const EdgeInsets.all(5.0),
                      //         child: InkWell(
                      //           onTap: () {
                      //             if (index == 0) {
                      //               Get.toNamed(Routes.searchDemandsScreen);
                      //             }
                      //             else if (index == 1) {
                      //               Get.toNamed(Routes.nonStockDemandsScreen);
                      //             }
                      //           },
                      //           child: Card(
                      //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(strokeAlign: 1.0, color: Colors.indigo)),
                      //             //clipBehavior: Clip.antiAlias,
                      //             elevation: 4.0,
                      //             child: Stack(
                      //               children: [
                      //                 Image.asset(controller.getlist[index]['icon']!,height: 200, width: 200, fit: BoxFit.cover),
                      //                 Align(
                      //                   alignment: Alignment.bottomCenter,
                      //                   child: Container(
                      //                     width: double.infinity,
                      //                     decoration: BoxDecoration(
                      //                         color: Colors.indigo.withOpacity(0.8),
                      //                         border: Border.all(color: Colors.indigo, strokeAlign: 1.0)
                      //                     ),
                      //                     padding: EdgeInsets.all(5),
                      //                     child: Text(
                      //                       controller.getlist[index]['label']!.tr,
                      //                       textAlign: TextAlign.center,
                      //                       style: TextStyle(
                      //                         color: Colors.white,
                      //                         fontSize: 12,
                      //                         fontWeight: FontWeight.bold,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     }))
                   ],
                 )
              ),
            )),
    );
  }
}

Widget navDrawer(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey, HomeController homeController, ThemeController themeController) {
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
                    color: Colors.indigo.shade300,
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
                                color: Colors.indigo,
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
                                homeController.username.value,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0))),
                            SizedBox(height: 2.0),
                            Obx(() => Text(homeController.email.value,
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
                  AapoortiUtilities.alertDialog(context, "MMIS");
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
    contentPadding: EdgeInsets.zero,
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

Widget _buildTile(BuildContext context, {
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48.0,
            color: Colors.blueGrey,
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

DateTime? _lastPressedAt;
Future<bool> _onWillPop() async {
  //Get.dialog(showExitDialog(context));
  //return Future<bool>.value(true);
  if (_lastPressedAt == null ||
      DateTime.now().difference(_lastPressedAt!) > const Duration(seconds: 2)) {
    _lastPressedAt = DateTime.now();
    ToastMessage.backPress('backpress'.tr);
    return false;
  }
  return true;
}
