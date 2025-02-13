import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {

  final controller = Get.put(DashBoardController());
  String selectedyear = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    yearslist();
  }


  List<String> yearRanges = [];
  int _selectedIndex = 2;

  void yearslist(){
    for (int i = -2; i < 1; i++) {
      yearRanges.add(generateYearRange(i));
    }
    debugPrint("year ranges $yearRanges");
    selectedyear = yearRanges[2];
  }

  String generateYearRange(int offset) {
    // Get the current year
    int currentYear = DateTime.now().year -1;

    debugPrint("current year $currentYear");

    // Calculate the start year (current year + offset)
    int startYear = currentYear + offset;

    debugPrint("start year $startYear");

    // Calculate the next year
    int endYear = startYear + 1;

    debugPrint("endYear year $endYear");

    // Return the formatted string in the form "startYear-endYear"
    return '$startYear-${endYear.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        if(controller.dsbState.value == DashboardState.Busy) {
          return Center(child: CircularProgressIndicator(strokeWidth: 3, color: Colors.indigo));
        }
        else if(controller.dsbState.value == DashboardState.Finished){
          return SingleChildScrollView(
            child: Column(
              children: [
                controller.dsbData.isNotEmpty ? Container(
                    height: 260.0,
                    width: Get.width,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.indigo, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            alignment: Alignment.center,
                            child:  Text("Summary", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: Container(
                              height: 45,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: yearRanges.length,
                                  itemBuilder: (context, index){
                                    bool isSelected = _selectedIndex == index;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                                      child: InkWell(
                                        onTap : (){
                                          setState(() {
                                            _selectedIndex = isSelected ? 0 : index;
                                            selectedyear = yearRanges[index];
                                          });
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isSelected ? Colors.blue : Colors.grey[300],
                                            borderRadius: BorderRadius.circular(5.0),
                                            border: Border.all(
                                              color: isSelected ? Colors.white : Colors.grey,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Text(
                                            yearRanges[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? Colors.white : Colors.black,
                                              //color: Colors.white ,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              height: 70,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, strokeAlign: 2.0),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(5),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Demand", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RichText(text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(text: 'Initiated :- ', style: TextStyle(color: Colors.black)),
                                          selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[2]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)) :
                                          selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
                                          TextSpan(text: controller.dsbData[0]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)),
                                        ],
                                      )),
                                      RichText(text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text: 'Register :- ', style: TextStyle(color: Colors.black)),
                                            selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[2]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
                                            selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
                                            TextSpan(text: controller.dsbData[0]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)),
                                          ]
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Container(
                            //       height: 100,
                            //       width: 150,
                            //       decoration: BoxDecoration(
                            //         border: Border.all(color: Colors.grey, strokeAlign: 2.0),
                            //         color: Colors.white,
                            //       ),
                            //       padding: EdgeInsets.all(10),
                            //       child: Column(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text("Demand Initiation", style: TextStyle(fontSize: 16.0)),
                            //           SizedBox(height: 10.0),
                            //           selectedyear == "2022-23" ?
                            //           Text(controller.dsbData[0]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
                            //           selectedyear == "2023-24" ? Text(controller.dsbData[1]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                            //               : Text(controller.dsbData[2]['di'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       height: 100,
                            //       width: 150,
                            //       decoration: BoxDecoration(
                            //         border: Border.all(color: Colors.grey, strokeAlign: 2.0),
                            //         color: Colors.white,
                            //       ),
                            //       padding: EdgeInsets.all(10),
                            //       child: Column(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text("Demand Register", style: TextStyle(fontSize: 16.0)),
                            //           SizedBox(height: 10.0),
                            //           selectedyear == "2022-23" ?
                            //           Text(controller.dsbData[0]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
                            //           selectedyear == "2023-24" ? Text(controller.dsbData[1]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                            //               : Text(controller.dsbData[2]['dr'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              height: 50,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, strokeAlign: 2.0),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  RichText(text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(text: 'Tender Published :- ', style: TextStyle(color: Colors.black)),
                                      selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[2]['tp'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)) :
                                      selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['tp'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)) :
                                      TextSpan(text: controller.dsbData[0]['tp'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,fontSize: 16)),
                                    ],
                                  )),
                                  RichText(text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: 'PO Issued :-', style: TextStyle(color: Colors.black)),
                                        selectedyear == "2022-23" ? TextSpan(text: controller.dsbData[2]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
                                        selectedyear == "2023-24" ? TextSpan(text: controller.dsbData[1]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)) :
                                        TextSpan(text: controller.dsbData[0]['poi'] ?? "0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                      ]
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ) : SizedBox (child: Image.asset('assets/no_data.png')),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     height: 50,
                //     width: Get.width,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.indigo
                //     ),
                //     alignment: Alignment.center,
                //     child: Text("Departments Chart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                //   ),
                // ),
                // Container(
                //   height: 80,
                //   width: Get.width,
                //   padding: EdgeInsets.all(10.0),
                //   child: Column(
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Row(children: [
                //             Container(height: 20, width: 20, color: Colors.red),
                //             SizedBox(width: 4),
                //             Text("Management")
                //           ]),
                //           SizedBox(width: 6),
                //           Row(children: [
                //             Container(height: 20, width: 20, color: Colors.green),
                //             SizedBox(width: 4),
                //             Text("CITG")
                //           ]),
                //           SizedBox(width: 6),
                //           Row(children: [
                //             Container(height: 20, width: 20, color: Colors.blue),
                //             SizedBox(width: 4),
                //             Text("Technical Vetting")
                //           ]),
                //         ],
                //       ),
                //       SizedBox(height: 20),
                //       Row(
                //         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Row(children: [
                //             Container(height: 20, width: 20, color: Colors.indigo),
                //             SizedBox(width: 10),
                //             Text("Purchase")
                //           ]),
                //           SizedBox(width: 40),
                //           Row(children: [
                //             Container(height: 20, width: 20, color: Colors.orange),
                //             SizedBox(width: 10),
                //             Text("IND")
                //           ]),
                //           SizedBox(width: 20),
                //           Row(children: [
                //             Container(height: 20, width: 20, color: Colors.purpleAccent),
                //             SizedBox(width: 10),
                //             Text("Account")
                //           ]),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // controller.dmdsData.isNotEmpty ? Container(
                //   height: Get.height * 0.5,
                //   width: Get.width,
                //   child: SfCartesianChart(
                //     primaryXAxis: CategoryAxis(),
                //     series: <CartesianSeries>[
                //       ColumnSeries<ChartData2, String>(
                //         dataSource: parseServerResponse(controller.dmdsData),
                //         onPointTap: (pointInteractionDetails) => debugPrint("${pointInteractionDetails.pointIndex} ${pointInteractionDetails.dataPoints} ${pointInteractionDetails.viewportPointIndex}"),
                //         // dataSource: [
                //         //   ChartData2('MGT', 90, Colors.red),
                //         //   ChartData2('Accts', 60, Colors.green),
                //         //   ChartData2('TV', 75, Colors.blue),
                //         //   ChartData2('Purc', 80, Colors.indigo),
                //         // ],
                //         xValueMapper: (ChartData2 data, _) => data.x,
                //         yValueMapper: (ChartData2 data, _) => data.y,
                //         pointColorMapper: (ChartData2 data, _) => data.color,
                //         dataLabelSettings: DataLabelSettings(
                //           isVisible: true,
                //           textStyle: TextStyle(color: Colors.white, fontSize: 12),
                //           labelAlignment: ChartDataLabelAlignment.top,
                //         ),
                //       ),
                //     ],
                //   ),
                // ) : SizedBox (child: Image.asset('assets/no_data.png')),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     height: 60,
                //     width: Get.width,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         color: Colors.indigo
                //     ),
                //     padding: EdgeInsets.all(8.0),
                //     alignment: Alignment.center,
                //     child: Text("Tender Published & Under Evaluation(IREPS & GeM)", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                //   ),
                // ),
                // controller.stackchartData.isNotEmpty ? Container(
                //     child: SfCartesianChart(
                //         primaryXAxis: CategoryAxis(),
                //         series: <CartesianSeries>[
                //           StackedColumnSeries<ChartData3, String>(
                //               dataLabelSettings: DataLabelSettings(
                //                   isVisible:true,
                //                   showCumulativeValues: true
                //               ),
                //               dataSource: parseChartData(controller.stackchartData),
                //               xValueMapper: (ChartData3 data, _) => data.x,
                //               yValueMapper: (ChartData3 data, _) => data.y1,
                //             pointColorMapper: (ChartData3 data, _) => Colors.pinkAccent,
                //           ),
                //           StackedColumnSeries<ChartData3, String>(
                //               dataLabelSettings: DataLabelSettings(
                //                   isVisible:true,
                //                   showCumulativeValues: true
                //               ),
                //               dataSource: parseChartData(controller.stackchartData),
                //               xValueMapper: (ChartData3 data, _) => data.x,
                //               yValueMapper: (ChartData3 data, _) => data.y2,
                //               pointColorMapper: (ChartData3 data, _) => Colors.yellow,
                //           ),
                //           StackedColumnSeries<ChartData3, String>(
                //               dataLabelSettings: DataLabelSettings(
                //                   isVisible:true,
                //                   showCumulativeValues: true
                //               ),
                //               dataSource: parseChartData(controller.stackchartData),
                //               xValueMapper: (ChartData3 data, _) => data.x,
                //               yValueMapper: (ChartData3 data, _) => data.y3,
                //               pointColorMapper: (ChartData3 data, _) => Colors.blue,
                //           ),
                //           StackedColumnSeries<ChartData3, String>(
                //               dataLabelSettings: DataLabelSettings(
                //                   isVisible:true,
                //                   showCumulativeValues: true
                //               ),
                //               dataSource: parseChartData(controller.stackchartData),
                //               xValueMapper: (ChartData3 data, _) => data.x,
                //               yValueMapper: (ChartData3 data, _) => data.y4,
                //               pointColorMapper: (ChartData3 data, _) => Colors.green,
                //           )
                //         ]
                //     )
                // ) : SizedBox (child: Image.asset('assets/no_data.png')),
              ],
            ),
          );
        }
        return SizedBox();
      }),
    );
  }
}
