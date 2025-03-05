import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/implinks/edocs/EdocsWorksDATA.dart';
import 'package:http/http.dart' as http;
//import'package:flutter_app/aapoorti/home/tender/tenderstatus/tender_status_view.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'EdocsGSdata.dart';

class edocs_GandS extends StatefulWidget {
  edocs_GandS() : super();


  @override
  edocs_GandSState createState() => edocs_GandSState();
}

class edocs_GandSState extends State<edocs_GandS> {

  ProgressDialog? pr;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _autoValidate = false;


  navigate() async {
    if(selectedOrganization != null && selectedZone != null && selectedDepartment != null) {
      try {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EdocsGSdata(item1: orgCode!, item2: zoneCode!.split(";").last, item3: deptCode!)));
      }
      catch (exception) {}
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  _progressShow() {
    pr = ProgressDialog(context, type: ProgressDialogType.normal, isDismissible: true, showLogs: true);
    pr!.show();
  }

  _progressHide() {
    Future.delayed(Duration(milliseconds: 100), () {
      pr!.hide().then((isHidden) {});
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPostOrganisation();
    });

  }

  String? selectedOrganization, orgCode = "-1";
  String? selectedZone, zoneCode = "-1;-1";
  String? selectedDepartment, deptCode = "-1";


  final Color primaryBlue = Colors.blue[800]!;
  late List organizations = [];
  late List zones = [];
  late List departments = [];

  Future<void> fetchPostOrganisation() async {
    _progressShow();
    try {
      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';

      final response1 = await http.post(Uri.parse(u));
      var jsonResult1 = json.decode(response1.body);
      setState(() {
        organizations = jsonResult1!;
      });

      _progressHide();
    }
    on SocketException catch(e){
      _progressHide();
      AapoortiUtilities.showInSnackBar(context, "Please check your internet connection!!");
    }
    on Exception catch(ex){
      _progressHide();
      AapoortiUtilities.showInSnackBar(context, "Something unexpected happened, please try again.");
    }
  }

  Future<String> fetchPostZone() async {
    debugPrint("org code $orgCode");
    var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,${this.orgCode}';
    _progressShow();
    final response = await http.post(Uri.parse(v));
    var jsonResult2 = json.decode(response.body);

    _progressHide();
    setState(() {
      zones = jsonResult2!;
    });
    return "Success";
  }

