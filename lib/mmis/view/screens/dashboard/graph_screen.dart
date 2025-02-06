import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/controllers/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String category;
  final double value;

  ChartData(this.category, this.value);
}

class ChartData2 {
  final String x;
  final double y;
  final Color color;
  ChartData2(this.x, this.y, this.color);
}

class ChartData3{
  ChartData3(this.x, this.y1, this.y2, this.y3, this.y4, this.color);
  final String x;
  final double y1;
  final double y2;
  final double y3;
  final double y4;
  final Color color;
}

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {

  final controller = Get.put(DashBoardController());

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.indigo
                    ),
                    alignment: Alignment.center,
                    child: Text("Demands Chart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                Container(
                  height: 80,
                  width: Get.width,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Container(height: 20, width: 20, color: Colors.red),
                            SizedBox(width: 4),
                            Text("Management")
                          ]),
                          SizedBox(width: 6),
                          Row(children: [
                            Container(height: 20, width: 20, color: Colors.green),
                            SizedBox(width: 4),
                            Text("CITG")
                          ]),
                          SizedBox(width: 6),
                          Row(children: [
                            Container(height: 20, width: 20, color: Colors.blue),
                            SizedBox(width: 4),
                            Text("Technical Vetting")
                          ]),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Container(height: 20, width: 20, color: Colors.indigo),
                            SizedBox(width: 10),
                            Text("Purchase")
                          ]),
                          SizedBox(width: 40),
                          Row(children: [
                            Container(height: 20, width: 20, color: Colors.orange),
                            SizedBox(width: 10),
                            Text("IND")
                          ]),
                          SizedBox(width: 20),
                          Row(children: [
                            Container(height: 20, width: 20, color: Colors.purpleAccent),
                            SizedBox(width: 10),
                            Text("Account")
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                controller.dmdsData.isNotEmpty ? Container(
                  height: Get.height * 0.5,
                  width: Get.width,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
                      ColumnSeries<ChartData2, String>(
                        dataSource: parseServerResponse(controller.dmdsData),
                        onPointTap: (pointInteractionDetails) => debugPrint("${pointInteractionDetails.pointIndex} ${pointInteractionDetails.dataPoints} ${pointInteractionDetails.viewportPointIndex}"),
                        // dataSource: [
                        //   ChartData2('MGT', 90, Colors.red),
                        //   ChartData2('Accts', 60, Colors.green),
                        //   ChartData2('TV', 75, Colors.blue),
                        //   ChartData2('Purc', 80, Colors.indigo),
                        // ],
                        xValueMapper: (ChartData2 data, _) => data.x,
                        yValueMapper: (ChartData2 data, _) => data.y,
                        pointColorMapper: (ChartData2 data, _) => data.color,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(color: Colors.white, fontSize: 12),
                          labelAlignment: ChartDataLabelAlignment.top,
                        ),
                      ),
                    ],
                  ),
                ) : SizedBox (child: Image.asset('assets/no_data.png')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo
                    ),
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text("Tender Published & Under Evaluation(IREPS & GeM)", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                controller.stackchartData.isNotEmpty ? Container(
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          StackedColumnSeries<ChartData3, String>(
                              dataLabelSettings: DataLabelSettings(
                                  isVisible:true,
                                  showCumulativeValues: true
                              ),
                              dataSource: parseChartData(controller.stackchartData),
                              xValueMapper: (ChartData3 data, _) => data.x,
                              yValueMapper: (ChartData3 data, _) => data.y1,
                            pointColorMapper: (ChartData3 data, _) => Colors.pinkAccent,
                          ),
                          StackedColumnSeries<ChartData3, String>(
                              dataLabelSettings: DataLabelSettings(
                                  isVisible:true,
                                  showCumulativeValues: true
                              ),
                              dataSource: parseChartData(controller.stackchartData),
                              xValueMapper: (ChartData3 data, _) => data.x,
                              yValueMapper: (ChartData3 data, _) => data.y2,
                              pointColorMapper: (ChartData3 data, _) => Colors.yellow,
                          ),
                          StackedColumnSeries<ChartData3, String>(
                              dataLabelSettings: DataLabelSettings(
                                  isVisible:true,
                                  showCumulativeValues: true
                              ),
                              dataSource: parseChartData(controller.stackchartData),
                              xValueMapper: (ChartData3 data, _) => data.x,
                              yValueMapper: (ChartData3 data, _) => data.y3,
                              pointColorMapper: (ChartData3 data, _) => Colors.blue,
                          ),
                          StackedColumnSeries<ChartData3, String>(
                              dataLabelSettings: DataLabelSettings(
                                  isVisible:true,
                                  showCumulativeValues: true
                              ),
                              dataSource: parseChartData(controller.stackchartData),
                              xValueMapper: (ChartData3 data, _) => data.x,
                              yValueMapper: (ChartData3 data, _) => data.y4,
                              pointColorMapper: (ChartData3 data, _) => Colors.green,
                          )
                        ]
                    )
                ) : SizedBox (child: Image.asset('assets/no_data.png')),
              ],
            ),
          );
        }
        return SizedBox();
      }),
    );
  }

  Widget buildChart(List<dynamic> jsonData) {
    final List<ChartData> dichartData = jsonData.map((data) {
      return ChartData(data['fyear'], double.parse(data['di'] ?? "0"));
    }).toList();


    final List<ChartData> drchartData = jsonData.map((data) {
      return ChartData(data['fyear'], double.parse(data['dr'] ?? '0'));
    }).toList();


    final List<ChartData> poichartData = jsonData.map((data) {
      return ChartData(data['fyear'], double.parse(data['poi'] ?? '0'));
    }).toList();

    final List<ChartData> pogchartData = jsonData.map((data) {
      return ChartData(data['fyear'], double.parse(data['pog'] ?? '0'));
    }).toList();


    final List<ChartData> tpchartData = jsonData.map((data) {
      return ChartData(data['fyear'], double.parse(data['tp'] ?? '0'));
    }).toList();

    final List<ChartData> tdchartData = jsonData.map((data) {
      return ChartData(data['fyear'], double.parse(data['td'] ?? '0'));
    }).toList();

    return SfCartesianChart(
      borderColor: Colors.grey,
      borderWidth: 1.5,
      enableAxisAnimation: true,
      tooltipBehavior: TooltipBehavior(
        enable: true,
        builder: (data, point, series, pointIndex, seriesIndex) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${point.y}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
      primaryXAxis: CategoryAxis(
        opposedPosition: true,
        rangePadding: ChartRangePadding.auto,
        plotOffset: 0,
        axisBorderType: AxisBorderType.rectangle,
        autoScrollingMode: AutoScrollingMode.start,
        tickPosition: TickPosition.outside,
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        zoomMode: ZoomMode.xy,
      ),
      series: <CartesianSeries>[
        _buildBarSeries(dichartData, Colors.red),
        _buildBarSeries(drchartData, Colors.indigo),
        _buildBarSeries(poichartData, Colors.blue),
        _buildBarSeries(pogchartData, Colors.green),
        _buildBarSeries(tpchartData, Colors.black),
        _buildBarSeries(tdchartData, Colors.orange),
      ],
    );
  }

  BarSeries<ChartData, String> _buildBarSeries(List<ChartData> data, Color color) {
    //debugPrint("Bar Data ${data.  }  ${data.value}");
    return BarSeries<ChartData, String>(
      enableTooltip: true,
      //initialIsVisible: true,
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
      ),
      dataSource: data,
      xValueMapper: (ChartData data, _) => data.category,
      yValueMapper: (ChartData data, _) => data.value,
      width: 0.9,
      color: color,
    );
  }

  List<ChartData2> parseServerResponse(List<dynamic> response) {
    List<ChartData2> chartDataList = [];

    for(var item in response) {
      String department = item['cur_dept'];
      //int count = int.parse(item['cnt']) == 0 ? 5 : 10;
      int count = int.parse(item['cnt'] ?? "0");
      Color color = department == 'MGMT' ? Colors.red : department == 'CITG' ? Colors.green : department == 'TV' ? Colors.blue : department == 'PURC' ? Colors.indigo : department == 'IND' ? Colors.orange : Colors.purpleAccent;

      // Create ChartData2 object and add to the list
      ChartData2 chartData = ChartData2(department, count.toDouble(), color);
      chartDataList.add(chartData);
    }

    return chartDataList;
  }

  List<ChartData3> parseChartData(List<dynamic> apiResponse) {
    return apiResponse.map((data) {
      // Map API data to the ChartData3 model
      Color color = _getColorForGroup(data['group_name']);

      return ChartData3(
        data['group_name'],
        double.parse(data['published_ireps'] ?? "0"),
        double.parse(data['published_gem'] ?? "0"),
        double.parse(data['under_evaluation_ireps'] ?? "0"),
        double.parse(data['under_evaluation_gem'] ?? "0"),
        color,
      );
    }).toList();
  }

  Color _getColorForGroup(String groupName) {
    switch (groupName) {
      case 'ADMN':
        return Colors.red;
      case 'CEP':
        return Colors.yellow;
      case 'CMM':
        return Colors.green;
      case 'CMS':
        return Colors.blue;
      case 'CN':
        return Colors.orange;
      case 'CP&WA':
        return Colors.pink;
      case 'CTCH':
        return Colors.pink;
      case 'EA':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
