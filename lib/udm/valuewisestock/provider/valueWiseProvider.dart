import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:flutter_app/udm/valuewisestock/model/railwaylistdata.dart';
import 'package:flutter_app/udm/valuewisestock/repo/valuewisestock_repo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/valueWise.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DefaultDataState { Idle, Busy, Finished, FinishedWithError }
enum ValueWiseState { Idle, Busy, Finished, FinishedWithError }
enum RailwayDataState {Idle, Busy, Finished, FinishedWithError}
enum UnittypeDataState {Idle, Busy, Finished, FinishedWithError}
enum UnitnameDataState {Idle, Busy, Finished, FinishedWithError}
enum DepartmentDataState {Idle, Busy, Finished, FinishedWithError}
enum ConsigneeDataState {Idle, Busy, Finished, FinishedWithError}
enum SubConsigneeDataState {Idle, Busy, Finished, FinishedWithError}

class ValueWiseProvider with ChangeNotifier{
  List<ValueWise>? _items;
  List<ValueWise>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  ValueWiseState _state = ValueWiseState.Idle;
  int? countData;
  bool countVis=false;
  void setState(ValueWiseState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ValueWiseState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<ValueWise>? get valueWiseList {
    return _items;
  }

  // Data Variables to assign initial value
  String department = "Select Department";
  String? deptcode;
  String railway = "Select Railway";
  String? rlyCode;
  String unittype = "Select Unit Type";
  String? unittypecode;
  String unitname = "Select Unit Name";
  String? unitnamecode;
  String consignee = "Select Consignee";
  String? consigneecode;
  String subconsignee = "Select Sub Consignee";
  String? subconsigneecode;

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

  DefaultDataState _defaultDataState = DefaultDataState.Idle;

  RailwayDataState _rlwDataState = RailwayDataState.Idle;
  UnittypeDataState _unittypeDataState = UnittypeDataState.Idle;
  UnitnameDataState _unitnameDataState = UnitnameDataState.Idle;
  DepartmentDataState _departmentDataState = DepartmentDataState.Idle;
  ConsigneeDataState _consigneeDataState = ConsigneeDataState.Idle;
  SubConsigneeDataState _subconsigneeDataState = SubConsigneeDataState.Idle;



  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      setState(ValueWiseState.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteValueViseStock();
    try {
        await databaseHelper.insertValueViseStock(_items);
    } catch (err) {
      setState(ValueWiseState.FinishedWithError);
    }
  }

  // Future<dynamic> default_data(BuildContext context) async {
  //   debugPrint("Default data calling");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setDefaultDataState(DefaultDataState.Busy);
  //   itemTypeList.clear();
  //   itemUsageList.clear();
  //   itemtCategryaList.clear();
  //   stockNonStockList.clear();
  //   DatabaseHelper dbHelper = DatabaseHelper.instance;
  //   dbResult = await dbHelper.fetchSaveLoginUser();
  //   try {
  //     var d_response = await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue', 'GetListDefaultValue',
  //         dbResult![0][DatabaseHelper.Tb3_col5_emailid],
  //         prefs.getString('token'));
  //
  //     var d_JsonData = json.decode(d_response.body);
  //     var d_Json = d_JsonData['data'];
  //     debugPrint("User resp $d_Json");
  //     var result_UDMRlyList = await Network().postDataWithAPIMList(
  //         'UDMAppList','UDMRlyList','',prefs.getString('token'));
  //     var UDMRlyList_body = json.decode(result_UDMRlyList.body);
  //     var rlyData = UDMRlyList_body['data'];
  //     var myList_UDMRlyList = [];
  //     myList_UDMRlyList.addAll(rlyData);
  //
  //     var staticDataresponse = await Network.postDataWithAPIM('app/Common/UdmAppListStatic/V1.0.0/UdmAppListStatic', 'UdmAppListStatic', '',prefs.getString('token'));
  //
  //     var staticData = json.decode(staticDataresponse.body);
  //     List staticDataJson = staticData['data'];
  //
  //     var itemCatDataUrl = await Network().postDataWithAPIMList('UDMAppList','ItemCategory','',prefs.getString('token'));
  //     var itemData = json.decode(itemCatDataUrl.body);
  //     var itemCatDataJson = itemData['data'];
  //
  //     for (int i = 0; i < staticDataJson.length; i++) {
  //       if (staticDataJson[i]['list_for'] == 'ItemType') {
  //           var all = {
  //             'intcode': staticDataJson[i]['key'],
  //             'value': staticDataJson[i]['value'],
  //           };
  //           itemTypeList.add(all);
  //       }
  //       if(staticDataJson[i]['list_for'] == 'ItemUsage') {
  //           var all = {
  //             'intcode': staticDataJson[i]['key'],
  //             'value': staticDataJson[i]['value'],
  //           };
  //           itemUsageList.add(all);
  //
  //       }
  //       if(staticDataJson[i]['list_for'] == 'StockNonStock') {
  //           var all = {
  //             'intcode': staticDataJson[i]['key'],
  //             'value': staticDataJson[i]['value'],
  //           };
  //           stockNonStockList.add(all);
  //
  //       }
  //       if (staticDataJson[i]['list_for'] == 'StockAvailability') {
  //           var all = {
  //             'intcode': staticDataJson[i]['key'],
  //             'value': staticDataJson[i]['value'],
  //           };
  //           stockAvailability.add(all);
  //       }
  //     }
  //       itemtCategryaList.addAll(itemCatDataJson);
  //
  //       dropdowndata_UDMUnitType.clear();
  //       dropdowndata_UDMDivision.clear();
  //       dropdowndata_UDMUserDepot.clear();
  //       dropdowndata_UDMRlyList = myList_UDMRlyList;
  //       dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value']));
  //       def_depart_result(d_Json[0]['org_subunit_dept'].toString());
  //       railway = d_Json[0]['account_name'];
  //       rlyCode  = d_Json[0]['org_zone'];
  //       unittype = d_Json[0]['unit_type'];
  //       unittypecode = d_Json[0]['org_unit_type'].toString();
  //       unitname = d_Json[0]['unit_name'];
  //       unitnamecode = d_Json[0]['admin_unit'].toString();
  //       department = d_Json[0]['dept_name'];
  //       deptcode = d_Json[0]['org_subunit_dept'].toString();
  //       consignee = "${d_Json[0]['ccode'].toString()}-${d_Json[0]['cname'].toString()}";
  //       consigneecode = d_Json[0]['ccode'].toString();
  //       subconsignee = "${d_Json[0]['sub_cons_code'].toString()}-${d_Json[0]['sub_user_depot'].toString()}";
  //       subconsigneecode = d_Json[0]['sub_cons_code'].toString();
  //       Future.delayed(Duration(milliseconds: 0), () async {
  //         // def_fetchUnit(
  //         //     d_Json[0]['org_zone'],
  //         //     d_Json[0]['org_unit_type'].toString(),
  //         //     d_Json[0]['org_subunit_dept'].toString(),
  //         //     d_Json[0]['admin_unit'].toString(),
  //         //     d_Json[0]['ccode'].toString(),
  //         //     d_Json[0]['sub_cons_code'].toString(), context);
  //
  //         getUnitTypeData("", context);
  //
  //       });
  //
  //   } on HttpException {
  //     //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
  //   } on SocketException {
  //     //IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
  //   } on FormatException {
  //     //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
  //   } catch (err) {
  //     //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
  //   }
  //
  //   setDefaultDataState(DefaultDataState.Finished);
  //   debugPrint("Default data calling end");
  // }

  // --- Default Data ------
  DefaultDataState get defaultDataState => _defaultDataState;
  void setDefaultDataState(DefaultDataState currentState) {
    _defaultDataState = currentState;
    notifyListeners();
  }

  // --- Railway Data ---
  List<dynamic> get rlylistData => dropdowndata_UDMRlyList;
  void setrailwaylistData(List<dynamic> rlylist){
    dropdowndata_UDMRlyList = rlylist;
  }
  RailwayDataState get rlydatastatus => _rlwDataState;
  void setRlwStatusState(RailwayDataState currentState) {
    _rlwDataState = currentState;
    notifyListeners();
  }

  // --- Unit Type Data ---
  List<dynamic> get unittypelistData => dropdowndata_UDMUnitType;
  void setunittypelistData(List<dynamic> unittypelist) {
    dropdowndata_UDMUnitType = unittypelist;
  }
  UnittypeDataState get unittypedatastatus => _unittypeDataState;
  void setUnittypeStatusState(UnittypeDataState currentState) {
    _unittypeDataState = currentState;
    notifyListeners();
  }

  // --- Unit Name Data ---
  List<dynamic> get unitnamelistData => dropdowndata_UDMDivision;
  void setunitnamelistData(List<dynamic> unitnamelist) {
    final seen = <String>{};
    final distinctList = unitnamelist.where((item) {
      final identifier = '${item['intcode']}_${item['value']}';
      return seen.add(identifier); // Only adds if not already in set
    }).toList();
    dropdowndata_UDMDivision = distinctList;
  }
  UnitnameDataState get unitnamedatastatus => _unitnameDataState;
  void setUnitnameStatusState(UnitnameDataState currentState) {
    _unitnameDataState = currentState;
    notifyListeners();
  }

  // --- Department Name Data ---
  List<dynamic> get departmentlistData => dropdowndata_UDMDept;
  void setdepartmentlistData(List<dynamic> departmentlist) {
    dropdowndata_UDMDept = departmentlist;
  }
  DepartmentDataState get departmentdatastatus => _departmentDataState;
  void setDepartmentStatusState(DepartmentDataState currentState) {
    _departmentDataState = currentState;
    notifyListeners();
  }

  //--- Consignee Data ---
  List<dynamic> get consigneelistData => dropdowndata_UDMUserDepot;
  void setConsigneelistData(List<dynamic> conlist) {
    dropdowndata_UDMUserDepot = conlist;
  }
  ConsigneeDataState get condatastatus => _consigneeDataState;
  void setConStatusState(ConsigneeDataState currentState) {
    _consigneeDataState = currentState;
    notifyListeners();
  }

  //--- Sub Consignee Data ---
  List<dynamic> get subconsigneeData => dropdowndata_UDMUserSubDepot;
  void setsubConsigneeData(List<dynamic> subconsigneelist) {
    dropdowndata_UDMUserSubDepot = subconsigneelist;
  }
  SubConsigneeDataState get subconsigneedatastatus => _subconsigneeDataState;
  void setSubConsigneeStatusState(SubConsigneeDataState currentState) {
    _subconsigneeDataState = currentState;
    notifyListeners();
  }

  Future<void> getRailwaylistData(BuildContext context) async{
    setRlwStatusState(RailwayDataState.Busy);
    //NSDemandSummaryRepo stockHistoryRepository = NSDemandSummaryRepo(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      Future<dynamic> data = ValueWiseStockRepo.instance.fetchrailwaylistData(context);
      data.then((value){
        debugPrint("railway data $value");
        if(value.isEmpty || value.length == 0){
          setRlwStatusState(RailwayDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setrailwaylistData(value);
          railway = "All";
          rlyCode = "-1";
          value.forEach((item) {
            if(item['intcode'].toString() == prefs.getString('userzone')){
              railway = item['value'].toString();
              rlyCode = item['intcode'].toString();
            }
          });
          setRlwStatusState(RailwayDataState.Finished);
        }
        else{
          setRlwStatusState(RailwayDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getUnitTypeData(String? rly, BuildContext context) async {
    setUnittypeStatusState(UnittypeDataState.Busy);
    setUnitnameStatusState(UnitnameDataState.Busy);
    setDepartmentStatusState(DepartmentDataState.Busy);
    //setConStatusState(ConsigneeDataState.Busy);
    //setSubConsigneeStatusState(SubConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dropdowndata_UDMUnitType.clear();
    if(rly == "") {
      try {
        Future<dynamic> data = ValueWiseStockRepo.instance.def_fetchUnit(prefs.getString('userzone'), prefs.getString('orgunittype'), prefs.getString('orgsubunit'), prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        getUnitNameData(prefs.getString('userzone'), prefs.getString('orgunittype'),context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setUnittypeStatusState(UnittypeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunittypelistData(value);
            value.forEach((item) {
              if (item['intcode'].toString() == prefs.getString('orgunittype')) {
                unittype = item['value'].toString();
                unittypecode = item['intcode'].toString();
              }
            });
            getUnitNameData(prefs.getString('userzone'), unittypecode,context);
            setUnittypeStatusState(UnittypeDataState.Finished);
          }
          else {
            setUnittypeStatusState(UnittypeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setUnittypeStatusState(UnittypeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else {
      try {
        Future<dynamic> data = ValueWiseStockRepo.instance.def_fetchUnit(
            rly,
            prefs.getString('orgunittype'),
            prefs.getString('orgsubunit'),
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        dropdowndata_UDMDivision.clear();
        //consigneelistData.clear();
        //subconsigneeData.clear();
        setunitnamelistData(_all());
        //setConsigneelistData(_all());
        //setsubConsigneeData(_all());
        unittype = "All";
        unittypecode = "-1";
        unitname = "All";
        unitnamecode = "-1";
        department = "All";
        deptcode = "-1";
        consignee = "All";
        consigneecode = "-1";
        subconsignee = "All";
        subconsigneecode = "-1";
        data.then((value) {
          setUnitnameStatusState(UnitnameDataState.Finished);
          setDepartmentStatusState(DepartmentDataState.Finished);
          //setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          if (value.isEmpty || value.length == 0) {
            setUnittypeStatusState(UnittypeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunittypelistData(value);
            getUnitNameData(rly, unittypecode,context);
            setUnittypeStatusState(UnittypeDataState.Finished);
          }
          else {
            setUnittypeStatusState(UnittypeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setUnittypeStatusState(UnittypeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
  }

  Future<void> getUnitNameData(String? rly, String? unittype, BuildContext context) async {
    setUnitnameStatusState(UnitnameDataState.Busy);
    setDepartmentStatusState(DepartmentDataState.Busy);
    //setConStatusState(ConsigneeDataState.Busy);
    //setSubConsigneeStatusState(SubConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dropdowndata_UDMDivision.clear();
    try {
      if(unittype == "") {
        Future<dynamic> data = ValueWiseStockRepo.instance.def_fetchunitName(
            prefs.getString('userzone'),
            prefs.getString('orgunittype'),
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('orgsubunit'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          debugPrint("Unit name0 $value");
          if (value.isEmpty || value.length == 0) {
            setUnitnameStatusState(UnitnameDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunitnamelistData(value);
            value.forEach((item) {
              if(item['intcode'].toString() == prefs.getString('adminunit')) {
                unitname = item['value'].toString();
                unitnamecode = item['intcode'].toString();
              }
            });
            setUnitnameStatusState(UnitnameDataState.Finished);
          }
          else {
            setUnitnameStatusState(UnitnameDataState.FinishedWithError);
          }
        });
      }
      else {
        //consigneelistData.clear();
        //setConsigneelistData(_all());
        unitname = "All";
        unitnamecode = "-1";
        consignee = "All";
        consigneecode = "-1";
        department = "All";
        deptcode = "-1";
        Future<dynamic> data = ValueWiseStockRepo.instance.def_fetchunitName(
            rly,
            unittype,
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('orgsubunit'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          debugPrint("Unit name1 $value");
          if (value.isEmpty || value.length == 0) {
            setUnitnameStatusState(UnitnameDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunitnamelistData(value);
            setDepartmentStatusState(DepartmentDataState.Finished);
            //setConStatusState(ConsigneeDataState.Finished);
            setUnitnameStatusState(UnitnameDataState.Finished);
            //setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setUnitnameStatusState(UnitnameDataState.FinishedWithError);
          }
        });
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getDepartment(BuildContext context) async {
    setDepartmentStatusState(DepartmentDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    departmentlistData.clear();
    try {
      Future<dynamic> data = ValueWiseStockRepo.instance.def_depart_result(context);
      data.then((value) {
        if(value.isEmpty || value.length == 0) {
          setDepartmentStatusState(DepartmentDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value == null){
          setDepartmentStatusState(DepartmentDataState.Finished);
        }
        else if (value.isNotEmpty || value.length != 0) {
          setdepartmentlistData(value);
          value.forEach((item) {
            if(item['intcode'].toString() == prefs.getString('orgsubunit')) {
              department = item['value'].toString();
              deptcode = item['intcode'].toString();
            }
          });
          setDepartmentStatusState(DepartmentDataState.Finished);
        }
        else {
          setDepartmentStatusState(DepartmentDataState.FinishedWithError);
        }
      });
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getConsignee(String? rly, String? orgsubunit, String? unittype, String? unitname, BuildContext context) async {
    setConStatusState(ConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //_consigneeitems.clear();
    if(unittype == "" && unitname == "" && prefs.getString('consigneecode') == "NA") {
      consignee = "All";
      consigneecode = "-1";
      setConsigneelistData(_all());
      Future.delayed(Duration(milliseconds: 1000),() => setConStatusState(ConsigneeDataState.Finished));
    }
    else if(unittype == "" && unitname == "" && prefs.getString('consigneecode') != "NA") {
      try {
        Future<dynamic> data = ValueWiseStockRepo.instance.fetchConsignee(
            prefs.getString('userzone'),
            prefs.getString('orgsubunit'),
            prefs.getString('orgunittype'),
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setConStatusState(ConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setConsigneelistData(value.toSet().toList());
            value.forEach((item) {
              if(item['intcode'].toString() == "-1") {
                consignee = item['value'].toString();
                consigneecode = item['intcode'].toString();
                return;
              }
              else {
                if(item['intcode'].toString() ==  prefs.getString('consigneecode')){
                  consignee = item['intcode'].toString() + "-" + item['value'].toString();
                  consigneecode = item['intcode'].toString();
                  return;
                }
              }
            });
            setConStatusState(ConsigneeDataState.Finished);
          }
          else {
            setConStatusState(ConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setConStatusState(ConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else {
      consignee = "All";
      consigneecode = "-1";
      try {
        Future<dynamic> data = ValueWiseStockRepo.instance.fetchConsignee(
            rly,
            orgsubunit,
            unittype,
            unitname,
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setConStatusState(ConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setConsigneelistData(value.toSet().toList());
            //consignee = "All";
            //consigneecode = "-1";
            // value.forEach((item) {
            //   if(item['intcode'].toString() == "-1"){
            //     consignee = item['value'].toString();
            //     consigneecode = item['intcode'].toString();
            //   }
            //   else{
            //     consignee = item['intcode'].toString()+"-"+item['value'].toString();
            //     consigneecode = item['intcode'].toString();
            //   }
            // });
            setConStatusState(ConsigneeDataState.Finished);
          }
          else {
            setConStatusState(ConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setConStatusState(ConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
  }

  Future<void> getSubConsignee(String? rly, String? orgsubunit, String? unittype, String? unitname, String? userDepot, BuildContext context) async {
    setSubConsigneeStatusState(SubConsigneeDataState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("user depot value $userDepot");
    print("Sub consignee value ${prefs.getString('subconsigneecode')}");
    //_subconsigneeitems.clear();
    if(userDepot == "" && prefs.getString('subconsigneecode') == "NA") {
      print("this is calling now1");
      subconsignee = "All";
      subconsigneecode = "-1";
      setsubConsigneeData(_all());
      Future.delayed(Duration(milliseconds: 1000),() => setSubConsigneeStatusState(SubConsigneeDataState.Finished));
    }
    else if(userDepot == "" && prefs.getString('subconsigneecode') != "NA") {
      print("this is calling now2");
      try {
        Future<dynamic> data = ValueWiseStockRepo.instance.def_fetchSubDepot(
            prefs.getString('userzone'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if(value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if(value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            value.forEach((item) {
              if (item['intcode'].toString() == "-1") {
                subconsignee = item['value'].toString();
                subconsigneecode = item['intcode'].toString();
                return;
              }
              else {
                if(item['intcode'].toString() == prefs.getString('subconsigneecode')){
                  subconsignee = item['intcode'].toString() + "-" + item['value'].toString();
                  subconsigneecode = item['intcode'].toString();
                  return;
                }
              }
            });
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else if(userDepot == "-1" && prefs.getString('subconsigneecode') != "NA") {
      print("this is calling now3");
      subconsignee = "All";
      subconsigneecode = "-1";
      setsubConsigneeData(_all());
      setSubConsigneeStatusState(SubConsigneeDataState.Finished);
    }
    else if(userDepot != "-1" && prefs.getString('subconsigneecode') != "NA") {
      print("this is calling now4");
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = ValueWiseStockRepo.instance.def_fetchSubDepot(
            rly,
            userDepot,
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else if(userDepot != "-1" && prefs.getString('subconsigneecode') == "NA") {
      print("this is calling now5");
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = ValueWiseStockRepo.instance.def_fetchSubDepot(
            rly,
            userDepot,
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
    else {
      print("this is calling now6");
      subconsignee = "All";
      subconsigneecode = "-1";
      try {
        Future<dynamic> data = ValueWiseStockRepo.instance.def_fetchSubDepot(
            rly,
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setSubConsigneeStatusState(SubConsigneeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setsubConsigneeData(value.toSet().toList());
            setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          }
          else {
            setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
          }
        });
      }
      on Exception catch (err) {
        setSubConsigneeStatusState(SubConsigneeDataState.FinishedWithError);
        IRUDMConstants().showSnack(err.toString(), context);
      }
    }
  }

  Future<void> fetchAndStoreItemsListwithdata(railway,unitType,division,department,userDepot
  ,userSubDepot
  ,itemUsage
  ,itemUnit
  ,itemCategory
  ,stkNstk
  ,stkAvl
  ,stkAvlValue,context) async {
    setState(ValueWiseState.Busy);
    countData = 0;
    countVis = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await Network.postDataWithAPIM('UDM/vws/ValueWiseStockResult/V1.0.0/ValueWiseStockResult','ValueWiseStockResult',
          railway+"~"+unitType +"~"+division+"~"+department+"~"+userDepot +
              "~"+ userSubDepot
              +"~"+itemUnit+"~"+itemUsage+"~"+itemCategory+"~"+stkNstk+"~"+stkAvl+"~"+stkAvlValue,prefs.getString('token'));
      if(response.statusCode == 200) {
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<ValueWise>((val) => ValueWise.fromJson(val)).toList();
            storeInDB();
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(ValueWiseState.Finished);
          } else {
            countData=0;

            setState(ValueWiseState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ValueWiseState.FinishedWithError);
          }
        } else {
          setState(ValueWiseState.Idle);
          IRUDMConstants().showSnack('No data found', context);
        //  showInSnackBar("Data not found", context);

        }
      }
      else {
        setState(ValueWiseState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {

      setState(ValueWiseState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      setState(ValueWiseState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      setState(ValueWiseState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(ValueWiseState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchSavedValueViseStock();
    if (query.isNotEmpty) {
      // _items = dbItems.where((row) => row[DatabaseHelper.Tbl10_thresholdlimit].toString().toLowerCase().contains(query.toLowerCase())||row[DatabaseHelper.Tbl10_ledgerfolioplno].toString().toLowerCase().contains(query.toLowerCase())||
      //     row[DatabaseHelper.Tbl10_stkvalue].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl10_ledgerfolioshortdesc].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl10_stkqty].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_ledgerno].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_vs].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_consumind].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_stkunit].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_issueccode].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_stkitem].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl10_issconsgdept].toString().toLowerCase().contains(query.toLowerCase()))
      //     .map<ValueWise>((e) => ValueWise.fromJson(e))
      //     .toList();
      _items = _duplicatesitems!.where((element) => element.pacfirm.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemcat.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.depodetail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueccode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkitem.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issconsgdept.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vs.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consumind.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfoliono.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioplno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioshortdesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lmrdt.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lmidt.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bar.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkunit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.thresholdlimit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      countVis=true;
    }else{
      countVis=false;
      var dbItems = await DatabaseHelper.instance.fetchSavedValueViseStock();
      _items=dbItems.map<ValueWise>((e) => ValueWise.fromJson(e)).toList();
      countData=_items!.length;
    }
    setState(ValueWiseState.Finished);
  }

  _all() {
    var all = [{
      'intcode': '-1',
      'value': 'All',
    }];
    return all;
  }

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;

  }
}
