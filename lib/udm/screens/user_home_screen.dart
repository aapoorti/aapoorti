// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:flutter_app/udm/helpers/wso2token.dart';
// import 'package:flutter_app/udm/transaction/transaction_screen.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_app/udm/crc_digitally_signed/view/crc_screen.dart';
// import 'package:flutter_app/udm/crc_summary/view/crc_summary_screen.dart';
// import 'package:flutter_app/udm/crn_digitally_signed/view/crn_screen.dart';
// import 'package:flutter_app/udm/crn_summary/view/crn_summary_screen.dart';
// import 'package:flutter_app/udm/end_user/view/to_user_end_screen.dart';
// import 'package:flutter_app/udm/helpers/api.dart';
// import 'package:flutter_app/udm/helpers/database_helper.dart';
// import 'package:flutter_app/udm/helpers/shared_data.dart';
// import 'package:flutter_app/udm/non_stock_demands/views/non_stock_demands_screen.dart';
// import 'package:flutter_app/udm/ns_demand_summary/view/nsdemandsummary_screen.dart';
// import 'package:flutter_app/udm/onlineBillSummary/summaryDropdown.dart';
// import 'package:flutter_app/udm/providers/languageProvider.dart';
// import 'package:flutter_app/udm/providers/loginProvider.dart';
// import 'package:flutter_app/udm/providers/versionProvider.dart';
// import 'package:flutter_app/udm/rejection_warranty/views/warranty_rejection_screen.dart';
// import 'package:flutter_app/udm/screens/UdmChangePin.dart';
// import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_items_history_sheet_screen.dart';
// import 'package:flutter_app/udm/stocking_proposal_summary/view/stocking_proposal_summary_screen.dart';
// import 'package:flutter_app/udm/transaction/transaction_search_dropdown.dart';
// import 'package:flutter_app/udm/warranty_complaint_summary/view/Warranty_dropdownScreen.dart';
// import 'package:flutter_app/udm/warranty_crn_summary/view/warranty_crn_summary_screen.dart';
// import 'package:flutter_app/udm/widgets/bottom_Nav/bottom_nav.dart';
// import 'package:flutter_app/udm/widgets/consuptionAnalysisFilter.dart';
// import 'package:flutter_app/udm/widgets/consuptionSummaryFilter.dart';
// import 'package:flutter_app/udm/widgets/custom_rightside_drawer.dart';
// import 'package:flutter_app/udm/widgets/warningalert_dialog.dart';
// import 'package:flutter_app/udm/widgets/highValueFilter.dart';
// import 'package:flutter_app/udm/widgets/nonMovingFilter.dart';
// import 'package:flutter_app/udm/widgets/poSearch_rightside_drawer.dart';
// import 'package:flutter_app/udm/widgets/stock_rightside_drawer.dart';
// import 'package:flutter_app/udm/widgets/stock_summary_drawer.dart';
// import 'package:flutter_app/udm/widgets/storeDepot_rightside_drawer.dart';
// import 'package:flutter_app/udm/widgets/switch_language_button.dart';
// import 'package:flutter_app/udm/widgets/valueWiseStockFilter.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// //import 'package:package_info/package_info.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../gemorder/gem_OrderDetails/view/gem_order_screen.dart';
// import '../onlineBillStatus/statusDropdown.dart';
//
// import 'package:permission_handler/permission_handler.dart';
//
// import '../warranty_rejection_register/view/warranty_rejection_register_screen.dart';
// import '../widgets/expandablegrid.dart';
// import 'Profile.dart';
// import 'login_screen.dart';
//
// class UserHomeScreen extends StatefulWidget {
//   static const routeName = "/user-home-screen";
//
//   @override
//   _UserHomeScreenState createState() => _UserHomeScreenState();
// }
//
// class _UserHomeScreenState extends State<UserHomeScreen> with TickerProviderStateMixin {
//
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//   List<Map<String, dynamic>> gridOneItems = [
//     {'icon': 'assets/item1.png', 'label': 'आइटम ढूँढें\nSearch Item'},
//     {
//       'icon': 'assets/item_search.png',
//       'label': 'स्टॉक उपलब्धता\nStock Availability'
//     },
//     {
//       'icon': 'assets/depot_store.png',
//       'label': 'भण्डार डिपो स्टॉक\nStores Depot Stock'
//     },
//     {
//       'icon': 'assets/images/po_search.png',
//       'label': 'क्रयादेश ढूँढें \nSearch PO'
//     },
//     {
//       'icon': 'assets/summary.png',
//       'label': 'स्टॉक का संक्षिप्त विवरण\nSummary of Stock'
//     },
//     {
//       'icon': 'assets/images/non_moving.png',
//       'label': 'नॉन-मूविंग आइटम\nNon-Moving Items'
//     },
//     {
//       'icon': 'assets/valueWise.png',
//       'label': 'वैल्यू अनुसार स्टॉक\nValue-Wise Stock'
//     },
//     {
//       'icon': 'assets/highValue.png',
//       'label': 'उच्च वैल्यू आइटम\nHigh Value Items'
//     },
//     {
//       'icon': 'assets/analysis.png',
//       'label': 'खपत का विश्लेषण\nConsumption Analysis'
//     },
//     {
//       'icon': 'assets/cons_summary.png',
//       'label': 'खपत का संक्षिप्त विवरण\nConsumption Summary'
//     },
//     {
//       'icon': 'assets/trans.png',
//       'label': 'लेनदेन\nTransactions',
//     },
//     {
//       'icon': 'assets/download.png',
//       'label': 'ऑनलाइन बिल की स्थितिं \nOn-Line Bill Status'
//     },
//     {
//       'icon': 'assets/edoc_home.png',
//       'label': 'ऑनलाइन बिल सारांश \nOn-Line Bill Summary'
//     },
//     {
//       'icon': 'assets/images/crn.png',
//       'label': 'सी.आर.एन \nCRN'
//     },
//     {
//       'icon': 'assets/images/udm_crc.png',
//       'label': 'सी.आर.सी \nCRC'
//     },
//     {
//       'icon': 'assets/stock.jpg',
//       'label': 'स्टॉक आइटम इतिहास पत्रक \nStk. Item History Sheet'
//     },
//     {
//       'icon': 'assets/images/ns_demands.png',
//       'label': 'गैर-स्टॉक मांगें \nNS Demands'
//     },
//     {
//       'icon': 'assets/images/gem.svg',
//       'label': 'रत्न-आदेश विवरण \nGeM Order Details'
//     },
//     {
//       'icon': 'assets/images/warranty.png',
//       'label': 'अस्वीकृति/वारंटी \nRejection/Warranty'
//     },
//     {
//       'icon': 'assets/images/demand.jpg',
//       'label': 'एनएस डिमांड सारांश \nNS Demand Summary'
//     },
//     {
//       'icon': 'assets/report_icon.png',
//       'label': 'वारंटी शिकायत सारांश \nWarranty Complaint Summary'
//     },
//     {
//       'icon': 'assets/images/summary.jpg',
//       'label': 'सीआरएन सारांश \nCRN Summary'
//     },
//     {
//       'icon': 'assets/images/stock_sm.jpg',
//       'label': 'स्टॉकिंग प्रस्ताव सारांश \nStocking Proposal Summary'
//     },
//     {
//       'icon': 'assets/images/rejection.png',
//       'label': 'वारंटी अस्वीकृति रजिस्टर \nWarranty Rejection Register'
//     },
//     {
//       'icon': 'assets/images/crc.png',
//       'label': 'सीआरसी सारांश \nCRC Summary'
//     },
//     // {
//     //   'icon': 'assets/images/end_user.png',
//     //   'label': 'अंतिम उपयोगकर्ता के लिए \nTo End User'
//     // },
//     // {
//     //   'icon': 'assets/images/wcs.png',
//     //   'label': 'वारंटी सीआरएन सारांश \nWarranty CRN Summary'
//     // },
//   ];
//
//   DatabaseHelper dbHelper = DatabaseHelper.instance;
//   late List<Map<String, dynamic>> dbResult;
//   String? username = '', email = '';
//   late LoginProvider itemListProvider;
//   VersionProvider? versionProvider;
//   String localCurrVer = '', versionName = '';
//
//   // Animation
//   bool expand = false;
//   late AnimationController controller;
//   late Animation<double> animation, animationView;
//
//   void initState() {
//     requestWritePermission();
//     getVersion();
//     fetchUserData();
//     //Provider.of<NetworkProvider>(context, listen: false);
//     // Animation
//     controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
//
//     animation = Tween(begin: 0.0, end: -0.5).animate(controller);
//     animationView = CurvedAnimation(parent: controller, curve: Curves.linear);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Timer(Duration(milliseconds: 500), () {
//         togglePanel();
//       });
//     });
//     super.initState();
//   }
//
//   void requestWritePermission() async {
//     PermissionStatus permissionStatus = await Permission.storage.request();
//     if(!permissionStatus.isGranted) {
//       bool isshown = await Permission.storage.shouldShowRequestRationale;
//       Map<Permission, PermissionStatus> permissions = await [Permission.storage].request();
//       if(this.mounted) setState(() {});
//     } else {
//       if(this.mounted) setState(() {});
//     }
//   }
//
//   @override
//   Future<void> didChangeDependencies() async {
//     super.didChangeDependencies();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.containsKey("notice")) {
//       if (prefs.getString("notice") != "") {
//         showHomeNoticeDialog(context, prefs.get('notice') as String?,
//             prefs.get('noticetitile') as String?);
//       }
//     }
//   }
//
//   Future<void> getVersion() async{
//      PackageInfo packageInfo = await PackageInfo.fromPlatform();
//      setState(() {
//          localCurrVer = packageInfo.version;
//          versionName = packageInfo.buildNumber;
//     });
//   }
//
//   showHomeNoticeDialog(context, String? msg, String? title) async {
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         String message = msg!;
//         String btnLabel = "Okay";
//         return AlertDialog(
//           title: Text(title!),
//           content: Text(message),
//           actions: <Widget>[
//             MaterialButton(
//                 child: Text(btnLabel),
//                 onPressed: () async {
//                   SharedPreferences prefs = await SharedPreferences.getInstance();
//                   prefs.setString('notice', '');
//                   prefs.setString('noticetitile', '');
//                   Navigator.of(context, rootNavigator: true).pop();
//                 }),
//           ],
//         );
//       },
//     );
//   }
//
//   // void versionControl() async {
//   //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   //   version = "${packageInfo.version}:${packageInfo.buildNumber}";
//   //   print("Versionutil = " + version);
//   // }
//
//   // Future<void> getVersion() async {
//   //   final _checker = AppVersionChecker();
//   //   //Provider.of<VersionProvider>(context, listen: false).fetchVersion(context);
//   //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   //   setState(() {
//   //     localCurrVer = packageInfo.version;
//   //     versionName = packageInfo.buildNumber;
//   //   });
//   //   // _checker.checkUpdate().then((value) {
//   //   //   if(value.canUpdate) {
//   //   //         showDialog(context: context, builder: (BuildContext context) {
//   //   //           return UpdateDialog(
//   //   //             allowDismissal: true,
//   //   //             description: "Please update your app from ${value.currentVersion} to ${value.newVersion} for access more functionality.",
//   //   //             version: value.newVersion!,
//   //   //             appLink: value.appURL!,
//   //   //           );
//   //   //         });
//   //   //     }
//   //   // });
//   // }
//
//   Future<void> fetchUserData() async {
//     try {
//       DatabaseHelper dbHelper = DatabaseHelper.instance;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var dbResult = await dbHelper.fetchSaveLoginUser();
//       if (dbResult.isNotEmpty) {
//         setState(() {
//           username = prefs.getString('name');
//           //username = dbResult[0][DatabaseHelper.Tb3_col8_userName];
//           email = dbResult[0][DatabaseHelper.Tb3_col5_emailid];
//         });
//       }
//     } catch (err) {}
//   }
//
//   Future<void> onTapFunction(String gridno, int itemIndex) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
//     if(providedTime.isBefore(DateTime.now())){
//       await fetchToken(context);
//       if(gridno == '1') {
//         switch (itemIndex) {
//           case 0:
//             Navigator.push(context, MaterialPageRoute(builder: (context) => CustomRightSideDrawer()));
//             break;
//           case 1:
//             Navigator.push(context, MaterialPageRoute(builder: (context) => StockRightSideDrawer()));
//             break;
//           case 2:
//             Navigator.push(context, MaterialPageRoute(builder: (context) => StoreStkDepotRightSideDrawer()));
//             break;
//           case 3:
//             Navigator.of(context).pushNamed(POSearchRightSideDrawer.routeName);
//             //Navigator.push(context, MaterialPageRoute(builder: (context) => POSearchRightSideDrawer()));
//             break;
//           case 4:
//             Navigator.of(context).pushNamed(StockSummarySideDrawer.routeName);
//             break;
//           case 5:
//             Navigator.of(context).pushNamed(NonMovingFilter.routeName);
//             break;
//           case 6:
//             Navigator.of(context).pushNamed(ValueWiseStockFilter.routeName);
//             break;
//           case 7:
//             Navigator.of(context).pushNamed(HighValueFilter.routeName);
//             break;
//           case 8:
//             Navigator.of(context).pushNamed(ConsumtionAnalysisFilter.routeName);
//             break;
//           case 9:
//             Navigator.of(context).pushNamed(ConsumtionSummaryFilter.routeName);
//             break;
//           case 10:
//           //Navigator.of(context).pushNamed(TransactionSearchDropDown.routeName);
//             Navigator.of(context).pushNamed(TransactionScreen.routeName);
//             break;
//           case 11:
//             Navigator.of(context).pushNamed(StatusDropDown.routeName);
//             break;
//           case 12:
//             Navigator.of(context).pushNamed(SummaryDropdown.routeName);
//             break;
//           case 13:
//             Navigator.of(context).pushNamed(CrnScreen.routeName);
//             break;
//           case 14:
//             Navigator.of(context).pushNamed(CrcScreen.routeName);
//             break;
//           case 15:
//             Navigator.of(context).pushNamed(StockItemHistorySheetScreen.routeName);
//             break;
//           case 16:
//             Navigator.of(context).pushNamed(NonStockDemandsScreen.routeName);
//             break;
//           case 17:
//             Navigator.of(context).pushNamed(GemOrderScreen.routeName);
//             break;
//           case 18:
//             Navigator.of(context).pushNamed(WarrantyRejectionScreen.routeName);
//             break;
//           case 19:
//             Navigator.of(context).pushNamed(NSDemandSummaryScreen.routeName);
//             break;
//           case 20:
//             Navigator.of(context).pushNamed(WarrantyComplaintDropdown.routeName);
//             break;
//           case 21:
//             Navigator.of(context).pushNamed(CrnSummaryScreen.routeName);
//             break;
//           case 22:
//             Navigator.of(context).pushNamed(StockingProposalSummaryScreen.routeName);
//             break;
//           case 23:
//             Navigator.of(context).pushNamed(WarrantyRejectionRegisterScreen.routeName);
//             break;
//           case 24:
//             Navigator.of(context).pushNamed(CrcSummaryScreen.routeName);
//             break;
//           case 25:
//             Navigator.of(context).pushNamed(ToEndUserScreen.routeName);
//             break;
//           case 26:
//             Navigator.of(context).pushNamed(WarrantyCRNSummaryScreen.routeName);
//             break;
//           default:
//         }
//       }
//     }
//     else{
//       if(gridno == '1') {
//         switch (itemIndex) {
//           case 0:
//             Navigator.push(context, MaterialPageRoute(builder: (context) => CustomRightSideDrawer()));
//             break;
//           case 1:
//             Navigator.push(context, MaterialPageRoute(builder: (context) => StockRightSideDrawer()));
//             break;
//           case 2:
//             Navigator.push(context, MaterialPageRoute(builder: (context) => StoreStkDepotRightSideDrawer()));
//             break;
//           case 3:
//             Navigator.of(context).pushNamed(POSearchRightSideDrawer.routeName);
//             //Navigator.push(context, MaterialPageRoute(builder: (context) => POSearchRightSideDrawer()));
//             break;
//           case 4:
//             Navigator.of(context).pushNamed(StockSummarySideDrawer.routeName);
//             break;
//           case 5:
//             Navigator.of(context).pushNamed(NonMovingFilter.routeName);
//             break;
//           case 6:
//             Navigator.of(context).pushNamed(ValueWiseStockFilter.routeName);
//             break;
//           case 7:
//             Navigator.of(context).pushNamed(HighValueFilter.routeName);
//             break;
//           case 8:
//             Navigator.of(context).pushNamed(ConsumtionAnalysisFilter.routeName);
//             break;
//           case 9:
//             Navigator.of(context).pushNamed(ConsumtionSummaryFilter.routeName);
//             break;
//           case 10:
//           //Navigator.of(context).pushNamed(TransactionSearchDropDown.routeName);
//             Navigator.of(context).pushNamed(TransactionScreen.routeName);
//             break;
//           case 11:
//             Navigator.of(context).pushNamed(StatusDropDown.routeName);
//             break;
//           case 12:
//             Navigator.of(context).pushNamed(SummaryDropdown.routeName);
//             break;
//           case 13:
//             Navigator.of(context).pushNamed(CrnScreen.routeName);
//             break;
//           case 14:
//             Navigator.of(context).pushNamed(CrcScreen.routeName);
//             break;
//           case 15:
//             Navigator.of(context).pushNamed(StockItemHistorySheetScreen.routeName);
//             break;
//           case 16:
//             Navigator.of(context).pushNamed(NonStockDemandsScreen.routeName);
//             break;
//           case 17:
//             Navigator.of(context).pushNamed(GemOrderScreen.routeName);
//             break;
//           case 18:
//             Navigator.of(context).pushNamed(WarrantyRejectionScreen.routeName);
//             break;
//           case 19:
//             Navigator.of(context).pushNamed(NSDemandSummaryScreen.routeName);
//             break;
//           case 20:
//             Navigator.of(context).pushNamed(WarrantyComplaintDropdown.routeName);
//             break;
//           case 21:
//             Navigator.of(context).pushNamed(CrnSummaryScreen.routeName);
//             break;
//           case 22:
//             Navigator.of(context).pushNamed(StockingProposalSummaryScreen.routeName);
//             break;
//           case 23:
//             Navigator.of(context).pushNamed(WarrantyRejectionRegisterScreen.routeName);
//             break;
//           case 24:
//             Navigator.of(context).pushNamed(CrcSummaryScreen.routeName);
//             break;
//           case 25:
//             Navigator.of(context).pushNamed(ToEndUserScreen.routeName);
//             break;
//           case 26:
//             Navigator.of(context).pushNamed(WarrantyCRNSummaryScreen.routeName);
//             break;
//           default:
//         }
//       }
//     }
//   }
//
//   void togglePanel() {
//     if(!expand) {
//       controller.forward(from: 0);
//     } else {
//       controller.reverse();
//     }
//     expand = !expand;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     LanguageProvider language = Provider.of<LanguageProvider>(context);
//     Size size = MediaQuery.of(context).size;
//     return WillPopScope(
//       onWillPop: () async{
//         AapoortiUtilities.showAlertDailog(context, "UDM");
//         return true;
//       },
//       //onWillPop: _onButtonPressed,
//       child: Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(
//               title: Text(language.text('udmFull'), style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
//               elevation: 0.0,
//               backgroundColor: AapoortiConstants.primary,
//               leading: IconButton(icon: SvgPicture.asset('assets/images/dashboard.svg', color: Colors.white, height: 22, width: 22), onPressed: () => _scaffoldKey.currentState!.openDrawer()),
//               actions: <Widget>[
//                 SwitchLanguageButton(),
//               ]
//           ),
//           drawer: navigationdrawer(context, size),
//           backgroundColor: Colors.grey.shade100,
//           bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
//           body: Padding(
//             padding: EdgeInsets.all(5),
//             child: ExpandableGrid(
//               children: gridOneItems,
//               action: onTapFunction,
//             ),
//           )),
//     );
//   }
//
//   Future<bool> _onButtonPressed() async {
//     return await showModalBottomSheet(
//             context: context,
//             builder: (context) {
//               return Container(
//                 color: Color(0xFF737373),
//                 height: 150,
//                 child: Container(
//                   child: _buildBottomNavigationMenu(),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).canvasColor,
//                     borderRadius: BorderRadius.only(
//                       topLeft: const Radius.circular(10),
//                       topRight: const Radius.circular(10),
//                     ),
//                   ),
//                 ),
//               );
//               // ignore: unnecessary_statements
//             }) ??
//         false;
//   }
//
//   Column _buildBottomNavigationMenu() {
//     LanguageProvider language = Provider.of<LanguageProvider>(context);
//     return Column(
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.vpn_key,
//               color: AapoortiConstants.primary,
//               size: 24,
//             ),
//             SizedBox(width: 5.0),
//             Text(
//               language.text('logOut'),
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.normal,
//                   fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//             Padding(padding: EdgeInsets.only(top: 40.0)),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               MaterialButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//                 child: Text(
//                   language.text('cancel'),
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 color: AapoortiConstants.primary,
//                 minWidth: 150,
//               ),
//               MaterialButton(
//                 onPressed: () {
//                   Future.delayed(Duration(milliseconds: 100), () {
//                     SchedulerBinding.instance.addPostFrameCallback((_) {
//                       Provider.of<LoginProvider>(context, listen: false).setState(LoginState.Idle);
//                       Navigator.of(context).pushReplacementNamed("/common_screen");
//                       //Navigator.of(context).pop(false);
//                       //exit(0);
//                     });
//                   });
//                 },
//                 child: Text(
//                   language.text('confirm'),
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 color: AapoortiConstants.primary,
//                 minWidth: 150,
//               )
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 35, top: 0.0, right: 55),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               TextButton(onPressed: (){
//                  Navigator.of(context).pop(false);
//                  WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
//                 }, child: Text(language.text('changeLogin'), style: TextStyle(
//                 decoration: TextDecoration.underline,
//                 decorationColor: AapoortiConstants.primary,
//                 fontSize: 15,
//                 color: AapoortiConstants.primary,
//               ))),
//               TextButton(onPressed: (){ IRUDMConstants.launchURL(play_store_url);}, child: Text(language.text('rateUs'), style: TextStyle(
//                 decoration: TextDecoration.underline,
//                 decorationColor: AapoortiConstants.primary,
//                 fontSize: 15,
//                 color: AapoortiConstants.primary,
//               ))),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget navigationdrawer(BuildContext context, Size size) {
//     LanguageProvider language = Provider.of<LanguageProvider>(context);
//     return Drawer(
//       width: size.width * 0.80,
//       child: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: <Widget>[
//                 Container(
//                     constraints: BoxConstraints.expand(height: size.height * 0.25),
//                     padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
//                     decoration: BoxDecoration(
//                       color: AapoortiConstants.primary,
//                       // image: DecorationImage(
//                       //   colorFilter: ColorFilter.mode(
//                       //     Colors.black38,
//                       //     BlendMode.darken,
//                       //   ),
//                       //   image: AssetImage('assets/welcome.jpg'), fit: BoxFit.cover,
//                       // ),
//                       borderRadius: BorderRadius.only(topRight: Radius.circular(16.0))
//                     ),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
//                       },
//                       child: Row(
//                         children: <Widget>[
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               CircleAvatar(
//                                 radius: 30,
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Icons.person,
//                                   size: 40,
//                                   color: AapoortiConstants.primary,
//                                 ),
//                               ),
//                               Text(language.text('welcome'), style: TextStyle(color: Colors.white, fontSize: 15.0)),
//                               Text(username!, style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20.0)),
//                               Text(email!, style: TextStyle(color: Colors.white, fontSize: 15.0)),
//                             ],
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: <Widget>[
//                               Icon(
//                                 Icons.arrow_forward_ios,
//                                 color: Colors.white,
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                 ),
//                 ListTile(
//                     onTap: () async {
//                       Navigator.pop(context);
//                       Navigator.of(context).pushNamed(UdmChangePin.routeName);
//                     },
//                     leading: Icon(
//                       Icons.pin_drop,
//                       color: Colors.black, size: 20
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
//                     title: Text(
//                       language.text('changePin'),
//                       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                     )
//                 ),
//                 // ListTile(
//                 //     onTap: () => IRUDMConstants.launchURL(play_store_url),
//                 //     leading: Icon(
//                 //       Icons.star,
//                 //       color: Colors.black, size: 20
//                 //     ),
//                 //     trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
//                 //     title: Text(
//                 //       language.text('rateUs'),
//                 //       style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
//                 //     )
//                 // ),
//               ],
//             ),
//           ),
//           Align(
//               alignment: Alignment.center,
//               child: Column(
//                 children: [
//                   // Text(
//                   //   "${language.text('version')} : " +
//                   //       localCurrVer +
//                   //       ' (' +
//                   //       versionName +
//                   //       ')',
//                   //   style: TextStyle(
//                   //     color: Colors.grey,
//                   //   ),
//                   // ),
//                   InkWell(
//                     onTap: () {
//                       if(_scaffoldKey.currentState!.isDrawerOpen) {
//                          _scaffoldKey.currentState!.closeDrawer();
//                         //_showConfirmationDialog(context);
//                          WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
//                         //callWebServiceLogout();
//                       }
//                     },
//                     child: Container(
//                       height: 45,
//                       color: AapoortiConstants.primary,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.logout, color: Colors.white),
//                           SizedBox(width: 10),
//                           Text(language.text('logout'), style: TextStyle(fontSize: 16, color: Colors.white))
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               )
//           ),
//         ],
//       ),
//     );
//   }
//
//   var play_store_url = 'https://play.google.com/store/apps/details?id=in.gov.ireps';
//
//   void callWebServiceLogout() async {
//     IRUDMConstants.showProgressIndicator(context);
//     var loginprovider = Provider.of<LoginProvider>(context, listen: false);
//     List<dynamic>? jsonResult;
//     try {
//       jsonResult = await fetchPostPostLogin(loginprovider.user!.ctoken!, loginprovider.user!.stoken!, loginprovider.user!.map_id!);
//       IRUDMConstants.removeProgressIndicator(context);
//       if(jsonResult![0]['logoutstatus'] == "You have been successfully logged out.") {
//         dbHelper.deleteSaveLoginUser();
//         loginprovider.setState(LoginState.FinishedWithError);
//         SchedulerBinding.instance.addPostFrameCallback((_) {
//           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), ModalRoute.withName("/login-screen"));
//           //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen());
//         });
//       }
//     } on HttpException {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } on SocketException {
//       IRUDMConstants()
//           .showSnack("No connectivity. Please check your connection.", context);
//     } on FormatException {
//       IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
//     } catch (err) {}
//   }
//
//   Future<List<dynamic>?> fetchPostPostLogin(String cTocken, String sTocken, String mapId) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var response = await Network.postDataWithAPIM(
//         'UDM/UdmAppLogin/V1.0.0/UdmAppLogin',
//         'UdmLogout',
//         cTocken + '~' + sTocken + '~' + mapId,
//         prefs.getString('token'));
//     if (response.statusCode == 200) {
//       var jsonResult = json.decode(response.body);
//       return jsonResult['data'];
//     } else {
//       return IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
//     }
//   }
//
//   void showWarningDialog(BuildContext context) {
//     showDialog(context: context, builder: (ctx) => AlertDialog(
//         title: const Text("Message!!"),
//         content: const Text("This utility has been temporarily discontinued due to scheduled maintenance."),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//             child: Container(
//               height : 45,
//               width : 60,
//               alignment : Alignment.center,
//               decoration : BoxDecoration(
//                 color: Colors.red,
//                 border: Border.all(
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: const Text("OK", style : TextStyle(color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static String shortName(String? usern){
//     String initials = '';
//     List<String> splitName = usern!.split('');
//     if (splitName[0].isNotEmpty) {
//       initials += splitName[0][0].toUpperCase();
//     }
//     if (splitName.length > 1) {
//       if(splitName[splitName.length - 1].isNotEmpty) {
//         initials += splitName[splitName.length - 1][0].toUpperCase();
//       }
//     }
//     return initials;
//   }
//
//   // Future getVersion() async {
//   //   String basicAuth;
//   //   String url = new UtilsFromHelper().getValueFromKey("mobile_app_version");
//   //
//   //   basicAuth = await Hrmstokenplugin.hrmsToken;
//   //
//   //   HttpClient client = new HttpClient();
//   //   client.badCertificateCallback =
//   //   ((X509Certificate cert, String host, int port) => true);
//   //   Map map = {
//   //     'name': "anything",
//   //   };
//   //
//   //   HttpClientRequest request = await client.postUrl(Uri.parse(url));
//   //   request.headers.set('content-type', 'application/json');
//   //
//   //   request.headers.set('authorization', basicAuth);
//   //   request.add(utf8.encode(json.encode(map)));
//   //   HttpClientResponse response = await request.close();
//   //
//   //   String value = await response.transform(utf8.decoder).join();
//   //   var responseJSON = await json.decode(value) as Map;
//   //   print('reponse $responseJSON');
//   //   if(int.parse(responseJSON['mobileAppData']['utility_value']) >
//   //       BuildConfig.VERSION_CODE) {
//   //     _showDialog(responseJSON['mobileAppData']['remarks']);
//   //   }
//   // }
//
// // void _showDialog(String title) {
//   //   showDialog(
//   //     barrierDismissible: false,
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return WillPopScope(
//   //           onWillPop: () {
//   //             return Future.value(false);
//   //           },
//   //           child: AlertDialog(
//   //             title: Text("Update Required", style: TextStyle(fontSize: 15.0)),
//   //             content: Text(title, style: TextStyle(fontSize: 13.0)),
//   //             actions: <Widget>[
//   //               MaterialButton(
//   //                 child: Text("UPGRADE"),
//   //                 onPressed: () {
//   //                   _playstorelaunchURL();
//   //                 },
//   //               ),
//   //             ],
//   //           ));
//   //     },
//   //   );
//   // }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:flutter_app/udm/localization/languageHelper.dart';
import 'package:flutter_app/udm/transaction/transaction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view/crc_screen.dart';
import 'package:flutter_app/udm/crc_summary/view/crc_summary_screen.dart';
import 'package:flutter_app/udm/crn_digitally_signed/view/crn_screen.dart';
import 'package:flutter_app/udm/crn_summary/view/crn_summary_screen.dart';
import 'package:flutter_app/udm/end_user/view/to_user_end_screen.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/non_stock_demands/views/non_stock_demands_screen.dart';
import 'package:flutter_app/udm/ns_demand_summary/view/nsdemandsummary_screen.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryDropdown.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/loginProvider.dart';
import 'package:flutter_app/udm/providers/versionProvider.dart';
import 'package:flutter_app/udm/rejection_warranty/views/warranty_rejection_screen.dart';
import 'package:flutter_app/udm/screens/UdmChangePin.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_items_history_sheet_screen.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view/stocking_proposal_summary_screen.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/view/Warranty_dropdownScreen.dart';
import 'package:flutter_app/udm/warranty_crn_summary/view/warranty_crn_summary_screen.dart';
import 'package:flutter_app/udm/widgets/bottom_Nav/bottom_nav.dart';
import 'package:flutter_app/udm/widgets/consuptionAnalysisFilter.dart';
import 'package:flutter_app/udm/widgets/consuptionSummaryFilter.dart';
import 'package:flutter_app/udm/widgets/custom_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/warningalert_dialog.dart';
import 'package:flutter_app/udm/widgets/highValueFilter.dart';
import 'package:flutter_app/udm/widgets/nonMovingFilter.dart';
import 'package:flutter_app/udm/widgets/poSearch_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/stock_rightside_drawer.dart';
import 'package:flutter_app/udm/widgets/stock_summary_drawer.dart';
import 'package:flutter_app/udm/widgets/storeDepot_rightside_drawer.dart';
import 'package:flutter_app/udm/valuewisestock/view/valueWiseStockFilter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../gemorder/gem_OrderDetails/view/gem_order_screen.dart';
import '../onlineBillStatus/statusDropdown.dart';

import 'package:permission_handler/permission_handler.dart';

import '../warranty_rejection_register/view/warranty_rejection_register_screen.dart';
import 'Profile.dart';
import 'login_screen.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = "/user-home-screen";

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> with TickerProviderStateMixin {

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  List<Map<String, dynamic>> gridOneItems = [
    {'icon': 'assets/item1.png', 'label': 'आइटम खोजें\nSearch Item'},
    {
      'icon': 'assets/item_search.png',
      'label': 'स्टॉक उपलब्धता\nStock Availability'
    },
    {
      'icon': 'assets/depot_store.png',
      'label': 'भण्डार डिपो स्टॉक\nStores Depot Stock'
    },
    {
      'icon': 'assets/images/po_search.png',
      'label': 'क्रयादेश ढूँढें \nSearch PO'
    },
    {
      'icon': 'assets/summary.png',
      'label': 'स्टॉक का संक्षिप्त विवरण\nSummary of Stock'
    },
    {
      'icon': 'assets/images/non_moving.png',
      'label': 'नॉन-मूविंग आइटम\nNon-Moving Items'
    },
    {
      'icon': 'assets/valueWise.png',
      'label': 'वैल्यू अनुसार स्टॉक\nValue-Wise Stock'
    },
    {
      'icon': 'assets/highValue.png',
      'label': 'उच्च वैल्यू आइटम\nHigh Value Items'
    },
    {
      'icon': 'assets/analysis.png',
      'label': 'खपत का विश्लेषण\nConsumption Analysis'
    },
    {
      'icon': 'assets/cons_summary.png',
      'label': 'खपत का संक्षिप्त विवरण\nConsumption Summary'
    },
    {
      'icon': 'assets/trans.png',
      'label': 'लेनदेन\nTransactions',
    },
    {
      'icon': 'assets/download.png',
      'label': 'ऑनलाइन बिल की स्थितिं \nOn-Line Bill Status'
    },
    {
      'icon': 'assets/edoc_home.png',
      'label': 'ऑनलाइन बिल सारांश \nOn-Line Bill Summary'
    },
    {
      'icon': 'assets/images/crn.png',
      'label': 'सी.आर.एन \nCRN'
    },
    {
      'icon': 'assets/images/udm_crc.png',
      'label': 'सी.आर.सी \nCRC'
    },
    {
      'icon': 'assets/stock.jpg',
      'label': 'स्टॉक आइटम इतिहास पत्रक \nStk. Item History Sheet'
    },
    {
      'icon': 'assets/images/ns_demands.png',
      'label': 'गैर-स्टॉक मांगें \nNS Demands'
    },
    {
      'icon': 'assets/images/gem.svg',
      'label': 'रत्न-आदेश विवरण \nGeM Order Details'
    },
    {
      'icon': 'assets/images/warranty.png',
      'label': 'अस्वीकृति/वारंटी \nRejection/Warranty'
    },
    {
      'icon': 'assets/images/demand.jpg',
      'label': 'एनएस डिमांड सारांश \nNS Demand Summary'
    },
    {
      'icon': 'assets/report_icon.png',
      'label': 'वारंटी शिकायत सारांश \nWarranty Complaint Summary'
    },
    {
      'icon': 'assets/images/summary.jpg',
      'label': 'सीआरएन सारांश \nCRN Summary'
    },
    {
      'icon': 'assets/images/stock_sm.jpg',
      'label': 'स्टॉकिंग प्रस्ताव सारांश \nStocking Proposal Summary'
    },
    {
      'icon': 'assets/images/rejection.png',
      'label': 'वारंटी अस्वीकृति रजिस्टर \nWarranty Rejection Register'
    },
    {
      'icon': 'assets/images/crc.png',
      'label': 'सीआरसी सारांश \nCRC Summary'
    },
    {
      'icon': 'assets/images/warranty.png',
      'label': 'अस्वीकृति/वारंटी \nRejection/Warranty'
    },
    {
      'icon': 'assets/images/demand.jpg',
      'label': 'एनएस मांग सारांश \nNS Demand Summary'
    },
    {
      'icon': 'assets/report_icon.png',
      'label': 'वारंटी शिकायत सारांश \nWarranty Complaint Summary'
    },
    {
      'icon': 'assets/images/summary.jpg',
      'label': 'सीआरएन सारांश \nCRN Summary'
    },
    {
      'icon': 'assets/images/stock_sm.jpg',
      'label': 'स्टॉकिंग प्रस्ताव सारांश \nStocking Proposal Summary'
    },
    {
      'icon': 'assets/images/rejection.png',
      'label': 'वारंटी अस्वीकृति रजिस्टर \nWarranty Rejection Register'
    },
    {
      'icon': 'assets/images/crc.png',
      'label': 'सीआरसी सारांश \nCRC Summary'
    },

    // {
    //   'icon': 'assets/images/end_user.png',
    //   'label': 'अंतिम उपयोगकर्ता के लिए \nTo End User'
    // },
    // {
    //   'icon': 'assets/images/wcs.png',
    //   'label': 'वारंटी सीआरएन सारांश \nWarranty CRN Summary'
    // },
  ];

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  late List<Map<String, dynamic>> dbResult;
  String? username = '', email = '';
  late LoginProvider itemListProvider;
  VersionProvider? versionProvider;
  String localCurrVer = '', versionName = '';

  bool _showSearchResults = false;

  // Animation
  bool expand = false;
  late AnimationController controller;
  late Animation<double> animation, animationView;

  int _selectedIndex = 0;
  bool _isEnglish = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final Map<String, String> _translations = {
    'User Depot Module': 'यूजर डिपो मॉड्यूल',
    'Search Item': 'आइटम खोजें',
    'Stock Availability': 'स्टॉक उपलब्धता',
    'Stores Depot': 'भण्डार डिपो स्टॉक',
    'Summary of Stock': 'स्टॉक का संक्षिप्त विवरण',
    'Non-Moving Items': 'नॉन-मूविंग आइटम',
    'Value-Wise Stock': 'वैल्यू अनुसार स्टॉक',
    'High Value Items': 'उच्च वैल्यू आइटम',
    'Stk. Item History Sheet' : 'स्टॉक आइटम इतिहास पत्रक',
    'Search PO': 'क्रयादेश ढूँढें',
    'Consumption Analysis': 'खपत का विश्लेषण',
    'Consumption Summary': 'खपत का संक्षिप्त विवरण',
    'Transactions': 'लेन-देन',
    'On-Line Bill Status': 'ऑनलाइन बिल की स्थितिं',
    'On-Line Bill Summary': 'ऑनलाइन बिल सारांश',
    'CRN': 'सीआरएन',
    'CRC': 'सीआरसी',
    'NS Demands': 'गैर-स्टॉक मांगें',
    'GeM Order Details': 'जीईएम ऑर्डर विवरण',
    'Inventory Management': 'इन्वेंटरी प्रबंधन',
    'Reports & Transactions': 'रिपोर्ट और लेनदेन',
    'Home': 'होम',
    'Profile': 'प्रोफाइल',
    'Search for items, stocks, orders...': 'आइटम, स्टॉक, ऑर्डर खोजें...',
    'No results found for': 'के लिए कोई परिणाम नहीं मिला',
    'Search Results': 'खोज परिणाम',
    'Rejection/Warranty':'अस्वीकृति/वारंटी',
    'NS Demand Summary' : 'एनएस मांग सारांश',
    'Warranty Complaint' : 'वारंटी शिकायत सारांश',
    'CRN Summary' : 'सीआरएन सारांश',
    'Stocking Proposal Summary' : 'स्टॉकिंग प्रस्ताव सारांश',
    'Warranty Rejection Register' : 'वारंटी अस्वीकृति रजिस्टर',
    'CRC Summary' : 'सीआरसी सारांश',
  };

  void initState() {
    //Provider.of<NetworkProvider>(context, listen: false);
    // Animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _searchController.addListener(_onSearchChanged);

    requestWritePermission();
    getVersion();
    fetchUserData();
    _checkLanguage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), () {
        togglePanel();
      });
    });
    super.initState();
  }

  void requestWritePermission() async {
    PermissionStatus permissionStatus = await Permission.storage.request();
    if(!permissionStatus.isGranted) {
      bool isshown = await Permission.storage.shouldShowRequestRationale;
      Map<Permission, PermissionStatus> permissions = await [Permission.storage].request();
      if(this.mounted) setState(() {});
    } else {
      if(this.mounted) setState(() {});
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("notice")) {
      if (prefs.getString("notice") != "") {
        showHomeNoticeDialog(context, prefs.get('notice') as String?,
            prefs.get('noticetitile') as String?);
      }
    }
  }

  Future<void> getVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      localCurrVer = packageInfo.version;
      versionName = packageInfo.buildNumber;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _showSearchResults = _searchQuery.isNotEmpty;
    });
  }

  showHomeNoticeDialog(context, String? msg, String? title) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String message = msg!;
        String btnLabel = "Okay";
        return AlertDialog(
          title: Text(title!),
          content: Text(message),
          actions: <Widget>[
            MaterialButton(
                child: Text(btnLabel),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('notice', '');
                  prefs.setString('noticetitile', '');
                  Navigator.of(context, rootNavigator: true).pop();
                }),
          ],
        );
      },
    );
  }

  // void versionControl() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   version = "${packageInfo.version}:${packageInfo.buildNumber}";
  //   print("Versionutil = " + version);
  // }

  // Future<void> getVersion() async {
  //   final _checker = AppVersionChecker();
  //   //Provider.of<VersionProvider>(context, listen: false).fetchVersion(context);
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   setState(() {
  //     localCurrVer = packageInfo.version;
  //     versionName = packageInfo.buildNumber;
  //   });
  //   // _checker.checkUpdate().then((value) {
  //   //   if(value.canUpdate) {
  //   //         showDialog(context: context, builder: (BuildContext context) {
  //   //           return UpdateDialog(
  //   //             allowDismissal: true,
  //   //             description: "Please update your app from ${value.currentVersion} to ${value.newVersion} for access more functionality.",
  //   //             version: value.newVersion!,
  //   //             appLink: value.appURL!,
  //   //           );
  //   //         });
  //   //     }
  //   // });
  // }

  Future<void> fetchUserData() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var dbResult = await dbHelper.fetchSaveLoginUser();
      if (dbResult.isNotEmpty) {
        setState(() {
          username = prefs.getString('name');
          //username = dbResult[0][DatabaseHelper.Tb3_col8_userName];
          email = dbResult[0][DatabaseHelper.Tb3_col5_emailid];
        });
      }
    } catch (err) {}
  }

  Future<void> onTapFunction(String gridno, int itemIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if(providedTime.isBefore(DateTime.now())){
      await fetchToken(context);
      if(gridno == '1') {
        switch (itemIndex) {
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (context) => CustomRightSideDrawer()));
            break;
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => StockRightSideDrawer()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => StoreStkDepotRightSideDrawer()));
            break;
          case 3:
            Navigator.of(context).pushNamed(POSearchRightSideDrawer.routeName);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => POSearchRightSideDrawer()));
            break;
          case 4:
            Navigator.of(context).pushNamed(StockSummarySideDrawer.routeName);
            break;
          case 5:
            Navigator.of(context).pushNamed(NonMovingFilter.routeName);
            break;
          case 6:
            Navigator.of(context).pushNamed(ValueWiseStockFilter.routeName);
            break;
          case 7:
            Navigator.of(context).pushNamed(HighValueFilter.routeName);
            break;
          case 8:
            Navigator.of(context).pushNamed(ConsumtionAnalysisFilter.routeName);
            break;
          case 9:
            Navigator.of(context).pushNamed(ConsumtionSummaryFilter.routeName);
            break;
          case 10:
          //Navigator.of(context).pushNamed(TransactionSearchDropDown.routeName);
            Navigator.of(context).pushNamed(TransactionScreen.routeName);
            break;
          case 11:
            Navigator.of(context).pushNamed(StatusDropDown.routeName);
            break;
          case 12:
            Navigator.of(context).pushNamed(SummaryDropdown.routeName);
            break;
          case 13:
            Navigator.of(context).pushNamed(CrnScreen.routeName);
            break;
          case 14:
            Navigator.of(context).pushNamed(CrcScreen.routeName);
            break;
          case 15:
            Navigator.of(context).pushNamed(StockItemHistorySheetScreen.routeName);
            break;
          case 16:
            Navigator.of(context).pushNamed(NonStockDemandsScreen.routeName);
            break;
          case 17:
            Navigator.of(context).pushNamed(GemOrderScreen.routeName);
            break;
          case 18:
            Navigator.of(context).pushNamed(WarrantyRejectionScreen.routeName);
            break;
          case 19:
            Navigator.of(context).pushNamed(NSDemandSummaryScreen.routeName);
            break;
          case 20:
            Navigator.of(context).pushNamed(WarrantyComplaintDropdown.routeName);
            break;
          case 21:
            Navigator.of(context).pushNamed(CrnSummaryScreen.routeName);
            break;
          case 22:
            Navigator.of(context).pushNamed(StockingProposalSummaryScreen.routeName);
            break;
          case 23:
            Navigator.of(context).pushNamed(WarrantyRejectionRegisterScreen.routeName);
            break;
          case 24:
            Navigator.of(context).pushNamed(CrcSummaryScreen.routeName);
            break;
          case 25:
            Navigator.of(context).pushNamed(ToEndUserScreen.routeName);
            break;
          case 26:
            Navigator.of(context).pushNamed(WarrantyCRNSummaryScreen.routeName);
            break;
          default:
        }
      }
    }
    else{
      if(gridno == '1') {
        switch (itemIndex) {
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (context) => CustomRightSideDrawer()));
            break;
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => StockRightSideDrawer()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => StoreStkDepotRightSideDrawer()));
            break;
          case 3:
            Navigator.of(context).pushNamed(POSearchRightSideDrawer.routeName);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => POSearchRightSideDrawer()));
            break;
          case 4:
            Navigator.of(context).pushNamed(StockSummarySideDrawer.routeName);
            break;
          case 5:
            Navigator.of(context).pushNamed(NonMovingFilter.routeName);
            break;
          case 6:
            Navigator.of(context).pushNamed(ValueWiseStockFilter.routeName);
            break;
          case 7:
            Navigator.of(context).pushNamed(HighValueFilter.routeName);
            break;
          case 8:
            Navigator.of(context).pushNamed(ConsumtionAnalysisFilter.routeName);
            break;
          case 9:
            Navigator.of(context).pushNamed(ConsumtionSummaryFilter.routeName);
            break;
          case 10:
          //Navigator.of(context).pushNamed(TransactionSearchDropDown.routeName);
            Navigator.of(context).pushNamed(TransactionScreen.routeName);
            break;
          case 11:
            Navigator.of(context).pushNamed(StatusDropDown.routeName);
            break;
          case 12:
            Navigator.of(context).pushNamed(SummaryDropdown.routeName);
            break;
          case 13:
            Navigator.of(context).pushNamed(CrnScreen.routeName);
            break;
          case 14:
            Navigator.of(context).pushNamed(CrcScreen.routeName);
            break;
          case 15:
            Navigator.of(context).pushNamed(StockItemHistorySheetScreen.routeName);
            break;
          case 16:
            Navigator.of(context).pushNamed(NonStockDemandsScreen.routeName);
            break;
          case 17:
            Navigator.of(context).pushNamed(GemOrderScreen.routeName);
            break;
          case 18:
            Navigator.of(context).pushNamed(WarrantyRejectionScreen.routeName);
            break;
          case 19:
            Navigator.of(context).pushNamed(NSDemandSummaryScreen.routeName);
            break;
          case 20:
            Navigator.of(context).pushNamed(WarrantyComplaintDropdown.routeName);
            break;
          case 21:
            Navigator.of(context).pushNamed(CrnSummaryScreen.routeName);
            break;
          case 22:
            Navigator.of(context).pushNamed(StockingProposalSummaryScreen.routeName);
            break;
          case 23:
            Navigator.of(context).pushNamed(WarrantyRejectionRegisterScreen.routeName);
            break;
          case 24:
            Navigator.of(context).pushNamed(CrcSummaryScreen.routeName);
            break;
          case 25:
            Navigator.of(context).pushNamed(ToEndUserScreen.routeName);
            break;
          case 26:
            Navigator.of(context).pushNamed(WarrantyCRNSummaryScreen.routeName);
            break;
          default:
        }
      }
    }
  }

  void togglePanel() {
    if(!expand) {
      controller.forward(from: 0);
    } else {
      controller.reverse();
    }
    expand = !expand;
  }

  final List<MenuItemData> _inventoryItems = [
    MenuItemData(
      title: 'Search Item',
      icon: Icons.search,
      color: const Color(0xFF4285F4),
      bgColor: const Color(0xFFE8F0FE),
    ),
    MenuItemData(
      title: 'Stock Availability',
      icon: Icons.analytics_outlined,
      color: const Color(0xFF34A853),
      bgColor: const Color(0xFFE6F4EA),
    ),
    MenuItemData(
      title: 'Stores Depot',
      icon: Icons.store,
      color: const Color(0xFF673AB7),
      bgColor: const Color(0xFFF3E5F5),
    ),
    MenuItemData(
      title: 'Summary of Stock',
      icon: Icons.bar_chart,
      color: const Color(0xFF009688),
      bgColor: const Color(0xFFE0F2F1),
    ),
    MenuItemData(
      title: 'Non-Moving Items',
      icon: Icons.inventory_2,
      color: const Color(0xFFFF6D00),
      bgColor: const Color(0xFFFFF3E0),
    ),
    MenuItemData(
      title: 'Value-Wise Stock',
      icon: Icons.trending_up,
      color: const Color(0xFF4CAF50),
      bgColor: const Color(0xFFE8F5E9),
    ),
    MenuItemData(
      title: 'High Value Items',
      icon: Icons.attach_money,
      color: const Color(0xFFFFB300),
      bgColor: const Color(0xFFFFF8E1),
    ),
    MenuItemData(
      title: 'Stk. Item History Sheet',
      icon: Icons.history,
      color: const Color(0xFF43A047),
      bgColor: const Color(0xFFE8F5E9),
    ),
  ];

  final List<MenuItemData> _reportsItems = [
    MenuItemData(
      title: 'Search PO',
      icon: Icons.receipt_long,
      color: const Color(0xFF03A9F4),
      bgColor: const Color(0xFFE1F5FE),
    ),
    MenuItemData(
      title: 'Consumption Analysis',
      icon: Icons.pie_chart,
      color: const Color(0xFF7E57C2),
      bgColor: const Color(0xFFEDE7F6),
    ),
    MenuItemData(
      title: 'Consumption Summary',
      icon: Icons.assessment,
      color: const Color(0xFF00ACC1),
      bgColor: const Color(0xFFE0F7FA),
    ),
    MenuItemData(
      title: 'Transactions',
      icon: Icons.swap_horiz,
      color: const Color(0xFFEC407A),
      bgColor: const Color(0xFFFCE4EC),
    ),
    MenuItemData(
      title: 'On-Line Bill Status',
      icon: Icons.receipt,
      color: const Color(0xFF3949AB),
      bgColor: const Color(0xFFE8EAF6),
    ),
    MenuItemData(
      title: 'On-Line Bill Summary',
      icon: Icons.description,
      color: const Color(0xFF5E35B1),
      bgColor: const Color(0xFFEDE7F6),
    ),
    MenuItemData(
      title: 'CRN',
      icon: Icons.assignment,
      color: const Color(0xFFE53935),
      bgColor: const Color(0xFFFFEBEE),
    ),
    MenuItemData(
      title: 'CRC',
      icon: Icons.category,
      color: const Color(0xFF039BE5),
      bgColor: const Color(0xFFE1F5FE),
    ),
    MenuItemData(
      title: 'NS Demands',
      icon: Icons.assignment_turned_in,
      color: const Color(0xFF455A64),
      bgColor: const Color(0xFFECEFF1),
    ),
    MenuItemData(
      title: 'GeM Order Details',
      icon: Icons.shopping_bag,
      color: const Color(0xFF212121),
      bgColor: const Color(0xFFF5F5F5),
    ),
    // New items added below
    MenuItemData(
      title: 'Rejection/Warranty',
      icon: Icons.warning_amber,
      color: const Color(0xFFF44336),
      bgColor: const Color(0xFFFFEBEE),
    ),
    MenuItemData(
      title: 'NS Demand Summary',
      icon: Icons.summarize,
      color: const Color(0xFF795548),
      bgColor: const Color(0xFFEFEBE9),
    ),
    MenuItemData(
      title: 'Warranty Complaint',
      icon: Icons.report_problem,
      color: const Color(0xFFFF9800),
      bgColor: const Color(0xFFFFF3E0),
    ),
    MenuItemData(
      title: 'CRN Summary',
      icon: Icons.list_alt,
      color: const Color(0xFF9C27B0),
      bgColor: const Color(0xFFF3E5F5),
    ),
    MenuItemData(
      title: 'Stocking Proposal Summary',
      icon: Icons.inventory,
      color: const Color(0xFF3F51B5),
      bgColor: const Color(0xFFE8EAF6),
    ),
    MenuItemData(
      title: 'Warranty Rejection Register',
      icon: Icons.do_not_disturb,
      color: const Color(0xFFD32F2F),
      bgColor: const Color(0xFFFFEBEE),
    ),
    MenuItemData(
      title: 'CRC Summary',
      icon: Icons.checklist,
      color: const Color(0xFF0097A7),
      bgColor: const Color(0xFFE0F7FA),
    ),
  ];

  List<MenuItemData> get _allItems => [..._inventoryItems, ..._reportsItems];

  List<MenuItemData> get _filteredItems {
    if(_searchQuery.isEmpty) {
      return [];
    }

    final query = _searchQuery.toLowerCase();
    return _allItems.where((item) {
      final title = item.title.toLowerCase();
      final translatedTitle = _translations[item.title]?.toLowerCase() ?? ""; // Ensure it’s not null

      return title.contains(query) || translatedTitle.contains(query);
    }).toList();
  }

  // List<MenuItemData> get _filteredItems {
  //   debugPrint("filter1 $_searchQuery");
  //   if(_searchQuery.isEmpty) {
  //     return [];
  //   }
  //
  //   debugPrint("filter2 $_searchQuery");
  //   final query = _searchQuery.toLowerCase();
  //   return _allItems.where((item) =>
  //   item.title.toLowerCase().contains(query) || _translations[item.title]!.toLowerCase().contains(query)
  //   ).toList();
  // }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async{
        AapoortiUtilities().showAlertDailog(context, "UDM");
        return true;
      },
      //onWillPop: _onButtonPressed,
      child: Scaffold(
        key: _scaffoldKey,

        // appBar: AppBar(
        //     title: Text(language.text('udmFull'), style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
        //     elevation: 0.0,
        //     backgroundColor: AapoortiConstants.primary,
        //     leading: IconButton(icon: SvgPicture.asset('assets/images/dashboard.svg', color: Colors.white, height: 22, width: 22), onPressed: () => _scaffoldKey.currentState!.openDrawer()),
        //     actions: <Widget>[
        //      SwitchLanguageButton(),
        //     ]
        // ),
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
                language.text('udmFull'),
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        drawer: navigationdrawer(context, size),
        backgroundColor: Colors.grey.shade100,
        //bottomNavigationBar: _buildBottomNavigationBar(),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              //_buildHeader(),
              _buildSearchBar(),
              Expanded(
                child: _showSearchResults ? _buildSearchResults() : _buildMainContent(),
              ),
            ],
          ),
        ),
        // body: Padding(
        //   padding: EdgeInsets.all(5),
        //   child: ExpandableGrid(
        //     children: gridOneItems,
        //     action: onTapFunction,
        //   ),
        // )
      ),
    );
  }

  Future<bool> _onButtonPressed() async {
    return await showModalBottomSheet(
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
          // ignore: unnecessary_statements
        }) ??
        false;
  }

  Widget _buildMainContent() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _buildCategorySection(
          _translate('Inventory Management'),
          _inventoryItems,
          Colors.blue.shade700,
        ),
        const SizedBox(height: 24),
        _buildCategorySection(
          _translate('Reports & Transactions'),
          _reportsItems,
          Colors.deepPurple.shade700,
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final results = _filteredItems;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _isEnglish ? '${_translate("No results found for")} "$_searchQuery"' : '"$_searchQuery" ${_translate("No results found for")}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${_translate("Search Results")} (${results.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: results.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = results[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                  ),
                ),
                title: Text(
                  _translate(item.title),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  _clearSearch();
                  _navigate(_translate(item.title));
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //     content: Text('${_translate(item.title)} ${_isEnglish ? 'selected' : 'चुना गया'}'),
                  //     duration: const Duration(seconds: 1),
                  //   ));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  _scaffoldKey.currentState!.openDrawer();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                      Icons.grid_view_rounded, color: Colors.white),
                ),
              ),
              //     const SizedBox(width: 16),
              //     const Text(
              //       'User Depot Module',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(width: 16),
              Text(
                _translate('User Depot Module'), // Use the translation here
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GestureDetector(
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
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: _translate('Search for items, stocks, orders...'),
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF0D47A1)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Color(0xFF0D47A1)),
            onPressed: _clearSearch,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _showSearchResults = _searchQuery.isNotEmpty;
          });
        },
        onFieldSubmitted: (value) {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildCategorySection(String title, List<MenuItemData> items, Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),


          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildMenuCard(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(MenuItemData item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
            if (providedTime.isBefore(DateTime.now())) {
              await fetchToken(context);
              _navigate(_translate(item.title));
            } else {
              _navigate(_translate(item.title));
            }

          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 24,
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Text(
                    _translate(item.title),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          index == 0 ? Navigator.of(context).pushReplacementNamed(UserHomeScreen.routeName) : Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: _translate('Home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: _translate('Profile'),
          ),
        ],
      ),
    );
  }

  Column _buildBottomNavigationMenu() {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.vpn_key,
              color: AapoortiConstants.primary,
              size: 24,
            ),
            SizedBox(width: 5.0),
            Text(
              language.text('logOut'),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(top: 40.0)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  language.text('cancel'),
                  style: TextStyle(color: Colors.white),
                ),
                color: AapoortiConstants.primary,
                minWidth: 150,
              ),
              MaterialButton(
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 100), () {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Provider.of<LoginProvider>(context, listen: false).setState(LoginState.Idle);
                      Navigator.of(context).pushReplacementNamed("/common_screen");
                      //Navigator.of(context).pop(false);
                      //exit(0);
                    });
                  });
                },
                child: Text(
                  language.text('confirm'),
                  style: TextStyle(color: Colors.white),
                ),
                color: AapoortiConstants.primary,
                minWidth: 150,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, top: 0.0, right: 55),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(onPressed: (){
                Navigator.of(context).pop(false);
                WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
              }, child: Text(language.text('changeLogin'), style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: AapoortiConstants.primary,
                fontSize: 15,
                color: AapoortiConstants.primary,
              ))),
              TextButton(onPressed: (){ IRUDMConstants.launchURL(play_store_url);}, child: Text(language.text('rateUs'), style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: AapoortiConstants.primary,
                fontSize: 15,
                color: AapoortiConstants.primary,
              ))),
            ],
          ),
        ),
      ],
    );
  }

  Widget navigationdrawer(BuildContext context, Size size) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Drawer(
      width: size.width * 0.80,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                    constraints: BoxConstraints.expand(height: size.height * 0.25),
                    padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0D47A1), // Dark Blue
                          Color(0xFF1976D2), // Lighter Blue
                        ],
                      ),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(16.0))
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                      },
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AapoortiConstants.primary,
                                ),
                              ),
                              Text(language.text('welcome'), style: TextStyle(color: Colors.white, fontSize: 15.0)),
                              Text(username!, style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0)),
                              Text(email!, style: TextStyle(color: Colors.white, fontSize: 15.0)),
                            ],
                          ),
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
                    )
                ),
                ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(UdmChangePin.routeName);
                    },
                    leading: Icon(
                        Icons.pin_drop,
                        color: Colors.black, size: 20
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
                    title: Text(
                      language.text('changePin'),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    )
                ),
                // ListTile(
                //     onTap: () => IRUDMConstants.launchURL(play_store_url),
                //     leading: Icon(
                //       Icons.star,
                //       color: Colors.black, size: 20
                //     ),
                //     trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
                //     title: Text(
                //       language.text('rateUs'),
                //       style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                //     )
                // ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Text(
                  //   "${language.text('version')} : " +
                  //       localCurrVer +
                  //       ' (' +
                  //       versionName +
                  //       ')',
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      if(_scaffoldKey.currentState!.isDrawerOpen) {
                        _scaffoldKey.currentState!.closeDrawer();
                        //_showConfirmationDialog(context);
                        WarningAlertDialog().changeLoginAlertDialog(context, () {callWebServiceLogout();}, language);
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
                          Text(language.text('logout'), style: TextStyle(fontSize: 16, color: Colors.white))
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  var play_store_url = 'https://play.google.com/store/apps/details?id=in.gov.ireps';

  void callWebServiceLogout() async {
    IRUDMConstants.showProgressIndicator(context);
    var loginprovider = Provider.of<LoginProvider>(context, listen: false);
    List<dynamic>? jsonResult;
    try {
      jsonResult = await fetchPostPostLogin(loginprovider.user!.ctoken!, loginprovider.user!.stoken!, loginprovider.user!.map_id!);
      IRUDMConstants.removeProgressIndicator(context);
      if(jsonResult![0]['logoutstatus'] == "You have been successfully logged out.") {
        dbHelper.deleteSaveLoginUser();
        loginprovider.setState(LoginState.FinishedWithError);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), ModalRoute.withName("/login-screen"));
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen());
        });
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {}
  }

  Future<List<dynamic>?> fetchPostPostLogin(String cTocken, String sTocken, String mapId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await Network.postDataWithAPIM(
        'UDM/UdmAppLogin/V1.0.0/UdmAppLogin',
        'UdmLogout',
        cTocken + '~' + sTocken + '~' + mapId,
        prefs.getString('token'));
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      return jsonResult['data'];
    } else {
      return IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }

  void showWarningDialog(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text("Message!!"),
      content: const Text("This utility has been temporarily discontinued due to scheduled maintenance."),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Container(
            height : 45,
            width : 60,
            alignment : Alignment.center,
            decoration : BoxDecoration(
              color: Colors.red,
              border: Border.all(
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: const Text("OK", style : TextStyle(color: Colors.white)),
          ),
        ),
      ],
    ),
    );
  }

  static String shortName(String? usern){
    String initials = '';
    List<String> splitName = usern!.split('');
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

  // Helper method to get translated text
  String _translate(String text) {
    return _isEnglish ? text : _translations[text] ?? text;
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
    _isEnglish ? Provider.of<LanguageProvider>(context, listen: false).updateLanguage(Language.English) : Provider.of<LanguageProvider>(context, listen: false).updateLanguage(Language.Hindi);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _showSearchResults = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _navigate(String title){
    if(title == "Search Item" || title == "आइटम खोजें") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomRightSideDrawer()));
    }
    else if (title == 'Stock Availability' || title == 'स्टॉक उपलब्धता') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => StockRightSideDrawer()));
    }
    else if (title == 'Stores Depot' || title == 'भण्डार डिपो') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => StoreStkDepotRightSideDrawer()));
    }
    else if (title == 'Summary of Stock' || title == 'स्टॉक का संक्षिप्त विवरण') {
      Navigator.of(context).pushNamed(StockSummarySideDrawer.routeName);
    }
    else if(title == 'Non-Moving Items' || title == 'नॉन-मूविंग आइटम'){
      Navigator.of(context).pushNamed(NonMovingFilter.routeName);
    }
    else if(title == 'Value-Wise Stock' || title == 'वैल्यू अनुसार स्टॉक'){
      Navigator.of(context).pushNamed(ValueWiseStockFilter.routeName);
    }
    else if(title == 'High Value Items' || title == 'उच्च वैल्यू आइटम'){
      Navigator.of(context).pushNamed(HighValueFilter.routeName);

    }
    else if(title == 'Stk. Item History Sheet' || title ==  'स्टॉक आइटम इतिहास पत्रक'){
      Navigator.of(context).pushNamed(StockItemHistorySheetScreen.routeName);
    }
    else if(title == 'Search PO' || title == 'क्रयादेश ढूँढें'){
      Navigator.of(context).pushNamed(POSearchRightSideDrawer.routeName);

    }
    else if(title == 'Consumption Analysis' || title == 'खपत का विश्लेषण'){
      Navigator.of(context).pushNamed(ConsumtionAnalysisFilter.routeName);
    }
    else if(title == 'Consumption Summary' || title == 'खपत का संक्षिप्त विवरण'){
      Navigator.of(context).pushNamed(ConsumtionSummaryFilter.routeName);
    }
    else if(title == 'Transactions' || title == 'लेनदेन'){
      Navigator.of(context).pushNamed(TransactionScreen.routeName);
    }
    else if(title == 'On-Line Bill Status' || title == 'ऑनलाइन बिल की स्थितिं'){
      Navigator.of(context).pushNamed(StatusDropDown.routeName);
    }
    else if(title == 'On-Line Bill Summary' || title == 'ऑनलाइन बिल सारांश'){
      Navigator.of(context).pushNamed(SummaryDropdown.routeName);
    }
    else if(title == 'CRN' || title == 'सीआरएन'){
      Navigator.of(context).pushNamed(CrnScreen.routeName);
    }
    else if(title == 'CRC' || title == 'सीआरसी'){
      Navigator.of(context).pushNamed(CrcScreen.routeName);
    }
    else if(title == 'NS Demands' || title == 'गैर-स्टॉक मांगें'){
      Navigator.of(context).pushNamed(NonStockDemandsScreen.routeName);
    }
    else if(title == 'GeM Order Details' || title == 'जीईएम ऑर्डर विवरण'){
      Navigator.of(context).pushNamed(GemOrderScreen.routeName);
    }
    else if (title == 'Rejection/Warranty' || title == 'अस्वीकृति/वारंटी') {
      Navigator.of(context).pushNamed(WarrantyRejectionScreen.routeName);
    }
    else if (title == 'NS Demand Summary' || title == 'एनएस डिमांड सारांश') {
      Navigator.of(context).pushNamed(NSDemandSummaryScreen.routeName);
    }
    else if (title == 'Warranty Complaint' || title == 'वारंटी शिकायत सारांश') {
      Navigator.of(context).pushNamed(WarrantyComplaintDropdown.routeName);
    }
    else if (title == 'CRN Summary' || title == 'सीआरएन सारांश') {
      Navigator.of(context).pushNamed(CrnSummaryScreen.routeName);
    }
    else if (title == 'Stocking Proposal Summary' || title == 'स्टॉकिंग प्रस्ताव सारांश') {
      Navigator.of(context).pushNamed(StockingProposalSummaryScreen.routeName);
    }
    else if (title == 'Warranty Rejection Register' || title == 'वारंटी अस्वीकृति रजिस्टर') {
      Navigator.of(context).pushNamed(WarrantyRejectionRegisterScreen.routeName);
    }
    else if (title == 'CRC Summary' || title == 'सीआरसी सारांश') {
      Navigator.of(context).pushNamed(CrcSummaryScreen.routeName);
    }
  }

  void _checkLanguage() {
    Language lan = Provider.of<LanguageProvider>(context, listen: false).language;
    setState(() {
      Language.Hindi == lan ?  _isEnglish = false : true;
    });
  }

