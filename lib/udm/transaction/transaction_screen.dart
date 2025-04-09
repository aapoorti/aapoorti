import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/transaction/transactionListDataDisplayScreen.dart';
import 'package:flutter_app/udm/transaction/transactionListDataProvider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/folio_no.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = "/transaction-search";
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {



  final _formKey = GlobalKey<FormBuilderState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SharedPreferences prefs;
  late TransactionListDataProvider itemListProvider;

  List dropdowndata_UDMRlyList = [];
  List dropdowndata_UDMUnitType = [];
  List dropdowndata_UDMunitName = [];
  List dropdowndata_UDMDept = [];
  List dropdowndata_UDMUserDepot = [];
  List dropdowndata_UDMUserSubDepot = [];

  List dropdowndata_UDMLedgerNoList = [];
  List dropdowndata_UDMFolioNoList = [];
  List dropdowndata_UDMFolioPLNoList = [];


  String? railway, railwayCode;
  String? unittype, unittypeCode;
  String? unitname, unitnameCode;
  String? department, departmentCode;
  String? userdepot, userdepotCode;
  String? usersubdepot, usersubdepotCode;

  List<FolioNo> folioDynamicData = [];
  late FocusNode myFocusNode;
  String? ledgerNum, ledgerNoCode = "-1";
  String? folioNum, folioNoCode = "-1";
  String? folioPLNum, folioPLNoCode = "-1";

  String fromdate = "";
  String todate = "";


  TextEditingController controller = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  _all() {
    var all = {
      'intcode': '-1',
      'value': 'All',
    };
    return all;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
    fromdate = DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 90)));
    todate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    default_data();
  }

  @override
  Future<void> didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  late List<Map<String, dynamic>> dbResult;

  Future<dynamic> default_data() async {
    Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    dbResult = await dbHelper.fetchSaveLoginUser();
    try {
      var d_response=await Network.postDataWithAPIM('app/Common/GetListDefaultValue/V1.0.0/GetListDefaultValue', 'GetListDefaultValue',
          dbResult[0][DatabaseHelper.Tb3_col5_emailid],
          prefs.getString('token'));

      var d_JsonData = json.decode(d_response.body);
      var d_Json = d_JsonData['data'];
      debugPrint("Default Data $d_Json");
      var result_UDMRlyList = await Network().postDataWithAPIMList('UDMAppList','UDMRlyList','',prefs.getString('token'));
      var UDMRlyList_body = json.decode(result_UDMRlyList.body);
      var rlyData = UDMRlyList_body['data'];
      debugPrint("Railway Data $rlyData");
      var myList_UDMRlyList = [];
      myList_UDMRlyList.addAll(rlyData);

      setState(() {
        dropdowndata_UDMUnitType.clear();
        dropdowndata_UDMunitName.clear();
        dropdowndata_UDMUserDepot.clear();
        dropdowndata_UDMRlyList = myList_UDMRlyList;
        dropdowndata_UDMRlyList.sort((a, b) => a['value'].compareTo(b['value']));
        railway = d_Json[0]['account_name'];
        railwayCode = d_Json[0]['org_zone'];
        unittype = d_Json[0]['unit_type'];
        unittypeCode = d_Json[0]['org_unit_type'];
        unitname = d_Json[0]['unit_name'].toString();
        unitnameCode = d_Json[0]['admin_unit'].toString();
        department = d_Json[0]['dept_name'];
        departmentCode = d_Json[0]['org_subunit_dept'];
        userdepot = "${d_Json[0]['ccode'].toString()}-${d_Json[0]['cname'].toString()}";
        userdepotCode = d_Json[0]['ccode'].toString();
        usersubdepot = "${d_Json[0]['sub_cons_code'].toString()}-${d_Json[0]['sub_user_depot'].toString()}";
        usersubdepotCode = d_Json[0]['sub_cons_code'].toString();
        def_depart_result(d_Json[0]['org_subunit_dept'].toString());
        Future.delayed(Duration(milliseconds: 0), () async {
        def_fetchUnit(
              d_Json[0]['org_zone'],
              d_Json[0]['org_unit_type'].toString(),
              d_Json[0]['org_subunit_dept'].toString(),
              d_Json[0]['admin_unit'].toString(),
              d_Json[0]['ccode'].toString(),
              d_Json[0]['sub_cons_code'].toString());
        });
        IRUDMConstants.removeProgressIndicator(context);
      });
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchUnit(String? value, String unit_data, String depart, String unitName, String depot, String userSubDep) async {
    Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    try {
      var result_UDMUnitType=await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      debugPrint("unit type resp $UDMUnitType_body");
      var myList_UDMUnitType = [];
      if (UDMUnitType_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMUnitType.add(getAll());
          unittypeCode = "-1";
          //def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        });
        IRUDMConstants.removeProgressIndicator(context);
      }
      else {
        var unitData = UDMUnitType_body['data'];
        myList_UDMUnitType.add(getAll());
        myList_UDMUnitType.addAll(unitData);
        setState(() {
          dropdowndata_UDMUnitType = myList_UDMUnitType;
          debugPrint("calling new unit type $myList_UDMUnitType");
        });
        if(value == '-1') {
          //def_fetchunitName(value!, '-1', unitName, depot, depart, userSubDep);
        }
        IRUDMConstants.removeProgressIndicator(context);
      }
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchunitName(String rai, String unit, String unitName_name, String depot, String depart, String userSubDep) async {
    Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    try {
      var result_UDMunitName=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai+"~"+unit,prefs.getString('token'));
      var UDMunitName_body = json.decode(result_UDMunitName.body);
      var myList_UDMunitName = [];
      if (UDMunitName_body['status'] != 'OK') {
        setState(() {
          dropdowndata_UDMunitName.add(getAll());
          unitnameCode = "-1";
          def_fetchDepot(rai, depart.toString(), unit, unitName_name, depot, userSubDep);
        });
        IRUDMConstants.removeProgressIndicator(context);
      } else {
        var divisionData = UDMunitName_body['data'];
        myList_UDMunitName.add(getAll());
        myList_UDMunitName.addAll(divisionData);
        setState(() {
          dropdowndata_UDMunitName = myList_UDMunitName;
        });
        if (unit == '-1') {
          departmentCode = "-1";
          def_fetchDepot(rai, depart.toString(), unit, unitName_name, depot, userSubDep);
        }
        IRUDMConstants.removeProgressIndicator(context);
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_depart_result(String depart) async {
    Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    try {
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','',prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      var deptData = UDMDept_body['data'];
      var myList_UDMDept = [];
      myList_UDMDept.addAll(deptData);
      setState(() {
        dropdowndata_UDMDept = myList_UDMDept;
      });
      IRUDMConstants.removeProgressIndicator(context);
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchDepot(String? rai, String? depart, String? unit_typ, String? Unit_Name, String depot_id, String userSubDep) async {
    Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    try {
      dropdowndata_UDMUserDepot.clear();
      if(depot_id == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserDepot.add(all);
        userdepotCode = "-1";
        //_formKey.currentState!.fields['User Depot']!.setValue('-1');
        def_fetchSubDepot(rai, depot_id, userSubDep);
        IRUDMConstants.removeProgressIndicator(context);
      }
      else {
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
            userdepotCode = "-1";
            //_formKey.currentState!.fields['User Depot']!.setValue('-1');
            def_fetchSubDepot(rai, depot_id, userSubDep);
          });
        } else {
          var depoData = UDMUserDepot_body['data'];
          dropdowndata_UDMUserSubDepot.clear();
          myList_UDMUserDepot.addAll(depoData);
          setState(() {
            dropdowndata_UDMUserDepot = myList_UDMUserDepot;
            if(depot_id != "") {
              userdepotCode = depot_id;
              //_formKey.currentState!.fields['User Depot']!.setValue(depot_id);
              dropdowndata_UDMUserDepot.forEach((item) {
                if(item['intcode'].toString().contains(depot_id.toLowerCase())) {
                  userdepot = item['intcode'].toString() + '-' + item['value'];
                }
              });
              debugPrint("sub depot calling now new");
              def_fetchSubDepot(rai, depot_id, userSubDep);
            }
          });
        }
        IRUDMConstants.removeProgressIndicator(context);
      }
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchSubDepot(String? rai, String? depot_id, String userSDepo) async {
    Future.delayed(Duration.zero, () => IRUDMConstants.showProgressIndicator(context));
    try {
      dropdowndata_UDMUserSubDepot.clear();
      if(userSDepo == 'NA') {
        debugPrint("Fetch sub depot if condition");
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMUserSubDepot.add(all);
       usersubdepotCode = "-1";
       def_fetchLedgerNo(rai, depot_id, userSDepo, '');
        IRUDMConstants.removeProgressIndicator(context);
      } else {
        debugPrint("Fetch sub depot else condition");
        var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UserSubDepot' , rai! + "~" + depot_id!,prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        debugPrint("Fetch sub depot $UDMUserSubDepot_body");
        var myList_UDMUserDepot = [];
        if(UDMUserSubDepot_body['status'] != 'OK') {
          debugPrint("Fetch sub depot internal if condition");
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMUserSubDepot.add(all);
            //_formKey.currentState!.fields['User Sub Depot']!.setValue('-1');
          });
        }
        else {
          debugPrint("Fetch sub depot internal else condition");
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          var subDepotData = UDMUserSubDepot_body['data'];
          myList_UDMUserDepot.add(all);
          myList_UDMUserDepot.addAll(subDepotData);
          setState(() {
            dropdowndata_UDMUserSubDepot = myList_UDMUserDepot;
            // if(userSDepo != "") {
            //   def_fetchLedgerNo(rai, depot_id, userSDepo, '');
            //   usersubdepotCode = userSDepo;
            //   for(int i=0;i<dropdowndata_UDMUserSubDepot.length;i++){
            //     if(userSDepo==dropdowndata_UDMUserSubDepot[i]['intcode']){
            //       setState(() {
            //         usersubdepot = dropdowndata_UDMUserSubDepot[i]['intcode'] + '-' + dropdowndata_UDMUserSubDepot[i]['value'];
            //       });
            //     }
            //   }
            // } else {
            //   usersubdepotCode = '-1';
            // }
          });
        }
      }
      //IRUDMConstants.removeProgressIndicator(context);
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } catch (err) {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
      IRUDMConstants.removeProgressIndicator(context);
    } finally {
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  //--------------------------------------------------//
  Future<dynamic> def_fetchLedgerNo(String? rai, String? depot_id, String? userSDepo, String ledgerNo) async {
    try {
      dropdowndata_UDMLedgerNoList.clear();
      var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList', 'LedgerNo', rai! + "~" + depot_id! + "~" + userSDepo!,prefs.getString('token'));
      var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
      var myList_UDMUserDepot = [];
      if(UDMUserSubDepot_body['status'] != 'OK') {
        debugPrint("ledger number if condition");
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMLedgerNoList.add(all);
          ledgerNoCode = "-1";
        });
      } else {
        debugPrint("ledger number else condition");
        var subDepotData = UDMUserSubDepot_body['data'];
        myList_UDMUserDepot.addAll(subDepotData);
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMLedgerNoList.add(all);
          dropdowndata_UDMLedgerNoList = myList_UDMUserDepot;
          if(ledgerNo != "") {
            dropdowndata_UDMLedgerNoList.forEach((element){
               if(element['intcode'] == ledgerNo){
                 ledgerNum = ledgerNo;
                 ledgerNoCode = ledgerNo;
               }
            });
          } else {
            ledgerNoCode = "-1";
            //_formKey.currentState!.fields['LedgerNo']!.setValue('-1');
          }
        });
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
    }finally {
      IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchFolioNo(String? rai, String? depot_id, String? userSDepo, String? ledgerNo, String? folioNo) async {
    IRUDMConstants.showProgressIndicator(context);
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      dropdowndata_UDMFolioNoList.clear();
      var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList', 'LedgerFolioNo', rai! + "~" + depot_id! + "~" + userSDepo! + "~" + ledgerNo!,prefs.getString('token'));
      var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
      var myList_UDMUserDepot = [];
      if(UDMUserSubDepot_body['status'] != 'OK') {
        debugPrint("folio number if condition");
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMFolioNoList.add(all);
          folioNoCode = "-1";
          folioNum = "All";
          //_formKey.currentState!.fields['FolioNo']!.setValue('-1');
        });
      }
      else {
        debugPrint("folio number else condition");
        var subDepotData = UDMUserSubDepot_body['data'];
        myList_UDMUserDepot.addAll(subDepotData);
        setState(() {
          var all = {
            'intcode': '-1',
            'value': "All",
          };
          dropdowndata_UDMFolioNoList.add(all);
          dropdowndata_UDMFolioNoList = myList_UDMUserDepot;
          debugPrint("folio number $folioNo");
          if(folioNo != "" || folioNo!.isNotEmpty) {
            dropdowndata_UDMFolioNoList.forEach((element){
               if(element['intcode'] == folioNo){
                 folioNum = "${element['intcode']}-${element['value']}";
                 folioNoCode = folioNo;
               }
            });

            //_formKey.currentState!.fields['FolioNo']!.setValue(folioNo);
          } else {
            debugPrint("folio number else condition $folioNo");
            //_formKey.currentState!.fields['FolioNo']!.setValue('-1');
          }
        });
      }
      IRUDMConstants.removeProgressIndicator(context);
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

  Future<dynamic> def_fetchFolioPLNo(String? rai, String? depot_id, String? userSDepo, String? ledgerNo, String? folioNo, String? folioPLNo) async {
    IRUDMConstants.showProgressIndicator(context);
    try {
      dropdowndata_UDMFolioPLNoList.clear();
      if (userSDepo == 'NA') {
        var all = {
          'intcode': '-1',
          'value': "All",
        };
        dropdowndata_UDMFolioPLNoList.add(all);
        folioPLNoCode = "-1";
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList(
            'UDMAppList',
            'LedgerFolioItem',
            rai! +
                "~" +
                depot_id! +
                "~" +
                userSDepo! +
                "~" +
                ledgerNo! +
                "~" +
                folioNo!,prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        var myList_UDMUserDepot = [];
        if (UDMUserSubDepot_body['status'] != 'OK') {
          setState(() {
            var all = {
              'intcode': '-1',
              'value': "All",
            };
            dropdowndata_UDMFolioPLNoList.add(all);
            folioPLNoCode = "-1";
            folioPLNum = "All";
          });
        } else {
          var subDepotData = UDMUserSubDepot_body['data'];
          myList_UDMUserDepot.addAll(subDepotData);
          setState(() {
            dropdowndata_UDMFolioPLNoList = myList_UDMUserDepot;
            if(folioPLNo != "") {
              dropdowndata_UDMFolioPLNoList.forEach((element){
                if(element['intcode'] == folioPLNo){
                  folioPLNum = "${element['intcode']}-${element['value']}";
                  folioPLNoCode = folioPLNo;
                }
              });
              //_formKey.currentState!.fields['LedgerFolioPlNo']!.setValue(folioPLNo);
            } else {
              //  _formKey.currentState!.fields['LedgerFolioPlNo']!.setValue('-1');
            }
          });
        }
      }
      IRUDMConstants.removeProgressIndicator(context);
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

  Future<List?> getFolioData(String query) async {
    IRUDMConstants.showProgressIndicator(context);
    setState(() {
      folioDynamicData.clear();
    });
    debugPrint(jsonEncode({
      'input_type': 'TransactionsLedgerFolioDtls',
      'input': railwayCode! +
          "~" +
          userdepotCode! +
          "~" +
          usersubdepotCode! +
          "~" +
          query
    }));
    try {
      if(userdepot.toString() == "All" || userdepotCode.toString() == "-1") {
        var response = await Network.postDataWithAPIM(
            'UDM/transaction/V1.0.0/transaction',
            'TransactionsLedgerFolioDtls',
            railwayCode! +
                "~" +
                userdepotCode! +
                "~" +
                usersubdepotCode! +
                "~" +
                query,prefs.getString('token'));

        debugPrint(jsonEncode({
          'input_type': 'TransactionsLedgerFolioDtls',
          'input': railway! +
              "~" +
              userdepotCode! +
              "~" +
              usersubdepotCode! +
              "~" +
              query
        }));
        var actionData = json.decode(response.body);
        IRUDMConstants.removeProgressIndicator(context);
        if(actionData['status'] != 'OK') {
          IRUDMConstants().showSnack("No Data Found", context);
        }
        else {
          if(response.statusCode == 200) {
            var data = actionData['data'];
            var users = data.map<FolioNo>((json) => FolioNo.fromJson(json)).toList();
            setState(() {
              folioDynamicData.addAll(users);
            });
            return users;
          } else {
            throw Exception('Failed to load post');
          }
        }
      }
      else{
        var response = await Network.postDataWithAPIM('UDM/transaction/V1.0.0/transaction', 'TransactionsLedgerFolioDtls', railwayCode! + "~" + userdepotCode! + "~" + usersubdepotCode! + "~" + query,prefs.getString('token'));
        debugPrint("resp $response");
        debugPrint(jsonEncode({
          'input_type': 'TransactionsLedgerFolioDtls',
          'input': railwayCode! +
              "~" +
              userdepotCode! +
              "~" +
              usersubdepotCode! +
              "~" +
              query
        }));
        var actionData = json.decode(response.body);
        debugPrint("resp $actionData");
        IRUDMConstants.removeProgressIndicator(context);
        if(actionData['status'] != 'OK') {IRUDMConstants().showSnack("No Data Found", context);
        }
        else {
          if (response.statusCode == 200) {
            var data = actionData['data'];
            var users = data.map<FolioNo>((json) => FolioNo.fromJson(json)).toList();
            setState(() {
              folioDynamicData.addAll(users);
              //FocusScope.of(context).requestFocus(FocusNode());
            });
            return users;
          } else {
            throw Exception('Failed to load post');
          }
        }
      }
    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
      //  IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    return null;
  }


  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  Future<void> resetForm() async{
    default_data();
    setState(() {
      _controller.text = '';
      dropdowndata_UDMLedgerNoList.clear();
      dropdowndata_UDMFolioNoList.clear();
      dropdowndata_UDMFolioPLNoList.clear();
      ledgerNum = null; ledgerNoCode = "-1";
      folioNum = null; folioNoCode = "-1";
      folioPLNum = null; folioPLNoCode = "-1";
      fromdate = DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 90)));
      todate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
       key: _scaffoldKey,
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
        title: Text(Provider.of<LanguageProvider>(context).text('transaction'), style: TextStyle(color: Colors.white)),
         actions: [
           IconButton(
             icon: const Icon(Icons.home, color: Colors.white, size: 22),
             onPressed: () {
               Navigator.of(context).pop();
               //Feedback.forTap(context);
             },
           ),
         ],
      ),
       body: Container(
         height: size.height,
         width: size.width,
         child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownSearch<String>(
                      selectedItem: railway ?? 'All',
                      items: (filter, loadProps) => dropdowndata_UDMRlyList.map((item) {
                        return item['intcode'].toString() == '-1' ? "All" : item['value'].toString().trim();
                      }).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Railway',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 450)),
                      onChanged: (newValue){
                        dropdowndata_UDMRlyList.forEach((element){
                          if(newValue.toString() == element['value'].toString()){
                            try {
                              setState(() {
                                railway = element['value'].toString().trim();
                                railwayCode = element['intcode'].toString();
                                dropdowndata_UDMUnitType.clear();
                                dropdowndata_UDMunitName.clear();
                                //dropdowndata_UDMDept.clear();
                                dropdowndata_UDMUserDepot.clear();
                                dropdowndata_UDMUserSubDepot.clear();

                                dropdowndata_UDMUnitType.add(_all());
                                dropdowndata_UDMunitName.add(_all());
                                //dropdowndata_UDMDept.add(_all());
                                dropdowndata_UDMUserDepot.add(_all());
                                dropdowndata_UDMUserSubDepot.add(_all());

                                unittype = "All";
                                unitname = "All";
                                department = "All";
                                userdepot = "All";
                                usersubdepot = "All";

                                unittypeCode = "-1";
                                unitnameCode = "-1";
                                departmentCode = "-1";
                                userdepotCode = "-1";
                                usersubdepotCode = '-1';
                              });
                            } catch (e) {
                              debugPrint("execption" + e.toString());
                            }
                            def_fetchUnit(railwayCode, '', '', '', '', '');
                          }
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    DropdownSearch<String>(
                      selectedItem: unittype ?? 'All',
                      items: (filter, loadProps) => dropdowndata_UDMUnitType.map((item) {
                        return item['intcode'].toString() == '-1' ? "All" : item['value'].toString().trim();
                      }).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Unit Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 450)),
                      onChanged: (newValue) {
                        dropdowndata_UDMUnitType.forEach((element) {
                          if(newValue.toString() == element['value'].toString()){
                            try {
                              setState(() {
                                unittype = element['value'].toString().trim();
                                unittypeCode = element['intcode'].toString();
                                //dropdowndata_UDMUnitType.clear();
                                dropdowndata_UDMunitName.clear();
                                //dropdowndata_UDMDept.clear();
                                dropdowndata_UDMUserDepot.clear();
                                dropdowndata_UDMUserSubDepot.clear();

                                //dropdowndata_UDMUnitType.add(_all());
                                dropdowndata_UDMunitName.add(_all());
                                //dropdowndata_UDMDept.add(_all());
                                dropdowndata_UDMUserDepot.add(_all());
                                dropdowndata_UDMUserSubDepot.add(_all());

                                //unittype = "All";
                                unitname = "All";
                                department = "All";
                                userdepot = "All";
                                usersubdepot = "All";

                                //unittypeCode = "-1";
                                unitnameCode = "-1";
                                departmentCode = "-1";
                                userdepotCode = "-1";
                                usersubdepotCode = '-1';
                              });
                            } catch (e) {
                              debugPrint("execption" + e.toString());
                            }
                          }
                        });
                        def_fetchunitName(railwayCode!, unittypeCode!, '', '', '', '');
                      },
                    ),
                    SizedBox(height: 15.0),
                    DropdownSearch<String>(
                      selectedItem: unitname ?? 'All',
                      items: (filter, loadProps) => dropdowndata_UDMunitName.map((item) {
                        return item['intcode'].toString() == '-1' ? "All" : item['value'].toString().trim();
                      }).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Unit Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 450)),
                      onChanged: (newValue){
                        dropdowndata_UDMunitName.forEach((element) {
                          if(newValue.toString() == element['value'].toString()){
                            try {
                              setState(() {
                                unitname = element['value'].toString().trim();
                                unitnameCode = element['intcode'].toString();
                                //dropdowndata_UDMUnitType.clear();
                                //dropdowndata_UDMunitName.clear();
                                //dropdowndata_UDMDept.clear();
                                dropdowndata_UDMUserDepot.clear();
                                dropdowndata_UDMUserSubDepot.clear();

                                //dropdowndata_UDMUnitType.add(_all());
                                //dropdowndata_UDMunitName.add(_all());
                                //dropdowndata_UDMDept.add(_all());
                                dropdowndata_UDMUserDepot.add(_all());
                                dropdowndata_UDMUserSubDepot.add(_all());

                                //unittype = "All";
                                //unitname = "All";
                                department = "All";
                                userdepot = "All";
                                usersubdepot = "All";

                                //unittypeCode = "-1";
                                //unitnameCode = "-1";
                                departmentCode = "-1";
                                userdepotCode = "-1";
                                usersubdepotCode = '-1';
                              });
                            } catch (e) {
                              debugPrint("execption" + e.toString());
                            }
                          }
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    DropdownSearch<String>(
                      selectedItem: department ?? 'All',
                      items: (filter, loadProps) => dropdowndata_UDMDept.map((item) {
                        return item['intcode'].toString() == '-1' ? "All" : item['value'].toString().trim();
                      }).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Department',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 450)),
                      onChanged: (newValue){
                        dropdowndata_UDMDept.forEach((element) {
                          if(newValue.toString() == element['value'].toString()){
                            try {
                              setState(() {
                                department = element['value'].toString().trim();
                                departmentCode = element['intcode'].toString();
                              });
                            } catch (e) {
                              debugPrint("execption" + e.toString());
                            }
                          }
                        });
                        def_fetchDepot(railwayCode, departmentCode, unittypeCode, unitnameCode, '', '');
                      },
                    ),
                    SizedBox(height: 15.0),
                    DropdownSearch<String>(
                      selectedItem: userdepot ?? 'All',
                      items: (filter, loadProps) => dropdowndata_UDMUserDepot.map((item) {
                        return item['intcode'].toString() == '-1' ? "All" : "${item['intcode'].toString()}-${item['value'].toString().trim()}";
                      }).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'User Depot',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 450)),
                      onChanged: (newValue){
                        dropdowndata_UDMUserDepot.forEach((element) {
                          debugPrint("newvavav $newValue");
                          debugPrint("newvavav1 ${element['value']}");
                          if(newValue.toString().trim() == "${element['intcode'].toString().trim()}-${element['value'].toString().trim()}"){
                            try {
                              setState(() {
                                userdepot = element['value'].toString().trim();
                                userdepotCode = element['intcode'].toString().trim();
                                dropdowndata_UDMUserSubDepot.clear();

                                //dropdowndata_UDMUnitType.add(_all());
                                //dropdowndata_UDMunitName.add(_all());
                                //dropdowndata_UDMDept.add(_all());
                                //dropdowndata_UDMUserDepot.add(_all());
                                dropdowndata_UDMUserSubDepot.add(_all());

                                //unittype = "All";
                                //unitname = "All";
                                //department = "All";
                                //userdepot = "All";
                                usersubdepot = "All";

                                //unittypeCode = "-1";
                                //unitnameCode = "-1";
                                //departmentCode = "-1";
                                //userdepotCode = "-1";
                                usersubdepotCode = '-1';
                              });
                            } catch (e) {
                              debugPrint("execption" + e.toString());
                            }
                          }
                        });
                        debugPrint("$railwayCode  ....   $userdepotCode");
                        def_fetchSubDepot(railwayCode, userdepotCode, '');
                      },
                    ),
                    SizedBox(height: 15.0),
                    DropdownSearch<String>(
                      selectedItem: usersubdepot ?? 'All',
                      items: (filter, loadProps) => dropdowndata_UDMUserSubDepot.map((item) {
                        return item['intcode'].toString() == '-1' ? "All" : "${item['intcode'].toString()}-${item['value'].toString().trim()}";
                      }).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'User Sub Depot',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 450)),
                      onChanged: (newValue){
                        dropdowndata_UDMUserSubDepot.forEach((element) {
                          if(newValue.toString().trim() == "${element['intcode'].toString().trim()}-${element['value'].toString().trim()}"){
                            try {
                              setState(() {
                                usersubdepot = element['value'].toString().trim();
                                usersubdepotCode = element['intcode'].toString().trim();
                              });
                            } catch (e) {
                              debugPrint("execption" + e.toString());
                            }
                          }
                        });
                        def_fetchLedgerNo(railwayCode, userdepotCode, usersubdepotCode, '');
                      },
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: TextField(
                        controller: _controller,
                        enableInteractiveSelection: true, // will disable paste operation
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: language.text('searchPLItemFolioDesc'),
                          hintText: language.text('searchPLItemFolioDescHint'),
                          contentPadding: EdgeInsetsDirectional.all(10),
                          border: const OutlineInputBorder(),
                        ),
                        onTap: () {
                          folioDynamicData.clear();
                          controller.text = '';
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Material(
                                  child: setupAlertDialoadContainer(_scaffoldKey.currentContext),
                                );
                              });
                        },
                      ),
                    ),
                    SizedBox(height: 15.0),
                    DropdownSearch<String>(
                      selectedItem: ledgerNum ?? 'Ledger No.',
                      items: (filter, loadProps) => dropdowndata_UDMLedgerNoList.map((item) {
                        return item['intcode'].toString() == '-1' ? "All" : "${item['intcode'].toString()}-${item['value'].toString().trim()}";
                      }).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Ledger No',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 450)),
                      onChanged: (newValue){
                        dropdowndata_UDMLedgerNoList.forEach((element) {
                          if(newValue.toString().trim() == "${element['intcode'].toString().trim()}-${element['value'].toString().trim()}"){
                            try {
                              setState(() {
                                ledgerNum = element['value'].toString().trim();
                                ledgerNoCode = element['intcode'].toString().trim();
                                //usersubdepotCode = element['intcode'].toString();
                              });
                            } catch (e) {
                              debugPrint("execption" + e.toString());
                            }
                          }
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    DropdownSearch<String>(
                      selectedItem: folioNum ?? 'Folio No.',
                      items: (filter, loadProps) => dropdowndata_UDMFolioNoList.map((item) {
                        return item['intcode'].toString() == '-1' ? "All" : "${item['intcode'].toString()}-${item['value'].toString().trim()}";
                      }).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Folio No',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 450)),
                      onChanged: (newValue){
                        dropdowndata_UDMFolioNoList.forEach((element) {
                          if(newValue.toString() == "${element['intcode'].toString().trim()}-${element['value'].toString()}"){
                            try {
                              setState(() {
                                folioNum = element['value'].toString().trim();
                                folioNoCode = element['intcode'].toString().trim();
                              });
                            } catch (e) {
                              debugPrint("execption" + e.toString());
                            }
                          }
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    DropdownSearch<String>(
                      selectedItem: folioPLNum ?? 'Ledger Folio PL No.',
                      items: (filter, loadProps) => dropdowndata_UDMFolioPLNoList.map((item) {
                        return item['intcode'].toString() == '-1' ? "All" : "${item['intcode'].toString()}-${item['value'].toString().trim()}";
                      }).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: 'Ledger Folio PL No',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 450)),
                      onChanged: (newValue){
                        dropdowndata_UDMFolioPLNoList.forEach((element) {
                          if(newValue.toString() == element['value'].toString()){
                            try {
                              setState(() {
                                folioPLNum = element['value'].toString().trim();
                                folioPLNoCode = element['intcode'].toString().trim();
                              });
                            } catch (e) {
                              debugPrint("execption" + e.toString());
                            }
                          }
                        });
                      },
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            name: 'From Date',
                            lastDate: DateTime.now(),
                            initialDate:
                            DateTime.now().subtract(const Duration(days: 90)),
                            initialValue:
                            DateTime.now().subtract(const Duration(days: 90)),
                            inputType: InputType.date,
                            format: DateFormat('dd-MM-yyyy'),
                            decoration: InputDecoration(
                              labelText: language.text('fromDate'),
                              hintText: language.text('fromDate'),
                              contentPadding: EdgeInsetsDirectional.all(10),
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (datevalue) {
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              fromdate = formatter.format(datevalue!);
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: FormBuilderDateTimePicker(
                            name: 'To Date',
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            initialValue: DateTime.now(),
                            inputType: InputType.date,
                            format: DateFormat('dd-MM-yyyy'),
                            decoration: InputDecoration(
                              labelText: language.text('toDate'),
                              hintText: language.text('toDate'),
                              contentPadding: EdgeInsetsDirectional.all(10),
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (datevalue) {
                              final DateFormat formatter = DateFormat('dd-MM-yyyy');
                              todate = formatter.format(datevalue!);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionListDataDisplayScreen(
                                railwayCode!,
                                unittypeCode!,
                                unitnameCode!,
                                departmentCode!,
                                userdepotCode!,
                                usersubdepotCode!,
                                ledgerNoCode!,
                                folioNoCode!,
                                folioPLNoCode!,
                                fromdate,
                                todate
                            )));
                          },
                          child: Container(
                            height: 50,
                            width: 160,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            alignment: Alignment.center,
                            child: Text(language.text('getDetails'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                             resetForm();
                          },
                          child: Container(
                            width: 160,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            alignment: Alignment.center,
                            child: Text(
                                language.text('reset'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
         ),
       ),
    );
  }

  Widget setupAlertDialoadContainer(context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 50, left: 10, right: 10, top: 50),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(language.text('searchPLItemFolioDescHint')),
          ),
          Card(
            elevation: 8,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: myFocusNode,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      contentPadding: EdgeInsetsDirectional.all(10),
                    ),
                  ),
                ),
                Container(
                  height: 47,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // foreground
                    ),
                    onPressed: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
                      if(providedTime.isBefore(DateTime.now())){
                        await fetchToken(context);
                        getFolioData(controller.text);
                      }
                      else{
                        getFolioData(controller.text);
                      }
                    },
                    child: Row(
                      children: [
                        Text('Fetch',style: TextStyle(fontSize:18),),
                        SizedBox(width: 3,),
                        Icon(Icons.arrow_forward_outlined,size: 20,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: listViewWidget(folioDynamicData),
            ),
          ),
        ],
      ),
    );
  }

  Widget listViewWidget(List<FolioNo> article) {
    return Container(
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: ScrollPhysics(),
        itemCount: article.length,
        itemBuilder: (context, position) {
          return GestureDetector(
              child: Container(
                  padding: EdgeInsets.only(left: 6, top: 9, right: 6, bottom: 9),
                  child: Text(
                    article[position].ledgername! + ': (' + article[position].ledgerfolioshortdesc! + ' #' + article[position].ledgerkey!,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      wordSpacing: 1,
                      height: 1.2,
                    ),
                  )),
              onTap: () {
                ledgerNum = "${article[position].ledgerno!}-${article[position].ledgername!}";
                ledgerNoCode = article[position].ledgerno!;
                _controller.text = article[position].ledgername! + ': (' + article[position].ledgerfolioshortdesc! + ' #' + article[position].ledgerkey!;
                Navigator.pop(context);
                def_fetchFolioNo(
                    railwayCode,
                    userdepotCode,
                    usersubdepotCode!,
                    article[position].ledgerno,
                    article[position].ledgerfoliono);
                def_fetchFolioPLNo(
                    railwayCode,
                    userdepotCode,
                    usersubdepotCode!,
                    article[position].ledgerno,
                    article[position].ledgerfoliono,
                    article[position].ledgerfolioplno);
              });
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 3,
            color: Colors.black87,
          );
        },
      ),
    );
  }
}
