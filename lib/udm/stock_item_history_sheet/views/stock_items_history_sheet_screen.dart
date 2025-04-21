

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/providers/stockhistory_updatechange_screen_provider.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/view_model/StockHistoryViewModel.dart';
import 'package:flutter_app/udm/stock_item_history_sheet/views/stock_history_select_list_screen.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class StockItemHistorySheetScreen extends StatefulWidget {
  static const routeName = "/stockhistory-screen";

  @override
  State<StockItemHistorySheetScreen> createState() => _StockItemHistorySheetScreenState();
}

class _StockItemHistorySheetScreenState
    extends State<StockItemHistorySheetScreen> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  final _textsearchController = TextEditingController();

  final _plController = TextEditingController();

  String rlyname = "--Select Railway--";
  String rlycode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 200)).then((value) {
      Provider.of<StockHistoryViewModel>(context, listen: false).getRailwaylistData(context);
    });

    //Provider.of<NetworkProvider>(context, listen: false).initConnectivity();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _plController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    final updatechangeprovider = Provider.of<StockHistoryupdateChangesScreenProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<StockHistoryViewModel>(context, listen: false).clearOnBack(context);
        return Future<bool>.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AapoortiConstants.primary,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
          // leading: Consumer<StockHistoryupdateChangesScreenProvider>(builder: (context, value, child){
          //     if(value.getSearchValue){
          //       return SizedBox();
          //     }
          //     else {
          //       return IconButton(
          //         splashRadius: 30,
          //         icon: Icon(
          //           Icons.arrow_back,
          //           color: Colors.white,
          //         ),
          //         onPressed: () {
          //           Navigator.of(context, rootNavigator: true).pushNamed(UserHomeScreen.routeName);
          //         },
          //       );
          //     }
          // }),
          actions: [
            Consumer<StockHistoryupdateChangesScreenProvider>(
                builder: (context, value, child) {
                  if (value.getSearchValue) {
                    return SizedBox();
                  }
                  else {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            updatechangeprovider.updateScreen(true);
                          },
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.home, color: Colors.white, size: 22),
                          onPressed: () {
                            Navigator.of(context).pop();
                            //Feedback.forTap(context);
                          },
                        ),
                        // PopupMenuButton<String>(
                        //   itemBuilder: (context) => [
                        //     PopupMenuItem(
                        //       value: 'clear',
                        //       child: Text(language.text('clear'),
                        //           style: TextStyle(color: Colors.black)),
                        //     ),
                        //     PopupMenuItem(
                        //       value: 'exit',
                        //       child: Text(language.text('exit'),
                        //           style: TextStyle(color: Colors.black)),
                        //     ),
                        //   ],
                        //   color: Colors.white,
                        //   onSelected: (value) {
                        //     if(value == 'clear') {
                        //       Provider.of<StockHistoryViewModel>(context, listen: false).clearAllData(context);
                        //     } else if (value == 'exit') {
                        //       Navigator.pop(context);
                        //     }
                        //   },
                        // )
                      ],
                    );
                  }
            }),
          ],
          title: Consumer<StockHistoryupdateChangesScreenProvider>(
              builder: (context, value, child) {
                if(value.getSearchValue) {
                  return Container(
                    width: double.infinity,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Center(child: TextField(
                      cursorColor: AapoortiConstants.primary,
                      controller: _textsearchController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: AapoortiConstants.primary),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear, color: AapoortiConstants.primary),
                            onPressed: () {
                              updatechangeprovider.updateScreen(false);
                              _textsearchController.text = "";
                              Future.delayed(const Duration(seconds: 1), () {
                                Provider.of<StockHistoryViewModel>(context, listen: false).searchingHisData(_textsearchController.text, context);
                              });
                            },
                          ),
                          hintText: language.text('search'),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none),
                          onChanged: (query) {
                            Future.delayed(const Duration(seconds: 1), () {
                               Provider.of<StockHistoryViewModel>(context, listen: false).searchingHisData(query, context);
                           });
                      },
                    ),
                    ),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            Provider.of<StockHistoryViewModel>(context, listen: false).clearOnBack(context).then((value) =>  Navigator.pop(context));
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white)),
                      SizedBox(width: 5),
                      Container(
                        height: size.height * 0.10,
                        width: size.width/1.6,
                        child: Marquee(
                            text: " ${language.text('stkitemtitle')}",
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 30.0,
                            velocity: 100.0,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            pauseAfterRound: Duration(seconds: 1),
                            accelerationDuration: Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                        )
                      )

                      // Text(language.text('stkitemtitle').length > 20
                      //     ? '${language.text('stkitemtitle').substring(0, 20)}...'
                      //     : language.text('stkitemtitle'))

                    ],
                  );
                }
              }),
        ),
        // body: SingleChildScrollView(
        //   child: Container(
        //     height: size.height,
        //     width: size.width,
        //     child: Padding(
        //       padding: const EdgeInsets.all(10.0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //           Text(language.text('rly'), style: TextStyle(color: Colors.black, fontSize: 17)),
        //           SizedBox(height: 10),
        //           Consumer<StockHistoryViewModel>(builder: (context, value, child) {
        //             if(value.state == StockHistoryViewModelDataState.Busy) {
        //               return Container(
        //                 height: 45,
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //                     border: Border.all(color: Colors.grey, width: 1)),
        //                 alignment: Alignment.center,
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Text("${language.text('selectrly')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
        //                       Container(
        //                           height: 24,
        //                           width: 24,
        //                           child: CircularProgressIndicator(
        //                             strokeWidth: 2.0,
        //                           ))
        //                     ],
        //                   ),
        //                 ),
        //               );
        //             }
        //             else {
        //               return Container(
        //                 height: 45,
        //                 decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //                     border: Border.all(color: Colors.grey, width: 1)),
        //                 child: DropdownSearch<String>(
        //                   //mode: Mode.DIALOG,
        //                   //showSelectedItem: true,
        //                   //autoFocusSearchBox: true,
        //                   //showSearchBox: true,
        //                   //showSelectedItems: true,
        //                   selectedItem: value.railway,
        //                   popupProps: PopupPropsMultiSelection.menu(
        //                     showSearchBox: true,
        //                     fit: FlexFit.loose,
        //                     showSelectedItems: true,
        //                     menuProps: MenuProps(
        //                         shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
        //                           borderRadius: BorderRadius.circular(5.0),
        //                           side: BorderSide(color: Colors.grey), // You can customize the border color
        //                         )
        //                     ),
        //                   ),
        //                   // popupShape: RoundedRectangleBorder(
        //                   //   borderRadius: BorderRadius.circular(5.0),
        //                   //   side: BorderSide(color: Colors.grey),
        //                   // ),
        //                   // favoriteItems: (val) {
        //                   //   return [value.railway];
        //                   // },
        //                   decoratorProps: DropDownDecoratorProps(
        //                     decoration: InputDecoration(
        //                         enabledBorder: OutlineInputBorder(
        //                             borderRadius: BorderRadius.circular(12),
        //                             borderSide: BorderSide.none),
        //                         contentPadding: EdgeInsets.only(left: 10))
        //                   ),
        //                   items: (filter, loadProps) => value.rlylistData.map((e) {
        //                     return e.value.toString();
        //                   }).toList(),
        //                   onChanged: (changedata) {
        //                     value.railway = changedata.toString();
        //                     value.rlylistData.forEach((element) {
        //                       if(changedata.toString() == element.value.toString()){
        //                         value.rlyCode = element.intcode.toString();
        //                       }
        //                     });
        //                   },
        //                 ),
        //               );
        //             }
        //           }),
        //           SizedBox(height: 10),
        //           Text(language.text("pldetails"),
        //               style: TextStyle(
        //                   color: Colors.black,
        //                   fontSize: 17)),
        //           SizedBox(height: 10),
        //           Row(
        //             children: [
        //               Container(
        //                 width: size.width * 0.60,
        //                 height: 40,
        //                 alignment: Alignment.center,
        //                 decoration: BoxDecoration(
        //                     color: Colors.white,
        //                     border: Border.all(color: Colors.grey, width: 1),
        //                     borderRadius: BorderRadius.all(Radius.circular(8.0))),
        //                 child: TextField(
        //                   controller: _plController,
        //                   decoration: InputDecoration(
        //                     border: InputBorder.none,
        //                     focusedBorder: InputBorder.none,
        //                     enabledBorder: InputBorder.none,
        //                     errorBorder: InputBorder.none,
        //                     disabledBorder: InputBorder.none,
        //                     hintText: language.text('plhint'),
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(width: 10),
        //               InkWell(
        //                 onTap: () {
        //                   FocusManager.instance.primaryFocus?.unfocus();
        //                   var provider = Provider.of<StockHistoryViewModel>(context, listen: false);
        //                   String rly = provider.railway;
        //                   String? rlyC = provider.rlyCode;
        //                   if(rly == "--Select Railway--") {
        //                     UdmUtilities.showWarningFlushBar(context, language.text('rlysuggestion'));
        //                     return;
        //                   } else if(_plController.text.isEmpty) {
        //                     UdmUtilities.showWarningFlushBar(context, language.text('plsuggestion'));
        //                     return;
        //                   } else {
        //                     provider.getStockhistorylistData(rlyC!, _plController.text.toString(), context);
        //                   }
        //                 },
        //                 child: Container(
        //                   width: size.width * 0.30,
        //                   height: 40,
        //                   alignment: Alignment.center,
        //                   decoration: BoxDecoration(color: AapoortiConstants.primary, borderRadius: BorderRadius.all(Radius.circular(8.0))),
        //                   child: Text(language.text('find'), style: TextStyle(color: Colors.white, fontSize: 16)),
        //                 ),
        //               )
        //             ],
        //           ),
        //           SizedBox(height: 10),
        //           Consumer<StockHistoryViewModel>(builder: (context, value, child){
        //             return Text("${language.text('tophead')} (${value.hislistData.length})",
        //                 style: TextStyle(
        //                     color: Colors.blueAccent,
        //                     fontSize: 18,
        //                     fontWeight: FontWeight.w600));
        //           }),
        //           SizedBox(height: 5.0),
        //           Consumer<StockHistoryViewModel>(builder: (context, value, child){
        //             if(value.hisstate == StockHistorylistViewModelDataState.Idle){
        //               return Expanded(child: Center(
        //                 child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       Image.asset('assets/no_data.png', height: 85, width: 85),
        //                       SizedBox(height: 3),
        //                       Text("Please select a railway and enter pl details to find history sheet.", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18))
        //                     ],
        //                 ),
        //               ));
        //             }
        //             else if(value.hisstate == StockHistorylistViewModelDataState.Busy){
        //               return Expanded(child: Center(
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       CircularProgressIndicator(strokeWidth: 3.0),
        //                       SizedBox(height: 3.0),
        //                       Text(language.text('pw'), style: TextStyle(color: Colors.black, fontSize: 16))
        //                     ],
        //                   )
        //               )
        //               );
        //             }
        //             else if(value.hisstate == StockHistorylistViewModelDataState.FinishedWithError){
        //               return Expanded(child: Center(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
        //                     AnimatedTextKit(
        //                         isRepeatingAnimation: false,
        //                         animatedTexts: [
        //                           TyperAnimatedText(language.text('dnf'),
        //                               speed: Duration(milliseconds: 150),
        //                               textStyle: TextStyle(
        //                                   fontWeight: FontWeight.bold)),
        //                         ])
        //                   ],
        //                 ),
        //               )
        //               );
        //             }
        //             else if(value.hisstate == StockHistorylistViewModelDataState.NoData){
        //               return Expanded(child:  Center(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
        //                     AnimatedTextKit(
        //                         isRepeatingAnimation: false,
        //                         animatedTexts: [
        //                           TyperAnimatedText(language.text('dnf'),
        //                               speed: Duration(milliseconds: 150),
        //                               textStyle: TextStyle(
        //                                   fontWeight: FontWeight.bold)),
        //                         ])
        //                   ],
        //                 ),
        //               ));
        //             }
        //             else{
        //               return Expanded(
        //                 child: AnimationLimiter(
        //                   child: ListView.builder(
        //                     itemCount: value.hislistData.length,
        //                     padding: EdgeInsets.zero,
        //                     shrinkWrap: true,
        //                     //physics: const NeverScrollableScrollPhysics(),
        //                     itemBuilder: (BuildContext context, int index) {
        //                       return AnimationConfiguration.staggeredList(
        //                         position: index,
        //                         duration: const Duration(milliseconds: 375),
        //                         child: SlideAnimation(
        //                           verticalOffset: 50.0,
        //                           child: FadeInAnimation(
        //                             child: Card(
        //                               elevation: 0.0,
        //                               color: Colors.white,
        //                               shape: RoundedRectangleBorder(
        //                                   borderRadius:
        //                                   BorderRadius.circular(4.0),
        //                                   side: BorderSide(
        //                                     color: Colors.blue.shade500,
        //                                     width: 1.0,
        //                                   )
        //                               ),
        //                               child: Container(
        //                                 //padding: EdgeInsets.all(10.0),
        //                                 child: Column(
        //                                   mainAxisAlignment: MainAxisAlignment.start,
        //                                   crossAxisAlignment: CrossAxisAlignment.start,
        //                                   children: [
        //                                     Align(
        //                                       alignment: Alignment.topLeft,
        //                                       child: Container(
        //                                           height: 30,
        //                                           width: 35,
        //                                           alignment: Alignment.center,
        //                                           child: Text('${index + 1}',
        //                                               textAlign: TextAlign
        //                                                   .center,
        //                                               style: TextStyle(
        //                                                   fontSize: 14,
        //                                                   color: Colors
        //                                                       .white)),
        //                                           decoration: BoxDecoration(
        //                                               color: Colors.blue,
        //                                               borderRadius:
        //                                               BorderRadius.only(
        //                                                   bottomRight:
        //                                                   Radius
        //                                                       .circular(
        //                                                       10),
        //                                                   topLeft: Radius
        //                                                       .circular(
        //                                                       5)))),
        //                                     ),
        //                                     Padding(
        //                                       padding: EdgeInsets.all(10.0),
        //                                       child: Column(
        //                                         mainAxisAlignment: MainAxisAlignment.start,
        //                                         crossAxisAlignment: CrossAxisAlignment.start,
        //                                         children: [
        //                                           Column(
        //                                             mainAxisAlignment:
        //                                             MainAxisAlignment.start,
        //                                             crossAxisAlignment:
        //                                             CrossAxisAlignment.start,
        //                                             children: [
        //                                               Text(language.text('plno'),
        //                                                   style: TextStyle(
        //                                                       color: Colors.black,
        //                                                       fontWeight: FontWeight.w600,
        //                                                       fontSize: 14)),
        //                                               Text(value.hislistData[index].plNo.toString(),
        //                                                   maxLines: 3,
        //                                                   style: TextStyle(
        //                                                       color: Colors.black,
        //                                                       fontSize: 14))
        //                                             ],
        //                                           ),
        //                                           SizedBox(height: 15),
        //                                           Column(
        //                                             mainAxisAlignment:
        //                                             MainAxisAlignment.start,
        //                                             crossAxisAlignment:
        //                                             CrossAxisAlignment.start,
        //                                             children: [
        //                                               Text(language.text('desc'),
        //                                                   style: TextStyle(
        //                                                       color: Colors.black,
        //                                                       fontWeight: FontWeight.w600,
        //                                                       fontSize: 14)),
        //                                               ReadMoreText(value.hislistData[0].descr.toString().trim(),
        //                                                   trimLines: 5,
        //                                                   colorClickableText: AapoortiConstants.primary,
        //                                                   trimMode: TrimMode.Line,
        //                                                   trimCollapsedText: '... More',
        //                                                   trimExpandedText: '...less',  style: TextStyle(color: Colors.black, fontSize: 14))
        //                                               // Text(value.hislistData[index].descr.toString().trim(),
        //                                               //     maxLines: 3,
        //                                               //     style: TextStyle(
        //                                               //         color: Colors.black,
        //                                               //         fontSize: 14))
        //                                             ],
        //                                           ),
        //                                           SizedBox(height: 15),
        //                                           Align(
        //                                             alignment: Alignment.topRight,
        //                                             child: InkWell(
        //                                               onTap:() {
        //                                                 String? rlyC = Provider.of<StockHistoryViewModel>(context, listen: false).rlyCode;
        //                                                 Navigator.push(context,
        //                                                   MaterialPageRoute(builder: (context) => StockHistorySelectlistScreen(rlyC!, _plController.text, value.hislistData[index].plNo.toString())),
        //                                                 );
        //                                                 //Navigator.of(context).pushNamed(StockHistorySelectlistScreen.routeName);
        //                                               },
        //                                               child: Container(
        //                                                 height: 35,
        //                                                 width: 90,
        //                                                 alignment: Alignment.center,
        //                                                 decoration: BoxDecoration(
        //                                                     color: Colors.blueAccent,
        //                                                     borderRadius: BorderRadius.all(
        //                                                         Radius.circular(4.0)),
        //                                                     border: Border.all(
        //                                                         color: Colors.blueAccent,
        //                                                         width: 1)),
        //                                                 child: Text("Select",
        //                                                     style: TextStyle(
        //                                                         color: Colors.white)),
        //                                               ),
        //                                             ),
        //                                           )
        //                                         ],
        //                                       ),
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                       );
        //                     },
        //                   ),
        //                 ),
        //               );
        //             }
        //           })
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: Column(
            children: [
              // Main content with straight edges
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.text('raildiv'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer<StockHistoryViewModel>(builder: (context, value, child) {
                      if(value.state == StockHistoryViewModelDataState.Busy) {
                        return Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${language.text('selectrly')}", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.start),
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
                      }
                      else {
                        return Container(
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: DropdownSearch<String>(
                            selectedItem: value.railway,
                            popupProps: PopupPropsMultiSelection.menu(
                              showSearchBox: true,
                              fit: FlexFit.loose,
                              showSelectedItems: true,
                              menuProps: MenuProps(
                                  shape: RoundedRectangleBorder( // Custom shape without the right side scroll line
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(color: Colors.grey), // You can customize the border color
                                  )
                              ),
                            ),
                            decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(left: 10))
                            ),
                            items: (filter, loadProps) => value.rlylistData.map((e) {
                              return e.value.toString();
                            }).toList(),
                            onChanged: (changedata) {
                              value.railway = changedata.toString();
                              value.rlylistData.forEach((element) {
                                if(changedata.toString() == element.value.toString()){
                                  value.rlyCode = element.intcode.toString();
                                }
                              });
                            },
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 20),
                    Text(
                      "${language.text('plr')}:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _plController,
                            decoration: InputDecoration(
                              hintText: language.text('plcode'),
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var provider = Provider.of<StockHistoryViewModel>(context, listen: false);
                            String rly = provider.railway;
                            String? rlyC = provider.rlyCode;
                            if(rly == "--Select Railway--") {
                              UdmUtilities.showWarningFlushBar(context, language.text('rlysuggestion'));
                              return;
                            } else if(_plController.text.isEmpty) {
                              UdmUtilities.showWarningFlushBar(context, language.text('plsuggestion'));
                              return;
                            } else {
                              provider.getStockhistorylistData(rlyC!, _plController.text.toString(), context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                          child: Text(
                            language.text('searchbtn'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Consumer<StockHistoryViewModel>(builder: (context, value, child){
                 if(value.hisstate == StockHistorylistViewModelDataState.Idle){
                   return Expanded(
                     child: Container(
                       width: double.infinity,
                       color: Colors.white,
                       padding: const EdgeInsets.all(16),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             language.text('sihr'),
                             style: TextStyle(
                               fontSize: 16,
                               fontWeight: FontWeight.bold,
                               color: Colors.blue.shade800,
                             ),
                           ),
                           const SizedBox(height: 40),
                           Expanded(
                             child: Center(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Container(
                                     width: 120,
                                     height: 120,
                                     padding: const EdgeInsets.all(16),
                                     decoration: BoxDecoration(
                                       color: Colors.blue.shade50,
                                       borderRadius: BorderRadius.circular(60),
                                     ),
                                     child: Stack(
                                       children: [
                                         Icon(
                                           Icons.inventory_2,
                                           size: 80,
                                           color: Colors.blue.shade700,
                                         ),
                                         Positioned(
                                           right: 0,
                                           bottom: 0,
                                           child: Container(
                                             width: 40,
                                             height: 40,
                                             decoration: BoxDecoration(
                                               color: Colors.white,
                                               borderRadius: BorderRadius.circular(20),
                                               border: Border.all(color: Colors.blue.shade200, width: 2),
                                             ),
                                             child: Center(
                                               child: Icon(
                                                 Icons.search,
                                                 color: Colors.blue.shade800,
                                                 size: 24,
                                               ),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                   const SizedBox(height: 24),
                                   Text(
                                     language.text('sihrdes'),
                                     style: TextStyle(
                                       fontSize: 16,
                                       color: Colors.grey.shade700,
                                       height: 1.5,
                                     ),
                                     textAlign: TextAlign.center,
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   );
                 }
                 else if(value.hisstate == StockHistorylistViewModelDataState.Busy){
                   return Expanded(child: Center(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           CircularProgressIndicator(strokeWidth: 3.0),
                           SizedBox(height: 3.0),
                           Text(language.text('pw'), style: TextStyle(color: Colors.black, fontSize: 16))
                         ],
                       )
                   )
                   );
                 }
                 else if(value.hisstate == StockHistorylistViewModelDataState.FinishedWithError){
                   return Expanded(child: Center(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
                         AnimatedTextKit(
                             isRepeatingAnimation: false,
                             animatedTexts: [
                               TyperAnimatedText(language.text('dnf'),
                                   speed: Duration(milliseconds: 150),
                                   textStyle: TextStyle(
                                       fontWeight: FontWeight.bold)),
                             ])
                       ],
                     ),
                   )
                   );
                 }
                 else if(value.hisstate == StockHistorylistViewModelDataState.NoData){
                   return Expanded(child:  Center(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Lottie.asset('assets/json/no_data.json', height: 120, width: 120),
                         AnimatedTextKit(
                             isRepeatingAnimation: false,
                             animatedTexts: [
                               TyperAnimatedText(language.text('dnf'),
                                   speed: Duration(milliseconds: 150),
                                   textStyle: TextStyle(
                                       fontWeight: FontWeight.bold)),
                             ])
                       ],
                     ),
                   ));
                 }
                 else{
                   return Expanded(
                     child: AnimationLimiter(
                       child: ListView.builder(
                         itemCount: value.hislistData.length,
                         padding: EdgeInsets.all(4.0),
                         shrinkWrap: true,
                         //physics: const NeverScrollableScrollPhysics(),
                         itemBuilder: (BuildContext context, int index) {
                           return AnimationConfiguration.staggeredList(
                             position: index,
                             duration: const Duration(milliseconds: 375),
                             child: SlideAnimation(
                               verticalOffset: 50.0,
                               child: FadeInAnimation(
                                 child: Card(
                                   elevation: 0.0,
                                   color: Colors.white,
                                   shape: RoundedRectangleBorder(
                                       borderRadius:
                                       BorderRadius.circular(4.0),
                                       side: BorderSide(
                                         color: Colors.blue.shade500,
                                         width: 1.0,
                                       )
                                   ),
                                   child: Container(
                                     //padding: EdgeInsets.all(10.0),
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
                                                   textAlign: TextAlign
                                                       .center,
                                                   style: TextStyle(
                                                       fontSize: 14,
                                                       color: Colors
                                                           .white)),
                                               decoration: BoxDecoration(
                                                   color: Colors.blue.shade800,
                                                   borderRadius:
                                                   BorderRadius.only(
                                                       bottomRight:
                                                       Radius
                                                           .circular(
                                                           10),
                                                       topLeft: Radius
                                                           .circular(
                                                           5)))),
                                         ),
                                         Padding(
                                           padding: EdgeInsets.all(10.0),
                                           child: Column(
                                             mainAxisAlignment: MainAxisAlignment.start,
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Column(
                                                 mainAxisAlignment:
                                                 MainAxisAlignment.start,
                                                 crossAxisAlignment:
                                                 CrossAxisAlignment.start,
                                                 children: [
                                                   Text(language.text('plno'),
                                                       style: TextStyle(
                                                           color: Colors.black,
                                                           fontWeight: FontWeight.w600,
                                                           fontSize: 14)),
                                                   Text(value.hislistData[index].plNo.toString(),
                                                       maxLines: 3,
                                                       style: TextStyle(
                                                           color: Colors.black,
                                                           fontSize: 14))
                                                 ],
                                               ),
                                               SizedBox(height: 15),
                                               Column(
                                                 mainAxisAlignment:
                                                 MainAxisAlignment.start,
                                                 crossAxisAlignment:
                                                 CrossAxisAlignment.start,
                                                 children: [
                                                   Text(language.text('desc'),
                                                       style: TextStyle(
                                                           color: Colors.black,
                                                           fontWeight: FontWeight.w600,
                                                           fontSize: 14)),
                                                   ReadMoreText(value.hislistData[0].descr.toString().trim(),
                                                       trimLines: 5,
                                                       colorClickableText: AapoortiConstants.primary,
                                                       trimMode: TrimMode.Line,
                                                       trimCollapsedText: '... More',
                                                       trimExpandedText: '...less',  style: TextStyle(color: Colors.black, fontSize: 14))
                                                   // Text(value.hislistData[index].descr.toString().trim(),
                                                   //     maxLines: 3,
                                                   //     style: TextStyle(
                                                   //         color: Colors.black,
                                                   //         fontSize: 14))
                                                 ],
                                               ),
                                               SizedBox(height: 15),
                                               Align(
                                                 alignment: Alignment.topRight,
                                                 child: InkWell(
                                                   onTap:() {
                                                     String? rlyC = Provider.of<StockHistoryViewModel>(context, listen: false).rlyCode;
                                                     Navigator.push(context,
                                                       MaterialPageRoute(builder: (context) => StockHistorySelectlistScreen(rlyC!, _plController.text, value.hislistData[index].plNo.toString())),
                                                     );
                                                     //Navigator.of(context).pushNamed(StockHistorySelectlistScreen.routeName);
                                                   },
                                                   child: Container(
                                                     height: 35,
                                                     width: 90,
                                                     alignment: Alignment.center,
                                                     decoration: BoxDecoration(
                                                         color: Colors.blue.shade800,
                                                         borderRadius: BorderRadius.all(
                                                             Radius.circular(4.0)),
                                                         border: Border.all(
                                                             color: Colors.blue.shade800,
                                                             width: 1)),
                                                     child: Text(language.text('selectbtn'),
                                                         style: TextStyle(
                                                             color: Colors.white)),
                                                   ),
                                                 ),
                                               )
                                             ],
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           );
                         },
                       ),
                     ),
                   );
                 }
              }),

            ],
          ),
        ),
      ),
    );
  }
}
