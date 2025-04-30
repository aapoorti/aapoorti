// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
//
// import 'package:flutter_app/udm/providers/languageProvider.dart';
// import 'package:flutter_app/udm/rejection_warranty/providers/search_rwscreen_provider.dart';
// import 'package:flutter_app/udm/rejection_warranty/view_tabs/my_approved_dropped_claims_screen.dart';
// import 'package:flutter_app/udm/rejection_warranty/view_tabs/my_forwarded_claim_screen.dart';
// import 'package:flutter_app/udm/rejection_warranty/view_tabs/warranty_complaint_screen.dart';
// import 'package:flutter_app/udm/screens/user_home_screen.dart';
// import 'package:provider/provider.dart';
//
//
// class WarrantyRejectionScreen extends StatefulWidget {
//   static const routeName = "/rejection-warranty-screen";
//
//   @override
//   State<WarrantyRejectionScreen> createState() => _WarrantyRejectionScreenState();
// }
//
// class _WarrantyRejectionScreenState extends State<WarrantyRejectionScreen> with SingleTickerProviderStateMixin{
//
//   String status = "All";
//   String statuscode = "-1";
//
//   String fromdate = "";
//   String todate = "";
//
//   int _activeindex = 0;
//
//   final _textsearchController = TextEditingController();
//
//   late TabController tabController;
//
//   @override
//   void initState() {
//     tabController = TabController(length: 2, vsync: this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     LanguageProvider language = Provider.of<LanguageProvider>(context);
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: AapoortiConstants.primary,
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.home, color: Colors.white, size: 22),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 //Feedback.forTap(context);
//               },
//             ),
//           ],
//           title: Consumer<SearchRWScreenProvider>(
//               builder: (context, value, child) {
//                 if(value.getSearchValue == true){
//                   return Container(
//                     width: double.infinity,
//                     height: 40,
//                     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
//                     child: Center(child: TextField(
//                       cursorColor: AapoortiConstants.primary,
//                       controller: _textsearchController,
//                       decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.search, color: AapoortiConstants.primary),
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.clear, color: AapoortiConstants.primary),
//                             onPressed: () {
//                               Provider.of<SearchRWScreenProvider>(context, listen: false).updateScreen(false);
//                               _textsearchController.text = "";
//                               Future.delayed(const Duration(milliseconds: 400), () {
//                                 //Provider.of<NonStockDemandViewModel>(context, listen: false).searchingFwdfinalizedData(_textsearchController.text.toString().trim(), context);
//                               });
//                             },
//                           ),
//                           hintText: language.text('search'),
//                           border: InputBorder.none),
//                       onChanged: (query) {
//                         //Provider.of<NonStockDemandViewModel>(context, listen: false).searchingFwdfinalizedData(_textsearchController.text.toString().trim(), context);
//                       },
//                     ),
//                     ),
//                   );
//                 }
//                 else{
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       InkWell(
//                           onTap: () {
//                             Navigator.of(context, rootNavigator: true).pushNamed(UserHomeScreen.routeName);
//                             //Navigator.pop(context);
//                           },
//                           child: Icon(Icons.arrow_back, color: Colors.white)),
//                       SizedBox(width: 10),
//                       Text(language.text('rwtitle'), maxLines: 1, style: TextStyle(color: Colors.white))
//                     ],
//                   );
//                 }
//               }),
//           // bottom: TabBar(
//           //   onTap: (tabindex){
//           //     _activeindex = tabindex;
//           //     _textsearchController.text = "";
//           //   },
//           //   indicator: BoxDecoration(
//           //       borderRadius: BorderRadius.all(Radius.circular(60)),
//           //       color: Colors.blue),
//           //   tabs: [
//           //     //Tab(child: Text(language.text('rwwarantycmptitle'))),
//           //     Tab(child: Text(language.text('fwctitle'))),
//           //     Tab(child: Text(language.text('apdtitle'))),
//           //     //Tab(child: Text(language.text('casetracker'))),
//           //   ],
//           //   isScrollable: true,
//           //   indicatorColor: Colors.white,
//           //   indicatorWeight: 3,
//           // ),
//         ),
//         body: Container(
//           height: size.height,
//           child: Column(
//             children: [
//               Container (
//                 width: size.width,
//                 decoration: BoxDecoration(
//                   color: AapoortiConstants.primary,
//                   borderRadius: BorderRadius.circular(0),
//                 ),
//                 child: Column(
//                   children: [
//                     Padding(
//                         padding: EdgeInsets.all(5),
//                         child: TabBar(
//                           onTap: (tabindex){
//                             _activeindex = tabindex;
//                             _textsearchController.text = "";
//                           },
//                           tabs: [
//                             //Tab(child: Text(language.text('rwwarantycmptitle'))),
//                             Tab(child: Text(language.text('fwctitle'), textAlign: TextAlign.center)),
//                             Tab(child: Text(language.text('apdtitle'), textAlign: TextAlign.center)),
//                             //Tab(child: Text(language.text('casetracker'))),
//                           ],
//                           unselectedLabelColor: Colors.white,
//                           labelColor: Colors.black,
//                           isScrollable: false,
//                           indicatorColor: Colors.white,
//                           indicatorSize: TabBarIndicatorSize.tab,
//                           indicatorWeight: 2,
//                           indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
//                           controller: tabController,
//                         )
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 5),
//               Expanded(child: TabBarView(
//                 controller: tabController,
//                 children: [
//                       //WarrantyComplaintScreen(),
//                       MyForwardedClaimScreen(),
//                       MyApprovedDroppedClaimScreen(),
//                       //CaseTrackerScreen()
//                 ],
//               ))
//             ],
//           ),
//         ),
//         // body: TabBarView(
//         //   physics: NeverScrollableScrollPhysics(),
//         //   children: [
//         //     //WarrantyComplaintScreen(),
//         //     MyForwardedClaimScreen(),
//         //     MyApprovedDroppedClaimScreen(),
//         //     //CaseTrackerScreen()
//         //   ],
//         // )
//     );
//   }
// }


