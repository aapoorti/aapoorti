// import 'dart:convert';
// import 'dart:io';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_app/udm/helpers/api.dart';
// import 'package:flutter_app/udm/helpers/database_helper.dart';
// import 'package:flutter_app/udm/helpers/shared_data.dart';
// import 'package:flutter_app/udm/localization/english.dart';
// import 'package:flutter_app/udm/providers/SumaryStockProvider.dart';
//
// import 'package:flutter_app/udm/providers/languageProvider.dart';
// import 'package:flutter_app/udm/screens/sumarystock_list_screen.dart';
// import 'package:flutter_app/udm/screens/summaryAction.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class StockSummarySideDrawer extends StatefulWidget {
//   static const routeName = "/stock-Summary-drawer";
//   @override
//   _StockSummarySideDrawerState createState() => _StockSummarySideDrawerState();
// }
//
// class _StockSummarySideDrawerState extends State<StockSummarySideDrawer> {
//   double? sheetLeft;
//   bool isExpanded = true;
//   late SummaryStockProvider itemListProvider;
//   String? railway;
//   String? unittype;
//   String? department;
//   String? userDepot;
//   String? userSubDepot;
//   String? itemType;
//   String? itemUsage;
//   String? itemCategory;
//   String? stockNonStk;
//   String? dropDownValue;
//   String? stockAvl, stkReport;
//   String? unitName;
//
//   final _formKey = GlobalKey<FormBuilderState>();
//
//   List dropdowndata_UDMRlyList = [];
//   List dropdowndata_UDMUnitType = [];
//   List dropdowndata_UDMunitName = [];
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
//   String? itemUnit = '-1', itemCatValue = '-1', sns = '-1';
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
//         title: Text(Provider.of<LanguageProvider>(context).text('stockSummary'), style: TextStyle(color: Colors.white)),
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
//                 _formKey.currentState!.fields['Unit Name']!.setValue(null);
//                 _formKey.currentState!.fields['Unit Type']!.setValue(null);
//                 _formKey.currentState!.fields['Department']!.setValue(null);
//                 //_formKey.currentState!.fields['User Depot']!.setValue(null);
//                 _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//                 setState(() {
//                   railway = newValue;
//                   dropdowndata_UDMUnitType.clear();
//                   dropdowndata_UDMunitName.clear();
//                   dropdowndata_UDMUserDepot.clear();
//                   dropdowndata_UDMUserSubDepot.clear();
//                   dropdowndata_UDMUserSubDepot.add(_all());
//
//                   dropdowndata_UDMUnitType.add(_all());
//                   dropdowndata_UDMunitName.add(_all());
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
//             //     unitType),
//             SizedBox(height: 10),
//             FormBuilderDropdown(
//               name: englishText['unitName'] ?? 'unitName',
//               focusColor: Colors.transparent,
//               decoration: InputDecoration(
//                 labelText: language.text('unitName'),
//                 contentPadding: EdgeInsetsDirectional.all(10),
//                 border: const OutlineInputBorder(),
//               ),
//               initialValue: dropdowndata_UDMunitName.any((item) => item['intcode'].toString() == unitName) ? unitName : null,
//               //initialValue: division,
//               //allowClear: false,
//               //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
//               //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
//               items: dropdowndata_UDMunitName.map((item) {
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
//                   unitName = newValue;
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
//             //     dropdowndata_UDMunitName,
//             //     unitName),
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
//                   def_fetchDepot(railway, department, unittype, unitName, '', '');
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
//               selectedItem: userDepotValue == "-1" || userDepotValue == "All" ? "All" : userDepotValue,
//               popupProps: PopupProps.menu(
//                 showSearchBox: true,
//                 showSelectedItems: true,
//                   emptyBuilder: (ctx, val) {
//                     return Align(
//                       alignment: Alignment.topCenter,
//                       child: Text('No Data Found for $val'),
//                     );
//                   },
//                 searchFieldProps: TextFieldProps(
//                   decoration: InputDecoration(
//                     hintText: '${language.text('select')} ${language.text('userDepot')}',
//                     contentPadding: EdgeInsetsDirectional.all(10),
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//                 menuProps: MenuProps(shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ))
//               ),
//               decoratorProps: DropDownDecoratorProps(
//                  decoration: InputDecoration(
//                    labelText: language.text('userDepot'),
//                    hintText: '${language.text('select')} ${language.text('userDepot')}',
//                    alignLabelWithHint: true,
//                    contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, bottom: 5.0, top: 5.0),
//                    border: const OutlineInputBorder(),
//                  ),
//               ),
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
//                 print("new value of user depot $newValue");
//                 _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//                 setState(() {
//                   userDepotValue = newValue.toString();
//                   var depot = userDepotValue.split('-');
//                   def_fetchSubDepot(railway, depot[0], '');
//                 });
//               },
//             ),
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
//                       if(item['intcode'].toString() == '-1') {
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
//                   stockDropdownStatic('itemType', 'Select Item Type', itemTypeList, itemType, name: 'Item Type'),
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
//                         return 'field is required';
//                       }
//                       return null; // Return null if the value is valid
//                     },
//                     items: itemtCategryaList.map((item) {
//                       return DropdownMenuItem(
//                           child: Text(() {
//                             if (item['intcode'].toString() == '-1') {
//                               return item['value'];
//                             } else {
//                               return item['intcode'].toString() + '-' + item['value'];
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
//                           if(itemTypeVis) {
//                             itemType = '-1';
//                           }
//                         });
//                       },
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
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
//                             itemListProvider = Provider.of<SummaryStockProvider>(context, listen: false);
//                             Navigator.of(context).pushNamed(SummaryStockListScreen.routeName, arguments: {
//                               'unitType': unittype,
//                               'unitname' : _formKey.currentState!.fields['Unit Name']!.value,
//                               'department' : _formKey.currentState!.fields['Department']!.value,
//                               'userdepot' : '-1',
//                               'usersubdepot' : _formKey.currentState!.fields['User Sub Depot']!.value
//                             },);
//                             if(!itemUsageVis) {
//                               itemUsage = '-1';
//                             } else {
//                               itemUsage = _formKey.currentState!.fields['Item Usage']!.value;
//                             }
//                             if (!itemTypeVis) {
//                               itemUnit = '-1';
//                             } else {
//                               itemUnit = _formKey.currentState!.fields['Item Type']!.value;
//                             }
//                             if (!stkVis) {
//                               sns = '-1';
//                             } else {
//                               sns = _formKey.currentState!.fields['Whether Stock/Non-Stock']!.value;
//                             }
//                             if(!itemCatVis) {
//                               itemCatValue = '-1';
//                             } else {
//                               itemCatValue = _formKey.currentState!.fields['Item Category']!.value;
//                             }
//                             itemListProvider.fetchAndStoreItemsListwithdata(
//                                 railway,
//                                 unittype,
//                                 _formKey.currentState!.fields['Unit Name']!.value,
//                                 _formKey.currentState!.fields['Department']!.value,
//                                 "-1",
//                                 _formKey.currentState!.fields['User Sub Depot']!.value,
//                                 itemUsage,
//                                 itemUnit,
//                                 itemCatValue,
//                                 sns,
//                                 context);
//                           }
//                           else{
//                             itemListProvider = Provider.of<SummaryStockProvider>(context, listen: false);
//                             var depot = userDepotValue.split('-');
//                             Navigator.of(context).pushNamed(SummaryStockListScreen.routeName, arguments: {
//                               'unitType': unittype,
//                               'unitname' : _formKey.currentState!.fields['Unit Name']!.value,
//                               'department' : _formKey.currentState!.fields['Department']!.value,
//                               'userdepot' : depot[0],
//                               'usersubdepot' : _formKey.currentState!.fields['User Sub Depot']!.value
//                             },);
//                             if(!itemUsageVis) {
//                               itemUsage = '-1';
//                             } else {
//                               itemUsage = _formKey.currentState!.fields['Item Usage']!.value;
//                             }
//                             if(!itemTypeVis) {
//                               itemUnit = '-1';
//                             } else {
//                               itemUnit = _formKey.currentState!.fields['Item Type']!.value;
//                             }
//                             if(!stkVis) {
//                               sns = '-1';
//                             } else {
//                               sns = _formKey.currentState!.fields['Whether Stock/Non-Stock']!.value;
//                             }
//                             if(!itemCatVis) {
//                               itemCatValue = '-1';
//                             } else {
//                               itemCatValue = _formKey.currentState!.fields['Item Category']!.value;
//                             }
//                             itemListProvider.fetchAndStoreItemsListwithdata(
//                                 railway,
//                                 unittype,
//                                 _formKey.currentState!.fields['Unit Name']!.value,
//                                 _formKey.currentState!.fields['Department']!.value,
//                                 depot[0],
//                                 _formKey.currentState!.fields['User Sub Depot']!.value,
//                                 itemUsage,
//                                 itemUnit,
//                                 itemCatValue,
//                                 sns,
//                                 context);
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
//                         itemCatVis = false;
//                         stkVis = false;
//                         itemTypeButtonVis = true;
//                         itemUsageBtnVis = true;
//                         itemCatBtnVis = true;
//                         stkBtnVis = true;
//                         _formKey.currentState!.reset();
//                         default_data();
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
//             SizedBox(height: 15),
//             Container(
//               width: 160,
//               height: 50,
//               child: OutlinedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.resolveWith((color) => Color(0xffffff00)),
//                   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0))),
//                   elevation: MaterialStateProperty.all(7.0),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     if(userDepotValue.toString() == "All" || userDepotValue.toString() == "-1"  || userDepotValue == null){
//                       if(!itemUsageVis) {
//                         itemUsage = '-1';
//                       } else {
//                         itemUsage = _formKey.currentState!.fields['Item Usage']!.value;
//                       }
//                       if (!itemTypeVis) {
//                         itemUnit = '-1';
//                       } else {
//                         itemUnit = _formKey.currentState!.fields['Item Type']!.value;
//                       }
//                       if (!stkVis) {
//                         sns = '-1';
//                       } else {
//                         sns = _formKey.currentState!.fields['Whether Stock/Non-Stock']!.value;
//                       }
//                       if(!itemCatVis) {
//                         itemCatValue = '-1';
//                       } else {
//                         itemCatValue = _formKey.currentState!.fields['Item Category']!.value;
//                       }
//                       Future.delayed(
//                         Duration.zero, () {
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => SummaryDetails(
//                             railway,
//                             "-1",
//                             _formKey.currentState!.fields['User Sub Depot']!.value,
//                             unittype,
//                             _formKey.currentState!.fields['Unit Name']!.value,
//                             _formKey.currentState!.fields['Department']!.value,
//                             itemUsage,
//                             itemUnit,
//                             itemCatValue,
//                             sns),
//                         ),
//                         );
//                       },
//                       );
//                     }
//                     else{
//                       var depot = userDepotValue.split('-');
//                       if(!itemUsageVis) {
//                         itemUsage = '-1';
//                       } else {
//                         itemUsage = _formKey.currentState!.fields['Item Usage']!.value;
//                       }
//                       if(!itemTypeVis) {
//                         itemUnit = '-1';
//                       } else {
//                         itemUnit = _formKey.currentState!.fields['Item Type']!.value;
//                       }
//                       if (!stkVis) {
//                         sns = '-1';
//                       } else {
//                         sns = _formKey.currentState!.fields['Whether Stock/Non-Stock']!.value;
//                       }
//                       if(!itemCatVis) {
//                         itemCatValue = '-1';
//                       } else {
//                         itemCatValue = _formKey.currentState!.fields['Item Category']!.value;
//                       }
//                       Future.delayed(
//                         Duration.zero, () {
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => SummaryDetails(
//                             railway,
//                             depot[0],
//                             _formKey.currentState!.fields['User Sub Depot']!.value,
//                             unittype,
//                             _formKey.currentState!.fields['Unit Name']!.value,
//                             _formKey.currentState!.fields['Department']!.value,
//                             itemUsage,
//                             itemUnit,
//                             itemCatValue,
//                             sns),
//                         ),
//                         );
//                       },
//                       );
//                     }},
//                   );
//                 },
//                 child: Text(language.text('summary'),
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     )),
//               ),
//             ),
//             SizedBox(height: 10),
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
//           _formKey.currentState!.fields['Unit Name']!.setValue(null);
//           _formKey.currentState!.fields['Unit Type']!.setValue(null);
//           _formKey.currentState!.fields['Department']!.setValue(null);
//           //_formKey.currentState!.fields['User Depot']!.setValue(null);
//           _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//           setState(() {
//             railway = newValue;
//             dropdowndata_UDMUnitType.clear();
//             dropdowndata_UDMunitName.clear();
//             dropdowndata_UDMUserDepot.clear();
//             dropdowndata_UDMUserSubDepot.clear();
//             dropdowndata_UDMUserSubDepot.add(_all());
//
//             dropdowndata_UDMUnitType.add(_all());
//             dropdowndata_UDMunitName.add(_all());
//             dropdowndata_UDMUserDepot.add(_all());
//             _formKey.currentState!.fields['Unit Name']!.setValue('-1');
//             _formKey.currentState!.fields['Unit Type']!.setValue('-1');
//             _formKey.currentState!.fields['Department']!.setValue('-1');
//             userDepotValue = "-1";
//             //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//             _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
//             unittype = "-1";
//           });
//           def_fetchUnit(railway, '', '', '', '', '');
//         }
//         else if(name == 'Unit Type') {
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
//         }
//         else if (name == 'Unit Name') {
//           _formKey.currentState!.fields['Department']!.setValue(null);
//           //_formKey.currentState!.fields['User Depot']!.setValue(null);
//           _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//           setState(() {
//             unitName = newValue;
//
//             itemType = null;
//             itemUsage = null;
//             itemCategory = null;
//             stockNonStk = null;
//             stockAvl = null;
//           });
//         }
//         else if (name == 'Department') {
//           //_formKey.currentState!.fields['User Depot']!.setValue(null);
//           _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
//           setState(() {
//             department = newValue;
//             itemType = null;
//             itemUsage = null;
//             itemCategory = null;
//             stockNonStk = null;
//             stockAvl = null;
//             def_fetchDepot(railway, department, unittype, unitName, '', '');
//           });
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
//           print("onchange value here $newValue");
//           initValue = newValue;
//         });
//       },
//     );
//   }
//
//   void reseteValues() {
//     dropdowndata_UDMUnitType.clear();
//     dropdowndata_UDMunitName.clear();
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
//     Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
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
//
//         if (staticDataJson[i]['list_for'] == 'StockNonStock') {
//           setState(() {
//             var all = {
//               'intcode': staticDataJson[i]['key'],
//               'value': staticDataJson[i]['value'],
//             };
//             stockNonStockList.add(all);
//           });
//         }
//       }
//
//       setState(() {
//         itemtCategryaList.addAll(itemCatDataJson);
//
//         dropdowndata_UDMUnitType.clear();
//         dropdowndata_UDMunitName.clear();
//         dropdowndata_UDMUserDepot.clear();
//         dropdowndata_UDMRlyList = myList_UDMRlyList; //1
//         dropdowndata_UDMRlyList
//             .sort((a, b) => a['value'].compareTo(b['value'])); //1
//         def_depart_result(d_Json[0]['org_subunit_dept'].toString());
//         railway = d_Json[0]['org_zone'];
//         department = d_Json[0]['org_subunit_dept'];
//         unitName = d_Json[0]['admin_unit'].toString();
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
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
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
//         });
//         if (value == '-1') {
//           def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
//         }
//       }
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
//   Future<dynamic> def_fetchunitName(String rai, String unit, String unitName_name, String depot, String depart, String userSubDep) async {
//     try {
//       var result_UDMunitName=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai+"~"+unit,prefs.getString('token'));
//       var UDMunitName_body = json.decode(result_UDMunitName.body);
//       var myList_UDMunitName = [];
//       if (UDMunitName_body['status'] != 'OK') {
//         setState(() {
//           dropdowndata_UDMunitName.add(getAll());
//           _formKey.currentState!.fields['Unit Name']!.setValue('-1');
//           def_fetchDepot(rai, depart.toString(), unit, unitName_name, depot, userSubDep);
//         });
//         // showInSnackBar("please select other value");
//       } else {
//         var divisionData = UDMunitName_body['data'];
//         myList_UDMunitName.add(getAll());
//         myList_UDMunitName.addAll(divisionData);
//         setState(() {
//           //dropdowndata_UDMUserDepot.clear();
//           //dropdowndata_UDMUserSubDepot.clear();
//           dropdowndata_UDMunitName = myList_UDMunitName; //2
//         });
//         if (unit == '-1') {
//           _formKey.currentState!.fields['Department']!.setValue('-1');
//           def_fetchDepot(
//               rai, depart.toString(), unit, unitName_name, depot, userSubDep);
//         }
//       }
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
//         print("stock summary user depot11");
//         var all = {
//           'intcode': '-1',
//           'value': "All",
//         };
//         dropdowndata_UDMUserDepot.add(all);
//         userDepotValue = "-1";
//         //_formKey.currentState!.fields['User Depot']!.setValue('-1');
//         def_fetchSubDepot(rai, depot_id, userSubDep);
//       }
//       else {
//         print("stock summary user depot22");
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
//                 userDepotValue = "-1";
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
//         var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UserSubDepot' , rai! + "~" + depot_id!,prefs.getString('token'));
//         var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
//         var myList_UDMUserDepot = [];
//         if(UDMUserSubDepot_body['status'] != 'OK') {
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

