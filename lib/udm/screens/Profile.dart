import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/user_home_screen.dart';
import 'package:flutter_app/udm/widgets/bottom_Nav/bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  bool isLoginSaved = false;

  String? username = "", emailid = '', phoneno = '', usertype = '', workarea = '', firmname = '', lastlogintime = '';
  List<Map<String, dynamic>>? dbResult;

  int _selectedIndex = 0;

  void initState() {
    UserData();
    super.initState();
  }

  Future<void> UserData() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(dbResult!.isNotEmpty) {
        setState(() {
          //username = dbResult![0][DatabaseHelper.Tb3_col8_userName];
          username = prefs.getString('name');
          emailid = dbResult![0][DatabaseHelper.Tb3_col5_emailid];
          phoneno = dbResult![0][DatabaseHelper.Tb3_col7_mobile];
          firmname = dbResult![0][DatabaseHelper.Tb3_col12_OuName];
          usertype = dbResult![0][DatabaseHelper.Tb3_col9_UserVlue];
          workarea = dbResult![0][DatabaseHelper.Tb3_col11_WKArea];
          lastlogintime = dbResult![0][DatabaseHelper.Tb3_col10_LastLogin];
        });
      }
    } catch (err) {}
  }

  String get nameToInitials {
    String initials = '';
    List<String> splitName = username!.split(' ');
    if (splitName[0].isNotEmpty) {
      initials += splitName[0][0].toUpperCase();
    }
    if (splitName.length > 1) {
      if (splitName[splitName.length - 1].isNotEmpty) {
        initials += splitName[splitName.length - 1][0].toUpperCase();
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      //floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      //resizeToAvoidBottomInset: true,
      // floatingActionButton: FloatingActionButton(
      //   mini: true,
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   child: Align(
      //     alignment: Alignment.center,
      //     child: Padding(
      //       padding: const EdgeInsets.only(right: 4.0),
      //       child: Icon(
      //         Icons.arrow_back_ios_rounded,
      //         color: Colors.black,
      //       ),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: AapoortiConstants.primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(language.text('profile'), style: TextStyle(color: Colors.white)),
        elevation: 4,
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1),
      body: Container(
        height: mediaQuery.size.height,
        width: mediaQuery.size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: AapoortiConstants.primary,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 45,
                            color: AapoortiConstants.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      username!.isEmpty ? SizedBox(height: 1, width: 1) : Text(username ?? "NA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
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
                SizedBox(height: 15),
                _buildDetailsContainer([
                  _buildDetailRow(Icons.phone, Colors.green, phoneno ?? "NA"),
                  _buildDetailRow(Icons.email, Colors.red, emailid ?? "NA"),
                  _buildDetailRow(Icons.account_circle, Colors.blue, usertype ?? "NA"),
                  _buildDetailRow(Icons.lock, Colors.orange, workarea ?? "NA"),
                  firmname == null || firmname == "null" ? _buildDetailRow(Icons.apartment, Colors.purple, "NA") : _buildDetailRow(Icons.apartment, Colors.purple, firmname)
                ]),
                SizedBox(height: 40),
                _buildDetailsContainer([
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
                          Text(lastlogintime!,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade600)),
                        ],
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
        // child: Stack(
        //   children: [
        //     Positioned(
        //       top: 0,
        //       left: 0,
        //       child: Stack(
        //         alignment: Alignment.center,
        //         children: [
        //           Container(
        //             height: mediaQuery.size.height * 0.50,
        //             width: mediaQuery.size.width,
        //             decoration: BoxDecoration(
        //               image: DecorationImage(
        //                 fit: BoxFit.fitHeight,
        //                 image: AssetImage('assets/welcome.jpg'),
        //               ),
        //             ),
        //           ),
        //           Positioned(
        //             bottom: mediaQuery.size.height * 0.15,
        //             child: FittedBox(
        //               child: Column(
        //                 children: [
        //                   Container(
        //                     child: CircleAvatar(
        //                       radius: 50,
        //                       backgroundColor: Colors.transparent,
        //                       foregroundColor: Colors.black,
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text(
        //                           nameToInitials,
        //                           style: TextStyle(
        //                             fontSize: 50,
        //                             fontWeight: FontWeight.w300,
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                     decoration: BoxDecoration(
        //                       color: Colors.white60,
        //                       borderRadius: BorderRadius.circular(100),
        //                     ),
        //                   ),
        //                   SizedBox(height: 20),
        //                   Container(
        //                     height: 30,
        //                     // width: mediaQuery.size.width * 0.6,
        //                     width: 250,
        //                     child: FittedBox(
        //                       child: (username!.isEmpty || username == null)
        //                           ? SizedBox(height: 1, width: 1)
        //                           : Text(
        //                         username!,
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                     ),
        //                     decoration: BoxDecoration(
        //                       color: Colors.white60,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Positioned(
        //       bottom: 0,
        //       child: Container(
        //         height: mediaQuery.size.height * 0.55,
        //         width: mediaQuery.size.width,
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(40),
        //             topRight: Radius.circular(40),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Positioned(
        //       bottom: 0,
        //       child: Container(
        //         height: mediaQuery.size.height * 0.55,
        //         width: mediaQuery.size.width,
        //         decoration: BoxDecoration(
        //           color: Colors.blue,
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(40),
        //             topRight: Radius.circular(40),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Positioned(
        //       bottom: 0,
        //       right: 0,
        //       child: Container(
        //         height: mediaQuery.size.height * 0.55,
        //         width: mediaQuery.size.width,
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(40),
        //             topRight: Radius.circular(40),
        //           ),
        //         ),
        //         child: Padding(
        //           padding:
        //           const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        //           child: ListView(
        //             children: [
        //               Row(
        //                 children: [
        //                   Icon(Icons.phone, size: 25),
        //                   SizedBox(width: 25),
        //                   Expanded(
        //                     child: Text(
        //                       phoneno!,
        //                       style: TextStyle(
        //                         fontSize: 20,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 20),
        //               Row(
        //                 children: [
        //                   Icon(Icons.email, size: 25),
        //                   SizedBox(width: 25),
        //                   FittedBox(
        //                     alignment: Alignment.topLeft,
        //                     fit: BoxFit.scaleDown,
        //                     child: (emailid == null || emailid!.isEmpty)
        //                         ? SizedBox(width: 1, height: 1)
        //                         : Text(
        //                       emailid!,
        //                       style: TextStyle(
        //                         fontSize: 20,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 20),
        //               Row(
        //                 children: [
        //                   Image.asset(
        //                     'assets/name_profile.png',
        //                     width: 24,
        //                     height: 32,
        //                   ),
        //                   SizedBox(width: 25),
        //                   Expanded(
        //                     child: Text(
        //                       usertype!,
        //                       style: TextStyle(
        //                         fontSize: 20,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 20),
        //               Row(
        //                 children: [
        //                   Image.asset(
        //                     'assets/work_area.png',
        //                     width: 24,
        //                     height: 32,
        //                   ),
        //                   SizedBox(width: 25),
        //                   Expanded(
        //                     child: Text(
        //                       workarea!,
        //                       style: TextStyle(
        //                         fontSize: 20,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 10),
        //               Row(
        //                 children: [
        //                   // Expanded(
        //                   //   child: Divider(),
        //                   // ),
        //                   Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Text(
        //                       'Organization Details',
        //                       style: TextStyle(
        //                         fontWeight: FontWeight.bold,
        //                         fontSize: 16,
        //                         color: Colors.blue[900],
        //                       ),
        //                     ),
        //                   ),
        //                   Expanded(
        //                     child: Divider(),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 10),
        //
        //               Row(
        //                 children: [
        //                   Image.asset(
        //                     'assets/firm_icon.png',
        //                     width: 24,
        //                     height: 32,
        //                   ),
        //                   SizedBox(width: 25),
        //                   Expanded(
        //                     child: Text(
        //                       firmname!,
        //                       style: TextStyle(
        //                         fontSize: 20,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 10),
        //               Row(
        //                 children: [
        //                   // Expanded(
        //                   //   child: Divider(),
        //                   // ),
        //                   Padding(
        //                     padding: const EdgeInsets.all(8.0),
        //                     child: Text(
        //                       'Last Login Time',
        //                       style: TextStyle(
        //                         fontWeight: FontWeight.bold,
        //                         fontSize: 16,
        //                         color: Colors.blue[900],
        //                       ),
        //                     ),
        //                   ),
        //                   Expanded(
        //                     child: Divider(),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 10),
        //               Row(
        //                 children: [
        //                   Image.asset(
        //                     'assets/login_time.png',
        //                     width: 24,
        //                     height: 32,
        //                   ),
        //                   SizedBox(width: 25),
        //                   Expanded(
        //                     child: Text(
        //                       lastlogintime!,
        //                       style: TextStyle(
        //                         fontSize: 20,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(height: 20),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
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

  Widget _buildDetailRow(IconData icon, Color color, String? text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(width: 12),
        Text(text ?? "NA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // Widget _buildBottomNavigationBar() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, -5),
  //         ),
  //       ],
  //     ),
  //     child: BottomNavigationBar(
  //       currentIndex: _selectedIndex,
  //       onTap: (index) {
  //         setState(() {
  //           _selectedIndex = index;
  //         });
  //         index == 0 ? Navigator.of(context).pushReplacementNamed(UserHomeScreen.routeName) : Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
  //       },
  //       backgroundColor: Colors.white,
  //       selectedItemColor: const Color(0xFF0D47A1),
  //       unselectedItemColor: Colors.grey,
  //       type: BottomNavigationBarType.fixed,
  //       showSelectedLabels: true,
  //       showUnselectedLabels: true,
  //       elevation: 0,
  //       items: [
  //         BottomNavigationBarItem(
  //           icon: const Icon(Icons.home_outlined),
  //           activeIcon: const Icon(Icons.home),
  //           label: _translate('Home'),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: const Icon(Icons.person_outline),
  //           activeIcon: const Icon(Icons.person),
  //           label: _translate('Profile'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
