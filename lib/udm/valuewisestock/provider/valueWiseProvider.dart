import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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

  Future<dynamic> default_data() async {
    debugPrint("Default data calling");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setDefaultDataState(DefaultDataState.Busy);
    itemTypeList.clear();
    itemUsageList.clear();
    itemtCategryaList.clear();
    stockNonStockList.clear();
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbResult = await dbHelper.fetchSaveLoginUser();
    try {
      var d_response = await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue', 'GetListDefaultValue',
          dbResult![0][DatabaseHelper.Tb3_col5_emailid],
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
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            itemTypeList.add(all);
        }
        if(staticDataJson[i]['list_for'] == 'ItemUsage') {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            itemUsageList.add(all);

        }
        if(staticDataJson[i]['list_for'] == 'StockNonStock') {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            stockNonStockList.add(all);

        }
        if (staticDataJson[i]['list_for'] == 'StockAvailability') {
            var all = {
              'intcode': staticDataJson[i]['key'],
              'value': staticDataJson[i]['value'],
            };
            stockAvailability.add(all);
        }
      }
        itemtCategryaList.addAll(itemCatDataJson);

        dropdowndata_UDMUnitType.clear();
        dropdowndata_UDMDivision.clear();
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMRlyList = myList_UDMRlyList; //1
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value'])); //1
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        railway = d_Json[0]['org_zone'];
        department = d_Json[0]['org_subunit_dept'];
        unitname = d_Json[0]['admin_unit'].toString();
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

    } on HttpException {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      //IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }

    setDefaultDataState(DefaultDataState.Finished);
    debugPrint("Default data calling end");
  }

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
    dropdowndata_UDMDivision = unitnamelist;
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

  // --- Consignee Data ---
  // List<dynamic> get consigneelistData => dr;
  // void setConsigneelistData(List<dynamic> conlist) {
  //   _consigneeitems = conlist;
  // }
  // ConsigneeDataState get condatastatus => _consigneeDataState;
  // void setConStatusState(ConsigneeDataState currentState) {
  //   _consigneeDataState = currentState;
  //   notifyListeners();
  // }

  // --- Sub Consignee Data ---
  // List<dynamic> get subconsigneeData => _subconsigneeitems;
  // void setsubConsigneeData(List<dynamic> subconsigneelist) {
  //   _subconsigneeitems = subconsigneelist;
  // }
  // SubConsigneeDataState get subconsigneedatastatus => _subconsigneeDataState;
  // void setSubConsigneeStatusState(SubConsigneeDataState currentState) {
  //   _subconsigneeDataState = currentState;
  //   notifyListeners();
  // }

  Future<void> getRailwaylistData(BuildContext context) async{
    setRlwStatusState(RailwayDataState.Busy);
    //NSDemandSummaryRepo stockHistoryRepository = NSDemandSummaryRepo(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      Future<List<dynamic>> data = ValueWiseStockRepo.instance.fetchrailwaylistData(context);
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
            if(item.intcode.toString() == prefs.getString('userzone')){
              railway = item.value.toString();
              rlyCode = item.intcode.toString();
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
        Future<dynamic> data = ValueWiseStockRepo.instance.def_fetchUnit(
            prefs.getString('userzone'),
            prefs.getString('orgunittype'),
            prefs.getString('orgsubunit'),
            prefs.getString('adminunit'),
            prefs.getString('consigneecode'),
            prefs.getString('subconsigneecode'),
            context);
        data.then((value) {
          if (value.isEmpty || value.length == 0) {
            setUnittypeStatusState(UnittypeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunittypelistData(value);
            value.forEach((item) {
              if (item['intcode'].toString() ==
                  prefs.getString('orgunittype')) {
                unittype = item['value'].toString();
                unittypecode = item['intcode'].toString();
              }
            });
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
          //setConStatusState(ConsigneeDataState.Finished);
          setUnitnameStatusState(UnitnameDataState.Finished);
          setDepartmentStatusState(DepartmentDataState.Finished);
          //setSubConsigneeStatusState(SubConsigneeDataState.Finished);
          if (value.isEmpty || value.length == 0) {
            setUnittypeStatusState(UnittypeDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunittypelistData(value);
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
          if (value.isEmpty || value.length == 0) {
            setUnitnameStatusState(UnitnameDataState.Idle);
            IRUDMConstants().showSnack('Data not found.', context);
          }
          else if (value.isNotEmpty || value.length != 0) {
            setunitnamelistData(value);
            value.forEach((item) {
              if (item['intcode'].toString() == prefs.getString('adminunit')) {
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
            if (item['intcode'].toString() == prefs.getString('orgsubunit')) {
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

  Future<void> fetchAndStoreItemsListwithdata(railway,unitType,division,department,userDepot
  ,userSubDepot
  ,itemUsage
  ,itemUnit
  ,itemCategory
  ,stkNstk
  ,stkAvl
  ,stkAvlValue,context) async {
    setState(ValueWiseState.Busy);
    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await Network.postDataWithAPIM('UDM/vws/ValueWiseStockResult/V1.0.0/ValueWiseStockResult','ValueWiseStockResult',
          railway+"~"+unitType +"~"+division+"~"+department+"~"+userDepot +
              "~"+ userSubDepot
              +"~"+itemUnit+"~"+itemUsage+"~"+itemCategory+"~"+stkNstk+"~"+stkAvl+"~"+stkAvlValue,prefs.getString('token'));
      if (response.statusCode == 200) {
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
      } else {
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
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
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
    }
    ];
    return all;
  }

  Future<dynamic> def_depart_result(String depart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','',prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      var deptData = UDMDept_body['data'];
      var myList_UDMDept = [];
      myList_UDMDept.addAll(deptData);
        dropdowndata_UDMDept = myList_UDMDept; //5
        department = depart;
    } on HttpException {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      //IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }

  Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart, String unitName, String depot, String userSubDep) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var result_UDMUnitType=await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);

      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        //dropdowndata_UDMUnitType.add(getAll());
      } else {
        var unitData = UDMUnitType_body['data'];
        //myList_UDMUnitType.add(getAll());
        setunittypelistData(unitData);
        myList_UDMUnitType.addAll(unitData);
        dropdowndata_UDMUnitType = myList_UDMUnitType; //2
        if (value == '-1') {
          //def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        }
      }
      if(unit_data != "") {
        //def_fetchunitName(value!, unit_data, unitName, depot, depart, userSubDep);
      }
    } on HttpException {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      //IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      //IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }
}
