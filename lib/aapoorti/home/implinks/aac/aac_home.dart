import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/home/implinks/aac/aacnextpage.dart';

class DropDown extends StatefulWidget {
  DropDown() : super();

  final String title = "DropDown Demo";

  @override
  DropDownState1 createState() => DropDownState1();
}

class DropDownState1 extends State<DropDown> {
  List<dynamic>? jsonResult2, jsonResult1;
  ProgressDialog? pr;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  bool _autoValidate = false;
  bool pressed = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? myselection2, myselection1, catid;
  DropDownState1({this.catid});

  List data = [];
  List data1 = [];

  Future<void> fetchPost() async {
    AapoortiUtilities.getProgressDialog(pr!);
    try {
      var u = AapoortiConstants.webServiceUrl + '/getData?input=SPINNERS,ORGANIZATION';
      final response = await http.post(Uri.parse(u));
      jsonResult1 = json.decode(response.body);
      if (response.statusCode != 200) throw Exception('HTTP request failed');
      AapoortiUtilities.stopProgress(pr!);
      data = jsonResult1!;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      AapoortiUtilities.stopProgress(pr!);
    }
  }

  Future<void> fetchdata() async {
    try {
      myselection2 = null;
      if (myselection1 != "-1") {
        AapoortiUtilities.getProgressDialog(pr!);
        var u = AapoortiConstants.webServiceUrl +
            '/getData?input=SPINNERS,ZONE,${myselection1}';
        final response1 = await http.post(Uri.parse(u));
        jsonResult2 = json.decode(response1.body);
        AapoortiUtilities.stopProgress(pr!);
        setState(() {
          jsonResult2!.removeAt(0);
          data1 = jsonResult2!;
        });
      }
    }
    catch(e){
      AapoortiUtilities.stopProgress(pr!);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      pr = ProgressDialog(context);
      fetchPost();
    });
  }

  Widget _myListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance, color: Colors.lightBlue[800]),
                labelText: "Select Organization",
              ),
              items: data.map((item) {
                return DropdownMenuItem(child: Text(item['NAME']), value: item['ID'].toString());
              }).toList(),
              onChanged: (newVal1) {
                setState(() {
                  myselection2 = null;
                  data1.clear();
                  myselection1 = newVal1;
                });
                fetchdata();
              },
              value: myselection1,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.train_rounded, color: Colors.lightBlue[800]),
                labelText: "Select Railway",
              ),
              items: data1.map((item) {
                return DropdownMenuItem(child: Text(item['NAME']), value: item['ID'].toString());
              }).toList(),
              onChanged: (newVal2) {
                setState(() {
                  myselection2 = newVal2;
                });
              },
              value: myselection2,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    backgroundColor: Colors.lightBlue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (myselection1 != null && myselection2 != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => aac2(value: DropDownState1(catid: myselection2)),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Show Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[800],
        title: Text('AAC-Item Annual Consumption', style: TextStyle(color: Colors.white,fontSize: 18)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false),
          ),
        ],
      ),
      body: ListView(children: <Widget>[_myListView(context)]),
    );
  }

  final snackbar = SnackBar(
    backgroundColor: Colors.redAccent[100],
    content: Text('Please select values', style: TextStyle(fontSize: 18, color: Colors.white)),
  );
}
