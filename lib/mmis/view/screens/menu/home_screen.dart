import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/extention/extension_util.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/view/components/bottom_Nav/bottom_nav.dart';
import 'package:flutter_app/mmis/view/screens/noInternet.dart';
import 'package:flutter_app/mmis/widgets/logout_dialog.dart';
import 'package:flutter_app/mmis/widgets/switch_language_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:flutter_svg/svg.dart';

import 'package:fluttericon/iconic_icons.dart';

import 'package:get/get.dart';
import 'package:flutter_app/mmis/controllers/home_controller.dart';
import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

//poonam.crismmis@gmail.com

class HomeScreen extends StatelessWidget {

  final themeController = Get.find<ThemeController>();
  final networkController = Get.put(NetworkController());
  final controller = Get.put(HomeController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? deptId = Get.arguments[0];
  String? postId = Get.arguments[1];
  String? crismmispendingcases = Get.arguments[2];
  String? oldimmspendingcases = Get.arguments[3];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Obx(() => networkController.connectionStatus.value == 0 ? const NoInternet() :  Scaffold(
        appBar: AppBar(
            backgroundColor: AapoortiConstants.primary,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            title: Text('appName'.tr, style : TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic,fontSize: 18.0))),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
        key: _scaffoldKey,
        drawer: navDrawer(context, _scaffoldKey, controller, themeController),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildCard(
                            'Search Demand',
                            Icons.analytics_outlined,
                            Colors.lightBlue.shade100,
                            onTap: () async{
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
                              if(providedTime.isBefore(DateTime.now())){
                                await fetchToken(context);
                                Get.toNamed(Routes.searchDemandsScreen);
                              }
                              else{
                                Get.toNamed(Routes.searchDemandsScreen);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCard(
                            'Search PO',
                            Icons.receipt_long,
                            Colors.green.shade100,
                            onTap: () {
                              //poonam.mishra@cris.gov.in
                              ToastMessage.showSnackBar("Information!!","Comming Soon", Colors.blue);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Pending Cases',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000080), // Navy blue color for "Pending Cases"
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildPendingCard(
                            'CRIS MMIS',
                            crismmispendingcases == "0" || crismmispendingcases == "0.0" ? "0" : crismmispendingcases!.contains('.') ? crismmispendingcases!.split('.')[1] == '0' ? crismmispendingcases!.split('.')[0] : crismmispendingcases! : crismmispendingcases!,
                            onTap: () async{
                              if(crismmispendingcases == "0" || crismmispendingcases == "0.0"){
                                AapoortiUtilities.showInSnackBar(context, "No Pending Demands in CRIS MMIS");
                              }else {
                                Get.toNamed(Routes.crismmispendingcaseScreen, arguments: [postId]);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPendingCard(
                            'OLD iMMS',
                            oldimmspendingcases == "0" || oldimmspendingcases == "0.0" ? "0" : oldimmspendingcases!.contains('.') ? oldimmspendingcases!.split('.')[1] == '0' ? oldimmspendingcases!.split('.')[0] : oldimmspendingcases!: oldimmspendingcases!,
                            onTap: () {
                              if(oldimmspendingcases == "0" || oldimmspendingcases == "0.0") {
                                AapoortiUtilities.showInSnackBar(context, "No Pending Demands in Old iMMS");
                              }
                              else {
                                Get.toNamed(Routes.oldimmspendingcaseScreen);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  //_buildBottomNav(),
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}

Widget _buildCard(String title, IconData icon, Color backgroundColor, {required VoidCallback onTap}) {
  return Card(
    color: backgroundColor,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.grey[700]),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF000080), // Navy blue color for card titles
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildPendingCard(String title, String count, {required VoidCallback onTap}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF000080), // Navy blue color for pending card titles
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0073CF),
              ),
            ),
          ],
        ),
      ),
    ),
  );
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
                  AapoortiUtilities.showAlertDailog(context, "MMIS");
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
