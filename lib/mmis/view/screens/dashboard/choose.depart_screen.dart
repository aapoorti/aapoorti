import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/controllers/choose_dept_controller.dart';
import 'package:flutter_app/mmis/controllers/dashboard_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/controllers/theme_controller.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseDepartScreen extends StatefulWidget {
  const ChooseDepartScreen({super.key});

  @override
  State<ChooseDepartScreen> createState() => _ChooseDepartScreenState();
}

class _ChooseDepartScreenState extends State<ChooseDepartScreen> {

  final choosedeptcontroller = Get.put<ChooseDeptController>(ChooseDeptController());
  int selectedIndex = 0;

  final controller = Get.put(DashBoardController());

  final themeController =  Get.find<ThemeController>();
  final networkController = Get.put(NetworkController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchDepart();
  }

  Future<void> fetchDepart() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if(providedTime.isBefore(DateTime.now())){
      await fetchToken(context);
      choosedeptcontroller.fetchDepartmentCount(prefs.getString('userid')!);
    }
    else{
      choosedeptcontroller.fetchDepartmentCount(prefs.getString('userid')!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      // appBar: AppBar(title: Text('CRIS MMIS',style: TextStyle(color: Colors.white)),backgroundColor: Colors.lightBlue[800]!, iconTheme: IconThemeData(color: Colors.white)),
      key: _scaffoldKey,
      drawer: navDrawer(context, _scaffoldKey, controller, themeController),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
             children: [
                Container(
                  height: 45,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade700
                  ),
                  alignment: Alignment.center,
                  child: Text("Choose your Department", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 5.0),
                Obx((){
                  if(choosedeptcontroller.choosedeptState == ChooseDeptState.idle){
                    return SizedBox();
                  }
                  else if(choosedeptcontroller.choosedeptState == ChooseDeptState.loading){
                    return Expanded(child: Center(child: CircularProgressIndicator()));
                  }
                  else if(choosedeptcontroller.choosedeptState == ChooseDeptState.success){
                    return Expanded(child: ListView.builder(
                        itemCount: choosedeptcontroller.departlist.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10),
                        itemBuilder: (BuildContext context, int index){
                          return InkWell(
                            onTap: () {
                              Future.delayed(Duration(milliseconds: 0), (){
                                Get.toNamed(Routes.homeScreen, arguments: [choosedeptcontroller.departlist[index].key1, choosedeptcontroller.departlist[index].key6, choosedeptcontroller.departlist[index].key8,choosedeptcontroller.departlist[index].key9]);
                              });
                            },
                            child: Card(
                              margin: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              child: Container(
                                height: 150,
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0)
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.cyanAccent,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    SizedBox(height: 25.0),
                                    Text(choosedeptcontroller.departlist[index].key2!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                                    SizedBox(height: 5.0),
                                    Obx((){
                                      if(choosedeptcontroller.selectdeptState == SelectDeptState.loading){
                                        return selectedIndex == index ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17.5),
                                                  color: Colors.indigo.shade300
                                              ),
                                              alignment: Alignment.center,
                                              child: Container(height: 25, width: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.0)),
                                            ),
                                          ),
                                        ) : Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17.5),
                                                  color: Colors.indigo.shade300
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      else if(choosedeptcontroller.selectdeptState == SelectDeptState.success){
                                        return selectedIndex == index ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17.5),
                                                  color: Colors.indigo.shade300
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.check, color: Colors.white),
                                            ),
                                          ),
                                        ) : Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17.5),
                                                  color: Colors.indigo.shade300
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      else if(choosedeptcontroller.selectdeptState == SelectDeptState.idle){
                                        return Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17.5),
                                                  color: Colors.indigo.shade300
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      else if(choosedeptcontroller.selectdeptState == SelectDeptState.failed){
                                        return selectedIndex == index ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17.5),
                                                  color: Colors.indigo.shade300
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                            ),
                                          ),
                                        ) : Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17.5),
                                                  color: Colors.indigo.shade300
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      else if(choosedeptcontroller.selectdeptState == SelectDeptState.failedWithError){
                                        return Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(17.5),
                                                  color: Colors.indigo.shade300
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      return Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(17.5),
                                                color: Colors.indigo.shade300
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(Icons.arrow_forward_outlined, color: Colors.white),
                                          ),
                                        ),
                                      );
                                    })
                                    //TextButton(onPressed: (){}, child: Text("CLICK HERE", style: TextStyle(color: Colors.pinkAccent, fontSize: 16)))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ));
                  }
                  return SizedBox();
                })
             ],
          ),
        ),
      ),
    );
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
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
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
                                  color: Color(0xFF1976D2),
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
}
