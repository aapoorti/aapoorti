import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/localization/english.dart';
import 'package:flutter_app/udm/localization/languageHelper.dart';
import 'package:flutter_app/udm/providers/itemsProvider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/providers/stockProvider.dart';
import 'package:flutter_app/udm/screens/itemlist_screen.dart';
import 'package:flutter_app/udm/screens/stock_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StockRightSideDrawer extends StatefulWidget {
  static const routeName = "/stock-list-drawer";
  @override
  _StockRightSideDrawerState createState() => _StockRightSideDrawerState();
}

class _StockRightSideDrawerState extends State<StockRightSideDrawer> {
  double? sheetLeft;
  bool isExpanded = true;
  late StockListProvider itemListProvider;
  String? railway;
  String? railwayValue;
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
  String radioData = 'Months based on AAC';
  String enterData = '3';
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
  late SharedPreferences prefs;
  late List<Map<String, dynamic>> dbResult;

  Error? _error;
  bool _autoValidate = false;

  var item_data = {"1", "2", "3"};

  var userDepotValue = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AapoortiConstants.primary,
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
        title: Text(
            Provider.of<LanguageProvider>(context).text('stockAvailability'), style: TextStyle(color: Colors.white)),

      ),
      body: searchDrawer(),
    );
  }

  Widget searchDrawer() {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      children: [
        FormBuilder(
          key: _formKey,
          child: Column(children: <Widget>[
            FormBuilderDropdown(
              name: englishText['railway'] ?? 'railway',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('Railway'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: railway,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
              items: dropdowndata_UDMRlyList.map((item) {
                return DropdownMenuItem(
                    child: Text(() {
                      if(item['intcode'].toString() == '-1') {
                        return item['value'];
                      } else {
                        return item['value'];
                      }}()),
                    value: item['intcode'].toString());
              }).toList(),
              onChanged: (String? newValue) {
                debugPrint("new railway:: $newValue");
                _formKey.currentState!.fields['Unit Name']!.setValue(null);
                _formKey.currentState!.fields['Unit Type']!.setValue(null);
                _formKey.currentState!.fields['Department']!.setValue(null);
                //_formKey.currentState!.fields['User Depot']!.setValue(null);
                _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
                setState(() {
                  railway = newValue;

                  dropdowndata_UDMUnitType.clear();
                  dropdowndata_UDMDivision.clear();
                  dropdowndata_UDMUserDepot.clear();
                  dropdowndata_UDMUserSubDepot.clear();
                  dropdowndata_UDMUserSubDepot.add(_all());
                  dropdowndata_UDMUnitType.add(_all());
                  dropdowndata_UDMDivision.add(_all());
                  dropdowndata_UDMUserDepot.add(_all());
                  _formKey.currentState!.fields['Unit Name']!.setValue('-1');
                  _formKey.currentState!.fields['Unit Type']!.setValue('-1');
                  _formKey.currentState!.fields['Department']!.setValue('-1');
                  userDepotValue = "-1";
                  //_formKey.currentState!.fields['User Depot']!.setValue('-1');
                  _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
                  unittype = "-1";
                });
                def_fetchUnit(railway, '', '', '', '', '');
                // setState(() {
                //   railway = newValue;
                // });
              },
            ),
            // stockDropdown(
            //     'railway',
            //     '${language.text('select')} ${language.text('railway')}',
            //     dropdowndata_UDMRlyList,
            //     railway),
            SizedBox(height: 10),
            FormBuilderDropdown(
              name: englishText['unitType'] ?? 'unitType',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('unitType'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: dropdowndata_UDMUnitType.any((item) => item['intcode'].toString() == unittype) ? unittype : null,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
              items: dropdowndata_UDMUnitType.map((item) {
                return DropdownMenuItem(
                    child: Text(() {
                      if(item['intcode'].toString() == '-1') {
                        return item['value'];
                      } else {
                        return item['value'];
                      }}()),
                    value: item['intcode'].toString());
              }).toList(),
              onChanged: (String? newValue) {
                _formKey.currentState!.fields['Unit Name']!.setValue('-1');
                _formKey.currentState!.fields['Department']!.setValue('-1');
                setState(() {
                  unittype = newValue;
                  dropdowndata_UDMUserDepot.clear();
                  dropdowndata_UDMUserSubDepot.clear();
                  dropdowndata_UDMUserDepot.add(_all());
                  dropdowndata_UDMUserSubDepot.add(_all());
                  //_formKey.currentState!.fields['User Depot']!.setValue('-1');
                  userDepotValue = "-1";
                  _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
                });
                def_fetchunitName(railway!, unittype!, '', '', '', '');
                // setState(() {
                //   unittype = newValue;
                // });
              },
            ),
            // stockDropdown(
            //     'unitType',
            //     '${language.text('select')} ${language.text('unitType')}',
            //     dropdowndata_UDMUnitType,
            //     unitType),
            SizedBox(height: 10),
            FormBuilderDropdown(
              name: englishText['unitName'] ?? 'unitName',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('unitName'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: dropdowndata_UDMDivision.any((item) => item['intcode'].toString() == division) ? division : null,
              //initialValue: division,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
              items: dropdowndata_UDMDivision.map((item) {
                return DropdownMenuItem(
                    child: Text(() {
                      if(item['intcode'].toString() == '-1') {
                        return item['value'];
                      } else {
                        return item['value'];
                      }}()),
                    value: item['intcode'].toString());
              }).toList(),
              onChanged: (String? newValue) {
                _formKey.currentState!.fields['Department']!.setValue(null);
                //_formKey.currentState!.fields['User Depot']!.setValue(null);
                _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
                setState(() {
                  division = newValue;
                  itemType = null;
                  itemUsage = null;
                  itemCategory = null;
                  stockNonStk = null;
                  stockAvl = null;
                });
                // setState(() {
                //   division = newValue;
                // });
              },
            ),
            // stockDropdown(
            //     'unitName',
            //     '${language.text('select')} ${language.text('unitName')}',
            //     dropdowndata_UDMDivision,
            //     division),
            SizedBox(height: 10),
            FormBuilderDropdown(
              name: englishText['department'] ?? 'department',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('department'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: dropdowndata_UDMDept.any((item) => item['intcode'].toString() == department) ? department : null,
              //initialValue: division,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
              items: dropdowndata_UDMDept.map((item) {
                return DropdownMenuItem(
                    child: Text(() {
                      if(item['intcode'].toString() == '-1') {
                        return item['value'];
                      } else {
                        return  item['value'];
                      }}()),
                    value: item['intcode'].toString());
              }).toList(),
              onChanged: (String? newValue) {
                _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
                setState(() {
                  department = newValue;
                  itemType = null;
                  itemUsage = null;
                  itemCategory = null;
                  stockNonStk = null;
                  stockAvl = null;
                  def_fetchDepot(railway, department, unittype, division, '', '');
                });
                // setState(() {
                //   department = newValue;
                // });
              },
            ),
            // stockDropdown(
            //     'department',
            //     '${language.text('select')} ${language.text('department')}',
            //     dropdowndata_UDMDept,
            //     department),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: DropdownSearch<String>(
                selectedItem: userDepotValue == "-1" || userDepotValue == "All" ? "All" : userDepotValue,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  showSelectedItems: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: '${language.text('select')} ${language.text('userDepot')}',
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                    emptyBuilder: (ctx, val) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Text('No Data Found for $val'),
                      );
                    },
                  menuProps: MenuProps(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ))
                ),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: language.text('userDepot'),
                    hintText: '${language.text('select')} ${language.text('userDepot')}',
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, bottom: 5.0, top: 5.0),
                    border: const OutlineInputBorder(),
                  ),
                ),
                // popupTitle: Align(
                //   alignment: Alignment.topRight,
                //   child: Container(
                //     height: 45,
                //     margin: EdgeInsets.all(10),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.black87, width: 2),
                //       shape: BoxShape.circle,
                //     ),
                //     child: IconButton(
                //       icon: const Icon(Icons.close),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //     ),
                //   ),
                // ),
                items: (filter, loadProps) => dropdowndata_UDMUserDepot.map((item) {
                  return item['intcode'].toString() != "-1" ? item['intcode'].toString() + '-' + item['value'] : item['value'].toString();
                }).toList(),
                onChanged: (String? newValue) {
                  dropDownValue = newValue;
                  print("new value of user depot $newValue");
                  _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
                  setState(() {
                    userDepotValue = newValue.toString();
                    var depot = userDepotValue.split('-');
                    def_fetchSubDepot(railway, depot[0], '');
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            FormBuilderDropdown(
              name: 'User Sub Depot',
              focusColor: Colors.transparent,
              decoration: InputDecoration(
                labelText: language.text('userSubDepot'),
                contentPadding: EdgeInsetsDirectional.all(10),
                border: const OutlineInputBorder(),
              ),
              initialValue: dropdowndata_UDMUserSubDepot.any((item) => item['intcode'].toString() == userSubDepot) ? userSubDepot : null,
              //initialValue: userSubDepot,
              //allowClear: false,
              //hint: Text('${language.text('select')} ${language.text('userDepot')}'),
              //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
              items: dropdowndata_UDMUserSubDepot.map((item) {
                return DropdownMenuItem(
                    child: Text(() {
                      if(item['intcode'].toString() == '-1') {
                        return item['value'];
                      } else {
                        return item['intcode'].toString() + '-' + item['value'];
                      }}()),
                    value: item['intcode'].toString());
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  userSubDepot = newValue;
                });
              },
            ),
            Visibility(
              visible: itemTypeVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  stockDropdownStatic(
                      'itemType', 'Select Item Type', itemTypeList, itemType,
                      name: 'Item Type'),
                ],
              ),
            ),
            Visibility(
              visible: itemUsageVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  stockDropdownStatic(
                    'itemUsage',
                    'Select Item Usage',
                    itemUsageList,
                    itemUsage,
                    name: 'Item Usage',
                  ),
                ],
              ),
            ),
            Visibility(
              visible: itemCatVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  FormBuilderDropdown(
                    name: 'Item Category',
                    focusColor: Colors.transparent,
                    decoration: InputDecoration(
                      labelText: language.text('itemCategory'),
                      contentPadding: EdgeInsetsDirectional.all(10),
                      border: const OutlineInputBorder(),
                    ),
                    initialValue: itemCategory,
                    //allowClear: false,
                    //hint: Text('Select Item Category'),
                    //validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                    items: itemtCategryaList.map((item) {
                      return DropdownMenuItem(
                          child: Text(() {
                            if (item['intcode'].toString() == '-1') {
                              return item['value'];
                            } else {
                              return item['intcode'].toString() +
                                  '-' +
                                  item['value'];
                            }
                          }()),
                          value: item['intcode'].toString());
                    }).toList(),
                    onChanged: (String? newValue) {
                      itemCategory = newValue;
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: stkVis,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  stockDropdownStatic(
                    'stockNonStock',
                    'Select Whether Stock/Non-Stock',
                    stockNonStockList,
                    stockNonStk,
                    name: 'Whether Stock/Non-Stock',
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            FormBuilderRadioGroup(
              name: "Select Report Criteria",
              decoration: InputDecoration(
                labelText: language.text('selectReportCriteria'),
                border: InputBorder.none,
              ),
              initialValue: 'AAC basis',
              options: [
                FormBuilderFieldOption(
                  value: "AAC basis",
                  child: Text(language.text('aacBasis')),
                ),
                FormBuilderFieldOption(
                  value: "Threshold Limit basis",
                  child: Text(language.text('thresholdLimitBasis')),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue == "AAC basis") {
                  setState(() {
                    stkReport = language.text('aac');
                    radioData = language.text('monthsBasedOnAAC');
                  });
                } else {
                  setState(() {
                    stkReport = language.text('thresholdLimit');
                    radioData = language.text('times') +
                        ' ' +
                        language.text('thresholdLimit');
                  });
                }
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FormBuilderRadioGroup(
                    name: 'Stock Availability',
                    initialValue: '${language.text('greaterThan')} (<=)',
                    decoration: InputDecoration(
                      labelText: language.text('selectStockAvailability'),
                      contentPadding: EdgeInsetsDirectional.all(0),
                      border: InputBorder.none,
                    ),
                    autovalidateMode: AutovalidateMode.disabled,
                    options: [
                      '${language.text('greaterThan')} (>)',
                      '${language.text('lessThan')} (<=)'
                    ]
                        .map((lang) => FormBuilderFieldOption(value: lang))
                        .toList(growable: false),
                    onChanged: (String? newValue) {},
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        child: FormBuilderTextField(
                          name: 'freeText',
                          initialValue: enterData,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsetsDirectional.all(10),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(radioData),
                    ],
                  ),
                ),
                // Expanded(child: Icon(IconData(0xf73f))),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 7.5,
              children: [
                Visibility(
                  visible: itemTypeButtonVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          itemTypeVis = true;
                          itemTypeButtonVis = false;
                          if (itemTypeVis) {
                            itemType = '-1';
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            language.text('itemType'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: itemUsageBtnVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          itemUsageVis = true;
                          itemUsageBtnVis = false;
                          if (itemUsageVis) {
                            itemUsage = '-1';
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            language.text('itemUsage'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: itemCatBtnVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          itemCatVis = true;
                          itemCatBtnVis = false;
                          if (itemCatVis) {
                            itemCategory = '-1';
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            language.text('itemCategory'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: stkBtnVis,
                  child: FittedBox(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          stkVis = true;
                          stkBtnVis = false;
                          if (stkVis) {
                            stockNonStk = '-1';
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            language.text('stockNonStock'),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 50,
                  width: 160,
                  child: OutlinedButton(
                    style: IRUDMConstants.bStyle(),
                    onPressed: () {
                      // print("from date ${_formKey.currentState!.fields['FromDate']!.value}");
                      // print("to date ${_formKey.currentState!.fields['ToDate']!.value}");
                      // print("user depot value $userDepotValue");
                      // print("user depot value $userDepot");
                      // print("unit name ${_formKey.currentState!.fields['Unit Name']!.value}");
                      // print("unit type $unitType");
                      setState(() {
                        if(_formKey.currentState!.validate()) {
                          if(userDepotValue.toString() == "All" || userDepotValue.toString() == "-1"  || userDepotValue == null){
                            itemListProvider = Provider.of<StockListProvider>(context, listen: false);
                            Navigator.of(context).pushNamed(StockListScreen.routeName);
                            if (_formKey.currentState!.fields['Select Report Criteria']!.value == "AAC basis") {
                              stkReport = "AAC";
                              if(language.language == Language.English) _aacData(stkReport!);
                              else _aacData(language.text('aac'));
                              print(_formKey.currentState!.fields['Select Report Criteria']!.value);
                            } else {
                              stkReport = "THL";
                              if(language.language == Language.English) {
                                _aacData(stkReport!);
                              } else {
                                _aacData(language.text('thresholdLimit'),
                                );
                              }
                            }
                            String? itemUnit, itemCat, sns;
                            if(!itemUsageVis) {
                              itemUsage = '-1';
                            } else {
                              itemUsage = _formKey.currentState!.fields['Item Usage']!.value;
                            }
                            if(!itemTypeVis) {
                              itemUnit = '-1';
                            } else {
                              itemUnit = _formKey.currentState!.fields['Item Type']!.value;
                            }
                            if (!stkVis) {
                              sns = '-1';
                            } else {
                              sns = _formKey.currentState!.fields['Whether Stock/Non-Stock']!.value;
                            }
                            String? itemCatValue = '';
                            if (!itemCatVis) {
                              itemCatValue = '-1';
                            } else {
                              itemCatValue = _formKey.currentState!.fields['Item Category']!.value;
                            }
                            String sAvl;
                            if(_formKey.currentState!.fields['Stock Availability']!.value == 'Less than (<=)') {
                              sAvl = '2';
                            } else {
                              sAvl = '1';
                            }
                            itemListProvider.fetchAndStoreItemsListwithdata(
                                railway,
                                unittype,
                                _formKey.currentState!.fields['Unit Name']!.value,
                                _formKey.currentState!.fields['Department']!.value,
                                "-1",
                                _formKey.currentState!.fields['User Sub Depot']!.value,
                                itemUsage,
                                itemUnit,
                                itemCatValue,
                                sns,
                                stkReport,
                                sAvl,
                                _formKey.currentState!.fields['freeText']!.value,
                                context);
                          }
                          else{
                            itemListProvider = Provider.of<StockListProvider>(context, listen: false);
                            Navigator.of(context).pushNamed(StockListScreen.routeName);
                            var depot = userDepotValue.split('-');
                            if (_formKey.currentState!.fields['Select Report Criteria']!.value == "AAC basis") {
                              stkReport = "AAC";
                              if(language.language == Language.English) _aacData(stkReport!);
                              else _aacData(language.text('aac'));
                              print(_formKey.currentState!.fields['Select Report Criteria']!.value);
                            } else {
                              stkReport = "THL";
                              if(language.language == Language.English) {
                                _aacData(stkReport!);
                              } else {
                                _aacData(language.text('thresholdLimit'),
                                );
                              }
                            }
                            String? itemUnit, itemCat, sns;
                            if(!itemUsageVis) {
                              itemUsage = '-1';
                            } else {
                              itemUsage = _formKey.currentState!.fields['Item Usage']!.value;
                            }
                            if(!itemTypeVis) {
                              itemUnit = '-1';
                            } else {
                              itemUnit = _formKey.currentState!.fields['Item Type']!.value;
                            }
                            if (!stkVis) {
                              sns = '-1';
                            } else {
                              sns = _formKey.currentState!.fields['Whether Stock/Non-Stock']!.value;
                            }
                            String? itemCatValue = '';
                            if (!itemCatVis) {
                              itemCatValue = '-1';
                            } else {
                              itemCatValue = _formKey.currentState!.fields['Item Category']!.value;
                            }
                            String sAvl;
                            if(_formKey.currentState!.fields['Stock Availability']!.value == 'Less than (<=)') {
                              sAvl = '2';
                            } else {
                              sAvl = '1';
                            }
                            itemListProvider.fetchAndStoreItemsListwithdata(
                                railway,
                                unittype,
                                _formKey.currentState!.fields['Unit Name']!.value,
                                _formKey.currentState!.fields['Department']!.value,
                                depot[0],
                                _formKey.currentState!.fields['User Sub Depot']!.value,
                                itemUsage,
                                itemUnit,
                                itemCatValue,
                                sns,
                                stkReport,
                                sAvl,
                                _formKey.currentState!.fields['freeText']!.value,
                                context);
                          }
                        }
                      });
                    },
                    child: Text(language.text('getDetails'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AapoortiConstants.primary,
                        )),
                  ),
                ),
                Container(
                  width: 160,
                  height: 50,
                  child: OutlinedButton(
                    style: IRUDMConstants.bStyle(),
                    onPressed: () {
                      setState(() {
                        itemTypeVis = false;
                        itemUsageVis = false;
                        itemCatVis = false;
                        stkVis = false;

                        itemTypeButtonVis = true;
                        itemUsageBtnVis = true;
                        itemCatBtnVis = true;
                        stkBtnVis = true;
                        _formKey.currentState!.reset();
                        default_data();
                        //reseteValues();
                      });
                    },
                    child: Text(
                      language.text('reset'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AapoortiConstants.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ],
    );
  }

  _all() {
    var all = {
      'intcode': '-1',
      'value': 'All',
    };
    return all;
  }

  Widget stockDropdown(String key, String hint, List listData, String? initValue) {
    String name = englishText[key] ?? key;
    debugPrint("mydata:::: $listData");
    return FormBuilderDropdown(
      name: name,
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: name == key ? name : Provider.of<LanguageProvider>(context).text(key),
        contentPadding: EdgeInsetsDirectional.all(10),
        border: const OutlineInputBorder(),
      ),
      initialValue: dropDownValue,
      //allowClear: false,
      //hint: Text(hint),
      validator: (value) {
        if (value == null || value.toString().isEmpty) {
          return 'Please select a $hint';
        }
        return null; // Return null if validation passes
      },
      items: listData.map((item) {
        return DropdownMenuItem(child: Text(item['value']), value: item['intcode'].toString());
      }).toList(),
      onChanged: (String? newValue) {
        debugPrint("mydata11:::: $newValue");
        dropDownValue = newValue;
        if(name == 'Railway') {
          _formKey.currentState!.fields['Unit Name']!.setValue(null);
          _formKey.currentState!.fields['Unit Type']!.setValue(null);
          _formKey.currentState!.fields['Department']!.setValue(null);
          //_formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          setState(() {
            railway = newValue;

            dropdowndata_UDMUnitType.clear();
            dropdowndata_UDMDivision.clear();
            dropdowndata_UDMUserDepot.clear();
            dropdowndata_UDMUserSubDepot.clear();
            dropdowndata_UDMUserSubDepot.add(_all());
            dropdowndata_UDMUnitType.add(_all());
            dropdowndata_UDMDivision.add(_all());
            dropdowndata_UDMUserDepot.add(_all());
            _formKey.currentState!.fields['Unit Name']!.setValue('-1');
            _formKey.currentState!.fields['Unit Type']!.setValue('-1');
            _formKey.currentState!.fields['Department']!.setValue('-1');
            userDepotValue = "-1";
            //_formKey.currentState!.fields['User Depot']!.setValue('-1');
            _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
            unittype = "-1";
          });
          def_fetchUnit(railway, '', '', '', '', '');
        }
        else if(name == 'Unit Type') {
          _formKey.currentState!.fields['Unit Name']!.setValue('-1');
          _formKey.currentState!.fields['Department']!.setValue('-1');
          setState(() {
            unittype = newValue;
            dropdowndata_UDMUserDepot.clear();
            dropdowndata_UDMUserSubDepot.clear();
            dropdowndata_UDMUserDepot.add(_all());
            dropdowndata_UDMUserSubDepot.add(_all());
            //_formKey.currentState!.fields['User Depot']!.setValue('-1');
            userDepotValue = "-1";
            _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
          });
          def_fetchunitName(railway!, unittype!, '', '', '', '');
        }
        else if (name == 'Unit Name') {
          _formKey.currentState!.fields['Department']!.setValue(null);
          //_formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          setState(() {
            division = newValue;
            itemType = null;
            itemUsage = null;
            itemCategory = null;
            stockNonStk = null;
            stockAvl = null;
          });
        }
        else if (name == 'Department') {
          //_formKey.currentState!.fields['User Depot']!.setValue(null);
          _formKey.currentState!.fields['User Sub Depot']!.setValue(null);
          setState(() {
            department = newValue;
            itemType = null;
            itemUsage = null;
            itemCategory = null;
            stockNonStk = null;
            stockAvl = null;
            def_fetchDepot(railway, department, unittype, division, '', '');
          });
        }
      },
    );
  }

  Widget stockDropdownStatic(String key, String hint, List listData, String? initValue, {String? name}) {
    if(name == null) {
      name = key;
    }
    return FormBuilderDropdown(
      name: name,
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: name == key ? name : Provider.of<LanguageProvider>(context).text(key),
        contentPadding: EdgeInsetsDirectional.all(10),
        border: const OutlineInputBorder(),
      ),
      initialValue: initValue,
      //allowClear: false,
      //hint: Text(hint),
      validator: (value) {
        // if (value == null || value..isEmpty) {
        //   return 'Please select a gender';
        // }
        return null; // Return null if validation passes
      },
      items: listData.map((item) {
        return DropdownMenuItem(child: Text(item['value']), value: item['intcode'].toString());
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          initValue = newValue;
        });
      },
    );
  }

  void reseteValues() {
    dropdowndata_UDMUnitType.clear();
    dropdowndata_UDMDivision.clear();
    dropdowndata_UDMUserDepot.clear();
  }

  void initState() {
    setState(() {
      default_data();
    });
    super.initState();
  }

  Future<dynamic> default_data() async {
    Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    itemTypeList.clear();
    itemUsageList.clear();
    itemtCategryaList.clear();
    stockNonStockList.clear();
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbResult = await dbHelper.fetchSaveLoginUser();
    try {
      var d_response = await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue', 'GetListDefaultValue', dbResult[0][DatabaseHelper.Tb3_col5_emailid], prefs.getString('token'));

      var d_JsonData = json.decode(d_response.body);
      var d_Json = d_JsonData['data'];
      var result_UDMRlyList = await Network().postDataWithAPIMList('UDMAppList','UDMRlyList','',prefs.getString('token'));
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
        if(staticDataJson[i]['list_for'] == 'ItemType') {
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
        dropdowndata_UDMRlyList = myList_UDMRlyList; //1
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        railway = d_Json[0]['org_zone'];
        department = d_Json[0]['org_subunit_dept'];
        division = d_Json[0]['admin_unit'].toString();
        unittype = d_Json[0]['org_unit_type'].toString();
        debugPrint("railway:: $railway  department $department division $division");
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
      _formKey.currentState!.fields['Railway']!.setValue(d_Json[0]['org_zone']);

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

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart, String unitName, String depot, String userSubDep) async {
    try {
      var result_UDMUnitType=await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);

      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMUnitType.add(getAll());
          _formKey.currentState!.fields['Unit Type']!.setValue("-1");
          def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        });
      }
      else {
        var unitData = UDMUnitType_body['data'];
        myList_UDMUnitType.add(getAll());
        myList_UDMUnitType.addAll(unitData);
        setState(() {
          dropdowndata_UDMUnitType = myList_UDMUnitType; //2
          debugPrint("Unit type list:: $myList_UDMUnitType");
        });
        if(value == '-1') {
          def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        }
      }
      if (unit_data != "") {
        _formKey.currentState!.fields['Unit Type']!.setValue(unit_data);
        def_fetchunitName(value!, unit_data, unitName, depot, depart, userSubDep);
      } else {
        _formKey.currentState!.fields['Unit Type']!.setValue("-1");
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
    debugPrint("fetch unit name calling now");
    try {
      var result_UDMunitName = await Network().postDataWithAPIMList('UDMAppList','UnitName',rai+"~"+unit,prefs.getString('token'));
      var UDMunitName_body = json.decode(result_UDMunitName.body);
      var myList_UDMunitName = [];
      if (UDMunitName_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMDivision.add(getAll());
          _formKey.currentState!.fields['Unit Name']!.setValue('-1');
          def_fetchDepot(rai, depart.toString(), unit, unitName_name, depot, userSubDep);
        });
      }
      else {
        var divisionData = UDMunitName_body['data'];
        myList_UDMunitName.add(getAll());
        myList_UDMunitName.addAll(divisionData);
        setState(() {
          dropdowndata_UDMDivision = myList_UDMunitName; //2
        });
        if (unit == '-1') {
          _formKey.currentState!.fields['Department']!.setValue('-1');
          def_fetchDepot(rai, depart.toString(), unit, unitName_name, depot, userSubDep);
        }
      }
      if (unitName_name != "") {
        _formKey.currentState!.fields['Unit Name']!.setValue(unitName_name);
        def_fetchDepot(rai, depart.toString(), unit, unitName_name, depot, userSubDep);
      } else {
        _formKey.currentState!.fields['Unit Name']!.setValue('-1');
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    }
  }

  // Future<dynamic> def_fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id, String userSubDep) async {
  //   try {
  //     dropdowndata_UDMUserDepot.clear();
  //     if (depot_id == 'NA') {
  //       var all = {
  //         'intcode': '-1',
  //         'value': "All",
  //       };
  //       userDepot = '-1';
  //       dropdowndata_UDMUserDepot.add(all);
  //       _formKey.currentState!.fields['User Depot']!.setValue('-1');
  //       def_fetchSubDepot(rai, depot_id, userSubDep);
  //     } else {
  //
  //       var result_UDMUserDepot = await Network().postDataWithAPIMList(
  //           'UDMAppList','UDMUserDepot' ,
  //           rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!,prefs.getString('token'));
  //       var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
  //       var myList_UDMUserDepot = [];
  //       if (UDMUserDepot_body['status'] != 'OK') {
  //         setState(() {
  //           var all = {
  //             'intcode': '-1',
  //             'value': "All",
  //           };
  //           dropdowndata_UDMUserDepot.add(all);
  //           _formKey.currentState!.fields['User Depot']!.setValue('-1');
  //           def_fetchSubDepot(rai, depot_id, userSubDep);
  //         });
  //       } else {
  //         var depoData = UDMUserDepot_body['data'];
  //         dropdowndata_UDMUserSubDepot.clear();
  //         var all = {
  //           'intcode': '-1',
  //           'value': "All",
  //         };
  //         myList_UDMUserDepot.add(all);
  //         myList_UDMUserDepot.addAll(depoData);
  //         setState(() {
  //           dropdowndata_UDMUserDepot = myList_UDMUserDepot; //2
  //           if (depot_id != "") {
  //             userDepot = depot_id;
  //             _formKey.currentState!.fields['User Depot']!.setValue(depot_id);
  //             def_fetchSubDepot(rai, depot_id, userSubDep);
  //           } else {
  //             _formKey.currentState!.fields['User Depot']!.didChange('-1');
  //           }
  //         });
  //       }
  //     }
  //   } on HttpException {
  //     IRUDMConstants().showSnack(
  //         "Something Unexpected happened! Please try again.", context);
  //   } on SocketException {
  //     IRUDMConstants()
  //         .showSnack("No connectivity. Please check your connection.", context);
  //   } on FormatException {
  //     IRUDMConstants().showSnack(
  //         "Something Unexpected happened! Please try again.", context);
  //   } catch (err) {
  //     IRUDMConstants().showSnack(
  //         "Something Unexpected happened! Please try again.", context);
  //   }
  // }

  Future<dynamic> def_fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id, String userSubDep) async {
    try {
      dropdowndata_UDMUserDepot.clear();
      if(depot_id == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserDepot.add(all);
        userDepotValue = "-1";
        //_formKey.currentState!.fields['User Depot']!.setValue('-1');
        def_fetchSubDepot(rai, depot_id, userSubDep);
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UDMUserDepot' , rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!, prefs.getString('token'));
        var UDMUserDepot_body = json.decode(result_UDMUserDepot.body);
        var myList_UDMUserDepot = [];
        if (UDMUserDepot_body['status'] != 'OK') {
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserDepot.add(all);
            userDepotValue = "-1";
            def_fetchSubDepot(rai, depot_id, userSubDep);
          });
        } else {
          var depoData = UDMUserDepot_body['data'];
          dropdowndata_UDMUserSubDepot.clear();
          myList_UDMUserDepot.addAll(depoData);
          setState(() {
            dropdowndata_UDMUserDepot = myList_UDMUserDepot;
            if(depot_id != "") {
              userDepot = depot_id;
              dropdowndata_UDMUserDepot.forEach((item) {
                if(item['intcode'].toString().contains(depot_id.toLowerCase())) {
                  userDepotValue = item['intcode'].toString() + '-' + item['value'];
                }
              });
              def_fetchSubDepot(rai, depot_id, userSubDep);
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

  Future<dynamic> def_fetchSubDepot(String? rai, String? depot_id, String userSDepo) async {
    try {
      dropdowndata_UDMUserSubDepot.clear();
      if (userSDepo == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserSubDepot.add(all);
        _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList(
            'UDMAppList','UserSubDepot' , rai! + "~" + depot_id!,prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        var myList_UDMUserDepot = [];
        if (UDMUserSubDepot_body['status'] != 'OK') {
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserSubDepot.add(all);
            _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
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
              debugPrint("UserSubDepot1 $userSubDepot");
              userSubDepot = userSDepo;
              debugPrint("UserSubDepot2 $userSubDepot");
              _formKey.currentState!.fields['User Sub Depot']!.setValue(userSDepo);
            } else {
              _formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
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

  Future<dynamic> def_depart_result(String depart) async {
    try {
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','',prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      var deptData = UDMDept_body['data'];
      var myList_UDMDept = [];
      myList_UDMDept.addAll(deptData);
      setState(() {
        dropdowndata_UDMDept = myList_UDMDept; //5
        if(depart != '') {
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

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  _aacData(String repotCrit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('aac', repotCrit);
  }

  @override
  Future<void> didChangeDependencies() async {
    radioData = Provider.of<LanguageProvider>(context).text('monthsBasedOnAAC');
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }
}
