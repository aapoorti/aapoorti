// import 'package:flutter/material.dart';
// import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// String? url;
//
// enum ConfirmAction { AGREE, DISAGREE }
//
// _launchURL(String url) async {
//
//   // const _url = 'https://flutter.dev';
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
//
// Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
//   return showDialog<ConfirmAction>(
//     context: context,
//     barrierDismissible: false, // user must tap button for close dialog!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10.0))
//         ),
//         title: Text('Alert!'),
//         content: const Text(
//             'You are being redirected to an external Link/ Website.'),
//         actions: <Widget>[
//           MaterialButton(
//             child: const Text('DISAGREE', style: TextStyle(color: Color(0xFF00695C),),),
//             onPressed: () {
//               Navigator.of(context).pop(ConfirmAction.DISAGREE);
//             },
//           ),
//           MaterialButton(
//             child: const Text('AGREE', style: TextStyle(color: Color(0xFF00695C),),),
//             onPressed: () {
//               Navigator.of(context).pop(ConfirmAction.AGREE);
//               _launchURL(url!);
//             },
//           )
//         ],
//       );
//     },
//   );
// }
//
// class Approvedvendors extends StatelessWidget
// {
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.of(context, rootNavigator: true).pop();
//         return false;
//       },
//       child: Scaffold(
//         appBar: AppBar( iconTheme: IconThemeData(color: Colors.white),
//             backgroundColor: AapoortiConstants.primary,
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                     child: Text('Approved Vendors', style:TextStyle(
//                         color: Colors.white
//                     ))),
//                 IconButton(
//                   icon: Icon(
//                     Icons.home,color: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
//                     //Navigator.of(context, rootNavigator: true).pop();
//                   },
//                 ),
//               ],
//             )),
//         body: Material(
//             color: Colors.grey[300],
//             child: ListView(
//               children: <Widget>[
//                 Card(
//                   color: Colors.white,
//                   surfaceTintColor: Colors.transparent,
//                   child: Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Column(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
//                             SizedBox(width:8),
//                             Expanded(
//                               child: InkWell(
//                                 child: Text("Research, Design and Standards Organisation (RDSO), Lucknow",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
//                                 onTap: (){
//                                   url ="http://www.rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269";
//                                   _asyncConfirmDialog(context);
//                                 },
//                               ),
//                             )
//                           ],
//                         ),
//                         SizedBox(height: 10.0),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Padding(padding: EdgeInsets.only(left: 0.0)),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,770";
//                                 },
//                                 padding: EdgeInsets.all(0.0),
//                                 child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//                                 Text("Civil",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Padding(padding: EdgeInsets.only(left: 0.0)),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,771";
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//                                 Text("QA(Electrical)",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Padding(padding: EdgeInsets.only(left: 0.0)),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,772";
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//
//                                 Text("Mechanical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//
//                           ],
//
//                         ),
//                         //Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
//                         Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: <Widget>[
//                             Padding(padding: EdgeInsets.only(left: 20)),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,826";
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30)),
//
//                                 Text("QA(S and T)",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                                 Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0)),
//                               ],
//                             ),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://rdso.indianrailways.gov.in/index.jsp?lang=0";
//
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//
//                                 Text("Works",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                                 Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0)),
//                               ],
//                             ),
//
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.white,
//                   surfaceTintColor: Colors.transparent,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
//                             SizedBox(width:8),
//                             InkWell(
//                               child: Text("Integral Coach Factory (ICF), Perambur",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
//                               onTap: (){
//                                 url ="http://icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295";
//                                 _asyncConfirmDialog(context);
//
//                               },
//                             ),
//                           ],
//                         ),
//                         Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 15.0)),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://www.icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,329,387";
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//                                 Text("Mechanical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://www.icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,329,384";
//
//                                 },
//                                 padding: EdgeInsets.all(0.0),
//                                 child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//                                 Text("Paints",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://www.icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,330,729";
//
//                                 },
//                                 padding: EdgeInsets.all(0.0),
//                                 child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//                                 Text("Electrical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//
//                           ],
//
//                         ),
//                         Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.white,
//                   surfaceTintColor: Colors.transparent,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
//                             SizedBox(width:8),
//                             InkWell(
//                               child: Text("Rail Coach Factory(RCF),Kapurthala",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
//                               onTap: (){
//                                 url ="http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,562,567";
//                                 _asyncConfirmDialog(context);
//
//                               },
//                             ),
//                             // new Text("   Rail Coach Factory(RCF),Kapurthala",style: TextStyle(fontSize:15.0,color: Colors.indigo[900],fontWeight: FontWeight.bold),)
//                           ],
//                         ),
//                         Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 15.0)),
//                         Row(
//                           children: <Widget>[
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,562,563";
//
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//
//                                 Text("Mechanical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Padding(padding: EdgeInsets.only(left:27.0)),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,562,564";
//
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//
//                                 Text("Electrical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Padding(padding: EdgeInsets.only(left:27.0)),
//                           ],
//
//                         ),
//                         Padding(padding: EdgeInsets.all(8.0)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.white,
//                   surfaceTintColor: Colors.transparent,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
//                             SizedBox(width:8),
//                             Expanded(
//                               child: InkWell(
//                                 child: Text("Diesel Loco Modernization Works (DMW), Patiala",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
//                                 onTap: (){
//                                   url ="http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376";
//                                   _asyncConfirmDialog(context);
//
//                                 },
//                               ),
//                             )
//                           ],
//                         ),
//                         Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 15.0)),
//                         Row(
//                           children: <Widget>[
//                             //Padding(padding: new EdgeInsets.only(left:27.0)),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,557";
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//                                 Text("Phase 1",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Padding(padding:EdgeInsets.only(left:27.0)),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,558";
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//                                 Text("Phase 2",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Padding(padding:EdgeInsets.only(left:27.0)),
//                           ],
//
//                         ),
//                         Padding(padding: EdgeInsets.all(8.0)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Card(
//                   color: Colors.white,
//                   surfaceTintColor: Colors.transparent,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Image.asset('assets/railway.png',width: 35.0,height: 35.0),
//                             SizedBox(width:8),
//                             Expanded(
//                               child: InkWell(
//                                 child: Text("Central Organisation for Railway Electrification (CORE),Allahabad",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
//                                 onTap: (){
//                                   url ="http://www.core.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376";
//                                   _asyncConfirmDialog(context);
//
//                                 },
//                               ),
//                             )
//                           ],
//                         ),
//                         Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 15.0)),
//                         Row(
//                           children: <Widget>[
//                             //Padding(padding: EdgeInsets.only(left:27.0)),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://www.core.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,444";
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//                                 // new  Image.asset('assets/zone_coloured.png',width: 45.0,height: 35.0,),
//                                 Text("Electrical",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Padding(padding: EdgeInsets.only(left:27.0)),
//                             Column(
//                               children: <Widget>[
//                                 MaterialButton( onPressed:(){
//                                   _asyncConfirmDialog(context);
//                                   url="http://www.core.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,445";
//                                 },
//                                     padding: EdgeInsets.all(0.0),
//                                     child: Image.asset('assets/web.jpg',width: 30,height: 30,)),
//                                 Text("Stores",style: TextStyle(fontSize:15.0,color: Colors.black,)),
//                               ],
//                             ),
//                             Padding(padding: EdgeInsets.only(left:27.0)),
//                           ],
//
//                         ),
//                         Padding(padding: EdgeInsets.all(8.0)),
//                       ],
//                     ),
//                   ),
//
//                 ),
//                 Card(
//                   color: Colors.white,
//                   surfaceTintColor: Colors.transparent,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Image.asset('assets/railway.png',width: 35.0,height: 35.0),
//                             SizedBox(width:8),
//                             InkWell(
//                               child: Text("Diesel Locomotive Works(DLW), Varanasi",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
//                               onTap: (){
//                                 url ="http://www.dlw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,714,743";
//                                 _asyncConfirmDialog(context);
//
//                               },
//                             ),
//                             // new Text("   Diesel Locomotive Works(DLW), Varanasi",style: TextStyle(fontSize:15.0,color: Colors.indigo[900],fontWeight: FontWeight.bold),)
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),),
//                 Card(
//                   color: Colors.white,
//                   surfaceTintColor: Colors.transparent,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Image.asset('assets/railway.png',width: 35.0,height: 35.0,),
//                             SizedBox(width:8),
//                             Expanded(
//                               child: InkWell(
//                                 child: Text("Chittaranjan Locomotive Works (CLW), Chittaranjan",style: TextStyle(fontSize:15.0,color: Colors.teal[900],fontWeight: FontWeight.bold),),
//                                 onTap: (){
//                                   url ="http://www.clw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376";
//                                   _asyncConfirmDialog(context);
//
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         ],
//                     ),
//                   ),
//                 ),
//               ],
//             )
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Enum for confirmation action
enum ConfirmAction { AGREE, DISAGREE }