// Future getVersion() async {
//   String basicAuth;
//   String url = new UtilsFromHelper().getValueFromKey("mobile_app_version");
//
//   basicAuth = await Hrmstokenplugin.hrmsToken;
//
//   HttpClient client = new HttpClient();
//   client.badCertificateCallback =
//   ((X509Certificate cert, String host, int port) => true);
//   Map map = {
//     'name': "anything",
//   };
//
//   HttpClientRequest request = await client.postUrl(Uri.parse(url));
//   request.headers.set('content-type', 'application/json');
//
//   request.headers.set('authorization', basicAuth);
//   request.add(utf8.encode(json.encode(map)));
//   HttpClientResponse response = await request.close();
//
//   String value = await response.transform(utf8.decoder).join();
//   var responseJSON = await json.decode(value) as Map;
//   print('reponse $responseJSON');
//   if(int.parse(responseJSON['mobileAppData']['utility_value']) >
//       BuildConfig.VERSION_CODE) {
//     _showDialog(responseJSON['mobileAppData']['remarks']);
//   }
// }

// void _showDialog(String title) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return WillPopScope(
//           onWillPop: () {
//             return Future.value(false);
//           },
//           child: AlertDialog(
//             title: Text("Update Required", style: TextStyle(fontSize: 15.0)),
//             content: Text(title, style: TextStyle(fontSize: 13.0)),
//             actions: <Widget>[
//               MaterialButton(
//                 child: Text("UPGRADE"),
//                 onPressed: () {
//                   _playstorelaunchURL();
//                 },
//               ),
//             ],
//           ));
//     },
//   );
// }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;

  MenuItemData({
    required this.title,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}
