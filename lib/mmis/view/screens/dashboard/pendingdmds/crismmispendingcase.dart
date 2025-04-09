// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_app/mmis/controllers/crismmis_controller.dart';
// import 'package:flutter_app/mmis/models/newCrisMmisData.dart';
// import 'package:flutter_app/mmis/routes/routes.dart';
// import 'package:flutter_app/mmis/utils/my_color.dart';
// import 'package:flutter_app/udm/helpers/wso2token.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:marquee/marquee.dart';
// import 'package:readmore/readmore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
//
// class Crismmispendingcase extends StatefulWidget {
//   const Crismmispendingcase({super.key});
//
//   @override
//   State<Crismmispendingcase> createState() => _CrismmispendingcaseState();
// }
//
// class _CrismmispendingcaseState extends State<Crismmispendingcase> {
//
//   final newcrismmiscontroller = Get.put<CrisMMISController>(CrisMMISController());
//   final _textsearchController = TextEditingController();
//
//   String? postId = Get.arguments[0];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchCrimMMISData();
//   }
//
//   Future<void> fetchCrimMMISData() async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
//     if(providedTime.isBefore(DateTime.now())){
//       await fetchToken(context);
//       newcrismmiscontroller.fetchCrismmisData(context, postId!);
//     }
//     else{
//       newcrismmiscontroller.fetchCrismmisData(context, postId!);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//           title: Obx((){
//             return newcrismmiscontroller.searchoption.value == true ? Container(
//               width: double.infinity,
//               height: 40,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(5)),
//               child: TextField(
//                 cursorColor: Colors.indigo[300],
//                 controller: _textsearchController,
//                 autofocus: newcrismmiscontroller.searchoption.value,
//                 decoration: InputDecoration(
//                     contentPadding: EdgeInsets.only(top: 5.0),
//                     prefixIcon: Icon(Icons.search, color: Colors.indigo[300]),
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.clear, color: Colors.indigo[300]),
//                       onPressed: () {
//                         newcrismmiscontroller.changetoolbarUi(false);
//                         _textsearchController.text = "";
//                         newcrismmiscontroller.searchingCrismmisData(_textsearchController.text.trim(), context);
//                       },
//                     ),
//                     focusColor: Colors.indigo[300],
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           color: Colors.indigo.shade300, width: 1.0),
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           color: Colors.indigo.shade300, width: 1.0),
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           color: Colors.indigo.shade300, width: 1.0),
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     hintText: "Search",
//                     border: InputBorder.none),
//                 onChanged: (query) {
//                   if(query.isNotEmpty) {
//                     newcrismmiscontroller.searchingCrismmisData(query, context);
//                   } else {
//                     newcrismmiscontroller.changetoolbarUi(false);
//                     _textsearchController.text = "";
//                   }
//                 },
//               ),
//             ) : Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(Icons.arrow_back, color: Colors.white)),
//                 SizedBox(width: 10),
//                 Container(
//                     height: Get.height * 0.10,
//                     width: Get.width / 1.5,
//                     child: Marquee(
//                       text: " Pending Demands",
//                       scrollAxis: Axis.horizontal,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       blankSpace: 30.0,
//                       velocity: 100.0,
//                       style: TextStyle(fontSize: 18,color: Colors.white),
//                       pauseAfterRound: Duration(seconds: 1),
//                       accelerationDuration: Duration(seconds: 1),
//                       accelerationCurve: Curves.linear,
//                       decelerationDuration: Duration(milliseconds: 500),
//                       decelerationCurve: Curves.easeOut,
//                     ))
//               ],
//             );
//           }),
//           backgroundColor:  AapoortiConstants.primary,
//           iconTheme: IconThemeData(color: Colors.white),
//           automaticallyImplyLeading: false,
//           actions: [
//             Obx((){
//               return newcrismmiscontroller.searchoption.value == true ? SizedBox() : IconButton(onPressed: (){
//                 //FocusScope.of(context).requestFocus(_focusNode);
//                 newcrismmiscontroller.changetoolbarUi(true);
//               }, icon: Icon(Icons.search, color: Colors.white));
//             })
//           ],
//         ),
//       body: Container(
//         height: Get.height,
//         width: Get.width,
//         child: Obx((){
//           if(newcrismmiscontroller.crismmisState == CrisMmmisState.Busy){
//             return SingleChildScrollView(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: ListView.builder(
//                             itemCount: 4,
//                             shrinkWrap: true,
//                             padding: EdgeInsets.all(5),
//                             itemBuilder: (context, index) {
//                               return Card(
//                                 elevation: 8.0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4.0),
//                                 ),
//                                 child: SizedBox(height: Get.height * 0.45),
//                               );
//                             }))
//                   ]),
//             );
//           }
//           else if(newcrismmiscontroller.crismmisState == CrisMmmisState.Finished){
//             return ListView.builder(
//               padding: const EdgeInsets.all(5.0),
//               itemCount: newcrismmiscontroller.newcrismmisData.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: DemandCard(
//                     demandDetails: newcrismmiscontroller.newcrismmisData[index],
//                     demandNumber: index + 1,
//                   ),
//                 );
//               },
//             );
//             // return Stack(
//             //   children: [
//             //     Container(
//             //         height: Get.height,
//             //         width: Get.width,
//             //         child: Padding(
//             //           padding: EdgeInsets.only(bottom: 0.0, left: 2.0, right: 2.0),
//             //           child: ListView.builder(
//             //             //padding: const EdgeInsets.all(16),
//             //             itemCount: newcrismmiscontroller.newcrismmisData.length,
//             //             shrinkWrap: true,
//             //             padding: EdgeInsets.zero,
//             //             itemBuilder: (context, index) {
//             //               return Padding(
//             //                 padding: const EdgeInsets.only(bottom: 5),
//             //                 child: DemandCard(
//             //                   demandDetails: newcrismmiscontroller.newcrismmisData[index],
//             //                   demandNumber: index + 1,
//             //                   onStatusCodeTap: () => _showStatusCodeModal(context),
//             //                 ),
//             //               );
//             //             },
//             //           ),
//             //         )
//             //     ),
//             //     // Positioned(
//             //     //   bottom: 0,  // Position at the bottom
//             //     //   left: 0,    // Position from the left side
//             //     //   right: 0,   // Position from the right side
//             //     //   child: Container(
//             //     //     height: 45,  // Height of the container
//             //     //     color: Colors.indigo,  // Background color of the container
//             //     //     child: Padding(
//             //     //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             //     //       child: Row(
//             //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     //         children: [
//             //     //           Text("Note", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
//             //     //           IconButton(onPressed: (){
//             //     //             _showStatusCodeModal(context);
//             //     //           }, icon: Icon(Icons.arrow_drop_up_outlined, size: 30, color: Colors.white))
//             //     //         ],
//             //     //       ),
//             //     //     ),
//             //     //   ),
//             //     // ),
//             //   ],
//             // );
//           }
//           else if(newcrismmiscontroller.crismmisState == CrisMmmisState.Error){
//             return Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 120,
//                     width: 120,
//                     child: Lottie.asset('assets/json/no_data.json'),
//                   ),
//                   AnimatedTextKit(
//                       isRepeatingAnimation: false,
//                       animatedTexts: [
//                         TyperAnimatedText(
//                             "Data not found",
//                             speed: Duration(milliseconds: 150),
//                             textStyle: TextStyle(fontWeight: FontWeight.bold)),
//                       ])
//                 ],
//               ),
//             );
//           }
//           else if(newcrismmiscontroller.crismmisState == CrisMmmisState.NoData){
//             return Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 120,
//                     width: 120,
//                     child: Lottie.asset('assets/json/no_data.json'),
//                   ),
//                   AnimatedTextKit(
//                       isRepeatingAnimation: false,
//                       animatedTexts: [
//                         TyperAnimatedText(
//                             "Data not found",
//                             speed: Duration(milliseconds: 150),
//                             textStyle: TextStyle(fontWeight: FontWeight.bold)),
//                       ])
//                 ],
//               ),
//             );
//           }
//           else if(newcrismmiscontroller.crismmisState == CrisMmmisState.FinishedwithError){
//             return Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 120,
//                     width: 120,
//                     child: Lottie.asset('assets/json/no_data.json'),
//                   ),
//                   AnimatedTextKit(
//                       isRepeatingAnimation: false,
//                       animatedTexts: [
//                         TyperAnimatedText(
//                             "Data not found",
//                             speed: Duration(milliseconds: 150),
//                             textStyle: TextStyle(fontWeight: FontWeight.bold)),
//                       ])
//                 ],
//               ),
//             );
//           }
//           return SizedBox();
//         }),
//       )
//     );
//   }
//
//   void _showStatusCodeModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.3,
//         minChildSize: 0.2,
//         maxChildSize: 0.8,
//         builder: (_, controller) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF0073CF),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Status Code Reference',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   controller: controller,
//                   padding: const EdgeInsets.all(20),
//                   child: Wrap(
//                     spacing: 12,
//                     runSpacing: 12,
//                     children: [
//                       _buildStatusItem('D', 'Demand Initiated'),
//                       _buildStatusItem('F', 'Fund(Allocation) Certified'),
//                       _buildStatusItem('P', 'PAC Approved'),
//                       _buildStatusItem('T', 'Technical Vetting'),
//                       _buildStatusItem('C', 'Financial Concurrence'),
//                       _buildStatusItem('R', 'Purchase Review'),
//                       _buildStatusItem('S', 'Sanctioned'),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusItem(String code, String description) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: Colors.blue.shade100),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.blue[100],
//               shape: BoxShape.circle,
//             ),
//             child: Text(
//               code,
//               style: const TextStyle(
//                 color: Color(0xFF0073CF),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Flexible(
//             child: Text(
//               description,
//               style: const TextStyle(
//                 color: Color(0xFF0073CF),
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   // Future<void> showNoteDetails(BuildContext context) async{
//   //   showModalBottomSheet(
//   //     context: context,
//   //     //isDismissible: false,
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.only(
//   //         topLeft: Radius.circular(5.0),
//   //         topRight: Radius.circular(5.0),
//   //       ),
//   //     ),
//   //     constraints: BoxConstraints.loose(Size(Get.width, 180)),
//   //     builder: (BuildContext context) {
//   //       return Stack(
//   //         clipBehavior: Clip.none,
//   //         children: [
//   //           Padding(
//   //             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//   //             child: Container(
//   //               width: Get.width,
//   //               child: Column(
//   //                 children: [
//   //                   SizedBox(height: 25.0),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: [
//   //                       Row(
//   //                         children: [
//   //                           Container(
//   //                             height: 30,
//   //                             width: 30,
//   //                             alignment: Alignment.center,
//   //                             decoration: BoxDecoration(
//   //                                 borderRadius: BorderRadius.circular(8.0),
//   //                                 color: Colors.teal.shade200
//   //                             ),
//   //                             child: Text("D"),
//   //                           ),
//   //                           SizedBox(width: 5.0),
//   //                           Text("Demand Initiated", style: TextStyle(color: Colors.black))
//   //                         ],
//   //                       ),
//   //                       Row(
//   //                         children: [
//   //                           Container(
//   //                             height: 30,
//   //                             width: 30,
//   //                             alignment: Alignment.center,
//   //                             decoration: BoxDecoration(
//   //                                 borderRadius: BorderRadius.circular(8.0),
//   //                                 color: Colors.teal.shade200
//   //                             ),
//   //                             child: Text("F"),
//   //                           ),
//   //                           SizedBox(width: 5.0),
//   //                           Text("Fund(Allocation) Certified", style: TextStyle(color: Colors.black))
//   //                         ],
//   //                       )
//   //                     ],
//   //                   ),
//   //                   SizedBox(height: 5.0),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: [
//   //                       Row(
//   //                         children: [
//   //                           Container(
//   //                             height: 30,
//   //                             width: 30,
//   //                             alignment: Alignment.center,
//   //                             decoration: BoxDecoration(
//   //                                 borderRadius: BorderRadius.circular(8.0),
//   //                                 color: Colors.teal.shade200
//   //                             ),
//   //                             child: Text("P"),
//   //                           ),
//   //                           SizedBox(width: 5.0),
//   //                           Text("PAC Approved", style: TextStyle(color: Colors.black))
//   //                         ],
//   //                       ),
//   //                       Row(
//   //                         children: [
//   //                           Container(
//   //                             height: 30,
//   //                             width: 30,
//   //                             alignment: Alignment.center,
//   //                             decoration: BoxDecoration(
//   //                                 borderRadius: BorderRadius.circular(8.0),
//   //                                 color: Colors.teal.shade200
//   //                             ),
//   //                             child: Text("T"),
//   //                           ),
//   //                           SizedBox(width: 5.0),
//   //                           Text("Technical Vetting", style: TextStyle(color: Colors.black))
//   //                         ],
//   //                       )
//   //                     ],
//   //                   ),
//   //                   SizedBox(height: 5.0),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                     children: [
//   //                       Row(
//   //                         children: [
//   //                           Container(
//   //                             height: 30,
//   //                             width: 30,
//   //                             alignment: Alignment.center,
//   //                             decoration: BoxDecoration(
//   //                                 borderRadius: BorderRadius.circular(8.0),
//   //                                 color: Colors.teal.shade200
//   //                             ),
//   //                             child: Text("C"),
//   //                           ),
//   //                           SizedBox(width: 5.0),
//   //                           Text("Financial Concurrence", style: TextStyle(color: Colors.black))
//   //                         ],
//   //                       ),
//   //                       Row(
//   //                         children: [
//   //                           Container(
//   //                             height: 30,
//   //                             width: 30,
//   //                             alignment: Alignment.center,
//   //                             decoration: BoxDecoration(
//   //                                 borderRadius: BorderRadius.circular(8.0),
//   //                                 color: Colors.teal.shade200
//   //                             ),
//   //                             child: Text("R"),
//   //                           ),
//   //                           SizedBox(width: 5.0),
//   //                           Text("Purchase Review", style: TextStyle(color: Colors.black))
//   //                         ],
//   //                       )
//   //                     ],
//   //                   ),
//   //                   SizedBox(height: 5.0),
//   //                   Row(
//   //                     children: [
//   //                       Container(
//   //                         height: 30,
//   //                         width: 30,
//   //                         alignment: Alignment.center,
//   //                         decoration: BoxDecoration(
//   //                             borderRadius: BorderRadius.circular(8.0),
//   //                             color: Colors.teal.shade200
//   //                         ),
//   //                         child: Text("S"),
//   //                       ),
//   //                       SizedBox(width: 5.0),
//   //                       Text("Sanctioned", style: TextStyle(color: Colors.black))
//   //                     ],
//   //                   ),
//   //                   SizedBox(height: 5.0),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //           Positioned(
//   //               top: -15,
//   //               right: 5,
//   //               left: 5,
//   //               child: Container(
//   //                 height: 35,
//   //                 width: Get.width,
//   //                 alignment: Alignment.centerLeft,
//   //                 decoration: BoxDecoration(
//   //                     color: Colors.indigo.shade500,
//   //                     borderRadius: BorderRadius.circular(8.0)
//   //                 ),
//   //                 child: Padding(
//   //                     padding: EdgeInsets.symmetric(horizontal: 10),
//   //                     child: Row(
//   //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                       children: [
//   //                         Text("Note", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//   //                         InkWell(
//   //                           onTap: (){
//   //                             Navigator.pop(context);
//   //                           },
//   //                           child: Container(
//   //                             height: 25,
//   //                             width: 25,
//   //                             decoration: BoxDecoration(
//   //                               color: Colors.white,
//   //                               borderRadius: BorderRadius.circular(12.5)
//   //                             ),
//   //                             child: Icon(Icons.clear, size: 20, color: Colors.indigo.shade400),
//   //                           ),
//   //                         )
//   //                       ],
//   //                     ),
//   //                 ),
//   //               ))
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//
// }
//
// class DemandCard extends StatefulWidget {
//   final CrisMmisData demandDetails;
//   final int demandNumber;
//
//   const DemandCard({
//     Key? key,
//     required this.demandDetails,
//     required this.demandNumber,
//   }) : super(key: key);
//
//   @override
//   State<DemandCard> createState() => _DemandCardState();
// }
//
// class _DemandCardState extends State<DemandCard> {
//   bool _showStatusReference = false;
//
//   Widget _buildStatusCodeReference(String status) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         Container(
//           width: double.infinity,
//           margin: const EdgeInsets.only(top: 10, bottom: 16, left: 34),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.withOpacity(0.3)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 5,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Status Code Reference',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13,
//                       color: const Color(0xFF0073CF),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         _showStatusReference = false;
//                       });
//                     },
//                     child: Icon(
//                       Icons.close,
//                       size: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(height: 16),
//               StatusCodeWrap(statusCodes: getstatuslist(status))
//               // Wrap(
//               //   spacing: 12,
//               //   runSpacing: 8,
//               //   children: [
//               //     _buildStatusCodeItem('D', 'Demand Initiated'),
//               //     _buildStatusCodeItem('F', 'Fund(Allocation) Certified'),
//               //     _buildStatusCodeItem('P', 'PAC Approved'),
//               //     _buildStatusCodeItem('T', 'Technical Vetting'),
//               //     _buildStatusCodeItem('C', 'Financial Concurrence'),
//               //     _buildStatusCodeItem('R', 'Purchase Review'),
//               //     _buildStatusCodeItem('S', 'Sanctioned'),
//               //   ],
//               // ),
//             ],
//           ),
//         ),
//         // Arrow pointing up
//         Positioned(
//           top: 2,
//           left: 50,
//           child: CustomPaint(
//             painter: ArrowPainter(Colors.grey[100]!, Colors.grey.withOpacity(0.3)),
//             size: const Size(16, 8),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusCodeItem(String code, String description) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             color: Colors.blue[100],
//             shape: BoxShape.circle,
//           ),
//           child: Text(
//             code,
//             style: const TextStyle(
//               color: Color(0xFF0073CF),
//               fontWeight: FontWeight.bold,
//               fontSize: 11,
//             ),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           description,
//           style: const TextStyle(
//             color: Color(0xFF0073CF),
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: (){
//         Get.toNamed(Routes.searchdmdpreviewScreen, arguments: [widget.demandDetails.key10]);
//       },
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF0073CF), Color(0xFF1E88E5)],
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         '${widget.demandNumber}. ${widget.demandDetails.key11}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 3,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               widget.demandDetails.key12!,
//                               style: TextStyle(color: Colors.grey[800], fontSize: 14),
//                               //overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               _buildDetailItem(
//                 context,
//                 Icons.info_outline,
//                 'Status',
//                 '${widget.demandDetails.key17!}',
//                 subtitle: widget.demandDetails.key22 == "NULL" || widget.demandDetails.key22 == null ? "NA" :'${removeLeadingDashes(widget.demandDetails.key22!)}',
//                 showStatusInfo: true,
//               ),
//               if(_showStatusReference) _buildStatusCodeReference(widget.demandDetails.key22!),
//               _buildDetailItem(
//                 context,
//                 Icons.person,
//                 'Indentor',
//                 '${widget.demandDetails.key13!.split('<br/>')[0]}',
//                 subtitle:'${ widget.demandDetails.key13!.split('<br/>')[1]}',
//                 isBold: true,
//                 isBlueText: true,
//               ),
//               _buildDetailItem(
//                 context,
//                 Icons.person,
//                 'Currently With',
//                 widget.demandDetails.key15!,
//                 subtitle: '${widget.demandDetails.key21!}',
//                 isBold: true,
//                 isBlueText: true,
//               ),
//               _buildDetailItem(
//                 context,
//                 Icons.description,
//                 'Purpose',
//                 "${widget.demandDetails.key4!}",
//               ),
//               _buildDetailItem(
//                 context,
//                 Icons.currency_rupee,
//                 'Value / Approval Level',
//                 '${widget.demandDetails.key18!} / ${widget.demandDetails.key19!}',
//                 isLast: true,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailItem(
//       BuildContext context,
//       IconData icon,
//       String label,
//       String value, {
//         String? subtitle,
//         bool isBold = false,
//         bool isBlueText = false,
//         bool isLast = false,
//         bool showStatusInfo = false,
//       }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isLast ? 0 : (_showStatusReference && showStatusInfo ? 0 : 20)),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: const Color(0xFF0073CF).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Icon(icon, size: 16, color: const Color(0xFF0073CF)),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontSize: 15,
//                     fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//                   ),
//                   overflow: TextOverflow.visible,
//                 ),
//                 if(subtitle != null) ...[
//                   const SizedBox(height: 2),
//                   Row(
//                     children: [
//                       Flexible(
//                         child: Text(
//                           subtitle,
//                           style: TextStyle(
//                             color: isBlueText ? const Color(0xFF0073CF) : Colors.grey[600],
//                             fontSize: 14,
//                             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       if(showStatusInfo) ...[
//                         const SizedBox(width: 4),
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               _showStatusReference = !_showStatusReference;
//                             });
//                           },
//                           child: Icon(
//                             Icons.info_outline,
//                             size: 14,
//                             color: const Color(0xFF0073CF),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Custom painter for drawing the arrow
// class ArrowPainter extends CustomPainter {
//   final Color fillColor;
//   final Color borderColor;
//
//   ArrowPainter(this.fillColor, this.borderColor);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint fillPaint = Paint()
//       ..color = fillColor
//       ..style = PaintingStyle.fill;
//
//     final Paint borderPaint = Paint()
//       ..color = borderColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;
//
//     final Path path = Path();
//     path.moveTo(0, size.height);
//     path.lineTo(size.width / 2, 0);
//     path.lineTo(size.width, size.height);
//     path.close();
//
//     canvas.drawPath(path, fillPaint);
//     canvas.drawPath(path, borderPaint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
//
// class StatusCodeWrap extends StatelessWidget {
//   final List<String> statusCodes;
//
//   StatusCodeWrap({required this.statusCodes});
//
//   // Mapping of status codes to descriptions
//   final Map<String, String> statusDescriptions = {
//     'D' : 'Demand Initiated',
//     'F': 'Fund(Allocation) Certified',
//     'P' : 'PAC Approved',
//     'V' : 'Technical Vetting',
//     'C': 'Financial Concurrence',
//     'R': 'Purchase Review',
//     'S': 'Sanctioned',
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 12,
//       runSpacing: 8,
//       children: statusCodes
//           .map((code) => _buildStatusCodeItem(code, statusDescriptions[code]!))
//           .toList(),
//     );
//   }
//
//   Widget _buildStatusCodeItem(String code, String description) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             color: Colors.blue[100],
//             shape: BoxShape.circle,
//           ),
//           child: Text(
//             code,
//             style: const TextStyle(
//               color: Color(0xFF0073CF),
//               fontWeight: FontWeight.bold,
//               fontSize: 11,
//             ),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           description,
//           style: const TextStyle(
//             color: Color(0xFF0073CF),
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // class DemandCard extends StatelessWidget {
// //   final CrisMmisData demandDetails;
// //   final int demandNumber;
// //   final VoidCallback onStatusCodeTap;
// //
// //   const DemandCard({
// //     Key? key,
// //     required this.demandDetails,
// //     required this.demandNumber,
// //     required this.onStatusCodeTap,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               children: [
// //                 Text('Demand No. & Date', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
// //                 SizedBox(height: 4.0),
// //                 RichText(
// //                   text: TextSpan(
// //                     text: '${demandDetails.key11}\n',
// //                     style: TextStyle(color: Colors.black, fontSize: 16),
// //                     children: <TextSpan>[
// //                       TextSpan(
// //                         text: 'Dt.${demandDetails.key12}',
// //                         style: TextStyle(color: Colors.black, fontSize: 16),
// //                       ),
// //                       // TextSpan(
// //                       //   text: 'testing',
// //                       //   style: TextStyle(color: Colors.blue, fontSize: 16),
// //                       // ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 20),
// //             _buildDetailItem(
// //               Icons.info_outline,
// //               'Status',
// //               '${demandDetails.key17!}',
// //               subtitle: demandDetails.key22 == "NULL" || demandDetails.key22 == null ? "NA" :'${removeLeadingDashes(demandDetails.key22!)}',
// //               onStatusCodeTap: onStatusCodeTap,
// //             ),
// //             _buildDetailItem(
// //               Icons.person,
// //               'Indentor',
// //               '${demandDetails.key13!.split('<br/>')[0]}',
// //               subtitle: '${demandDetails.key13!.split('<br/>')[1]}',
// //               isBold: true,
// //               isBlueText: true,
// //             ),
// //             _buildDetailItem(
// //               Icons.person,
// //               'Currently With',
// //               '${demandDetails.key15!}',
// //               subtitle: '${demandDetails.key21!}',
// //               isBold: true,
// //               isBlueText: true,
// //             ),
// //             _buildDetailItem(
// //               Icons.description,
// //               'Purpose',
// //               "${demandDetails.key4!}",
// //             ),
// //             _buildDetailItem(
// //               Icons.currency_rupee,
// //               'Value / Approval Level',
// //               'Rs.${demandDetails.key18!}/-',
// //               subtitle: '${demandDetails.key19!}',
// //               isLast: true,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDetailItem(
// //       IconData icon,
// //       String label,
// //       String value, {
// //         String? subtitle,
// //         bool isBold = false,
// //         bool isBlueText = false,
// //         bool isLast = false,
// //         VoidCallback? onStatusCodeTap,
// //       }) {
// //     return Padding(
// //       padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(6),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF0073CF).withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(6),
// //             ),
// //             child: Icon(icon, size: 16, color: const Color(0xFF0073CF)),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   label,
// //                   style: TextStyle(
// //                     color: Colors.grey[600],
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   value,
// //                   style: TextStyle(
// //                     color: Colors.black87,
// //                     fontSize: 15,
// //                     fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
// //                   ),
// //                 ),
// //                 if(subtitle != null) ...[
// //                   const SizedBox(height: 2),
// //                   InkWell(
// //                     onTap: label == 'Status' ? onStatusCodeTap : null,
// //                     child: Row(
// //                       children: [
// //                         Text(
// //                           subtitle,
// //                           style: TextStyle(
// //                             color: isBlueText ? const Color(0xFF0073CF) : Colors.grey[600],
// //                             fontSize: 14,
// //                             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
// //                           ),
// //                         ),
// //                         if (label == 'Status') ...[
// //                           const SizedBox(width: 4),
// //                           Icon(
// //                             Icons.info_outline,
// //                             size: 14,
// //                             color: const Color(0xFF0073CF),
// //                           ),
// //                         ],
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
//   String removeLeadingDashes(String value) {
//     if(value.startsWith('---')) {
//       return value.replaceFirst('---', '');
//     }
//     return value;
//   }
//
//   List<String> getstatuslist(String input){
//     List<String> result = input.split('---').where((e) => e.isNotEmpty).toList();
//     return result;
//   }


