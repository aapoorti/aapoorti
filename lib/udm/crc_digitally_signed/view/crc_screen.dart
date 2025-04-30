import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/udm/crc_digitally_signed/providers/crcscreen_update_changes.dart';
import 'package:flutter_app/udm/crc_digitally_signed/tabs_views/crc_approval_screen.dart';
import 'package:flutter_app/udm/crc_digitally_signed/tabs_views/crc_finalized_screen.dart';
import 'package:flutter_app/udm/crc_digitally_signed/tabs_views/crc_myfinalised_screen.dart';
import 'package:flutter_app/udm/crc_digitally_signed/tabs_views/crc_myforwaded_screen.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcAwaitingViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcMyfinalisedViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcMyforwardedViewModel.dart';
import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcfinalizedViewModel.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/screens/user_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrcScreen extends StatefulWidget {
  static const routeName = "/crc-screen";

  @override
  State<CrcScreen> createState() => _CrcScreenState();
}

class _CrcScreenState extends State<CrcScreen> with SingleTickerProviderStateMixin {

  final _textsearchController = TextEditingController();

  int _activeindex = 0;

  String gradecode = "";

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    _getUsergradecode();
    //Provider.of<Crcusertype>(context, listen: false).fetchUserData(context);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  _getUsergradecode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gradecode = prefs.getString("gradecode").toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    final updatechangeprovider = Provider.of<CrcupdateChangesScreenProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AapoortiConstants.primary,
          automaticallyImplyLeading: false,
          title: Consumer<CrcupdateChangesScreenProvider>(
              builder: (context, value, child) {
                if(value.getSearchValue) {
                  return Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Center(child: TextField(
                      cursorColor: AapoortiConstants.primary,
                      controller: _textsearchController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: AapoortiConstants.primary),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: AapoortiConstants.primary),
                            onPressed: () {
                              if(_activeindex == 0 && gradecode == "N"){
                                _textsearchController.text = "";
                                updatechangeprovider.updateScreen(false);
                                Provider.of<CrcMyforwardedViewModel>(context, listen: false).getsearchMyforwardedcrcData(_textsearchController.text, context);
                              }
                              else if(_activeindex == 0 && gradecode != "N"){
                                _textsearchController.text = "";
                                updatechangeprovider.updateScreen(false);
                                Provider.of<CrcAwaitingViewModel>(context, listen: false).getsearchAwaitcrcData(_textsearchController.text, context);
                              }
                              else if(_activeindex == 1 && gradecode == "N"){
                                _textsearchController.text = "";
                                updatechangeprovider.updateScreen(false);
                                Provider.of<CrcMyfinalisedViewModel>(context, listen: false).getsearchMyfinalisedcrcData(_textsearchController.text, context);
                              }
                              else{
                                _textsearchController.text = "";
                                updatechangeprovider.updateScreen(false);
                                Provider.of<CrcfinalizedViewModel>(context, listen: false).getsearchfinalisedcrcData(_textsearchController.text, context);
                              }
                            },
                          ),
                          hintText: language.text('search'),
                          border: InputBorder.none),
                      onChanged: (query) {
                        if(_activeindex == 0 && gradecode == "N"){
                          Provider.of<CrcMyforwardedViewModel>(context, listen: false).getsearchMyforwardedcrcData(query, context);
                        }
                        else if(_activeindex == 0 && gradecode != "N"){
                          Provider.of<CrcAwaitingViewModel>(context, listen: false).getsearchAwaitcrcData(query, context);
                        }
                        else if(_activeindex == 1 && gradecode == "N"){
                          Provider.of<CrcMyfinalisedViewModel>(context, listen: false).getsearchMyfinalisedcrcData(query, context);
                        }
                        else{
                          Provider.of<CrcfinalizedViewModel>(context, listen: false).getsearchfinalisedcrcData(query, context);
                        }
                      },
                    ),
                    ),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pushNamed(UserHomeScreen.routeName);
                            //Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                      SizedBox(width: 10),
                      Text(language.text('crcdigisigned').length > 25
                          ? '${language.text('crcdigisigned').substring(0, 25)}...'
                          : language.text('crcdigisigned'), style: TextStyle(color: Colors.white, fontSize: 18))
                    ],
                  );
                }
              }),
          actions: [
            Consumer<CrcupdateChangesScreenProvider>(builder: (context, value, child){
              if(value.getSearchValue){
                return SizedBox();
              }
              else{
                return IconButton(
                    onPressed: () {
                      updatechangeprovider.updateScreen(true);
                    },
                    icon: Icon(Icons.search, color: Colors.white));
              }
            }),
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 22),
              onPressed: () {
                Navigator.of(context).pop();
                //Feedback.forTap(context);
              },
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blue[100], // Light blue background
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TabBar(
                            unselectedLabelColor: Colors.white,
                            labelColor: Colors.black,
                            //indicatorColor: Colors.white,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 0,
                            indicatorPadding: EdgeInsets.zero,
                            isScrollable: false,
                            onTap: (tabindex) {
                              _activeindex = tabindex;
                            },
                            indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                            controller: tabController,
                            tabs: [
                              gradecode == "N" ? Tab(child: Text(language.text('myforwarded'))) : Tab(child: Text(language.text('awaitingapproval'))),
                              gradecode == "N" ?  Tab(child: Text(language.text('myfinalised'))) : Tab(child: Text(language.text('finalizedme'))),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    gradecode == "N" ? CrcmyforwardedScreen() : CrcAwaitingApprovalScreen(),
                    gradecode == "N" ? CrcmyfinalisedScreen() : CrcFinalizedScreen(),
                  ],
                )
              )
            ],
          ),
        ),
        // body: TabBarView(
        //   physics: NeverScrollableScrollPhysics(),
        //   children: [
        //     gradecode == "N" ? CrcmyforwardedScreen() : CrcAwaitingApprovalScreen(),
        //     gradecode == "N" ? CrcmyfinalisedScreen() : CrcFinalizedScreen(),
        //   ],
        // )
    );
  }

}

