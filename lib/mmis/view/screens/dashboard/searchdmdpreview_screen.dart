import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/controllers/searchdmdpreview_controller.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchdmdpreviewScreen extends StatefulWidget {
  const SearchdmdpreviewScreen({super.key});

  @override
  State<SearchdmdpreviewScreen> createState() => _SearchdmdpreviewScreenState();
}

class _SearchdmdpreviewScreenState extends State<SearchdmdpreviewScreen> {

  final searchdmdPreviewcontroller = Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  String? dmdKey = Get.arguments[0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //searchdmdPreviewcontroller.getSearchdmdPreview();
    fetSearchdmdPreview();
  }

  Future<void> fetSearchdmdPreview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if (providedTime.isBefore(DateTime.now())) {
      await fetchToken(context);
      await searchdmdPreviewcontroller.getSearchdmdPreviewHeader(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewLPR(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewLS(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewDoc(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewCondition(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewAllocation(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewItemCon(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewAuthentication(dmdKey);
      //choosedeptcontroller.fetchDepartmentCount(prefs.getString('userid')!);
    } else {
      await searchdmdPreviewcontroller.getSearchdmdPreviewHeader(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewLPR(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewLS(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewDoc(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewCondition(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewAllocation(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewItemCon(dmdKey);
      searchdmdPreviewcontroller.getSearchdmdPreviewAuthentication(dmdKey);
      //choosedeptcontroller.fetchDepartmentCount(prefs.getString('userid')!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AapoortiConstants.primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Non-Stock Demand',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Obx((){
            if(searchdmdPreviewcontroller.searchdmdPreviewHeaderState == SearchdmdPreviewHeaderState.success){
              return TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle, color: Colors.green),
                label: Text(
                  searchdmdPreviewcontroller.headerData.length != 0 ? searchdmdPreviewcontroller.headerData[0].key18 == "NULL" ? "NA" : searchdmdPreviewcontroller.headerData[0].key18! : "NA",
                  style: TextStyle(color: Colors.green),
                ),
              );
            }
            return SizedBox();
          })

        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if(searchdmdPreviewcontroller.searchdmdPreviewHeaderState == SearchdmdPreviewHeaderState.loading) {
                 return Container(
                  height: Get.height,
                  width: Get.width,
                  child: Center(child: CircularProgressIndicator()));
                }
                else if(searchdmdPreviewcontroller.searchdmdPreviewHeaderState == SearchdmdPreviewHeaderState.success) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.fromLTRB(4, 0, 0, 4),
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFFE3F2FD), // Slightly darker blue background
                          borderRadius: BorderRadius.circular(4),
                          border:
                          Border.all(color: const Color(0xFFBBDEFB)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info,
                                color: const Color(0xFF1565C0), size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'In case of any issues in data,please report.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const DemandHeader(),
                      const SizedBox(height: 16),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: constraints.maxWidth),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [

                            ExpandableCard(title: 'Items & Consignees', child: ItemsConsigneesPanel()),
                            ExpandableCard(title: 'LPR', child: LPRPanel()),
                            ExpandableCard(
                                title: 'Likely Suppliers',
                                child: SuppliersPanel()),
                            ExpandableCard(
                                title: 'Documents', child: DocumentsPanel()),
                            ExpandableCard(
                                title: 'Conditions', child: ConditionsPanel()),
                            ExpandableCard(
                                title: 'Allocation', child: AllocationPanel()),
                            ExpandableCard(title: 'Authentication Details', child: AuthenticationPanel()),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                else if(searchdmdPreviewcontroller.searchdmdPreviewHeaderState == SearchdmdPreviewHeaderState.failure) {
                  return Container(
                    height: Get.height,
                    width: Get.width,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            child: Lottie.asset('assets/json/no_data.json'),
                          ),
                          AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TyperAnimatedText("Data not found",
                                    speed: Duration(milliseconds: 150),
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ])
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox();
              }),
            ),
          );
        },
      ),
    );
  }
}

class ExpandableCard extends StatelessWidget {
  final String title;
  final Widget child;

  const ExpandableCard({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardWidth = screenWidth > 1200 ? 400.0 : (screenWidth > 800 ? (screenWidth / 2) - 24 : screenWidth - 32);
        return SizedBox(
          width: cardWidth,
          child: Card(
            child: ExpansionTile(
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: cardWidth,
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DemandHeader extends StatefulWidget {
  const DemandHeader({Key? key}) : super(key: key);

  @override
  State<DemandHeader> createState() => _DemandHeaderState();
}

class _DemandHeaderState extends State<DemandHeader> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final searchdmdPreviewcontroller =
      Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  String? fundavlyear(String? yrvalue) {
    if (yrvalue == "21") {
      return "2021-22";
    } else if (yrvalue == "22") {
      return "2022-23";
    } else if (yrvalue == "23") {
      return "2023-24";
    } else if (yrvalue == "24") {
      return "2024-25";
    } else if (yrvalue == "25") {
      return "2025-26";
    } else if (yrvalue == "26") {
      return "2026-27";
    } else if (yrvalue == "27") {
      return "2027-28";
    }
    return null;
  }

  String? getmodeofprocurent(String? s) {
    if (s == "0") {
      return "Variation/optional Clause";
    } else if (s == "1") {
      return "Open Tender";
    } else if (s == "2") {
      return "Limited Tender";
    } else if (s == "3") {
      return "Single Tender";
    } else if (s == "4") {
      return "Rate Contract";
    }
    return null;
  }

  String? getDemandtype(String? s) {
    if (s == "1") {
      return "ICT ITEMS";
    } else if (s == "2") {
      return "NON-ICT ITEMS";
    }
    return null;
  }

  String? getProcurementtype(String? s) {
    if (s == "1") {
      return "Purchase Through Stores(IREPS)";
    } else if (s == "2") {
      return "Purchase Through Stores(GeM)";
    } else if (s == "3") {
      return "Purchase Through Group(3BQs/IREPS)";
    }
    return null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: Card(
              elevation: 2,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildBasicDetails(),
                  _buildFundDetails(),
                  _buildProcurementDetails(),
                  _buildEstimateDetails(),
                  _buildTechnicalDetails(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) => _buildPageIndicator(index)),
              const SizedBox(width: 16),
              Text(
                ' ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int pageIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == pageIndex ? Colors.blue : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildBasicDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Basic Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                // InkWell(
                //   onTap: (){
                //     Get.toNamed(Routes.demandactionScreen);
                //   },
                //   child: Container(
                //     height: 35,
                //     width: 85,
                //     alignment: Alignment.center,
                //     child: Text("Action", style: TextStyle(color: Colors.white)),
                //     decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.circular(8.0),
                //       border: Border.all(color: Colors.blue[300]!)
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildHeaderItem(
                      'Demand No.',
                      searchdmdPreviewcontroller.headerData[0].key2!,
                      Icons.comment_bank_sharp),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _buildHeaderItem(
                      'Indentor',
                      "${searchdmdPreviewcontroller.headerData[0].key3!}",
                      Icons.person),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildHeaderItem(
                      'Demand Value',
                      searchdmdPreviewcontroller.headerData[0].key12 == "NULL" ? "NA" : "Rs. ${searchdmdPreviewcontroller.headerData[0].key12!}",
                      Icons.currency_rupee),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _buildHeaderItem(
                      'Purpose',
                      searchdmdPreviewcontroller.headerData[0].key5 == "NULL"
                          ? "NA"
                          : "${searchdmdPreviewcontroller.headerData[0].key5!}",
                      Icons.description),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFundDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fund Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildHeaderItem(
                      'Fund Availability Year',
                      fundavlyear(searchdmdPreviewcontroller
                              .headerData[0].key13!) ??
                          "NA",
                      Icons.account_balance),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildHeaderItem(
                      'Indentor Demand Reference',
                      searchdmdPreviewcontroller.headerData[0].key14 == "NULL" ? "NA" : searchdmdPreviewcontroller.headerData[0].key14!,
                      Icons.bookmark),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildHeaderItem(
                      'Whether PAC Case?', 'No', Icons.help_outline),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildHeaderItem(
                      'Estimate Date',
                      searchdmdPreviewcontroller.headerData[0].key15 == "NULL" ? "NA" : searchdmdPreviewcontroller.headerData[0].key15!,
                      Icons.event),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcurementDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Procurement Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildHeaderItem(
                      'Bill Passing Officer',
                      searchdmdPreviewcontroller.headerData[0].key4 ?? "NA",
                      Icons.assignment_ind),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildHeaderItem(
                      'Procurement Type',
                      getProcurementtype(
                              searchdmdPreviewcontroller.headerData[0].key10) ??
                          "NA",
                      Icons.store),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildHeaderItem(
                      'Demand Type',
                      getDemandtype(
                              searchdmdPreviewcontroller.headerData[0].key7) ??
                          "NA",
                      Icons.category),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildHeaderItem(
                      'Mode of Procurement',
                      getmodeofprocurent(
                              searchdmdPreviewcontroller.headerData[0].key8) ??
                          "NA",
                      Icons.shopping_cart),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimateDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estimate Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildHeaderItem(
                      'Sanctioned Estimate No.',
                      searchdmdPreviewcontroller.headerData[0].key17 == "NULL" ? "NA" : searchdmdPreviewcontroller.headerData[0].key17!,
                      Icons.receipt),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildHeaderItem(
                      'Bill Paying Officer',
                      searchdmdPreviewcontroller.headerData[0].key16 ?? "NA",
                      Icons.payments),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildHeaderItem(
                      'Estimate Item No.', 'NA', Icons.list_alt),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildHeaderItem(
                      'Purchase Unit',
                      searchdmdPreviewcontroller.headerData[0].key11 == "NULL" ? "NA" : searchdmdPreviewcontroller.headerData[0].key11!,
                      Icons.business),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Technical Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            _buildHeaderItem(
                'Technical Vetting Required',
                searchdmdPreviewcontroller.headerData[0].key7 == "2" ? "NA" : searchdmdPreviewcontroller.headerData[0].key7 == "1" && searchdmdPreviewcontroller.headerData[0].key9 == "1" ? "Yes" : "No",
                Icons.gavel,
                showViewButton:  searchdmdPreviewcontroller.headerData[0].key7 == "2" && searchdmdPreviewcontroller.headerData[0].key7 == "1" && searchdmdPreviewcontroller.headerData[0].key9 == "1" ? true : false),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderItem(String label, String value, IconData icon,
      {bool showViewButton = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
            if(showViewButton)
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('View'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: label == "Purpose" ? ReadMoreText(value, style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
            trimLines: 4,
            colorClickableText: Colors.blue[700],
            trimMode: TrimMode.Line,
            trimCollapsedText: '... More',
            trimExpandedText: '...less',): Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class ItemsConsigneesPanel extends StatelessWidget {
  final searchdmdPreviewcontroller = Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  List<DataRow> getItemDDataRows() {
    return searchdmdPreviewcontroller.itemConData.asMap().entries.map((entry) {
      int index = entry.key + 1; // Get index
      var item = entry.value; // Get item
      return DataRow(cells: [
        DataCell(Padding(
          padding: EdgeInsets.only(right: 4),
          child: Text(index.toString(), style: TextStyle(fontSize: 13)),
        )),
        DataCell(
          Container(
            // constraints: const BoxConstraints(
            //   minWidth: 100,
            //   maxWidth: 250,
            // ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Code:', item.key2!),
                  const SizedBox(height: 8),
                  _buildDetailRow('Type:', item.key9!),
                  const SizedBox(height: 8),
                  _buildDetailRow('Description:', item.key6!),
                  const SizedBox(height: 8),
                  _buildDetailRow('Warranty:', item.key7 == "NULL" ? "N/A" : '${item.key7!} month(s) from the date of Supply', valueColor: Colors.red.shade700),
                ],
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            constraints: const BoxConstraints(minWidth: 130),
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item.key4 == 'NULL' ? _buildQuantityRow('Total Qty:', '0 ${item.key5!}') : _buildQuantityRow('Total Qty:', '${item.key4 ?? "0"} ${item.key5!}'),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 70),
                  //   child: Text(
                  //     '(Only ${item.key4!} Number)',
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.grey,
                  //       fontStyle: FontStyle.italic,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  _buildQuantityRow('Rate:', 'Rs. ${item.key3!}/-'),
                  const SizedBox(height: 8),
                  //Text("harsh ${item.key3} ${item.key4}"),
                  item.key3 == 'NULL' && item.key4 == 'NULL' ? _buildQuantityRow('Value:', 'N/A') : item.key3 == 'NULL' && item.key4 != 'NULL' ? _buildQuantityRow('Value:', 'Rs. ${item.key4.toString()}/-') : item.key3 != 'NULL' && item.key4 == 'NULL' ? _buildQuantityRow('Value:', 'Rs. ${item.key3.toString()}/-') : _buildQuantityRow('Value:', 'Rs. ${int.parse(item.key3.toString())*int.parse(item.key4.toString())}/-'),
                ],
              ),
            ),
          ),
        ),
      ]);
    }).toList();
  }

  List<Map<String, dynamic>> getConsDDataRows() {
    List<Map<String, dynamic>> allData = [];
    searchdmdPreviewcontroller.itemConData.asMap().entries.forEach((entry) {
      var item = entry.value; // Get item
      try {
        List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(json.decode(item.key13!));
        allData.addAll(dataList); // Add decoded list to allData
      } catch (e) {
        debugPrint("Error decoding JSON: $e");
      }
    });

    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   padding: const EdgeInsets.all(12.0),
            //   decoration: BoxDecoration(
            //     color: Colors.orange.shade50,
            //     borderRadius: BorderRadius.circular(4),
            //   ),
            //   child: const Text(
            //     'Group A50001-Software, Hardware and Furniture',
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       color: Colors.blue,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 24),
            _buildSectionHeader('Item Details'),
            Card(
              elevation: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 800),
                  child: _buildItemDetailsTable(getItemDDataRows()),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Consignee Details'),
            Card(
              elevation: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 800),
                  child: _buildConsigneeTable(getConsDDataRows()),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Card(
                elevation: 1,
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Total Value',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        searchdmdPreviewcontroller.headerData[0].key12 == "NULL" ? "NA" : "Rs. ${searchdmdPreviewcontroller.headerData[0].key12!}/-",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '(Inclusive All taxes)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value == "NULL" ? "N/A" : value,
            maxLines: 2,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemDetailsTable(List<DataRow> data) {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
      columnSpacing: 4,
      horizontalMargin: 8,
      headingRowHeight: 40,
      dataRowHeight: 140,
      columns: const [
        DataColumn(
          label: Text('SN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text('Item Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text('Total Qty./Rate/Value',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
      rows: data,
    );
  }

  Widget _buildQuantityRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildConsigneeTable(List<Map<String, dynamic>> dataList) {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
      columnSpacing: 24,
      horizontalMargin: 16,
      columns: const [
        DataColumn(
          label: Text('Consignee',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text('Delivery Reqd. by',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text('Quantity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text('State',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text('Required at',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        DataColumn(
          label: Text('Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
      rows: dataList.map((item) {
        return DataRow(cells: [
          DataCell(Text("${item['consignee_code'].toString()}-${item['consignee_name'].toString()}-${item['consignee_zone'].toString()}")),
          DataCell(Text(item['deliv_reqd_by'].toString())),
          DataCell(Text('${item['cons_qty']} Number')),
          DataCell(Text(item['reqd_at_state'].toString())),
          DataCell(Text(item['reqd_at_stn'].toString())),
          DataCell(Text(item['reqd_at_address'].toString())),
        ]);
      }).toList(),
    );
  }
}

class LPRPanel extends StatelessWidget {
  final searchdmdPreviewcontroller = Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  List<DataRow> getDataRows() {
    return searchdmdPreviewcontroller.lprData.asMap().entries.map((entry) {
      int index = entry.key + 1; // Get index
      var item = entry.value; // Get item
      return DataRow(cells: [
        DataCell(Text(index.toString())), // Serial No
        DataCell(
          Container(
            constraints: const BoxConstraints(
              minWidth: 120,
              maxWidth: 250,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.key4!,
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text(item.key5!,
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ),
        DataCell(
          Container(
            constraints: const BoxConstraints(
              minWidth: 160,
              maxWidth: 200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // Changed from start
              children: [
                Text(item.key16!,
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(6), // Reduced from 8
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item.key12 == "NULL" ? Text("PO No.: NA", style: TextStyle(fontSize: 13)) : Text('PO No.: ${item.key12}', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 2),
                      item.key13 == "NULL" ? Text("dt. NA", style: TextStyle(fontSize: 13)) : Text('PO No.: ${item.key13!}', style: TextStyle(fontSize: 13)),
                      SizedBox(height: 2),
                      Text('(Non-IMMS PO)',
                          style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Container(
            constraints: const BoxConstraints(
              minWidth: 100,
              maxWidth: 240,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.key5!,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        DataCell(Text('Rs.${item.key9} per ${item.key10}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8.0), // Reduced from 12.0
              child: const Text(
                'Last Purchase Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              elevation: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 32,
                  ),
                  child: _buildLPRTable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLPRTable() {
    return Theme(
      data: ThemeData(
        dividerTheme: const DividerThemeData(
          space: 3,
        ),
      ),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
        columnSpacing: 24,
        horizontalMargin: 25,
        dataRowMinHeight: 80, // Reduced from 80
        dataRowMaxHeight: 100, // Reduced from 120
        columns: const [
          DataColumn(
            label: Text('SN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          DataColumn(
            label: Text('Item Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          DataColumn(
            label: Text('Rate Type & Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          DataColumn(
            label: Text('     Firm',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          DataColumn(
            label: Text('All Incl. Rate',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
        rows: getDataRows(),
      ),
    );
  }
}

class SuppliersPanel extends StatelessWidget {
  final searchdmdPreviewcontroller = Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  List<DataRow> getDataRows() {
    return searchdmdPreviewcontroller.lsData.asMap().entries.map((entry) {
      int index = entry.key + 1; // Get index
      var item = entry.value; // Get item

      return DataRow(cells: [
        DataCell(Text(index.toString())), // Serial No
        DataCell(
          Container(
            constraints: const BoxConstraints(
              minWidth: 200,
              maxWidth: 400,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDetailRow('         Name:', '${item.key3!}'),
                  const SizedBox(height: 4),
                  _buildDetailRow('         Address:', '${item.key4!}'),
                  const SizedBox(height: 4),
                  _buildDetailRow('         Mobile:', item.key5 == "NULL" ? "NA" : '${item.key5!}'),
                  const SizedBox(height: 4),
                  _buildDetailRow('         Email:', item.key6 == "NULL" ? "NA" : '${item.key6!}'),
                ],
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            constraints: const BoxConstraints(
              minWidth: 120,
              maxWidth: 300,
            ),
            child: Text(
              '      ${item.key11!}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ]);
    }).toList();
  }

  Widget _buildDetailRow(String label, String value,
      {Color? labelColor, Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: labelColor ?? Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: label == "Address:" ? 2 : 3,
            style: TextStyle(
              fontSize: 13,
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: const Text(
                'Likely Suppliers',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              elevation: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 32,
                  ),
                  child: _buildSuppliersTable(getDataRows()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuppliersTable(List<DataRow> data) {
    return Theme(
      data: ThemeData(
        dividerTheme: const DividerThemeData(
          space: 3,
        ),
      ),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
        columnSpacing: 24,
        horizontalMargin: 25,
        dataRowMinHeight: 120,
        dataRowMaxHeight: 140,
        columns: const [
          DataColumn(
            label: Text('SN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          DataColumn(
            label: Text('                         Firm Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          DataColumn(
            label: Text('              Category',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
        rows: data,
      ),
    );
  }
}

class DocumentsPanel extends StatelessWidget {
  final searchdmdPreviewcontroller = Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  List<DataRow> getDataRows(BuildContext context) {
    return searchdmdPreviewcontroller.docData.asMap().entries.map((entry) {
      int index = entry.key + 1; // Get index
      var item = entry.value; // Get item

      return DataRow(
        cells: [
          DataCell(Text(index.toString())), // Display Index
          DataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (item.key1!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      item.key1!,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    item.key3!,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          DataCell(
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  var fileUrl = "https://www.ireps.gov.in/${item.key4}";
                  var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                  if (Platform.isIOS) {
                    AapoortiUtilities.openPdf(context, fileUrl, fileName);
                  }
                  else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          contentPadding: EdgeInsets.all(20),
                          content: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Choose an option for file',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.black,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    fileName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: Colors.lightBlue[700],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.lightBlue[700],
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          AapoortiUtilities.downloadpdf(fileUrl, fileName, context);
                                        },
                                        child: Text('Download'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.lightBlue[700],
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          AapoortiUtilities.openPdf(context, fileUrl, fileName);
                                        },
                                        child: Text('Open'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            item.key2!.length > 12 ? "${item.key2!.substring(0, 10).trim()}.pdf" : item.key2!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            placeholder: false,
          ),
        ],
      );
    }).toList();

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: const Text(
                'Documents',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Card(
              elevation: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 32,
                  ),
                  child: _buildDocumentsTable(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsTable(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerTheme: const DividerThemeData(
          space: 5,
        ),
      ),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
        columnSpacing: 32,
        horizontalMargin: 25,
        dataRowMinHeight: 52,
        dataRowMaxHeight: 64,
        headingRowHeight: 48,
        columns: const [
          DataColumn(
            label: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                'SN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
          DataColumn(
            label: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                'File Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
        rows: getDataRows(context),
      ),
    );
  }
}

class ConditionsPanel extends StatelessWidget {
  final searchdmdPreviewcontroller =
      Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  List<DataRow> getDataRows() {
    return searchdmdPreviewcontroller.conditionData.asMap().entries.map((entry) {
      int index = entry.key + 1;
      var item = entry.value; // Get item

      return DataRow(cells: [
        DataCell(Text(index.toString())), // Serial No
        DataCell(Text(item.key2 == "NULL" ? "NA" : item.key2!,
            style: const TextStyle(fontSize: 13))),
        DataCell(Text(item.key13 == "NULL" ? "NA" : item.key13!,
            style: const TextStyle(fontSize: 13))),
        DataCell(Text(item.key3 == "NULL" ? "NA" : item.key3!,
            style: const TextStyle(fontSize: 13))),
        DataCell(Text(item.key5!, style: const TextStyle(fontSize: 13))),
        DataCell(Text(item.key6!, style: const TextStyle(fontSize: 13))),
        DataCell(Text(item.key7!, style: const TextStyle(fontSize: 13))),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 32,
                  ),
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all(Colors.grey.shade100),
                    columnSpacing: 24,
                    horizontalMargin: 25,
                    columns: const [
                      DataColumn(
                        label: Text(
                          'SN',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Condition Type',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Template',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Condition Heading/Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Confirmation Required',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Remarks Allowed',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Document Allowed',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                    rows: getDataRows(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllocationPanel extends StatelessWidget {
  final searchdmdPreviewcontroller = Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  List<DataRow> getDataRows() {
    return searchdmdPreviewcontroller.allocationData.asMap().entries.map((entry) {

      int index = entry.key + 1;
      var item = entry.value;

      return DataRow(cells: [
        DataCell(Text(index.toString())), // Serial No
        DataCell(Text("${item.key9!}${item.key10!}", style: const TextStyle(fontSize: 13))),
        DataCell(Text(item.key7!, style: const TextStyle(fontSize: 13))),
        DataCell(Text(item.key5!, style: const TextStyle(fontSize: 13))),
        DataCell(Text("${item.key1!}${item.key2!}", style: const TextStyle(fontSize: 13))),
        DataCell(Text(item.key11!, style: const TextStyle(fontSize: 13))),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 32,
                  ),
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all(Colors.grey.shade100),
                    columnSpacing: 24,
                    horizontalMargin: 25,
                    columns: const [
                      DataColumn(
                        label: Text(
                          'SN',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Item',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Consignee',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Qty',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Allocation',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Value (Rs.)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                    rows: getDataRows(),
                    // rows: [
                    //   _buildAllocationRow(
                    //     '1.',
                    //     '5170100120010- Computer Hardware (@#\$%^&*()_++ - []}{\\/:9<<??',
                    //     'ACCTS - ADCTS\n(CHS -RLMS TESTING)',
                    //     '2.0 Number',
                    //     'EPSW020000\nEPSW020000-Integration of e-tendering in Works Contracts with IPSM',
                    //     '90,000/-',
                    //   ),
                    //   _buildAllocationRow(
                    //     '',
                    //     'Input Tax Credit (ITC) Flag: TI-No ITC (Input goods or services used exclusively for non',
                    //     '',
                    //     '',
                    //     '',
                    //     '',
                    //   ),
                    // ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildAllocationRow(
    String sn,
    String item,
    String consignee,
    String qty,
    String allocation,
    String value,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(sn, style: const TextStyle(fontSize: 13))),
        DataCell(Text(item, style: const TextStyle(fontSize: 13))),
        DataCell(Text(consignee, style: const TextStyle(fontSize: 13))),
        DataCell(Text(qty, style: const TextStyle(fontSize: 13))),
        DataCell(Text(allocation, style: const TextStyle(fontSize: 13))),
        DataCell(Text(value, style: const TextStyle(fontSize: 13))),
      ],
    );
  }
}

class AuthenticationPanel extends StatefulWidget {
  const AuthenticationPanel({super.key});

  @override
  State<AuthenticationPanel> createState() => _AuthenticationPanelState();
}

class _AuthenticationPanelState extends State<AuthenticationPanel> {

  final searchdmdPreviewcontroller = Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  List<DataRow> getDataRows() {
    return searchdmdPreviewcontroller.authenticationData.asMap().entries.map((entry) {

      int index = entry.key + 1;
      var item = entry.value;

      return DataRow(
        cells: [
          DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                index.toString(),
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${item.key6} ${item.key7}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${item.key3}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.key10!.split(",").first,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.key10!.split(",").last.trim(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.key11!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.key12!.split(",").first,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.key12!.split(",").last.trim(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.key13!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _showRemarksDialog(context, item.key9!,
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'View Remarks',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  void _showRemarksDialog(BuildContext context, String remarks) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Remarks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  remarks,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
            columnSpacing: 28,
            horizontalMargin: 20,
            dataRowHeight: 90,
            headingRowHeight: 56,
            columns: const [
              DataColumn(
                label: Text(
                  'S.No.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Stage/Activity',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Name & Designation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Forwarded To',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
            rows: getDataRows(),
          ),
        ),
      ),
    );
  }
}
