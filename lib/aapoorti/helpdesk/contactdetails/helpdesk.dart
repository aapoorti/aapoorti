import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/provider/aapoorti_language_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Help extends StatelessWidget {
  String phone_IREPS = 'tel:+91-11-23761525',
      phone_SBIePAY = 'tel:+91-22-27523816',
      phone_SBIePAY1 = 'tel:+91-22-27570026',
      phone_SBInetBanking1 = 'tel:+91-11-27566066',
      phone_SBInetBanking2 = 'tel:+91-22-27566067',
      phone_SBInetBanking3 = 'tel:+91-22-27560137',
      phone_SBInetBanking4 = 'tel:+91-22-27566501',
      email_SBIePAY = 'sbiepay@sbi.co.in',
      email_SBInetbanking = "inb.cinb@sbi.co.in";
  String phnl = "", url = "";

  _callPhone(phn1) async {
    if (await canLaunch(phn1)) {
      await launch(phn1);
    } else {
      throw 'Could not Call Phone';
    }
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  _launchmailURL(String toMailId) async {
    var url = 'mailto:$toMailId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchURL() async {
    const url = 'https://www.ireps.gov.in/eps/helpdesk/querisAfterLogin.do?param=showPage';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the URL';
    }
  }


  @override
  Widget build(BuildContext context) {
    AapoortiLanguageProvider language = Provider.of<AapoortiLanguageProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AapoortiConstants.primary, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image(image: AssetImage("images/ic_launcher_app3.png"), height: 80, width: 80),
                    // SizedBox(height: 10),
                    //Text('For Any Query/Suggestions/Support',style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.underline)),
                    //SizedBox(height: 10),
                    Text('1. ${language.text('callus')}::',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, decoration: TextDecoration.none)),
                    SizedBox(height: 10),
                    //Text("For Any Query/Suggestions/Supports"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/phone_icon.png', height: 32, width: 32),
                            SizedBox(width: 10),
                            Text('011-41385200', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            //_callPhone('011-23761525');
                            makePhoneCall('011-41385200');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.phone, size: 25),
                              Text(language.text('callnow'), style: TextStyle(fontSize: 15, fontWeight:  FontWeight.w600))
                            ],
                          ),
                        )
                      ],
                    ),
                    // SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     RichText(
                    //       textAlign: TextAlign.start,
                    //       text: TextSpan(
                    //         text: 'Email :: ',
                    //         style: TextStyle(fontSize: 16, color: Colors.black),
                    //         children: <TextSpan>[
                    //           TextSpan(text: 'udm@cris.org.in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    //         ],
                    //       ),
                    //     ),
                    //     //Text("Email :: udm@cris.org.in"),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         InkWell(
                    //           onTap: (){
                    //             //sendEmail('udm@cris.org.in');
                    //           },
                    //           child: Icon(Icons.email, size: 25),
                    //         ),
                    //         Text('Email Now', style: TextStyle(fontSize: 15, fontWeight:  FontWeight.w600))
                    //       ],
                    //     )
                    //
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AapoortiConstants.primary, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('2. ${language.text('submitq')}::',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, decoration: TextDecoration.none)),
                      SizedBox(height: 10),
                      //Text("For Any Query/Suggestions/Supports"),
                      ElevatedButton(
                          onPressed: (){
                            _launchURL();
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen()));
                          },
                          child: Text(language.text('clickhere'), style: TextStyle(color: Colors.white, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[700]!,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder( // Shape of the button
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5, // Shadow depth
                            side: BorderSide(color: Colors.grey, width: 1),
                          ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
//     return ListView(
//       children: <Widget>[
//         Padding(padding: EdgeInsets.all(2.0)),
//         Card(
//           child:Column(
//             children: <Widget>[
//               Text(
//                 'Check Request Status',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500),
//               ),
//               Padding(padding: EdgeInsets.only(bottom: 10.0)),
//               Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     MaterialButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, "/View_Reply_to_Question");
//                         },
//                         padding: EdgeInsets.all(0.0),
//                         child: Image.asset(
//                           'assets/web.png',
//                           width: 50,
//                           height: 70,
//                         )),
//                     MaterialButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, "/helpdesk_vendor");
//                         },
//                         padding: EdgeInsets.all(0.0),
//                         child: Image.asset(
//                           'assets/vendor.png',
//                           width: 50,
//                           height: 70,
//                         )),
//                   ],
//                 ),
//               ),
//               Center(
//                   child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Text('           View Reply', style: TextStyle(color: Colors.black)),
//                   Text('         Vendor Registration Status', style: TextStyle(color: Colors.black),
//                   ),
//                 ],
//               )),
//               Center(
//                   child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Padding(padding: EdgeInsets.only(left: 2)),
//                   Text('To Question          \n', style: TextStyle(color: Colors.black)),
//                   Padding(padding: EdgeInsets.only(bottom: 20)),
//                   Text('(For Firms)\n', style: TextStyle(color: Colors.black)),
//                   Padding(padding: EdgeInsets.only(bottom: 20, left: 20.0)),
//                 ],
//               )),
//             ],
//           ),
//         ),
//         Padding(padding: EdgeInsets.only(top: 2)),
//         InkWell(
//             child: Card(
//               child: Column(
//                 children: <Widget>[
//                   Text('Report A Problem',
//                     style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         MaterialButton(
//                             onPressed: () {
//                               Navigator.pushNamed(context, "/report");
//                             },
//                             padding: EdgeInsets.all(0.0),
//                             child: Image.asset(
//                               'assets/query.jpg',
//                               width: 50,
//                               height: 70,
//                             )),
//                       ],
//                     ),
//                   ),
//
//                   new Center(
//                       child: new Row(
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(left: 10),
//                       ),
//                       Flexible(
//                         child: RichText(
//                           text: TextSpan(
//                             text: 'Note: ',
//                             style: TextStyle(
//                               color: Colors.red,
//                             ),
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text:
//                                     'This feature is only to report issues related to the \n           Mobile App (Aapoorti)\n',
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                       //Text('Note: ',style: new TextStyle(color: Colors.red),textAlign: TextAlign.left,),
//
//                       //new  Text('This feature is only to report issues related to the ',style: new TextStyle(color: Colors.black),textAlign: TextAlign.left,),
//                     ],
//                   )),
//                   /* new Center(
//                         child: new Row(
//
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//
//
//                             new  Text('Mobile App (Aapoorti)\n',style: new TextStyle(color: Colors.black,),),
//
//
//
//
//                           ],)
//
//
//                     ),*/
//                 ],
//               ),
//             ),
//             onTap: () {
//               Navigator.pushNamed(context, "/report");
//             }),
//         Padding(padding: EdgeInsets.only(top: 2)),
// //         Card(
// //           child: Column(
// //             children: <Widget>[
// //               Text(
// //                 'Helpdesk Contact Details',
// //                 style: TextStyle(
// //                     color: Colors.black,
// //                     fontWeight: FontWeight.w500,
// //                     fontSize: 15.0),
// //               ),
// //               Container(
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(
// //                             padding: EdgeInsets.only(left: 10.0, top: 40.0)),
// //                         Text(
// //                           '1. IREPS Helpdesk',
// //                           style: TextStyle(fontWeight: FontWeight.bold),
// //                         )
// //                       ],
// //                     ),
// //
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
// //                         Icon(
// //                           Icons.call,
// //                           color: Colors.green,
// //                         ),
// //                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
// //                         InkWell(
// //                           child: Text("+91-11-23761525",
// //                               style: TextStyle(
// //                                 color: Colors.indigo,
// //                                 fontSize: 15,
// //                                 decoration: TextDecoration.underline,
// //                               )),
// //                           onTap: () {
// //                             _callPhone(phone_IREPS);
// //                           },
// //                         ),
// //                         Text(
// //                           " (10 lines)",
// //                           style: TextStyle(
// //                             color: Colors.indigo,
// //                             fontSize: 15,
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //                     Padding(padding: EdgeInsets.only(top: 20.0)),
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
// //                         Icon(
// //                           Icons.alarm_on,
// //                           color: Colors.blue[500],
// //                         ),
// //                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
// //                         Text(
// //                           "Mon - Sat: 8:00 AM - 7:00 PM",
// //                           style: TextStyle(
// //                             color: Colors.black,
// //                             fontSize: 15,
// //                           ),
// //                         )
// //                       ],
// //                     ),
// //
// //                     Padding(padding: EdgeInsets.only(top: 20.0)),
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
// //                         Icon(
// //                           Icons.calendar_today,
// //                           color: Colors.red[500],
// //                         ),
// //                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
// //                         InkWell(
// //                           child:
// //                               Text("Click here to know CRIS Gazetted Holidays",
// //                                   style: TextStyle(
// //                                     color: Colors.lightBlue[600],
// //                                     fontSize: 15,
// //                                     decoration: TextDecoration.underline,
// //                                   )),
// //                           onTap: () {
// //                             var fileUrl =
// //                                 "https://www.ireps.gov.in/ireps/upload/resources/List%20of%20Gazetted%20Holidays.pdf";
// //                             var fileName =
// //                                 fileUrl.substring(fileUrl.lastIndexOf("/"));
// //                             AapoortiUtilities.openPdf(
// //                                 context, fileUrl, fileName);
// //                           },
// //                         ),
// //
// //                         //Text("click here to know CRIS Gazetted Holidays", style: TextStyle(color: Colors.lightBlueAccent,fontSize: 15),),
// //                       ],
// //                     ),
// //                     Padding(padding: EdgeInsets.only(top: 30.0)),
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(padding: EdgeInsets.only(left: 10.0, top: 0.0)),
// //                         //  Padding(padding: EdgeInsets.only(top: 10.0,left:20.0)),
// //                         Text(
// //                           "2. SBIePay Payment Gateway Helpdesk",
// //                           style: TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 15,
// //                               fontWeight: FontWeight.bold),
// //                         ),
// //                       ],
// //                     ),
// //                     Padding(padding: EdgeInsets.only(top: 20.0)),
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
// //                         Icon(
// //                           Icons.call,
// //                           color: Colors.green[500],
// //                         ),
// //                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
// //
// //                         InkWell(
// //                           child: Text("+91-22-27523816",
// //                               style: TextStyle(
// //                                 color: Colors.indigo,
// //                                 fontSize: 15,
// //                                 decoration: TextDecoration.underline,
// //                               )),
// //                           onTap: () {
// //                             _callPhone(phone_SBIePAY);
// //                           },
// //                         ),
// //                         // Text("+91-22-27560137",style: TextStyle(color: Colors.indigo,decoration: TextDecoration.underline,fontSize: 15),),
// //                         Padding(
// //                             padding: EdgeInsets.only(left: 5.0, right: 5.0)),
// //                         Text(
// //                           ",",
// //                           style: TextStyle(
// //                             color: Colors.indigo,
// //                           ),
// //                         ),
// //                         Padding(
// //                             padding: EdgeInsets.only(left: 5.0, right: 5.0)),
// //                         InkWell(
// //                           child: Text("+91-22-27570026",
// //                               style: TextStyle(
// //                                 color: Colors.indigo,
// //                                 fontSize: 15,
// //                                 decoration: TextDecoration.underline,
// //                               )),
// //                           onTap: () {
// //                             _callPhone(phone_SBIePAY1);
// //                           },
// //                         ),
// //
// //                         //Text("+91-22-27523816", style: TextStyle(color: Colors.indigo,decoration: TextDecoration.underline,fontSize: 15)),
// //                       ],
// //                     ),
// //                     Padding(padding: EdgeInsets.only(top: 20.0)),
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
// //                         Icon(
// //                           Icons.mail_outline,
// //                           color: Colors.yellow[700],
// //                         ),
// //                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
// //                         InkWell(
// //                           child: Text("sbiepay@sbi.co.in",
// //                               style: TextStyle(
// //                                   color: Colors.lightBlue[600],
// //                                   decoration: TextDecoration.underline,
// //                                   fontSize: 15)),
// //                           onTap: () {
// //                             _launchURL(email_SBIePAY);
// //                           },
// //                         ),
// //                         //Text("sbipay@sbi.co.in", style: TextStyle(color: Colors.lightBlueAccent,decoration: TextDecoration.underline,fontSize: 15),),
// //                       ],
// //                     ),
// //
// //                     //Padding(padding: EdgeInsets.only(top: 20.0)),
// //                     Padding(padding: EdgeInsets.only(top: 30.0)),
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(padding: EdgeInsets.only(left: 10.0, top: 0.0)),
// //
// //                         //Padding(padding: EdgeInsets.only(top: 10.0,left:20.0)),
// //                         Text(
// //                           "3.SBI Net Banking Helpdesk",
// //                           style: TextStyle(
// //                               fontSize: 15, fontWeight: FontWeight.bold),
// //                         ),
// //                       ],
// //                     ),
// //                     Padding(padding: EdgeInsets.only(top: 20.0)),
// //
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
// //                         Icon(
// //                           Icons.call,
// //                           color: Colors.green[500],
// //                         ),
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 10.0)),
// //                         InkWell(
// //                           child: Text("+91-11-23766066",
// //                               style: TextStyle(
// //                                 color: Colors.indigo,
// //                                 fontSize: 15,
// //                                 decoration: TextDecoration.underline,
// //                               )),
// //                           onTap: () {
// //                             _callPhone(phone_SBInetBanking1);
// //                           },
// //                         ),
// //                         //Text("+91-11-23761525",style: TextStyle(color: Colors.indigo,decoration: TextDecoration.underline,fontSize: 15),),
// //                         Padding(
// //                             padding: EdgeInsets.only(left: 5.0, right: 5.0)),
// //                         Text(
// //                           ",",
// //                           style: TextStyle(
// //                             color: Colors.indigo,
// //                           ),
// //                         ),
// //                         Padding(
// //                             padding: EdgeInsets.only(left: 5.0, right: 5.0)),
// //                         InkWell(
// //                           child: Text("+91-22-27566067",
// //                               style: TextStyle(
// //                                 color: Colors.indigo,
// //                                 fontSize: 15,
// //                                 decoration: TextDecoration.underline,
// //                               )),
// //                           onTap: () {
// //                             _callPhone(phone_SBInetBanking2);
// //                           },
// //                         ),
// //                         //Text("+91-22-27566067",style: TextStyle(color: Colors.indigo,decoration: TextDecoration.underline,fontSize: 15),)
// //                       ],
// //                     ),
// //
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 55.0)),
// //                         InkWell(
// //                           child: Text("+91-22-27560137",
// //                               style: TextStyle(
// //                                 color: Colors.indigo,
// //                                 fontSize: 15,
// //                                 decoration: TextDecoration.underline,
// //                               )),
// //                           onTap: () {
// //                             _callPhone(phone_SBInetBanking3);
// //                           },
// //                         ),
// //                         // Text("+91-22-27560137",style: TextStyle(color: Colors.indigo,decoration: TextDecoration.underline,fontSize: 15),),
// //                         Padding(
// //                             padding: EdgeInsets.only(left: 5.0, right: 5.0)),
// //                         Text(
// //                           ",",
// //                           style: TextStyle(
// //                             color: Colors.indigo,
// //                           ),
// //                         ),
// //                         Padding(
// //                             padding: EdgeInsets.only(left: 5.0, right: 5.0)),
// //                         InkWell(
// //                           child: Text("+91-22-27566501",
// //                               style: TextStyle(
// //                                 color: Colors.indigo,
// //                                 fontSize: 15,
// //                                 decoration: TextDecoration.underline,
// //                               )),
// //                           onTap: () {
// //                             _callPhone(phone_SBInetBanking4);
// //                           },
// //                         ),
// //                         //Text("+91-22-27566501",style: TextStyle(color: Colors.indigo,decoration: TextDecoration.underline,fontSize: 15),)
// //                       ],
// //                     ),
// //                     Padding(padding: EdgeInsets.only(top: 20.0)),
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 20.0)),
// //                         Icon(
// //                           Icons.mail_outline,
// //                           color: Colors.yellow[700],
// //                         ),
// //                         Padding(
// //                             padding: EdgeInsets.only(top: 10.0, left: 15.0)),
// //                         InkWell(
// //                           child: Text("inb.cinb@sbi.co.in",
// //                               style: TextStyle(
// //                                   color: Colors.lightBlueAccent,
// //                                   decoration: TextDecoration.underline,
// //                                   fontSize: 15)),
// //                           onTap: () {
// //                             _launchURL(email_SBInetbanking);
// //                           },
// //                         ),
// // //                        Text('inb.cinb@sbi.co.in',
// // //                          style: TextStyle(color: Colors.lightBlueAccent,decoration: TextDecoration.underline,fontSize: 15), ),
// //                       ],
// //                     ),
// //
// //                     Padding(padding: EdgeInsets.only(top: 20.0)),
// //                     Row(
// //                       children: <Widget>[
// //                         Padding(padding: EdgeInsets.only(top: 5.0, left: 20.0)),
// //                         Icon(
// //                           Icons.alarm_on,
// //                           color: Colors.blue[500],
// //                         ),
// //                         Padding(padding: EdgeInsets.only(top: 5.0, left: 15.0)),
// //                         Text(
// //                           'Mon - Sat: 10:00 AM - 6:00 PM',
// //                           style: TextStyle(fontSize: 15),
// //                         ),
// //                       ],
// //                     ),
// //                     Row(
// //                       children: <Widget>[
// //                         Text('\n'),
// //                       ],
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
//       ],
//
//       // ),
//
//       // bottomNavigationBar:AapoortiUtilities.bottomnavigationbar(context)
//       // ),
//     );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loading = true;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _loading = true;
            });

          },
          onPageFinished: (String url) {
            setState(() {
              _loading = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if(request.url.toLowerCase().contains('https://www.ireps.gov.in')) {
              //IRUDMConstants.launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.ireps.gov.in/eps/helpdesk/querisAfterLogin.do?param=showPage'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.white), backgroundColor: Colors.black,centerTitle: true, title: Text("IREPS", style: TextStyle(color: Colors.white))),
      body: SafeArea(
          child: _loading == false ? WebViewWidget(controller: _controller, gestureRecognizers: Set()) : Center(child: CircularProgressIndicator(color: Colors.cyan[300], strokeWidth: 4))
      )
    );
  }
}

