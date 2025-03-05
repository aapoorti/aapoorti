import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/aapoorti/home/auction/lotsearch/LotSearchList.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class LotSearch extends StatefulWidget {
  @override
  _LotSearchState createState() => _LotSearchState();
}

class _LotSearchState extends State<LotSearch> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<dynamic>? jsonRail, jsonDepot;
  int _buttonFilter = 0, _filter = 1, lotType = 0;
  bool _autoValidate = false;
  final FocusNode _firstFocus = FocusNode();
  String? railUnit, depotUnit, catid, desc = "";
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 13.0);
  TextEditingController myController = TextEditingController();
  ProgressDialog? pr;
  bool visibilityPub = true;
  bool visibilitySold = false;
  List dataRail = [];
  List dataDepot = [];

  _LotSearchState({
    this.catid,
  });

  void _changed(bool visibility, String field) {
    setState(() {
      if(field == "pub") {
        visibilityPub = visibility;
        visibilitySold = false;
      }
      if (field == "sold") {
        visibilityPub = false;
        visibilitySold = visibility;
      }
    });
  }

  void _onClear() {
    _formKey.currentState!.reset();
    myController.text = "";
    railUnit = null;
    depotUnit = null;
    lotType = 0;
    desc = "";
    setState(() {
      visibilityPub = true;
      visibilitySold = false;
      _buttonFilter = 0;
      _filter = 1;
      lotType = 0;
    });
  }

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<void> fetchPost() async {
    AapoortiUtilities.getProgressDialog(pr!);
    try {
      var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,RLY_UNITS_AUCTION';
      final response = await http.post(Uri.parse(v));
      jsonRail = json.decode(response.body);
      setState(() {
        dataRail = jsonRail!;
        jsonRail!.removeAt(0);
        jsonRail!.removeRange(12, 14);
      });
      AapoortiUtilities.stopProgress(pr!);
    }
    on SocketException catch(e){
      AapoortiUtilities.showInSnackBar(context, "Please check your internet connection!");
      AapoortiUtilities.stopProgress(pr!);
    }
    catch (ex){
      AapoortiUtilities.stopProgress(pr!);
    }
  }

  Future<void> fetchData() async {
    depotUnit = null;
    try {
      if (railUnit != "-2") {
        AapoortiUtilities.getProgressDialog(pr!);
        var u = AapoortiConstants.webServiceUrl + '/getData?input=AUCTION_PRELOGIN,DP_START_DATE,$railUnit';
        final response1 = await http.post(Uri.parse(u));
        jsonDepot = json.decode(response1.body);
        AapoortiUtilities.stopProgress(pr!);
        setState(() {
          dataDepot = jsonDepot!;
        });
      }
    }
    on SocketException catch(e){
      AapoortiUtilities.showInSnackBar(context, "Please check your internet connection!");
      AapoortiUtilities.stopProgress(pr!);
    }
    catch(ex){
      AapoortiUtilities.stopProgress(pr!);
    }
  }

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchPost();
    });
  }

  void _csfilter(int value) {
    setState(() {
      _buttonFilter = value;
      switch (_buttonFilter) {
        case 1:
          _filter = 1;
          break;
        case 2:
          _filter = 2;
          break;
        case 3:
          _filter = 3;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.lightBlue[800],
                title: Text('Lot Search(Sale)', style: TextStyle(color: Colors.white))),
            body: Container(
              height: size.height,
              width: size.width,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical:10), // Mobile-friendly spacing
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spacing between text & buttons
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Select Lot Type',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15, // Optimized font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3),
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: () {
                                    _csfilter(1);
                                    lotType = 0;
                                    _changed(true, "pub");
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: (_filter == 1) ? Colors.blue : Colors.grey.shade400),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  ),
                                  child: Text(
                                    "Published",
                                    style: TextStyle(
                                      color: (_filter == 1) ? Colors.blue : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3), // Space between buttons
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: () {
                                    _csfilter(2);
                                    lotType = 1;
                                    _changed(true, "sold");
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: (_filter == 2) ? Colors.blue : Colors.grey.shade400),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  ),
                                  child: Text(
                                    "Sold Out",
                                    style: TextStyle(
                                      color: (_filter == 2) ? Colors.blue : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 1.0)),
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AapoortiConstants.primary, strokeAlign: 0.2)), // Rounded edges
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Responsive spacing
                      child: Padding(
                        padding: EdgeInsets.all(8), // Reduced padding inside the card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5), // Space between dropdowns
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Reduced padding inside dropdown
                                    hintText: "Select Railway Unit", // Hint text instead of label
                                    prefixIcon: Icon(Icons.train, color: Colors.blueGrey), // Icon inside input
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.blueGrey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.never, // Prevents label from floating
                                  ),
                                  value: railUnit,
                                  hint: Text(railUnit ?? "All Railway Units"),
                                  items: dataRail.map((item) {
                                    return DropdownMenuItem(
                                      value: item['ID'].toString(),
                                      child: Text(item['NAME']),
                                    );
                                  }).toList(),
                                  onChanged: (newVal1) {
                                    setState(() {
                                      railUnit = newVal1;
                                    });
                                    fetchData();
                                  },
                                ),

                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15), // Space between dropdowns
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return SizedBox(
                                    width: constraints.maxWidth, // Uses the available screen width dynamically
                                    child: DropdownButtonFormField(
                                      isExpanded: true, // Prevents overflow by expanding dropdown
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Reduced padding inside dropdown
                                        hintText: "Select Depot", // Hint text instead of label
                                        prefixIcon: Icon(Icons.account_balance, color: Colors.blueGrey),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(color: Colors.blueGrey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        floatingLabelBehavior: FloatingLabelBehavior.never, // Prevents label from floating
                                      ),
                                      value: depotUnit,
                                      hint: Text("Select Depot"),
                                      items: dataDepot.map((item) {
                                        return DropdownMenuItem(
                                          value: item['DEPOT_ID'].toString(),
                                          child: Text(item['DEPOT_NAME']),
                                        );
                                      }).toList(),
                                      onChanged: (newVal2) {
                                        setState(() {
                                          depotUnit = newVal2;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5), // Space between dropdowns
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                                child: TextFormField(
                                  controller: myController,
                                  onSaved: (value) {
                                    desc = value;
                                  },
                                  onEditingComplete: () {
                                    desc = myController.text;
                                    checkvalue();
                                    FocusScope.of(context).requestFocus(_firstFocus);
                                  },
                                  validator: (desc) {
                                    if (desc!.length < 3) {
                                      return 'Compulsory field!! Enter 4 to 30 characters';
                                    } else if (desc.length > 30) {
                                      return 'Maximum 30 characters only!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Reduced padding inside input field
                                    hintText: 'Lot no. or Description (Min 4 Chars.)', // Changed labelText to hintText
                                    prefixIcon: Icon(Icons.border_color, color: Colors.blueGrey),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.blueGrey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    errorStyle: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center align buttons
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            debugPrint("lottype $lotType railUnit $railUnit depotunit $depotUnit desc ${myController.text.trim()}");
                            if(!myController.text.isEmpty) {
                              try {
                                var connectivityresult = await InternetAddress.lookup('google.com');
                                if(railUnit != null && depotUnit != null && desc != null) {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => LotSearchList(lotType: lotType, railUnit: railUnit!, depotUnit: depotUnit!, desc: myController.text.trim())),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                }
                              } on SocketException catch (_) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                              }
                            }
                            checkvalue();
                            FocusScope.of(context).requestFocus(_firstFocus);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(size.width/1.1, 45),
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            backgroundColor: Colors.lightBlue[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Show Results',
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              fontSize: 18,
                            ),
                          ),
                        ),

                        SizedBox(height: 10), // Space between buttons
                        ElevatedButton(
                          onPressed: () {
                            _onClear();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(size.width/1.1, 45),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color:Colors.lightBlue.shade800),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                              color: Colors.lightBlue[800],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }

  void checkvalue() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    } else {
      debugPrint("If all data are not valid then start auto validation.");
      setState(() {
        _autoValidate = true;
      });
    }
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
      onPressed: () {},
    ),
  );
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:flutter_app/aapoorti/common/NoConnection.dart';
// import 'package:flutter_app/aapoorti/home/auction/lotsearch/LotSearchList.dart';
// import 'package:http/http.dart' as http;
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
//
// class LotSearch extends StatefulWidget {
//   @override
//   _LotSearchState createState() => _LotSearchState();
// }
//
// class _LotSearchState extends State<LotSearch> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   List<dynamic>? jsonRail, jsonDepot;
//   int _buttonFilter = 0, _filter = 1, lotType = 0;
//   bool _autoValidate = false;
//   final FocusNode _firstFocus = FocusNode();
//   String? railUnit, depotUnit, catid, desc = "";
//   TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
//   TextEditingController myController = TextEditingController();
//   ProgressDialog? pr;
//   bool visibilityPub = true;
//   bool visibilitySold = false;
//   List dataRail = [];
//   List dataDepot = [];
//
//   _LotSearchState({
//     this.catid,
//   });
//
//   void _changed(bool visibility, String field) {
//     setState(() {
//       if (field == "pub") {
//         visibilityPub = visibility;
//         visibilitySold = false;
//       }
//       if (field == "sold") {
//         visibilityPub = false;
//         visibilitySold = visibility;
//       }
//     });
//   }
//
//   @override
//   void _onClear() {
//     _formKey.currentState!.reset();
//     visibilityPub = true;
//     visibilitySold = false;
//     myController.text = "";
//     railUnit = null;
//     depotUnit = null;
//     lotType = 0;
//     desc = "";
//     setState(() {
//       _formKey.currentState!.reset();
//       visibilityPub = true;
//       visibilitySold = false;
//       myController.text = "";
//       railUnit = null;
//       depotUnit = null;
//       lotType = 0;
//       desc = "";
//     });
//   }
//
//   void dispose() {
//     myController.dispose();
//     super.dispose();
//   }
//
//   Future<void> fetchPost() async {
//     var v = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,RLY_UNITS_AUCTION';
//     final response = await http.post(Uri.parse(v));
//     jsonRail = json.decode(response.body);
//     setState(() {
//       dataRail = jsonRail!;
//       jsonRail!.removeAt(0);
//       jsonRail!.removeRange(12, 14);
//     });
//   }
//
//   Future<void> fetchdata() async {
//     depotUnit = null;
//     if(railUnit != "-2") {
//       AapoortiUtilities.getProgressDialog(pr!);
//       var u = AapoortiConstants.webServiceUrl + '/getData?input=AUCTION_PRELOGIN,DP_START_DATE,$railUnit';
//       final response1 = await http.post(Uri.parse(u));
//       jsonDepot = json.decode(response1.body);
//       AapoortiUtilities.stopProgress(pr!);
//       setState(() {
//         dataDepot = jsonDepot!;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     pr = ProgressDialog(context);
//     fetchPost();
//   }
//
//   void _csfilter(int value) {
//     setState(() {
//       _buttonFilter = value;
//       switch (_buttonFilter) {
//         case 1:
//           _filter = 1;
//           break;
//         case 2:
//           _filter = 2;
//           break;
//         case 3:
//           _filter = 3;
//           break;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           return true;
//         },
//         child: Scaffold(
//             appBar: AppBar(
//                 iconTheme: IconThemeData(color: Colors.white),
//                 backgroundColor: AapoortiConstants.primary,
//                 actions: [
//                   IconButton(
//                     icon: Icon(
//                       Icons.home,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       Navigator.of(context, rootNavigator: true).pop();
//                     },
//                   ),
//                 ],
//                 title: Text('Lot Search (Sale)', style: TextStyle(color: Colors.white,fontSize: 18))),
//             body: Builder(
//               builder: (context) => Material(
//                 color: Colors.cyan[50],
//                 child: ListView(
//                   children: <Widget>[
//                     Container(
//                       child: Form(
//                         key: _formKey,
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         child: Column(
//                           children: <Widget>[
//                             Card(
//                                 margin: EdgeInsets.only(
//                                     top: 20.0, left: 10, right: 10),
//                                 child: Column(children: <Widget>[
//                                   Padding(
//                                       padding: EdgeInsets.only(top: 10.0)),
//                                   Text(
//                                     '                Select Lot Type               ',
//                                     style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                   Padding(
//                                       padding:
//                                           EdgeInsets.only(bottom: 10.0)),
//                                   Container(
//                                     child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: <Widget>[
//                                           Icon(Icons.list,
//                                               color: Colors.black,
//                                               textDirection: TextDirection.rtl),
//                                           ElevatedButton(
//                                             onPressed: () {
//                                               _csfilter(1);
//                                               lotType = 0;
//                                               _changed(true, "pub");
//                                             },
//                                             child: Row(
//                                               children: <Widget>[
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 5.0)),
//                                                 Text(
//                                                   "Published",
//                                                   style: TextStyle(
//                                                       color: (_filter == 1)
//                                                           ? Colors.cyan
//                                                           : Colors.grey),
//                                                 ),
//                                                 Visibility(
//                                                   child: Image.asset(
//                                                     "assets/check_box.png",
//                                                     height: 30.0,
//                                                     width: 30.0,
//                                                   ),
//                                                   maintainSize: true,
//                                                   maintainAnimation: true,
//                                                   maintainState: true,
//                                                   visible: visibilityPub,
//                                                 ),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 5.0)),
//                                               ],
//                                             ),
//                                             // borderSide: BorderSide(
//                                             //   color: Colors
//                                             //       .black, //Color of the border
//                                             //   style: BorderStyle
//                                             //       .solid, //Style of the border
//                                             //   width: 2.0, //width of the border
//                                             // ),
//                                           ),
//                                           ElevatedButton(
//                                             onPressed: () {
//                                               _csfilter(2);
//                                               lotType = 1;
//                                               _changed(true, "sold");
//                                             },
//                                             child: Row(
//                                               children: <Widget>[
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 5.0)),
//                                                 Text(
//                                                   "Sold Out",
//                                                   style: new TextStyle(
//                                                       color: (_filter == 1)
//                                                           ? Colors.grey
//                                                           : Colors.cyan),
//                                                 ),
//                                                 Visibility(
//                                                   child: Image.asset(
//                                                     "assets/check_box.png",
//                                                     height: 30.0,
//                                                     width: 30.0,
//                                                   ),
//                                                   maintainSize: true,
//                                                   maintainAnimation: true,
//                                                   maintainState: true,
//                                                   visible: visibilitySold,
//                                                 ),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 5.0)),
//                                               ],
//                                             ),
//                                             //color: Colors.white,
//                                             // borderSide: BorderSide(
//                                             //   color: Colors.black,
//                                             //   style: BorderStyle.solid,
//                                             //   width: 2.0,
//                                             // ),
//                                           ),
//                                         ]),
//                                     margin: EdgeInsets.all(10.0),
//                                   )
//                                 ])),
//                             Padding(padding: EdgeInsets.only(top: 10.0)),
//                             Card(
//                               child: DropdownButtonFormField(
//                                 hint: Text(railUnit != null
//                                     ? railUnit!
//                                     : "All Railway Units"),
//                                 decoration: InputDecoration(
//                                     icon:
//                                         Icon(Icons.train, color: Colors.black)),
//                                 items: dataRail.map((item) {
//                                   return DropdownMenuItem(
//                                       child: Text(item['NAME']),
//                                       value: item['ID'].toString());
//                                 }).toList(),
//                                 onChanged: (newVal1) {
//                                   setState(() {
//                                     railUnit = newVal1 as String?;
//                                   });
//                                   fetchdata();
//                                 },
//                                 value: railUnit,
//                               ),
//                             ),
//                             Padding(padding: EdgeInsets.only(top: 10.0)),
//                             Card(
//                               // margin: EdgeInsets.only(top:30.0,left: 15,right: 15) ,
//                               child: DropdownButtonFormField(
//                                 hint: Text('Select Depot'),
//                                 decoration: InputDecoration(
//                                     icon: Icon(Icons.account_balance,
//                                         color: Colors.black)),
//                                 items: dataDepot.map((item) {
//                                   return DropdownMenuItem(
//                                       child: Text(item['DEPOT_NAME']),
//                                       value: item['DEPOT_ID'].toString());
//                                 }).toList(),
//                                 onChanged: (newVal2) {
//                                   setState(() {
//                                     depotUnit = newVal2 as String?;
//                                   });
//                                 },
//                                 value: depotUnit,
//                               ),
//                             ),
//                             Padding(padding: EdgeInsets.only(top: 10.0)),
//                             Card(
//                               child: TextFormField(
//                                 onSaved: (value) {
//                                   desc = value;
//                                 },
//                                 controller: myController,
//                                 onEditingComplete: () {
//                                   desc = myController.text;
//                                   checkvalue();
//                                   FocusScope.of(context)
//                                       .requestFocus(_firstFocus);
//                                 },
//                                 validator: (desc) {
//                                   if (desc!.length < 3) {
//                                     return 'Compulsory field!! Enter 4 to 30 characters';
//                                   } else if (desc.length > 30) {
//                                     return 'Maximum 30 characters only!';
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                                 decoration: InputDecoration(
//                                     errorStyle: TextStyle(color: Colors.red),
//                                     contentPadding: EdgeInsets.symmetric(
//                                         vertical: 12.0, horizontal: 0.1),
//                                     icon: Icon(
//                                       Icons.border_color,
//                                       color: Colors.black,
//                                       textDirection: TextDirection.rtl,
//                                       size: 18,
//                                     ),
//                                     labelText:
//                                         'Lot no. or Description(Min 4 Chars.)',
//                                     labelStyle: TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                     helperStyle: TextStyle(
//                                       color: Colors.grey,
//                                     )),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 8,
//                             ),
//                             MaterialButton(
//                               minWidth: 330,
//                               height: 35,
//                               padding: EdgeInsets.fromLTRB(
//                                 25.0,
//                                 5.0,
//                                 25.0,
//                                 5.0,
//                               ),
//                               child: Text(
//                                 'Show Results',
//                                 textAlign: TextAlign.center,
//                                 style: style.copyWith(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18),
//                               ),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(30.0)),
//                               onPressed: () async {
//                                 if (!myController.text.isEmpty) {
//                                   try {
//                                     var connectivityresult =
//                                         await InternetAddress.lookup(
//                                             'google.com');
//                                     if (connectivityresult != null &&
//                                         railUnit != null &&
//                                         depotUnit != null &&
//                                         desc != null &&
//                                         lotType != null) {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   LotSearchList(
//                                                       lotType: lotType,
//                                                       railUnit: railUnit!,
//                                                       depotUnit: depotUnit!,
//                                                       desc: desc!)));
//                                     } else {
//                                       ScaffoldMessenger.of(context).showSnackBar(snackbar);
//                                     }
//                                   } on SocketException catch (_) {
//                                     print('internet not available');
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
//                                   }
//                                 }
//                                 checkvalue();
//                                 FocusScope.of(context)
//                                     .requestFocus(_firstFocus);
//                               },
//                               color: Colors.cyan.shade400,
//                             ),
//                             Padding(padding: EdgeInsets.only(top: 20)),
//                             MaterialButton(
//                                 minWidth: 330,
//                                 height: 35,
//                                 padding:
//                                     EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
//                                 child: Text('Reset',
//                                     textAlign: TextAlign.center,
//                                     style: style.copyWith(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18)),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(30.0)),
//                                 onPressed: () {
//                                   _onClear();
//                                 },
//                                 color: Colors.cyan.shade400),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )));
//   }
//
//   void checkvalue() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//     } else {
//       debugPrint("If all data are not valid then start auto validation.");
//       setState(() {
//         _autoValidate = true;
//       });
//     }
//   }
//
//   final snackbar = SnackBar(
//     backgroundColor: Colors.redAccent[100],
//     content: Container(
//       child: Text(
//         'Please select values',
//         style: TextStyle(
//             fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
//       ),
//     ),
//     action: SnackBarAction(
//       label: 'Undo',
//       onPressed: () {},
//     ),
//   );
// }
