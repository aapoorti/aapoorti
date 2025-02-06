import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_app/aapoorti/home/tender/highvaluetender/high_value_tender_details.dart';

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


  DateTime _valuefrom = DateTime.now();
  DateTime _valueto = DateTime.now().add(Duration(days: 30));

  String? orgName, orgCode = "-1";
  String? zoneName, zoneCode = "-1;-1";
  String? deptName, deptCode = "-1";
  String? unitName, unitCode = "-1";
  String? workArea = "PT";
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonResult2;
  List<dynamic>? jsonResult3;
  List<dynamic>? jsonResult4;
  String? url;
  String? selectedOption;

  int counter = 0;
  GlobalKey<ScaffoldState> _snackKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      pr = ProgressDialog(context);
      fetchPost();
    });
  }

  void reset() {
    setState(() {
      orgCode = null;
      zoneCode = null;
      deptCode = null;
      unitCode = null;
      orgName = null;
      zoneName = null;
      deptName = null;
      unitName = null;
      dataZone.clear();
      dataDepartment.clear();
      dataUnit.clear();
      workArea = "PT";
      selectedOption = "Goods & Services";
      _valuefrom = DateTime.now();
      _valueto = DateTime.now().add(Duration(days: 30));
    });
  }

  List dataOrganisation = [];
  List dataZone = [];
  List dataDepartment = [];
  List dataUnit = [];

  Future<void> fetchPost() async {
    try {
      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
      AapoortiUtilities.getProgressDialog(pr!);
      final response = await http.post(Uri.parse(u)).timeout(Duration(seconds: 30));
      jsonResult1 = json.decode(response.body);
      if (response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      debugPrint(jsonResult1.toString());
      AapoortiUtilities.stopProgress(pr!);
      if (this.mounted)
        setState(() {
          if (jsonResult1 != null) dataOrganisation = jsonResult1!;
        });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> fetchPostZone() async {
    try{
      if(orgCode != "-1") {
        AapoortiUtilities.getProgressDialog(pr!);

        var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${orgCode}';
        debugPrint("url2-----" + v);
        final response = await http.post(Uri.parse(v)).timeout(Duration(seconds: 10));
        jsonResult2 = json.decode(response.body);

        debugPrint("jsonResult2------");
        debugPrint(jsonResult2.toString());
        AapoortiUtilities.stopProgress(pr!);
        setState(() {
          dataZone = jsonResult2!;
        });
      }
      return "Success";
    }
    on Exception catch(e){}

    return "Failure";
  }

  Future<void> fetchPostDepartment() async {
    try {
      debugPrint('Fetching from service first spinner');
      if (zoneCode != "-1;-1") {
        AapoortiUtilities.getProgressDialog(pr!);
        var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,DEPARTMENT,${orgCode!},${zoneCode!.substring(zoneCode!.indexOf(';') + 1)}';
        debugPrint("ur13-----" + u);

        final response1 = await http.post(Uri.parse(u)).timeout(Duration(seconds: 30));
        jsonResult3 = json.decode(response1.body);
        debugPrint("jsonResult3===");
        debugPrint(jsonResult3.toString());

        AapoortiUtilities.stopProgress(pr!);
        setState(() {
          dataDepartment = jsonResult3!;
        });
      }
    }
    on Exception catch(e){
      fetchPostDepartment();
    }
  }

  Future<void> fetchPostUnit(String url) async {
    try {
      debugPrint('Fetching from service first spinner');
      if (deptCode != "-1") {
        AapoortiUtilities.getProgressDialog(pr!);
        final response1 = await http.post(Uri.parse(url)).timeout(Duration(seconds: 30));
        jsonResult4 = json.decode(response1.body);
        AapoortiUtilities.stopProgress(pr!);
        setState(() {
          dataUnit = jsonResult4!;
        });
      }
    }
    on Exception catch(e){}
  }

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
                  return e['NAME'].toString().trim();
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
                onChanged: (newVal) {
                  setState(() {
                    zoneCode = null;
                    deptCode = null;
                    unitCode = null;

                    dataZone.clear();
                    dataDepartment.clear();
                    dataUnit.clear();

                    dataOrganisation.forEach((element) {
                      if(newVal.toString() == element['NAME'].toString()) {
                        orgName = newVal.toString();
                        orgCode = element['ID'].toString();
                      }
                    });
                    debugPrint("orgID $orgCode orgname $newVal");
                  });
                  fetchPostZone();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
              child: DropdownSearch<String>(
                selectedItem: zoneName ?? "Select Zone",
                items: (filter, loadProps) => dataZone.map((e) {
                  return e['NAME'].toString().trim();
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
                      if(newVal.toString() == element['NAME'].toString()) {
                        zoneCode = element['ACCID'].toString() + ";" + element['ID'].toString();
                        zoneName = newVal.toString();
                      }
                    });
                  });
                  this.fetchPostDepartment();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
              child: DropdownSearch<String>(
                selectedItem: deptName ?? "Select Department",
                items: (filter, loadProps) => dataDepartment.map((e) {
                  return e['NAME'].toString().trim();
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
                onChanged: (newVal) {
                  setState(() {
                    unitCode = null;
                    unitName = null;
                    dataUnit.clear();
                    dataDepartment.forEach((element){
                      if(newVal.toString() == element['NAME'].toString()) {
                        deptCode = element['ID'].toString();
                        deptName = newVal.toString();
                      }
                    });
                  });
                  if(deptCode == "-1") {
                    url = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,UNIT,-2,-2,-2,-1';
                  }
                  if (deptCode != "-1") {
                    url = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,UNIT,${orgCode},${zoneCode!.substring(zoneCode!.indexOf(';') + 1)},${deptCode},';
                  }
                  this.fetchPostUnit(url!);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: DropdownSearch<String>(
                selectedItem: unitName ?? "Select Unit",
                items: (filter, loadProps) => dataUnit.map((e) {
                  return e['NAME'].toString().trim();
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
                      if(newVal.toString() == element['NAME'].toString()) {
                        unitCode = element['ID'].toString();
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
              padding: const EdgeInsets.all(8.0),
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
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("myselection1 $orgCode myselection2 $zoneCode myselection3 $deptCode myselection4 $unitCode myselection5 $workArea valufrom $_valuefrom valueto $_valueto");
                  if(orgCode != null || orgCode == "-1" && zoneCode != null || zoneCode == "-1" && deptCode != null || deptCode == "-1" && unitCode != null || unitCode != "-1") {
                    if(_valueto.difference(_valuefrom).inDays < 30) {
                      debugPrint("fdfdfdf ${_valuefrom.difference(_valueto).inDays}");
                      AapoortiUtilities.showInSnackBar(context, "Please select a valid date range");
                    }
                    else {
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
                  }
                  else {
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  reset();
                },
                style: TextButton.styleFrom(
                  fixedSize: Size(size.width, 55),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
                child: Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ),
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(child: Text('High Value Tender', style: TextStyle(color: Colors.white,fontSize: 18))),
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                  ],
                )),
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
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: Colors.blue[800]),
            SizedBox(width: 8),
            Text(
              selectedDate != null ? formatDate(selectedDate) : label,
              style: TextStyle(
                color: selectedDate != null ? Colors.black87 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
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
}
