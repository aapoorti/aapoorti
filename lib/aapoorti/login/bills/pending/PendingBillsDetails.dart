// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
// import 'package:flutter_app/aapoorti/common/DatabaseHelper.dart';
// import 'package:flutter_app/aapoorti/common/NoData.dart';
// import 'package:flutter_app/aapoorti/common/NoResponse.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter/src/painting/text_style.dart' as textSt;
//
// class PendingBillDetails extends StatefulWidget {
//   final String? pokeyN, desc;
//   PendingBillDetails({this.pokeyN, this.desc});
//   @override
//   _PendingBillDetailsState createState() =>
//       _PendingBillDetailsState(this.pokeyN!, this.desc!);
// }
//
// class _PendingBillDetailsState extends State<PendingBillDetails> {
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   String? pokeyN, desc;
//   _PendingBillDetailsState(String pokey, String desc) {
//     this.pokeyN = pokey;
//     this.desc = desc;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       key: _scaffoldKey,
//       appBar: AppBar(
//         iconTheme: new IconThemeData(color: Colors.white),
//         backgroundColor: Colors.teal,
//         title: Text('My Pending Bills',
//             style: textSt.TextStyle(color: Colors.white)),
//       ),
//       drawer: AapoortiUtilities.navigationdrawer(_scaffoldKey,context),
//       body: jsonResult == null
//           ? SpinKitFadingCircle(
//               color: Colors.cyan,
//               size: 120.0,
//             )
//           : ListView.builder(
//               itemBuilder: (BuildContext context, int index) {
//                 return _expandList(context);
//               },
//               itemCount: 1,
//             ),
//     );
//   }
//
//   void initState() {
//     super.initState();
//     callWebService();
//   }
//
//   bool expandFlag = false;
//   List<dynamic>? jsonResult;
//   void callWebService() async {
//     String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
//         "," +
//         AapoortiUtilities.user!.S_TOKEN +
//         ",Flutter,0,0";
//     String inputParam2 = AapoortiUtilities.user!.MAP_ID +
//         "," +
//         AapoortiUtilities.user!.CUSTOM_WK_AREA +
//         "," +
//         pokeyN.toString();
//     print(inputParam1);
//     print(inputParam2);
//     jsonResult = await AapoortiUtilities.fetchPostPostLogin(
//         'Login/PendingBillDtls', 'PendingBillDtls', inputParam1, inputParam2, context);
//     if (jsonResult!.length == 0) {
//       jsonResult = null;
//       Navigator.pop(context);
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => NoData()));
//     } else if (jsonResult![0]['ErrorCode'] == 3) {
//       jsonResult = null;
//       Navigator.pop(context);
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => NoResponse()));
//     }
//     print(jsonResult);
//     setState(() {});
//   }
//
//   @override
//   Widget _expandList(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 1.0),
//       child: Column(
//         children: <Widget>[
//           Container(
//             color: Colors.orange[50],
//             padding: EdgeInsets.symmetric(horizontal: 5.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   "   Firm and Tender Details",
//                   style: textSt.TextStyle(fontSize: 16, color: Colors.teal),
//                 ),
//                 IconButton(
//                     icon: Container(
//                       height: 50.0,
//                       width: 50.0,
//                       decoration: new BoxDecoration(
//                         color: Colors.teal,
//                         shape: BoxShape.circle,
//                       ),
//                       child: new Center(
//                         child: new Icon(
//                           expandFlag
//                               ? Icons.keyboard_arrow_up
//                               : Icons.keyboard_arrow_down,
//                           color: Colors.white,
//                           size: 30.0,
//                         ),
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         expandFlag = !expandFlag;
//                       });
//                     })
//               ],
//             ),
//           ),
//           new ExpandableContainer(
//             expanded: expandFlag,
//             child: new Container(
//                 decoration: new BoxDecoration(
//                     border: new Border.all(width: 1.0, color: Colors.teal),
//                     color: Colors.white),
//                 padding: new EdgeInsets.symmetric(horizontal: 5.0),
//                 child: new Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       Expanded(
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               new Text(
//                                 "Firm Name",
//                                 textAlign: TextAlign.left,
//                                 style: new textSt.TextStyle(color: Colors.teal),
//                               ),
//                               Padding(padding: EdgeInsets.only(left: 70)),
//                               AapoortiUtilities.customTextView(
//                                   jsonResult![0]["BIDDER_ACCT_NAME"],
//                                   Colors.black),
//                             ]),
//                       ),
//                       Expanded(
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 "User",
//                                 style: textSt.TextStyle(color: Colors.teal),
//                               ),
//                               Padding(padding: EdgeInsets.only(left: 110)),
//                               AapoortiUtilities.customTextView(
//                                   jsonResult![0]["NAME"], Colors.black),
//                             ]),
//                       ),
//                       Expanded(
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 "Address           ",
//                                 style: new textSt.TextStyle(color: Colors.teal),
//                               ),
//                               Padding(padding: EdgeInsets.only(left: 53)),
//                               AapoortiUtilities.customTextView(
//                                   jsonResult![0]["ADDR"], Colors.black),
//                             ]),
//                       ),
//                       Expanded(
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               AapoortiUtilities.customTextView(
//                                   "Tender No", Colors.teal),
//                               Padding(padding: EdgeInsets.only(left: 75)),
//                               AapoortiUtilities.customTextView(
//                                   jsonResult![0]["TEND_NO"], Colors.black),
//                             ]),
//                       ),
//                       Expanded(
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               AapoortiUtilities.customTextView(
//                                   "Closing Date", Colors.teal),
//                               Padding(padding: EdgeInsets.only(left: 60)),
//                               AapoortiUtilities.customTextView(
//                                   jsonResult![0]["TENDER_OPDATE"], Colors.black),
//                             ]),
//                       ),
//                       Expanded(
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               AapoortiUtilities.customTextView(
//                                   "Contract No", Colors.teal),
//                               Padding(padding: EdgeInsets.only(left: 65)),
//                               AapoortiUtilities.customTextView(
//                                   jsonResult![0]["CONTRACT_NO"], Colors.black),
//                             ]),
//                       ),
//                       Expanded(
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               AapoortiUtilities.customTextView(
//                                   "Contract Date", Colors.teal),
//                               Padding(padding: EdgeInsets.only(left: 55)),
//                               AapoortiUtilities.customTextView(
//                                   jsonResult![0]["CONTRACT_DATE"], Colors.black),
//                             ]),
//                       ),
//                       Expanded(
//                         child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               AapoortiUtilities.customTextView(
//                                   "Name Of Work", Colors.teal),
//                               Padding(padding: EdgeInsets.only(left: 50)),
//                               Expanded(
//                                 child: AapoortiUtilities.customTextView(
//                                     jsonResult![0]["WRK_NM"], Colors.black),
//                               ),
//                             ]),
//                       ),
//                     ])
//                 /*  leading: new Icon(
//                 Icons.local_pizza,
//             color: Colors.white,
//           ),*/
//                 ),
//           ),
//           _myListView(context)
//         ],
//       ),
//     );
//   }
//
//   Widget _myListView(BuildContext context) {
//     return Container(
//         child: Container(
//             padding: EdgeInsets.all(10),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Expanded(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Center(
//                                     child: Text("Bill Details",
//                                         textAlign: TextAlign.center,
//                                         style: textSt.TextStyle(
//                                           color: Colors.teal,
//                                           fontSize: 17,
//                                         ),
//                                         overflow: TextOverflow.ellipsis)),
//                               ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "Bill/GST Invoice No", Colors.teal),
//                             ),
//                             Container(
//                               height: 30,
//                               child: AapoortiUtilities.customTextView(
//                                   jsonResult![0]["INV_BILL_NO"].toString(),
//                                   Colors.black),
//                             )
//                           ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "Bill/GST Invoice Date", Colors.teal),
//                             ),
//                             Container(
//                               height: 30,
//                               child: AapoortiUtilities.customTextView(
//                                   jsonResult![0]["INV_BILL_DATE"].toString(),
//                                   Colors.black),
//                             )
//                           ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "Amount Claimed", Colors.teal),
//                             ),
//                             Container(
//                               height: 30,
//                               child: AapoortiUtilities.customTextView(
//                                   jsonResult![0]["BILL_AMT"].toString(),
//                                   Colors.black),
//                             )
//                           ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "Amount Paid", Colors.teal),
//                             ),
//                             Container(
//                               height: 30,
//                               child: AapoortiUtilities.customTextView(
//                                   jsonResult![0]["AMT_PAID"].toString(),
//                                   Colors.black),
//                             )
//                           ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "GSTIN No", Colors.teal),
//                             ),
//                             Container(
//                               height: 30,
//                               child: AapoortiUtilities.customTextView(
//                                   jsonResult![0]["BIDDER_GSTN"].toString(),
//                                   Colors.black),
//                             )
//                           ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 40,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "Bill Submitted to\nExec Dept On",
//                                   Colors.teal),
//                             ),
//                             Container(
//                               height: 30,
//                               child: AapoortiUtilities.customTextView(
//                                   jsonResult![0]["BILL_SUBMIT_DATE"].toString(),
//                                   Colors.black),
//                             )
//                           ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "Remarks", Colors.teal),
//                             ),
//                             Container(
//                               height: 30,
//                               child: AapoortiUtilities.customTextView(
//                                   jsonResult![0]["CONTRACTOR_REMARK"].toString(),
//                                   Colors.black),
//                             )
//                           ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 90,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "Certificate by\nContractor", Colors.teal),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 jsonResult![0]["CERTI_DESC"].toString(),
//                                 textAlign: TextAlign.justify,
//                                 style: textSt.TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             )
//                           ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               height: 30,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "Bill Submitted To", Colors.teal),
//                             ),
//                             Container(
//                               height: 30,
//                               child: AapoortiUtilities.customTextView(
//                                   jsonResult![0]["BILL_PREP_DESIG"].toString() +
//                                       "/" +
//                                       jsonResult![0]["DEPARTMENT_NAME"]
//                                           .toString(),
//                                   Colors.black),
//                             )
//                           ]),
//                           Padding(padding: EdgeInsets.only(top: 10)),
//                           Row(children: <Widget>[
//                             Container(
//                               // height: 50,
//                               width: 150,
//                               child: AapoortiUtilities.customTextView(
//                                   "Current Status", Colors.teal),
//                             ),
//                             Expanded(
//                               child: Container(
//                                   // height: 50,
//                                   child: Text(
//                                 desc!,
//                                 textAlign: TextAlign.justify,
//                                 style: textSt.TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 15,
//                                 ),
//                                 // AapoortiUtilities.customTextView(desc, Colors.black),
//                               )),
//                             )
//                           ]),
//                         ]),
//                   ),
//                 ])));
//   }
// }
//
// class ExpandableContainer extends StatelessWidget {
//   final bool expanded;
//   final double collapsedHeight;
//   final double expandedHeight;
//   final Widget child;
//
//   ExpandableContainer({
//     required this.child,
//     this.collapsedHeight = 0.0,
//     this.expandedHeight = 300.0,
//     this.expanded = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return new AnimatedContainer(
//       duration: new Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//       width: screenWidth,
//       height: expanded ? expandedHeight : collapsedHeight,
//       child: new Container(
//         child: child,
//         decoration: new BoxDecoration(
//             border: new Border.all(width: 0.1, color: Colors.teal)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/NoData.dart';
import 'package:flutter_app/aapoorti/common/NoResponse.dart';

class PendingBillDetails extends StatefulWidget {
  final String? pokeyN, desc;

  const PendingBillDetails({Key? key, this.pokeyN, this.desc}) : super(key: key);

  @override
  _PendingBillDetailsState createState() => _PendingBillDetailsState();
}

class _PendingBillDetailsState extends State<PendingBillDetails> {
  // Track position of floating back button
  Offset _buttonPosition = const Offset(20, 100);
  List<dynamic>? jsonResult;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchBillDetails();
  }

  Future<void> _fetchBillDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Validate parameters
      if (widget.pokeyN == null || widget.pokeyN!.isEmpty) {
        throw Exception("Invalid bill reference");
      }

      // Prepare parameters
      String inputParam1 = AapoortiUtilities.user!.C_TOKEN +
          "," +
          AapoortiUtilities.user!.S_TOKEN +
          ",Flutter,0,0";
      String inputParam2 = AapoortiUtilities.user!.MAP_ID +
          "," +
          AapoortiUtilities.user!.CUSTOM_WK_AREA +
          "," +
          widget.pokeyN.toString();

      // Fetch data
      final result = await AapoortiUtilities.fetchPostPostLogin(
          'Login/PendingBillDtls', 'PendingBillDtls', inputParam1, inputParam2, context);

      // Handle response
      if (result == null || result.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = "No data available";
        });

        // Navigate to NoData screen
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => NoData()));
        return;
      }

      // Handle error code
      if (result[0]['ErrorCode'] == 3) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = "No response from server";
        });

        // Navigate to NoResponse screen
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => NoResponse()));
        return;
      }

      // Success case
      setState(() {
        jsonResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = "Error: ${e.toString()}";
      });

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Function to handle back navigation
  void _goBack() {
    Navigator.pop(context);
  }

  // Function to safely get a value from jsonResult
  String _safeGetValue(String key, {String defaultValue = "N/A"}) {
    try {
      if (jsonResult == null || jsonResult!.isEmpty) return defaultValue;
      return jsonResult![0][key]?.toString() ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for button constraints
    final screenSize = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Pending Bills', style: TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _goBack,
        ),
        actions: [
          // Add refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchBillDetails,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading ? Center(
        child: SpinKitFadingCircle(
          color: Colors.blue.shade800,
          size: 120.0,
        ),
      ) : _hasError ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchBillDetails,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ) : SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Status Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Date information with submission icon
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Submitted on',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.assignment_turned_in_outlined,
                                  size: 16,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _safeGetValue("BILL_SUBMIT_DATE"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Status information
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.pending_actions_rounded,
                              size: 12,
                              color: Colors.orange.shade800,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.desc ?? "Pending",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchBillDetails,
                    color: Colors.blue.shade800,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // First Section: Bill Details
                        _buildSectionCard(
                          context,
                          icon: Icons.receipt_long_rounded,
                          title: 'Bill Details',
                          content: [
                            _buildInvoiceDetails(
                              _safeGetValue("INV_BILL_NO"),
                              _safeGetValue("INV_BILL_DATE"),
                              _safeGetValue("BIDDER_GSTN"),
                            ),
                            _buildAmountDetails(
                              _safeGetValue("BILL_AMT", defaultValue: "0"),
                              _safeGetValue("AMT_PAID", defaultValue: "0"),
                            ),
                            _buildDetailItem('Remarks', _safeGetValue("CONTRACTOR_REMARK")),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Second Section: Submission Details
                        _buildSectionCard(
                          context,
                          icon: Icons.verified_rounded,
                          title: 'Submission Details',
                          content: [
                            _buildDetailItem('Bill Submitted To',
                                _safeGetValue("BILL_PREP_DESIG") + "/" +
                                    _safeGetValue("DEPARTMENT_NAME")),
                            _buildDetailItem('Certificate', _safeGetValue("CERTI_DESC"), isLongText: true),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Third Section: Firm Details
                        _buildSectionCard(
                          context,
                          icon: Icons.business_rounded,
                          title: 'Firm Details',
                          content: [
                            _buildDetailItem('Firm Name', _safeGetValue("BIDDER_ACCT_NAME")),
                            _buildDetailItem('User', _safeGetValue("NAME")),
                            _buildDetailItem('Address', _safeGetValue("ADDR")),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Fourth Section: Tender Details
                        _buildSectionCard(
                          context,
                          icon: Icons.description_rounded,
                          title: 'Tender Details',
                          content: [
                            _buildDetailItem('Tender No', _safeGetValue("TEND_NO")),
                            _buildDetailItem('Closing Date', _safeGetValue("TENDER_OPDATE")),
                            _buildDetailItem('Contract No', _safeGetValue("CONTRACT_NO")),
                            _buildDetailItem('Contract Date', _safeGetValue("CONTRACT_DATE")),
                            _buildDetailItem('Name Of Work', _safeGetValue("WRK_NM")),
                          ],
                        ),

                        // Extra padding at the bottom
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Improved draggable floating back button with more transparency
            Positioned(
              left: _buttonPosition.dx,
              top: _buttonPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // Update position but stay within screen bounds
                    _buttonPosition = Offset(
                      (_buttonPosition.dx + details.delta.dx).clamp(0, screenSize.width - 50),
                      (_buttonPosition.dy + details.delta.dy).clamp(50, screenSize.height - 100),
                    );
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15), // More transparent background
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _goBack, // Use the same function as appbar back button
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required List<Widget> content,
      }) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue.shade800,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(
              thickness: 1,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 8),
            ...content,
          ],
        ),
      ),
    );
  }

  // Widget to display merged invoice details with colons removed
  Widget _buildInvoiceDetails(String invoiceNo, String invoiceDate, String gstinNo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Invoice Details',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        'No ',  // Removed colon
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        invoiceNo,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        'Date ',  // Removed colon
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        invoiceDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        'GSTIN ',  // Removed colon
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        gstinNo,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isLongText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: isLongText
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
          ),
        ],
      )
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDetails(String claimed, String paid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Amount',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        'Claimed ',  // Removed colon
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '₹$claimed',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        'Paid ',  // Removed colon
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '₹$paid',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}