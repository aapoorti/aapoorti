// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_app/common/AapoortiConstants.dart';
// import 'package:flutter_app/home/tender/liveupra/LivUpcomRA.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart';
// import 'package:http/testing.dart';

// void main() {
//   group('check no data  if no data from up and liv RA api', () {
//     Client createHttpClient = createMockImageHttpClient();
//     testWidgets('Atleast one item in list', (WidgetTester tester) async {
//       await tester.pumpWidget(MaterialApp(home: Scaffold(body: LivUpcomRA())));
//       await tester.pump(Duration(seconds: 5));
//       expect(find.byType(Center), findsNWidgets(3));
//     });
//   });
// }

// const String LivRAurl =
//     "https://ireps.gov.in/Aapoorti/ServiceCall/Auction/LiveRA";
// const String UpRAurl =
//     "https://ireps.gov.in/Aapoorti/ServiceCall/Auction/UpcomingRA";
// List<dynamic> dummyData = [
//   {
//     "RLY_DEPT": "SOUTH EAST CENTRAL RLY/CAO-C-HQ-ENGINEERING",
//     "TENDER_NUMBER": "CEC-BSP-21-22-26",
//     "TENDER_TITLE": "Construction of Tunnel between",
//     "WORK_AREA": "Works",
//     "RA_START_DT": "18/04/2022 10:00",
//     "RA_CLOSE_DT": "19/04/2022 10:00",
//     "NIT_PDF_URL":
//         "https://www.ireps.gov.in/ireps/works/pdfdocs/022022/61465138/viewNitPdf_3721657.pdf",
//     "ATTACH_DOCS":
//         "Tender doc CEC BSP 21 22 26,/ireps/upload/files/61465138/Tenderdoc21-22-26.pdf",
//     "CORRI_DETAILS": "NA",
//     "STATUS": "Live"
//   }
// ];
// Client createMockImageHttpClient() => new MockClient((request) {
//       switch (request.url.path) {
//         case LivRAurl:
//           return new Future<Response>.value(
//               new Response(dummyData.toString(), 200, request: request));
//         case UpRAurl:
//           return new Future<Response>.value(
//               new Response(dummyData.toString(), 200, request: request));
//         default:
//           return new Future<Response>.value(new Response('', 404));
//       }
//     });