//------------------------------ New Screen UI------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/rejection_warranty/view_model/rejectionwarranty_view_model.dart';
import 'package:flutter_app/udm/rejection_warranty/view_tabs_screens/my_approved_dropped_claims_data_screen.dart';
import 'package:flutter_app/udm/rejection_warranty/view_tabs_screens/my_forwarded_data_screen.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WarrantyRejectionScreen extends StatefulWidget {
  static const routeName = "/rejection-warranty-screen";

  @override
  _WarrantyRejectionScreenState createState() => _WarrantyRejectionScreenState();
}

class _WarrantyRejectionScreenState extends State<WarrantyRejectionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _approvedSearchController = TextEditingController();
  DateTime _startDate = DateTime.now().subtract(Duration(days: 180));
  DateTime _endDate = DateTime.now();
  DateTime _approvedStartDate = DateTime(2024, 10, 30);
  DateTime _approvedEndDate = DateTime(2025, 4, 28);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _approvedSearchController.dispose();
    super.dispose();
  }

  // Custom date formatter
  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return '$day-$month-$year';
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[800]!,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
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

  Future<void> _selectApprovedDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _approvedStartDate : _approvedEndDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[800]!,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _approvedStartDate = picked;
        } else {
          _approvedEndDate = picked;
        }
      });
    }
  }

  clearfwdclaims(){
    setState(() {
      _startDate = DateTime.now().subtract(Duration(days: 180));
      _endDate = DateTime.now();
      _searchController.text = '';
    });
  }

  clearApprovedClaims(){
    _approvedStartDate = DateTime.now().subtract(Duration(days: 180));
    _approvedEndDate = DateTime.now();
    _approvedSearchController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        title: Text(
          language.text('rwtitle'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(language),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildClaimsTab(language),
                _buildHistoryTab(language),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(LanguageProvider language) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[700],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      height: 50, // Fixed height for the tab bar
      child: TabBar(
        controller: _tabController,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 3.0, color: Colors.white),
          insets: EdgeInsets.symmetric(horizontal: 12.0), // Reduced insets
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13, // Smaller font size
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13, // Smaller font size
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 4), // Reduced padding
        tabs: [
          Tab(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(language.text('fwctitle')),
            ),
          ),
          Tab(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(language.text('apdtitle')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimsTab(LanguageProvider language) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDateRangeSelector(language),
          SizedBox(height: 8),
          _buildSearchBox(language),
          SizedBox(height: 8),
          _buildActionButtons(language),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(LanguageProvider language) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildApprovedDateRangeSelector(language),
          SizedBox(height: 8),
          _buildApprovedSearchBox(language),
          SizedBox(height: 8),
          _buildApprovedActionButtons(language),
          SizedBox(height: 16),
          Container(height: 300),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector(LanguageProvider language) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.text('wcp'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.text('from'),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(_startDate),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Colors.blue[800]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.text('to'),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(_endDate),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Colors.blue[800]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedDateRangeSelector(LanguageProvider language) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language.text('wcp'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.text('from'),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectApprovedDate(context, true),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(_approvedStartDate),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Colors.blue[800]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.text('to'),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectApprovedDate(context, false),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(_approvedEndDate),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Colors.blue[800]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox(LanguageProvider language) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: language.text('rwsearchhint'),
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildApprovedSearchBox(LanguageProvider language) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _approvedSearchController,
        decoration: InputDecoration(
          hintText: language.text('rwsearchhint'),
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildActionButtons(LanguageProvider language) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Consumer<RejectionWarrantyViewModel>(builder: (context, value, child){
               return ElevatedButton(
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),
                 ),
                 onPressed: () {
                   if(value.fcmonthcountstate == RWfcCheckMonthState.greater){
                     UdmUtilities.showWarningFlushBar(context, language.text('monthwarning'));
                   }
                   else{
                     if(_searchController.text.trim().length == 0){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => MyForwardedClaimsDataScreen(DateFormat('dd-MM-yyyy').format(_startDate), DateFormat('dd-MM-yyyy').format(_endDate), " ")));
                     }
                     else{
                       Navigator.push(context, MaterialPageRoute(builder: (context) => MyForwardedClaimsDataScreen(DateFormat('dd-MM-yyyy').format(_startDate), DateFormat('dd-MM-yyyy').format(_endDate), _searchController.text.trim())));
                     }
                   }
                 },
                 child: Text(language.text('rwsearch')),
               );
            }),
          ),
          SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                clearfwdclaims();
              },
              child: Text(language.text('clear')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedActionButtons(LanguageProvider language) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Consumer<RejectionWarrantyViewModel>(builder: (context, value, child){
               return ElevatedButton(
                 style: ButtonStyle(
                   backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),
                 ),
                 onPressed: () {
                   if(value.adcmonthcountstate == RWadcCheckMonthState.greater){
                     UdmUtilities.showWarningFlushBar(context, language.text('monthwarning'));
                   }
                   else{
                     if (_approvedSearchController.text.trim().length == 0) {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => MyApprovedDroppedClaimsDataScreen(DateFormat('dd-MM-yyyy').format(_approvedStartDate), DateFormat('dd-MM-yyyy').format(_approvedEndDate), " ")));
                     }
                     else {Navigator.push(context, MaterialPageRoute(builder: (context) => MyApprovedDroppedClaimsDataScreen(DateFormat('dd-MM-yyyy').format(_approvedStartDate), DateFormat('dd-MM-yyyy').format(_approvedEndDate), _approvedSearchController.text)));}
                   }
                 },
                 child: Text(language.text('rwsearch')),
               );
            }),
          ),
          SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                clearApprovedClaims();
              },
              child: Text(language.text('clear')),
            ),
          ),
        ],
      ),
    );
  }
}