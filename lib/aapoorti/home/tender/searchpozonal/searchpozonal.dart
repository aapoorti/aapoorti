import 'dart:core';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'SearchPoList.dart';

class SearchPoZonal extends StatefulWidget {
  TextEditingController _textFieldController = TextEditingController();
  SearchPoZonal() : super();

  @override
  _SearchZonalState createState() => _SearchZonalState();
}

class _SearchZonalState extends State<SearchPoZonal> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<dynamic>? jsonResult;
   List data = [];
   GlobalKey<ScaffoldState> _snackKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _plNoController = TextEditingController();
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now().add(Duration(days: 30));
  // Initialize with default values
  double _minValue = 0;
  double _maxValue = 100;

  String? _selectedRailway;

  Future<String> getSWData() async {
    var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ZONE,01,,,-1';
    final response = await http.post(Uri.parse(v));
    jsonResult = json.decode(response.body);

    // Check if the widget is still mounted before calling setState()
    if(mounted) {
      setState(() {
        data = jsonResult!;
        data.removeAt(0);
      });
    }
    return "Success";
  }


  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  void reset() {
    getSWData();
    setState(() {
      //valueRange = 0.0;
      //pressed = false;
      //data = [];
      //myselection1 = null;
      //myController.clear();
      //myController1.clear();
      //_valueto = DateTime.now();
      //_valueto = _valuefrom.add(Duration(days: 1));
      //_valuecond = _valuefrom.add(Duration(days: 30));
    });
  }

  // Widget _myListView(BuildContext context) {
  //   return Container(
  //     child: Form(
  //       key: _formKey,
  //       autovalidateMode: AutovalidateMode.onUserInteraction,
  //       child: Column(
  //         children: <Widget>[
  //           Card(
  //             margin: EdgeInsets.only(top: 20.0, left: 10, right: 10),
  //             child: TextFormField(
  //                 onSaved: (value) {
  //                   supName = value!;
  //                 },
  //                 controller: myController,
  //                 decoration: InputDecoration(
  //                     icon: Icon(
  //                       Icons.assignment, color: Colors.black,
  //                       // textDirection: TextDirection.rtl,
  //                     ),
  //                     labelText: 'Supplier Name (min 3 char,Optional field)',
  //                     labelStyle: TextStyle(
  //                       color: Colors.grey,
  //                     ),
  //                     helperStyle: TextStyle(
  //                       color: Colors.grey,
  //                     ))),
  //           ),
  //           Card(
  //             margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
  //             child: TextFormField(
  //                 onSaved: (value) {
  //                   plNo = value!;
  //                 },
  //                 controller: myController1,
  //                 decoration: InputDecoration(
  //                     icon: Icon(
  //                       Icons.assignment, color: Colors.black,
  //                       // textDirection: TextDirection.rtl,
  //                     ),
  //                     labelText: 'PL No (min 3 char, Optional field)',
  //                     labelStyle: TextStyle(
  //                       color: Colors.grey,
  //                     ),
  //                     helperStyle: TextStyle(
  //                       color: Colors.grey,
  //                     ))),
  //           ),
  //           Card(
  //             margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
  //             child: DropdownButtonFormField(
  //               validator: (newVal1) {
  //                 if (newVal1 == null) {
  //                   return "Select Railway";
  //                 } else {
  //                   return null;
  //                 }
  //               },
  //
  //               hint: Text(
  //                   myselection1 != null ? myselection1 : "Select Railway"),
  //               decoration: InputDecoration(
  //                   icon: Icon(Icons.train, color: Colors.black)),
  //               items: data.map((item) {
  //                 return DropdownMenuItem(
  //                     child: Text(item['NAME']),
  //                     value: item['ACCID'].toString());
  //               }).toList(),
  //               onChanged: (newVal1) {
  //                 setState(() {
  //                   myselection1 = newVal1;
  //                 });
  //                 //checkvalue();
  //                 this.getSWData();
  //               },
  //
  //               // color: visibilitywk ? Colors.grey : Colors.red, fontSize: 11.0),
  //               value: myselection1,
  //             ),
  //           ),
  //           Card(
  //             margin: EdgeInsets.only(top: 15.0, left: 15, right: 15),
  //             child: Column(
  //               children: <Widget>[
  //                 Text(
  //                   "Select PO Value Range (in Lakhs)",
  //                   textAlign: TextAlign.left,
  //                   style: TextStyle(
  //                     color: slider_color ? Colors.grey : Colors.red,
  //                   ),
  //                 ),
  //                 Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   color: Colors.grey[200],
  //                   height: 40,
  //                   child: CupertinoSlider(
  //                     value: valueRange,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         valueRange = value;
  //                         setRange(valueRange);
  //                       });
  //                     },
  //                     max: 5,
  //                     min: val,
  //                     divisions: 5,
  //                   ),
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     Container(
  //                         width: (MediaQuery.of(context).size.width - 20) / 5.7,
  //                         alignment: Alignment.topLeft,
  //                         child: Column(
  //                           children: <Widget>[
  //                             Text(
  //                               "0",
  //                               style:
  //                                   TextStyle(fontSize: 10, color: Colors.grey),
  //                             ),
  //                           ],
  //                         )),
  //                     Padding(padding: EdgeInsets.all(2.0)),
  //                     Container(
  //                         width: (MediaQuery.of(context).size.width - 20) / 6.4,
  //                         alignment: Alignment.topLeft,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Text(
  //                               "0-1",
  //                               style:
  //                                   TextStyle(fontSize: 9, color: Colors.grey),
  //                             ),
  //                           ],
  //                         )),
  //                     Padding(padding: EdgeInsets.all(2.0)),
  //                     Container(
  //                         width: (MediaQuery.of(context).size.width - 20) / 6.9,
  //                         alignment: Alignment.topLeft,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Text(
  //                               "1-2",
  //                               style:
  //                                   TextStyle(fontSize: 9, color: Colors.grey),
  //                             ),
  //                           ],
  //                         )),
  //                     Padding(padding: EdgeInsets.all(2.0)),
  //                     Container(
  //                         width: (MediaQuery.of(context).size.width - 20) / 7,
  //                         alignment: Alignment.topLeft,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Text(
  //                               "2-5",
  //                               style:
  //                                   TextStyle(fontSize: 9, color: Colors.grey),
  //                             ),
  //                           ],
  //                         )),
  //                     Padding(padding: EdgeInsets.all(2.0)),
  //                     Container(
  //                         width: (MediaQuery.of(context).size.width - 20) / 7,
  //                         alignment: Alignment.topLeft,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Text(
  //                               "5-50",
  //                               style:
  //                                   TextStyle(fontSize: 9, color: Colors.grey),
  //                             ),
  //                           ],
  //                         )),
  //                        Container(
  //                         width:
  //                             (MediaQuery.of(context).size.width - 20) / 11.45,
  //                         alignment: Alignment.topLeft,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             Text(
  //                               "50-99999",
  //                               style:
  //                                   TextStyle(fontSize: 8, color: Colors.grey),
  //                             ),
  //                           ],
  //                         )),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(padding: EdgeInsets.only(top: 20)),
  //           Card(
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 mainAxisSize: MainAxisSize.max,
  //                 children: <Widget>[
  //                   Row(
  //                     mainAxisSize: MainAxisSize.max,
  //                     children: <Widget>[
  //                       Text('   Date Range difference must be 30 days',
  //                           style: TextStyle(color: Colors.grey)),
  //                     ],
  //                   ),
  //                   Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Padding(padding: EdgeInsets.fromLTRB(10, 30, 0, 10)),
  //                         Padding(padding:EdgeInsets.symmetric()),
  //                         MaterialButton(
  //                             padding: const EdgeInsets.all(0.0),
  //                             onPressed: _selectDateFrom,
  //                             child: Row(
  //                               children: <Widget>[
  //                                 Icon(
  //                                   Icons.date_range,
  //                                   color: Colors.cyan,
  //                                 ),
  //                                 Padding(
  //                                     padding: EdgeInsets.only(left: 15)),
  //                                 Text(
  //                                     DateFormat('dd-MM-yyyy')
  //                                         .format(_valuefrom),
  //                                     style: TextStyle(color: Colors.black),
  //                                     textAlign: TextAlign.left),
  //                               ],
  //                             )),
  //                         Padding(
  //                             padding: EdgeInsets.fromLTRB(50, 30, 0, 10)),
  //                         MaterialButton(
  //                             padding: const EdgeInsets.all(0.0),
  //                             onPressed: _selectDateTo,
  //                             child: Row(
  //                               children: <Widget>[
  //                                 Icon(
  //                                   Icons.date_range,
  //                                   color: Colors.cyan,
  //                                 ),
  //                                 Padding(
  //                                     padding: EdgeInsets.only(left: 15)),
  //                                 Text(
  //                                     DateFormat('dd-MM-yyyy').format(_valueto),
  //                                     style: TextStyle(color: Colors.black),
  //                                     textAlign: TextAlign.left),
  //                               ],
  //                             )),
  //                       ]),
  //                 ],
  //               ),
  //             ),
  //             margin: EdgeInsets.only(left: 20, right: 20),
  //           ),
  //           Padding(padding: EdgeInsets.only(top: 20)),
  //           MaterialButton(
  //             minWidth: 330,
  //             height: 40,
  //
  //             padding: EdgeInsets.fromLTRB(
  //               25.0,
  //               5.0,
  //               25.0,
  //               5.0,
  //             ),
  //             // padding: const EdgeInsets.only(left:110.0,right:110.0),
  //             child: Text(
  //               'Show Result',
  //               textAlign: TextAlign.center,
  //               style: style.copyWith(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 18),
  //             ),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(30.0)),
  //             onPressed: () {
  //               if(myselection1 == null) {
  //                 ScaffoldMessenger.of(context).showSnackBar(snackbar);
  //               }
  //               if(valueRange == 0) {
  //                 slider_color = false;
  //                 ScaffoldMessenger.of(context).showSnackBar(snackbar);
  //               } else if (_valueto.difference(_valuefrom).inDays < 1) {
  //                 ScaffoldMessenger.of(context).showSnackBar(snackbar1);
  //               } else if (_valueto.difference(_valuefrom).inDays > 30) {
  //                 ScaffoldMessenger.of(context).showSnackBar(snackbar2);
  //               } else {
  //                 slider_color = true;
  //                 pressed = true;
  //                 if(_formKey.currentState!.validate()){
  //                   _formKey.currentState!.save();
  //                   pressed ? Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => SearchPoList(
  //                               supName: supName,
  //                               plNo: plNo,
  //                               railUnit: myselection1,
  //                               pv1: pv1,
  //                               pv2: pv2,
  //                               valuefrom: DateFormat('dd-MM-yyyy').format(_valuefrom),
  //                               valueto: DateFormat('dd-MM-yyyy').format(_valueto)))) : null;
  //                 }
  //               }
  //
  //               //checkvalue();
  //             },
  //             color: Colors.cyan.shade400,
  //           ),
  //           Padding(padding: EdgeInsets.only(top: 10)),
  //           MaterialButton(
  //               minWidth: 330,
  //               height: 40,
  //               padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
  //               // padding: const EdgeInsets.only(left:110.0,right:110.0),
  //               child: Text('Reset',
  //                   textAlign: TextAlign.center,
  //                   style: style.copyWith(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18)),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(30.0)),
  //               onPressed: () {
  //                 reset();
  //                 slider_color = true;
  //                 myselection1 = null;
  //               },
  //               color: Colors.cyan.shade400),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // key: _snackKey,
    // body: Builder(
    //   builder: (context) => Material(
    //       color: Colors.cyan.shade50,
    //       child: ListView(
    //         children: <Widget>[_myListView(context)],
    //       )),
    // ));
    return Scaffold(
      key: _snackKey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                _supplierController,
                'Supplier Name',
                'Min 3 characters required,Optional Field',
                Icons.business,
              ),
              const SizedBox(height: 8),
              _buildTextFormField(
                _plNoController,
                'PL Number',
                'Min 3 characters required,Optional Field',
                Icons.numbers,
              ),
              const SizedBox(height: 8),
              _buildRailwayDropdown(),
              const SizedBox(height: 8),
              _buildPOValueRange(),
              const SizedBox(height: 8),
              _buildDateRange(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Search...')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Show Result',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _resetForm,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.blue.shade800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _supplierController.clear();
      _plNoController.clear();
      _startDate = null;
      _endDate = null;
      _minValue = 0;
      _maxValue = 100;
      _selectedRailway = null;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade800,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Widget _buildTextFormField(TextEditingController controller, String label, String hint, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.blue.shade800),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade800),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(fontSize: 12, color: Colors.black),
            hintStyle: const TextStyle(color: Colors.black54),
          ),
          style: const TextStyle(fontSize: 12, color: Colors.black),
          validator: (value) {
            if (value == null || value.length < 3) {
              return 'Minimum 3 characters required';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildRailwayDropdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField<String>(
          value: _selectedRailway,
          decoration: InputDecoration(
            labelText: 'Select Railway',
            prefixIcon: Icon(Icons.train, color: Colors.blue.shade800),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade800),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade800),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            labelStyle: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          style: const TextStyle(fontSize: 12, color: Colors.black),
          dropdownColor: Colors.white,
          items: data.map((item) {
            return DropdownMenuItem(
                child: Text(item['NAME'],style: const TextStyle(color: Colors.black)),
                value: item['ACCID'].toString());
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedRailway = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPOValueRange() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PO Value Range (in Lakhs)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '₹${_minValue.toStringAsFixed(0)} L - ₹${_maxValue.toStringAsFixed(0)} L',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.blue.shade800,
                      inactiveTrackColor: Colors.blue.shade100,
                      thumbColor: Colors.blue.shade800,
                      overlayColor: Colors.blue.shade800.withOpacity(0.2),
                      valueIndicatorColor: Colors.blue.shade800,
                      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                      showValueIndicator: ShowValueIndicator.always,
                    ),
                    child: RangeSlider(
                      values: RangeValues(_minValue, _maxValue),
                      min: 0,
                      max: 100,
                      divisions: 100,
                      labels: RangeLabels(
                        '₹${_minValue.round()} L',
                        '₹${_maxValue.round()} L',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _minValue = values.start;
                          _maxValue = values.end;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRange() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date Range (30 days difference required)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade800),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context, true),
                      icon: Icon(Icons.calendar_today, color: Colors.blue.shade800),
                      label: Text(
                        _startDate != null ? _formatDate(_startDate) : 'From  $_startDate',
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        side: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade800),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context, false),
                      icon: Icon(Icons.calendar_today, color: Colors.blue.shade800),
                      label: Text(
                        _endDate != null ? _formatDate(_endDate) : 'To',
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        side: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void setRange(double value) {
  //   debugPrint("value" + value.toString());
  //   if (value == 0.0) {
  //     pv1 = "0";
  //     pv2 == "0";
  //   } else if (value == 1.0) {
  //     pv1 = "0";
  //     pv2 = "1";
  //   } else if (value == 2.0) {
  //     pv1 = "1";
  //     pv2 = "2";
  //   } else if (value == 3.0) {
  //     pv1 = "2";
  //     pv2 = "5";
  //   } else if (value == 4.0) {
  //     pv1 = "5";
  //     pv2 = "50";
  //   } else if (value == 5.0) {
  //     pv1 = "50";
  //     pv2 = "99999";
  //   }
  // }

  void checkvalue() {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPoList(supName: _supplierController.text.trim(), plNo: _plNoController.text.trim(), railUnit: _selectedRailway, pv1:_minValue.toString(), pv2: _maxValue.toString(), valuefrom: DateFormat('dd-MM-yyyy').format(_startDate!), valueto: DateFormat('dd-MM-yyyy').format(_endDate!))));
    }
    else {
      setState(() {
        //_autoValidate = true;
      });
    }
  }
}