class Approvedvendors extends StatefulWidget {
  const Approvedvendors({super.key});

  @override
  State<Approvedvendors> createState() => _ApprovedvendorsState();
}

class _ApprovedvendorsState extends State<Approvedvendors> {
  // Sample data for vendors with URLs
  final List<VendorData> vendors = [
    VendorData(
      name: 'Research, Design and Standards Organisation (RDSO), Lucknow',
      url: 'http://www.rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269',
      departments: [
        DepartmentData(
          name: 'Civil',
          url: 'http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,770',
        ),
        DepartmentData(
          name: 'QA(Electrical)',
          url: 'http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,771',
        ),
        DepartmentData(
          name: 'Mechanical',
          url: 'http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,772',
        ),
        DepartmentData(
          name: 'QA(S and T)',
          url: 'http://rdso.indianrailways.gov.in/view_section.jsp?lang=0&id=0,5,269,826',
        ),
        DepartmentData(
          name: 'Works',
          url: 'http://rdso.indianrailways.gov.in/index.jsp?lang=0',
        ),
      ],
      departmentRows: [
        ['Civil', 'QA(Electrical)', 'Mechanical'],
        ['QA(S and T)', 'Works'],
      ],
    ),
    VendorData(
      name: 'Integral Coach Factory (ICF), Perambur',
      url: 'http://icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295',
      departments: [
        DepartmentData(
          name: 'Mechanical',
          url: 'http://www.icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,329,387',
        ),
        DepartmentData(
          name: 'Paints',
          url: 'http://www.icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,329,384',
        ),
        DepartmentData(
          name: 'Electrical',
          url: 'http://www.icf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,295,330,729',
        ),
      ],
      departmentRows: [
        ['Mechanical', 'Paints', 'Electrical'],
      ],
    ),
    VendorData(
      name: 'Rail Coach Factory(RCF),Kapurthala',
      url: 'http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,562,567',
      departments: [
        DepartmentData(
          name: 'Mechanical',
          url: 'http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,562,563',
        ),
        DepartmentData(
          name: 'Electrical',
          url: 'http://www.rcf.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,562,564',
        ),
      ],
      departmentRows: [
        ['Mechanical', 'Electrical'],
      ],
    ),
    VendorData(
      name: 'Diesel Loco Modernization Works (DMW), Patiala',
      url: 'http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376',
      departments: [
        DepartmentData(
          name: 'Phase 1',
          url: 'http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,557',
        ),
        DepartmentData(
          name: 'Phase 2',
          url: 'http://dmw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,558',
        ),
      ],
      departmentRows: [
        ['Phase 1', 'Phase 2'],
      ],
    ),
    VendorData(
      name: 'Central Organisation for Railway Electrification (CORE),Allahabad',
      url: 'http://www.core.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376',
      departments: [
        DepartmentData(
          name: 'Electrical',
          url: 'http://www.core.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,444',
        ),
        DepartmentData(
          name: 'Stores',
          url: 'http://www.core.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376,445',
        ),
      ],
      departmentRows: [
        ['Electrical', 'Stores'],
      ],
    ),
    VendorData(
      name: 'Banaras Locomotive Works (BLW), Varanasi',
      url: 'http://www.blw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,714,743',
      departments: [],
      departmentRows: [],
    ),
    VendorData(
      name: 'Chittaranjan Locomotive Works (CLW), Chittaranjan',
      url: 'http://www.clw.indianrailways.gov.in/view_section.jsp?lang=0&id=0,298,376',
      departments: [],
      departmentRows: [],
    ),
  ];

