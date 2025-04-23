// import 'dart:convert';
// import 'dart:io';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_app/udm/helpers/api.dart';
// import 'package:flutter_app/udm/helpers/database_helper.dart';
// import 'package:flutter_app/udm/helpers/shared_data.dart';
// import 'package:flutter_app/udm/localization/english.dart';
// import 'package:flutter_app/udm/providers/itemsProvider.dart';
// import 'package:flutter_app/udm/providers/languageProvider.dart';
// import 'package:flutter_app/udm/providers/stockProvider.dart';
// import 'package:flutter_app/udm/providers/valueWiseProvider.dart';
// import 'package:flutter_app/udm/screens/itemlist_screen.dart';
// import 'package:flutter_app/udm/screens/stock_list_screen.dart';
// import 'package:flutter_app/udm/screens/valueWise_list_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ValueWiseStockFilter extends StatefulWidget {
//   static const routeName = "/value-wise-stock";
//   @override
//   _ValueWiseStockFilterState createState() => _ValueWiseStockFilterState();
// }
//
// class _ValueWiseStockFilterState extends State<ValueWiseStockFilter> {
//   double? sheetLeft;
//   bool isExpanded = true;
//   late ValueWiseProvider itemListProvider;
//   String? railway;
//   String? unittype;
//   String? department;
//   String? userDepot;
//   String? userSubDepot;
//   String? itemType;
//   String? itemUsage;
//   String? itemCategory;
//   String? stockNonStk;
//   String? division;
//   String? dropDownValue;
//   String? stockAvl, stkReport;
//   String enterData = '10000';
//   final _formKey = GlobalKey<FormBuilderState>();
//
//   List dropdowndata_UDMRlyList = [];
//   List dropdowndata_UDMUnitType = [];
//   List dropdowndata_UDMDivision = [];
//   List dropdowndata_UDMUserDepot = [];
//   List dropdowndata_UDMDept = [];
//   List dropdowndata_UDMItemsResult = [];
//   List dropdowndata_UDMUserSubDepot = [];
//
//   //Static Data List
//   List itemTypeList = [];
//   List itemUsageList = [];
//   List itemtCategryaList = [];
//   List stockNonStockList = [];
//   List stockAvailability = [];
//
//   bool itemTypeVis = false;
//   bool itemUsageVis = false;
//   bool itemCatVis = false;
//   bool stkVis = false;
//
//   bool itemTypeButtonVis = true;
//   bool itemUsageBtnVis = true;
//   bool itemCatBtnVis = true;
//   bool stkBtnVis = true;
//
//   late List<Map<String, dynamic>> dbResult;
//
//   Error? _error;
//   bool _autoValidate = false;
//
//   var userDepotValue = "All";
//
//   @override
//   Widget build(BuildContext context) {
//     LanguageProvider language = Provider.of<LanguageProvider>(context);
//     Size mq = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AapoortiConstants.primary,
//         iconTheme: IconThemeData(color: Colors.white),
//         leading: IconButton(
//           splashRadius: 30,
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.home, color: Colors.white, size: 22),
//             onPressed: () {
//               Navigator.of(context).pop();
//               //Feedback.forTap(context);
//             },
//           ),
//         ],
//         title: Text(language.text('valueWiseStock'), style: TextStyle(color: Colors.white)),
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
//           child: Column(children: <Widget>[
//             FormBuilderDropdown(
//               name: englishText['railway'] ?? 'railway',
//               focusColor: Colors.transparent,
//               decoration: InputDecoration(
//                 labelText: language.text('Railway'),
//                 contentPadding: EdgeInsetsDirectional.all(10),
//                 border: const OutlineInputBorder(),
//               ),
//               initialValue: railway,
//               //allowClear: false,
//               //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
//               //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
//               items: dropdowndata_UDMRlyList.map((item) {
//                 return DropdownMenuItem(
//                     child: Text(() {
//                       if(item['intcode'].toString() == '-1') {
//                         return item['value'];
//                       } else {
//                         return item['value'];
//                       }}()),
//                     value: item['intcode'].toString());
//               }).toList(),
//               onChanged: (String? newValue) {
//                 debugPrint("new railway:: $newValue");
//                 _formKey.currentState!.fields['Unit Name']!.setValue(null);
//                 _formKey.currentState!.fields['Unit Type']!.setValue(null);
//                 _formKey.currentState!.fields['Department']!.setValue(null);
//                 //_formKey.currentState!.fields['User Depot']!.setValue(null);
//                 _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//                 setState(() {
//                   railway = newValue;
//
//                   dropdowndata_UDMUnitType.clear();
//                   dropdowndata_UDMDivision.clear();
//                   dropdowndata_UDMUserDepot.clear();
//                   dropdowndata_UDMUserSubDepot.clear();
//                   dropdowndata_UDMUserSubDepot.add(_all());
//                   dropdowndata_UDMUnitType.add(_all());
//                   dropdowndata_UDMDivision.add(_all());
//                   dropdowndata_UDMUserDepot.add(_all());
//                   _formKey.currentState!.fields['Unit Name']!.setValue('-1');
//                   _formKey.currentState!.fields['Unit Type']!.setValue('-1');
//                   _formKey.currentState!.fields['Department']!.setValue('-1');
//                   userDepotValue = "-1";
//                   //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//                   _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//                   unittype = "-1";
//                 });
//                 def_fetchUnit(railway, '', '', '', '', '');
//                 // setState(() {
//                 //   railway = newValue;
//                 // });
//               },
//             ),
//             // stockDropdown(
//             //     'railway',
//             //     '${language.text('select')} ${language.text('railway')}',
//             //     dropdowndata_UDMRlyList,
//             //     railway),
//             SizedBox(height: 10),
//             FormBuilderDropdown(
//               name: englishText['unitType'] ?? 'unitType',
//               focusColor: Colors.transparent,
//               decoration: InputDecoration(
//                 labelText: language.text('unitType'),
//                 contentPadding: EdgeInsetsDirectional.all(10),
//                 border: const OutlineInputBorder(),
//               ),
//               initialValue: dropdowndata_UDMUnitType.any((item) => item['intcode'].toString() == unittype) ? unittype : null,
//               //allowClear: false,
//               //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
//               //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
//               items: dropdowndata_UDMUnitType.map((item) {
//                 return DropdownMenuItem(
//                     child: Text(() {
//                       if(item['intcode'].toString() == '-1') {
//                         return item['value'];
//                       } else {
//                         return item['value'];
//                       }}()),
//                     value: item['intcode'].toString());
//               }).toList(),
//               onChanged: (String? newValue) {
//                 _formKey.currentState!.fields['Unit Name']!.setValue('-1');
//                 _formKey.currentState!.fields['Department']!.setValue('-1');
//                 setState(() {
//                   unittype = newValue;
//                   dropdowndata_UDMUserDepot.clear();
//                   dropdowndata_UDMUserSubDepot.clear();
//                   dropdowndata_UDMUserDepot.add(_all());
//                   dropdowndata_UDMUserSubDepot.add(_all());
//                   //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//                   userDepotValue = "-1";
//                   _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//                 });
//                 def_fetchunitName(railway!, unittype!, '', '', '', '');
//                 // setState(() {
//                 //   unittype = newValue;
//                 // });
//               },
//             ),
//             // stockDropdown(
//             //     'unitType',
//             //     '${language.text('select')} ${language.text('unitType')}',
//             //     dropdowndata_UDMUnitType,
//             //     unittype),
//             SizedBox(height: 10),
//             FormBuilderDropdown(
//               name: englishText['unitName'] ?? 'unitName',
//               focusColor: Colors.transparent,
//               decoration: InputDecoration(
//                 labelText: language.text('unitName'),
//                 contentPadding: EdgeInsetsDirectional.all(10),
//                 border: const OutlineInputBorder(),
//               ),
//               initialValue: dropdowndata_UDMDivision.any((item) => item['intcode'].toString() == division) ? division : null,
//               //initialValue: division,
//               //allowClear: false,
//               //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
//               //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
//               items: dropdowndata_UDMDivision.map((item) {
//                 return DropdownMenuItem(
//                     child: Text(() {
//                       if(item['intcode'].toString() == '-1') {
//                         return item['value'];
//                       } else {
//                         return item['value'];
//                       }}()),
//                     value: item['intcode'].toString());
//               }).toList(),
//               onChanged: (String? newValue) {
//                 _formKey.currentState!.fields['Department']!.setValue(null);
//                 //_formKey.currentState!.fields['User Depot']!.setValue(null);
//                 _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//                 setState(() {
//                   division = newValue;
//                   itemType = null;
//                   itemUsage = null;
//                   itemCategory = null;
//                   stockNonStk = null;
//                   stockAvl = null;
//                 });
//                 // setState(() {
//                 //   division = newValue;
//                 // });
//               },
//             ),
//             // stockDropdown(
//             //     'unitName',
//             //     '${language.text('select')} ${language.text('unitName')}',
//             //     dropdowndata_UDMDivision,
//             //     division),
//             SizedBox(height: 10),
//             FormBuilderDropdown(
//               name: englishText['department'] ?? 'department',
//               focusColor: Colors.transparent,
//               decoration: InputDecoration(
//                 labelText: language.text('department'),
//                 contentPadding: EdgeInsetsDirectional.all(10),
//                 border: const OutlineInputBorder(),
//               ),
//               initialValue: dropdowndata_UDMDept.any((item) => item['intcode'].toString() == department) ? department : null,
//               //initialValue: division,
//               //allowClear: false,
//               //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
//               //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
//               items: dropdowndata_UDMDept.map((item) {
//                 return DropdownMenuItem(
//                     child: Text(() {
//                       if(item['intcode'].toString() == '-1') {
//                         return item['value'];
//                       } else {
//                         return  item['value'];
//                       }}()),
//                     value: item['intcode'].toString());
//               }).toList(),
//               onChanged: (String? newValue) {
//                 _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//                 setState(() {
//                   department = newValue;
//                   itemType = null;
//                   itemUsage = null;
//                   itemCategory = null;
//                   stockNonStk = null;
//                   stockAvl = null;
//                   def_fetchDepot(railway, department, unittype, division, '', '');
//                 });
//                 // setState(() {
//                 //   department = newValue;
//                 // });
//               },
//             ),
//             // stockDropdown(
//             //     'department',
//             //     '${language.text('select')} ${language.text('department')}',
//             //     dropdowndata_UDMDept,
//             //     department),
//             SizedBox(height: 10),
//             DropdownSearch<String>(
//               //showSearchBox: true,
//               //showSelectedItems: true,
//               selectedItem: userDepotValue == "-1" || userDepotValue == "All" ? "All" : userDepotValue,
//               //maxHeight:MediaQuery.of(context).size.height * 0.90,
//               //mode: Mode.MENU,
//               popupProps: PopupPropsMultiSelection.menu(
//                 showSearchBox: true,
//                 fit: FlexFit.loose,
//                 showSelectedItems: true,
//                 emptyBuilder: (ctx, val) {
//                   return Align(
//                     alignment: Alignment.topCenter,
//                     child: Text('No Data Found for $val'),
//                   );
//                 },
//                 searchFieldProps: TextFieldProps(
//                   decoration: InputDecoration(
//                     hintText: '${language.text('select')} ${language.text('userDepot')}',
//                     contentPadding: EdgeInsetsDirectional.all(10),
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//                 menuProps: MenuProps(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                       ),
//                     )
//                 ),
//               ),
//               decoratorProps: DropDownDecoratorProps(
//                 decoration: InputDecoration(
//                   labelText: language.text('userDepot'),
//                   hintText: '${language.text('select')} ${language.text('userDepot')}',
//                   alignLabelWithHint: true,
//                   contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, bottom: 5.0, top: 5.0),
//                   border: const OutlineInputBorder(),
//                 ),
//               ),
//               // popupSafeArea: const PopupSafeArea(
//               //   top: true,
//               //   bottom: true,
//               // ),
//               // popupTitle: Align(
//               //   alignment: Alignment.topRight,
//               //   child: Container(
//               //     height: 45,
//               //     margin: EdgeInsets.all(10),
//               //     decoration: BoxDecoration(
//               //       border: Border.all(color: Colors.black87, width: 2),
//               //       shape: BoxShape.circle,
//               //     ),
//               //     child: IconButton(
//               //       icon: const Icon(Icons.close),
//               //       onPressed: () {
//               //         Navigator.of(context).pop();
//               //       },
//               //     ),
//               //   ),
//               // ),
//               items: (filter, loadProps) => dropdowndata_UDMUserDepot.map((item) {
//                 return item['intcode'].toString() != "-1" ? item['intcode'].toString() + '-' + item['value'] : item['value'].toString();
//               }).toList(),
//               onChanged: (String? newValue) {
//                 dropDownValue = newValue;
//                 _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//                 setState(() {
//                   userDepotValue = newValue.toString();
//                   var depot = userDepotValue.split('-');
//                   def_fetchSubDepot(railway, depot[0], '');
//                 });
//               },
//             ),
//             // FormBuilderDropdown(
//             //   name: 'User Depot',
//             //   focusColor: Colors.transparent,
//             //   decoration: InputDecoration(
//             //     labelText: language.text('userDepot'),
//             //     contentPadding: EdgeInsetsDirectional.all(10),
//             //     border: const OutlineInputBorder(),
//             //   ),
//             //   initialValue: dropDownValue,
//             //   allowClear: false,
//             //   hint: Text(
//             //       '${language.text('select')} ${language.text('userDepot')}'),
//             //   validator: FormBuilderValidators.compose(
//             //       [FormBuilderValidators.required(context)]),
//             //   items: dropdowndata_UDMUserDepot.map((item) {
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
//             //     dropDownValue = newValue;
//             //     _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//             //     setState(() {
//             //       userDepot = newValue;
//             //       def_fetchSubDepot(railway, dropDownValue, '');
//             //     });
//             //   },
//             // ),
//             SizedBox(height: 10),
//             FormBuilderDropdown(
//               name: 'User Sub Depot',
//               focusColor: Colors.transparent,
//               decoration: InputDecoration(
//                 labelText: language.text('userSubDepot'),
//                 contentPadding: EdgeInsetsDirectional.all(10),
//                 border: const OutlineInputBorder(),
//               ),
//               initialValue: dropdowndata_UDMUserSubDepot.any((item) => item['intcode'].toString() == userSubDepot) ? userSubDepot : null,
//               //allowClear: false,
//               //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return 'field is required';
//                 }
//                 return null; // Return null if the value is valid
//               },
//               items: dropdowndata_UDMUserSubDepot.map((item) {
//                 return DropdownMenuItem(
//                     child: Text(() {
//                       if (item['intcode'].toString() == '-1') {
//                         return item['value'];
//                       } else {
//                         return item['intcode'].toString() + '-' + item['value'];
//                       }
//                     }()),
//                     value: item['intcode'].toString());
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   userSubDepot = newValue;
//                 });
//               },
//             ),
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
//             //  stockDropdownStatic('Item Category','Select Item Category',itemtCategryaList,''),
//             Visibility(
//               visible: itemCatVis,
//               child: Column(
//                 children: [
//                   SizedBox(height: 10),
//                   FormBuilderDropdown(
//                     name: 'Item Category',
//                     focusColor: Colors.transparent,
//                     decoration: InputDecoration(
//                       labelText: language.text('itemCategory'),
//                       contentPadding: EdgeInsetsDirectional.all(10),
//                       border: const OutlineInputBorder(),
//                     ),
//                     initialValue: itemCategory,
//                     //allowClear: false,
//                     //hint: Text('Select Item Category'),
//                     validator: (String? value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Select Item Category is required';
//                       }
//                       return null; // Return null if the value is valid
//                     },
//                     items: itemtCategryaList.map((item) {
//                       return new DropdownMenuItem(
//                           child: new Text(() {
//                             if (item['intcode'].toString() == '-1') {
//                               return item['value'];
//                             } else {
//                               return item['intcode'].toString() +
//                                   '-' +
//                                   item['value'];
//                             }
//                           }()),
//                           value: item['intcode'].toString());
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       itemCategory = newValue;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Visibility(
//               visible: stkVis,
//               child: Column(
//                 children: [
//                   SizedBox(height: 10),
//                   stockDropdownStatic(
//                     'stockNonStock',
//                     'Select Whether Stock/Non-Stock',
//                     stockNonStockList,
//                     stockNonStk,
//                     name: 'Whether Stock/Non-Stock',
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             stockDropdownStatic(
//               'stockAvailability',
//               '${language.text('select')} ${language.text('stockAvailability')}',
//               stockAvailability,
//               '1',
//               name: 'Stock Availability',
//             ),
//             SizedBox(height: 10),
//             FormBuilderTextField(
//               name: 'freeText',
//               initialValue: enterData,
//               keyboardType: TextInputType.number,
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return 'field is required';
//                 }
//                 return null; // Return null if the value is valid
//               },
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsetsDirectional.all(10),
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(language.text('valueInRsDefinedByUser')),
//             ),
//             Wrap(
//               spacing: 7.5,
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
//                 Visibility(
//                   visible: itemCatBtnVis,
//                   child: FittedBox(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         setState(() {
//                           itemCatVis = true;
//                           itemCatBtnVis = false;
//                           if (itemCatVis) {
//                             itemCategory = '-1';
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
//                             language.text('itemCategory'),
//                             style: TextStyle(color: Colors.white, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: stkBtnVis,
//                   child: FittedBox(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         setState(() {
//                           stkVis = true;
//                           stkBtnVis = false;
//                           if (stkVis) {
//                             stockNonStk = '-1';
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
//                             language.text('stockNonStock'),
//                             style: TextStyle(color: Colors.white, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
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
//                         if (_formKey.currentState!.validate()) {
//                           if(userDepotValue.toString() == "All" || userDepotValue.toString() == "-1"  || userDepotValue == null){
//                             itemListProvider = Provider.of<ValueWiseProvider>(
//                                 context,
//                                 listen: false);
//                             Navigator.of(context)
//                                 .pushNamed(ValueWiseScreen.routeName);
//                             String? itemUnit, itemCat, sns;
//                             if(!itemUsageVis) {
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
//                             if (!stkVis) {
//                               sns = '-1';
//                             } else {
//                               sns = _formKey.currentState!
//                                   .fields['Whether Stock/Non-Stock']!.value;
//                             }
//                             String? itemCatValue = '';
//                             if (!itemCatVis) {
//                               itemCatValue = '-1';
//                             } else {
//                               itemCatValue = _formKey
//                                   .currentState!.fields['Item Category']!.value;
//                             }
//
//                             itemListProvider.fetchAndStoreItemsListwithdata(
//                                 railway,
//                                 _formKey
//                                     .currentState!.fields['Unit Type']!.value,
//                                 _formKey
//                                     .currentState!.fields['Unit Name']!.value,
//                                 _formKey.currentState!.fields['Department']!.value,
//                                 "-1",
//                                 //_formKey.currentState!.fields['User Depot']!.value,
//                                 _formKey.currentState!.fields['User Sub Depot']!
//                                     .value,
//                                 itemUsage,
//                                 itemUnit,
//                                 itemCatValue,
//                                 sns,
//                                 _formKey.currentState!
//                                     .fields['Stock Availability']!.value,
//                                 _formKey
//                                     .currentState!.fields['freeText']!.value,
//                                 context);
//                           }
//                           else{
//                             itemListProvider = Provider.of<ValueWiseProvider>(
//                                 context,
//                                 listen: false);
//                             Navigator.of(context)
//                                 .pushNamed(ValueWiseScreen.routeName);
//                             var depot = userDepotValue.split('-');
//                             String? itemUnit, itemCat, sns;
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
//                             if (!stkVis) {
//                               sns = '-1';
//                             } else {
//                               sns = _formKey.currentState!
//                                   .fields['Whether Stock/Non-Stock']!.value;
//                             }
//                             String? itemCatValue = '';
//                             if (!itemCatVis) {
//                               itemCatValue = '-1';
//                             } else {
//                               itemCatValue = _formKey
//                                   .currentState!.fields['Item Category']!.value;
//                             }
//
//                             itemListProvider.fetchAndStoreItemsListwithdata(
//                                 railway,
//                                 _formKey
//                                     .currentState!.fields['Unit Type']!.value,
//                                 _formKey
//                                     .currentState!.fields['Unit Name']!.value,
//                                 _formKey
//                                     .currentState!.fields['Department']!.value,
//                                 depot[0],
//                                 //_formKey.currentState!.fields['User Depot']!.value,
//                                 _formKey.currentState!.fields['User Sub Depot']!
//                                     .value,
//                                 itemUsage,
//                                 itemUnit,
//                                 itemCatValue,
//                                 sns,
//                                 _formKey.currentState!
//                                     .fields['Stock Availability']!.value,
//                                 _formKey
//                                     .currentState!.fields['freeText']!.value,
//                                 context);
//                           }
//                         }
//                       });
//                     },
//                     // style: ButtonStyle(
//                     //   backgroundColor:
//                     // ),
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
//                         itemCatVis = false;
//                         stkVis = false;
//
//                         itemTypeButtonVis = true;
//                         itemUsageBtnVis = true;
//                         itemCatBtnVis = true;
//                         stkBtnVis = true;
//                         _formKey.currentState!.reset();
//                         default_data();
//                         //reseteValues();
//                       });
//                     },
//                     // style: ButtonStyle(
//                     //   backgroundColor:
//                     // ),
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
//   _aacData(String repotCrit) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('aac', repotCrit);
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
//           _formKey.currentState!.fields['Unit Name']!.setValue(null);
//           _formKey.currentState!.fields['Unit Type']!.setValue(null);
//           _formKey.currentState!.fields['Department']!.setValue(null);
//           //_formKey.currentState!.fields['User Depot']!.setValue(null);
//           _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//           setState(() {
//             railway = newValue;
//
//             dropdowndata_UDMUnitType.clear();
//             dropdowndata_UDMDivision.clear();
//             dropdowndata_UDMUserDepot.clear();
//             dropdowndata_UDMUserSubDepot.clear();
//             dropdowndata_UDMUserSubDepot.add(_all());
//
//             dropdowndata_UDMUnitType.add(_all());
//             dropdowndata_UDMDivision.add(_all());
//             dropdowndata_UDMUserDepot.add(_all());
//             _formKey.currentState!.fields['Unit Name']!.setValue('-1');
//             _formKey.currentState!.fields['Unit Type']!.setValue('-1');
//             _formKey.currentState!.fields['Department']!.setValue('-1');
//             userDepotValue = "-1";
//             //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//             _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//
//             unittype = "-1";
//           });
//           def_fetchUnit(railway, '', '', '', '', '');
//         } else if(name == 'Unit Type') {
//           _formKey.currentState!.fields['Unit Name']!.setValue('-1');
//           _formKey.currentState!.fields['Department']!.setValue('-1');
//           setState(() {
//             unittype = newValue;
//             dropdowndata_UDMUserDepot.clear();
//             dropdowndata_UDMUserSubDepot.clear();
//             dropdowndata_UDMUserDepot.add(_all());
//             dropdowndata_UDMUserSubDepot.add(_all());
//             userDepotValue = "-1";
//             //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//             _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//           });
//           def_fetchunitName(railway!, unittype!, '', '', '', '');
//         } else if (name == 'Unit Name') {
//           _formKey.currentState!.fields['Department']!.setValue(null);
//           //_formKey.currentState!.fields['User Depot']!.setValue(null);
//           _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//           setState(() {
//             division = newValue;
//
//             itemType = null;
//             itemUsage = null;
//             itemCategory = null;
//             stockNonStk = null;
//             stockAvl = null;
//           });
//         } else if (name == 'Department') {
//           //_formKey.currentState!.fields['User Depot']!.setValue(null);
//           _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//           setState(() {
//             department = newValue;
//             itemType = null;
//             itemUsage = null;
//             itemCategory = null;
//             stockNonStk = null;
//             stockAvl = null;
//             def_fetchDepot(railway, department, unittype, division, '', '');
//           });
//         }
//       },
//     );
//   }
//
//   Widget stockDropdownStatic(
//       String key, String hint, List listData, String? initValue,
//       {String? name}) {
//     // name = englishText[key] ?? key;
//     if (name == null) {
//       name = key;
//     }
//
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
//         return new DropdownMenuItem(
//             child: new Text(item['value']), value: item['intcode'].toString());
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
//     dropdowndata_UDMUnitType.clear();
//     dropdowndata_UDMDivision.clear();
//     dropdowndata_UDMUserDepot.clear();
//   }
//
//   void initState() {
//     setState(() {
//       default_data();
//     });
//     super.initState();
//   }
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
//     itemtCategryaList.clear();
//     stockNonStockList.clear();
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
//         if (staticDataJson[i]['list_for'] == 'StockNonStock') {
//           setState(() {
//             var all = {
//               'intcode': staticDataJson[i]['key'],
//               'value': staticDataJson[i]['value'],
//             };
//             stockNonStockList.add(all);
//           });
//         }
//         if (staticDataJson[i]['list_for'] == 'StockAvailability') {
//           setState(() {
//             var all = {
//               'intcode': staticDataJson[i]['key'],
//               'value': staticDataJson[i]['value'],
//             };
//             stockAvailability.add(all);
//           });
//         }
//       }
//
//       setState(() {
//         itemtCategryaList.addAll(itemCatDataJson);
//
//         dropdowndata_UDMUnitType.clear();
//         dropdowndata_UDMDivision.clear();
//         dropdowndata_UDMUserDepot.clear();
//         dropdowndata_UDMRlyList = myList_UDMRlyList; //1
//         dropdowndata_UDMRlyList
//             .sort((a, b) => a['value'].compareTo(b['value'])); //1
//         def_depart_result(d_Json[0]['org_subunit_dept'].toString());
//         railway = d_Json[0]['org_zone'];
//         department = d_Json[0]['org_subunit_dept'];
//         division = d_Json[0]['admin_unit'].toString();
//         unittype = d_Json[0]['org_unit_type'].toString();
//         Future.delayed(Duration(milliseconds: 0), () async {
//           def_fetchUnit(
//               d_Json[0]['org_zone'],
//               d_Json[0]['org_unit_type'].toString(),
//               d_Json[0]['org_subunit_dept'].toString(),
//               d_Json[0]['admin_unit'].toString(),
//               d_Json[0]['ccode'].toString(),
//               d_Json[0]['sub_cons_code'].toString());
//         });
//       });
//       _formKey.currentState!.fields['Railway']!.setValue(d_Json[0]['org_zone']);
//
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
//     ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(value)));
//   }
//
//   Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart, String unitName, String depot, String userSubDep) async {
//     try {
//       var result_UDMUnitType=await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
//       var UDMUnitType_body = json.decode(result_UDMUnitType.body);
//
//       var myList_UDMUnitType = [];
//       if (UDMUnitType_body['status'] != 'OK') {
//         setState(() {
//           dropdowndata_UDMUnitType.add(getAll());
//           _formKey.currentState!.fields['Unit Type']!.setValue("-1");
//           def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
//         });
//       } else {
//         var unitData = UDMUnitType_body['data'];
//         myList_UDMUnitType.add(getAll());
//         myList_UDMUnitType.addAll(unitData);
//         setState(() {
//           // dropdowndata_UDMUnitType.clear();
//           // dropdowndata_UDMunitName.clear();
//           // dropdowndata_UDMUserDepot.clear();
//           // dropdowndata_UDMUserSubDepot.clear();
//           dropdowndata_UDMUnitType = myList_UDMUnitType; //2
//           print(myList_UDMUnitType);
//         });
//         if (value == '-1') {
//           def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
//         }
//       }
//
//       if (unit_data != "") {
//         _formKey.currentState!.fields['Unit Type']!.setValue(unit_data);
//         def_fetchunitName(
//             value!, unit_data, unitName, depot, depart, userSubDep);
//       } else {
//         _formKey.currentState!.fields['Unit Type']!.setValue("-1");
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
//   Future<dynamic> def_fetchunitName(
//       String rai,
//       String unit,
//       String unitName_name,
//       String depot,
//       String depart,
//       String userSubDep) async {
//     try {
//       var result_UDMunitName=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai+"~"+unit,prefs.getString('token'));
//       var UDMunitName_body = json.decode(result_UDMunitName.body);
//       var myList_UDMunitName = [];
//       if (UDMunitName_body['status'] != 'OK') {
//         setState(() {
//           dropdowndata_UDMDivision.add(getAll());
//           _formKey.currentState!.fields['Unit Name']!.setValue('-1');
//           def_fetchDepot(
//               rai, depart.toString(), unit, unitName_name, depot, userSubDep);
//         });
//         // showInSnackBar("please select other value");
//       } else {
//         var divisionData = UDMunitName_body['data'];
//         myList_UDMunitName.add(getAll());
//         myList_UDMunitName.addAll(divisionData);
//         setState(() {
//           //dropdowndata_UDMUserDepot.clear();
//           //dropdowndata_UDMUserSubDepot.clear();
//           dropdowndata_UDMDivision = myList_UDMunitName; //2
//         });
//         if (unit == '-1') {
//           _formKey.currentState!.fields['Department']!.setValue('-1');
//           def_fetchDepot(
//               rai, depart.toString(), unit, unitName_name, depot, userSubDep);
//         }
//       }
//
//       if (unitName_name != "") {
//         _formKey.currentState!.fields['Unit Name']!.setValue(unitName_name);
//         def_fetchDepot(
//             rai, depart.toString(), unit, unitName_name, depot, userSubDep);
//       } else {
//         _formKey.currentState!.fields['Unit Name']!.setValue('-1');
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
//   Future<dynamic> def_fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id, String userSubDep) async {
//     try {
//       dropdowndata_UDMUserDepot.clear();
//       if(depot_id == 'NA') {
//         var all = {
//           'intcode': '-1',
//           'value': "All",
//         };
//         dropdowndata_UDMUserDepot.add(all);
//         userDepotValue = "-1";
//         //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//         def_fetchSubDepot(rai, depot_id, userSubDep);
//       } else {
//         var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UDMUserDepot' , rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!, prefs.getString('token'));
//         var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
//         var myList_UDMUserDepot = [];
//         if (UDMUserDepot_body['status'] != 'OK') {
//           setState(() {
//             var all = {
//               'intcode': '-1',
//               'value': "All",
//             };
//             dropdowndata_UDMUserDepot.add(all);
//             userDepotValue = "-1";
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
//               userDepotValue = "-1";
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
//   // Future<dynamic> def_fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id, String userSubDep) async {
//   //   try {
//   //     dropdowndata_UDMUserDepot.clear();
//   //     if (depot_id == 'NA') {
//   //       var all = {
//   //         'intcode': '-1',
//   //         'value': "All",
//   //       };
//   //       userDepot = '-1';
//   //       dropdowndata_UDMUserDepot.add(all);
//   //       _formKey.currentState!.fields['User Depot']!.setValue('-1');
//   //       def_fetchSubDepot(rai, depot_id, userSubDep);
//   //     } else {
//   //
//   //       var result_UDMUserDepot = await Network().postDataWithAPIMList(
//   //           'UDMAppList','UDMUserDepot' ,
//   //           rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!,prefs.getString('token'));
//   //       var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
//   //       var myList_UDMUserDepot = [];
//   //       if (UDMUserDepot_body['status'] != 'OK') {
//   //         setState(() {
//   //           var all = {
//   //             'intcode': '-1',
//   //             'value': "All",
//   //           };
//   //           dropdowndata_UDMUserDepot.add(all);
//   //           _formKey.currentState!.fields['User Depot']!.setValue('-1');
//   //           def_fetchSubDepot(rai, depot_id, userSubDep);
//   //         });
//   //       } else {
//   //         var depoData = UDMUserDepot_body['data'];
//   //         dropdowndata_UDMUserSubDepot.clear();
//   //         var all = {
//   //           'intcode': '-1',
//   //           'value': "All",
//   //         };
//   //         myList_UDMUserDepot.add(all);
//   //         myList_UDMUserDepot.addAll(depoData);
//   //         setState(() {
//   //           dropdowndata_UDMUserDepot = myList_UDMUserDepot; //2
//   //           if (depot_id != "") {
//   //             userDepot = depot_id;
//   //             _formKey.currentState!.fields['User Depot']!.setValue(depot_id);
//   //             def_fetchSubDepot(rai, depot_id, userSubDep);
//   //           } else {
//   //             _formKey.currentState!.fields['User Depot']!.didChange('-1');
//   //           }
//   //         });
//   //       }
//   //     }
//   //   } on HttpException {
//   //     IRUDMConstants().showSnack(
//   //         "Something Unexpected happened! Please try again.", context);
//   //   } on SocketException {
//   //     IRUDMConstants()
//   //         .showSnack("No connectivity. Please check your connection.", context);
//   //   } on FormatException {
//   //     IRUDMConstants().showSnack(
//   //         "Something Unexpected happened! Please try again.", context);
//   //   } catch (err) {
//   //     IRUDMConstants().showSnack(
//   //         "Something Unexpected happened! Please try again.", context);
//   //   }
//   // }
//
//   Future<dynamic> def_fetchSubDepot(
//       String? rai, String? depot_id, String userSDepo) async {
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
//               userSubDepot = userSDepo;
//               _formKey.currentState!.fields['User Sub Depot']!
//                   .setValue(userSDepo);
//             } else {
//               _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
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
// }


//------ New UI Screen-------------------
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/valuewisestock/provider/valueWiseProvider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ValueWiseStockFilter extends StatefulWidget {
  static const routeName = "/value-wise-stock";

  @override
  State<ValueWiseStockFilter> createState() => _ValuewiseStockfilterState();
}

class _ValuewiseStockfilterState extends State<ValueWiseStockFilter> {

  double? sheetLeft;
  bool isExpanded = true;
  late ValueWiseProvider itemListProvider;
  String? railway;
  String? unittype;
  String? department;
  String? userDepot;
  String? userSubDepot;
  String? itemType;
  String? itemUsage;
  String? itemCategory;
  String? stockNonStk;
  String? division;
  String? dropDownValue;
  String? stockAvl, stkReport;
  String enterData = '10000';
  final _formKey = GlobalKey<FormBuilderState>();

  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMUnitType = [];
  List dropdowndata_UDMDivision = [];
  List dropdowndata_UDMUserDepot = [];
  List dropdowndata_UDMDept = [];
  List dropdowndata_UDMItemsResult = [];
  List dropdowndata_UDMUserSubDepot = [];

  //Static Data List
  List itemTypeList = [];
  List itemUsageList = [];
  List itemtCategryaList = [];
  List stockNonStockList = [];
  List stockAvailability = [];

  bool itemTypeVis = false;
  bool itemUsageVis = false;
  bool itemCatVis = false;
  bool stkVis = false;

  bool itemTypeButtonVis = true;
  bool itemUsageBtnVis = true;
  bool itemCatBtnVis = true;
  bool stkBtnVis = true;

  late List<Map<String, dynamic>> dbResult;

  bool _autoValidate = false;

  var userDepotValue = "All";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //default_data();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getInitData();
    });
  }

  Future<void> getInitData() async{
    await Provider.of<ValueWiseProvider>(context, listen: false).default_data();
    await Provider.of<ValueWiseProvider>(context, listen: false).getRailwaylistData(context);
    //await Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnitInitiatingproposalData("", "", context);
    //await Provider.of<StockingProposalSummaryProvider>(context, listen: false).getUnifyingrlyData(context);
    //await Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStoresDepotData("", context);
  }

  late SharedPreferences prefs;
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  Future<dynamic> default_data() async {
    //Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    itemTypeList.clear();
    itemUsageList.clear();
    itemtCategryaList.clear();
    stockNonStockList.clear();
    //Item Usage Item Category Whether Stock/Non-Stock
    // _formKey.currentState.fields['Item Type'].reset();
    //_formKey.currentState.fields['Item Type'].reset();
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbResult = await dbHelper.fetchSaveLoginUser();
    try {
      var d_response = await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue', 'GetListDefaultValue',
          dbResult[0][DatabaseHelper.Tb3_col5_emailid],
          prefs.getString('token'));

      var d_JsonData = json.decode(d_response.body);
      var d_Json = d_JsonData['data'];
      var result_UDMRlyList = await Network().postDataWithAPIMList(
          'UDMAppList','UDMRlyList','',prefs.getString('token'));
      var UDMRlyList_body = json.decode(result_UDMRlyList.body);
      var rlyData = UDMRlyList_body['data'];
      var myList_UDMRlyList = [];
      myList_UDMRlyList.addAll(rlyData);

      var staticDataresponse = await Network.postDataWithAPIM('app/Common/UdmAppListStatic/V1.0.0/UdmAppListStatic', 'UdmAppListStatic', '',prefs.getString('token'));

      var staticData = json.decode(staticDataresponse.body);
      List staticDataJson = staticData['data'];

      var itemCatDataUrl = await Network().postDataWithAPIMList('UDMAppList','ItemCategory','',prefs.getString('token'));
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
        if (staticDataJson[i]['list_for'] == 'StockNonStock') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            stockNonStockList.add(all);
          });
        }
        if (staticDataJson[i]['list_for'] == 'StockAvailability') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            stockAvailability.add(all);
          });
        }
      }

      setState(() {
        itemtCategryaList.addAll(itemCatDataJson);

        dropdowndata_UDMUnitType.clear();
        dropdowndata_UDMDivision.clear();
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMRlyList = myList_UDMRlyList; //1
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        railway = d_Json[0]['org_zone'];
        department = d_Json[0]['org_subunit_dept'];
        division = d_Json[0]['admin_unit'].toString();
        unittype = d_Json[0]['org_unit_type'].toString();
        Future.delayed(Duration(milliseconds: 0), () async {
          def_fetchUnit(
              d_Json[0]['org_zone'],
              d_Json[0]['org_unit_type'].toString(),
              d_Json[0]['org_subunit_dept'].toString(),
              d_Json[0]['admin_unit'].toString(),
              d_Json[0]['ccode'].toString(),
              d_Json[0]['sub_cons_code'].toString());
        });
      });
      //_formKey.currentState!.fields['Railway']!.setValue(d_Json[0]['org_zone']);

      if (staticDataresponse.statusCode == 200) {
        //  _formKey.currentState.fields['Item Usage' ].setValue('-1');
        //  _formKey.currentState.fields['Item Type'].setValue('-1');
        //  _formKey.currentState.fields['Item Category'].setValue('-1');
        //  _formKey.currentState.fields['Whether Stock/Non-Stock'].setValue('-1');
      }
      //  _progressHide();
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

  Future<dynamic> def_depart_result(String depart) async {
    try {
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','',prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      var deptData = UDMDept_body['data'];
      var myList_UDMDept = [];
      myList_UDMDept.addAll(deptData);
      setState(() {
        dropdowndata_UDMDept = myList_UDMDept; //5
        if (depart != '') {
          _formKey.currentState!.fields['Department']!.setValue(depart);
        } else {
          _formKey.currentState!.fields['Department']!.setValue('-1');
        }
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

  Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart, String unitName, String depot, String userSubDep) async {
    try {
      var result_UDMUnitType=await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);

      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          //dropdowndata_UDMUnitType.add(getAll());
          //_formKey.currentState!.fields['Unit Type']!.setValue("-1");
          //def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        });
      } else {
        var unitData = UDMUnitType_body['data'];
        //myList_UDMUnitType.add(getAll());
        myList_UDMUnitType.addAll(unitData);
        setState(() {
          // dropdowndata_UDMUnitType.clear();
          // dropdowndata_UDMunitName.clear();
          // dropdowndata_UDMUserDepot.clear();
          // dropdowndata_UDMUserSubDepot.clear();
          dropdowndata_UDMUnitType = myList_UDMUnitType; //2
          print(myList_UDMUnitType);
        });
        if (value == '-1') {
          //def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        }
      }

      if (unit_data != "") {
        //_formKey.currentState!.fields['Unit Type']!.setValue(unit_data);
        //def_fetchunitName(value!, unit_data, unitName, depot, depart, userSubDep);
      } else {
        //_formKey.currentState!.fields['Unit Type']!.setValue("-1");
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
    }
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Value-Wise Stock',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF1565C0), // Deeper blue
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle back button
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle home button
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[50], // Light background

      body: Stack(
        children: [
          // Decorative top curved background
          Container(
            height: 80,
            width: double.infinity,
            color: Color(0xFF1565C0),
          ),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main form card
                Card(
                  elevation: 4,
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Main dropdown fields with improved styling
                        Consumer<ValueWiseProvider>(builder: (context, provider, child) {
                          if(provider.rlydatastatus == RailwayDataState.Busy) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                  child: Text(
                                    "Railway",
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      border: Border.all(color: Colors.grey, width: 1)),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${language.text('selectrly')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                                        Container(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          else {
                            return buildSearchableDropdown(
                              "Railway",
                              provider.railway,
                              provider.rlylistData,
                              (value) => provider.railway = value,
                              Icons.train,
                            );
                          }
                        }),

                        const SizedBox(height: 16),

                        Consumer<ValueWiseProvider>(builder: (context, provider, child){
                          if(provider.defaultDataState == DefaultDataState.Busy) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                  child: Text(
                                    "Unit Type",
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      border: Border.all(color: Colors.grey, width: 1)),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${language.text('selectrly')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
                                        Container(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          else {
                            return buildSearchableDropdown(
                                "Unit Type",
                                provider.unittype,
                                provider.unittypelistData,
                                (value) => provider.unittype = value,
                                Icons.business);
                          }
                        }),
                        const SizedBox(height: 16),
                        //
                        // buildSearchableDropdown("Unit Name", _unitName, unitNameOptions, (value) {
                        //   setState(() => _unitName = value);
                        // }, Icons.location_city),
                        // const SizedBox(height: 16),
                        //
                        // buildSearchableDropdown("Department", _department, departmentOptions, (value) {
                        //   setState(() => _department = value);
                        // }, Icons.work),
                        // const SizedBox(height: 16),
                        //
                        // buildSearchableDropdown("User Depot", _userDepot, depotOptions, (value) {
                        //   setState(() => _userDepot = value);
                        // }, Icons.warehouse),
                        // const SizedBox(height: 16),
                        //
                        // buildSearchableDropdown("User Sub Depot", _userSubDepot, subDepotOptions, (value) {
                        //   setState(() => _userSubDepot = value);
                        // }, Icons.store),
                        const SizedBox(height: 16),

                        // Modified Stock Value Criteria section with min-max layout
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              child: Text(
                                "Stock Value Criteria (in Rs.)",
                                style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade50,
                              ),
                              child: Row(
                                children: [
                                  // Minimum value field
                                  Expanded(
                                    child: TextFormField(
                                      //controller: _minValueController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Min Value",
                                        prefixIcon: Icon(Icons.currency_rupee, color: Color(0xFF1565C0)),
                                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  // Comparison operator in the middle
                                  // Container(
                                  //   width: 80,
                                  //   margin: EdgeInsets.symmetric(horizontal: 8),
                                  //   child: DropdownButtonFormField<String>(
                                  //     value: _comparisonType,
                                  //     decoration: InputDecoration(
                                  //       contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  //       border: OutlineInputBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //       ),
                                  //       isDense: true,
                                  //     ),
                                  //     items: [
                                  //       DropdownMenuItem(
                                  //         value: "greater",
                                  //         child: Row(
                                  //           mainAxisAlignment: MainAxisAlignment.center,
                                  //           children: [
                                  //             Icon(Icons.keyboard_arrow_right, size: 18, color: Color(0xFF1565C0)),
                                  //             Text(">", style: TextStyle(fontWeight: FontWeight.bold)),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       DropdownMenuItem(
                                  //         value: "less",
                                  //         child: Row(
                                  //           mainAxisAlignment: MainAxisAlignment.center,
                                  //           children: [
                                  //             Icon(Icons.keyboard_arrow_left, size: 18, color: Color(0xFF1565C0)),
                                  //             Text("<", style: TextStyle(fontWeight: FontWeight.bold)),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //     onChanged: (value) {
                                  //       setState(() {
                                  //         //_comparisonType = value!;
                                  //       });
                                  //     },
                                  //   ),
                                  // ),

                                  // Maximum value field
                                  Expanded(
                                    child: TextFormField(
                                      //controller: _maxValueController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Max Value",
                                        prefixIcon: Icon(Icons.currency_rupee, color: Color(0xFF1565C0)),
                                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 4.0),

                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Additional filters card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Additional Filters",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(height: 2),

                        // Display dynamically added fields if they exist
                        // if (_hasItemType) ...[
                        //   buildSearchableDropdown("Item Type", _itemType, itemTypeOptions, (value) {
                        //     setState(() => _itemType = value);
                        //   }, Icons.category),
                        //   const SizedBox(height: 16),
                        // ],
                        //
                        // if (_hasItemUsage) ...[
                        //   buildSearchableDropdown("Item Usage", _itemUsage, itemUsageOptions, (value) {
                        //     setState(() => _itemUsage = value);
                        //   }, Icons.handyman),
                        //   const SizedBox(height: 16),
                        // ],
                        //
                        // if (_hasItemCategory) ...[
                        //   buildSearchableDropdown("Item Category", _itemCategory, itemCategoryOptions, (value) {
                        //     setState(() => _itemCategory = value);
                        //   }, Icons.label),
                        //   const SizedBox(height: 16),
                        // ],
                        //
                        // if (_hasStockType) ...[
                        //   buildSearchableDropdown("Stock/Non-Stock", _stockType, stockTypeOptions, (value) {
                        //     setState(() => _stockType = value);
                        //   }, Icons.inventory_2),
                        //   const SizedBox(height: 16),
                        // ],

                        // Dynamic field buttons with improved styling

                        const SizedBox(height: 12),

                        // Wrap(
                        //   spacing: 10,
                        //   runSpacing: 10,
                        //   children: [
                        //     FilterChip(
                        //       avatar: CircleAvatar(
                        //         backgroundColor: _hasItemType ? Colors.grey : Color(0xFF1565C0),
                        //         child: Icon(Icons.add, size: 18, color: Colors.white),
                        //       ),
                        //       label: Text("Item Type"),
                        //       labelStyle: TextStyle(
                        //         color: _hasItemType ? Colors.grey : Color(0xFF1565C0),
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //       selected: _hasItemType,
                        //       selectedColor: Colors.blue[100],
                        //       backgroundColor: Colors.grey[100],
                        //       onSelected: _hasItemType ? null : (bool selected) {
                        //         if (selected) {
                        //           setState(() {
                        //             _hasItemType = true;
                        //           });
                        //         }
                        //       },
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(
                        //           color: _hasItemType ? Colors.grey.shade300 : Color(0xFF1565C0).withOpacity(0.5),
                        //         ),
                        //       ),
                        //     ),
                        //
                        //     FilterChip(
                        //       avatar: CircleAvatar(
                        //         backgroundColor: _hasItemUsage ? Colors.grey : Color(0xFF1565C0),
                        //         child: Icon(Icons.add, size: 18, color: Colors.white),
                        //       ),
                        //       label: Text("Item Usage"),
                        //       labelStyle: TextStyle(
                        //         color: _hasItemUsage ? Colors.grey : Color(0xFF1565C0),
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //       selected: _hasItemUsage,
                        //       selectedColor: Colors.blue[100],
                        //       backgroundColor: Colors.grey[100],
                        //       onSelected: _hasItemUsage ? null : (bool selected) {
                        //         if (selected) {
                        //           setState(() {
                        //             _hasItemUsage = true;
                        //           });
                        //         }
                        //       },
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(
                        //           color: _hasItemUsage ? Colors.grey.shade300 : Color(0xFF1565C0).withOpacity(0.5),
                        //         ),
                        //       ),
                        //     ),
                        //
                        //     FilterChip(
                        //       avatar: CircleAvatar(
                        //         backgroundColor: _hasItemCategory ? Colors.grey : Color(0xFF1565C0),
                        //         child: Icon(Icons.add, size: 18, color: Colors.white),
                        //       ),
                        //       label: Text("Item Category"),
                        //       labelStyle: TextStyle(
                        //         color: _hasItemCategory ? Colors.grey : Color(0xFF1565C0),
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //       selected: _hasItemCategory,
                        //       selectedColor: Colors.blue[100],
                        //       backgroundColor: Colors.grey[100],
                        //       onSelected: _hasItemCategory ? null : (bool selected) {
                        //         if (selected) {
                        //           setState(() {
                        //             _hasItemCategory = true;
                        //           });
                        //         }
                        //       },
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(
                        //           color: _hasItemCategory ? Colors.grey.shade300 : Color(0xFF1565C0).withOpacity(0.5),
                        //         ),
                        //       ),
                        //     ),
                        //
                        //     FilterChip(
                        //       avatar: CircleAvatar(
                        //         backgroundColor: _hasStockType ? Colors.grey : Color(0xFF1565C0),
                        //         child: Icon(Icons.add, size: 18, color: Colors.white),
                        //       ),
                        //       label: Text("Stock/Non-Stock"),
                        //       labelStyle: TextStyle(
                        //         color: _hasStockType ? Colors.grey : Color(0xFF1565C0),
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //       selected: _hasStockType,
                        //       selectedColor: Colors.blue[100],
                        //       backgroundColor: Colors.grey[100],
                        //       onSelected: _hasStockType ? null : (bool selected) {
                        //         if (selected) {
                        //           setState(() {
                        //             _hasStockType = true;
                        //           });
                        //         }
                        //       },
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20),
                        //         side: BorderSide(
                        //           color: _hasStockType ? Colors.grey.shade300 : Color(0xFF1565C0).withOpacity(0.5),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons with improved styling
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Get Details action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              "Get Details",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Reset action
                          setState(() {
                            railway = "IREPS-TESTING";
                            unittype = "Zonal HQ / PU HQ";
                            division= "EPS/UD";
                            department = "Mechanical";
                            userDepot = "36640-SR. SECTION ENGINEER-I/PS/NEW DELHI";
                            userSubDepot = "00-SSE/EPS/UD";
                            // _comparisonType = "greater";
                            // _minValueController.text = "10000";
                            // _maxValueController.clear();
                            //
                            // // Reset dynamic fields
                            // _hasItemType = false;
                            // _hasItemUsage = false;
                            // _hasItemCategory = false;
                            // _hasStockType = false;
                            //
                            // // Reset their values too
                            // _itemType = "Consumable";
                            // _itemUsage = "Regular";
                            // _itemCategory = "A";
                            // _stockType = "Stock";
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Color(0xFF1565C0), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, color: Color(0xFF1565C0)),
                            const SizedBox(width: 8),
                            Text(
                              "Reset",
                              style: TextStyle(
                                color: Color(0xFF1565C0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // Build searchable dropdown with improved styling
  Widget buildSearchableDropdown(String label, String value, List<dynamic> options, Function(String) onChanged, IconData iconData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return SearchableDropdownModal(
                  title: label,
                  options: options,
                  onSelect: onChanged,
                  currentValue: value,
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Icon(iconData, color: Color(0xFF1565C0), size: 22),
                const SizedBox(width: 12),
                Consumer<ValueWiseProvider>(builder: (context, provider, child){
                   return Expanded(
                     child: Text(
                       label == "Railway" ? provider.railway : label == "Unit Type" ? provider.unittype : provider.unitname,
                       style: TextStyle(fontSize: 16),
                       overflow: TextOverflow.ellipsis,
                     ),
                   );
                }),
                Icon(Icons.arrow_drop_down, color: Color(0xFF1565C0)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Searchable dropdown modal with improved styling
class SearchableDropdownModal extends StatefulWidget {
  final String title;
  final List<dynamic> options;
  final Function(String) onSelect;
  final String currentValue;

  const SearchableDropdownModal({
    Key? key,
    required this.title,
    required this.options,
    required this.onSelect,
    required this.currentValue,
  }) : super(key: key);

  @override
  _SearchableDropdownModalState createState() => _SearchableDropdownModalState();
}

class _SearchableDropdownModalState extends State<SearchableDropdownModal> {
  late TextEditingController _searchController;
  late List<dynamic> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredOptions = List.from(widget.options);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOptions(String query) {
    setState(() {
      _filteredOptions = widget.options.where((option) => option.value != null && option.value!.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select ${widget.title}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1565C0)),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey[700]),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Search field
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search ${widget.title.toLowerCase()}...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1565C0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onChanged: _filterOptions,
            ),
          ),
          const SizedBox(height: 10),
          // Options list
          Expanded(
            child: _filteredOptions.isEmpty ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No results found",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ) : ListView.separated(
              itemCount: _filteredOptions.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                final option = _filteredOptions[index];
                final isSelected = option == widget.currentValue;

                return ListTile(
                  title: Text(
                    option.value!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  tileColor: isSelected ? Color(0xFF1565C0).withOpacity(0.1) : null,
                  leading: isSelected
                      ? Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF1565C0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 16),
                  ) : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () {
                    //widget.onSelect(option.value!);
                    Provider.of<ValueWiseProvider>(context, listen: false).railway = option.value!;
                    Provider.of<ValueWiseProvider>(context, listen: false).setRlwStatusState(RailwayDataState.Finished);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

