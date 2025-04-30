// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_app/udm/warranty_complaint_summary/view/Warranty_DeatilsScreen.dart';
// import 'package:provider/provider.dart';
// import '../../helpers/shared_data.dart';
// import '../../providers/languageProvider.dart';
// import '../provider/search.dart';
// import '../view_model/WarrantyCompaint_ViewModel.dart';
//
// class WarrantyComplaintDropdown extends StatefulWidget {
//   static const routeName = "/WarrantyComplaintDropdown-screen";
//
//   @override
//   State<WarrantyComplaintDropdown> createState() => _WarrantyComplaintDropdownState();
// }
//
// class _WarrantyComplaintDropdownState extends State<WarrantyComplaintDropdown> {
//
//   String complaintsource = "All";
//   String complaintsourcecode = "-1";
//
//   String? rlyname = "All";
//   String? rlycode = "-1";
//
//   String? rlyname1 = "All";
//   String? rlycode1 = "-1";
//
//   String? consignee = "All";
//   String? consigneecode = "-1";
//
//   String? consignee1 = "All";
//   String? consigneecode1 = "-1";
//
//   String fromdate = "";
//   String todate = "";
//
//   ScrollController listScrollController = ScrollController();
//
//   final _demandnoController = TextEditingController();
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       DateTime frdate = DateTime.now().subtract(const Duration(days: 182));
//       DateTime tdate = DateTime.now();
//       final DateFormat formatter = DateFormat('dd-MM-yyyy');
//       fromdate = formatter.format(frdate);
//       todate = formatter.format(tdate);
//       Provider.of<WarrantyComplaintViewModel>(context, listen: false).getComplaintSourceData(context);
//       Provider.of<WarrantyComplaintViewModel>(context, listen: false).getRailwaylistData(context);
//       Provider.of<WarrantyComplaintViewModel>(context, listen: false).getConsigneeComplaint("","",context);
//
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   @override
//   void setState(VoidCallback fn) {
//     super.setState(fn);
//   }
//
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     LanguageProvider language = Provider.of<LanguageProvider>(context);
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       appBar:  AppBar(
//         backgroundColor: AapoortiConstants.primary,
//         leading: IconButton(
//           splashRadius: 30,
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(language.text('warrantycomsum'), style: TextStyle(color: Colors.white)),
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.home, color: Colors.white, size: 22),
//             onPressed: () {
//               Navigator.of(context).pop();
//               //Feedback.forTap(context);
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 15),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Expanded(
//                       child: FormBuilderDateTimePicker(
//                         name: 'FromDate',
//                         initialDate: DateTime.now().subtract(const Duration(days: 182)),
//                         initialValue: DateTime.now().subtract(const Duration(days: 182)),
//                         inputType: InputType.date,
//                         format: DateFormat('dd-MM-yyyy'),
//                         onChanged: (datevalue){
//                           final DateFormat formatter = DateFormat('dd-MM-yyyy');
//                           fromdate = formatter.format(datevalue!);
//                         },
//                         decoration: InputDecoration(
//                           labelText: language.text('cfrom'),
//                           contentPadding: EdgeInsetsDirectional.all(10),
//                           suffixIcon: Icon(Icons.calendar_month),
//                           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: FormBuilderDateTimePicker(
//                         name: 'ToDate',
//                         initialDate: DateTime.now(),
//                         initialValue: DateTime.now(),
//                         inputType: InputType.date,
//                         format: DateFormat('dd-MM-yyyy'),
//                         onChanged: (datevalue){
//                           final DateFormat formatter = DateFormat('dd-MM-yyyy');
//                           todate = formatter.format(datevalue!);
//                         },
//                         decoration: InputDecoration(
//                           labelText: language.text('cto'),
//                           contentPadding: EdgeInsetsDirectional.all(10),
//                           suffixIcon: Icon(Icons.calendar_month),
//                           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.grey, width: 1)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15),
//                 Text(language.text('nsdrailway'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
//                 SizedBox(height: 8),
//                 Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
//                   if(value.rlydatastatus == RailListDataState.Busy) {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("${language.text('selectrly')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
//                             Container(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2.0,
//                                 ))
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       child: DropdownSearch<String>(
//                         //mode: Mode.DIALOG,
//                         //showSearchBox: true,
//                         //showSelectedItems: true,
//                         selectedItem: value.railway,
//                         popupProps: PopupPropsMultiSelection.menu(
//                           showSearchBox: true,
//                           fit: FlexFit.loose,
//                           showSelectedItems: true,
//                           menuProps: MenuProps(
//                               shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: BorderSide(color: Colors.grey), // You can customize the border color
//                               )
//                           ),
//                         ),
//                         // popupShape: RoundedRectangleBorder(
//                         //   borderRadius: BorderRadius.circular(5.0),
//                         //   side: BorderSide(color: Colors.grey),
//                         // ),
//                         decoratorProps: DropDownDecoratorProps(
//                           decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide.none),
//                               contentPadding: EdgeInsets.only(left: 10))
//                         ),
//                         items: (filter, loadProps) => value.railwaylistData.map((e) {
//                           return e.value.toString().trim();
//                         }).toList(),
//                         onChanged: (changedata) {
//                           value.railwaylistData.forEach((element) {
//                             if(changedata.toString() == element.value.toString()){
//                               value.railway = element.value.toString().trim();
//                               value.rlyCode = element.intcode.toString();
//                               Provider.of<WarrantyComplaintViewModel>(context, listen: false).getConsigneeComplaint(value.rlyCode!, "", context);
//                             }
//                           });
//                         },
//                       ),
//                     );
//                   }
//                 }),
//                 SizedBox(height: 15),
//                 Text(language.text('ccodegencom'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
//                 SizedBox(height: 8),
//                 Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
//                   if(value.condatastatus == ConsigneeComplaintDataState.Busy) {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("${language.text('selectcon')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
//                             Container(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2.0,
//                                 ))
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       child: DropdownSearch<String>(
//                         //mode: Mode.DIALOG,
//                         //showSearchBox: true,
//                         selectedItem: value.consignee.length > 35 ? value.consignee.substring(0, 32) : value.consignee,
//                         //showSelectedItems: true,
//                         popupProps: PopupPropsMultiSelection.menu(
//                           showSearchBox: true,
//                           fit: FlexFit.loose,
//                           showSelectedItems: true,
//                           menuProps: MenuProps(
//                               shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: BorderSide(color: Colors.grey), // You can customize the border color
//                               )
//                           ),
//                         ),
//                         // popupShape: RoundedRectangleBorder(
//                         //   borderRadius: BorderRadius.circular(5.0),
//                         //   side: BorderSide(color: Colors.grey),
//                         // ),
//                         decoratorProps: DropDownDecoratorProps(
//                           decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide.none),
//                               contentPadding: EdgeInsets.only(left: 10))
//                         ),
//                         items: (filter, loadProps) => value.consigneelistData.map((item) {
//                           if(item['value'].toString().trim() == "All"){
//                             return item['value'].toString().trim();
//                           }
//                           else{
//                             return item['intcode'].toString()+"-"+item['value'].toString().trim();
//                           }
//                         }).toList(),
//                         onChanged: (changedata) {
//                           value.consigneelistData.forEach((element) {
//                             if(changedata.toString() == "All"){
//                               consignee = "All";
//                               value.consigneecode = "-1";
//                             }
//                             if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
//                               consignee = changedata.toString();
//                               value.consigneecode = element['intcode'].toString();
//                             }
//                             // if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
//                             //   print("if change value $changedata");
//                             //   consignee = changedata.toString();
//                             //   value.consigneecode = element['intcode'].toString();
//                             //   return;
//                             // }
//                             // else{
//                             //   print("else change value $changedata");
//                             //   consignee = "All";
//                             //   value.consigneecode = "-1";
//                             // }
//                           });
//                         },
//                       ),
//                     );
//                   }
//                 }),
//                 SizedBox(height: 15),
//                 Text(language.text('rlc'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
//                 SizedBox(height: 8),
//                 Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
//                   if(value.rlydatastatus == RailListDataState.Busy) {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("${language.text('selectrly')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
//                             Container(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2.0,
//                                 ))
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       child: DropdownSearch<String>(
//                         //mode: Mode.DIALOG,
//                         //showSearchBox: true,
//                         //showSelectedItems: true,
//                         selectedItem: rlyname,
//                         popupProps: PopupPropsMultiSelection.menu(
//                           showSearchBox: true,
//                           fit: FlexFit.loose,
//                           showSelectedItems: true,
//                           menuProps: MenuProps(
//                               shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: BorderSide(color: Colors.grey), // You can customize the border color
//                               )
//                           ),
//                         ),
//                         // popupShape: RoundedRectangleBorder(
//                         //   borderRadius: BorderRadius.circular(5.0),
//                         //   side: BorderSide(color: Colors.grey),
//                         // ),
//                         // selectedItem: value.railway,
//                         decoratorProps: DropDownDecoratorProps(
//                            decoration: InputDecoration(
//                                enabledBorder: OutlineInputBorder(
//                                    borderRadius: BorderRadius.circular(12),
//                                    borderSide: BorderSide.none),
//                                contentPadding: EdgeInsets.only(left: 10))
//                         ),
//                         items: (filter, loadProps) => value.railwaylistData.map((e) {
//                           return e.value.toString().trim();
//                         }).toList(),
//                         onChanged: (changedata) {
//                           value.railwaylistData.forEach((element) {
//                             if(changedata.toString() == element.value.toString()){
//                               value.railway = element.value.toString().trim();
//                               rlycode1 = element.intcode.toString();
//                               value.rlyCode1 = element.intcode.toString();
//                               Provider.of<WarrantyComplaintViewModel>(context, listen: false).getConsigneeLodgeclaim(value.rlyCode1!, "", context);
//                             }
//                           });
//                         },
//                       ),
//                     );
//                   }
//                 }),
//                 SizedBox(height: 15),
//                 Text(language.text('concodelc'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
//                 SizedBox(height: 8),
//                 Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
//                   if(value.conlodgedatastatus == ConsigneeLodgeDataState.Busy) {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("${language.text('selectcon')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
//                             Container(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2.0,
//                                 ))
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       child: DropdownSearch<String>(
//                         //mode: Mode.DIALOG,
//                         //showSearchBox: true,
//                         //showSelectedItems: true,
//                         selectedItem: consignee1,
//                         popupProps: PopupPropsMultiSelection.menu(
//                           showSearchBox: true,
//                           fit: FlexFit.loose,
//                           showSelectedItems: true,
//                           menuProps: MenuProps(
//                               shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: BorderSide(color: Colors.grey), // You can customize the border color
//                               )
//                           ),
//                         ),
//                         // popupShape: RoundedRectangleBorder(
//                         //   borderRadius: BorderRadius.circular(5.0),
//                         //   side: BorderSide(color: Colors.grey),
//                         // ),
//                         decoratorProps: DropDownDecoratorProps(
//                           decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide.none),
//                               contentPadding: EdgeInsets.only(left: 10))
//                         ),
//                         items: (filter, loadProps) => value.consigneelodgelistData.map((item) {
//                           if(item['value'].toString().trim() == "All"){
//                             return item['value'].toString().trim();
//                           }
//                           else{
//                             return item['intcode'].toString()+"-"+item['value'].toString().trim();
//                           }
//                         }).toList(),
//                         onChanged: (changedata) {
//                           value.consigneelodgelistData.forEach((element) {
//                             if(changedata.toString() == "All"){
//                               consignee = "All";
//                               value.consigneecode = "-1";
//                               consigneecode1 = element['intcode'].toString();
//                             }
//                             if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
//                               consignee = changedata.toString();
//                               value.consigneelodgecode = element['intcode'].toString();
//                               consigneecode1 = element['intcode'].toString();
//                             }
//                             // if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
//                             //   print("if change value $changedata");
//                             //   consignee = changedata.toString();
//                             //   value.consigneecode = element['intcode'].toString();
//                             //   return;
//                             // }
//                             // else{
//                             //   print("else change value $changedata");
//                             //   consignee = "All";
//                             //   value.consigneecode = "-1";
//                             // }
//                           });
//                         },
//                       ),
//                     );
//                   }
//                 }),
//                 SizedBox(height: 15),
//                 Text(language.text('csource'), style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400)),
//                 SizedBox(height: 8),
//                 Consumer<WarrantyComplaintViewModel>(builder: (context, value, child) {
//                   if(value.complaintSourcestate == ComplaintSourceDataState.Busy) {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("${language.text('selectsts')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
//                             Container(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2.0,
//                                 ))
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                           border: Border.all(color: Colors.grey, width: 1)),
//                       child: DropdownSearch<String>(
//                         //mode: Mode.DIALOG,
//                         //showSearchBox: true,
//                         //showSelectedItems: true,
//                         selectedItem: complaintsource,
//                         popupProps: PopupPropsMultiSelection.menu(
//                           showSearchBox: true,
//                           fit: FlexFit.loose,
//                           showSelectedItems: true,
//                           menuProps: MenuProps(
//                               shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 side: BorderSide(color: Colors.grey), // You can customize the border color
//                               )
//                           ),
//                         ),
//                         // popupShape: RoundedRectangleBorder(
//                         //   borderRadius: BorderRadius.circular(5.0),
//                         //   side: BorderSide(color: Colors.grey),
//                         // ),
//                         decoratorProps: DropDownDecoratorProps(
//                           decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide.none),
//                               contentPadding: EdgeInsets.only(left: 10))
//                         ),
//                         items: (filter, loadProps) => value.complaintSourceitemstate.map((e) {
//                           return e.complaintsourcename.toString().trim();
//                         }).toList(),
//                         onChanged: (changedata) {
//                           value.complaintSourceitemstate.forEach((element) {
//                             if(changedata.toString() == element.complaintsourcename.toString()){
//                               complaintsource = element.complaintsourcename.toString().trim();
//                               complaintsourcecode = element.complaintsourcename.toString();
//                             }
//                           });
//                         },
//                       ),
//                     );
//                   }
//                 }),
//                 SizedBox(height: 20),
//                 Consumer<WarrantyComplaintViewModel>(builder: (context, value, child){
//                   return Container(
//                     width: size.width,
//                     padding: EdgeInsets.symmetric(horizontal: 5.0),
//                     height: 45,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Container(
//                           height: 50,
//                           width: 160,
//                           child: OutlinedButton(
//                             style: IRUDMConstants.bStyle(),
//                             onPressed: (){
//                               // print("1. ${value.rlyCode!}");
//                               // print("2. ${value.consigneecode!}");
//                               // print("3. ${rlycode1!}");
//                               // print("4. ${consigneecode1!}");
//                               // print("5. ${complaintsourcecode}");
//                               // print("6. ${fromdate}");
//                               // print("7. ${todate}");
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => WarrantyDeatilsScreen(
//                                   value.rlyCode!,value.consigneecode!, rlycode1!, consigneecode1!,complaintsourcecode, fromdate, todate)));
//                             },
//                             child: Text(language.text('submit'),
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: AapoortiConstants.primary,
//                                 )),
//                           ),
//                         ),
//                         Container(
//                           width: 160,
//                           height: 50,
//                           child: OutlinedButton(
//                             style: IRUDMConstants.bStyle(),
//                             onPressed: () {
//                               Navigator.pushReplacement(
//                                 context, PageRouteBuilder(
//                                 pageBuilder: (_, __, ___) => WarrantyComplaintDropdown(),
//                                 transitionDuration: const Duration(seconds: 0),
//                               ),
//                               );
//                             },
//                             child: Text(
//                                 language.text('reset'),
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: AapoortiConstants.primary,
//                                 )),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ]),
//         ),
//       ),
//     );
//   }
// }

//--------------------------New UI Screen-----------------------

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/view/Warranty_DeatilsScreen.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/view_model/WarrantyCompaint_ViewModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WarrantyComplaintDropdown extends StatefulWidget {
  static const routeName = "/WarrantyComplaintDropdown-screen";

  @override
  State<WarrantyComplaintDropdown> createState() =>
      _WarrantyComplaintDropdownState();
}

class _WarrantyComplaintDropdownState extends State<WarrantyComplaintDropdown> {
 
  DateTime fromDate = DateTime(2024, 10, 22);
  DateTime toDate = DateTime(2025, 4, 22);

  String complaintsource = "All";
  String complaintsourcecode = "-1";

  String? rlyname = "All";
  String? rlycode = "-1";

  String? rlyname1 = "All";
  String? rlycode1 = "-1";

  String? consignee = "All";
  String? consigneecode = "-1";

  String? consignee1 = "All";
  String? consigneecode1 = "-1";

  String fromdate = "";
  String todate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DateTime frdate = DateTime.now().subtract(const Duration(days: 182));
      DateTime tdate = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      fromdate = formatter.format(frdate);
      todate = formatter.format(tdate);
      Provider.of<WarrantyComplaintViewModel>(context, listen: false)
          .getComplaintSourceData(context);
      Provider.of<WarrantyComplaintViewModel>(context, listen: false)
          .getRailwaylistData(context);
      Provider.of<WarrantyComplaintViewModel>(context, listen: false)
          .getConsigneeComplaint("", "", context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Simple date formatter
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(language),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateRangeSelection(),
                    const SizedBox(height: 24),
                    Consumer<WarrantyComplaintViewModel>(
                        builder: (context, value, child) {
                      if (value.rlydatastatus == RailListDataState.Busy) {
                        return Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18.0)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${language.text('selectrly')}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.start),
                                Container(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ))
                              ],
                            ),
                          ),
                        );
                      } else {
                        return DropdownSearch<String>(
                          selectedItem: value.railway,
                          popupProps: PopupPropsMultiSelection.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                          ),
                          decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                  label: Text(language.text('nsdrailway'),
                                      style: TextStyle(color: Colors.blue)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(
                                          width: 0.7, color: Colors.blue)),
                                  contentPadding: EdgeInsets.only(left: 10))),
                          items: (filter, loadProps) =>
                              value.railwaylistData.map((e) {
                            return e.value.toString().trim();
                          }).toList(),
                          onChanged: (changedata) {
                            value.railwaylistData.forEach((element) {
                              if (changedata.toString() ==
                                  element.value.toString()) {
                                value.railway = element.value.toString().trim();
                                value.rlyCode = element.intcode.toString();
                                Provider.of<WarrantyComplaintViewModel>(context,
                                        listen: false)
                                    .getConsigneeComplaint(
                                        value.rlyCode!, "", context);
                              }
                            });
                          },
                        );
                      }
                    }),
                    // _buildDropdownField('Railway', 'IREPS-TESTING'),
                    const SizedBox(height: 24),
                    Consumer<WarrantyComplaintViewModel>(
                        builder: (context, value, child) {
                      if (value.condatastatus ==
                          ConsigneeComplaintDataState.Busy) {
                        return Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${language.text('selectcon')}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.start),
                                Container(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ))
                              ],
                            ),
                          ),
                        );
                      } else {
                        return DropdownSearch<String>(
                          selectedItem: value.consignee.length > 35
                              ? value.consignee.substring(0, 32)
                              : value.consignee,
                          //showSelectedItems: true,
                          popupProps: PopupPropsMultiSelection.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                            menuProps: MenuProps(
                                shape: RoundedRectangleBorder(
                              // Custom shape without the right side scroll line
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: Colors
                                      .grey), // You can customize the border color
                            )),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                  label: Text(language.text('ccodegencom'), style: TextStyle(color:Colors.blue)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(width: 0.7, color: Colors.blue)),
                                  contentPadding: EdgeInsets.only(left: 10))),
                          items: (filter, loadProps) =>
                              value.consigneelistData.map((item) {
                            if (item['value'].toString().trim() == "All") {
                              return item['value'].toString().trim();
                            } else {
                              return item['intcode'].toString() +
                                  "-" +
                                  item['value'].toString().trim();
                            }
                          }).toList(),
                          onChanged: (changedata) {
                            value.consigneelistData.forEach((element) {
                              if (changedata.toString() == "All") {
                                consignee = "All";
                                value.consigneecode = "-1";
                              }
                              if (changedata.toString() ==
                                  element['intcode'].toString() +
                                      "-" +
                                      element['value'].toString()) {
                                consignee = changedata.toString();
                                value.consigneecode =
                                    element['intcode'].toString();
                              }
                              // if(changedata.toString() == element['intcode'].toString()+"-"+element['value'].toString()){
                              //   print("if change value $changedata");
                              //   consignee = changedata.toString();
                              //   value.consigneecode = element['intcode'].toString();
                              //   return;
                              // }
                              // else{
                              //   print("else change value $changedata");
                              //   consignee = "All";
                              //   value.consigneecode = "-1";
                              // }
                            });
                          },
                        );
                      }
                    }),
                    // _buildDropdownField('Consignee Code Generating Complaints', '36640-SSE-I/PS/NDLS'),
                    const SizedBox(height: 24),
                    Consumer<WarrantyComplaintViewModel>(
                        builder: (context, value, child) {
                      if (value.rlydatastatus == RailListDataState.Busy) {
                        return Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${language.text('selectrly')}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.start),
                                Container(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ))
                              ],
                            ),
                          ),
                        );
                      } else {
                        return DropdownSearch<String>(
                          selectedItem: rlyname,
                          popupProps: PopupPropsMultiSelection.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                            menuProps: MenuProps(
                                shape: RoundedRectangleBorder(
                              // Custom shape without the right side scroll line
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: Colors
                                      .grey), // You can customize the border color
                            )),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                  label: Text(
                                    language.text('rlc'),
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(
                                          width: 0.7, color: Colors.blue)),
                                  contentPadding: EdgeInsets.only(left: 10))),
                          items: (filter, loadProps) =>
                              value.railwaylistData.map((e) {
                            return e.value.toString().trim();
                          }).toList(),
                          onChanged: (changedata) {
                            value.railwaylistData.forEach((element) {
                              if (changedata.toString() ==
                                  element.value.toString()) {
                                value.railway = element.value.toString().trim();
                                rlycode1 = element.intcode.toString();
                                value.rlyCode1 = element.intcode.toString();
                                Provider.of<WarrantyComplaintViewModel>(context,
                                        listen: false)
                                    .getConsigneeLodgeclaim(
                                        value.rlyCode1!, "", context);
                              }
                            });
                          },
                        );
                      }
                    }),
                    //_buildDropdownField('Railway to Lodge Claim', 'All'),
                    const SizedBox(height: 24),
                    Consumer<WarrantyComplaintViewModel>(
                        builder: (context, value, child) {
                      if (value.conlodgedatastatus ==
                          ConsigneeLodgeDataState.Busy) {
                        return Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${language.text('selectcon')}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.start),
                                Container(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ))
                              ],
                            ),
                          ),
                        );
                      } else {
                        return DropdownSearch<String>(
                          selectedItem: consignee1,
                          popupProps: PopupPropsMultiSelection.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                            menuProps: MenuProps(
                                shape: RoundedRectangleBorder(
                              // Custom shape without the right side scroll line
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: Colors
                                      .grey), // You can customize the border color
                            )),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                  label: Text(
                                    language.text('concodelc'),
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 0.7)),
                                  contentPadding: EdgeInsets.only(left: 10))),
                          items: (filter, loadProps) =>
                              value.consigneelodgelistData.map((item) {
                            if (item['value'].toString().trim() == "All") {
                              return item['value'].toString().trim();
                            } else {
                              return item['intcode'].toString() +
                                  "-" +
                                  item['value'].toString().trim();
                            }
                          }).toList(),
                          onChanged: (changedata) {
                            value.consigneelodgelistData.forEach((element) {
                              if (changedata.toString() == "All") {
                                consignee = "All";
                                value.consigneecode = "-1";
                                consigneecode1 = element['intcode'].toString();
                              }
                              if (changedata.toString() ==
                                  element['intcode'].toString() +
                                      "-" +
                                      element['value'].toString()) {
                                consignee = changedata.toString();
                                value.consigneelodgecode =
                                    element['intcode'].toString();
                                consigneecode1 = element['intcode'].toString();
                              }
                            });
                          },
                        );
                      }
                    }),
                    //_buildDropdownField('Consignee Code to Lodge Claim', 'All'),
                    const SizedBox(height: 24),
                    Consumer<WarrantyComplaintViewModel>(
                        builder: (context, value, child) {
                      if (value.complaintSourcestate ==
                          ComplaintSourceDataState.Busy) {
                        return Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${language.text('selectsts')}",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.start),
                                Container(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ))
                              ],
                            ),
                          ),
                        );
                      } else {
                        return DropdownSearch<String>(
                          selectedItem: complaintsource,
                          popupProps: PopupPropsMultiSelection.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                            menuProps: MenuProps(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.grey))),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                  label: Text(language.text('csource'),
                                      style: TextStyle(color: Colors.blue)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 0.7)),
                                  contentPadding: EdgeInsets.only(left: 10))),
                          items: (filter, loadProps) =>
                              value.complaintSourceitemstate.map((e) {
                            return e.complaintsourcename.toString().trim();
                          }).toList(),
                          onChanged: (changedata) {
                            value.complaintSourceitemstate.forEach((element) {
                              if (changedata.toString() ==
                                  element.complaintsourcename.toString()) {
                                complaintsource = element.complaintsourcename
                                    .toString()
                                    .trim();
                                complaintsourcecode =
                                    element.complaintsourcename.toString();
                              }
                            });
                          },
                        );
                      }
                    }),
                    //_buildDropdownField('Complaint Source', 'All'),
                    const SizedBox(height: 32),
                    _buildActionButtons(language),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(LanguageProvider language) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: AppBar(
        title: Text(
          language.text('warrantycomsum'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {},
            padding: const EdgeInsets.all(8.0),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                'Complaints From',
                fromDate,
                (date) {
                  setState(() {
                    fromDate = date;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                'Complaints To',
                toDate,
                (date) {
                  setState(() {
                    toDate = date;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label, DateTime initialDate, Function(DateTime) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue[700],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2026),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.blue[800]!,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(initialDate),
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(Icons.calendar_today, color: Colors.blue[800], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String initialValue) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.blue[100]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: initialValue,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue[800]),
              items: [initialValue].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
          ),
        ),
        Positioned(
          left: 12,
          top: -10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.white,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.blue[700],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(LanguageProvider language) {
    return Row(
      children: [
        Expanded(
          child: Consumer<WarrantyComplaintViewModel>(
              builder: (context, value, child) {
            return ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WarrantyDeatilsScreen(
                            value.rlyCode!,
                            value.consigneecode!,
                            rlycode1!,
                            consigneecode1!,
                            complaintsourcecode,
                            fromdate,
                            todate)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              child: Text(
                language.text('submit'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => WarrantyComplaintDropdown(),
                      transitionDuration: const Duration(seconds: 0)));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue[800],
              side: BorderSide(color: Colors.blue[800]!),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              language.text('reset'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