  // Function to launch URLs with confirmation dialog
  Future<void> _launchURLWithConfirmation(BuildContext context, String url) async {
    final action = await _showConfirmDialog(context);
    if (action == ConfirmAction.AGREE) {
      _launchURL(url);
    }
  }

  // Function to show confirmation dialog
  Future<ConfirmAction?> _showConfirmDialog(BuildContext context) async {
    final theme = Theme.of(context);

    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: 280, // Reduced from 300
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12), // Reduced padding
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button at top right
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(ConfirmAction.DISAGREE);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18, // Reduced from 20
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                // Icon in the middle
                Container(
                  padding: const EdgeInsets.all(8), // Reduced from 10
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.public_rounded,
                    size: 28, // Reduced from 32
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 12), // Reduced from 16

                // Title in the middle
                Text(
                  'External Link',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16, // Reduced from 18
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 8), // Reduced from 12

                // Message
                Text(
                  'You are being redirected to an external website.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13, // Reduced from 14
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 16), // Reduced from 24

                // Buttons in the middle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(ConfirmAction.DISAGREE);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced padding
                      ),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          fontSize: 13, // Added font size
                          color: theme.colorScheme.primary.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6), // Reduced from 8
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(ConfirmAction.AGREE);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Reduced from 8
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced padding
                      ),
                      child: const Text('CONTINUE', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          title: const Text(
            'Approved Vendors',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.home_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
              },
            ),
          ],
          elevation: 0,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: vendors.length,
          itemBuilder: (context, index) {
            return VendorCard(
              vendor: vendors[index],
              onVendorTap: (url) => _launchURLWithConfirmation(context, url),
              onDepartmentTap: (url) => _launchURLWithConfirmation(context, url),
            );
          },
        ),
      ),
    );
  }
}

