// import 'dart:convert';
// import 'dart:io';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/udm/helpers/wso2token.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_app/udm/helpers/api.dart';
// import 'package:flutter_app/udm/helpers/database_helper.dart';
// import 'package:flutter_app/udm/helpers/shared_data.dart';
// import 'package:flutter_app/udm/localization/english.dart';
// import 'package:flutter_app/udm/providers/consSummaryProvider.dart';
// import 'package:flutter_app/udm/providers/languageProvider.dart';
// import 'package:flutter_app/udm/screens/consSummaryListScreen.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ConsumtionSummaryFilter extends StatefulWidget {
//   static const routeName = "/consumption-Summary-stock";
//   @override
//   _ConsumtionSummaryFilterState createState() =>
//       _ConsumtionSummaryFilterState();
// }
//
// class _ConsumtionSummaryFilterState extends State<ConsumtionSummaryFilter> {
//   double? sheetLeft;
//   bool isExpanded = true;
//   late ConsSummaryProvider itemListProvider;
//
//   String? railwayname = "All";
//   String? railway;
//   String? unittype = "All";
//   String? unitType;
//   String? unitname = "All";
//   String? unitName;
//   String? dept = "All";
//   String? department;
//   String? userDepotName = "All";
//   String? userDepot;
//   String? payingAuthName = "All";
//   String? payingAuth;
//   String? itemType;
//   String? itemUsage;
//   String? itemCategory;
//   String? isStockItem;
//   String? division;
//   String? fromDate;
//   String? toDate;
//   String? dropDownValue;
//
//   String intcodevalue = "-1";
//   final _formKey = GlobalKey<FormBuilderState>();
//
//   List dropdowndata_UDMRlyList = [];
//   List dropdowndata_UDMUnitType = [];
//   List dropdowndata_UDMDivision = [];
//   List dropdowndata_UDMDept = [];
//   List dropdowndata_UDMUserDepot = [];
//   List dropdowndata_UDMItemsResult = [];
//   List dropdowndata_UDMUserSubDepot = [];
//
//   List itemTypeList = [];
//   List itemUsageList = [];
//
//   bool itemTypeVis = false;
//   bool itemUsageVis = false;
//
//   bool itemTypeButtonVis = true;
//   bool itemUsageBtnVis = true;
//
//   bool topNHighVis = true;
//   bool specifyLimitVis = false;
//   bool percVis = false;
//
//   String percntValue = '20';
//   late List<Map<String, dynamic>> dbResult;
//
//   Error? _error;
//   bool _autoValidate = false;
//
//   var userDepotValue = "All";
//
//   @override
//   Widget build(BuildContext context) {
//     Size mq = MediaQuery.of(context).size;
//     LanguageProvider language = Provider.of<LanguageProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AapoortiConstants.primary,
//         iconTheme: IconThemeData(color: Colors.white),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(Provider.of<LanguageProvider>(context).text('consSummary')),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.home_outlined, color: Colors.white),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//       body: searchDrawer(),
//     );
//   }
//
//   Widget searchDrawer() {
//     LanguageProvider language = Provider.of<LanguageProvider>(context);
//     return ListView(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//       children: [
//         FormBuilder(
//           key: _formKey,
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//             // FormBuilderDropdown(
//             //   name: englishText['railway'] ?? 'railway',
//             //   focusColor: Colors.transparent,
//             //   decoration: InputDecoration(
//             //     labelText: language.text('Railway'),
//             //     contentPadding: EdgeInsetsDirectional.all(10),
//             //     border: const OutlineInputBorder(),
//             //   ),
//             //   initialValue: railway,
//             //   items: dropdowndata_UDMRlyList.map((item) {
//             //     return DropdownMenuItem(
//             //         child: Text(() {
//             //           if(item['intcode'].toString() == '-1') {
//             //             return item['value'];
//             //           } else {
//             //             return item['value'];
//             //           }}()),
//             //         value: item['intcode'].toString());
//             //   }).toList(),
//             //   onChanged: (String? newValue) {
//             //     _formKey.currentState!.fields['Department']!.setValue(null);
//             //     //_formKey.currentState!.fields['User Depot']!.setValue(null);
//             //     _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//             //     setState(() {
//             //       railway = newValue;
//             //       dropdowndata_UDMUserDepot.clear();
//             //       dropdowndata_UDMUserSubDepot.clear();
//             //       dropdowndata_UDMDept.clear();
//             //       dropdowndata_UDMUserSubDepot.add(_all());
//             //       dropdowndata_UDMUserDepot.add(_all());
//             //       dropdowndata_UDMDept.add(_all());
//             //       _formKey.currentState!.fields['Department']!.setValue('-1');
//             //       userDepotValue = "-1";
//             //       //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//             //       _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//             //     });
//             //     def_depart_result(railway!);
//             //     fetchConsignee(railway, '', '', '');
//             //   },
//             // ),
//             // SizedBox(height: 10),
//             // FormBuilderDropdown(
//             //   name: englishText['department'] ?? 'department',
//             //   focusColor: Colors.transparent,
//             //   decoration: InputDecoration(
//             //     labelText: language.text('department'),
//             //     contentPadding: EdgeInsetsDirectional.all(10),
//             //     border: const OutlineInputBorder(),
//             //   ),
//             //   initialValue: dropdowndata_UDMDept.any((item) => item['intcode'].toString() == department) ? department : null,
//             //   //initialValue: division,
//             //   //allowClear: false,
//             //   //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
//             //   //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
//             //   items: dropdowndata_UDMDept.map((item) {
//             //     return DropdownMenuItem(
//             //         child: Text(() {
//             //           if(item['intcode'].toString() == '-1') {
//             //             return item['value'];
//             //           } else {
//             //             return  item['value'];
//             //           }}()),
//             //         value: item['intcode'].toString());
//             //   }).toList(),
//             //   onChanged: (String? newValue) {
//             //     _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//             //     setState(() {
//             //       department = newValue;
//             //       itemType = null;
//             //       itemUsage = null;
//             //     });
//             //     fetchConsignee(railway, department, '', '');
//             //   },
//             // ),
//             // // stockDropdown(
//             // //     'department',
//             // //     '${language.text('select')} ${language.text('department')}',
//             // //     dropdowndata_UDMDept,
//             // //     department),
//             // // FormBuilderDropdown(
//             // //   name: 'User Depot',
//             // //   focusColor: Colors.transparent,
//             // //   decoration: InputDecoration(
//             // //     labelText: language.text('userDepot'),
//             // //     contentPadding: EdgeInsetsDirectional.all(10),
//             // //     border: const OutlineInputBorder(),
//             // //   ),
//             // //   initialValue: dropDownValue,
//             // //   allowClear: false,
//             // //   hint: Text(
//             // //       '${language.text('select')} ${language.text('userDepot')}'),
//             // //   validator: FormBuilderValidators.compose(
//             // //       [FormBuilderValidators.required(context)]),
//             // //   items: dropdowndata_UDMUserDepot.map((item) {
//             // //     return DropdownMenuItem(
//             // //         child: Text(() {
//             // //           if (item['intcode'].toString() == '-1') {
//             // //             return item['value'];
//             // //           } else {
//             // //             return item['intcode'].toString() + '-' + item['value'];
//             // //           }
//             // //         }()),
//             // //         value: item['intcode'].toString());
//             // //   }).toList(),
//             // //   onChanged: (String? newValue) {
//             // //     dropDownValue = newValue;
//             // //     _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//             // //     setState(() {
//             // //       userDepot = newValue;
//             // //       def_fetchSubDepot(railway, dropDownValue, '');
//             // //     });
//             // //   },
//             // // ),
//             // SizedBox(height: 10),
//             // DropdownSearch<String>(
//             //   selectedItem: userDepotValue == "-1" || userDepotValue == "All" ? "All" : userDepotValue,
//             //   //maxHeight:MediaQuery.of(context).size.height * 0.90,
//             //   //mode: Mode.MENU,
//             //   popupProps: PopupProps.menu(
//             //     showSearchBox: true,
//             //     showSelectedItems: true,
//             //     emptyBuilder: (ctx, val) {
//             //         return Align(
//             //           alignment: Alignment.topCenter,
//             //           child: Text('No Data Found for $val'),
//             //         );
//             //       },
//             //     searchFieldProps: TextFieldProps(
//             //       decoration: InputDecoration(
//             //         hintText: '${language.text('select')} ${language.text('userDepot')}',
//             //         contentPadding: EdgeInsetsDirectional.all(10),
//             //         border: const OutlineInputBorder(),
//             //       ),
//             //     ),
//             //     menuProps: MenuProps(shape: RoundedRectangleBorder(
//             //       borderRadius: BorderRadius.only(
//             //         topLeft: Radius.circular(20),
//             //         topRight: Radius.circular(20),
//             //       ),
//             //     ))
//             //   ),
//             //   decoratorProps: DropDownDecoratorProps(
//             //     decoration: InputDecoration(
//             //       labelText: language.text('userDepot'),
//             //       hintText: '${language.text('select')} ${language.text('userDepot')}',
//             //       alignLabelWithHint: true,
//             //       contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, bottom: 5.0, top: 5.0),
//             //       border: const OutlineInputBorder(),
//             //     )
//             //   ),
//             //
//             //   // popupTitle: Align(
//             //   //   alignment: Alignment.topRight,
//             //   //   child: Container(
//             //   //     height: 45,
//             //   //     margin: EdgeInsets.all(10),
//             //   //     decoration: BoxDecoration(
//             //   //       border: Border.all(color: Colors.black87, width: 2),
//             //   //       shape: BoxShape.circle,
//             //   //     ),
//             //   //     child: IconButton(
//             //   //       icon: const Icon(Icons.close),
//             //   //       onPressed: () {
//             //   //         Navigator.of(context).pop();
//             //   //       },
//             //   //     ),
//             //   //   ),
//             //   // ),
//             //   items: (filter, loadProps) => dropdowndata_UDMUserDepot.map((item) {
//             //     return item['intcode'].toString() != "-1" ? item['intcode'].toString() + '-' + item['value'] : item['value'].toString();
//             //   }).toList(),
//             //   onChanged: (String? newValue) {
//             //     dropDownValue = newValue;
//             //     _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//             //     setState(() {
//             //       userDepotValue = newValue.toString();
//             //       var depot = userDepotValue.split('-');
//             //       def_fetchSubDepot(railway, depot[0], '');
//             //     });
//             //   },
//             // ),
//             // SizedBox(height: 10),
//             // FormBuilderDropdown(
//             //   name: 'User Sub Depot',
//             //   focusColor: Colors.transparent,
//             //   decoration: InputDecoration(
//             //     labelText: language.text('userSubDepot'),
//             //     contentPadding: EdgeInsetsDirectional.all(10),
//             //     border: const OutlineInputBorder(),
//             //   ),
//             //   initialValue: dropdowndata_UDMUserSubDepot.any((item) => item['intcode'].toString() == userSubDepot) ? userSubDepot : null,
//             //   //initialValue: userSubDepot,
//             //   //allowClear: false,
//             //   //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
//             //   validator: (String? value) {
//             //     if (value == null || value.isEmpty) {
//             //       return 'field is required';
//             //     }
//             //     return null; // Return null if the value is valid
//             //   },
//             //   items: dropdowndata_UDMUserSubDepot.map((item) {
//             //     return DropdownMenuItem(
//             //         child: Text(() {
//             //           if (item['intcode'].toString() == '-1') {
//             //             return item['value'];
//             //           } else {
//             //             return item['intcode'].toString() + '-' + item['value'];
//             //           }
//             //         }()),
//             //         value: item['intcode'].toString());
//             //   }).toList(),
//             //   onChanged: (String? newValue) {
//             //     setState(() {
//             //       userSubDepot = newValue;
//             //     });
//             //   },
//             // ),
//             Text(language.text('railway'),
//                 style: TextStyle(
//                   fontSize: 13, // Reduced font size by 15%
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade800,
//                 )),
//             SizedBox(height: 10),
//             Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius:
//                 BorderRadius.circular(7), // Slightly reduced radius
//                 color: Colors.white,
//               ),
//               child: DropdownSearch<String>(
//                 //mode: Mode.DIALOG,
//                 //showSearchBox: true,
//                 //showSelectedItems: true,
//                 selectedItem: railwayname,
//                 popupProps: PopupPropsMultiSelection.menu(
//                   showSearchBox: true,
//                   fit: FlexFit.loose,
//                   showSelectedItems: true,
//                   menuProps: MenuProps(
//                       shape: RoundedRectangleBorder(
//                         // Custom shape without the right side scroll line
//                         borderRadius: BorderRadius.circular(5.0),
//                         side: BorderSide(
//                             color: Colors
//                                 .grey), // You can customize the border color
//                       )),
//                 ),
//                 // popupShape: RoundedRectangleBorder(
//                 //   borderRadius: BorderRadius.circular(5.0),
//                 //   side: BorderSide(color: Colors.grey),
//                 // ),
//                 decoratorProps: DropDownDecoratorProps(
//                     decoration: InputDecoration(
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none),
//                         contentPadding: EdgeInsets.only(left: 10))),
//                 items: (filter, loadProps) =>
//                     dropdowndata_UDMRlyList.map((e) {
//                       return e['value'].toString().trim();
//                     }).toList(),
//                 onChanged: (newValue) {
//                   var rlyname;
//                   var rlycode;
//                   dropdowndata_UDMRlyList.forEach((element) {
//                     if (newValue.toString() ==
//                         element['value'].toString()) {
//                       rlyname = element['value'].toString().trim();
//                       rlycode = element['intcode'].toString();
//                       try {
//                         setState(() {
//                           railway = rlycode;
//                           railwayname = rlyname;
//
//                           dropdowndata_UDMDivision.clear();
//                           dropdowndata_UDMUserDepot.clear();
//                           dropdowndata_UDMDivision.add(_all());
//                           dropdowndata_UDMUserDepot.add(_all());
//                           dept = "All";
//                           userDepotName = "All";
//                           division = '-1';
//                           department = '-1';
//                           userDepot = '-1';
//                         });
//                       } catch (e) {
//                         debugPrint("execption" + e.toString());
//                       }
//                     }
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               language.text('unitType'),
//               style: TextStyle(
//                 fontSize: 13, // Reduced font size by 15%
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade800,
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius:
//                 BorderRadius.circular(7), // Slightly reduced radius
//                 color: Colors.white,
//               ),
//               child: DropdownSearch<String>(
//                 selectedItem: unittype,
//                 popupProps: PopupPropsMultiSelection.menu(
//                   showSearchBox: true,
//                   fit: FlexFit.loose,
//                   showSelectedItems: true,
//                   menuProps: MenuProps(
//                       shape: RoundedRectangleBorder(
//                         // Custom shape without the right side scroll line
//                         borderRadius: BorderRadius.circular(5.0),
//                         side: BorderSide(
//                             color: Colors
//                                 .grey), // You can customize the border color
//                       )),
//                 ),
//                 decoratorProps: DropDownDecoratorProps(
//                     decoration: InputDecoration(
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none),
//                         contentPadding: EdgeInsets.only(left: 10))),
//                 items: (filter, loadProps) =>
//                     dropdowndata_UDMUnitType.map((e) {
//                       return e['value'].toString().trim();
//                     }).toList(),
//                 onChanged: (String? newValue) {
//                   var unittypecode;
//                   var unittypename;
//                   dropdowndata_UDMUnitType.forEach((element) {
//                     if (newValue.toString() ==
//                         element['value'].toString()) {
//                       unittypename = element['value'].toString().trim();
//                       unittypecode = element['intcode'].toString();
//                       try {
//                         setState(() {
//                           unitName = unittypecode;
//                           unittype = unittypename;
//                           division = '-1';
//                           department = '-1';
//                           userDepot = '-1';
//                         });
//                       } catch (e) {
//                         debugPrint("execption" + e.toString());
//                       }
//                     }
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(language.text('unitName'),
//                 style: TextStyle(
//                   fontSize: 13, // Reduced font size by 15%
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade800,
//                 )),
//             SizedBox(height: 10),
//             Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius:
//                 BorderRadius.circular(7), // Slightly reduced radius
//                 color: Colors.white,
//               ),
//               child: DropdownSearch<String>(
//                 selectedItem: unitname,
//                 popupProps: PopupPropsMultiSelection.menu(
//                   showSearchBox: true,
//                   fit: FlexFit.loose,
//                   showSelectedItems: true,
//                   menuProps: MenuProps(
//                       shape: RoundedRectangleBorder(
//                         // Custom shape without the right side scroll line
//                         borderRadius: BorderRadius.circular(5.0),
//                         side: BorderSide(
//                             color: Colors
//                                 .grey), // You can customize the border color
//                       )),
//                 ),
//                 decoratorProps: DropDownDecoratorProps(
//                     decoration: InputDecoration(
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none),
//                         contentPadding: EdgeInsets.only(left: 10))),
//                 items: (filter, loadProps) =>
//                     dropdowndata_UDMDivision.map((e) {
//                       return e['value'].toString().trim();
//                     }).toList(),
//                 onChanged: (String? newValue) {
//                   var unitnamecode;
//                   var unittname;
//                   dropdowndata_UDMDivision.forEach((element) {
//                     if (newValue.toString() ==
//                         element['value'].toString()) {
//                       unittname = element['value'].toString().trim();
//                       unitnamecode = element['intcode'].toString();
//                       try {
//                         setState(() {
//                           division = unitnamecode;
//                           unitname = unittname;
//                           userDepot = '-1';
//                         });
//                       } catch (e) {
//                         debugPrint("execption" + e.toString());
//                       }
//                     }
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(language.text('departmentName'),
//                 style: TextStyle(
//                   fontSize: 13, // Reduced font size by 15%
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade800,
//                 )),
//             SizedBox(height: 10),
//             Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius:
//                 BorderRadius.circular(7), // Slightly reduced radius
//                 color: Colors.white,
//               ),
//               child: DropdownSearch<String>(
//                 selectedItem: dept,
//                 popupProps: PopupPropsMultiSelection.menu(
//                   showSearchBox: true,
//                   fit: FlexFit.loose,
//                   showSelectedItems: true,
//                   menuProps: MenuProps(
//                       shape: RoundedRectangleBorder(
//                         // Custom shape without the right side scroll line
//                         borderRadius: BorderRadius.circular(5.0),
//                         side: BorderSide(
//                             color: Colors
//                                 .grey), // You can customize the border color
//                       )),
//                 ),
//                 // popupShape: RoundedRectangleBorder(
//                 //   borderRadius: BorderRadius.circular(5.0),
//                 //   side: BorderSide(color: Colors.grey),
//                 // ),
//                 decoratorProps: DropDownDecoratorProps(
//                     decoration: InputDecoration(
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none),
//                         contentPadding: EdgeInsets.only(left: 10))),
//                 items: (filter, loadProps) => dropdowndata_UDMDept.map((e) {
//                   return e['value'].toString().trim();
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   var deptt;
//                   var deparmentt;
//                   dropdowndata_UDMDept.forEach((element) {
//                     if (newValue.toString() ==
//                         element['value'].toString()) {
//                       deptt = element['value'].toString().trim();
//                       deparmentt = element['intcode'].toString();
//                       debugPrint("department code here $deparmentt");
//                       try {
//                         setState(() {
//                           department = deparmentt;
//                           dept = deptt;
//                         });
//                       } catch (e) {
//                         debugPrint("execption" + e.toString());
//                       }
//                       fetchDepot(railway, department, unitName, division, "");
//                     }
//                   });
//                   // try {
//                   //   setState(() {
//                   //     department = deparmentt;
//                   //     dept = deptt;
//                   //     description.clear();
//                   //   });
//                   // } catch (e) {
//                   //   print("execption" + e.toString());
//                   // }
//                   // fetchDepot(railway, department, unitName, division, "");
//                 },
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(language.text('userDepot'),
//                 style: TextStyle(
//                   fontSize: 13, // Reduced font size by 15%
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade800,
//                 )),
//             SizedBox(height: 10),
//             Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius:
//                 BorderRadius.circular(7), // Slightly reduced radius
//                 color: Colors.white,
//               ),
//               child: DropdownSearch<String>(
//                 popupProps: PopupPropsMultiSelection.menu(
//                   showSearchBox: true,
//                   fit: FlexFit.loose,
//                   showSelectedItems: true,
//                   menuProps: MenuProps(
//                       shape: RoundedRectangleBorder(
//                         // Custom shape without the right side scroll line
//                         borderRadius: BorderRadius.circular(5.0),
//                         side: BorderSide(
//                             color: Colors
//                                 .grey), // You can customize the border color
//                       )),
//                 ),
//                 // popupShape: RoundedRectangleBorder(
//                 //   borderRadius: BorderRadius.circular(5.0),
//                 //   side: BorderSide(color: Colors.grey),
//                 // ),
//                 selectedItem: userDepotName.toString().length > 35
//                     ? userDepotName.toString().substring(0, 32)
//                     : userDepotName.toString(),
//                 decoratorProps: DropDownDecoratorProps(
//                     decoration: InputDecoration(
//                         enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none),
//                         contentPadding: EdgeInsets.only(left: 10))),
//                 items: (filter, loadProps) =>
//                     dropdowndata_UDMUserDepot.map((e) {
//                       return e['value'].toString().trim() == "All"
//                           ? e['value'].toString().trim()
//                           : e['intcode'].toString().trim() +
//                           "-" +
//                           e['value'].toString().trim();
//                     }).toList(),
//                 onChanged: (String? newValue) {
//                   debugPrint("onChanges User Depot value $newValue");
//                   var userDepotname;
//                   var userDepotCode;
//                   dropdowndata_UDMUserDepot.forEach((element) {
//                     if (newValue.toString().trim() ==
//                         element['intcode'].toString().trim() +
//                             "-" +
//                             element['value'].toString().trim()) {
//                       userDepotname = element['intcode'].toString().trim() +
//                           "-" +
//                           element['value'].toString().trim();
//                       userDepotCode = element['intcode'].toString();
//                       debugPrint("user depot code here $userDepotCode");
//                       try {
//                         setState(() {
//                           userDepot = userDepotCode;
//                           userDepotName = userDepotname;
//                         });
//                       } catch (e) {
//                         debugPrint("execption" + e.toString());
//                       }
//                     } else {
//                       setState(() {
//                         userDepotname = "All";
//                         userDepotCode = "-1";
//                       });
//                     }
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(language.text('payauth'),
//                 style: TextStyle(
//                   fontSize: 13, // Reduced font size by 15%
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade800,
//                 )),
//             SizedBox(height: 10),
//             Visibility(
//               visible: itemTypeVis,
//               child: Column(
//                 children: [
//                   SizedBox(height: 10),
//                   stockDropdownStatic(
//                       'itemType', 'Select Item Type', itemTypeList, itemType,
//                       name: 'Item Type'),
//                 ],
//               ),
//             ),
//             Visibility(
//               visible: itemUsageVis,
//               child: Column(
//                 children: [
//                   SizedBox(height: 10),
//                   stockDropdownStatic(
//                     'itemUsage',
//                     'Select Item Usage',
//                     itemUsageList,
//                     itemUsage,
//                     name: 'Item Usage',
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(language.text('currentPeriod')),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Expanded(
//                   child: FormBuilderDateTimePicker(
//                     name: 'CFrom',
//                     //firstDate: DateTime.now().subtract(const Duration(days: 120)),
//                     lastDate: DateTime.now(),
//                     initialDate:
//                     DateTime.now().subtract(const Duration(days: 60)),
//                     initialValue:
//                     DateTime.now().subtract(const Duration(days: 60)),
//                     inputType: InputType.date,
//                     format: DateFormat('dd-MM-yyyy'),
//                     decoration: InputDecoration(
//                       labelText: language.text('from'),
//                       hintText: 'Current Period: From',
//                       contentPadding: EdgeInsetsDirectional.all(10),
//                       border: const OutlineInputBorder(),
//                     ),
//                     // onChanged: _onChanged,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: FormBuilderDateTimePicker(
//                     name: 'CTo',
//                     // firstDate: DateTime.now().subtract(const Duration(days: 180)),
//                     lastDate: DateTime.now(),
//                     initialDate: DateTime.now(),
//                     initialValue: DateTime.now(),
//                     inputType: InputType.date,
//                     format: DateFormat('dd-MM-yyyy'),
//                     decoration: InputDecoration(
//                       labelText: language.text('to'),
//                       hintText: 'Current Period: To',
//                       contentPadding: EdgeInsetsDirectional.all(10),
//                       border: const OutlineInputBorder(),
//                     ),
//                     // onChanged: _onChanged,
//                   ),
//                 ),
//                 // SizedBox(height:10),
//               ],
//             ),
//             SizedBox(height: 10),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(language.text('previousPeriod')),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Expanded(
//                   child: FormBuilderDateTimePicker(
//                     name: 'PFrom',
//                     //firstDate: DateTime.now().subtract(const Duration(days: 120)),
//                     lastDate: DateTime.now(),
//                     initialDate:
//                     DateTime.now().subtract(const Duration(days: 121)),
//                     initialValue:
//                     DateTime.now().subtract(const Duration(days: 121)),
//                     inputType: InputType.date,
//                     format: DateFormat('dd-MM-yyyy'),
//                     decoration: InputDecoration(
//                       labelText: language.text('from'),
//                       hintText: 'Previous Period: From',
//                       contentPadding: EdgeInsetsDirectional.all(10),
//                       border: const OutlineInputBorder(),
//                     ),
//                     // onChanged: _onChanged,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: FormBuilderDateTimePicker(
//                     name: 'PTo',
//                     // firstDate: DateTime.now().subtract(const Duration(days: 180)),
//                     lastDate: DateTime.now(),
//                     initialDate:
//                     DateTime.now().subtract(const Duration(days: 61)),
//                     initialValue:
//                     DateTime.now().subtract(const Duration(days: 61)),
//                     inputType: InputType.date,
//                     format: DateFormat('dd-MM-yyyy'),
//                     decoration: InputDecoration(
//                       labelText: language.text('to'),
//                       hintText: 'Previous Period: To',
//                       contentPadding: EdgeInsetsDirectional.all(10),
//                       border: const OutlineInputBorder(),
//                     ),
//                     // onChanged: _onChanged,
//                   ),
//                 ),
//                 // SizedBox(height:10),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Expanded(
//                   child: FormBuilderRadioGroup(
//                     name: 'perc',
//                     initialValue: language.text('increase'),
//                     decoration: InputDecoration(
//                       labelText: language.text('percentageChange'),
//                       contentPadding: EdgeInsetsDirectional.all(0),
//                       border: InputBorder.none,
//                     ),
//                     autovalidateMode: AutovalidateMode.disabled,
//                     options: [
//                       language.text('increase'),
//                       language.text('decrease')
//                     ]
//                         .map((lang) => FormBuilderFieldOption(value: lang))
//                         .toList(growable: false),
//                     onChanged: (String? newValue) {
//
//                     },
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       width: 100,
//                       child: FormBuilderTextField(
//                         name: 'by',
//                         initialValue: percntValue,
//                         decoration: InputDecoration(
//                           labelText: language.text('by'),
//                           contentPadding: EdgeInsetsDirectional.all(10),
//                           border: const OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       "%",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                   ],
//                 ),
//                 // Expanded(child: Icon(IconData(0xf73f))),
//               ],
//             ),
//             Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//               Expanded(
//                 child: FormBuilderDateTimePicker(
//                   name: 'CFrom',
//                   //firstDate: DateTime.now().subtract(const Duration(days: 120)),
//                   lastDate: DateTime.now(),
//                   initialDate:
//                   DateTime.now().subtract(const Duration(days: 180)),
//                   initialValue:
//                   DateTime.now().subtract(const Duration(days: 180)),
//                   inputType: InputType.date,
//                   format: DateFormat('dd-MM-yyyy'),
//                   decoration: InputDecoration(
//                     labelText: language.text('from'),
//                     hintText: 'Current Period: From',
//                     contentPadding: EdgeInsetsDirectional.all(10),
//                     border: const OutlineInputBorder(),
//                   ),
//                   // onChanged: _onChanged,
//                 ),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: FormBuilderDateTimePicker(
//                   name: 'CTo',
//                   // firstDate: DateTime.now().subtract(const Duration(days: 180)),
//                   lastDate: DateTime.now(),
//                   initialDate: DateTime.now(),
//                   initialValue: DateTime.now(),
//                   inputType: InputType.date,
//                   format: DateFormat('dd-MM-yyyy'),
//                   decoration: InputDecoration(
//                     labelText: language.text('to'),
//                     hintText: 'Current Period: To',
//                     contentPadding: EdgeInsetsDirectional.all(10),
//                     border: const OutlineInputBorder(),
//                   ),
//                   // onChanged: _onChanged,
//                 ),
//               ),
//               // SizedBox(height:10),
//             ]),
//             SizedBox(height: 10),
//             Column(
//               children: [
//                 FormBuilderRadioGroup(
//                   name: 'SNS',
//                   initialValue: language.text('topNHighConsumptionValueItems'),
//                   decoration: InputDecoration(
//                     labelText: language.text('chooseSummaryType'),
//                     contentPadding: EdgeInsetsDirectional.all(0),
//                     border: InputBorder.none,
//                   ),
//                   options: [
//                     language.text('topNHighConsumptionValueItems'),
//                     language
//                         .text('itemsHavingConsumptionValueAboveSpecifiedLimit'),
//                     language.text('consumptionComparisonWithAAC')
//                   ]
//                       .map((lang) => FormBuilderFieldOption(value: lang))
//                       .toList(growable: false),
//                   onChanged: (String? newValue) {
//                     if (newValue ==
//                         language.text('topNHighConsumptionValueItems')) {
//                       setState(() {
//                         topNHighVis = true;
//                         specifyLimitVis = false;
//                         percVis = false;
//                       });
//                     } else if (newValue ==
//                         language.text('consumptionComparisonWithAAC')) {
//                       setState(() {
//                         topNHighVis = false;
//                         specifyLimitVis = false;
//                         percVis = true;
//                       });
//                     } else {
//                       setState(() {
//                         topNHighVis = false;
//                         specifyLimitVis = true;
//                         percVis = false;
//                       });
//                     }
//                   },
//                 ),
//                 Visibility(
//                   visible: topNHighVis,
//                   child: FormBuilderTextField(
//                     name: 'topN',
//                     initialValue: '10',
//                     validator: (String? value) {
//                       if (value == null || value.isEmpty) {
//                         return 'field is required';
//                       }
//                       return null; // Return null if the value is valid
//                     },
//                     decoration: InputDecoration(
//                       labelText: language.text('specifyNNoOfTop'),
//                       contentPadding: EdgeInsetsDirectional.all(10),
//                       border: const OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//                 Visibility(
//                   visible: specifyLimitVis,
//                   child: FormBuilderTextField(
//                     name: 'specLimit',
//                     initialValue: '',
//                     validator: (String? value) {
//                       if (value == null || value.isEmpty) {
//                         return 'field is required';
//                       }
//                       return null; // Return null if the value is valid
//                     },
//                     decoration: InputDecoration(
//                       labelText: language.text('specifyLimitOfConVal'),
//                       contentPadding: EdgeInsetsDirectional.all(10),
//                       border: const OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//                 Visibility(
//                   visible: percVis,
//                   child: Card(
//                     elevation: 8,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: Column(
//                         children: [
//                           //  SizedBox(height:10),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: FormBuilderRadioGroup(
//                                   name: 'perc',
//                                   initialValue: language.text('percentageGreater'),
//                                   decoration: InputDecoration(
//                                     contentPadding:
//                                     EdgeInsetsDirectional.all(0),
//                                     border: InputBorder.none,
//                                   ),
//                                   autovalidateMode: AutovalidateMode.disabled,
//                                   options: [
//                                     language.text('percentageGreater'),
//                                     language.text('percentageLess'),
//                                     // 'Percentage Greater than (>)',
//                                     // 'Percentage Less than (<=)'
//                                   ]
//                                       .map((lang) =>
//                                       FormBuilderFieldOption(value: lang))
//                                       .toList(growable: false),
//                                   onChanged: (String? newValue) {},
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Container(
//                                 width: 120,
//                                 child: FormBuilderTextField(
//                                   name: 'percValue',
//                                   initialValue: '10',
//                                   decoration: InputDecoration(
//                                     contentPadding:
//                                     EdgeInsetsDirectional.all(10),
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   keyboardType: TextInputType.number,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Text(language.text('proportionateQtyAsPerAAC')),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Expanded(child: Icon(IconData(0xf73f))),
//               ],
//             ),
//             SizedBox(height: 10),
//             Wrap(
//               spacing: 8.0,
//               children: [
//                 Visibility(
//                   visible: itemTypeButtonVis,
//                   child: FittedBox(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         setState(() {
//                           itemTypeVis = true;
//                           itemTypeButtonVis = false;
//                           if (itemTypeVis) {
//                             itemType = '-1';
//                           }
//                         });
//                       },
//                       style: ButtonStyle(
//                         backgroundColor:
//                         MaterialStateProperty.all(Colors.blueAccent),
//                         shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0))),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.add,
//                             color: Colors.white,
//                           ),
//                           Text(
//                             language.text('itemType'),
//                             style: TextStyle(color: Colors.white, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: itemUsageBtnVis,
//                   child: FittedBox(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         setState(() {
//                           itemUsageVis = true;
//                           itemUsageBtnVis = false;
//                           if (itemUsageVis) {
//                             itemUsage = '-1';
//                           }
//                         });
//                       },
//                       style: ButtonStyle(
//                         backgroundColor:
//                         MaterialStateProperty.all(Colors.blueAccent),
//                         shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0))),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.add,
//                             color: Colors.white,
//                           ),
//                           Text(
//                             language.text('itemUsage'),
//                             style: TextStyle(color: Colors.white, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   height: 50,
//                   width: 160,
//                   child: OutlinedButton(
//                     style: IRUDMConstants.bStyle(),
//                     onPressed: () {
//                       setState(() {
//                         if(_formKey.currentState!.validate()) {
//                           if(userDepotValue.toString() == "All" || userDepotValue.toString() == "-1"  || userDepotValue == null){
//                             itemListProvider = Provider.of<ConsSummaryProvider>(
//                                 context,
//                                 listen: false);
//                             String? itemUnit;
//                             String cFrom = DateFormat('dd/MM/yyyy').format(
//                                 _formKey.currentState!.fields['CFrom']!.value);
//                             String cTo = DateFormat('dd/MM/yyyy').format(
//                                 _formKey.currentState!.fields['CTo']!.value);
//                             if (!itemUsageVis) {
//                               itemUsage = '-1';
//                             } else {
//                               itemUsage = _formKey
//                                   .currentState!.fields['Item Usage']!.value;
//                             }
//                             if (!itemTypeVis) {
//                               itemUnit = '-1';
//                             } else {
//                               itemUnit = _formKey
//                                   .currentState!.fields['Item Type']!.value;
//                             }
//
//                             String? lable, percValue = '', perc;
//                             if (topNHighVis) {
//                               lable = 'A';
//                               percValue =
//                                   _formKey.currentState!.fields['topN']!.value;
//                             } else if (specifyLimitVis) {
//                               lable = 'B';
//                               percValue = _formKey
//                                   .currentState!.fields['specLimit']!.value;
//                             } else {
//                               lable = 'C';
//                               if (_formKey.currentState!.fields['perc']!.value ==
//                                   language.text('percentageGreater')) {
//                                 perc = '1';
//                               } else {
//                                 perc = '2';
//                               }
//                               percValue = _formKey
//                                   .currentState!.fields['percValue']!.value +
//                                   '~' +
//                                   perc;
//                             }
//
//                             if (percValue!.isEmpty) {
//                               IRUDMConstants().showSnack(
//                                   'Please fill all the fields', context);
//                             } else {
//                               Navigator.of(context)
//                                   .pushNamed(ConsSummaryScreen.routeName);
//                               itemListProvider.fetchAndStoreItemsListwithdata(
//                                   lable,
//                                   cFrom,
//                                   cTo,
//                                   railway,
//                                   _formKey.currentState!.fields['Department']!.value,
//                                   "-1",
//                                   //_formKey.currentState!.fields['User Depot']!.value,
//                                   _formKey.currentState!.fields['User Sub Depot']!.value,
//                                   itemUsage,
//                                   itemUnit,
//                                   percValue,
//                                   context);
//                             }
//                           }
//                           else{
//                             itemListProvider = Provider.of<ConsSummaryProvider>(context, listen: false);
//                             String? itemUnit;
//                             String cFrom = DateFormat('dd/MM/yyyy').format(
//                                 _formKey.currentState!.fields['CFrom']!.value);
//                             String cTo = DateFormat('dd/MM/yyyy').format(
//                                 _formKey.currentState!.fields['CTo']!.value);
//                             if (!itemUsageVis) {
//                               itemUsage = '-1';
//                             } else {
//                               itemUsage = _formKey
//                                   .currentState!.fields['Item Usage']!.value;
//                             }
//                             if (!itemTypeVis) {
//                               itemUnit = '-1';
//                             } else {
//                               itemUnit = _formKey
//                                   .currentState!.fields['Item Type']!.value;
//                             }
//
//                             String? lable, percValue = '', perc;
//                             if (topNHighVis) {
//                               lable = 'A';
//                               percValue =
//                                   _formKey.currentState!.fields['topN']!.value;
//                             } else if (specifyLimitVis) {
//                               lable = 'B';
//                               percValue = _formKey
//                                   .currentState!.fields['specLimit']!.value;
//                             } else {
//                               lable = 'C';
//                               if (_formKey.currentState!.fields['perc']!.value ==
//                                   language.text('percentageGreater')) {
//                                 perc = '1';
//                               } else {
//                                 perc = '2';
//                               }
//                               percValue = _formKey
//                                   .currentState!.fields['percValue']!.value +
//                                   '~' +
//                                   perc;
//                             }
//                             if (percValue!.isEmpty) {
//                               IRUDMConstants().showSnack('Please fill all the fields', context);
//                             } else {
//                               Navigator.of(context).pushNamed(ConsSummaryScreen.routeName);
//                               var depot = userDepotValue.split('-');
//                               itemListProvider.fetchAndStoreItemsListwithdata(
//                                   lable,
//                                   cFrom,
//                                   cTo,
//                                   railway,
//                                   _formKey.currentState!.fields['Department']!.value,
//                                   depot[0],
//                                   //_formKey.currentState!.fields['User Depot']!.value,
//                                   _formKey.currentState!.fields['User Sub Depot']!.value,
//                                   itemUsage,
//                                   itemUnit,
//                                   percValue,
//                                   context);
//                             }
//                           }
//                         }
//                       });
//                     },
//                     child: Text(language.text('getDetails'),
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AapoortiConstants.primary,
//                         )),
//                   ),
//                 ),
//                 Container(
//                   width: 160,
//                   height: 50,
//                   child: OutlinedButton(
//                     style: IRUDMConstants.bStyle(),
//                     onPressed: () {
//                       setState(() {
//                         itemTypeVis = false;
//                         itemUsageVis = false;
//
//                         itemTypeButtonVis = true;
//                         itemUsageBtnVis = true;
//                         _formKey.currentState!.reset();
//                         default_data();
//                         //reseteValues();
//                       });
//                     },
//                     child: Text(language.text('reset'),
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AapoortiConstants.primary,
//                         )),
//                   ),
//                 ),
//               ],
//             ),
//           ]),
//         ),
//       ],
//     );
//   }
//
//   _all() {
//     var all = {
//       'intcode': '-1',
//       'value': 'All',
//     };
//     return all;
//   }
//
//   Widget stockDropdown(String key, String hint, List listData, String? initValue) {
//     String name = englishText[key] ?? key;
//     return FormBuilderDropdown(
//       name: name,
//       focusColor: Colors.transparent,
//       decoration: InputDecoration(
//         labelText: name == key
//             ? name
//             : Provider.of<LanguageProvider>(context).text(key),
//         contentPadding: EdgeInsetsDirectional.all(10),
//         border: const OutlineInputBorder(),
//       ),
//       initialValue: dropDownValue,
//       //allowClear: false,
//       //hint: Text(hint),
//       validator: (String? value) {
//         if (value == null || value.isEmpty) {
//           return 'field is required';
//         }
//         return null; // Return null if the value is valid
//       },
//       items: listData.map((item) {
//         return DropdownMenuItem(
//             child: Text(item['value']), value: item['intcode'].toString());
//       }).toList(),
//       onChanged: (String? newValue) {
//         dropDownValue = newValue;
//         if(name == 'Railway') {
//           _formKey.currentState!.fields['Department']!.setValue(null);
//           //_formKey.currentState!.fields['User Depot']!.setValue(null);
//           _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//           setState(() {
//             railway = newValue;
//             dropdowndata_UDMUserDepot.clear();
//             dropdowndata_UDMUserSubDepot.clear();
//             dropdowndata_UDMDept.clear();
//             dropdowndata_UDMUserSubDepot.add(_all());
//             dropdowndata_UDMUserDepot.add(_all());
//             dropdowndata_UDMDept.add(_all());
//             _formKey.currentState!.fields['Department']!.setValue('-1');
//             userDepotValue = "-1";
//             //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//             _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//           });
//           def_depart_result(railway!);
//           fetchConsignee(railway, '', '', '');
//         }
//         else if (name == 'Department') {
//           //_formKey.currentState!.fields['User Depot']!.setValue(null);
//           _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//           setState(() {
//             department = newValue;
//             itemType = null;
//             itemUsage = null;
//           });
//           fetchConsignee(railway, department, '', '');
//         }
//       },
//     );
//   }
//
//   Widget stockDropdownStatic(String key, String hint, List listData, String? initValue, {String? name}) {
//     if (name == null) {
//       name = key;
//     }
//     return FormBuilderDropdown(
//       name: name,
//       focusColor: Colors.transparent,
//       decoration: InputDecoration(
//         labelText: name == key
//             ? name
//             : Provider.of<LanguageProvider>(context).text(key),
//         contentPadding: EdgeInsetsDirectional.all(10),
//         border: const OutlineInputBorder(),
//       ),
//       initialValue: initValue,
//       //allowClear: false,
//       //hint: Text(hint),
//       validator: (String? value) {
//         if (value == null || value.isEmpty) {
//           return 'field is required';
//         }
//         return null; // Return null if the value is valid
//       },
//       items: listData.map((item) {
//         return DropdownMenuItem(child: Text(item['value']), value: item['intcode'].toString());
//       }).toList(),
//       onChanged: (String? newValue) {
//         setState(() {
//           initValue = newValue;
//         });
//       },
//     );
//   }
//
//   void reseteValues() {
//     dropdowndata_UDMUserDepot.clear();
//   }
//
//   void initState() {
//     super.initState();
//     getInitData();
//   }
//
//   Future<void> getInitData() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
//     if(providedTime.isBefore(DateTime.now())) {
//       await fetchToken(context);
//       default_data();
//     }
//     else {
//       default_data();
//     }
//
//   }
//
//   late SharedPreferences prefs;
//   Future<void> didChangeDependencies() async {
//     prefs = await SharedPreferences.getInstance();
//     super.didChangeDependencies();
//   }
//
//   Future<dynamic> default_data() async {
//     Future.delayed(
//         Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
//     itemTypeList.clear();
//     itemUsageList.clear();
//     //Item Usage Item Category Whether Stock/Non-Stock
//     // _formKey.currentState.fields['Item Type'].reset();
//     //_formKey.currentState.fields['Item Type'].reset();
//     DatabaseHelper dbHelper = DatabaseHelper.instance;
//     dbResult = await dbHelper.fetchSaveLoginUser();
//     try {
//       var d_response=await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue',
//           'GetListDefaultValue',
//           dbResult[0][DatabaseHelper.Tb3_col5_emailid],
//           prefs.getString('token'));
//
//       var d_JsonData = json.decode(d_response.body);
//       var d_Json = d_JsonData['data'];
//       var result_UDMRlyList = await Network().postDataWithAPIMList(
//           'UDMAppList','UDMRlyList','',prefs.getString('token'));
//       var UDMRlyList_body = json.decode(result_UDMRlyList.body);
//       var rlyData = UDMRlyList_body['data'];
//       var myList_UDMRlyList = [];
//       myList_UDMRlyList.addAll(rlyData);
//
//       var staticDataresponse =
//       await Network.postDataWithAPIM('app/Common/UdmAppListStatic/V1.0.0/UdmAppListStatic', 'UdmAppListStatic', '',prefs.getString('token'));
//
//       var staticData = json.decode(staticDataresponse.body);
//       List staticDataJson = staticData['data'];
//
//       var itemCatDataUrl = await Network().postDataWithAPIMList(
//           'UDMAppList','ItemCategory','',prefs.getString('token'));
//       var itemData = json.decode(itemCatDataUrl.body);
//       var itemCatDataJson = itemData['data'];
//
//       for (int i = 0; i < staticDataJson.length; i++) {
//         if (staticDataJson[i]['list_for'] == 'ItemType') {
//           setState(() {
//             var all = {
//               'intcode': staticDataJson[i]['key'],
//               'value': staticDataJson[i]['value'],
//             };
//             itemTypeList.add(all);
//           });
//         }
//
//         if (staticDataJson[i]['list_for'] == 'ItemUsage') {
//           setState(() {
//             var all = {
//               'intcode': staticDataJson[i]['key'],
//               'value': staticDataJson[i]['value'],
//             };
//             itemUsageList.add(all);
//           });
//         }
//       }
//
//       setState(() {
//         dropdowndata_UDMUserDepot.clear();
//         dropdowndata_UDMRlyList = myList_UDMRlyList; //1
//         dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
//         def_depart_result(d_Json[0]['org_subunit_dept'].toString());
//         railway = d_Json[0]['org_zone'];
//         railwayname = d_Json[0]['account_name'];
//         unitType = d_Json[0]['org_unit_type'];
//         unittype = d_Json[0]['unit_type'];
//         unitName = d_Json[0]['admin_unit'];
//         unitname = d_Json[0]['unit_name'];
//         department = d_Json[0]['org_subunit_dept'];
//         dept = d_Json[0]['dept_name'];
//         userDepot = d_Json[0]['ccode'].toString() == "NA" ? "-1" : d_Json[0]['ccode'].toString();
//         userDepotName = d_Json[0]['ccode'].toString() == "NA" ? "All" : d_Json[0]['ccode'] + "-" + d_Json[0]['cname'];
//         Future.delayed(Duration(milliseconds: 0), () async {
//           def_fetchDepot(
//               d_Json[0]['org_zone'],
//               d_Json[0]['org_subunit_dept'].toString(),
//               d_Json[0]['org_unit_type'].toString(),
//               d_Json[0]['admin_unit'].toString(),
//               d_Json[0]['ccode'].toString(),
//               d_Json[0]['sub_cons_code'].toString());
//         });
//       });
//       _formKey.currentState!.fields['Railway']!.setValue(d_Json[0]['org_zone']);
//       if (staticDataresponse.statusCode == 200) {
//         //  _formKey.currentState.fields['Item Usage' ].setValue('-1');
//         //  _formKey.currentState.fields['Item Type'].setValue('-1');
//         //  _formKey.currentState.fields['Item Category'].setValue('-1');
//         //  _formKey.currentState.fields['Whether Stock/Non-Stock'].setValue('-1');
//       }
//       //  _progressHide();
//     } on HttpException {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } on SocketException {
//       IRUDMConstants()
//           .showSnack("No connectivity. Please check your connection.", context);
//     } on FormatException {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } catch (err) {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     }
//   }
//
//   void showInSnackBar(String value) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
//   }
//
//   Future<dynamic> fetchConsignee(String? rai, String? depart, String depot_id, String userSubDep) async {
//     IRUDMConstants.showProgressIndicator(context);
//     dropdowndata_UDMUserDepot.clear();
//     if(rai == '-1') {
//       var consigneeName = {
//         'intcode': '-1',
//         'value': "All",
//       };
//       dropdowndata_UDMUserDepot.add(consigneeName);
//     } else {
//       var result_UDMConsignee = await Network().postDataWithAPIMList(
//           'UDMAppList','ConsigneeInBillStatus' , rai! ,prefs.getString('token'));
//       var UDMConsignee_body = json.decode(result_UDMConsignee.body);
//       var depotData = UDMConsignee_body['data'];
//       var myList_UDMConsignee = [];
//       if (UDMConsignee_body['status'] != 'OK') {
//         setState(() {
//           var _all = {
//             'intcode': '-1',
//             'value': "All",
//           };
//           dropdowndata_UDMUserDepot.add(_all);
//           userDepotValue = _all['intcode'].toString();
//         });
//       } else {
//         myList_UDMConsignee.addAll(depotData);
//         setState(() {
//           dropdowndata_UDMUserDepot = myList_UDMConsignee;
//           if(depot_id != "") {
//             userDepot = depot_id;
//             dropdowndata_UDMUserDepot.forEach((item) {
//               if(item['intcode'].toString().contains(depot_id.toLowerCase())) {
//                 userDepotValue = item['intcode'].toString() + '-' + item['value'];
//               }
//             });
//             print("sub depot calling now new");
//             def_fetchSubDepot(rai, depot_id, userSubDep);
//           } else {
//             var _all = {
//               'intcode': '-1',
//               'value': "All",
//             };
//             userDepotValue = _all['intcode'].toString();
//           }
//         });
//       }
//     }
//     IRUDMConstants.removeProgressIndicator(context);
//   }
//
//   Future<dynamic> def_fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id, String userSubDep) async {
//     try {
//       dropdowndata_UDMUserDepot.clear();
//       if(depot_id == 'NA') {
//         var all = {
//           'intcode': '-1',
//           'value': "All",
//         };
//         dropdowndata_UDMUserDepot.add(all);
//         userDepotValue = all['intcode'].toString();
//         //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//         def_fetchSubDepot(rai, depot_id, userSubDep);
//       } else {
//         var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UDMUserDepot' , rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!, prefs.getString('token'));
//         var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
//         var myList_UDMUserDepot = [];
//         if(UDMUserDepot_body['status'] != 'OK') {
//           setState(() {
//             var all = {
//               'intcode': '-1',
//               'value': "All",
//             };
//             dropdowndata_UDMUserDepot.add(all);
//             userDepotValue = all['intcode'].toString();
//             def_fetchSubDepot(rai, depot_id, userSubDep);
//           });
//         } else {
//           var depoData = UDMUserDepot_body['data'];
//           dropdowndata_UDMUserSubDepot.clear();
//           myList_UDMUserDepot.addAll(depoData);
//           setState(() {
//             dropdowndata_UDMUserDepot = myList_UDMUserDepot;
//             if(depot_id != "") {
//               userDepot = depot_id;
//               dropdowndata_UDMUserDepot.forEach((item) {
//                 if(item['intcode'].toString().contains(depot_id.toLowerCase())) {
//                   userDepotValue = item['intcode'].toString() + '-' + item['value'];
//                 }
//               });
//               print("sub depot calling now new");
//               def_fetchSubDepot(rai, depot_id, userSubDep);
//             } else {
//               var all = {
//                 'intcode': '-1',
//                 'value': "All",
//               };
//               userDepotValue = all['intcode'].toString();
//             }
//           });
//         }
//       }
//     } on HttpException {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } on SocketException {
//       IRUDMConstants()
//           .showSnack("No connectivity. Please check your connection.", context);
//     } on FormatException {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } catch (err) {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     }
//   }
//
//   Future<dynamic> fetchDepot(String? rai, String? depart, String? unit_typ,
//       String? Unit_Name, String depot_id) async {
//     IRUDMConstants.showProgressIndicator(context);
//     dropdowndata_UDMUserDepot.clear();
//     if (rai == intcodevalue) {
//       var depotName = {
//         'intcode': intcodevalue,
//         'value': "All",
//       };
//       dropdowndata_UDMUserDepot.add(depotName);
//       userDepot = intcodevalue;
//       department = intcodevalue;
//     } else {
//       var result_UDMUserDepot = await Network().postDataWithAPIMList(
//           'UDMAppList',
//           'UDMUserDepot',
//           rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!,
//           prefs.getString('token'));
//       var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
//       var depotData = UDMUserDepot_body['data'];
//       var myList_UDMUserDepot = [];
//       if (UDMUserDepot_body['status'] != 'OK') {
//         setState(() {
//           var UnitType = {
//             'intcode': intcodevalue,
//             'value': "All",
//           };
//           dropdowndata_UDMUserDepot.add(UnitType);
//           userDepot = intcodevalue;
//         });
//       } else {
//         var UnitType = {
//           'intcode': intcodevalue,
//           'value': "All",
//         };
//         myList_UDMUserDepot.add(UnitType);
//         myList_UDMUserDepot.addAll(depotData);
//         setState(() {
//           dropdowndata_UDMUserDepot = myList_UDMUserDepot;
//           if (depot_id != "") {
//             userDepot = depot_id;
//           }
//         });
//       }
//     }
//     IRUDMConstants.removeProgressIndicator(context);
//   }
//
//   Future<dynamic> def_fetchSubDepot(String? rai, String? depot_id, String userSDepo) async {
//     try {
//       dropdowndata_UDMUserSubDepot.clear();
//       if (userSDepo == 'NA') {
//         var all = {
//           'intcode': '-1',
//           'value': "All",
//         };
//         dropdowndata_UDMUserSubDepot.add(all);
//         _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//       } else {
//         var result_UDMUserDepot = await Network().postDataWithAPIMList(
//             'UDMAppList','UserSubDepot' , rai! + "~" + depot_id!,prefs.getString('token'));
//         var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
//         var myList_UDMUserDepot = [];
//         if (UDMUserSubDepot_body['status'] != 'OK') {
//           setState(() {
//             var all = {
//               'intcode': '-1',
//               'value': "All",
//             };
//             dropdowndata_UDMUserSubDepot.add(all);
//             _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//           });
//         } else {
//           var all = {
//             'intcode': '-1',
//             'value': "All",
//           };
//           var subDepotData = UDMUserSubDepot_body['data'];
//           myList_UDMUserDepot.add(all);
//           myList_UDMUserDepot.addAll(subDepotData);
//           setState(() {
//             dropdowndata_UDMUserSubDepot = myList_UDMUserDepot; //2
//             if (userSDepo != "") {
//               //userSubDepot = userSDepo;
//               //_formKey.currentState!.fields['User Sub Depot']!.setValue(userSDepo);
//             } else {
//               //_formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//             }
//           });
//         }
//       }
//     } on HttpException {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } on SocketException {
//       IRUDMConstants()
//           .showSnack("No connectivity. Please check your connection.", context);
//     } on FormatException {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } catch (err) {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } finally {
//       IRUDMConstants.removeProgressIndicator(context);
//     }
//   }
//
//
//   Future<dynamic> def_depart_result(String depart) async {
//     try {
//       var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','',prefs.getString('token'));
//       var UDMDept_body = json.decode(result_UDMDept.body);
//       var deptData = UDMDept_body['data'];
//       var myList_UDMDept = [];
//       myList_UDMDept.addAll(deptData);
//       setState(() {
//         dropdowndata_UDMDept = myList_UDMDept; //5
//         if (depart != '') {
//           _formKey.currentState!.fields['Department']!.setValue(depart);
//         } else {
//           _formKey.currentState!.fields['Department']!.setValue('-1');
//         }
//       });
//     } on HttpException {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } on SocketException {
//       IRUDMConstants()
//           .showSnack("No connectivity. Please check your connection.", context);
//     } on FormatException {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     } catch (err) {
//       IRUDMConstants().showSnack(
//           "Something Unexpected happened! Please try again.", context);
//     }
//   }
//
//   Map<String, String> getAll() {
//     var all = {
//       'intcode': '-1',
//       'value': "All",
//     };
//     return all;
//   }
//
// }

//------- New UI Screen --------
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:flutter_app/udm/providers/consSummaryProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/consSummaryListScreen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumtionSummaryFilter extends StatefulWidget {
  static const routeName = "/consumption-Summary-stock";

  @override
  State<ConsumtionSummaryFilter> createState() =>
      _ConsumtionSummaryFilterState();
}

class _ConsumtionSummaryFilterState extends State<ConsumtionSummaryFilter> {
  // For Item Type and Item Usage
  bool showItemType = false;
  bool showItemUsage = false;

  var userDepotValue = "All";

  // Added missing variable for increase/decrease toggle
  bool _isIncrease = true; // Default to "Increase"

  // Slider control for percentage
  double percentageValue = 20;
  final TextEditingController currentFromDateController =
      TextEditingController(text: '28-02-2025');
  final TextEditingController currentToDateController =
      TextEditingController(text: '29-04-2025');
  final TextEditingController previousFromDateController =
      TextEditingController(text: '29-12-2024');
  final TextEditingController previousToDateController =
      TextEditingController(text: '27-02-2025');

  final consumptionLimitController = TextEditingController();
  final aacPercentageController = TextEditingController();

  late ConsSummaryProvider itemListProvider;

  // Control values
  int selectedSummaryType = 0;
  int selectedChangeType = 0;
  int topItemsValue = 10;
  int consumptioncwacc = 0;

  void initState() {
    super.initState();
    getInitData();
  }

  Future<void> getInitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if (providedTime.isBefore(DateTime.now())) {
      await fetchToken(context);
      default_data();
    } else {
      default_data();
    }
  }

  late SharedPreferences prefs;
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  Future<dynamic> default_data() async {
    Future.delayed(
        Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    var dbResult = await dbHelper.fetchSaveLoginUser();
    try {
      var d_response = await Network.postDataWithAPIM(
          'app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue',
          'GetListDefaultValue',
          dbResult[0][DatabaseHelper.Tb3_col5_emailid],
          prefs.getString('token'));

      var d_JsonData = json.decode(d_response.body);
      var d_Json = d_JsonData['data'];
      var result_UDMRlyList = await Network().postDataWithAPIMList(
          'UDMAppList', 'UDMRlyList', '', prefs.getString('token'));
      var UDMRlyList_body = json.decode(result_UDMRlyList.body);
      var rlyData = UDMRlyList_body['data'];
      var myList_UDMRlyList = [];
      myList_UDMRlyList.addAll(rlyData);

      var staticDataresponse = await Network.postDataWithAPIM(
          'app/Common/UdmAppListStatic/V1.0.0/UdmAppListStatic',
          'UdmAppListStatic',
          '',
          prefs.getString('token'));

      var staticData = json.decode(staticDataresponse.body);
      List staticDataJson = staticData['data'];

      var itemCatDataUrl = await Network().postDataWithAPIMList(
          'UDMAppList', 'ItemCategory', '', prefs.getString('token'));
      var itemData = json.decode(itemCatDataUrl.body);
      var itemCatDataJson = itemData['data'];

      for (int i = 0; i < staticDataJson.length; i++) {
        if (staticDataJson[i]['list_for'] == 'ItemType') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            itemTypeList.add(all);
          });
        }

        if (staticDataJson[i]['list_for'] == 'ItemUsage') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            itemUsageList.add(all);
          });
        }
      }

      setState(() {
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMRlyList = myList_UDMRlyList; //1
        dropdowndata_UDMRlyList
            .sort((a, b) => a['value'].compareTo(b['value'])); //1
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        railway = d_Json[0]['org_zone'];
        railwayname = d_Json[0]['account_name'];
        unitType = d_Json[0]['org_unit_type'];
        unittype = d_Json[0]['unit_type'];
        unitName = d_Json[0]['admin_unit'];
        unitname = d_Json[0]['unit_name'];
        department = d_Json[0]['org_subunit_dept'];
        dept = d_Json[0]['dept_name'];
        userDepot = d_Json[0]['ccode'].toString() == "NA"
            ? "-1"
            : d_Json[0]['ccode'].toString();
        userDepotName = d_Json[0]['ccode'].toString() == "NA"
            ? "All"
            : d_Json[0]['ccode'] + "-" + d_Json[0]['cname'];
        userSubDepotName =
            "${d_Json[0]['sub_cons_code'].toString()}-${d_Json[0]['sub_user_depot'].toString()}";
        userSubDepot = d_Json[0]['sub_cons_code'].toString();
        Future.delayed(Duration(milliseconds: 0), () async {
          fetchDepot(
              d_Json[0]['org_zone'],
              d_Json[0]['org_unit_type'].toString(),
              d_Json[0]['org_subunit_dept'].toString(),
              d_Json[0]['admin_unit'].toString(),
              d_Json[0]['ccode'].toString());
        });
      });
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }

  Future<dynamic> fetchConsignee(
      String? rai, String? depart, String depot_id, String userSubDep) async {
    IRUDMConstants.showProgressIndicator(context);
    dropdowndata_UDMUserDepot.clear();
    if (rai == '-1') {
      var consigneeName = {
        'intcode': '-1',
        'value': "All",
      };
      dropdowndata_UDMUserDepot.add(consigneeName);
    } else {
      var result_UDMConsignee = await Network().postDataWithAPIMList(
          'UDMAppList',
          'ConsigneeInBillStatus',
          rai!,
          prefs.getString('token'));
      var UDMConsignee_body = json.decode(result_UDMConsignee.body);
      var depotData = UDMConsignee_body['data'];
      var myList_UDMConsignee = [];
      if (UDMConsignee_body['status'] != 'OK') {
        setState(() {
          var _all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMUserDepot.add(_all);
          userDepotValue = _all['intcode'].toString();
        });
      } else {
        myList_UDMConsignee.addAll(depotData);
        setState(() {
          dropdowndata_UDMUserDepot = myList_UDMConsignee;
          if (depot_id != "") {
            userDepot = depot_id;
            dropdowndata_UDMUserDepot.forEach((item) {
              if (item['intcode'].toString().contains(depot_id.toLowerCase())) {
                userDepotValue =
                    item['intcode'].toString() + '-' + item['value'];
              }
            });
            def_fetchSubDepot(rai, depot_id, userSubDep);
          } else {
            var _all = {
              'intcode': '-1',
              'value': "All",
            };
            userDepotValue = _all['intcode'].toString();
          }
        });
      }
    }
    IRUDMConstants.removeProgressIndicator(context);
  }

  Future<dynamic> def_depart_result(String depart) async {
    try {
      var result_UDMDept = await Network().postDataWithAPIMList(
          'UDMAppList', 'UDMDept', '', prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      var deptData = UDMDept_body['data'];
      var myList_UDMDept = [];
      myList_UDMDept.addAll(deptData);
      setState(() {
        dropdowndata_UDMDept = myList_UDMDept; //5
      });
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }

  Future<dynamic> fetchDepot(String? rai, String? depart, String? unit_typ,
      String? Unit_Name, String depot_id) async {
    IRUDMConstants.showProgressIndicator(context);
    dropdowndata_UDMUserDepot.clear();
    if (rai == intcodevalue) {
      var depotName = {
        'intcode': intcodevalue,
        'value': "All",
      };
      dropdowndata_UDMUserDepot.add(depotName);
      userDepot = intcodevalue;
      department = intcodevalue;
    } else {
      var result_UDMUserDepot = await Network().postDataWithAPIMList(
          'UDMAppList',
          'UDMUserDepot',
          rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!,
          prefs.getString('token'));
      var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
      var depotData = UDMUserDepot_body['data'];
      var myList_UDMUserDepot = [];
      if (UDMUserDepot_body['status'] != 'OK') {
        setState(() {
          var UnitType = {
            'intcode': intcodevalue,
            'value': "All",
          };
          dropdowndata_UDMUserDepot.add(UnitType);
          userDepot = intcodevalue;
        });
      } else {
        var UnitType = {
          'intcode': intcodevalue,
          'value': "All",
        };
        myList_UDMUserDepot.add(UnitType);
        myList_UDMUserDepot.addAll(depotData);
        setState(() {
          dropdowndata_UDMUserDepot = myList_UDMUserDepot;
          if (depot_id != "") {
            userDepot = depot_id;
          }
        });
      }
    }
    IRUDMConstants.removeProgressIndicator(context);
  }

  Future<dynamic> def_fetchSubDepot(
      String? rai, String? depot_id, String userSDepo) async {
    try {
      dropdowndata_UDMUserSubDepot.clear();
      if (userSDepo == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserSubDepot.add(all);
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList(
            'UDMAppList',
            'UserSubDepot',
            rai! + "~" + depot_id!,
            prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        var myList_UDMUserDepot = [];
        if (UDMUserSubDepot_body['status'] != 'OK') {
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserSubDepot.add(all);
          });
        } else {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          var subDepotData = UDMUserSubDepot_body['data'];
          myList_UDMUserDepot.add(all);
          myList_UDMUserDepot.addAll(subDepotData);
          setState(() {
            dropdowndata_UDMUserSubDepot = myList_UDMUserDepot;
          });
        }
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } finally {
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  //--- Old variables ----------------
  String? railwayname = "All";
  String? railway;
  String? unittype = "All";
  String? unitType;
  String? unitname = "All";
  String? unitName;
  String? dept = "All";
  String? department;
  String? userDepotName = "All";
  String? userDepot;
  String? userSubDepotName = "All";
  String? userSubDepot;
  String? itemType;
  String? itemUsage;
  String? itemCategory;
  String? isStockItem;
  String? division;
  String? fromDate;
  String? toDate;

  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMDept = [];
  List dropdowndata_UDMUserDepot = [];
  List dropdowndata_UDMUserSubDepot = [];

  List itemTypeList = [];
  List itemUsageList = [];
  String? itemtypename = "All";
  String? itemtypecode = "-1";
  String? itemusagename = "Any";
  String? itemusagecode = "-1";


  String intcodevalue = "-1";

  _all() {
    var all = {
      'intcode': intcodevalue,
      'value': 'All',
    };
    return all;
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AapoortiConstants.primary,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(Provider.of<LanguageProvider>(context).text('consSummary')),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModifiedCard(
                    title: '',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(language.text('railway'),
                            style: TextStyle(
                              fontSize: 13, // Reduced font size by 15%
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            )),
                        SizedBox(height: 10),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(
                                7), // Slightly reduced radius
                            color: Colors.white,
                          ),
                          child: DropdownSearch<String>(
                            selectedItem: railwayname,
                            popupProps: PopupPropsMultiSelection.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                              showSelectedItems: true,
                              menuProps: MenuProps(
                                  shape: RoundedRectangleBorder(
                                // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                    color: Colors
                                        .grey), // You can customize the border color
                              )),
                            ),
                            decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(left: 10))),
                            items: (filter, loadProps) =>
                                dropdowndata_UDMRlyList.map((e) {
                              return e['value'].toString().trim();
                            }).toList(),
                            onChanged: (newValue) {
                              var rlyname;
                              var rlycode;
                              dropdowndata_UDMRlyList.forEach((element) {
                                if (newValue.toString() ==
                                    element['value'].toString()) {
                                  rlyname = element['value'].toString().trim();
                                  rlycode = element['intcode'].toString();
                                  try {
                                    setState(() {
                                      railway = rlycode;
                                      railwayname = rlyname;

                                      dropdowndata_UDMUserDepot.clear();
                                      dropdowndata_UDMUserDepot.add(_all());
                                      dropdowndata_UDMUserSubDepot.clear();
                                      dropdowndata_UDMUserSubDepot.add(_all());
                                      dept = "All";
                                      userDepotName = "All";
                                      department = '-1';
                                      userDepot = '-1';
                                      userSubDepotName = "All";
                                      userSubDepot = "-1";
                                    });
                                  } catch (e) {
                                    debugPrint("execption" + e.toString());
                                  }
                                  def_depart_result(railway!);
                                  fetchConsignee(railway, '', '', '');
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(language.text('departmentName'),
                            style: TextStyle(
                              fontSize: 13, // Reduced font size by 15%
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            )),
                        SizedBox(height: 10),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(
                                7), // Slightly reduced radius
                            color: Colors.white,
                          ),
                          child: DropdownSearch<String>(
                            selectedItem: dept,
                            popupProps: PopupPropsMultiSelection.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                              showSelectedItems: true,
                              menuProps: MenuProps(
                                  shape: RoundedRectangleBorder(
                                // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                    color: Colors
                                        .grey), // You can customize the border color
                              )),
                            ),
                            decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(left: 10))),
                            items: (filter, loadProps) =>
                                dropdowndata_UDMDept.map((e) {
                              return e['value'].toString().trim();
                            }).toList(),
                            onChanged: (String? newValue) {
                              var deptt;
                              var deparmentt;
                              dropdowndata_UDMDept.forEach((element) {
                                if (newValue.toString() ==
                                    element['value'].toString()) {
                                  deptt = element['value'].toString().trim();
                                  deparmentt = element['intcode'].toString();
                                  debugPrint(
                                      "department code here $deparmentt");
                                  try {
                                    setState(() {
                                      department = deparmentt;
                                      dept = deptt;

                                      dropdowndata_UDMUserDepot.clear();
                                      dropdowndata_UDMUserDepot.add(_all());
                                      dropdowndata_UDMUserSubDepot.clear();
                                      dropdowndata_UDMUserSubDepot.add(_all());
                                      userDepotName = "All";
                                      userDepot = '-1';
                                      userSubDepotName = "All";
                                      userSubDepot = "-1";
                                    });
                                  } catch (e) {
                                    debugPrint("execption" + e.toString());
                                  }
                                  fetchConsignee(railway, department, '', '');
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(language.text('userDepot'),
                            style: TextStyle(
                              fontSize: 13, // Reduced font size by 15%
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            )),
                        SizedBox(height: 10),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(
                                7), // Slightly reduced radius
                            color: Colors.white,
                          ),
                          child: DropdownSearch<String>(
                            popupProps: PopupPropsMultiSelection.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                              showSelectedItems: true,
                              menuProps: MenuProps(
                                  shape: RoundedRectangleBorder(
                                // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                    color: Colors
                                        .grey), // You can customize the border color
                              )),
                            ),
                            selectedItem: userDepotName.toString().length > 35
                                ? userDepotName.toString().substring(0, 32)
                                : userDepotName.toString(),
                            decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(left: 10))),
                            items: (filter, loadProps) =>
                                dropdowndata_UDMUserDepot.map((e) {
                              return e['value'].toString().trim() == "All"
                                  ? e['value'].toString().trim()
                                  : e['intcode'].toString().trim() +
                                      "-" +
                                      e['value'].toString().trim();
                            }).toList(),
                            onChanged: (String? newValue) {
                              var userDepotname;
                              var userDepotCode;
                              dropdowndata_UDMUserDepot.forEach((element) {
                                if (newValue.toString().trim() ==
                                    element['intcode'].toString().trim() +
                                        "-" +
                                        element['value'].toString().trim()) {
                                  userDepotname =
                                      element['intcode'].toString().trim() +
                                          "-" +
                                          element['value'].toString().trim();
                                  userDepotCode = element['intcode'].toString();
                                  debugPrint(
                                      "user depot code here $userDepotCode");
                                  try {
                                    setState(() {
                                      userDepot = userDepotCode;
                                      userDepotName = userDepotname;

                                      dropdowndata_UDMUserSubDepot.clear();
                                      dropdowndata_UDMUserSubDepot.add(_all());
                                      userSubDepotName = "All";
                                      userSubDepot = "-1";
                                    });
                                    userDepotValue = newValue.toString();
                                    var depot = userDepotValue.split('-');
                                    def_fetchSubDepot(railway, depot[0], '');
                                  } catch (e) {
                                    debugPrint("execption" + e.toString());
                                  }
                                } else {
                                  setState(() {
                                    userDepotname = "All";
                                    userDepotCode = "-1";
                                  });
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(language.text('userSubDepot'),
                            style: TextStyle(
                              fontSize: 13, // Reduced font size by 15%
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            )),
                        SizedBox(height: 10),
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(
                                7), // Slightly reduced radius
                            color: Colors.white,
                          ),
                          child: DropdownSearch<String>(
                            popupProps: PopupPropsMultiSelection.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                              showSelectedItems: true,
                              menuProps: MenuProps(
                                  shape: RoundedRectangleBorder(
                                // Custom shape without the right side scroll line
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                    color: Colors
                                        .grey), // You can customize the border color
                              )),
                            ),
                            selectedItem: userSubDepotName.toString().length >
                                    35
                                ? userSubDepotName.toString().substring(0, 32)
                                : userSubDepotName.toString(),
                            decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(left: 10))),
                            items: (filter, loadProps) =>
                                dropdowndata_UDMUserSubDepot.map((e) {
                              return e['value'].toString().trim() == "All"
                                  ? e['value'].toString().trim()
                                  : e['intcode'].toString().trim() +
                                      "-" +
                                      e['value'].toString().trim();
                            }).toList(),
                            onChanged: (String? newValue) {
                              var userSubDepotname;
                              var userSubDepotCode;
                              dropdowndata_UDMUserSubDepot.forEach((element) {
                                if (newValue.toString().trim() ==
                                    element['intcode'].toString().trim() +
                                        "-" +
                                        element['value'].toString().trim()) {
                                  userSubDepotname =
                                      element['intcode'].toString().trim() +
                                          "-" +
                                          element['value'].toString().trim();
                                  userSubDepotCode =
                                      element['intcode'].toString();
                                  debugPrint(
                                      "user Sub depot code here $userSubDepotCode");
                                  try {
                                    setState(() {
                                      userSubDepot = userSubDepotCode;
                                      userSubDepotName = userSubDepotname;
                                    });
                                  } catch (e) {
                                    debugPrint("execption" + e.toString());
                                  }
                                } else {
                                  setState(() {
                                    userSubDepotname = "All";
                                    userSubDepotCode = "-1";
                                  });
                                }
                              });
                            },
                          ),
                        ),
                        // _buildDropdownField(
                        //   label: 'User Sub Depot',
                        //   value: selectedSubDepot,
                        //   items: subDepots,
                        //   onChanged: (val) => setState(() => selectedSubDepot = val),
                        //   isDark: false,
                        // ),
                      ],
                    ),
                  ),

                  _buildCard(
                    title: 'Time Period',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabelText('Current Period'),
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: _buildLabelText('From'),
                            ),
                            Expanded(
                              child: _buildSimpleDateField(
                                controller: currentFromDateController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: _buildLabelText('To'),
                            ),
                            Expanded(
                              child: _buildSimpleDateField(
                                controller: currentToDateController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildLabelText('Previous Period'),
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: _buildLabelText('From'),
                            ),
                            Expanded(
                              child: _buildSimpleDateField(
                                controller: previousFromDateController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: _buildLabelText('To'),
                            ),
                            Expanded(
                              child: _buildSimpleDateField(
                                controller: previousToDateController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  _buildModifiedCard(
                    title: '',
                    content: Column(
                      children: [
                        // Improved sliding toggle
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isIncrease = !_isIncrease;
                              selectedChangeType = _isIncrease
                                  ? 1
                                  : 0; // Update selectedChangeType (1 for increase, 0 for decrease)
                            });
                          },
                          child: Container(
                            width: 200,
                            height: 50,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                            ),
                            child: Stack(
                              children: [
                                // Sliding selector - fixed width to match container sections
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  left: _isIncrease
                                      ? 0
                                      : 100, // Correct position for half of 200px container width
                                  top: 0,
                                  child: Container(
                                    width:
                                        95, // Exactly half of the parent container
                                    height:
                                        45, // Adjusted to account for padding
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ),
                                // Labels
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Increase (+)',
                                          style: TextStyle(
                                            color: _isIncrease
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: _isIncrease
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Decrease (-)',
                                          style: TextStyle(
                                            color: !_isIncrease
                                                ? Colors.white
                                                : Colors.black87,
                                            fontWeight: !_isIncrease
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // New slider implementation for percentage selection
                        Row(
                          children: [
                            const Text(
                              'By',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: Colors.blue.shade800,
                                      inactiveTrackColor: Colors.blue.shade100,
                                      thumbColor: Colors.blue.shade800,
                                      overlayColor:
                                          Colors.blue.shade800.withOpacity(0.2),
                                      trackHeight: 4,
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 10),
                                    ),
                                    child: Slider(
                                      value: percentageValue,
                                      min: 0,
                                      max: 100,
                                      divisions: 100,
                                      onChanged: (newValue) {
                                        setState(() {
                                          percentageValue = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('0%',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade800,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${percentageValue.toInt()}%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text('100%',
                                          style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  _buildModifiedCard(
                    title: '',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryTypeOption(
                          value: 0,
                          label: 'Top "N" High Consumption Value Items',
                        ),
                        _buildSummaryTypeOption(
                          value: 1,
                          label: 'Items having Consumption Value above specified Limit',
                        ),
                        _buildSummaryTypeOption(
                          value: 2,
                          label: 'Consumption comparison with AAC',
                        ),
                        if (selectedSummaryType == 0) ...[
                          const SizedBox(height: 16),
                          _buildLabelText(
                              'Specify "N" No. of Top High Value Items'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  if (topItemsValue > 1) {
                                    setState(() {
                                      topItemsValue--;
                                    });
                                  }
                                },
                                color: Colors.blue.shade800,
                              ),
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Center(
                                    child: Text(
                                      topItemsValue.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    topItemsValue++;
                                  });
                                },
                                color: Colors.blue.shade800,
                              ),
                            ],
                          ),
                        ],
                        if(selectedSummaryType == 1) ...[
                           const SizedBox(height: 16),
                          _buildLabelText('Specify Limit of Consumptioon Value(in Rs.)'),
                          const SizedBox(height:  8),
                          _buildConsumptionLimitField(),
                        ],
                        if(selectedSummaryType == 2) ...[
                          const SizedBox(height: 16),
                          _buildAACComparisonVisualization()
                        ]
                      ],
                    ),
                  ),

                  // Item Type and Item Usage buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildExpandableButton(
                          icon: Icons.category_outlined,
                          label: 'Item Type',
                          onPressed: () {
                            setState(() {
                              showItemType = !showItemType;
                            });
                          },
                          isExpanded: showItemType,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildExpandableButton(
                          icon: Icons.insights_outlined,
                          label: 'Item Usage',
                          onPressed: () {
                            setState(() {
                              showItemUsage = !showItemUsage;
                            });
                          },
                          isExpanded: showItemUsage,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Expanded sections for Item Type and Item Usage
                  if (showItemType)
                    _buildModifiedCard(
                      title: '',
                      content: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(7), // Slightly reduced radius
                          color: Colors.white,
                        ),
                        child: DropdownSearch<String>(
                          selectedItem: itemtypename,
                          popupProps: PopupPropsMultiSelection.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                            menuProps: MenuProps(
                                shape: RoundedRectangleBorder(
                                  // Custom shape without the right side scroll line
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Colors
                                          .grey), // You can customize the border color
                                )),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.only(left: 10))),
                          items: (filter, loadProps) =>
                              itemTypeList.map((e) {
                                return e['value'].toString().trim();
                              }).toList(),
                          onChanged: (newValue) {
                            itemTypeList.forEach((element) {
                              if (newValue.toString() == element['value'].toString()) {
                                var itemtype = element['value'].toString().trim();
                                var itemtypeCode = element['intcode'].toString();
                                try {
                                  setState(() {
                                      itemtypecode = itemtypeCode;
                                      itemtypename = itemtype;
                                  });
                                } catch (e) {
                                  debugPrint("execption" + e.toString());
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    if (showItemUsage)
                      _buildModifiedCard(
                        title: '',
                        content: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(7), // Slightly reduced radius
                            color: Colors.white,
                          ),
                          child: DropdownSearch<String>(
                            selectedItem: itemusagename,
                            popupProps: PopupPropsMultiSelection.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                              showSelectedItems: true,
                              menuProps: MenuProps(
                                  shape: RoundedRectangleBorder(
                                    // Custom shape without the right side scroll line
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: Colors
                                            .grey), // You can customize the border color
                                  )),
                            ),
                            decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(left: 10))),
                            items: (filter, loadProps) =>
                                itemUsageList.map((e) {
                                  return e['value'].toString().trim();
                                }).toList(),
                            onChanged: (newValue) {
                              itemUsageList.forEach((element) {
                                if (newValue.toString() == element['value'].toString()) {
                                  var itemusage = element['value'].toString().trim();
                                  var itemusageCode = element['intcode'].toString();
                                  try {
                                    setState(() {
                                      itemusagename = itemusage;
                                      itemusagecode = itemusageCode;
                                    });
                                  } catch (e) {
                                    debugPrint("execption" + e.toString());
                                  }
                                }
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                  // Action Buttons - Get Details and Reset
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.refresh,
                          label: language.text('reset'),
                          onPressed: () {
                            setState(() {
                              // Reset Item Type and Item Usage
                              showItemType = false;
                              showItemUsage = false;

                              // Reset control values
                              selectedSummaryType = 0;
                              selectedChangeType = 0;
                              topItemsValue = 10;
                              percentageValue = 20; // Reset slider value

                              // Reset date controllers
                              currentFromDateController.text = '28-02-2025';
                              currentToDateController.text = '29-04-2025';
                              previousFromDateController.text = '29-12-2024';
                              previousToDateController.text = '27-02-2025';

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: const Text('All fields have been reset'),
                                  backgroundColor: Colors.blue.shade800,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            });
                          },
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.present_to_all,
                          label: language.text('getDetails'),
                          onPressed: () {
                            setState(() {
                              if(userDepotValue.toString() == "All" || userDepotValue.toString() == "-1") {
                                  itemListProvider = Provider.of<ConsSummaryProvider>(context,listen: false);
                                  String? itemUnit;
                                  String cFrom = currentFromDateController.text;
                                  String cTo = currentToDateController.text;
                                  if (!showItemUsage) {
                                    itemUsage = '-1';
                                  }
                                  else {
                                    itemUsage = itemusagecode;
                                  }
                                  if (!showItemType) {
                                    itemUnit = '-1';
                                  } else {
                                    itemUnit = itemtypecode;
                                  }

                                  String? lable, percValue = '', perc;
                                  if (selectedSummaryType == 0) {
                                    lable = 'A';
                                    percValue = topItemsValue.toString();
                                  }
                                  else if (selectedSummaryType == 1) {
                                    lable = 'B';
                                    percValue = consumptionLimitController.text.trim();
                                  }
                                  else {
                                    lable = 'C';
                                    if(selectedChangeType == 0) {
                                      perc = '1';
                                    } else {
                                      perc = '2';
                                    }
                                    percValue = aacPercentageController.text.trim() +'~' +perc;
                                  }

                                  if (percValue.isEmpty) {
                                    IRUDMConstants().showSnack('Please fill all the fields', context);
                                  } else {
                                    Navigator.of(context).pushNamed(ConsSummaryScreen.routeName);
                                    itemListProvider.fetchAndStoreItemsListwithdata(
                                            lable,
                                            cFrom,
                                            cTo,
                                            railway,
                                            department,
                                            "-1",
                                            //_formKey.currentState!.fields['User Depot']!.value,
                                            userSubDepot,
                                            itemUsage,
                                            itemUnit,
                                            percValue,
                                            context);
                                  }
                                } else {
                                  itemListProvider = Provider.of<ConsSummaryProvider>(context,listen: false);
                                  String? itemUnit;
                                  String cFrom = currentFromDateController.text;
                                  String cTo = currentToDateController.text;
                                  if(!showItemUsage) {
                                    itemUsage = '-1';
                                  } else {
                                    itemUsage = itemusagecode;
                                  }
                                  if (!showItemType) {
                                    itemUnit = '-1';
                                  } else {
                                    itemUnit = itemtypecode;
                                  }

                                  String? lable, percValue = '', perc;
                                  if (selectedSummaryType == 0) {
                                    lable = 'A';
                                    percValue = topItemsValue.toString();
                                  } else if (selectedSummaryType == 1) {
                                    lable = 'B';
                                    percValue = consumptionLimitController.text.trim();
                                  } else {
                                    lable = 'C';
                                    if(selectedChangeType == 0) {
                                      perc = '1';
                                    } else {
                                      perc = '2';
                                    }
                                    percValue = aacPercentageController.text.trim() +'~' +perc;
                                  }
                                  if (percValue.isEmpty) {
                                    IRUDMConstants().showSnack('Please fill all the fields', context);
                                  } else {
                                    Navigator.of(context).pushNamed(ConsSummaryScreen.routeName);
                                    var depot = userDepotValue.split('-');
                                    itemListProvider.fetchAndStoreItemsListwithdata(
                                            lable,
                                            cFrom,
                                            cTo,
                                            railway,
                                            department,
                                            depot[0],
                                            //_formKey.currentState!.fields['User Depot']!.value,
                                            userSubDepot,
                                            itemUsage,
                                            itemUnit,
                                            percValue,
                                            context);
                                  }
                                }
                              });
                          },
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Original styled card widget with title and content - retaining for Time Period and other sections
  Widget _buildCard({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }

  // Modified card widget without blue bar header
  Widget _buildModifiedCard({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Title on the top edge of the card
          if (title.isNotEmpty)
            Positioned(
              top: -9,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.white,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          // Content with extra padding at the top
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: content,
          ),
        ],
      ),
    );
  }

  // Dropdown field with label - adjusted to support field labels on the edge
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isDark = true,
  }) {
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color backgroundColor =
        isDark ? Colors.white.withOpacity(0.15) : Colors.white;
    final Color borderColor =
        isDark ? Colors.white.withOpacity(0.3) : Colors.grey.shade300;

    if (label.isEmpty) {
      // For empty labels (Item Type and Item Usage sections)
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text(
              'Select',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: textColor,
            ),
            isExpanded: true,
            dropdownColor: Colors.white,
            style: TextStyle(
              color: isDark ? Colors.black87 : textColor,
              fontSize: 15,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      );
    }

    // For fields with labels
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Space for the label
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  hint: Text(
                    'Select $label',
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: textColor,
                  ),
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  style: TextStyle(
                    color: isDark ? Colors.black87 : textColor,
                    fontSize: 15,
                  ),
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
        // Label positioned on the top edge of the field
        Positioned(
          top: 0,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: Colors.white,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // New simplified date field without the label inside
  Widget _buildSimpleDateField({
    required TextEditingController controller,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          suffixIcon: Icon(
            Icons.calendar_today_rounded,
            size: 18,
            color: Colors.blue.shade800,
          ),
        ),
        style: const TextStyle(fontSize: 14),
        onTap: () async {
          // Parse the date string manually
          final dateValues = controller.text.split('-');
          if (dateValues.length == 3) {
            try {
              final day = int.parse(dateValues[0]);
              final month = int.parse(dateValues[1]);
              final year = int.parse(dateValues[2]);

              final initialDate = DateTime(year, month, day);

              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.blue.shade800,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                // Format date manually
                final day = pickedDate.day.toString().padLeft(2, '0');
                final month = pickedDate.month.toString().padLeft(2, '0');
                final year = pickedDate.year.toString();

                setState(() {
                  controller.text = '$day-$month-$year';
                });
              }
            } catch (e) {
              // Handle parse error
              print('Date parse error: $e');
            }
          }
        },
      ),
    );
  }

  // Radio button with label
  Widget _buildRadioButton({
    required int value,
    required int groupValue,
    required String label,
    required Function(int?) onChanged,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Radio<int>(
              value: value,
              groupValue: groupValue,
              activeColor: Colors.blue.shade800,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Summary type option radio
  Widget _buildSummaryTypeOption({
    required int value,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => setState(() => selectedSummaryType = value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<int>(
                value: value,
                groupValue: selectedSummaryType,
                activeColor: Colors.blue.shade800,
                onChanged: (val) => setState(() => selectedSummaryType = val!),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selectedSummaryType == value
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: selectedSummaryType == value
                          ? Colors.blue.shade800
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section label text
  Widget _buildLabelText(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  // Button with icon and label
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blue.shade800 : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.blue.shade800,
        elevation: isPrimary ? 2 : 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: Colors.blue.shade800),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: isPrimary ? 0.5 : 0,
            ),
          ),
        ],
      ),
    );
  }

  // Expandable button with + sign
  Widget _buildExpandableButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isExpanded,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.blue.shade800),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isExpanded ? Icons.remove : Icons.add,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildConsumptionLimitField() {
    return TextField(
      controller: consumptionLimitController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade800),
        ),
        hintText: 'Enter amount in Rs.',
        suffixText: 'Rs.',
        suffixStyle: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }

  Widget _buildAACComparisonVisualization() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Consumption comparison with AAC',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Radio buttons for selection
          Row(
            children: [
              Radio(
                value: 0,
                groupValue: selectedChangeType,
                activeColor: Colors.blue.shade800,
                onChanged: (value) {
                  setState(() {
                    selectedChangeType = value as int;
                  });
                },
              ),
              const Text(
                'Percent Greater than (>)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          Row(
            children: [
              Radio(
                value: 1,
                groupValue: selectedChangeType,
                activeColor: Colors.blue.shade800,
                onChanged: (value) {
                  setState(() {
                    selectedChangeType = value as int;
                  });
                },
              ),
              const Text(
                'Percent Less than (<=)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Text field for value
          TextField(
            keyboardType: TextInputType.number,
            controller: aacPercentageController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade800),
              ),
              hintText: '10',
            ),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 16),

          // Proportionate Quantity text
          const Text(
            'Proportionate Quantity as per AAC',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'AAC: Annual Approved Consumption',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }}

Widget _buildCard({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
}