  Future<void> fetchPostDepartment() async {
    var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,DEPARTMENT,${this.orgCode},${this.zoneCode!.split(";").first}';
    _progressShow();
    final response1 = await http.post(Uri.parse(u));
    var jsonResult3 = json.decode(response1.body);
    _progressHide();

    setState(() {
      departments = jsonResult3!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: AapoortiConstants.primary,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/common_screen", (route) => false);
                    },
                  ),
                ],
                title: Text('Public Documents',style: TextStyle(color: Colors.white,fontSize: 18))),

            body: Builder(
              builder: (context) => Material(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: Colors.blueAccent,
                        width: double.infinity,
                        child: const Text(
                          'Goods and Services',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(16),
                      //   color: Colors.blue[800]!,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue[900],
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     child: const Row(
                      //       children: [
                      //         Icon(Icons.inventory_2, color: Colors.white),
                      //         SizedBox(width: 12),
                      //         Text(
                      //           'Goods and Services',
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10.0, left: 5, right: 5, bottom: 10),
                              child: DropdownSearch<String>(
                                  selectedItem: selectedOrganization ?? "Select Organization",
                                  // items: (filter, loadProps) => dataRly.map((e) {
                                  //     return e['NAME'].toString().trim();
                                  //   }).toList(),
                                  items: (filter, loadProps) => organizations.map((e) {
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
                                        selectedZone = null;
                                        selectedDepartment = null;
                                        zones.clear();
                                        departments.clear();
                                        organizations.forEach((element) {
                                          if(newValue.toString() == element['NAME'].toString()) {
                                            selectedOrganization = newValue.toString();
                                            orgCode = element['ID'].toString();
                                          }
                                        });
                                        // dataRly.forEach((element) {
                                        //   if(newValue.toString() == element['NAME'].toString()) {
                                        //     orgName = newValue.toString();
                                        //     orgCode = element['ID'].toString();
                                        //   }
                                        // });
                                        debugPrint("orgname $selectedOrganization  orgcode $orgCode");
                                      });
                                    } catch (e) {
                                      debugPrint("execption resp " + e.toString());
                                    }
                                    //getZone();
                                    fetchPostZone();
                                  }
                              ),
                            ),
                            // _buildDropdownField(
                            //   icon: Icons.business,
                            //   label: 'Organization',
                            //   value: selectedOrganization,
                            //   items: organizations,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       selectedOrganization = value;
                            //       departments.clear();
                            //       selectedDepartment = null;
                            //       zones.clear();
                            //       selectedZone = null;
                            //       fetchPostZone();
                            //     });
                            //   },
                            // ),
                            const SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.only(top: 10.0, left: 5, right: 5, bottom: 10),
                              child: DropdownSearch<String>(
                                selectedItem: selectedZone ?? "Select Zone",
                                // items: (filter, loadProps) => dataZone.map((e) {
                                //   return e['NAME'].toString().trim();
                                // }).toList(),
                                items: (filter, loadProps) => zones.map((e) {
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
                                    deptCode = "-1";
                                    selectedDepartment = null;
                                    departments.clear();
                                    zones.forEach((element) {
                                      if(newVal.toString() == element['NAME'].toString()) {
                                        zoneCode = element['ACCID'].toString() + ";" + element['ID'].toString();
                                        selectedZone = newVal.toString();

                                        debugPrint("zone code nsnns $zoneCode");
                                      }
                                      debugPrint("zone code nanna $zoneCode");
                                    });
                                  });
                                  //getDept();
                                  fetchPostDepartment();
                                },
                              ),
                            ),
                            // _buildDropdownField(
                            //   icon: Icons.location_on,
                            //   label: 'Zone',
                            //   value: selectedZone,
                            //   items: zones,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       selectedZone = value;
                            //       departments.clear();
                            //       selectedDepartment = null;
                            //       fetchPostDepartment();
                            //     });
                            //   },
                            // ),
                            const SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.only(top: 10.0, left: 5, right: 5, bottom: 10),
                              child: DropdownSearch<String>(
                                  selectedItem: selectedDepartment ?? "Select Department",
                                  items: (filter, loadProps) => departments.map((e) {
                                    return e['NAME'].toString().trim();
                                  }).toList(),
                                  // items: (filter, loadProps) => dataDept.map((e) {
                                  //   return e['NAME'].toString().trim();
                                  // }).toList(),
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
                                      departments.forEach((element){
                                        if(newValue.toString() == element['NAME'].toString()) {
                                          deptCode = element['ID'].toString();
                                          selectedDepartment = newValue.toString();
                                        }
                                      });
                                      // dataDept.forEach((element){
                                      //   if(newValue.toString() == element['NAME'].toString()) {
                                      //     deptCode = element['ID'].toString();
                                      //     deptName = newValue.toString();
                                      //   }
                                      // });
                                    });
                                  }
                              ),
                            ),
                            // _buildDropdownField(
                            //   icon: Icons.account_balance,
                            //   label: 'Department',
                            //   value: selectedDepartment,
                            //   items: departments,
                            //   onChanged: (value) {
                            //     setState(() => selectedDepartment = value);
                            //   },
                            // ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if(selectedOrganization != null && selectedZone != null && selectedDepartment != null){
                                  //_validateInputs();
                                  navigate();
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800]!,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Show Results',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  selectedOrganization = null;
                                  selectedZone = null;
                                  selectedDepartment = null;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.blue[800]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.blue[800]!,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Form(
                      //   key: _formKey,
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   child: FormUI(),
                      // ),
                    ],
                  ),
                ),
              ),
            )));
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select values',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}

Widget _buildDropdownField({
  required IconData icon,
  required String label,
  required String? value,
  required List<dynamic> items,
  required Function(dynamic) onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue[800]!.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.blue[800]!.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]!),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<dynamic>(
                value: value,
                menuMaxHeight: 350,
                hint: Text(
                  'Select $label',
                  style: TextStyle(
                    color: Colors.blue[800]!.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.blue[800]!),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: label == 'Zone' ? "${item['ACCID'].toString()};${item['ID'].toString()}" : item['ID'].toString(),
                    child: Text(
                      item['NAME'],
                      style: TextStyle(
                        color: Colors.blue[800]!,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