import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/mmis/controllers/crismmis_controller.dart';
import 'package:flutter_app/mmis/models/newCrisMmisData.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Crismmispendingcase extends StatefulWidget {
  const Crismmispendingcase({super.key});

  @override
  State<Crismmispendingcase> createState() => _CrismmispendingcaseState();
}

class _CrismmispendingcaseState extends State<Crismmispendingcase> {

  final newcrismmiscontroller = Get.put<CrisMMISController>(CrisMMISController());
  final _textsearchController = TextEditingController();

  String? postId = Get.arguments[0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCrimMMISData();
  }

  Future<void> fetchCrimMMISData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
    if(providedTime.isBefore(DateTime.now())){
      await fetchToken(context);
      newcrismmiscontroller.fetchCrismmisData(context, postId!);
    }
    else{
      newcrismmiscontroller.fetchCrismmisData(context, postId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
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
          backgroundColor:  AapoortiConstants.primary,
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
              return ListView.builder(
                padding: const EdgeInsets.all(5.0),
                itemCount: newcrismmiscontroller.newcrismmisData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DemandCard(
                      demandDetails: newcrismmiscontroller.newcrismmisData[index],
                      demandNumber: index + 1,
                    ),
                  );
                },
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

  void _showStatusCodeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF0073CF),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status Code Reference',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildStatusItem('D', 'Demand Initiated'),
                      _buildStatusItem('F', 'Fund(Allocation) Certified'),
                      _buildStatusItem('P', 'PAC Approved'),
                      _buildStatusItem('T', 'Technical Vetting'),
                      _buildStatusItem('C', 'Financial Concurrence'),
                      _buildStatusItem('R', 'Purchase Review'),
                      _buildStatusItem('S', 'Sanctioned'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(String code, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: Color(0xFF0073CF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              description,
              style: const TextStyle(
                color: Color(0xFF0073CF),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DemandCard extends StatefulWidget {
  final CrisMmisData demandDetails;
  final int demandNumber;

  const DemandCard({
    Key? key,
    required this.demandDetails,
    required this.demandNumber,
  }) : super(key: key);

  @override
  State<DemandCard> createState() => _DemandCardState();
}

class _DemandCardState extends State<DemandCard> {
  void _showStatusCodeDialog(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status Code Reference',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0073CF),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: StatusCodeWrap(statusCodes: getstatuslist(status)),
          ),
          contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.toNamed(Routes.searchdmdpreviewScreen, arguments: [widget.demandDetails.key10]);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0073CF), Color(0xFF1E88E5)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.demandNumber}. ${widget.demandDetails.key11}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.demandDetails.key12!,
                              style: TextStyle(color: Colors.grey[800], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailItem(
                context,
                Icons.info_outline,
                'Status',
                '${widget.demandDetails.key17!}',
                subtitle: widget.demandDetails.key22 == "NULL" || widget.demandDetails.key22 == null ? "NA" :'${removeLeadingDashes(widget.demandDetails.key22!)}',
                showStatusInfo: true,
                status: widget.demandDetails.key22!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Indentor Section (Left)
                  Expanded(
                    flex: 6,
                    child: _buildDetailItem(
                      context,
                      Icons.person,
                      'Indentor',
                      '${widget.demandDetails.key13!.split('<br/>')[0]}',
                      subtitle: '${widget.demandDetails.key13!.split('<br/>')[1]}',
                      isBold: true,
                      isBlueText: true,
                      noBottomPadding: true,
                      isSmallText: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Value/Approval Section (Right)
                  Expanded(
                    flex: 5,
                    child: _buildDetailItem(
                      context,
                      Icons.currency_rupee,
                      'Value / Approval',
                      '${widget.demandDetails.key18!}',
                      subtitle: '${widget.demandDetails.key19!}',
                      noBottomPadding: true,
                      isSmallText: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailItem(
                context,
                Icons.person,
                'Currently With',
                widget.demandDetails.key15!,
                subtitle: '${widget.demandDetails.key21!}',
                isBold: true,
                isBlueText: true,
              ),
              _buildDetailItem(
                context,
                Icons.description,
                'Purpose',
                "${widget.demandDetails.key4!}",
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context,
      IconData icon,
      String label,
      String value, {
        String? subtitle,
        bool isBold = false,
        bool isBlueText = false,
        bool isLast = false,
        bool showStatusInfo = false,
        bool noBottomPadding = false,
        String? status,
        bool isSmallText = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast || noBottomPadding ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF0073CF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(icon, size: 14, color: const Color(0xFF0073CF)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: isSmallText ? 12 : 14,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.visible,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            color: isBlueText ? const Color(0xFF0073CF) : Colors.grey[600],
                            fontSize: isSmallText ? 11 : 13,
                            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      if (showStatusInfo && status != null) ...[
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            _showStatusCodeDialog(context, status);
                          },
                          child: Icon(
                            Icons.info_outline,
                            size: 12,
                            color: const Color(0xFF0073CF),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusCodeWrap extends StatelessWidget {
  final List<String> statusCodes;

  StatusCodeWrap({required this.statusCodes});

  // Mapping of status codes to descriptions
  final Map<String, String> statusDescriptions = {
    'D' : 'Demand Initiated',
    'F': 'Fund(Allocation) Certified',
    'P' : 'PAC Approved',
    'V' : 'Technical Vetting',
    'C': 'Financial Concurrence',
    'R': 'Purchase Review',
    'S': 'Sanctioned',
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: statusCodes
          .map((code) => _buildStatusCodeItem(code, statusDescriptions[code]!))
          .toList(),
    );
  }

  Widget _buildStatusCodeItem(String code, String description) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          child: Text(
            code,
            style: const TextStyle(
              color: Color(0xFF0073CF),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          description,
          style: const TextStyle(
            color: Color(0xFF0073CF),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

String removeLeadingDashes(String value) {
  if(value.startsWith('---')) {
    return value.replaceFirst('---', '');
  }
  return value;
}

List<String> getstatuslist(String input){
  List<String> result = input.split('---').where((e) => e.isNotEmpty).toList();
  return result;
}