class DepartmentData {
  final String name;
  final String url;

  DepartmentData({
    required this.name,
    required this.url,
  });
}

class VendorData {
  final String name;
  final String url;
  final List<DepartmentData> departments;
  final List<List<String>> departmentRows;

  VendorData({
    required this.name,
    required this.url,
    required this.departments,
    required this.departmentRows,
  });

  // Helper method to get department URL by name
  String getDepartmentUrl(String departmentName) {
    final department = departments.firstWhere(
          (dept) => dept.name == departmentName,
      orElse: () => DepartmentData(name: departmentName, url: ''),
    );
    return department.url;
  }
}

class VendorCard extends StatelessWidget {
  final VendorData vendor;
  final Function(String) onVendorTap;
  final Function(String) onDepartmentTap;

  const VendorCard({
    super.key,
    required this.vendor,
    required this.onVendorTap,
    required this.onDepartmentTap,
  });

  // Get gradient colors for department icons with lighter, more theme-matching colors
  List<Color> _getGradientColors(String department) {
    switch (department.toLowerCase()) {
      case 'mechanical':
        return [const Color(0xFF90CAF9), const Color(0xFF64B5F6)]; // Lighter blue
      case 'electrical':
        return [const Color(0xFF80DEEA), const Color(0xFF4DD0E1)]; // Lighter teal
      case 'civil':
        return [const Color(0xFFB0BEC5), const Color(0xFF90A4AE)]; // Lighter blueGrey
      case 'paints':
        return [const Color(0xFFFFAB91), const Color(0xFFFF8A65)]; // Lighter coral
      case 'works':
        return [const Color(0xFFFFE082), const Color(0xFFFFD54F)]; // Lighter amber
      case 'stores':
        return [const Color(0xFFCE93D8), const Color(0xFFBA68C8)]; // Lighter purple
      case 'phase 1':
        return [const Color(0xFFA5D6A7), const Color(0xFF81C784)]; // Lighter green
      case 'phase 2':
        return [const Color(0xFF90CAF9), const Color(0xFF64B5F6)]; // Lighter blue
      case 'qa(electrical)':
      case 'qa(s and t)':
        return [const Color(0xFFB39DDB), const Color(0xFF9575CD)]; // Lighter deep purple
      default:
        return [const Color(0xFFCFD8DC), const Color(0xFFB0BEC5)]; // Lighter blueGrey
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with new blue vertical line
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blue vertical line as provided
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),

                // Vendor name text
                Expanded(
                  child: InkWell(
                    onTap: () => onVendorTap(vendor.url),
                    child: Text(
                      vendor.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Department rows with centered layout
            if (vendor.departmentRows.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var rowDepts in vendor.departmentRows)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 10),
                      child: _buildDepartmentRow(rowDepts, theme),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Create a separate method to handle department rows with centered layout
  Widget _buildDepartmentRow(List<String> departments, ThemeData theme) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 10,
        children: departments.map((department) {
          final gradientColors = _getGradientColors(department);
          final departmentUrl = vendor.getDepartmentUrl(department);

          return SizedBox(
            width: 62,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minWidth: 0,
                  onPressed: departmentUrl.isNotEmpty
                      ? () => onDepartmentTap(departmentUrl)
                      : null,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // Increased radius for softer look
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors.first.withOpacity(0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconForDepartment(department),
                        size: 22,
                        color: Colors.white, // Keeping white for good contrast
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  department,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForDepartment(String department) {
    // Match icons to departments
    switch (department.toLowerCase()) {
      case 'mechanical':
        return Icons.precision_manufacturing_rounded;
      case 'electrical':
        return Icons.electrical_services_rounded;
      case 'civil':
        return Icons.architecture_rounded;
      case 'paints':
        return Icons.format_paint_rounded;
      case 'works':
        return Icons.build_rounded;
      case 'stores':
        return Icons.inventory_2_rounded;
      case 'phase 1':
        return Icons.looks_one_rounded;
      case 'phase 2':
        return Icons.looks_two_rounded;
      case 'qa(electrical)':
      case 'qa(s and t)':
        return Icons.verified_rounded;
      default:
        return Icons.article_rounded;
    }
  }
}