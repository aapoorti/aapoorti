// import 'package:flutter/material.dart';
// import 'package:flutter_app/mmis/controllers/dashboard_controller.dart';
// import 'package:get/get.dart';
//
// class SummaryScreen extends StatefulWidget {
//   const SummaryScreen({super.key});
//
//   @override
//   State<SummaryScreen> createState() => _SummaryScreenState();
// }
//
// class _SummaryScreenState extends State<SummaryScreen> {
//
//   final controller = Get.put(DashBoardController());
//   String selectedyear = '';
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     yearslist();
//   }
//
//
//   List<String> yearRanges = [];
//   int _selectedIndex = 2;
//
//   void yearslist(){
//     for (int i = -2; i < 1; i++) {
//       yearRanges.add(generateYearRange(i));
//     }
//     debugPrint("year ranges $yearRanges");
//     selectedyear = yearRanges[2];
//   }
//
//   String generateYearRange(int offset) {
//     // Get the current year
//     int currentYear = DateTime.now().year -1;
//
//     debugPrint("current year $currentYear");
//
//     // Calculate the start year (current year + offset)
//     int startYear = currentYear + offset;
//
//     debugPrint("start year $startYear");
//
//     // Calculate the next year
//     int endYear = startYear + 1;
//
//     debugPrint("endYear year $endYear");
//
//     // Return the formatted string in the form "startYear-endYear"
//     return '$startYear-${endYear.toString().substring(2)}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx((){
//         if(controller.dsbState.value == DashboardState.Busy) {
//           return Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.indigo));
//         }
//         else if(controller.dsbState.value == DashboardState.Finished){
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 controller.dsbData.isNotEmpty ? Container(
//                     height: 260.0,
//                     width: Get.width,
//                     child: Card(
//                       color: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(color: Colors.indigo, width: 1.5),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 50,
//                             width: 120,
//                             decoration: BoxDecoration(
//                               color: Colors.indigo,
//                               borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
//                             ),
//                             alignment: Alignment.center,
//                             child:  Text("Summary", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                             child: Container(
//                               height: 45,
//                               child: ListView.builder(
//                                   shrinkWrap: true,
//                                   padding: EdgeInsets.zero,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: yearRanges.length,
//                                   itemBuilder: (context, index){
//                                     bool isSelected = _selectedIndex == index;
//                                     return Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: 4.0),
//                                       child: InkWell(
//                                         onTap : (){
//                                           setState(() {
//                                             _selectedIndex = isSelected ? 0 : index;
//                                             selectedyear = yearRanges[index];
//                                           });
//                                         },
//                                         child: Container(
//                                           width: 100,
//                                           height: 40,
//                                           alignment: Alignment.center,
//                                           decoration: BoxDecoration(
//                                             color: isSelected ? Colors.blue : Colors.grey[300],
//                                             borderRadius: BorderRadius.circular(5.0),
//                                             border: Border.all(
//                                               color: isSelected ? Colors.white : Colors.grey,
//                                               width: 1.5,
//                                             ),
//                                           ),
//                                           child: Text(
//                                             yearRanges[index],
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                               color: isSelected ? Colors.white : Colors.black,
//                                               //color: Colors.white ,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Container(
//                               height: 70,
//                               width: Get.width,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey, strokeAlign: 2.0),
//                                 color: Colors.white,
//                               ),
//                               padding: EdgeInsets.all(5),
//                               child: Column(
//                                 //mainAxisAlignment: MainAxisAlignment.start,
//                                 //crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Demand", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
//                                   SizedBox(height: 10.0),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     //mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       RichText(text: TextSpan(
//                                         children: <TextSpan>[
//                                           TextSpan(text: 'Initiated :- ', style: TextStyle(color: Colors.black)),
//                                           selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[2]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)) :
//                                           selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
//                                           TextSpan(text: controller.dsbData[0]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)),
//                                         ],
//                                       )),
//                                       RichText(text: TextSpan(
//                                           children: <TextSpan>[
//                                             TextSpan(text: 'Register :- ', style: TextStyle(color: Colors.black)),
//                                             selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[2]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
//                                             selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
//                                             TextSpan(text: controller.dsbData[0]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)),
//                                           ]
//                                       )),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                             // child: Row(
//                             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             //   children: [
//                             //     Container(
//                             //       height: 100,
//                             //       width: 150,
//                             //       decoration: BoxDecoration(
//                             //         border: Border.all(color: Colors.grey, strokeAlign: 2.0),
//                             //         color: Colors.white,
//                             //       ),
//                             //       padding: EdgeInsets.all(10),
//                             //       child: Column(
//                             //         mainAxisAlignment: MainAxisAlignment.start,
//                             //         crossAxisAlignment: CrossAxisAlignment.start,
//                             //         children: [
//                             //           Text("Demand Initiation", style: TextStyle(fontSize: 16.0)),
//                             //           SizedBox(height: 10.0),
//                             //           selectedyear == "2022-23" ?
//                             //           Text(controller.dsbData[0]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
//                             //           selectedyear == "2023-24" ? Text(controller.dsbData[1]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
//                             //               : Text(controller.dsbData[2]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
//                             //         ],
//                             //       ),
//                             //     ),
//                             //     Container(
//                             //       height: 100,
//                             //       width: 150,
//                             //       decoration: BoxDecoration(
//                             //         border: Border.all(color: Colors.grey, strokeAlign: 2.0),
//                             //         color: Colors.white,
//                             //       ),
//                             //       padding: EdgeInsets.all(10),
//                             //       child: Column(
//                             //         mainAxisAlignment: MainAxisAlignment.start,
//                             //         crossAxisAlignment: CrossAxisAlignment.start,
//                             //         children: [
//                             //           Text("Demand Register", style: TextStyle(fontSize: 16.0)),
//                             //           SizedBox(height: 10.0),
//                             //           selectedyear == "2022-23" ?
//                             //           Text(controller.dsbData[0]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
//                             //           selectedyear == "2023-24" ? Text(controller.dsbData[1]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
//                             //               : Text(controller.dsbData[2]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
//                             //         ],
//                             //       ),
//                             //     ),
//                             //   ],
//                             // ),
//                           ),
//                           SizedBox(height: 10),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Container(
//                               height: 50,
//                               width: Get.width,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey, strokeAlign: 2.0),
//                                 color: Colors.white,
//                               ),
//                               padding: EdgeInsets.all(5),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 //mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   RichText(text: TextSpan(
//                                     children: <TextSpan>[
//                                       TextSpan(text: 'Tender Published :- ', style: TextStyle(color: Colors.black)),
//                                       selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[2]['tp'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)) :
//                                       selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['tp'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
//                                       TextSpan(text: controller.dsbData[0]['tp'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)),
//                                     ],
//                                   )),
//                                   RichText(text: TextSpan(
//                                       children: <TextSpan>[
//                                         TextSpan(text: 'PO Issued :-', style: TextStyle(color: Colors.black)),
//                                         selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[2]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
//                                         selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
//                                         TextSpan(text: controller.dsbData[0]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
//                                       ]
//                                   )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                 ) : SizedBox (child: Image.asset('assets/no_data.png')),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Container(
//                 //     height: 50,
//                 //     width: Get.width,
//                 //     decoration: BoxDecoration(
//                 //       borderRadius: BorderRadius.circular(10),
//                 //       color: Colors.indigo
//                 //     ),
//                 //     alignment: Alignment.center,
//                 //     child: Text("Departments Chart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
//                 //   ),
//                 // ),
//                 // Container(
//                 //   height: 80,
//                 //   width: Get.width,
//                 //   padding: EdgeInsets.all(10.0),
//                 //   child: Column(
//                 //     children: [
//                 //       Row(
//                 //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //         children: [
//                 //           Row(children: [
//                 //             Container(height: 20, width: 20, color: Colors.red),
//                 //             SizedBox(width: 4),
//                 //             Text("Management")
//                 //           ]),
//                 //           SizedBox(width: 6),
//                 //           Row(children: [
//                 //             Container(height: 20, width: 20, color: Colors.green),
//                 //             SizedBox(width: 4),
//                 //             Text("CITG")
//                 //           ]),
//                 //           SizedBox(width: 6),
//                 //           Row(children: [
//                 //             Container(height: 20, width: 20, color: Colors.blue),
//                 //             SizedBox(width: 4),
//                 //             Text("Technical Vetting")
//                 //           ]),
//                 //         ],
//                 //       ),
//                 //       SizedBox(height: 20),
//                 //       Row(
//                 //         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //         children: [
//                 //           Row(children: [
//                 //             Container(height: 20, width: 20, color: Colors.indigo),
//                 //             SizedBox(width: 10),
//                 //             Text("Purchase")
//                 //           ]),
//                 //           SizedBox(width: 40),
//                 //           Row(children: [
//                 //             Container(height: 20, width: 20, color: Colors.orange),
//                 //             SizedBox(width: 10),
//                 //             Text("IND")
//                 //           ]),
//                 //           SizedBox(width: 20),
//                 //           Row(children: [
//                 //             Container(height: 20, width: 20, color: Colors.purpleAccent),
//                 //             SizedBox(width: 10),
//                 //             Text("Account")
//                 //           ]),
//                 //         ],
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 // controller.dmdsData.isNotEmpty ? Container(
//                 //   height: Get.height * 0.5,
//                 //   width: Get.width,
//                 //   child: SfCartesianChart(
//                 //     primaryXAxis: CategoryAxis(),
//                 //     series: <CartesianSeries>[
//                 //       ColumnSeries<ChartData2, String>(
//                 //         dataSource: parseServerResponse(controller.dmdsData),
//                 //         onPointTap: (pointInteractionDetails) => debugPrint("${pointInteractionDetails.pointIndex} ${pointInteractionDetails.dataPoints} ${pointInteractionDetails.viewportPointIndex}"),
//                 //         // dataSource: [
//                 //         //   ChartData2('MGT', 90, Colors.red),
//                 //         //   ChartData2('Accts', 60, Colors.green),
//                 //         //   ChartData2('TV', 75, Colors.blue),
//                 //         //   ChartData2('Purc', 80, Colors.indigo),
//                 //         // ],
//                 //         xValueMapper: (ChartData2 data, _) => data.x,
//                 //         yValueMapper: (ChartData2 data, _) => data.y,
//                 //         pointColorMapper: (ChartData2 data, _) => data.color,
//                 //         dataLabelSettings: DataLabelSettings(
//                 //           isVisible: true,
//                 //           textStyle: TextStyle(color: Colors.white, fontSize: 12),
//                 //           labelAlignment: ChartDataLabelAlignment.top,
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ) : SizedBox (child: Image.asset('assets/no_data.png')),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Container(
//                 //     height: 60,
//                 //     width: Get.width,
//                 //     decoration: BoxDecoration(
//                 //         borderRadius: BorderRadius.circular(10),
//                 //         color: Colors.indigo
//                 //     ),
//                 //     padding: EdgeInsets.all(8.0),
//                 //     alignment: Alignment.center,
//                 //     child: Text("Tender Published & Under Evaluation(IREPS & GeM)", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
//                 //   ),
//                 // ),
//                 // controller.stackchartData.isNotEmpty ? Container(
//                 //     child: SfCartesianChart(
//                 //         primaryXAxis: CategoryAxis(),
//                 //         series: <CartesianSeries>[
//                 //           StackedColumnSeries<ChartData3, String>(
//                 //               dataLabelSettings: DataLabelSettings(
//                 //                   isVisible:true,
//                 //                   showCumulativeValues: true
//                 //               ),
//                 //               dataSource: parseChartData(controller.stackchartData),
//                 //               xValueMapper: (ChartData3 data, _) => data.x,
//                 //               yValueMapper: (ChartData3 data, _) => data.y1,
//                 //             pointColorMapper: (ChartData3 data, _) => Colors.pinkAccent,
//                 //           ),
//                 //           StackedColumnSeries<ChartData3, String>(
//                 //               dataLabelSettings: DataLabelSettings(
//                 //                   isVisible:true,
//                 //                   showCumulativeValues: true
//                 //               ),
//                 //               dataSource: parseChartData(controller.stackchartData),
//                 //               xValueMapper: (ChartData3 data, _) => data.x,
//                 //               yValueMapper: (ChartData3 data, _) => data.y2,
//                 //               pointColorMapper: (ChartData3 data, _) => Colors.yellow,
//                 //           ),
//                 //           StackedColumnSeries<ChartData3, String>(
//                 //               dataLabelSettings: DataLabelSettings(
//                 //                   isVisible:true,
//                 //                   showCumulativeValues: true
//                 //               ),
//                 //               dataSource: parseChartData(controller.stackchartData),
//                 //               xValueMapper: (ChartData3 data, _) => data.x,
//                 //               yValueMapper: (ChartData3 data, _) => data.y3,
//                 //               pointColorMapper: (ChartData3 data, _) => Colors.blue,
//                 //           ),
//                 //           StackedColumnSeries<ChartData3, String>(
//                 //               dataLabelSettings: DataLabelSettings(
//                 //                   isVisible:true,
//                 //                   showCumulativeValues: true
//                 //               ),
//                 //               dataSource: parseChartData(controller.stackchartData),
//                 //               xValueMapper: (ChartData3 data, _) => data.x,
//                 //               yValueMapper: (ChartData3 data, _) => data.y4,
//                 //               pointColorMapper: (ChartData3 data, _) => Colors.green,
//                 //           )
//                 //         ]
//                 //     )
//                 // ) : SizedBox (child: Image.asset('assets/no_data.png')),
//               ],
//             ),
//           );
//         }
//         return SizedBox();
//       }),
//     );
//   }
// }


//--------- New UI Screen ----------------------
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final DashBoardController controller = Get.put(DashBoardController());
  final List<String> yearRanges = [];
  int selectedYearIndex = 2;
  late String selectedYear;

  @override
  void initState() {
    super.initState();
    generateYearRanges();
    selectedYear = yearRanges[selectedYearIndex];
  }

  void generateYearRanges() {
    final int currentYear = DateTime.now().year - 1;

    for (int i = -2; i < 1; i++) {
      final int startYear = currentYear + i;
      final int endYear = startYear + 1;
      final String range = '$startYear-${endYear.toString().substring(2)}';
      yearRanges.add(range);
    }
  }

  void updateSelectedYear(int index) {
    setState(() {
      selectedYearIndex = index;
      selectedYear = yearRanges[index];
    });
  }

  String getDataValueForSelectedYear(String key) {
    final int dataIndex = selectedYear == yearRanges[0] ? 2 :
    selectedYear == yearRanges[1] ? 1 : 0;

    return controller.dsbData[dataIndex][key] ?? "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.dsbState.value == DashboardState.Busy) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF3949AB),
            ),
          );
        } else if (controller.dsbState.value == DashboardState.Finished) {
          return buildContent();
        }
        return const SizedBox();
      }),
    );
  }

  Widget buildContent() {
    if (controller.dsbData.isEmpty) {
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/no_data.png', height: 150),
              const SizedBox(height: 16),
              const Text(
                "No data available",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500
                ),
              )
            ],
          )
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        physics: const BouncingScrollPhysics(),
        child: buildSummaryCard(),
      ),
    );
  }

  Widget buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCardHeader(),
          buildYearSelector(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          buildMetricsGrid(),
        ],
      ),
    );
  }

  Widget buildCardHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Color(0xFF3949AB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            "Summary Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 0.3,
            ),
          ),
          // const Spacer(),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.2),
          //     borderRadius: BorderRadius.circular(30),
          //   ),
          //   child: const Text(
          //     "Overview",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.w500,
          //       fontSize: 12,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildYearSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Financial Year",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                yearRanges.length,
                    (index) {
                  final bool isSelected = selectedYearIndex == index;
                  return GestureDetector(
                    onTap: () => updateSelectedYear(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF3949AB) : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        yearRanges[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isSelected ? Colors.white : const Color(0xFF757575),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMetricsGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle("Demand", Icons.receipt_outlined),
          const SizedBox(height: 12),
          buildMetricsRow([
            MetricData("Initiated", getDataValueForSelectedYear('di'), Colors.blue),
            MetricData("Registered", getDataValueForSelectedYear('dr'), Colors.green),
          ]),

          const SizedBox(height: 24),

          buildSectionTitle("Procurement", Icons.assignment_outlined),
          const SizedBox(height: 12),
          buildMetricsRow([
            MetricData("Tenders", getDataValueForSelectedYear('tp'), Colors.orange),
            MetricData("PO Issued", getDataValueForSelectedYear('poi'), Colors.purple),
          ]),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF3949AB),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3949AB),
          ),
        ),
      ],
    );
  }

  Widget buildMetricsRow(List<MetricData> metrics) {
    return Row(
      children: metrics.map((metric) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: buildMetricCard(metric),
        ),
      )).toList(),
    );
  }

  Widget buildMetricCard(MetricData metric) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: metric.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: metric.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: metric.color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                metric.value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: metric.color,
                ),
              ),
              // const Spacer(),
              // Container(
              //   padding: const EdgeInsets.all(4),
              //   decoration: BoxDecoration(
              //     color: metric.color.withOpacity(0.1),
              //     shape: BoxShape.circle,
              //   ),
              //   child: Icon(
              //     Icons.arrow_upward,
              //     size: 12,
              //     color: metric.color,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class MetricData {
  final String label;
  final String value;
  final Color color;

  MetricData(this.label, this.value, this.color);
}
