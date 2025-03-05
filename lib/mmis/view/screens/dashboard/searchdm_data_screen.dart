import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/mmis/controllers/search_demand_controller.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class SearchdmDataScreen extends StatefulWidget {
  const SearchdmDataScreen({super.key});

  @override
  State<SearchdmDataScreen> createState() => _SearchdmDataScreenState();
}

class _SearchdmDataScreenState extends State<SearchdmDataScreen> {

  final searchdmdController = Get.find<SearchDemandController>();
  final _textsearchController = TextEditingController();

  //final FocusNode _focusNode = FocusNode();

  String? demandType = Get.arguments[0];
  String? fromDate = Get.arguments[1];
  String? toDate = Get.arguments[2];
  String? deptCode = Get.arguments[3];
  String? statusCode = Get.arguments[4];
  String? DemandNum = Get.arguments[5];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("$demandType~$fromDate~$toDate~$deptCode~$statusCode~$DemandNum");

    searchdmdController.fetchSearchDmdData(demandType, fromDate, toDate, deptCode, statusCode, DemandNum, context);
  }

  @override
  void dispose() {
    // Don't forget to dispose the FocusNode when it's no longer needed
    //_focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Obx((){
          return searchdmdController.searchData.value == true ? Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: TextField(
              cursorColor: Colors.indigo[300],
              controller: _textsearchController,
              autofocus: searchdmdController.searchData.value,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5.0),
                  prefixIcon: Icon(Icons.search, color: Colors.indigo[300]),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.indigo[300]),
                    onPressed: () {
                      searchdmdController.changetoolbarUi(false);
                      _textsearchController.text = "";
                      searchdmdController.searchingDmdData(_textsearchController.text.trim(), context);
                    },
                  ),
                  focusColor: Colors.indigo[300],
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.indigo.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.indigo.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.indigo.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Search",
                  border: InputBorder.none),
              onChanged: (query) {
                if(query.isNotEmpty) {
                  searchdmdController.searchingDmdData(query, context);
                } else {
                  searchdmdController.changetoolbarUi(false);
                  _textsearchController.text = "";
                }
              },
            ),
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white)),
              SizedBox(width: 10),
              Container(
                  height: Get.height * 0.10,
                  width: Get.width / 1.5,
                  child: Marquee(
                    text: " Demand Details",
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 30.0,
                    velocity: 100.0,
                    style: TextStyle(fontSize: 18,color: Colors.white),
                    pauseAfterRound: Duration(seconds: 1),
                    accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ))
            ],
          );
        }),
        backgroundColor: AapoortiConstants.primary,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [
          Obx((){
            return searchdmdController.searchData.value == true ? SizedBox() : IconButton(onPressed: (){
              //FocusScope.of(context).requestFocus(_focusNode);
              searchdmdController.changetoolbarUi(true);
            }, icon: Icon(Icons.search, color: Colors.white));
          })
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Expanded(child: Obx((){
                 if(searchdmdController.dmdDataState == SearchDmdDataState.Finished){
                   return ListView.builder(
                     padding: const EdgeInsets.all(5.0),
                     itemCount: searchdmdController.dmdData.length,
                     itemBuilder: (context, index) {
                       return Padding(
                         padding: const EdgeInsets.only(bottom: 5.0),
                         child: _buildDemandCard(context, searchdmdController.dmdData[index], index + 1),
                       );
                     },
                   );
                 }
                 else if(searchdmdController.dmdDataState == SearchDmdDataState.Busy){
                   return SingleChildScrollView(
                     child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Shimmer.fromColors(
                               baseColor: Colors.grey[300]!,
                               highlightColor: Colors.grey[100]!,
                               child: ListView.builder(
                                   itemCount: 4,
                                   shrinkWrap: true,
                                   padding: EdgeInsets.all(5),
                                   itemBuilder: (context, index) {
                                     return Card(
                                       elevation: 8.0,
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(4.0),
                                       ),
                                       child: SizedBox(height: Get.height * 0.45),
                                     );
                                   }))
                         ]),
                   );
                 }
                 else if(searchdmdController.dmdDataState == SearchDmdDataState.NoData){
                   return Center(
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
                               TyperAnimatedText(
                                   "Data not found",
                                   speed: Duration(milliseconds: 150),
                                   textStyle: TextStyle(fontWeight: FontWeight.bold)),
                             ])
                       ],
                     ),
                   );
                 }
                 else if(searchdmdController.dmdDataState == SearchDmdDataState.Error){
                   return Center(
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
                               TyperAnimatedText(
                                   "Data not found",
                                   speed: Duration(milliseconds: 150),
                                   textStyle: TextStyle(fontWeight: FontWeight.bold)),
                             ])
                       ],
                     ),
                   );
                 }
                 else if(searchdmdController.dmdDataState == SearchDmdDataState.FinishedwithError){
                   return Center(
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
                               TyperAnimatedText(
                                   "Data not found",
                                   speed: Duration(milliseconds: 150),
                                   textStyle: TextStyle(fontWeight: FontWeight.bold)),
                             ])
                       ],
                     ),
                   );
                 }
                 return SizedBox();
              }))
          ],
        )
      ),
    );
  }

  Widget _buildDemandCard(BuildContext context, details, int index) {
    return InkWell(
      onTap: (){
        Get.toNamed(Routes.searchdmdpreviewScreen, arguments: [details.key2]);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, details, index),
              const SizedBox(height: 24),
              _buildDemandDetails(context, details),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, details, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$index. ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            "${details.key4}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  "${details.key5}",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemandDetails(BuildContext context, details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHighlightedRow(
          context,
          'Demand Status',
          details.key7,
          icon: Icons.pending_actions_outlined,
        ),
        _buildDetailRow(
          context,
          'Indentor',
          details.key3,
          icon: Icons.account_balance_outlined,
        ),
        _buildDetailRow(
          context,
          'Estimated Value',
          details.key8,
          icon: Icons.currency_rupee_outlined,
        ),
        _buildHighlightedRow(
          context,
          'Current With',
          details.key9,
          icon: Icons.person_outlined,
        ),
        _buildExpandableDescription(
          context,
          details.key6,
          icon: Icons.description_outlined,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildDetailRow(
      BuildContext context,
      String label,
      String value, {
        IconData? icon,
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(icon != null)
            Container(
              width: 30,
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 22,
                color: Colors.blue[600],
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                    height: 1.4,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedRow(
      BuildContext context,
      String label,
      String value, {
        IconData? icon,
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Container(
              width: 30,
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 22,
                color: Colors.blue[600],
              ),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableDescription(
      BuildContext context,
      String description, {
        IconData? icon,
        bool isLast = false,
      }) {
    return StatefulBuilder(
      builder: (context, setState) {
        final ValueNotifier<bool> expandedNotifier = ValueNotifier<bool>(false);
        final ValueNotifier<bool> isHoveringNotifier = ValueNotifier<bool>(false);

        return ValueListenableBuilder<bool>(
            valueListenable: expandedNotifier,
            builder: (context, isExpanded, child) {
              final maxLines = isExpanded ? null : 2;
              final overflow = isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis;

              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (icon != null)
                      Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Icon(
                          icon,
                          size: 22,
                          color: Colors.blue[600],
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 15,
                              height: 1.4,
                              letterSpacing: 0.2,
                            ),
                            maxLines: maxLines,
                            overflow: overflow,
                          ),
                          if (description.length > 80)
                            ValueListenableBuilder<bool>(
                              valueListenable: isHoveringNotifier,
                              builder: (context, isHovering, _) {
                                return MouseRegion(
                                  onEnter: (_) => isHoveringNotifier.value = true,
                                  onExit: (_) => isHoveringNotifier.value = false,
                                  child: GestureDetector(
                                    onTap: () {
                                      expandedNotifier.value = !expandedNotifier.value;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 12.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isHovering ? Colors.blue[50] : Colors.transparent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            isExpanded ? 'See less' : 'See more',
                                            style: TextStyle(
                                              color: Colors.blue[700],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            size: 16,
                                            color: Colors.blue[700],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }
}
