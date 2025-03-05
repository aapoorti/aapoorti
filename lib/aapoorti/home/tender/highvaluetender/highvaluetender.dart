import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_app/aapoorti/home/tender/highvaluetender/high_value_tender_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropDownhvt extends StatefulWidget {
  DropDownhvt() : super();
  final String title = "DropDown Demo";
  @override
  DropDownState createState() => DropDownState();
}

class DropDownState extends State<DropDownhvt> {
  String date = "-1";
  ProgressDialog? pr;
  DateTime? selected;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);


  DateTime _valuefrom = DateTime.now().subtract(Duration(days: 333));
  DateTime _valueto = DateTime.now();


  String? orgName, orgCode = "-1";
  String? zoneName, zoneCode = "-1;-1";
  String? deptName, deptCode = "-1";
  String? unitName = "Select Unit", unitCode = "-1";
  String? workArea = "PT";
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonResult2;
  List<dynamic>? jsonResult3;
  List<dynamic>? jsonResult4;
  String? url;

  String? selectedOption = 'Goods & Services';

  int counter = 0;
  GlobalKey<ScaffoldState> _snackKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(context);
    Future.delayed(Duration.zero, () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
      if(providedTime.isBefore(DateTime.now())){
        await fetchToken(context);
        fetchOrganisation();
      }
      else{
        fetchOrganisation();
      }
    });
  }

  void reset() {
    setState(() {
      orgCode = "-1";
      zoneCode = "-1;-1";
      deptCode = "-1";
      unitCode = "-1";
      orgName = null;
      zoneName = null;
      deptName = null;
      unitName = null;
      dataZone.clear();
      dataDepartment.clear();
      dataUnit.clear();
      workArea = "PT";
      selectedOption = "Goods & Services";
      _valuefrom = DateTime.now().subtract(Duration(days: 333));
      _valueto = DateTime.now();
    });
  }

  _progressShow() {
    pr = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr!.show();
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {
        debugPrint(isHidden.toString());
      });
    });
  }

  List dataOrganisation = [];
  List dataZone = [];
  List dataDepartment = [];
  List dataUnit = [];

  Future<void> fetchOrganisation() async {
    //debugPrint("Parameter $demandType~$fromDate~$toDate~$deptCode~$statusCode~$demandnum~05~98");
    _progressShow();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P4/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "ORGANIZATION",
        "input": "",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response organisation ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        dataOrganisation.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success') {
          var listJson = listdata['data'];
          if(listJson != null) {
            setState(() {
              dataOrganisation = listJson;
            });
          }
          else{
            setState(() {
              dataOrganisation = [];
            });
          }
        }
        _progressHide();
      }
      else{
        dataOrganisation.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
        _progressHide();
      }
    }
    on Exception{
      _progressHide();
    }
  }

  Future<void> fetchZone(String orgCode) async{
    _progressShow();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P4/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "ZONE",
        "input": orgCode,
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response zone ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        dataZone.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success') {
          var listJson = listdata['data'];
          if(listJson != null) {
            setState(() {
              dataZone = listJson;
            });
          }
          else{
            setState(() {
              dataZone = [];
            });
          }
        }
        _progressHide();
      }
      else{
        dataZone.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
        _progressHide();
      }
    }
    on Exception{
      _progressHide();
    }
  }

  Future<void> fetchDepartment(String orgCode, String zoneCode) async {
    debugPrint("fetch Dept $orgCode ${zoneCode.split(";").first}");
    _progressShow();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P4/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "DEPARTMENT",
        "input": "$orgCode",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response Department ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        dataDepartment.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success') {
          var listJson = listdata['data'];
          if(listJson != null) {
            setState(() {
              dataDepartment = listJson;
            });
          }
          else{
            setState(() {
              dataDepartment = [];
            });
          }
        }
        _progressHide();
      }
      else{
        dataDepartment.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
        _progressHide();
      }
    }
    on Exception{
      _progressHide();
    }
  }

  Future<void> fetchUnit(String orgCode, String orgZone, String orgDept, String unittypeid) async{
    _progressShow();
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P4/V1/GetData");
      debugPrint("$orgCode~$orgZone~$orgDept~$unittypeid");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "UNIT",
        "input": "$orgCode~${zoneCode!.split(";").last}~$orgDept~$unittypeid",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response Unit ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        dataUnit.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success') {
          var listJson = listdata['data'];
          if(listJson != null) {
            setState(() {
              unitName = null;
              dataUnit = listJson;
            });
          }
          else{
            setState(() {
              unitName = null;
              dataUnit = [];
            });
          }
        }
        _progressHide();
      }
      else{
        dataUnit.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
        _progressHide();
      }
    }
    on Exception{
      _progressHide();
    }
  }

  // Future<void> fetchPost() async {
  //   try {
  //     var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
  //     AapoortiUtilities.getProgressDialog(pr!);
  //     final response = await http.post(Uri.parse(u)).timeout(Duration(seconds: 30));
  //     jsonResult1 = json.decode(response.body);
  //     if (response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
  //     debugPrint(jsonResult1.toString());
  //     AapoortiUtilities.stopProgress(pr!);
  //     if (this.mounted)
  //       setState(() {
  //         if (jsonResult1 != null) dataOrganisation = jsonResult1!;
  //       });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
  //
  // Future<String> fetchPostZone() async {
  //   try{
  //     if(orgCode != "-1") {
  //       AapoortiUtilities.getProgressDialog(pr!);
  //
  //       var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${orgCode}';
  //       debugPrint("url2-----" + v);
  //       final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 10));
  //       jsonResult2 = json.decode(response.body);
  //
  //       debugPrint("jsonResult2------");
  //       debugPrint(jsonResult2.toString());
  //       AapoortiUtilities.stopProgress(pr!);
  //       setState(() {
  //         dataZone = jsonResult2!;
  //       });
  //     }
  //     return "Success";
  //   }
  //   on Exception catch(e){}
  //
  //   return "Failure";
  // }
  //
  // Future<void> fetchPostDepartment() async {
  //   try {
  //     debugPrint('Fetching from service first spinner');
  //     if (zoneCode != "-1;-1") {
  //       AapoortiUtilities.getProgressDialog(pr!);
  //       var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,DEPARTMENT,${orgCode!},${zoneCode!.substring(zoneCode!.indexOf(';') + 1)}';
  //       debugPrint("ur13-----" + u);
  //
  //       final response1 = await http.post(Uri.parse(u)).timeout(Duration(seconds: 30));
  //       jsonResult3 = json.decode(response1.body);
  //       debugPrint("jsonResult3===");
  //       debugPrint(jsonResult3.toString());
  //
  //       AapoortiUtilities.stopProgress(pr!);
  //       setState(() {
  //         dataDepartment = jsonResult3!;
  //       });
  //     }
  //   }
  //   on Exception catch(e){
  //     fetchPostDepartment();
  //   }
  // }
  //
  // Future<void> fetchPostUnit(String url) async {
  //   try {
  //     debugPrint('Fetching from service first spinner');
  //     if (deptCode != "-1") {
  //       AapoortiUtilities.getProgressDialog(pr!);
  //       final response1 = await http.post(Uri.parse(url)).timeout(Duration(seconds: 30));
  //       jsonResult4 = json.decode(response1.body);
  //       AapoortiUtilities.stopProgress(pr!);
  //       setState(() {
  //         dataUnit = jsonResult4!;
  //       });
  //     }
  //   }
  //   on Exception catch(e){}
  // }

  Widget _myListView(BuildContext context, Size size) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10.0),
              child: DropdownSearch<String>(
                selectedItem: orgName ?? "Select Organization",
                items: (filter, loadProps) => dataOrganisation.map((e) {
                  return e['key1'].toString().trim();
                }).toList(),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    //labelText: "Organization",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    prefixIcon: Icon(Icons.list, color: Colors.blue[800]),
                  ),
                ),
                popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 400)),
                onChanged: (newVal) async{
                  setState(() {
                    zoneCode = "-1;-1";
                    deptCode = "-1";
                    unitCode = "-1";

                    dataZone.clear();
                    dataDepartment.clear();
                    dataUnit.clear();

                    dataOrganisation.forEach((element) {
                      if(newVal.toString() == element['key1'].toString()) {
                        orgName = newVal.toString();
                        orgCode = element['key2'].toString();
                      }
                    });
                  });
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
                  if(providedTime.isBefore(DateTime.now())){
                    await fetchToken(context);
                    fetchZone(orgCode!);
                  }
                  else{
                    fetchZone(orgCode!);
                  }
                },
              ),
            ),
            orgCode == "-1" ? InkWell(
              onTap: (){
                AapoortiUtilities.showInSnackBar(context, "Please select organization");
              },
              child: Container(
                width: size.width,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey[800]!)
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.train, color: Colors.blue[800]),
                    SizedBox(width: 10),
                    Text(zoneName ?? "Select Zone", style: TextStyle(color: Colors.black)),
                    SizedBox(width: 10),
                    Spacer(),
                    Icon(Icons.arrow_drop_down, size: 24, color: Colors.grey[800]),
                  ],
                ),
              ),
            ) : Container(
              margin: EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
              child: DropdownSearch<String>(
                selectedItem: zoneName ?? "Select Zone",
                items: (filter, loadProps) => dataZone.map((e) {
                  return e['key1'].toString().trim();
                }).toList(),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    //labelText: "Zone",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    prefixIcon: Icon(Icons.train, color: Colors.blue[800]),
                  ),
                ),
                popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 400)),
                onChanged: (newVal) {
                  setState(() {
                    deptCode = null;
                    unitCode = null;
                    deptName = null;
                    unitName = null;
                    dataDepartment.clear();
                    dataUnit.clear();

                    dataZone.forEach((element) {
                      if(newVal.toString() == element['key1'].toString()) {
                        zoneCode = element['key3'].toString() + ";" + element['key2'].toString();
                        zoneName = newVal.toString();
                      }
                    });
                  });
                  fetchDepartment(orgCode!, zoneCode!);
                },
              ),
            ),
            Container(margin: EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10), child: DropdownSearch<String>(
                selectedItem: deptName ?? "Select Department",
                items: (filter, loadProps) => dataDepartment.map((e) {
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
                    dataDepartment.forEach((element){
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
            deptCode == "-1" ? Container(
              width: size.width,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[800]!)
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: Row(
                children: [
                  Icon(Icons.location_city, color: Colors.blue[800]),
                  SizedBox(width: 10),
                  Text(unitName ?? "Select Unit", style: TextStyle(color: Colors.black)),
                  SizedBox(width: 10),
                  Spacer(),
                  Icon(Icons.arrow_drop_down, size: 24, color: Colors.grey[800]),
                ],
              ),
            ) : Container(
              margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: DropdownSearch<String>(
                selectedItem: unitName ?? "Select Unit",
                //suffixProps: DropdownSuffixProps(dropdownButtonProps: DropdownButtonProps(isVisible: false)),
                items: (filter, loadProps) => dataUnit.map((e) {
                  return e['key1'].toString().trim();
                }).toList(),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    //labelText: "Unit",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)
                    ),
                    prefixIcon: Icon(Icons.location_city, color: Colors.blue[800]),
                  ),
                ),
                popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 400)),
                onChanged: (newVal) {
                  setState(() {
                    dataUnit.forEach((element){
                      if(newVal.toString() == element['key1'].toString()) {
                        unitCode = element['key2'].toString();
                        unitName = newVal.toString();
                      }
                    });
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(
                'Select Work Area',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            _buildWorkAreaSelection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(
                'Publish Date Range',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      'From',
                      _valuefrom, (date) => setState(() => _valuefrom = date),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDatePicker(
                      'To',
                      _valueto, (date) => setState(() => _valueto = date),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint("myselection1 $orgCode myselection2 $zoneCode myselection3 $deptCode myselection4 $unitCode myselection5 $workArea valufrom $_valuefrom valueto $_valueto");
                    if(orgName != null && zoneName != null && deptName != null && unitName != null) {
                      if(_valueto.difference(_valuefrom).inDays < 30) {
                        debugPrint("days ${_valueto.difference(_valuefrom).inDays}");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HighValueStatus(
                                  item1: orgCode,
                                  item2: zoneCode!.split(";").first.trim(),
                                  item3: deptCode,
                                  item4: unitCode,
                                  item5: workArea,
                                  item6: DateFormat('dd/MM/yyyy').format(_valuefrom),
                                  item7: DateFormat('dd/MM/yyyy').format(_valueto),
                                )));
                      }
                      else {
                        AapoortiUtilities.showInSnackBar(context, "Please select a valid date range");
                      }
                    }
                    else {
                      debugPrint("days ${_valueto.difference(_valuefrom).inDays}");
                      AapoortiUtilities.showInSnackBar(context, "Please select values.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    fixedSize: Size(size.width, 55),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Show Results',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildActionButton(
                "Reset",
                Colors.blue.shade400,
                onPressed: reset,
                isOutlined: true,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: TextButton(
            //     onPressed: () {
            //       reset();
            //     },
            //     style: TextButton.styleFrom(
            //       fixedSize: Size(size.width, 55),
            //       padding: EdgeInsets.symmetric(vertical: 16),
            //       backgroundColor: Colors.white,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //         side: BorderSide(color: Colors.blue[800]!),
            //       ),
            //     ),
            //     child: Text(
            //       'Reset',
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: Colors.blue[800],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(
            key: _snackKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: AapoortiConstants.primary,
                title: Text('High Value Tender', style: TextStyle(color: Colors.white,fontSize: 18))),
            backgroundColor: Colors.white,
            body: Builder(
              builder: (context) => Material(
                  child: ListView(
                  children: <Widget>[_myListView(context, size)],
              )),
            )

            ));
  }

  Widget _buildDatePicker(
      String label,
      DateTime? selectedDate,
      Function(DateTime) onDateSelected,
      ) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
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
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            SizedBox(width: 8),
            Text(
              selectedDate != null ? formatDate(selectedDate) : label,
              style: TextStyle(
                color: selectedDate != null ? Colors.blue.shade800 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.calendar_today, size: 16, color: Colors.blue[800]),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkAreaSelection() {
    List<String> areas = ["Goods & Services", "Works", "Earning/Leasing"];
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: areas.map((area) => _buildChip(area)).toList(),
      ),
    );
  }

  Widget _buildChip(String title) {
    return ChoiceChip(
      label: Text(
        title,
        style: TextStyle(fontSize: 13),
      ),
      selected: selectedOption == title,
      selectedColor: Colors.blue[400],
      showCheckmark: false,
      onSelected: (selected) {
        setState(() {
          selectedOption = title;
          if(title == "Goods & Services"){
            workArea = "PT";
          }
          else if(title == "Works"){
            workArea = "WT";
          }
          else if(title == "Earning/Leasing"){
            workArea = "LT";
          }
        });
      },
    );
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildActionButton(
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
              side: isOutlined ? BorderSide(color: color, width: 1.5) : BorderSide.none,
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
