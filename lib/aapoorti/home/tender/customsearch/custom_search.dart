import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../udm/helpers/wso2token.dart';
import 'custom_search_view.dart';

class CustomSearch extends StatefulWidget {
  @override
  CustomSearchState createState() => CustomSearchState();
}

class CustomSearchState extends State<CustomSearch> {
  String content = "";
  TextEditingController searchcriteriaController = TextEditingController();
  ProgressDialog? pr;

  int countersc = 1;
  String counterwk = "PT";
  int counter = 1;
  DateTime? selected;
  double? width, height;
  var padding;

  List dataRly = [];
  List dataZone = [];
  List dataUnit = [];
  List dataDept = [];

  String? orgName, orgCode = "-1";
  String? zoneName, zoneCode = "-1;-1";
  String? deptName, deptCode = "-1";
  String? unitName, unitCode = "-1";
  String? workArea = "PT";

  navigate() async {
    try {
      if (closingDate.difference(uploadingDate).inDays > 30) {
        AapoortiUtilities.showInSnackBar(
            context, "Select Tender Date Criteria Maximum difference 30 days");
      } else {
        debugPrint(zoneCode);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Custom_search_view(
                  workarea: counterwk,
                  SearchForstring: searchcriteriaController.text.trim(),
                  RailZoneIn: '${zoneCode!.split(";").first.trim()}',
                  Dt1In: DateFormat('dd/MMM/yyyy')
                      .format(uploadingDate)
                      .toString(),
                  Dt2In:
                      DateFormat('dd/MMM/yyyy').format(closingDate).toString(),
                  searchOption: countersc.toString(),
                  OrgCode: orgCode.toString(),
                  ClDate: counter.toString(),
                  dept: deptCode.toString(),
                  unit: unitCode.toString()),
            ));
      }
    } catch (ex) {
      debugPrint('SharedProfile ' + ex.toString());
    }
  }

  void dispose() {
    searchcriteriaController.dispose();
    super.dispose();
  }

  _progressShow() {
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr!.show();
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        debugPrint(isHidden.toString());
      });
    });
  }

  // Future<void> fetchPost() async {
  //   try {
  //     _progressShow();
  //     var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
  //     final response = await http.post(Uri.parse(u));
  //     List<dynamic>? rlyData = json.decode(response.body);
  //     if(response.statusCode != 200) throw new Exception('HTTP request failed, statusCode: ${response.statusCode}');
  //     setState(() {
  //       if(rlyData!.isNotEmpty) dataRly = rlyData;
  //     });
  //     _progressHide();
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     _progressHide();
  //   }
  // }
  //
  // Future<void> getZone() async {
  //   try {
  //     debugPrint('Fetching from service' +orgCode!+ "     ----" + zoneCode!);
  //     dataZone.clear();
  //     _progressShow();
  //     var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${orgCode}';
  //     final response = await http.post(Uri.parse(v));
  //     debugPrint("GetZone response $response");
  //     List<dynamic>? zoneResult = json.decode(response.body);
  //     if(response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
  //     debugPrint("GetZone jsonresult $zoneResult");
  //     zoneCode = "-1;-1";
  //     setState(() {
  //       if(zoneResult!.isNotEmpty) dataZone = zoneResult;
  //     });
  //     debugPrint('after Fetching from service' + orgCode! + "     ----" + zoneCode!);
  //     _progressHide();
  //   } catch (e) {
  //     debugPrint("GetZone exception ${e.toString()}");
  //     _progressHide();
  //   }
  // }
  //
  // Future<void> getDept() async {
  //   debugPrint("orgcode $orgCode");
  //   debugPrint("zone code ${zoneCode!.substring(zoneCode!.indexOf(';') + 1)}  ....... ${zoneCode!}");
  //   try {
  //     dataDept.clear();
  //     _progressShow();
  //     var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,DEPARTMENT,${orgCode!},${zoneCode!.substring(zoneCode!.indexOf(';') + 1)}';
  //     debugPrint("Department url $u");
  //     final response = await http.post(Uri.parse(u));
  //     List<dynamic>? deptResult = json.decode(response.body);
  //     debugPrint("Department data $deptResult");
  //     if(deptResult.toString().trim() == "[{ErrorCode: 4}]"){
  //       dataDept = [{"NAME": "All Departments", "ID" : "-1"}];
  //       _progressHide();
  //     }
  //     else{
  //       if(json.decode(response.body) == null || response.statusCode != 200) throw new Exception('HTTP request failed, statusCode: ${response.statusCode}');
  //       deptCode = "-1";
  //       setState(() {
  //         if(deptResult!.isNotEmpty) dataDept = deptResult;
  //       });
  //       _progressHide();
  //     }
  //
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
  //
  // Future<void> getUnit() async {
  //   try {
  //     dataUnit.clear();
  //     var v;
  //     if((zoneCode!.substring(zoneCode!.indexOf(';') + 1) == "-1") || (deptCode == "-1")) {
  //       v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,UNIT,-2,-2,-2,-1';
  //     } else if((zoneCode!.substring(zoneCode!.indexOf(';') + 1) != "-1") || (deptCode != "-1")) {
  //       v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,UNIT,${orgCode},${zoneCode!.substring(zoneCode!.indexOf(';') + 1)},${deptCode},';
  //     }
  //     _progressShow();
  //     final response = await http.post(Uri.parse(v));
  //     debugPrint("unit resp ${json.decode(response.body)}");
  //     if(response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
  //     List<dynamic>? unitResult = json.decode(response.body);
  //     if(unitResult.toString().trim() == "[{ErrorCode: 4}]"){
  //       dataUnit = [{"NAME": "ALL", "ID": -1}];
  //     }
  //     unitCode = "-1";
  //     setState(() {
  //       if(unitResult!.isNotEmpty) dataUnit = unitResult;
  //     });
  //     _progressHide();
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  String selectedWorkArea = 'Goods & Services';
  String selectedDateType = 'uploading';
  DateTime closingDate = DateTime.now().add(Duration(days: 30));
  DateTime uploadingDate = DateTime.now();
  bool showTenderNo = false;
  bool showItemDesc = false;

  void resetForm() {
    setState(() {
      showTenderNo = false;
      showItemDesc = false;
      selectedWorkArea = 'Goods & Services';
      selectedDateType = 'uploading';
      closingDate = DateTime.now().add(Duration(days: 30));
      uploadingDate = DateTime.now();

      searchcriteriaController.text = "";

      countersc = 1;
      counterwk = "PT";
      counter = 1;

      orgCode = "-1";
      zoneCode = "-1;-1";
      deptCode = "-1";
      unitCode = "-1";
      orgName = null;
      zoneName = null;
      deptName = null;
      unitName = null;

      dataZone.clear();
      dataUnit.clear();
      dataDept.clear();

      closingDate = DateTime.now().add(Duration(days: 30));
      uploadingDate = DateTime.now();
    });
  }

  Future<void> fetchOrganisation() async {
    //debugPrint("Parameter $demandType~$fromDate~$toDate~$deptCode~$statusCode~$demandnum~05~98");
    _progressShow();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url =
          Uri.parse("${AapoortiConstants.webirepsServiceUrl}P4/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json
          .encode({"input_type": "ORGANIZATION", "input": "", "key_ver": "V1"});
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response organisation ${json.decode(response.body)}");
      if (response.statusCode == 200 &&
          json.decode(response.body)['status'] == 'Success') {
        dataRly.clear();
        var listdata = json.decode(response.body);
        if (listdata['status'] == 'Success') {
          var listJson = listdata['data'];
          if (listJson != null) {
            setState(() {
              dataRly = listJson;
            });
          } else {
            setState(() {
              dataRly = [];
            });
          }
        }
        _progressHide();
      } else {
        dataRly.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
        _progressHide();
      }
    } on Exception {
      _progressHide();
    }
  }

  Future<void> fetchZone(String orgCode) async {
    _progressShow();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url =
          Uri.parse("${AapoortiConstants.webirepsServiceUrl}P4/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json
          .encode({"input_type": "ZONE", "input": orgCode, "key_ver": "V1"});
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response zone ${json.decode(response.body)}");
      if (response.statusCode == 200 &&
          json.decode(response.body)['status'] == 'Success') {
        dataZone.clear();
        var listdata = json.decode(response.body);
        if (listdata['status'] == 'Success') {
          var listJson = listdata['data'];
          if (listJson != null) {
            setState(() {
              dataZone = listJson;
            });
          } else {
            setState(() {
              dataZone = [];
            });
          }
        }
        _progressHide();
      } else {
        dataZone.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
        _progressHide();
      }
    } on Exception {
      _progressHide();
    }
  }

  Future<void> fetchDepartment(String orgCode, String zoneCode) async {
    debugPrint("fetch Dept $orgCode ${zoneCode.split(";").first}");
    _progressShow();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url =
          Uri.parse("${AapoortiConstants.webirepsServiceUrl}P4/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode(
          {"input_type": "DEPARTMENT", "input": "$orgCode", "key_ver": "V1"});
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response Department ${json.decode(response.body)}");
      if (response.statusCode == 200 &&
          json.decode(response.body)['status'] == 'Success') {
        dataDept.clear();
        var listdata = json.decode(response.body);
        if (listdata['status'] == 'Success') {
          var listJson = listdata['data'];
          if (listJson != null) {
            setState(() {
              dataDept = listJson;
            });
          } else {
            setState(() {
              dataDept = [];
            });
          }
        }
        _progressHide();
      } else {
        dataDept.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
        _progressHide();
      }
    } on Exception {
      _progressHide();
    }
  }

  Future<void> fetchUnit(
      String orgCode, String orgZone, String orgDept, String unittypeid) async {
    _progressShow();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url =
          Uri.parse("${AapoortiConstants.webirepsServiceUrl}P4/V1/GetData");
      debugPrint("$orgCode~$orgZone~$orgDept~$unittypeid");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type": "UNIT",
        "input": "$orgCode~${zoneCode!.split(";").last}~$orgDept~$unittypeid",
        "key_ver": "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response Unit ${json.decode(response.body)}");
      if (response.statusCode == 200 &&
          json.decode(response.body)['status'] == 'Success') {
        dataUnit.clear();
        var listdata = json.decode(response.body);
        if (listdata['status'] == 'Success') {
          var listJson = listdata['data'];
          if (listJson != null) {
            setState(() {
              unitName = null;
              dataUnit = listJson;
            });
          } else {
            setState(() {
              unitName = null;
              dataUnit = [];
            });
          }
        }
        _progressHide();
      } else {
        dataUnit.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
        _progressHide();
      }
    } on Exception {
      _progressHide();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
      if (providedTime.isBefore(DateTime.now())) {
        await fetchToken(context);
        fetchOrganisation();
      } else {
        fetchOrganisation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Custom Search",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: AapoortiConstants.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.home, color: Colors.white, size: 22),
        //     onPressed: () {
        //       Navigator.of(context, rootNavigator: true).pop();
        //     },
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchOrganisation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Search Criteria",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              SizedBox(height: 12),
              Row(
                children: [
                  if (!showTenderNo)
                    Expanded(
                      child: _buildExpandableButton(
                        title: "Tender No",
                        onPressed: () {
                          setState(() {
                            showTenderNo = true;
                            showItemDesc = false;
                            countersc = 1;
                          });
                        },
                      ),
                    ),
                  if (!showTenderNo && !showItemDesc) SizedBox(width: 8),
                  if (!showItemDesc)
                    Expanded(
                      child: _buildExpandableButton(
                        title: "Item Desc",
                        onPressed: () {
                          setState(() {
                            showItemDesc = true;
                            showTenderNo = false;
                            countersc = 2;
                          });
                        },
                      ),
                    ),
                ],
              ),
              if (showTenderNo || showItemDesc)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showTenderNo) ...[
                      SizedBox(height: 8),
                      _buildTextField("Enter Tender No"),
                    ],
                    if (showItemDesc) ...[
                      SizedBox(height: 8),
                      _buildTextField("Enter Item Description"),
                    ],
                    SizedBox(height: 12),
                  ],
                ),
              SizedBox(height: 16),
              Text(
                "Select Work Area",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              _buildWorkAreaSelection(),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0)),
              Container(
                margin: EdgeInsets.only(
                    top: 10.0, left: 10, right: 10, bottom: 10.0),
                child: DropdownSearch<String>(
                    selectedItem: orgName ?? "Select Organization",
                    // items: (filter, loadProps) => dataRly.map((e) {
                    //     return e['NAME'].toString().trim();
                    //   }).toList(),
                    items: (filter, loadProps) => dataRly.map((e) {
                          return e['key1'].toString().trim();
                        }).toList(),
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        //labelText: "Organization",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        prefixIcon: Icon(Icons.list, color: Colors.blue[800]),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                        fit: FlexFit.loose,
                        showSearchBox: true,
                        constraints: BoxConstraints(maxHeight: 400)),
                    onChanged: (String? newValue) {
                      debugPrint("Select Organization test $newValue");
                      try {
                        setState(() {
                          zoneCode = "-1;-1";
                          deptCode = "-1";
                          unitCode = "-1";
                          dataZone.clear();
                          dataDept.clear();
                          dataUnit.clear();
                          dataRly.forEach((element) {
                            if (newValue.toString() ==
                                element['key1'].toString()) {
                              orgName = newValue.toString();
                              orgCode = element['key2'].toString();
                            }
                          });
                          // dataRly.forEach((element) {
                          //   if(newValue.toString() == element['NAME'].toString()) {
                          //     orgName = newValue.toString();
                          //     orgCode = element['ID'].toString();
                          //   }
                          // });
                          debugPrint("orgname $orgName  orgcode $orgCode");
                        });
                      } catch (e) {
                        debugPrint("execption resp " + e.toString());
                      }
                      //getZone();
                      fetchZone(orgCode!);
                    }),
              ),
              //_buildOrganisationDropdown(),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0)),
              //_buildRlyDropdown(),
              orgCode == null || orgCode == "-1"
                  ? InkWell(
                      onTap: () {
                        AapoortiUtilities.showInSnackBar(
                            context, "Please select organization");
                      },
                      child: Container(
                        width: size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey[800]!)),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.only(
                            top: 10.0, left: 10, right: 10, bottom: 10),
                        child: Row(
                          children: [
                            Icon(Icons.train, color: Colors.blue[800]),
                            SizedBox(width: 10),
                            Text(zoneName ?? "Select Zone",
                                style: TextStyle(color: Colors.black)),
                            SizedBox(width: 10),
                            Spacer(),
                            Icon(Icons.arrow_drop_down,
                                size: 24, color: Colors.grey[800]),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                          top: 10.0, left: 10, right: 10, bottom: 10),
                      child: DropdownSearch<String>(
                        selectedItem: zoneName ?? "Select Zone",
                        // items: (filter, loadProps) => dataZone.map((e) {
                        //   return e['NAME'].toString().trim();
                        // }).toList(),
                        items: (filter, loadProps) => dataZone.map((e) {
                          return e['key1'].toString().trim();
                        }).toList(),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            //labelText: "Zone",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            prefixIcon:
                                Icon(Icons.train, color: Colors.blue[800]),
                          ),
                        ),
                        popupProps: PopupProps.menu(
                            fit: FlexFit.loose,
                            showSearchBox: true,
                            constraints: BoxConstraints(maxHeight: 400)),
                        onChanged: (newVal) async{
                          setState(() {
                            deptCode = "-1";
                            unitCode = "-1";
                            deptName = null;
                            unitName = null;
                            dataDept.clear();
                            dataUnit.clear();
                            dataZone.forEach((element) {
                              if(newVal.toString() == element['key1'].toString()) {
                                zoneCode = element['key3'].toString() + ";" + element['key2'].toString();
                                zoneName = newVal.toString();

                                debugPrint("zone code nsnns $zoneCode");
                              }
                              debugPrint("zone code nanna $zoneCode");
                            });
                          });
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
                          if(providedTime.isBefore(DateTime.now())){
                            await fetchToken(context);
                            fetchDepartment(orgCode!, zoneCode!);
                          }
                          else{
                            fetchDepartment(orgCode!, zoneCode!);
                          }
                        },
                      ),
                    ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0)),
              //_buildDepDropdown(),
              Container(margin: EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10), child: DropdownSearch<String>(
                selectedItem: deptName ?? "Select Department",
                items: (filter, loadProps) => dataDept.map((e) {
                  return e['key1'].toString().trim();
                }).toList(),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    //labelText: "Department",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)
                    ),
                    prefixIcon: Icon(Icons.account_balance, color: Colors.blue[800]),
                  ),
                ),
                popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 400)),
                onChanged: (newVal) async{
                  setState(() {
                    dataUnit.clear();
                    dataDept.forEach((element){
                      if(newVal.toString() == element['key1'].toString()) {
                        deptCode = element['key2'].toString();
                        deptName = newVal.toString();
                      }
                    });
                  });
                  if(deptCode == "-1"){
                    setState(() {
                      unitCode = "-1";
                      unitName = "All";
                    });
                  }
                  else{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
                    if(providedTime.isBefore(DateTime.now())){
                      await fetchToken(context);
                      fetchUnit(orgCode!, zoneCode!, deptCode!, "-1");
                    }
                    else{
                      fetchUnit(orgCode!, zoneCode!, deptCode!, "-1");
                    }
                  }
                },
              )),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0)),
              //_buildUnitDropdown(),
              deptCode == null || deptCode == "-1"
                  ? Container(
                      width: size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey[800]!)),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_city, color: Colors.blue[800]),
                          SizedBox(width: 10),
                          Text(unitName ?? "Select Unit",
                              style: TextStyle(color: Colors.black)),
                          SizedBox(width: 10),
                          Spacer(),
                          Icon(Icons.arrow_drop_down,
                              size: 24, color: Colors.grey[800]),
                        ],
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                      child: DropdownSearch<String>(
                        selectedItem: unitName ?? "Select Unit",
                        // items: (filter, loadProps) => dataUnit.map((e) {
                        //   return e['NAME'].toString().trim();
                        // }).toList(),
                        items: (filter, loadProps) => dataUnit.map((e) {
                          return e['key1'].toString().trim();
                        }).toList(),
                        decoratorProps: DropDownDecoratorProps(
                          decoration: InputDecoration(
                            //labelText: "Unit",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            prefixIcon: Icon(Icons.location_city,
                                color: Colors.blue[800]),
                          ),
                        ),
                        popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 400)),
                        onChanged: (newVal) {
                          setState(() {
                            dataUnit.forEach((element) {
                              if (newVal.toString() == element['key1'].toString()) {
                                unitCode = element['key2'].toString();
                                unitName = newVal.toString();
                              }
                            });
                          });
                        },
                      ),
                    ),
              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  children: [
                    TextSpan(
                        text: "Select Tender Date Criteria",
                        style: TextStyle(fontSize: 15)),
                    TextSpan(
                      text: " (Maximum difference 30 days)",
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              _buildDateTypeSelection(),
              SizedBox(height: 12),
              _buildDateSelection(),
              SizedBox(height: 24),
              _buildActionButton("Show Results", Colors.blue.shade800),
              SizedBox(height: 8),
              _buildResetButton(
                "Reset",
                Colors.blue.shade400,
                onPressed: resetForm,
                isOutlined: true,
              ),
              //_buildActionButton("Reset", Colors.blue.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTypeSelection() {
    return Row(
      children: [
        Expanded(
          child: _buildDateTypeOption(
            title: "Uploading Date",
            value: "uploading",
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildDateTypeOption(
            title: "Closing Date",
            value: "closing",
          ),
        ),
      ],
    );
  }

  Widget _buildDateTypeOption({
    required String title,
    required String value,
  }) {
    bool isSelected = selectedDateType == value;
    return InkWell(
      onTap: () {
        setState(() {
          selectedDateType = value;
          if (title == "Uploading Date") {
            counter = 1;
          } else {
            counter = 0;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.blue.shade400 : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.blue.shade400,
                size: 18,
              ),
            if (!isSelected)
              Icon(
                Icons.circle_outlined,
                color: Colors.grey.shade400,
                size: 18,
              ),
            SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      controller: searchcriteriaController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        hintText: hint,
        filled: true,
        fillColor: Colors.blue.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        hintStyle: TextStyle(fontSize: 13),
      ),
      style: TextStyle(fontSize: 13),
    );
  }

  Widget _buildWorkAreaSelection() {
    List<String> areas = ["Goods & Services", "Works", "Earning/Leasing"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: areas.map((area) => _buildChip(area)).toList(),
    );
  }

  Widget _buildChip(String title) {
    return ChoiceChip(
      label: Text(
        title,
        style: TextStyle(fontSize: 13),
      ),
      selected: selectedWorkArea == title,
      selectedColor: Colors.blue.shade300,
      showCheckmark: false,
      onSelected: (selected) {
        setState(() {
          selectedWorkArea = title;
          if (title == "Goods & Services") {
            counterwk = "PT";
          } else if (title == "Works") {
            counterwk = "WT";
          } else if (title == "Earning/Leasing") {
            counterwk = "LT";
          }
        });
      },
    );
  }

  Widget _buildDateSelection() {
    return Row(
      children: [
        Expanded(
          child: _buildDatePicker(
            uploadingDate,
            "From  ",
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildDatePicker(
            closingDate,
            "To  ",
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(DateTime date, String label) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(1995),
          lastDate: DateTime(2050),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.blue.shade800,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.blue.shade800,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            if (label == "From  ") {
              uploadingDate = pickedDate;
            } else {
              closingDate = pickedDate;
            }
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8),
            Text(
              "${date.toLocal()}".split(' ')[0],
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(Icons.calendar_today, color: Colors.blue.shade800, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          if (text == "Show Results") {
            //_validateInputs();
            //debugPrint("zone code ${zoneCode}");
            //debugPrint("counterwk $counterwk countrersc $countersc closingd ${DateFormat('dd-MM-yyyy').format(closingDate)}  ""uploadingd ${DateFormat('dd-MM-yyyy').format(uploadingDate)} content ${searchcriteriaController.text.toString()} orgcode $orgCode orgname $orgName zonecode ${zoneCode!.trim().split(";").first.trim()} zonename $zoneName deptcode $deptCode $deptName unitcode $unitCode $unitName");
            if (orgName == null &&
                zoneName == null &&
                deptName == null &&
                unitName == null) {
              AapoortiUtilities.showInSnackBar(context,
                  "All selection fields are required, please select require fields");
            } else {
              navigate();
            }
          } else {
            resetForm();
          }
        },
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildResetButton(
    String text,
    Color color, {
    VoidCallback? onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isOutlined ? Colors.white : color,
            foregroundColor: isOutlined ? color : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: isOutlined
                  ? BorderSide(color: color, width: 1.5)
                  : BorderSide.none,
            ),
            elevation: isOutlined ? 0 : 2,
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isOutlined ? color : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
