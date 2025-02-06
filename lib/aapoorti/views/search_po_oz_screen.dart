import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';

import '../home/tender/searchpoother/search_po_other.dart';
import '../home/tender/searchpozonal/searchpozonal.dart';

class SearchPoOtherZonalScreen extends StatefulWidget {

  @override
  State<SearchPoOtherZonalScreen> createState() => _SearchPoOtherZonalScreenState();
}

class _SearchPoOtherZonalScreenState extends State<SearchPoOtherZonalScreen> with SingleTickerProviderStateMixin{

  // late TabController tabController;
  //
  // int _activeindex = 0;
  //
  // @override
  // void initState() {
  //   tabController = TabController(length: 2, vsync: this);
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   tabController.dispose();
  //   super.dispose();
  // }

  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _plNoController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  // Initialize with default values
  double _minValue = 0;
  double _maxValue = 100;

  String? _selectedRailway;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _supplierController.dispose();
    _plNoController.dispose();
    super.dispose();
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
            'Search PO',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
        backgroundColor: Colors.blue.shade800,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Search PO (Zonal)'),
            Tab(text: 'Search PO (Other)'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 14),
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
