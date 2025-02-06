import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/mmis/controllers/searchdmdpreview_controller.dart';
import 'package:get/get.dart';

class SearchdmdpreviewScreen extends StatefulWidget {
  const SearchdmdpreviewScreen({super.key});

  @override
  State<SearchdmdpreviewScreen> createState() => _SearchdmdpreviewScreenState();
}

class _SearchdmdpreviewScreenState extends State<SearchdmdpreviewScreen> {

  final searchdmdPreviewcontroller = Get.put<SearchdmdPreviewController>(SearchdmdPreviewController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchdmdPreviewcontroller.getSearchdmdPreview();
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
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.check_circle, color: Colors.green),
            label: const Text(
              'Demand Approved',
              style: TextStyle(color: Colors.green),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Obx((){
               if(searchdmdPreviewcontroller.searchdmdPreviewState.value == SearchdmdPreviewState.loading){
                 return Container(
                   height: Get.height,
                   width: Get.width,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       CircularProgressIndicator(),
                     ],
                   ),
                 );
               }
               else if(searchdmdPreviewcontroller.searchdmdPreviewState.value == SearchdmdPreviewState.success){
                 return Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       DemandHeader(searchdmdPreviewController: searchdmdPreviewcontroller),
                       const SizedBox(height: 16),
                       ConstrainedBox(
                         constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                         child: const Wrap(
                           spacing: 16,
                           runSpacing: 16,
                           children: [
                             ExpandableCard(title: 'Items & Consignees', child: ItemsConsigneesPanel()),
                             ExpandableCard(title: 'LPR', child: LPRPanel()),
                             ExpandableCard(title: 'Likely Suppliers', child: SuppliersPanel()),
                             ExpandableCard(title: 'Documents', child: DocumentsPanel()),
                             ExpandableCard(title: 'Conditions', child: ConditionsPanel()),
                             ExpandableCard(title: 'Authentication Details', child: AuthenticationPanel()),
                           ],
                         ),
                       ),
                     ],
                   ),
                 );
               }
               return SizedBox();
            }),
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
        final cardWidth = screenWidth > 1200
            ? 400.0
            : (screenWidth > 800
            ? (screenWidth / 2) - 24
            : screenWidth - 32);

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
  final SearchdmdPreviewController searchdmdPreviewController;
  const DemandHeader({super.key, required this.searchdmdPreviewController});

  @override
  State<DemandHeader> createState() => _DemandHeaderState();
}

