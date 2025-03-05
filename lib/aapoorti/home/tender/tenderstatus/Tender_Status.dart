import 'dart:io';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_app/aapoorti/home/tender/tenderstatus/tender_status_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Tender extends StatefulWidget {

  @override
  DropDownState createState() => DropDownState();
}

class DropDownState extends State<Tender> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool pressed = false, showdatepicker = false;
  bool _validate = false, calender = false;
  String minus = "-1", minus1 = "01", minus2 = "02", minus3 = "03";
  String minus4 = "04", minus5 = "05", minus6 = "06", minus7 = "07";
  final FocusNode _firstFocus = FocusNode();
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);

  String? content, id;
  ProgressDialog? pr;
  String date = "-1";
  String? value;
  String text = "";


  List<dynamic>? jsonFinalResult;


  void _onClear() {
    setState(() {
      _tenderController.text = '';
      orgName = null;
      zoneName = null;
      _selectedDate = DateTime.now();
    });
  }

  DateTime? _selectedDate = DateTime.now();
  final _tenderController = TextEditingController();

  List dataRly = [];
  List dataZone = [];

  String? orgName, orgCode = "-1";
  String? zoneName, zoneCode = "-1;-1";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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

  Future<void> fetchOrganisation() async {
    //debugPrint("Parameter $demandType~$fromDate~$toDate~$deptCode~$statusCode~$demandnum~05~98");
    _progressShow();
    fetchToken(context);
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
        dataRly.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success') {
          var listJson = listdata['data'];
          if(listJson != null) {
            setState(() {
              dataRly = listJson;
            });
          }
          else{
            setState(() {
              dataRly = [];
            });
          }
        }
        _progressHide();
      }
      else{
        dataRly.clear();
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
        dataRly.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
        _progressHide();
      }
    }
    on Exception{
      _progressHide();
    }
  }

  void dispose() {
    _tenderController.clear();
    super.dispose();
  }

  // Future<void> fetchPost() async {
  //   AapoortiUtilities.getProgressDialog(pr!);
  //   try {
  //     var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
  //     final response = await http.post(Uri.parse(u));
  //     jsonResult1 = json.decode(response.body);
  //     if(response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
  //     AapoortiUtilities.stopProgress(pr!);
  //     if (this.mounted)
  //       setState(() {
  //         if (jsonResult1 != null) data1 = jsonResult1!;
  //       });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     AapoortiUtilities.stopProgress(pr!);
  //   }
  // }
  //
  // Future<String> getSWData() async {
  //   try {
  //     _mySelection = null;
  //     if (myselection1 != "-1") {
  //       AapoortiUtilities.getProgressDialog(pr!);
  //       var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,$myselection1';
  //       final response = await http.post(Uri.parse(v));
  //       jsonResult = json.decode(response.body);
  //       AapoortiUtilities.stopProgress(pr!);
  //       if (this.mounted)
  //         setState(() {
  //           data = jsonResult!;
  //           _mySelection = null;
  //         });
  //     }
  //     return "Success";
  //   }
  //   catch(e){}
  //   return "Failure";
  // }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AapoortiConstants.primary,
            // actions: [
            //   IconButton(
            //     alignment: Alignment.centerRight,
            //     icon: Icon(
            //       Icons.home,
            //     ),
            //     onPressed: () {
            //       Navigator.of(context, rootNavigator: true).pop();
            //     },
            //   ),
            // ],
            title: Text('Tender Status Search', style: TextStyle(color: Colors.white,fontSize: 18)),
          ),
          backgroundColor: Colors.white,
          body: Container(
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [Color(0xFFF5F5F5), Colors.white],
            //   ),
            // ),
            child:Form( key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AapoortiConstants.primary)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: _buildDemandNumberField(),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(5.0),
                        //   child: TextFormField(
                        //     controller: _tenderController,
                        //     focusNode: _firstFocus,
                        //     decoration: InputDecoration(
                        //       labelText: 'Enter Tender No.',
                        //       prefixIcon: Icon(Icons.description, color: AapoortiConstants.primary),
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //         borderSide: const BorderSide(color: Colors.blue, width: 2),
                        //       ),
                        //     ),
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Please enter tender number';
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0, bottom: 10.0),
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
                                    dataZone.clear();
                                    dataRly.forEach((element) {
                                      if(newValue.toString() == element['key1'].toString()) {
                                        orgName = newValue.toString();
                                        orgCode = element['key2'].toString();
                                      }
                                    });
                                    debugPrint("orgname $orgName  orgcode $orgCode");
                                  });
                                } catch (e) {
                                  debugPrint("execption resp " + e.toString());
                                }
                                //getZone();
                                fetchZone(orgCode!);
                              }
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 10),
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
                                    borderRadius: BorderRadius.circular(8.0)
                                ),
                                prefixIcon: Icon(Icons.train, color: Colors.blue[800]),
                              ),
                            ),
                            popupProps: PopupProps.menu(fit: FlexFit.loose, showSearchBox: true, constraints: BoxConstraints(maxHeight: 400)),
                            onChanged: (newVal) {
                              setState(() {
                                dataZone.forEach((element) {
                                  if(newVal.toString() == element['key1'].toString()) {
                                    zoneCode = element['key3'].toString() + ";" + element['key2'].toString();
                                    zoneName = newVal.toString();
                                  }
                                });
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Tender Closing Date (Optional)',
                                prefixIcon: Icon(Icons.calendar_today, color: AapoortiConstants.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                style: TextStyle(color: Colors.blue.shade800),
                                _selectedDate == null ? 'Select Date' : '${_selectedDate!.day} ${_getMonth(_selectedDate!.month)} ${_selectedDate!.year}',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Container(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async{
                              if(_formKey.currentState!.validate()) {
                                if (!_tenderController.text.isEmpty) {
                                  try {
                                    if(orgName != null && zoneName != null) {
                                      debugPrint("date ${_selectedDate.toString()}");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Status(Date: _selectedDate.toString(), content: _tenderController.text.trim(), id: zoneCode!.split(";").first.trim())));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                    }
                                  } on SocketException catch (_) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Show Result',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildActionButton(
                          "Reset",
                          Colors.blue.shade400,
                          onPressed: _onClear,
                          isOutlined: true,
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     _onClear();
                        //   },
                        //   style: TextButton.styleFrom(
                        //     backgroundColor: Colors.grey[350],
                        //     padding: const EdgeInsets.symmetric(vertical: 16),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //   ),
                        //   child: Text(
                        //     'Reset',
                        //     style: TextStyle(
                        //       color: Colors.grey[700],
                        //       fontSize: 16,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // child: Form(
        )     //   key: _formKey,
      //   autovalidateMode: AutovalidateMode.onUserInteraction,
      //   child: FormUI(),
      // ),
    );
  }

  Widget _buildDemandNumberField() {
    return TextFormField(
      controller: _tenderController,
      decoration: InputDecoration(
        hintText: 'Enter Tender No.',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue.shade50,
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(Icons.numbers, size: 18, color: Colors.blue.shade700),
      ),
      style: const TextStyle(fontSize: 13),
      onChanged: (value) {
        setState(() {
          //demandNo = value.isEmpty ? null : value;
        });
      },
    );
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

  // Widget FormUI() {
  //   return Column(
  //     children: <Widget>[
  //       Card(
  //         margin: EdgeInsets.only(top: 30.0, left: 10, right: 10),
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //           child: TextFormField(
  //             onSaved: (value) {
  //               text = value!;
  //             },
  //             controller: myController,
  //             onEditingComplete: () {
  //               text = myController.text;
  //               FocusScope.of(context).requestFocus(_firstFocus);
  //             },
  //             validator: (text) {
  //               if (text!.isEmpty) {
  //                 return 'Enter Tender No.';
  //               } else {
  //                 return null;
  //               }
  //             },
  //             textInputAction: TextInputAction.done,
  //             decoration: InputDecoration(
  //                 icon: Icon(
  //                   Icons.assignment,
  //                   color: Colors.black,
  //                   textDirection: TextDirection.rtl,
  //                 ),
  //                 labelText: 'Enter Tender No.',
  //                 labelStyle: TextStyle(
  //                   color: Colors.grey,
  //                 ),
  //                 helperStyle: TextStyle(
  //                   color: Colors.grey,
  //                 )),
  //           ),
  //         ),
  //       ),
  //       Card(
  //         margin: EdgeInsets.only(top: 30.0, left: 10, right: 10),
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //           child: DropdownButtonFormField(
  //             isExpanded: true,
  //             hint: Text(myselection1 != null ? myselection1! : 'Select Organisation'),
  //             decoration: InputDecoration(icon: Icon(Icons.train, color: Colors.black)),
  //             items: data1.map((item) {
  //               return DropdownMenuItem(
  //                   child: Text(
  //                     item['NAME'],
  //                   ),
  //                   value: item['ID'].toString());
  //             }).toList(),
  //             onChanged: (newVal1) {
  //               setState(() {
  //                 _mySelection = null;
  //                 data.clear();
  //                 myselection1 = newVal1;
  //               });
  //               getSWData();
  //             },
  //             value: myselection1,
  //           ),
  //         ),
  //       ),
  //       Card(
  //         margin: EdgeInsets.only(top: 30.0, left: 10, right: 10),
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //           child: DropdownButtonFormField(
  //             isExpanded: true,
  //             hint: Text('Select Railway '),
  //             decoration: InputDecoration(
  //                 icon: Icon(Icons.account_balance, color: Colors.black)),
  //             items: data.map((item) {
  //               return DropdownMenuItem(
  //                   child: Text(item['NAME']),
  //                   value: item['ACCID'].toString());
  //             }).toList(),
  //             onChanged: (newVal2) {
  //               setState(() {
  //                 _mySelection = newVal2;
  //               });
  //             },
  //             value: _mySelection,
  //           ),
  //         ),
  //       ),
  //       Card(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             Row(
  //               children: <Widget>[
  //                 Column(
  //                   children: <Widget>[
  //                     Checkbox(
  //                         value: calender,
  //                         onChanged: (bool? value) {
  //                           setState(() {
  //                             calender = value!;
  //                           });
  //                         })
  //                   ],
  //                 ),
  //                 Padding(padding: EdgeInsets.only(left: 20)),
  //                 Column(
  //                   children: <Widget>[
  //                     Text('Tender Closing Date(Optional Field)'),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: <Widget>[
  //                 Expanded(
  //                   child: Container(
  //                     height: 90,
  //                     child: CupertinoDatePicker(
  //                       mode: CupertinoDatePickerMode.date,
  //                       use24hFormat: false,
  //                       onDateTimeChanged: (dateTime) {
  //                         setState(() {
  //                           _dateTime = dateTime;
  //                         });
  //                         date = _dateTime.toString();
  //                       },
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ],
  //         ),
  //         margin: EdgeInsets.only(top: 30.0, left: 10, right: 10, bottom: 20),
  //         elevation: 22.0,
  //       ),
  //       MaterialButton(
  //         minWidth: 330,
  //         height: 40,
  //         padding: EdgeInsets.fromLTRB(
  //           25.0,
  //           5.0,
  //           25.0,
  //           5.0,
  //         ),
  //         child: Text(
  //           'Show Result',
  //           textAlign: TextAlign.center,
  //           style: style.copyWith(
  //               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
  //         ),
  //         shape: RoundedRectangleBorder(
  //             borderRadius: new BorderRadius.circular(30.0)),
  //         onPressed: () async {
  //           debugPrint("date hdhdh $date");
  //           checkvalue();
  //           if (!myController.text.isEmpty) {
  //             try {
  //               var connectivityresult = await InternetAddress.lookup('google.com');
  //               if (myselection1 != null &&
  //                   _mySelection != null) {
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => Status(
  //                             Date: date, content: text, id: _mySelection!)));
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(snackbar);
  //               }
  //             } on SocketException catch (_) {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => NoConnection()));
  //             }
  //           }
  //         },
  //         color: Colors.cyan.shade400,
  //       ),
  //       Padding(padding: EdgeInsets.only(top: 20)),
  //       MaterialButton(
  //           minWidth: 330,
  //           height: 40,
  //           padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
  //           child: Text('Reset',
  //               textAlign: TextAlign.center,
  //               style: style.copyWith(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 18)),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: new BorderRadius.circular(30.0)),
  //           onPressed: () {
  //             _onClear();
  //           },
  //           color: Colors.cyan.shade400),
  //     ],
  //   );
  // }

  void checkvalue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      setState(() {
        //_autoValidate = true;
      });
    }
  }

  String _getMonth(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Container(
      child: Text(
        'Please select values',
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
    ),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {},
    ),
  );
}