//---------------------New UI Screen-----------------------
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/providers/SumaryStockProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/nonMovingProvider.dart';
import 'package:flutter_app/udm/screens/nonMoving_list_screen.dart';
import 'package:flutter_app/udm/screens/sumarystock_list_screen.dart';
import 'package:flutter_app/udm/screens/summaryAction.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockSummarySideDrawer extends StatefulWidget {
  static const routeName = "/stock-Summary-drawer";

  @override
  State<StockSummarySideDrawer> createState() => _StockSummarySideDrawerState();
}

class _StockSummarySideDrawerState extends State<StockSummarySideDrawer>
    with SingleTickerProviderStateMixin {
  // Selected month value
  int _selectedMonth = 1;

  // Track expanded filter sections
  final Map<String, bool> _expandedFilters = {
    'Item Type': false,
    'Item Usage': false,
    'Item Category': false,
    'Stock/Non-Stock': false,
  };

  late AnimationController _animationController;
  late Map<String, Animation<double>> _animations;

  late SummaryStockProvider itemListProvider;

  String? railwayCode;
  String? railwayName = "All";
  String? unittypeName = "All";
  String? unittypeCode;
  String? unitname = "All";
  String? unitnameCode;
  String? deptName = "All";
  String? deptCode;
  String? userDepotName = "All";
  String? userDepotCode;
  String? userSubDepotName = "All";
  String? userSubDepotCode;

  String? itemType = "-1";
  String? itemUsage = "-1";
  String? itemCategory = "-1";
  String? stockNonStk = "-1";

  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMUnitType = [];
  List dropdowndata_UDMDivision = [];
  List dropdowndata_UDMDept = [];
  List dropdowndata_UDMUserDepot = [];
  List dropdowndata_UDMUserSubDepot = [];

  //Static Data List
  List itemTypeList = [];
  List itemUsageList = [];
  List itemtCategryaList = [];
  List stockNonStockList = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create animations for each filter
    _animations = {
      for (var filter in _expandedFilters.keys)
        filter: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
    };

    default_data();
  }

  late SharedPreferences prefs;
  @override
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFilter(String filterName) {
    setState(() {
      // Toggle the selected filter
      _expandedFilters[filterName] = !_expandedFilters[filterName]!;

      // If any filter is expanded, forward the animation, otherwise reverse it
      if (_expandedFilters.values.any((isExpanded) => isExpanded)) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  // Increase the month value (with max limit of 12)
  void _incrementMonth() {
    setState(() {
      if (_selectedMonth < 12) {
        _selectedMonth++;
      }
    });
  }

  // Decrease the month value (with min limit of 1)
  void _decrementMonth() {
    setState(() {
      if (_selectedMonth > 1) {
        _selectedMonth--;
      }
    });
  }

  Future<dynamic> default_data() async {
    Future.delayed(
        Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    itemTypeList.clear();
    itemUsageList.clear();
    itemtCategryaList.clear();
    stockNonStockList.clear();
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

        if (staticDataJson[i]['list_for'] == 'StockNonStock') {
          setState(() {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            stockNonStockList.add(all);
          });
        }
      }

      setState(() {
        itemtCategryaList.addAll(itemCatDataJson);

        dropdowndata_UDMUnitType.clear();
        dropdowndata_UDMDivision.clear();
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMRlyList = myList_UDMRlyList;
        dropdowndata_UDMRlyList
            .sort((a, b) => a['value'].compareTo(b['value']));
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        railwayCode = d_Json[0]['org_zone'];
        railwayName = d_Json[0]['account_name'];
        deptCode = d_Json[0]['org_subunit_dept'];
        deptName = d_Json[0]['dept_name'];
        unitnameCode = d_Json[0]['admin_unit'].toString();
        unitname = d_Json[0]['unit_name'].toString();
        unittypeCode = d_Json[0]['org_unit_type'].toString();
        unittypeName = d_Json[0]['unit_type'].toString();
        userDepotName =
            "${d_Json[0]['ccode'].toString()}-${d_Json[0]['cname'].toString()}";
        userDepotCode = d_Json[0]['ccode'].toString();
        userSubDepotCode = d_Json[0]['sub_cons_code'].toString();
        userSubDepotName =
            "${d_Json[0]['sub_cons_code'].toString()}-${d_Json[0]['sub_user_depot'].toString()}";
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
      var result_UDMDept = await Network().postDataWithAPIMList(
          'UDMAppList', 'UDMDept', '', prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      var deptData = UDMDept_body['data'];
      var myList_UDMDept = [];
      myList_UDMDept.addAll(deptData);
      setState(() {
        dropdowndata_UDMDept = myList_UDMDept;
        if (depart != '') {
          deptCode = depart;
        } else {
          deptCode = '-1';
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

  Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart,
      String unitName, String depot, String userSubDep) async {
    try {
      var result_UDMUnitType = await Network().postDataWithAPIMList(
          'UDMAppList', 'UDMUnitType', value, prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);

      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMUnitType.add(getAll());
          unittypeCode = '-1';
          def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        });
      } else {
        var unitData = UDMUnitType_body['data'];
        myList_UDMUnitType.add(getAll());
        myList_UDMUnitType.addAll(unitData);
        setState(() {
          dropdowndata_UDMUnitType = myList_UDMUnitType; //2
        });
        if (value == '-1') {
          def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        }
      }

      if (unit_data != "") {
        unittypeCode = unit_data;
        def_fetchunitName(
            value!, unit_data, unitName, depot, depart, userSubDep);
      } else {
        unittypeCode = '-1';
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

  Future<dynamic> def_fetchunitName(
      String rai,
      String unit,
      String unitName_name,
      String depot,
      String depart,
      String userSubDep) async {
    try {
      var result_UDMunitName = await Network().postDataWithAPIMList(
          'UDMAppList', 'UnitName', rai + "~" + unit, prefs.getString('token'));
      var UDMunitName_body = json.decode(result_UDMunitName.body);
      var myList_UDMunitName = [];
      if (UDMunitName_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMDivision.add(getAll());
          unitnameCode = '-1';
          def_fetchDepot(
              rai, depart.toString(), unit, unitName_name, depot, userSubDep);
        });
        // showInSnackBar("please select other value");
      } else {
        var divisionData = UDMunitName_body['data'];
        myList_UDMunitName.add(getAll());
        myList_UDMunitName.addAll(divisionData);
        setState(() {
          //dropdowndata_UDMUserDepot.clear();
          //dropdowndata_UDMUserSubDepot.clear();
          dropdowndata_UDMDivision = myList_UDMunitName; //2
        });
        if (unit == '-1') {
          deptCode = "-1";
          def_fetchDepot(
              rai, depart.toString(), unit, unitName_name, depot, userSubDep);
        }
      }
      if (unitName_name != "") {
        unitnameCode = unitName_name;
        def_fetchDepot(
            rai, depart.toString(), unit, unitName_name, depot, userSubDep);
      } else {
        unittypeCode = '-1';
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

  Future<dynamic> def_fetchDepot(String? rai, String? depart, String? unit_typ,
      String? Unit_Name, String depot_id, String userSubDep) async {
    try {
      dropdowndata_UDMUserDepot.clear();
      if (depot_id == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserDepot.add(all);
        userDepotCode = "-1";
        //_formKey.currentState!.fields['User Depot']!.setValue('-1');
        def_fetchSubDepot(rai, depot_id, userSubDep);
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList(
            'UDMAppList',
            'UDMUserDepot',
            rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!,
            prefs.getString('token'));
        var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
        var myList_UDMUserDepot = [];
        if (UDMUserDepot_body['status'] != 'OK') {
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserDepot.add(all);
            userDepotCode = "-1";
            def_fetchSubDepot(rai, depot_id, userSubDep);
          });
        } else {
          var depoData = UDMUserDepot_body['data'];
          dropdowndata_UDMUserSubDepot.clear();
          myList_UDMUserDepot.addAll(depoData);
          setState(() {
            dropdowndata_UDMUserDepot = myList_UDMUserDepot;
            if (depot_id != "") {
              userDepotCode = depot_id;
              dropdowndata_UDMUserDepot.forEach((item) {
                if (item['intcode']
                    .toString()
                    .contains(depot_id.toLowerCase())) {
                  userDepotName =
                      item['intcode'].toString() + '-' + item['value'];
                }
              });
              def_fetchSubDepot(rai, depot_id, userSubDep);
            } else {
              userDepotCode = "-1";
            }
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
    }
  }

  Future<dynamic> def_fetchSubDepot(
      String? rai, String? depot_id, String userSDepo) async {
    debugPrint("railway $rai  depot $depot_id  usersubdept $userSDepo ");
    try {
      dropdowndata_UDMUserSubDepot.clear();
      if (userSDepo == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserSubDepot.add(all);
        userDepotCode = '-1';
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
            userSubDepotCode = '-1';
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
            dropdowndata_UDMUserSubDepot = myList_UDMUserDepot; //2
            if (userSDepo != "") {
              userSubDepotCode = userSDepo;
            } else {
              userSubDepotCode = '-1';
            }
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

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AapoortiConstants.primary,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          splashRadius: 30,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.of(context).pop();
              //Feedback.forTap(context);
            },
          ),
        ],
        title: Text(Provider.of<LanguageProvider>(context).text('stockSummary'),
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                context,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Railway',
                          value: railwayName!,
                          items: dropdowndata_UDMRlyList,
                          onChanged: (value) {
                            dropdowndata_UDMRlyList.forEach((element) {
                              if (element['value'].toString().trim() ==
                                  value.toString().trim()) {
                                setState(() {
                                  railwayName = value!;
                                  railwayCode =
                                      element['intcode'].toString().trim();

                                  unittypeName = "All";
                                  unittypeCode = "-1";
                                  unitname = "All";
                                  unitnameCode = "-1";
                                  deptName = "All";
                                  deptCode = "-1";
                                  userDepotName = "All";
                                  userDepotCode = "-1";
                                  userSubDepotName = "All";
                                  userSubDepotCode = "-1";

                                  dropdowndata_UDMDivision.clear();
                                  dropdowndata_UDMUnitType.clear();
                                  dropdowndata_UDMUserDepot.clear();
                                  dropdowndata_UDMUserSubDepot.clear();

                                  dropdowndata_UDMDivision.add(getAll());
                                  dropdowndata_UDMUnitType.add(getAll());
                                  dropdowndata_UDMUserDepot.add(getAll());
                                  dropdowndata_UDMUserSubDepot.add(getAll());
                                });
                              }
                            });
                            def_fetchUnit(railwayCode, '', '', '', '', '');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Unit Type',
                          items: dropdowndata_UDMUnitType,
                          value: unittypeName!,
                          onChanged: (value) {
                            dropdowndata_UDMUnitType.forEach((element) {
                              if (element['value'].toString().trim() ==
                                  value.toString().trim()) {
                                setState(() {
                                  unittypeName = value!;
                                  unittypeCode =
                                      element['intcode'].toString().trim();
                                });
                              }
                            });
                            def_fetchunitName(
                                railwayCode!, unittypeCode!, '', '', '', '');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Unit Name',
                          value: unitname!,
                          items: dropdowndata_UDMDivision,
                          onChanged: (value) {
                            dropdowndata_UDMDivision.forEach((element) {
                              if (element['value'].toString().trim() ==
                                  value.toString().trim()) {
                                setState(() {
                                  unitname = value!;
                                  unitnameCode =
                                      element['intcode'].toString().trim();
                                });
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Department',
                          value: deptName!,
                          items: dropdowndata_UDMDept,
                          onChanged: (value) {
                            dropdowndata_UDMDept.forEach((element) {
                              if (element['value'].toString().trim() ==
                                  value.toString().trim()) {
                                setState(() {
                                  deptName = value!;
                                  deptCode =
                                      element['intcode'].toString().trim();
                                });
                              }
                            });
                            def_fetchDepot(railwayCode, deptCode, unittypeCode,
                                unitnameCode, '', '');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownField(
                    label: 'User Depot',
                    value: userDepotName!,
                    items: dropdowndata_UDMUserDepot,
                    onChanged: (value) {
                      debugPrint("userdepotdrp $value");
                      dropdowndata_UDMUserDepot.forEach((element) {
                        if ("${element['intcode'].toString().trim()}-${element['value'].toString().trim()}" ==
                            value.toString().trim()) {
                          setState(() {
                            userDepotName = value!;
                            userDepotCode =
                                element['intcode'].toString().trim();
                          });
                        }
                      });
                      debugPrint("userdepotdrp1 $userDepotName $userDepotCode");
                      def_fetchSubDepot(railwayCode, userDepotCode, '');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownField(
                    label: 'User Sub Depot',
                    value: userSubDepotName!,
                    items: dropdowndata_UDMUserSubDepot,
                    onChanged: (value) {
                      dropdowndata_UDMUserSubDepot.forEach((element) {
                        if ("${element['intcode'].toString().trim()}-${element['value'].toString().trim()}" ==
                            value.toString().trim()) {
                          setState(() {
                            userSubDepotName = value!;
                            userSubDepotCode =
                                element['intcode'].toString().trim();
                          });
                        }
                      });
                    },
                  ),
                  //const SizedBox(height: 12),
                  // Month selector moved to its own row below User Sub Depot
                  //_buildMonthSelector(),
                ],
              ),
              const SizedBox(height: 12),
              _buildFilterOptionsCard(),

              // Display all filter dropdowns (expanded or collapsed)
              ..._expandedFilters.keys.map((filterName) {
                return SizeTransition(
                  sizeFactor: _animations[filterName]!,
                  child: _expandedFilters[filterName]!
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildFilterDropdown(filterName),
                          ],
                        )
                      : const SizedBox.shrink(),
                );
              }).toList(),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSecondaryButton(
                      label: 'Reset',
                      onPressed: () {
                        setState(() {
                          default_data();
                          for (var filter in _expandedFilters.keys) {
                            _expandedFilters[filter] = false;
                          }
                          _animationController.reverse();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPrimaryButton(
                      label: 'Get Details',
                      onPressed: () {
                        debugPrint("$railwayCode ..$unittypeCode..$unitnameCode..$deptCode..$userDepotCode...$userSubDepotCode...$itemUsage...$itemType...$itemCategory...$stockNonStk...$_selectedMonth");
                        if (userDepotCode.toString() == "-1" || userDepotCode == null) {
                          String? itemUnit, itemUsge, itemCat, sns;
                          if (!_expandedFilters['Item Usage']!) {
                            itemUsge = '-1';
                          } else {
                            itemUsge = itemUsage;
                          }
                          if (!_expandedFilters['Item Type']!) {
                            itemUnit = '-1';
                          } else {
                            itemUnit = itemType;
                          }
                          if (!_expandedFilters['Stock/Non-Stock']!) {
                            sns = '-1';
                          } else {
                            sns = stockNonStk;
                          }
                          if (!_expandedFilters['Item Category']!) {
                            itemCat = '-1';
                          } else {
                            itemCat = itemCategory;
                          }
                          Navigator.of(context).pushNamed(SummaryStockListScreen.routeName, arguments: [railwayCode,
                            unittypeCode,
                            unitnameCode,
                            deptCode,
                            "-1",
                            userSubDepotCode,
                            itemUsge,
                            itemUnit,
                            itemCat,
                            sns]);
                        }
                        else {
                          String? itemUnit, itemUsge, itemCat, sns;
                          if (!_expandedFilters['Item Usage']!) {
                            itemUsge = '-1';
                          } else {
                            itemUsge = itemUsage;
                          }
                          if (!_expandedFilters['Item Type']!) {
                            itemUnit = '-1';
                          } else {
                            itemUnit = itemType;
                          }
                          if (!_expandedFilters['Stock/Non-Stock']!) {
                            sns = '-1';
                          } else {
                            sns = stockNonStk;
                          }
                          if (!_expandedFilters['Item Category']!) {
                            itemCat = '-1';
                          } else {
                            itemCat = itemCategory;
                          }
                          Navigator.of(context).pushNamed(SummaryStockListScreen.routeName, arguments: [railwayCode,
                            unittypeCode,
                            unitnameCode,
                            deptCode,
                            userDepotCode,
                            userSubDepotCode,
                            itemUsge,
                            itemUnit,
                            itemCat,
                            sns]);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  width: 150,
                  child: _buildPrimaryButton(
                    label: 'Summary',
                    onPressed: () {
                      if (userDepotCode.toString() == "-1" || userDepotCode == null) {
                        String? itemUnit, itemUsge, itemCat, sns;
                        if (!_expandedFilters['Item Usage']!) {
                          itemUsge = '-1';
                        } else {
                          itemUsge = itemUsage;
                        }
                        if (!_expandedFilters['Item Type']!) {
                          itemUnit = '-1';
                        } else {
                          itemUnit = itemType;
                        }
                        if (!_expandedFilters['Stock/Non-Stock']!) {
                          sns = '-1';
                        } else {
                          sns = stockNonStk;
                        }
                        if (!_expandedFilters['Item Category']!) {
                          itemCat = '-1';
                        } else {
                          itemCat = itemCategory;
                        }
                        Future.delayed(
                          Duration.zero,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SummaryDetails(
                                    railwayCode,
                                    "-1",
                                    userSubDepotCode,
                                    unittypeCode,
                                    unitnameCode,
                                    deptCode,
                                    itemUsge,
                                    itemUnit,
                                    itemCat,
                                    sns),
                              ),
                            );
                          },
                        );
                      }
                      else {
                        String? itemUnit, itemUsge, itemCat, sns;
                        if (!_expandedFilters['Item Usage']!) {
                          itemUsge = '-1';
                        } else {
                          itemUsge = itemUsage;
                        }
                        if (!_expandedFilters['Item Type']!) {
                          itemUnit = '-1';
                        } else {
                          itemUnit = itemType;
                        }
                        if (!_expandedFilters['Stock/Non-Stock']!) {
                          sns = '-1';
                        } else {
                          sns = stockNonStk;
                        }
                        if (!_expandedFilters['Item Category']!) {
                          itemCat = '-1';
                        } else {
                          itemCat = itemCategory;
                        }
                        Future.delayed(
                          Duration.zero,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SummaryDetails(
                                    railwayCode,
                                    userDepotCode,
                                    userSubDepotCode,
                                    unittypeCode,
                                    unitnameCode,
                                    deptCode,
                                    itemUsge,
                                    itemUnit,
                                    itemCat,
                                    sns),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated method to build the month selector UI with interactive controls
  Widget _buildMonthSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Month's",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    // Decrement button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _decrementMonth,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        child: SizedBox(
                          width: 40,
                          height: 38,
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            color: _selectedMonth > 1
                                ? Colors.blue.shade800
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),

                    // Vertical separator
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey.shade300,
                    ),

                    // Month display
                    Expanded(
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade800,
                            ),
                            children: [
                              TextSpan(
                                text: "$_selectedMonth",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Vertical separator
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.grey.shade300,
                    ),

                    // Increment button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _incrementMonth,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        child: SizedBox(
                          width: 40,
                          height: 38,
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: _selectedMonth < 12
                                ? Colors.blue.shade800
                                : Colors.grey.shade400,
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
        const SizedBox(height: 4),
        Center(
          child: Text(
            'item not issued since last $_selectedMonth ${_selectedMonth == 1 ? 'month' : 'months'}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterOptionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildFilterChip(
                icon: Icons.category,
                label: 'Item Type',
                onTap: () => _toggleFilter('Item Type'),
                isSelected: _expandedFilters['Item Type']!,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                icon: Icons.add_shopping_cart,
                label: 'Item Usage',
                onTap: () => _toggleFilter('Item Usage'),
                isSelected: _expandedFilters['Item Usage']!,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                icon: Icons.format_list_bulleted,
                label: 'Item Category',
                onTap: () => _toggleFilter('Item Category'),
                isSelected: _expandedFilters['Item Category']!,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                icon: Icons.inventory_2,
                label: 'Stock/Non-Stock',
                onTap: () => _toggleFilter('Stock/Non-Stock'),
                isSelected: _expandedFilters['Stock/Non-Stock']!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(String filterName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filterName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade800,
                  ),
                ),
                IconButton(
                  icon:
                      Icon(Icons.close, size: 18, color: Colors.blue.shade800),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      _expandedFilters[filterName] = false;
                      if (!_expandedFilters.values
                          .any((isExpanded) => isExpanded)) {
                        _animationController.reverse();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Adding a simple dropdown for each filter
            _buildFilterSelectionDropdown(filterName),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSelectionDropdown(String filterName) {
    // Define options based on filter type
    List<dynamic>? options;
    String defaultValue;

    switch (filterName) {
      case 'Item Type':
        options = itemTypeList;
        defaultValue = 'All';
        break;
      case 'Item Usage':
        options = itemUsageList;
        defaultValue = 'Any';
        break;
      case 'Item Category':
        options = itemtCategryaList;
        defaultValue = 'All';
        break;
      case 'Stock/Non-Stock':
        options = stockNonStockList;
        defaultValue = 'All Items';
        break;
      default:
        options = ['All'];
        defaultValue = 'All';
    }

    return _buildDropdownField(
      label: 'Select $filterName',
      value: defaultValue,
      onChanged: (value) {
        if (filterName == 'Item Type') {
          itemTypeList.forEach((element) {
            if (element['value'].toString().trim() == value!.trim()) {
              setState(() {
                itemType = element['intcode'].toString().trim();
              });
            }
          });
        } else if (filterName == 'Item Usage') {
          itemUsageList.forEach((element) {
            if (element['value'].toString().trim() == value!.trim()) {
              setState(() {
                itemUsage = element['intcode'].toString().trim();
              });
            }
          });
        } else if (filterName == 'Item Category') {
          itemtCategryaList.forEach((element) {
            if (element['value'].toString().trim() == value!.trim()) {
              setState(() {
                itemCategory = element['intcode'].toString().trim();
              });
            }
          });
        } else {
          stockNonStockList.forEach((element) {
            if (element['value'].toString().trim() == value!.trim()) {
              setState(() {
                stockNonStk = element['intcode'].toString().trim();
              });
            }
          });
        }
      },
      items: options,
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Material(
      color: isSelected ? Colors.blue.shade100 : Colors.blue.shade50,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Colors.blue.shade800),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.blue.shade800,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down,
                    size: 16, color: Colors.blue.shade800),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context,
      {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required Function(String?) onChanged,
    List<dynamic>? items,
  }) {
    final dropdownItems = items ?? [value];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: DropdownSearch<String>(
            selectedItem: value,
            items: (filter, loadProps) => dropdownItems.map((e) {
              return label == 'User Depot' ||
                      label == 'User Sub Depot' &&
                          e['value'].toString().trim() != "All"
                  ? "${e['intcode'].toString().trim()}-${e['value'].toString().trim()}"
                  : e['value'].toString().trim();
            }).toList(),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(6)),
                contentPadding: EdgeInsets.only(left: 4.0),
              ),
            ),
            popupProps: PopupProps.menu(
              showSelectedItems: true,
              fit: FlexFit.loose,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.blue.shade800),
        ),
        elevation: 2, // Added elevation for better visual effect
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue.shade800,
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.blue.shade800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}