class _DemandHeaderState extends State<DemandHeader> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              height: 300,
              child: Card(
                elevation: 0,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildBasicDetails(widget.searchdmdPreviewController),
                    _buildFundDetails(widget.searchdmdPreviewController),
                    _buildProcurementDetails(widget.searchdmdPreviewController),
                    _buildEstimateDetails(widget.searchdmdPreviewController),
                    _buildTechnicalDetails(widget.searchdmdPreviewController),
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
        );
      },
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

  Widget _buildBasicDetails(SearchdmdPreviewController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 18),
            Obx((){
              if(SearchdmdPreviewState.idle == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Demand No.', "-------", Icons.comment_bank_sharp),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: _buildHeaderItem('Indentor', '------', Icons.person),
                    ),
                  ],
                );
              }
              else if(SearchdmdPreviewState.success == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Demand No.', controller.headerData[0].key2!, Icons.comment_bank_sharp),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: _buildHeaderItem('Indentor', controller.headerData[0].key3!, Icons.person),
                    ),
                  ],
                );
              }
              return SizedBox();
            }),
            const SizedBox(height: 18),
            Obx((){
              if(SearchdmdPreviewState.idle == controller.searchdmdPreviewState.value){
                return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildHeaderItem('Demand Value', 'Rs. 90,000/-\n(Rupees Ninety Thousand Only)', Icons.currency_rupee),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _buildHeaderItem('Purpose',
                        'S1: Sanctioned Estimate\n'
                            'S2: Sanctioned Estimate\n'
                            'S3: Sanctioned Estimate\n'
                            'S4: Sanctioned Estimate',
                        Icons.description),
                  ),
                ],
              );
              }
              else if(SearchdmdPreviewState.success == controller.searchdmdPreviewState.value) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Demand Value', 'Rs. ${controller.headerData[0].key12!}/-\n(Rupees Ninety Thousand Only)', Icons.currency_rupee),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: _buildHeaderItem('Purpose',
                          controller.headerData[0].key5!,
                          Icons.description),
                    ),
                  ],
                );
              }
              return SizedBox();
            })

          ],
        ),
      ),
    );
  }

  Widget _buildFundDetails(SearchdmdPreviewController controller) {
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
            Obx((){
              if(SearchdmdPreviewState.idle == controller.searchdmdPreviewState.value) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem(
                          'Fund Availability Year', '-----',
                          Icons.account_balance),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem(
                          'Indentor Demand Reference', '-----',
                          Icons.bookmark),
                    ),
                  ],
                );
              }
              else if(SearchdmdPreviewState.success == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem(
                          'Fund Availability Year', fundavlyear(controller.headerData[0].key13!)!,
                          Icons.account_balance),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem(
                          'Indentor Demand Reference', controller.headerData[0].key14!,
                          Icons.bookmark),
                    ),
                  ],
                );
              }
              return SizedBox();
            }),
            const SizedBox(height: 24),
            Obx((){
               if(SearchdmdPreviewState.idle == controller.searchdmdPreviewState.value){
                 return Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Expanded(
                       child: _buildHeaderItem('Whether PAC Case?', '-----', Icons.help_outline),
                     ),
                     const SizedBox(width: 32),
                     Expanded(
                       child: _buildHeaderItem('Estimate Date', '-----', Icons.event),
                     ),
                   ],
                 );
               }
               else if(SearchdmdPreviewState.success == controller.searchdmdPreviewState.value){
                 return Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Expanded(
                       child: _buildHeaderItem('Whether PAC Case?', controller.headerData[0].key6!, Icons.help_outline),
                     ),
                     const SizedBox(width: 32),
                     Expanded(
                       child: _buildHeaderItem('Estimate Date', controller.headerData[0].key15!, Icons.event),
                     ),
                   ],
                 );
               }
               return SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProcurementDetails(SearchdmdPreviewController controller) {
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
            Obx((){
              if(SearchdmdPreviewState.idle == controller.searchdmdPreviewState.value) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Bill Passing Officer', 'GM/01',
                          Icons.assignment_ind),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem(
                          'Procurement Type', 'Purchase Through Stores(IREPS)',
                          Icons.store),
                    ),
                  ],
                );
              }
              else if(SearchdmdPreviewState.success == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Bill Passing Officer', controller.headerData[0].key4!,
                          Icons.assignment_ind),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem(
                          'Procurement Type', getProcurementtype(controller.headerData[0].key10!)!,
                          Icons.store),
                    ),
                  ],
                );
              }
              return SizedBox();
            }),
            const SizedBox(height: 24),
            Obx((){
              if(SearchdmdPreviewState.idle == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Demand Type', '-----', Icons.category),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem('Mode of Procurement', '-----', Icons.shopping_cart),
                    ),
                  ],
                );
              }
              else if(SearchdmdPreviewState.success == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Demand Type', getDemandtype(controller.headerData[0].key7!)!, Icons.category),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem('Mode of Procurement',  getmodeofprocurent(controller.headerData[0].key8!)!, Icons.shopping_cart),
                    ),
                  ],
                );
              }
              return SizedBox();
            })

          ],
        ),
      ),
    );
  }

  Widget _buildEstimateDetails(SearchdmdPreviewController controller) {
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
            Obx((){
              if(SearchdmdPreviewState.idle == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Sanctioned Estimate No.', '------', Icons.receipt),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem('Bill Paying Officer', '-------', Icons.payments),
                    ),
                  ],
                );
              }
              else if(SearchdmdPreviewState.success == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Sanctioned Estimate No.', controller.headerData[0].key17!, Icons.receipt),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem('Bill Paying Officer', controller.headerData[0].key16!, Icons.payments),
                    ),
                  ],
                );
              }
              return SizedBox();
            }),
            const SizedBox(height: 24),
            Obx((){
              if(SearchdmdPreviewState.idle == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Estimate Item No.', "------", Icons.list_alt),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem('Purchase Unit', "------", Icons.business),
                    ),
                  ],
                );
              }
              else if(SearchdmdPreviewState.success == controller.searchdmdPreviewState.value){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildHeaderItem('Estimate Item No.', controller.headerData[0].key17!, Icons.list_alt),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildHeaderItem('Purchase Unit', controller.headerData[0].key11!, Icons.business),
                    ),
                  ],
                );
              }
              return SizedBox();
            })

          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalDetails(SearchdmdPreviewController controller) {
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
            Obx((){
              if(SearchdmdPreviewState.idle == controller.searchdmdPreviewState.value){
                return _buildHeaderItem('Technical Vetting Required', '-----', Icons.gavel, showViewButton: true);
              }
              else if(SearchdmdPreviewState.success == controller.searchdmdPreviewState.value){
                return _buildHeaderItem('Technical Vetting Required', controller.headerData[0].key9!, Icons.gavel, showViewButton: true);
              }
              return SizedBox();
            })

          ],
        ),
      ),
    );
  }

  Widget _buildHeaderItem(String label, String value, IconData icon, {bool showViewButton = false}) {
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
            if (showViewButton)
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
          child: Text(
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

  String? fundavlyear(String? yrvalue) {
    if(yrvalue == "21"){
      return "2021-22";
    }
    else if(yrvalue == "22"){
      return "2022-23";
    }
    else if(yrvalue == "23"){
      return "2023-24";
    }
    else if(yrvalue == "24"){
      return "2024-25";
    }
    else if(yrvalue == "25"){
      return "2025-26";
    }
    else if(yrvalue == "26"){
      return "2026-27";
    }
    else if(yrvalue == "27"){
      return "2027-28";
    }
    return null;
  }

  String? getmodeofprocurent(String? s) {
    if(s == "0"){
      return "Variation/optional Clause";
    }
    else if(s == "1"){
      return "Open Tender";
    }
    else if(s == "2"){
      return "Limited Tender";
    }
    else if(s == "3"){
      return "Single Tender";
    }
    else if(s == "4"){
      return "Rate Contract";
    }
    return null;
  }

  String? getDemandtype(String? s) {
   if(s == "1"){
      return "ICT ITEMS";
    }
    else if(s == "2"){
      return "NON-ICT ITEMS";
    }
    return null;
  }

  String? getProcurementtype(String? s) {
    if(s == "1"){
      return "Purchase Through Stores(IREPS)";
    }
    else if(s == "2"){
      return "Purchase Through Stores(GeM)";
    }
    else if(s == "3"){
      return "Purchase Through Group(3BQs/IREPS)";
    }
    return null;
  }
}
class ItemsConsigneesPanel extends StatelessWidget {
  const ItemsConsigneesPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Group A50001-Software, Hardware and Furniture',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Item Details'),
            Card(
              elevation: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 800),
                  child: _buildItemDetailsTable(),
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
                  child: _buildConsigneeTable(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Card(
                elevation: 1,
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
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
                        'Rs. 90,000/-',
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
        Flexible(
          child: Text(
            value,
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

  Widget _buildItemDetailsTable() {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
      columnSpacing: 4,
      horizontalMargin: 8,
      headingRowHeight: 40,
      dataRowHeight: 140,
      columns: const [
        DataColumn(
          label: Text('SN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
        ),
        DataColumn(
          label: Text('Item Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
        ),
        DataColumn(
          label: Text('Total Qty./Rate/Value',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
        ),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: Text('1.', style: TextStyle(fontSize: 13)),
              )
          ),
          DataCell(
            Container(
              constraints: const BoxConstraints(
                minWidth: 100,
                maxWidth: 250,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Code:','57010012010'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Type:', 'Supply'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Description:', 'Computer Hardware'),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Warranty:',
                      '30 month(s) from the date of Supply',
                      valueColor: Colors.red.shade700,
                    ),
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
                    _buildQuantityRow('Total Qty:', '2 Number'),
                    const Padding(
                      padding: EdgeInsets.only(left: 70),
                      child: Text(
                        '(Only Two Number)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildQuantityRow('Rate:', 'Rs. 45,000/-'),
                    const SizedBox(height: 8),
                    _buildQuantityRow('Value:', 'Rs. 90,000/-'),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ],
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

  Widget _buildConsigneeTable() {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
      columnSpacing: 24,
      horizontalMargin: 16,
      columns: const [
        DataColumn(
          label: Text('Consignee',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
        ),
        DataColumn(
          label: Text('Delivery Reqd. by',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
        ),
        DataColumn(
          label: Text('Quantity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
        ),
        DataColumn(
          label: Text('State',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
        ),
        DataColumn(
          label: Text('Required at',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
        ),
        DataColumn(
          label: Text('Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
        ),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text(
            'ACCTS-ACCTS-IMMSTEST',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          )),
          const DataCell(Text('12/11/2024',
              style: TextStyle(fontSize: 13)
          )),
          const DataCell(Text(
            '2 Number',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          )),
          const DataCell(Text('Andhra Pradesh',
              style: TextStyle(fontSize: 13)
          )),
          const DataCell(Text('NDLS',
              style: TextStyle(fontSize: 13)
          )),
          const DataCell(Text('NEW DELHI',
              style: TextStyle(fontSize: 13)
          )),
        ]),
      ],
    );
  }
}
class LPRPanel extends StatelessWidget {
  const LPRPanel({Key? key}) : super(key: key);

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
          DataColumn(label: Text('SN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          DataColumn(
            label: Text('Item Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
            ),
          ),
          DataColumn(
            label: Text('Rate Type & Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
            ),
          ),
          DataColumn(
            label: Text('     Firm',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
            ),
          ),
          DataColumn(
            label: Text('All Incl. Rate',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
            ),
          ),
        ],
        rows: [
          DataRow(cells: [
            const DataCell(
              Text('1',
                  style: TextStyle(fontSize: 13)
              ),
            ),
            DataCell(
              Container(
                constraints: const BoxConstraints(
                  minWidth: 120,
                  maxWidth: 250,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('570100120010',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500
                        )
                    ),
                    SizedBox(height: 4),
                    Text('Computer Hardware',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey
                        )
                    ),
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
                    const Text('LPR(My By: IMMSTEST)',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500
                        )
                    ),
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
                        children: const [
                          Text('PO No.: gsm-Test',
                              style: TextStyle(fontSize: 13)
                          ),
                          SizedBox(height: 2),
                          Text('dt. 03/04/2024',
                              style: TextStyle(fontSize: 13)
                          ),
                          SizedBox(height: 2),
                          Text('(Non-IMMS PO)',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey
                              )
                          ),
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
                    Text(
                        'TEST BIDDER\n10-ODISHA',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500
                        )
                    ),
                  ],
                ),
              ),
            ),
            const DataCell(
              Text('Rs.500 per Nos.',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500
                  )
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
class SuppliersPanel extends StatelessWidget {
  const SuppliersPanel({Key? key}) : super(key: key);

  Widget _buildDetailRow(String label, String value, {Color? labelColor, Color? valueColor}) {
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
                  child: _buildSuppliersTable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuppliersTable() {
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
            ),
          ),
          DataColumn(
            label: Text('                         Firm Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
            ),
          ),
          DataColumn(
            label: Text('              Category',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
            ),
          ),
        ],
        rows: [
          DataRow(cells: [
            const DataCell(
              Text('1',
                  style: TextStyle(fontSize: 13)
              ),
            ),
            DataCell(
              Container(
                constraints: const BoxConstraints(
                  minWidth: 200,
                  maxWidth: 400,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDetailRow('         Name:', 'TEST BIDDER 10-ODISHA'),
                      const SizedBox(height: 8),
                      _buildDetailRow('         Address:', 'Odisha Odisha, Odisha, India, 221014'),
                      const SizedBox(height: 8),
                      _buildDetailRow('         Mobile:', '+91 9876543216'),
                      const SizedBox(height: 8),
                      _buildDetailRow('         Email:', 'tb11.testbidder@gmail.com'),
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
                child: const Text(
                  '      Last Supplier (LPR)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
class DocumentsPanel extends StatelessWidget {
  const DocumentsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDocumentSection('Technical Documents'),
            const SizedBox(height: 16),
            _buildDocumentSection('Commercial Documents'),
            const SizedBox(height: 16),
            _buildDocumentSection('Other Documents'),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentSection(String title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.file_present),
                title: Text('Document ${index + 1}'),
                subtitle: Text('Uploaded on: ${30 - index}/10/2024'),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConditionsPanel extends StatelessWidget {
  const ConditionsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConditionCard(
              'Special Conditions',
              [
                'Delivery within 30 days',
                'Installation and configuration included',
                'Three years warranty required',
                'On-site technical support'
              ],
            ),
            const SizedBox(height: 16),
            _buildConditionCard(
              'General Conditions',
              [
                'Payment terms: 100% after delivery and installation',
                'Performance security: 3% of contract value',
                'Liquidated damages: 0.5% per week of delay',
                'Maximum LD: 10% of contract value'
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionCard(String title, List<String> conditions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ...conditions.map((condition) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(child: Text(condition)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class AuthenticationPanel extends StatelessWidget {
  const AuthenticationPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Digital Signatures',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildSignatureRow(
                  'Indentor',
                  'NAVAL KUMAR GUPTA',
                  'Signed on 30/10/2024 10:30 AM',
                  true,
                ),
                _buildSignatureRow(
                  'Approving Authority',
                  'RAJESH KUMAR',
                  'Signed on 30/10/2024 02:15 PM',
                  true,
                ),
                _buildSignatureRow(
                  'Purchase Officer',
                  'AMIT SHARMA',
                  'Signed on 30/10/2024 04:45 PM',
                  true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureRow(
      String role,
      String name,
      String timestamp,
      bool isSigned,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(name),
                Text(
                  timestamp,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isSigned ? Icons.verified : Icons.pending,
            color: isSigned ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
  }

  String? fundavlyear(String yrvalue) {
    if(yrvalue == "21"){
      return "2021-22";
    }
    else if(yrvalue == "22"){
      return "2022-23";
    }
    else if(yrvalue == "23"){
      return "2023-24";
    }
    else if(yrvalue == "24"){
      return "2024-25";
    }
    else if(yrvalue == "25"){
      return "2025-26";
    }
    else if(yrvalue == "26"){
      return "2026-27";
    }
    else if(yrvalue == "27"){
      return "2027-28";
    }
    return null;
  }
}
