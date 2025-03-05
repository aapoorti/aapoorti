import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';

import '../home/tender/searchpoother/search_po_other.dart';
import '../home/tender/searchpozonal/searchpozonal.dart';

class SearchPoOtherZonalScreen extends StatefulWidget {

  @override
  State<SearchPoOtherZonalScreen> createState() => _SearchPoOtherZonalScreenState();
}

class _SearchPoOtherZonalScreenState extends State<SearchPoOtherZonalScreen> with SingleTickerProviderStateMixin{

  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: AapoortiConstants.primary,
    //     iconTheme: IconThemeData(color: Colors.white),
    //     title: Text("Search PO (Zonal & Other)", style: TextStyle(color: Colors.white)),
    //   ),
    //   body : Container(
    //     height: MediaQuery.of(context).size.height,
    //     child : Column(
    //       children : [
    //         Container(
    //           width: MediaQuery.of(context).size.width,
    //           decoration: BoxDecoration(
    //             color: Colors.cyan[700],
    //             borderRadius: BorderRadius.circular(0),
    //           ),
    //           child: Column(
    //             children: [
    //               Padding(
    //                   padding: EdgeInsets.all(5),
    //                   child: TabBar(
    //                     unselectedLabelColor: Colors.white,
    //                     labelColor: Colors.black,
    //                     indicatorColor: Colors.white,
    //                     indicatorSize: TabBarIndicatorSize.tab,
    //                     indicatorWeight: 0,
    //                     indicatorPadding: EdgeInsets.zero,
    //                     isScrollable: false,
    //                     padding: EdgeInsets.zero,
    //                     onTap: (tabindex) {
    //                       _activeindex = tabindex;
    //                     },
    //                     indicator: BoxDecoration(
    //                         color: Colors.white,
    //                         borderRadius: BorderRadius.circular(5)),
    //                     controller: tabController,
    //                     tabs: [
    //                       Tab(child: Text("Search PO (Zonal)")),
    //                       Tab(child: Text("Search PO (Other)"))
    //
    //                     ],
    //                   )
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(height: 10),
    //         Expanded(
    //           child : TabBarView(
    //             controller: tabController,
    //             physics: NeverScrollableScrollPhysics(),
    //             children : [
    //               SearchPoZonal(),
    //               SearchPoOther()
    //             ]
    //           )
    //         )
    //       ]
    //     )
    //   )
    // );
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.white),
      //   centerTitle: true,
      //   title: Text(
      //       'Search PO',
      //       style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      //   // actions: [
      //   //   IconButton(
      //   //     icon: const Icon(Icons.home, color: Colors.white),
      //   //     onPressed: () {
      //   //       Navigator.of(context, rootNavigator: true).pop();
      //   //     },
      //   //   ),
      //   // ],
      //   backgroundColor: Colors.blue.shade800,
      //   // bottom: TabBar(
      //   //   controller: _tabController,
      //   //   tabs: const [
      //   //     Tab(text: 'Search PO (Zonal)'),
      //   //     Tab(text: 'Search PO (Other)'),
      //   //   ],
      //   //   labelColor: Colors.white,
      //   //   unselectedLabelColor: Colors.white70,
      //   //   indicatorColor: Colors.white,
      //   //   labelStyle: const TextStyle(fontSize: 14),
      //   // ),
      // ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110), // Increased height to accommodate both bars
        child: Column(
          children: [
            // Main AppBar
            AppBar(
              toolbarHeight: 60, // Increased height for main AppBar
              iconTheme: IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                'Search PO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              // actions: [
              //   IconButton(
              //     icon: const Icon(Icons.home, color: Colors.white),
              //     onPressed: () {
              //       // Handle home button press
              //     },
              //   ),
              // ],
              backgroundColor: Colors.blue.shade800,
            ),
            // Separate TabBar with lighter color
            Container(
              height: 50, // Fixed height for TabBar
              color: Colors.blue.shade700, // Lighter blue color
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: Text(
                      'Search PO (Zonal)',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Search PO (Other)',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SearchPoZonal(),
          SearchPoOther()
        ],
      ),
    );
  }
}
