import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
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
    debugPrint(uploadingDate.difference(closingDate).inDays.toString() + "no of difference in date");
    debugPrint("Closing date $closingDate");
    debugPrint("Uploading date $uploadingDate");
    try{
      if(closingDate.difference(uploadingDate).inDays > 30) {
        AapoortiUtilities.showInSnackBar(context, "Please select maximum 30 days range in date");
      }
      else {
        debugPrint(zoneCode);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Custom_search_view(
                  workarea: counterwk,
                  SearchForstring: searchcriteriaController.text.trim(),
                  RailZoneIn: '${zoneCode!.split(";").first.trim()}',
                  Dt1In: DateFormat('dd/MMM/yyyy').format(uploadingDate).toString(),
                  Dt2In: DateFormat('dd/MMM/yyyy').format(closingDate).toString(),
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

  Future<void> fetchPost() async {
    try {
      _progressShow();
      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
      final response = await http.post(Uri.parse(u));
      List<dynamic>? rlyData = json.decode(response.body);
      if(response.statusCode != 200) throw new Exception('HTTP request failed, statusCode: ${response.statusCode}');
      setState(() {
        if(rlyData!.isNotEmpty) dataRly = rlyData;
      });
      _progressHide();
    } catch (e) {
      debugPrint(e.toString());
      _progressHide();
    }
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

  Future<void> getZone() async {
    try {
      debugPrint('Fetching from service' +orgCode!+ "     ----" + zoneCode!);
      dataZone.clear();
      _progressShow();
      var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${orgCode}';
      final response = await http.post(Uri.parse(v));
      debugPrint("GetZone response $response");
      List<dynamic>? zoneResult = json.decode(response.body);
      if(response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      debugPrint("GetZone jsonresult $zoneResult");
      zoneCode = "-1;-1";
      setState(() {
        if(zoneResult!.isNotEmpty) dataZone = zoneResult;
      });
      debugPrint('after Fetching from service' + orgCode! + "     ----" + zoneCode!);
      _progressHide();
    } catch (e) {
      debugPrint("GetZone exception ${e.toString()}");
      _progressHide();
    }
  }

  Future<void> fetchDept() async {
    debugPrint("orgcode $orgCode");
    debugPrint("zone code ${zoneCode!.substring(zoneCode!.indexOf(';') + 1)}  ....... ${zoneCode!}");
    try {
      dataDept.clear();
      _progressShow();
      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,DEPARTMENT,${orgCode!},${zoneCode!.substring(zoneCode!.indexOf(';') + 1)}';
      debugPrint("Department url $u");
      final response = await http.post(Uri.parse(u));
      List<dynamic>? deptResult = json.decode(response.body);
      debugPrint("Department data $deptResult");
      if(deptResult.toString().trim() == "[{ErrorCode: 4}]"){
        dataDept = [{"NAME": "All Departments", "ID" : "-1"}];
        _progressHide();
      }
      else{
        if(json.decode(response.body) == null || response.statusCode != 200) throw new Exception('HTTP request failed, statusCode: ${response.statusCode}');
        deptCode = "-1";
        setState(() {
          if(deptResult!.isNotEmpty) dataDept = deptResult;
        });
        _progressHide();
      }

    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchUnit() async {
    try {
      dataUnit.clear();
      var v;
      if((zoneCode!.substring(zoneCode!.indexOf(';') + 1) == "-1") || (deptCode == "-1")) {
        v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,UNIT,-2,-2,-2,-1';
      } else if((zoneCode!.substring(zoneCode!.indexOf(';') + 1) != "-1") || (deptCode != "-1")) {
        v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,UNIT,${orgCode},${zoneCode!.substring(zoneCode!.indexOf(';') + 1)},${deptCode},';
      }
      _progressShow();
      final response = await http.post(Uri.parse(v));
      debugPrint("unit resp ${json.decode(response.body)}");
      if(response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      List<dynamic>? unitResult = json.decode(response.body);
      if(unitResult.toString().trim() == "[{ErrorCode: 4}]"){
        dataUnit = [{"NAME": "ALL", "ID": -1}];
      }
      unitCode = "-1";
      setState(() {
        if(unitResult!.isNotEmpty) dataUnit = unitResult;
      });
      _progressHide();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Custom Search",style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: AapoortiConstants.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchPost,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Search Criteria",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  if(!showTenderNo)
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
                  if(!showTenderNo && !showItemDesc)
                    SizedBox(width: 8),
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
              if(showTenderNo || showItemDesc) Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(showTenderNo) ...[
                      SizedBox(height: 8),
                      _buildTextField("Enter Tender No"),
                    ],
                    if(showItemDesc) ...[
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
              Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0)),
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10.0),
                child: DropdownSearch<String>(
                  selectedItem: orgName ?? "Select Organization",
                  items: (filter, loadProps) => dataRly.map((e) {
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
                            if(newValue.toString() == element['NAME'].toString()) {
                              orgName = newValue.toString();
                              orgCode = element['ID'].toString();
                            }
                          });
                          debugPrint("orgname $orgName  orgcode $orgCode");
                        });
                      } catch (e) {
                        debugPrint("execption resp " + e.toString());
                      }
                      getZone();
                    }
                ),
              ),
              //_buildOrganisationDropdown(),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0)),
              //_buildRlyDropdown(),
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
                      dataDept.clear();
                      dataUnit.clear();

                      dataZone.forEach((element) {
                        if(newVal.toString() == element['NAME'].toString()) {
                          zoneCode = element['ACCID'].toString() + ";" + element['ID'].toString();
                          zoneName = newVal.toString();
                        }
                      });
                    });
                    this.fetchDept();
                  },
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0)),
              //_buildDepDropdown(),
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 10),
                child: DropdownSearch<String>(
                  selectedItem: deptName ?? "Select Department",
                  items: (filter, loadProps) => dataDept.map((e) {
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
                    onChanged: (String? newValue) {
                      setState(() {
                        unitCode = "-1";
                        dataUnit.clear();
                        dataDept.forEach((element){
                          if(newValue.toString() == element['NAME'].toString()) {
                            deptCode = element['ID'].toString();
                            deptName = newValue.toString();
                          }
                        });
                      });
                      fetchUnit();
                    }
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0)),
              //_buildUnitDropdown(),
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
              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                  children: [
                    TextSpan(text: "Select Tender Date Criteria", style: TextStyle(fontSize: 15)),
                    TextSpan(
                      text: " (Maximum difference 30 days)",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
              _buildActionButton("Reset", Colors.blue.shade400),
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
          if(title == "Uploading Date"){
            counter = 1;
          }
          else{
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
            if(isSelected)
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
          if(title == "Goods & Services"){
            counterwk = "PT";
          }
          else if(title == "Works"){
            counterwk = "WT";
          }
          else if(title == "Earning/Leasing"){
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
            if(label == "From  ") {
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

  Widget _buildActionButton(String text, Color color){
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: (){
          if(text == "Show Results"){
            //_validateInputs();
            navigate();
            //debugPrint("counterwk $counterwk countrersc $countersc closingd ${DateFormat('dd-MM-yyyy').format(closingDate)}  ""uploadingd ${DateFormat('dd-MM-yyyy').format(uploadingDate)} content ${searchcriteriaController.text.toString()} orgcode $orgCode orgname $orgName zonecode $zoneCode zonename $zoneName deptcode $deptCode $deptName unitcode $unitCode $unitName");
          }
          else{
             resetForm();
          }
        },
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

