import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_app/aapoorti/home/tender/tenderstatus/tender_status_view.dart';


class Tender extends StatefulWidget {

  @override
  DropDownState createState() => DropDownState();
}

class DropDownState extends State<Tender> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static DateTime _dateTime = DateTime.now();
  bool pressed = false, showdatepicker = false;
  bool _validate = false, calender = false;
  String minus = "-1", minus1 = "01", minus2 = "02", minus3 = "03";
  String minus4 = "04", minus5 = "05", minus6 = "06", minus7 = "07";
  final FocusNode _firstFocus = FocusNode();
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  String? _mySelection, myselection1, _finalsel1;
  TextEditingController myController = TextEditingController();

  String? content, id;
  ProgressDialog? pr;
  String date = "-1";
  String _value = '';
  String? value;
  String text = "";

  bool _autoValidate = false;
  List<dynamic>? jsonResult;
  List<dynamic>? jsonResult1;
  List<dynamic>? jsonFinalResult;

  List data = [];
  List data1 = [];

  void _onClear() {
    pressed = false;
    myController.text = "";
    myselection1 = null;
    _mySelection = null;
    text = "";
    calender = false;
    _dateTime = DateTime.now();
    date = "-1";
    setState(() {
      pressed = false;
      myController.text = "";
      myselection1 = null;
      _mySelection = null;
      text = "";
      calender = false;
      _dateTime = DateTime.now();
      date = "-1";
    });
  }

  DateTime? _selectedDate;
  String? _selectedOrganization;
  String? _selectedRailway;
  final _tenderController = TextEditingController();

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

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<void> fetchPost() async {
    AapoortiUtilities.getProgressDialog(pr!);
    try {
      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
      final response = await http.post(Uri.parse(u));
      jsonResult1 = json.decode(response.body);
      if(response.statusCode != 200) throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      AapoortiUtilities.stopProgress(pr!);
      if (this.mounted)
        setState(() {
          if (jsonResult1 != null) data1 = jsonResult1!;
        });
    } catch (e) {
      debugPrint(e.toString());
      AapoortiUtilities.stopProgress(pr!);
    }
  }

  Future<String> getSWData() async {
    try {
      _mySelection = null;
      if (myselection1 != "-1") {
        AapoortiUtilities.getProgressDialog(pr!);
        var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,$myselection1';
        final response = await http.post(Uri.parse(v));
        jsonResult = json.decode(response.body);
        AapoortiUtilities.stopProgress(pr!);
        if (this.mounted)
          setState(() {
            data = jsonResult!;
            _mySelection = null;
          });
      }
      return "Success";
    }
    catch(e){}
    return "Failure";
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      pr = ProgressDialog(context);
      fetchPost();
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
            actions: [
              IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(
                  Icons.home,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
            title: Text('Tender Status Search', style: TextStyle(color: Colors.white,fontSize: 18)),
          ),
          backgroundColor: Colors.cyan.shade50,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF5F5F5), Colors.white],
              ),
            ),
            child:Form( key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _tenderController,
                          decoration: InputDecoration(
                            labelText: 'Enter Tender No.',
                            prefixIcon: const Icon(Icons.description, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter tender number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          hint: Text(myselection1 != null ? myselection1! : 'Select Organisation'),
                          decoration: InputDecoration(
                            //icon: Icon(Icons.train, color: Colors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey,strokeAlign: 1)
                              )
                          ),
                          items: data1.map((item) {
                            return DropdownMenuItem(
                                child: Text(
                                  item['NAME'],
                                ),
                                value: item['ID'].toString());
                          }).toList(),
                          onChanged: (newVal1) {
                            setState(() {
                              _mySelection = null;
                              data.clear();
                              myselection1 = newVal1;
                            });
                            getSWData();
                          },
                          value: myselection1,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          hint: Text('Select Railway '),
                          decoration: InputDecoration(
                            //icon: Icon(Icons.account_balance, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              )
                          ),
                          items: data.map((item) {
                            return DropdownMenuItem(
                                child: Text(item['NAME']),
                                value: item['ACCID'].toString());
                          }).toList(),
                          onChanged: (newVal2) {
                            setState(() {
                              _mySelection = newVal2;
                            });
                          },
                          value: _mySelection,
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Tender Closing Date (Optional)',
                              prefixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _selectedDate == null ? 'Select Date' : '${_selectedDate!.day} ${_getMonth(_selectedDate!.month)} ${_selectedDate!.year}',
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: () async{
                            if(_formKey.currentState!.validate()) {
                              if (!_tenderController.text.isEmpty) {
                                try {
                                  var connectivityresult = await InternetAddress.lookup('google.com');
                                  if(myselection1 != null && _mySelection != null) {
                                    debugPrint("date ${_selectedDate.toString()}");
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Status(Date: _selectedDate.toString(), content: _tenderController.text.trim(), id: _mySelection!)));
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
                        const SizedBox(height: 12),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              _tenderController.clear();
                              _selectedOrganization = null;
                              _selectedRailway = null;
                              _selectedDate = null;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[350],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                        ),
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
        _autoValidate = true;
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
