import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/controllers/crismmis_controller.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class Crismmispendingcase extends StatefulWidget {
  const Crismmispendingcase({super.key});

  @override
  State<Crismmispendingcase> createState() => _CrismmispendingcaseState();
}

class _CrismmispendingcaseState extends State<Crismmispendingcase> {

  final newcrismmiscontroller = Get.put<CrisMMISController>(CrisMMISController());
  final _textsearchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newcrismmiscontroller.fetchCrismmisData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Obx((){
            return newcrismmiscontroller.searchoption.value == true ? Container(
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                cursorColor: Colors.indigo[300],
                controller: _textsearchController,
                autofocus: newcrismmiscontroller.searchoption.value,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5.0),
                    prefixIcon: Icon(Icons.search, color: Colors.indigo[300]),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.indigo[300]),
                      onPressed: () {
                        newcrismmiscontroller.changetoolbarUi(false);
                        _textsearchController.text = "";
                        newcrismmiscontroller.searchingCrismmisData(_textsearchController.text.trim(), context);
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
                    newcrismmiscontroller.searchingCrismmisData(query, context);
                  } else {
                    newcrismmiscontroller.changetoolbarUi(false);
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
              return newcrismmiscontroller.searchoption.value == true ? SizedBox() : IconButton(onPressed: (){
                //FocusScope.of(context).requestFocus(_focusNode);
                newcrismmiscontroller.changetoolbarUi(true);
              }, icon: Icon(Icons.search, color: Colors.white));
            })
          ],
        ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Obx((){
          if(newcrismmiscontroller.crismmisState == CrisMmmisState.Busy){
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
          else if(newcrismmiscontroller.crismmisState == CrisMmmisState.Finished){
            return Stack(
              children: [
                Container(
                    height: Get.height,
                    width: Get.width,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: ListView.builder(
                          itemCount: newcrismmiscontroller.newcrismmisData.length,
                          shrinkWrap: true,
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
                                                    Text('Demand No. & Date', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                                    SizedBox(height: 4.0),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: '${newcrismmiscontroller.newcrismmisData[index].key11}\n',
                                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: 'Dt.${newcrismmiscontroller.newcrismmisData[index].key12}',
                                                            style: TextStyle(color: Colors.black, fontSize: 16),
                                                          ),
                                                          // TextSpan(
                                                          //   text: 'testing',
                                                          //   style: TextStyle(color: Colors.blue, fontSize: 16),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    //Text("Dt.03-01-25 \n testing", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16))
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Indentor", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                                    SizedBox(height: 4.0),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: '${newcrismmiscontroller.newcrismmisData[index].key13!.split('<br/>')[0]}\n',
                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: '${newcrismmiscontroller.newcrismmisData[index].key13!.split('<br/>')[1]}',
                                                            style: TextStyle(color: Colors.blue, fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                                                    Text('Purpose', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                                    SizedBox(height: 4.0),
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: ReadMoreText(
                                                        "${newcrismmiscontroller.newcrismmisData[index].key4!}",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16
                                                        ),
                                                        trimLines: 2,
                                                        colorClickableText: Colors.blue[700],
                                                        trimMode: TrimMode.Line,
                                                        trimCollapsedText: '... More',
                                                        trimExpandedText: '...less',
                                                      ),
                                                    ),
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
                                                        'Value & Min. Approval Level',
                                                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                                    SizedBox(height: 4.0),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Rs.${newcrismmiscontroller.newcrismmisData[index].key18!}/-\n',
                                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: '${newcrismmiscontroller.newcrismmisData[index].key19!}',
                                                            style: TextStyle(color: Colors.red, fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                                                    Text("Current With", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                                    SizedBox(height: 4.0),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: '${newcrismmiscontroller.newcrismmisData[index].key15!}\n',
                                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: '${newcrismmiscontroller.newcrismmisData[index].key21!}',
                                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Status', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                                    SizedBox(height: 4.0),
                                                    InkWell(
                                                      onTap: (){
                                                        if(newcrismmiscontroller.newcrismmisData[index].key22.toString() != "NULL"){
                                                          showNoteDetails(context);
                                                        }
                                                      },
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: '${newcrismmiscontroller.newcrismmisData[index].key17!}\n',
                                                          style: TextStyle(color: Colors.black, fontSize: 16),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: newcrismmiscontroller.newcrismmisData[index].key22 == "NULL" || newcrismmiscontroller.newcrismmisData[index].key22 == null ? "NA" :'${removeLeadingDashes(newcrismmiscontroller.newcrismmisData[index].key22!)}',
                                                              style: TextStyle(color: Colors.blue, fontSize: 14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
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
                      ),
                    )
                ),
                Positioned(
                  bottom: 0,  // Position at the bottom
                  left: 0,    // Position from the left side
                  right: 0,   // Position from the right side
                  child: Container(
                    height: 45,  // Height of the container
                    color: Colors.indigo,  // Background color of the container
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Note", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                          IconButton(onPressed: (){
                            showNoteDetails(context);
                          }, icon: Icon(Icons.arrow_drop_up_outlined, size: 30, color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          else if(newcrismmiscontroller.crismmisState == CrisMmmisState.Error){
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
          else if(newcrismmiscontroller.crismmisState == CrisMmmisState.NoData){
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
          else if(newcrismmiscontroller.crismmisState == CrisMmmisState.FinishedwithError){
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
        }),
      )
    );
  }

  Future<void> showNoteDetails(BuildContext context) async{
    showModalBottomSheet(
      context: context,
      //isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
        ),
      ),
      constraints: BoxConstraints.loose(Size(Get.width, 180)),
      builder: (BuildContext context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: Get.width,
                child: Column(
                  children: [
                    SizedBox(height: 25.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.teal.shade200
                              ),
                              child: Text("D"),
                            ),
                            SizedBox(width: 5.0),
                            Text("Demand Initiated", style: TextStyle(color: Colors.black))
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.teal.shade200
                              ),
                              child: Text("F"),
                            ),
                            SizedBox(width: 5.0),
                            Text("Fund(Allocation) Certified", style: TextStyle(color: Colors.black))
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.teal.shade200
                              ),
                              child: Text("P"),
                            ),
                            SizedBox(width: 5.0),
                            Text("PAC Approved", style: TextStyle(color: Colors.black))
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.teal.shade200
                              ),
                              child: Text("T"),
                            ),
                            SizedBox(width: 5.0),
                            Text("Technical Vetting", style: TextStyle(color: Colors.black))
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.teal.shade200
                              ),
                              child: Text("C"),
                            ),
                            SizedBox(width: 5.0),
                            Text("Financial Concurrence", style: TextStyle(color: Colors.black))
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.teal.shade200
                              ),
                              child: Text("R"),
                            ),
                            SizedBox(width: 5.0),
                            Text("Purchase Review", style: TextStyle(color: Colors.black))
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.teal.shade200
                          ),
                          child: Text("S"),
                        ),
                        SizedBox(width: 5.0),
                        Text("Sanctioned", style: TextStyle(color: Colors.black))
                      ],
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -15,
                right: 5,
                left: 5,
                child: Container(
                  height: 35,
                  width: Get.width,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade500,
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Note", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.5)
                              ),
                              child: Icon(Icons.clear, size: 20, color: Colors.indigo.shade400),
                            ),
                          )
                        ],
                      ),
                  ),
                ))
          ],
        );
      },
    );
  }

  String removeLeadingDashes(String value) {
    if(value.startsWith('---')) {
      return value.replaceFirst('---', '');
    }
    return value;
  }
}
