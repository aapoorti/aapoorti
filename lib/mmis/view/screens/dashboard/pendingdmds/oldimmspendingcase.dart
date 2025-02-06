import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/controllers/oldimms_controller.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

class Oldimmspendingcase extends StatefulWidget {
  const Oldimmspendingcase({super.key});

  @override
  State<Oldimmspendingcase> createState() => _OldimmspendingcaseState();
}

class _OldimmspendingcaseState extends State<Oldimmspendingcase> {

  final oldimmscontroller = Get.put<OldiMMsController>(OldiMMsController());
  final _textsearchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //oldimmscontroller.fetchOldimmsData(context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    oldimmscontroller.fetchOldimmsData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Obx((){
          return oldimmscontroller.searchoption.value == true ? Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: TextField(
              cursorColor: Colors.indigo[300],
              controller: _textsearchController,
              autofocus: oldimmscontroller.searchoption.value,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5.0),
                  prefixIcon: Icon(Icons.search, color: Colors.indigo[300]),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.indigo[300]),
                    onPressed: () {
                      oldimmscontroller.changetoolbarUi(false);
                      _textsearchController.text = "";
                      oldimmscontroller.searchingOldimmsData(_textsearchController.text.trim(), context);
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
                  oldimmscontroller.searchingOldimmsData(query, context);
                } else {
                  oldimmscontroller.changetoolbarUi(false);
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
                    text: " Pending Demands",
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
        backgroundColor: MyColor.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [
          Obx((){
            return oldimmscontroller.searchoption.value == true ? SizedBox() : IconButton(onPressed: (){
              //FocusScope.of(context).requestFocus(_focusNode);
              oldimmscontroller.changetoolbarUi(true);
            }, icon: Icon(Icons.search, color: Colors.white));
          })
        ],
      ),
       body: Container(
           height: Get.height,
           width: Get.width,
           child: Obx((){
             if(oldimmscontroller.oldimmsState == OldimmsState.Busy){
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
             else if(oldimmscontroller.oldimmsState == OldimmsState.Finished){
               return ListView.builder(
                   itemCount: oldimmscontroller.oldimmsData.length,
                   shrinkWrap: true,
                   //controller: listScrollController,
                   padding: EdgeInsets.zero,
                   itemBuilder: (BuildContext context, int index) {
                     return Card(
                       elevation: 8.0,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(4.0),
                           side: BorderSide(
                             color: Colors.indigo.shade500,
                             width: 1.0,
                           )),
                       child: Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(4.0)),
                             color: Colors.white
                         ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Align(
                               alignment: Alignment.topLeft,
                               child: Container(
                                   height: 30,
                                   width: 35,
                                   alignment: Alignment.center,
                                   child: Text('${index + 1}',
                                       textAlign: TextAlign.center,
                                       style: TextStyle(
                                           fontSize: 14,
                                           color: Colors.white)),
                                   decoration: BoxDecoration(
                                       color: Colors.indigo,
                                       borderRadius: BorderRadius.only(
                                           bottomRight: Radius.circular(10),
                                           topLeft: Radius.circular(5)))),
                             ),
                             Padding(
                                 padding: EdgeInsets.symmetric(horizontal: 8),
                                 child: Column(children: <Widget>[
                                   Container(
                                     child: Column(
                                       mainAxisAlignment:
                                       MainAxisAlignment.start,
                                       crossAxisAlignment:
                                       CrossAxisAlignment.start,
                                       children: [
                                         Column(
                                           mainAxisAlignment:
                                           MainAxisAlignment.start,
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             Text('Demand No.', style: TextStyle(color: Colors.indigo, fontSize: 16, fontWeight: FontWeight.w500)),
                                             SizedBox(height: 4.0),
                                             Text(oldimmscontroller.oldimmsData[index].key7!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16))
                                           ],
                                         ),
                                         SizedBox(height: 10),
                                         Column(
                                           mainAxisAlignment:
                                           MainAxisAlignment.start,
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             Text("Date/Time", style: TextStyle(color: Colors.indigo, fontSize: 16, fontWeight: FontWeight.w500)),
                                             SizedBox(height: 4.0),
                                             Text(
                                                 oldimmscontroller.oldimmsData[index].key2!,
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontWeight:
                                                     FontWeight.w400,
                                                     fontSize: 16))
                                             //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                           ],
                                         ),
                                         SizedBox(height: 10),
                                         Column(
                                           mainAxisAlignment:
                                           MainAxisAlignment.start,
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                                 'Status',
                                                 style: TextStyle(
                                                     color: Colors.indigo,
                                                     fontSize: 16,
                                                     fontWeight:
                                                     FontWeight.w500)),
                                             SizedBox(height: 4.0),
                                             InkWell(
                                               onTap: (){

                                               },
                                               child: Text(
                                                   oldimmscontroller.oldimmsData[index].key4!,
                                                   style: TextStyle(
                                                       color: Colors.black,
                                                       fontWeight:
                                                       FontWeight.w400,
                                                       fontSize: 16)),
                                             )
                                             //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                           ],
                                         ),
                                         SizedBox(height: 10),
                                         Column(
                                           mainAxisAlignment:
                                           MainAxisAlignment.start,
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                                 'Received From',
                                                 style: TextStyle(
                                                     color: Colors.indigo,
                                                     fontSize: 16,
                                                     fontWeight: FontWeight.w500)),
                                             SizedBox(height: 4.0),
                                             Text(oldimmscontroller.oldimmsData[index].key6!, style: TextStyle(color: Colors.black, fontSize: 16))
                                             //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                           ],
                                         ),
                                         SizedBox(height: 10),
                                         Column(
                                           mainAxisAlignment:
                                           MainAxisAlignment.start,
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             Text("Consignee", style: TextStyle(color: Colors.indigo, fontSize: 16, fontWeight: FontWeight.w500)),
                                             SizedBox(height: 4.0),
                                             Text(oldimmscontroller.oldimmsData[index].key9!, style: TextStyle(color: Colors.black, fontSize: 16)),
                                           ],
                                         ),
                                         SizedBox(height: 10),
                                         Column(
                                           mainAxisAlignment:
                                           MainAxisAlignment.start,
                                           crossAxisAlignment:
                                           CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                                 'Demand Value',
                                                 style: TextStyle(
                                                     color: Colors.indigo,
                                                     fontSize: 16,
                                                     fontWeight:
                                                     FontWeight.w500)),
                                             SizedBox(height: 4.0),
                                             Text(oldimmscontroller.oldimmsData[index].key10!, style: TextStyle(color: Colors.black, fontSize: 16)),
                                             //Text("P.O.No. ${value.coveredDueData[index].poNo.toString()} dt. ${value.coveredDueData[index].podt.toString()} on M/s. ${value.coveredDueData[index].firm.toString()} PO-CAT:[ XX ]", style: TextStyle(color: Colors.black, fontSize: 16))
                                           ],
                                         ),
                                         SizedBox(height: 10),
                                         // Row(
                                         //   mainAxisAlignment: MainAxisAlignment.end,
                                         //   children: [
                                         //     Text(language.text('viemdmd'), style: TextStyle(color: Colors.blue, fontSize: 16)),
                                         //     ElevatedButton(
                                         //         style: ElevatedButton.styleFrom(shape: CircleBorder()),
                                         //         onPressed: () async {
                                         //           bool check = await UdmUtilities.checkconnection();
                                         //           // if(check == true) {
                                         //           //   //fileUrl = "https://www.trial.ireps.gov.in/ireps/etender/pdfdocs/MMIS/RN/DMD/2022/03/NR-33364-22-00121.pdf";
                                         //           //   var fileUrl = "https://${value.nstotallinklistData[index].pdf_path}";
                                         //           //   //var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                         //           //   if(fileUrl.toString().trim() == "https://www.ireps.gov.in") {
                                         //           //     UdmUtilities.showWarningFlushBar(context, language.text('sdnf'));
                                         //           //   } else {
                                         //           //     var fileName = fileUrl.substring(fileUrl.lastIndexOf("/"));
                                         //           //     UdmUtilities.openPdfBottomSheet(context, fileUrl, fileName, language.text('nsdemandtitle'));
                                         //           //   }
                                         //           // } else{
                                         //           //   Navigator.push(context, MaterialPageRoute(builder: (context) => NoConnection()));
                                         //           // }
                                         //         },
                                         //         child: Icon(
                                         //           Icons.feedback_outlined,
                                         //           color: Colors.white,
                                         //         )),
                                         //   ],
                                         // )
                                       ],
                                     ),
                                   ),
                                 ]))
                           ],
                         ),
                       ),
                     );
                   }
               );
             }
             else if(oldimmscontroller.oldimmsState == OldimmsState.Error){
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
             else if(oldimmscontroller.oldimmsState == OldimmsState.NoData){
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
             else if(oldimmscontroller.oldimmsState == OldimmsState.FinishedwithError){
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
           })
       ),
    );
  }
}