//------------------------------------------CRC NEW Screen UI -------------------------------------
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/udm/crc_digitally_signed/providers/crcscreen_update_changes.dart';
// import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcAwaitingViewModel.dart';
// import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcMyfinalisedViewModel.dart';
// import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcMyforwardedViewModel.dart';
// import 'package:flutter_app/udm/crc_digitally_signed/view_model/CrcfinalizedViewModel.dart';
// import 'package:flutter_app/udm/providers/languageProvider.dart';
// import 'package:flutter_app/udm/screens/user_home_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CrcScreen extends StatefulWidget {
//   static const routeName = "/crc-screen";
//
//   @override
//   State<CrcScreen> createState() => _CrcScreenState();
// }
//
// class _CrcScreenState extends State<CrcScreen>
//     with SingleTickerProviderStateMixin {
//   int _selectedTabIndex = 0;
//   final DateTime _fromDate = DateTime(2024, 10, 28);
//   final DateTime _toDate = DateTime(2025, 4, 28);
//   final Map<int, bool> _expandedDescriptions = {};
//
//   final _textsearchController = TextEditingController();
//
//   int _activeindex = 0;
//
//   String gradecode = "";
//
//   late TabController tabController;
//
//   @override
//   void initState() {
//     tabController = TabController(length: 2, vsync: this);
//     super.initState();
//     _getUsergradecode();
//     //Provider.of<Crcusertype>(context, listen: false).fetchUserData(context);
//   }
//
//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }
//
//   _getUsergradecode() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       gradecode = prefs.getString("gradecode").toString();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     LanguageProvider language = Provider.of<LanguageProvider>(context);
//     final updatechangeprovider = Provider.of<CrcupdateChangesScreenProvider>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AapoortiConstants.primary,
//         automaticallyImplyLeading: false,
//         title: Consumer<CrcupdateChangesScreenProvider>(
//             builder: (context, value, child) {
//           if(value.getSearchValue) {
//             return Container(
//               width: double.infinity,
//               height: 40,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(5)),
//               child: Center(
//                 child: TextField(
//                   cursorColor: AapoortiConstants.primary,
//                   controller: _textsearchController,
//                   decoration: InputDecoration(
//                       prefixIcon:
//                           Icon(Icons.search, color: AapoortiConstants.primary),
//                       suffixIcon: IconButton(
//                         icon:
//                             Icon(Icons.clear, color: AapoortiConstants.primary),
//                         onPressed: () {
//                           if (_activeindex == 0 && gradecode == "N") {
//                             _textsearchController.text = "";
//                             updatechangeprovider.updateScreen(false);
//                             Provider.of<CrcMyforwardedViewModel>(context, listen: false).getsearchMyforwardedcrcData(
//                                     _textsearchController.text, context);
//                           } else if (_activeindex == 0 && gradecode != "N") {
//                             _textsearchController.text = "";
//                             updatechangeprovider.updateScreen(false);
//                             Provider.of<CrcAwaitingViewModel>(context,
//                                     listen: false)
//                                 .getsearchAwaitcrcData(
//                                     _textsearchController.text, context);
//                           } else if (_activeindex == 1 && gradecode == "N") {
//                             _textsearchController.text = "";
//                             updatechangeprovider.updateScreen(false);
//                             Provider.of<CrcMyfinalisedViewModel>(context,
//                                     listen: false)
//                                 .getsearchMyfinalisedcrcData(
//                                     _textsearchController.text, context);
//                           } else {
//                             _textsearchController.text = "";
//                             updatechangeprovider.updateScreen(false);
//                             Provider.of<CrcfinalizedViewModel>(context,
//                                     listen: false)
//                                 .getsearchfinalisedcrcData(
//                                     _textsearchController.text, context);
//                           }
//                         },
//                       ),
//                       hintText: language.text('search'),
//                       border: InputBorder.none),
//                   onChanged: (query) {
//                     if (_activeindex == 0 && gradecode == "N") {
//                       Provider.of<CrcMyforwardedViewModel>(context,
//                               listen: false)
//                           .getsearchMyforwardedcrcData(query, context);
//                     } else if (_activeindex == 0 && gradecode != "N") {
//                       Provider.of<CrcAwaitingViewModel>(context, listen: false)
//                           .getsearchAwaitcrcData(query, context);
//                     } else if (_activeindex == 1 && gradecode == "N") {
//                       Provider.of<CrcMyfinalisedViewModel>(context,
//                               listen: false)
//                           .getsearchMyfinalisedcrcData(query, context);
//                     } else {
//                       Provider.of<CrcfinalizedViewModel>(context, listen: false)
//                           .getsearchfinalisedcrcData(query, context);
//                     }
//                   },
//                 ),
//               ),
//             );
//           } else {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 InkWell(
//                     onTap: () {
//                       Navigator.of(context, rootNavigator: true).pushNamed(UserHomeScreen.routeName);
//                     },
//                     child: Icon(Icons.arrow_back, color: Colors.white)),
//                 SizedBox(width: 10),
//                 Text(
//                     language.text('crcdigisigned').length > 25
//                         ? '${language.text('crcdigisigned').substring(0, 25)}...'
//                         : language.text('crcdigisigned'),
//                     style: TextStyle(color: Colors.white, fontSize: 18))
//               ],
//             );
//           }
//         }),
//         actions: [
//           Consumer<CrcupdateChangesScreenProvider>(
//               builder: (context, value, child) {
//             if (value.getSearchValue) {
//               return SizedBox();
//             } else {
//               return IconButton(
//                   onPressed: () {
//                     updatechangeprovider.updateScreen(true);
//                   },
//                   icon: Icon(Icons.search, color: Colors.white));
//             }
//           }),
//           IconButton(
//             icon: const Icon(Icons.home, color: Colors.white, size: 22),
//             onPressed: () {
//               Navigator.of(context).pop();
//               //Feedback.forTap(context);
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.blue[100], // Light blue background
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 2,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: _buildTabButton(
//                     'My Forwarded',
//                     0,
//                     onPressed: () => setState(() => _selectedTabIndex = 0),
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildTabButton(
//                     'My Finalized Cases',
//                     1,
//                     onPressed: () => setState(() => _selectedTabIndex = 1),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Date Selection
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 4, bottom: 2),
//                         child: Text(
//                           'From Date',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ),
//                       _buildDateFieldRectangle(_fromDate),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 4, bottom: 2),
//                         child: Text(
//                           'To Date',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ),
//                       _buildDateFieldRectangle(_toDate),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Search Button
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue[600],
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 elevation: 0,
//                 minimumSize: const Size(double.infinity, 40),
//               ),
//               child: const Text(
//                 'Search',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
//
//           // Voucher List
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(12),
//               children: [
//                 _buildVoucherCard(
//                   voucherNo: '36640-24-00177',
//                   voucherDate: '19/02/2025',
//                   poNo: '01151061100002',
//                   poDate: '23-02-2023',
//                   forwarded: 'Sr.DME/EPS/UD<br>test.srdme1@gmail.com',
//                   forwardedDate: '28-02-2025',
//                   plNo: '75036484',
//                   vendorName: 'M/S TEST BIDDER 1...- KANPUR',
//                   itemDescription:
//                       'RUBBER HOSE FOR WELDING AND CUTTING WITH BARIDED TEXTILE REINFORCEMENT MODEL NO.SHINE STAR BORE 10MM COLOUR BLACK IS:447/1988.',
//                   recdQty: '1 MTR',
//                   recdValue: '22.56',
//                   index: 1,
//                 ),
//                 _buildVoucherCard(
//                   voucherNo: '36640-24-00080',
//                   voucherDate: '26/02/2024',
//                   poNo: '02056520246003',
//                   poDate: '17-04-2023',
//                   forwarded: 'Sr.DME/EPS/UD<br>example@email.com',
//                   forwardedDate: '28-02-2025',
//                   plNo: '75036400',
//                   vendorName: 'M/S VENDOR NAME - LOCATION',
//                   itemDescription:
//                       'SAMPLE ITEM DESCRIPTION TEXT CONTENT WITH ADDITIONAL DETAILS THAT SHOULD BE TRUNCATED AND SHOW A SEE MORE BUTTON FOR DEMONSTRATION PURPOSES. THE TEXT CONTINUES WITH MORE INFORMATION ABOUT THE PRODUCT SPECIFICATIONS AND OTHER RELEVANT DETAILS.',
//                   recdQty: '2 MTR',
//                   recdValue: '45.12',
//                   index: 2,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabButton(String title, int index,
//       {required VoidCallback onPressed}) {
//     final bool isSelected = _selectedTabIndex == index;
//
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               color: isSelected ? Colors.blue[800]! : Colors.transparent,
//               width: 2.0,
//             ),
//           ),
//         ),
//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: isSelected ? Colors.blue[800] : Colors.black54,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//             fontSize: 15,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateFieldRectangle(DateTime date) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               '${date.day}-${date.month}-${date.year}',
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Icon(
//             Icons.calendar_today,
//             size: 16,
//             color: Colors.blue[800],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVoucherCard({
//     required String voucherNo,
//     required String voucherDate,
//     required String poNo,
//     required String poDate,
//     required String forwarded,
//     required String forwardedDate,
//     required String plNo,
//     required String vendorName,
//     required String itemDescription,
//     required String recdQty,
//     required String recdValue,
//     required int index,
//   }) {
//     // Initialize the expanded state for this card if not already done
//     _expandedDescriptions[index] ??= false;
//     bool isExpanded = _expandedDescriptions[index]!;
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top row with index and voucher information
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Index number without circle
//                 Text(
//                   '$index.',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.blue[800],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 // Voucher info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: _buildInfoSection(
//                               title: 'Voucher No. & Date',
//                               value: '$voucherNo\n$voucherDate',
//                               bottomPadding: 12,
//                             ),
//                           ),
//                           Expanded(
//                             child: _buildInfoSection(
//                               title: 'PO No. & Date',
//                               value: '$poNo\n$poDate',
//                               bottomPadding: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             // Forwarded section
//             if (forwarded.isNotEmpty)
//               _buildInfoSection(
//                 title: 'Forwarded to/on',
//                 value: '$forwarded\n$forwardedDate',
//                 bottomPadding: 12,
//               ),
//
//             // PL and Vendor info
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: _buildInfoSection(
//                     title: 'PL No./Item Code',
//                     value: plNo,
//                     bottomPadding: 12,
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildInfoSection(
//                     title: 'Vendor Name',
//                     value: vendorName,
//                     bottomPadding: 12,
//                   ),
//                 ),
//               ],
//             ),
//
//             // Item Description with Show More/Less
//             if (itemDescription.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Item Description',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   // Container with fixed height for 3 lines when not expanded
//                   Container(
//                     constraints: isExpanded
//                         ? null
//                         : const BoxConstraints(
//                             maxHeight: 60), // Approx. 3 lines
//                     child: Text(
//                       itemDescription,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       overflow: isExpanded
//                           ? TextOverflow.visible
//                           : TextOverflow.ellipsis,
//                       maxLines: isExpanded ? null : 3,
//                     ),
//                   ),
//                   // Show More/Less button
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _expandedDescriptions[index] = !isExpanded;
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text(
//                         isExpanded ? 'Show Less' : 'Show More',
//                         style: TextStyle(
//                           color: Colors.blue[800],
//                           fontWeight: FontWeight.w500,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                 ],
//               ),
//
//             // Quantity and Value info
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: _buildInfoSection(
//                     title: 'Recd. Qty.',
//                     value: recdQty,
//                     bottomPadding: 8,
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildInfoSection(
//                     title: 'Recd. Value(Rs.)',
//                     value: recdValue,
//                     bottomPadding: 8,
//                   ),
//                 ),
//               ],
//             ),
//
//             // Accept Quantity and Value
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: _buildInfoSection(
//                     title: 'Accept Qty.',
//                     value: 'NA',
//                     bottomPadding: 0,
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildInfoSection(
//                     title: 'Accept Value(Rs.)',
//                     value: 'NA',
//                     bottomPadding: 0,
//                   ),
//                 ),
//               ],
//             ),
//
//             // Download button aligned to the right
//             Align(
//               alignment: Alignment.centerRight,
//               child: IconButton(
//                 icon: Icon(
//                   Icons.file_download,
//                   color: Colors.blue[800],
//                   size: 24,
//                 ),
//                 onPressed: () {},
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoSection({
//     required String title,
//     required String value,
//     required double bottomPadding,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: bottomPadding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
