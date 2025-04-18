import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view/stocking_proposal_summary_data_link_screen.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/view_model/stocking_prosposal_summary_provider.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class StockingProposalSummaryDataScreen extends StatefulWidget {
  final String? rly;
  final String? department;
  final String? unitinitproposal;
  final String? unifyingrly;
  final String? storesdepot;
  final String? fromdate;
  final String? todate;
  StockingProposalSummaryDataScreen(this.rly, this.department, this.unitinitproposal, this.unifyingrly, this.storesdepot,this.fromdate, this.todate);

  @override
  State<StockingProposalSummaryDataScreen> createState() => _StockingProposalSummaryDataScreenState();
}

class _StockingProposalSummaryDataScreenState extends State<StockingProposalSummaryDataScreen> {

  ScrollController listScrollController = ScrollController();
  final _textsearchController = TextEditingController();

  void _onScrollEvent() {
    final extentAfter = listScrollController.position.pixels;
    Provider.of<StockingProposalSummaryProvider>(context, listen: false).setexpandtotal(false);
    if(extentAfter == listScrollController.position.maxScrollExtent) {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryShowScroll(false);
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryScrollValue(false);
    } else if(extentAfter > listScrollController.position.maxScrollExtent / 3) {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryShowScroll(true);
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryScrollValue(true);
    } else if (extentAfter > listScrollController.position.maxScrollExtent / 5) {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryShowScroll(true);
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryScrollValue(false);
    } else {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryShowScroll(true);
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryScrollValue(false);
    }
  }

  @override
  void initState() {
    listScrollController.addListener(_onScrollEvent);
    super.initState();
    // print("from date ${widget.fromdate}");
    // print("to date ${widget.todate}");
    // print("Railway code ${widget.rly}");
    // print("unitinitproposal ${widget.unitinitproposal!}");
    // print("Department ${widget.department}");
    // print("unifying rly ${widget.unifyingrly}");
    // print("storesdepot ${widget.storesdepot}");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStkSummaryData(widget.rly, widget.storesdepot, widget.unitinitproposal!, widget.department,
          widget.unifyingrly, widget.fromdate, widget.todate, context);
    });
  }

  @override
  void dispose() {
    listScrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  stt.SpeechToText _speech = stt.SpeechToText();

  Future<bool> _isAvailable() async {
    bool isAvailable = await _speech.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
      onError: (error) {
        print('Speech recognition error: $error');
      },
    );
    return isAvailable;
  }

  void _startListening() {
    Provider.of<StockingProposalSummaryProvider>(context, listen: false).showhidemicglow(true);
    _speech.listen(
      onResult: (result) {
        _textsearchController.text = result.recognizedWords;
        Provider.of<StockingProposalSummaryProvider>(context, listen: false).getSearchStkSummaryData(_textsearchController.text, context);
        Provider.of<StockingProposalSummaryProvider>(context, listen: false).updatetextchangeScreen(true);
        Provider.of<StockingProposalSummaryProvider>(context, listen: false).showhidemicglow(false);
      },
    );
  }

  void _stopListening() {
    _speech.stop();
  }

  void hideSoftKeyBoard(bool isVisible) {
    if(isVisible) {
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      Provider.of<StockingProposalSummaryProvider>(context, listen: false).showhidemicglow(false);
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true);
    Provider.of<StockingProposalSummaryProvider>(context, listen: false).setexpandtotal(false);
    Provider.of<StockingProposalSummaryProvider>(context, listen: false).updateScreen(false);
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return KeyboardVisibilityProvider(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AapoortiConstants.primary,
            automaticallyImplyLeading: false,
            title: Consumer<StockingProposalSummaryProvider>(
                builder: (context, value, child) {
                  if(value.getstksumrySearchValue == true) {
                    return Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: TextField(
                          cursorColor: AapoortiConstants.primary,
                          controller: _textsearchController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: AapoortiConstants.primary),
                              suffixIcon: value.getchangetextlistener == false ? IconButton(
                                icon: Icon(Icons.mic, color: AapoortiConstants.primary),
                                onPressed: () async {
                                  hideSoftKeyBoard(KeyboardVisibilityProvider.isKeyboardVisible(context));
                                  bool isAvailable = await _isAvailable();
                                  if(isAvailable) {
                                    _startListening();
                                  } else {
                                    UdmUtilities.showInSnackBar(context, 'Speech recognition not available');
                                  }
                                },
                              ) : IconButton(
                                icon: Icon(Icons.clear, color: AapoortiConstants.primary),
                                onPressed: () {
                                  _textsearchController.text = "";
                                  Provider.of<StockingProposalSummaryProvider>(context, listen: false).getSearchStkSummaryData(_textsearchController.text, context);
                                  Provider.of<StockingProposalSummaryProvider>(context, listen: false).updatetextchangeScreen(false);
                                  Provider.of<StockingProposalSummaryProvider>(context, listen: false).updateScreen(false);
                                },
                              ),
                              focusColor: AapoortiConstants.primary,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AapoortiConstants.primary, width: 1.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AapoortiConstants.primary, width: 1.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AapoortiConstants.primary, width: 1.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: language.text('search'),
                              border: InputBorder.none
                          ),
                          onChanged: (query) {
                            if(query.isNotEmpty) {
                              value.updatetextchangeScreen(true);
                              value.showhidemicglow(false);
                              _stopListening();
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getSearchStkSummaryData(query, context);
                            } else {
                              value.updatetextchangeScreen(false);
                              _textsearchController.text = "";
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).getSearchStkSummaryData(_textsearchController.text, context);
                            }
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
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).setexpandtotal(false);
                              Provider.of<StockingProposalSummaryProvider>(context, listen: false).updateScreen(false);
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back, color: Colors.white)),
                        SizedBox(width: 10),
                        Container(
                            height: size.height * 0.10,
                            width: size.width / 1.7,
                            child: Marquee(
                              text: " ${language.text('stkprptitle')}",
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
                            ))
                      ],
                    );
                  }
                }),
            actions: [
              Consumer<StockingProposalSummaryProvider>(builder: (context, value, child) {
                if (value.getstksumrySearchValue == true) {
                  return SizedBox();
                } else {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<StockingProposalSummaryProvider>(context, listen: false).updateScreen(true);
                        },
                        child: Icon(Icons.search, color: Colors.white),
                      ),
                      PopupMenuButton<String>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'refresh',
                            child: Text(language.text('refresh'), style: TextStyle(color: Colors.black)),
                          ),
                          PopupMenuItem(
                            value: 'exit',
                            child: Text(language.text('exit'), style: TextStyle(color: Colors.black)),
                          ),
                        ],
                        color: Colors.white,
                        onSelected: (value) {
                          if(value == 'refresh') {
                            Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStkSummaryData(widget.rly, widget.storesdepot, widget.unitinitproposal!, widget.department,
                                widget.unifyingrly, widget.fromdate, widget.todate, context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  );
                }
              })
            ],
          ),
          floatingActionButton: Consumer<StockingProposalSummaryProvider>(
              builder: (context, value, child) {
                if (value.getStkPrpSummryUiShowScroll == true) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.09),
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21.5),
                          color: Colors.blue),
                      child: FloatingActionButton(
                        backgroundColor: Colors.blue,
                          onPressed: () {
                            if (listScrollController.hasClients) {
                              if (value.getStkPrpUiScrollValue == false) {
                                final position = listScrollController.position.maxScrollExtent;
                                listScrollController.animateTo(
                                    position,
                                    curve: Curves.linearToEaseOut,
                                    duration: Duration(seconds: 3)
                                );
                                value.setStkPrpSummryScrollValue(true);
                              } else {
                                final position = listScrollController.position.minScrollExtent;
                                listScrollController.animateTo(position, curve: Curves.linearToEaseOut,
                                    duration: Duration(seconds: 3));
                                value.setStkPrpSummryScrollValue(false);
                              }
                            }
                          },
                          child: value.getStkPrpUiScrollValue == true
                              ? Icon(Icons.arrow_upward, color: Colors.white)
                              : Icon(Icons.arrow_downward_rounded,
                              color: Colors.white)),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }),
          body: Container(
            height: size.height,
            width: size.width,
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Consumer<StockingProposalSummaryProvider>(
                        builder: (context, value, child) {
                          if(value.stksmryDatastate == StksmryDataState.Busy) {
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
                                                borderRadius:
                                                BorderRadius.circular(4.0),
                                              ),
                                              child: SizedBox(
                                                  height: size.height * 0.45),
                                            );
                                          }))
                                ],
                              ),
                            );
                          }
                          else if(value.stksmryDatastate == StksmryDataState.Finished) {
                            return ListView.builder(
                                itemCount: value.stkSummaryData.length,
                                shrinkWrap: true,
                                controller: listScrollController,
                                padding: EdgeInsets.only(bottom: size.height * 0.09),
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 8.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        side: BorderSide(
                                          color: Colors.blue.shade500,
                                          width: 1.0,
                                        )),
                                    child: Container(
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
                                                    color: Colors.blue,
                                                    borderRadius: BorderRadius.only(
                                                        bottomRight:
                                                        Radius.circular(10),
                                                        topLeft:
                                                        Radius.circular(5)))),
                                          ),
                                          Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                                              child: Column(children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                  language.text('stksummaryrly'),
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 16, fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(height: 4.0),
                                                              Text("${value.stkSummaryData[index].rlyname.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                  language.text('stksummarydept'),
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                      fontWeight:
                                                                      FontWeight.w500)),
                                                              SizedBox(height: 4.0),
                                                              Text("${value.stkSummaryData[index].subUnitName.toString()}", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: size.width * 0.30,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                    language.text(
                                                                        'unitinitprpsl'),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: 16,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                                SizedBox(height: 4.0),
                                                                Text(
                                                                    "${value.stkSummaryData[index].unitName.toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: 16))
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: size.width * 0.30,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                    language.text(
                                                                        'storedepot'),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: 16,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                                SizedBox(height: 4.0),
                                                                Text(
                                                                    "${value.stkSummaryData[index].storesDepot.toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: size.width * 0.35,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                    language.text('unifyingrly'),
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight:
                                                                        FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text(value.stkSummaryData[index].uplrly == null ? "NA" : "${value.stkSummaryData[index].uplrly.toString()}" ,
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontWeight:
                                                                        FontWeight.w400,
                                                                        fontSize: 16))
                                                              ],
                                                            ),
                                                          ),
                                                          value.stkSummaryData[index].totalCount.toString() != "0" ? InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "TOTAL_PROPOSAL_INITIATED")));
                                                            },
                                                            child: Container(
                                                              width: size.width * 0.35,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(language.text('totprpinit'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                  SizedBox(height: 4.0),
                                                                  Text("${value.stkSummaryData[index].cnt.toString()}",
                                                                      style: TextStyle(
                                                                          color: Colors.blue,
                                                                          fontWeight:
                                                                          FontWeight.w400,
                                                                          fontSize: 16))
                                                                ],
                                                              ),
                                                            ),
                                                          ) : Container(
                                                            width: size.width * 0.35,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Text(language.text('totprpinit'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text("${value.stkSummaryData[index].cnt.toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontWeight:
                                                                        FontWeight.w400,
                                                                        fontSize: 16))
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          value.stkSummaryData[index].proposalInDraftStage.toString() != "0" ? InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "PROPOSAL_IN_DRAFT_STAGE")));
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(language.text('prpindrfdatege'), style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text(value.stkSummaryData[index].proposalInDraftStage.toString(), style: TextStyle(
                                                                    color: Colors.blue, fontSize: 18))
                                                              ],
                                                            ),
                                                          ) : Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(language.text('prpindrfdatege'), style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(value.stkSummaryData[index].proposalInDraftStage.toString(), style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            value.stkSummaryData[index].proposalWithDeptts.toString() != "0" ? InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "PROPOSAL_WITH_DEPTTS")));
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(language.text('prpother'), style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text(value.stkSummaryData[index].proposalWithDeptts.toString(), style: TextStyle(
                                                                    color: Colors.blue, fontSize: 18))
                                                              ],
                                                            ),
                                                          ) : Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(language.text('prpother'), style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(value.stkSummaryData[index].proposalWithDeptts.toString(), style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          value.stkSummaryData[index].proposalWithStoreDepo.toString() != "0" ? InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "PROPOSAL_WITH_STORE_DEPO")));
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(language.text('prpstrdepot'), style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text(value.stkSummaryData[index].proposalWithStoreDepo.toString(), style: TextStyle(
                                                                    color: Colors.blue, fontSize: 18))
                                                              ],
                                                            ),
                                                          ) : Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(language.text('prpstrdepot'), style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(value.stkSummaryData[index].proposalWithStoreDepo.toString(), style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          value.stkSummaryData[index].proposalWithPcmm.toString() != "0" ? InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "PROPOSAL_WITH_PCMM")));
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(language.text('prppcm'), style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text(value.stkSummaryData[index].proposalWithPcmm.toString(), style: TextStyle(
                                                                    color: Colors.blue, fontSize: 18))
                                                              ],
                                                            ),
                                                          ) : Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(language.text('prppcm'), style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w500)),
                                                              SizedBox(height: 4.0),
                                                              Text(value.stkSummaryData[index].proposalWithPcmm.toString(), style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 16))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                            value.stkSummaryData[index].proposalWithUnifying.toString() != "0" ? InkWell(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "PROPOSAL_WITH_UNIFYING")));
                                                            },
                                                            child: Container(
                                                              width:
                                                              size.width *
                                                                  0.30,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(
                                                                      language.text(
                                                                          'prpunifrly'),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                          16,
                                                                          fontWeight:
                                                                          FontWeight.w500)),
                                                                  SizedBox(
                                                                      height:
                                                                      4.0),
                                                                  Text(
                                                                      "${value.stkSummaryData[index].proposalWithUnifying.toString()}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
                                                                          fontSize:
                                                                          18))
                                                                ],
                                                              ),
                                                            ),
                                                          ) : Container(
                                                            width: size.width * 0.30,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(language.text('prpunifrly'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text("${value.stkSummaryData[index].proposalWithUnifying.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                              ],
                                                            ),
                                                          ),
                                                          value.stkSummaryData[index].proposalRejectedUnifying != "0" ? InkWell(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "PROPOSAL_REJECTED_UNIFYING")));
                                                            },
                                                            child: Container(
                                                              width:
                                                              size.width * 0.30,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(language.text('prprejected'), style: TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.w500)),
                                                                  SizedBox(height: 4.0),
                                                                  Text(
                                                                      "${value.stkSummaryData[index].proposalRejectedUnifying.toString()}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
                                                                          fontSize:
                                                                          18)),
                                                                ],
                                                              ),
                                                            ),
                                                          ) : Container(
                                                            width: size.width *
                                                                0.30,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                    language.text(
                                                                        'prprejected'),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16,
                                                                        fontWeight:
                                                                        FontWeight.w500)),
                                                                SizedBox(
                                                                    height:
                                                                    4.0),
                                                                Text(
                                                                    "${value.stkSummaryData[index].proposalRejectedUnifying.toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                        16)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          value.stkSummaryData[index].proposalReturnedToInitiator.toString() != "0" ? InkWell(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "PROPOSAL_RETURNED_TO_INITIATOR")));
                                                            },
                                                            child: Container(
                                                              width:
                                                              size.width *
                                                                  0.30,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(language.text('prpreturned'),
                                                                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                  SizedBox(height: 4.0),
                                                                  Text("${value.stkSummaryData[index].proposalReturnedToInitiator.toString()}",
                                                                      style: TextStyle(color: Colors.blue, fontSize: 18)),
                                                                ],
                                                              ),
                                                            ),
                                                          ) : Container(width: size.width * 0.30,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(language.text('prpreturned'),
                                                                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text("${value.stkSummaryData[index].proposalReturnedToInitiator.toString()}",
                                                                    style: TextStyle(color: Colors.black, fontSize: 16)),
                                                              ],
                                                            ),
                                                          ),
                                                          value.stkSummaryData[index].stokingProposalDroped.toString() != "0" ? InkWell(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "STOKING_PROPOSAL_DROPED")));
                                                            },
                                                            child: Container(width: size.width * 0.30, child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                      language.text('stcprpdrop'),
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w500)),
                                                                  SizedBox(height: 4.0),
                                                                  Text("${value.stkSummaryData[index].stokingProposalDroped.toString()}",
                                                                      style: TextStyle(color: Colors.blue, fontSize: 18)),
                                                                ],
                                                              )),
                                                          ) : Container(
                                                            width: size.width * 0.30,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(language.text('stcprpdrop'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text("${value.stkSummaryData[index].stokingProposalDroped.toString()}", style: TextStyle(color: Colors.black, fontSize: 16)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          value.stkSummaryData[index].stokingProposalApproved.toString() != "0" ? InkWell(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(value.stkSummaryData[index].rly, value.stkSummaryData[index].subunitId, value.stkSummaryData[index].unitId,
                                                                  value.stkSummaryData[index].uplRlyId, value.stkSummaryData[index].storesDepotId, widget.fromdate, widget.todate, "STOKING_PROPOSAL_APPROVED")));
                                                            },
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Text(language.text('stkprpapp'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                SizedBox(height: 4.0),
                                                                Text("${value.stkSummaryData[index].stokingProposalApproved.toString()}", style: TextStyle(color: Colors.blue, fontSize: 18))
                                                              ],
                                                            ),
                                                          ) : Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(language.text('stkprpapp'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                                                              SizedBox(height: 4.0),
                                                              Text("${value.stkSummaryData[index].stokingProposalApproved.toString()}", style: TextStyle(color: Colors.black, fontSize: 16))
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]))
                                        ],
                                      ),
                                    ),
                                  );}
                            );
                          }
                          else if (value.stksmryDatastate == StksmryDataState.NoData) {
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
                                        TyperAnimatedText(language.text('dnf'),
                                            speed: Duration(milliseconds: 150),
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ])
                                ],
                              ),
                            );}
                          else if(value.stksmryDatastate == StksmryDataState.FinishedWithError) {
                            return Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 85,
                                      width: 85,
                                      child: Image.asset('assets/no_data.png')),
                                  InkWell(
                                    onTap: () {
                                      Provider.of<StockingProposalSummaryProvider>(context, listen: false).getStkSummaryData(widget.rly, widget.storesdepot, widget.unitinitproposal!, widget.department,
                                          widget.unifyingrly, widget.fromdate, widget.todate, context);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(language.text('badresp'),
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 16)),
                                        SizedBox(width: 2),
                                        Text(language.text('tryagain'),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );}
                          else { return SizedBox();}
                        })),
                  ],
                ),
                Consumer<StockingProposalSummaryProvider>(
                  builder: (context, value, child) {
                    return Positioned(
                      bottom: size.height * 0.08,
                      left: size.width * 0.25,
                      right: size.width * 0.25,
                      child: value.getshowhidemicglow == true ? AvatarGlow(
                        glowColor: Colors.blue.shade400,
                        endRadius: 70.0,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              icon: Icon(Icons.mic, color: Colors.white, size: 32),
                              onPressed: (){
                                //_startListening();
                              },
                            ),
                            radius: 35.0,
                          ),
                        ),
                      ) : SizedBox(),
                    );
                  },
                ),
                showtotalDialog()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showtotalDialog() {
    LanguageProvider language = Provider.of<LanguageProvider>(context, listen: false);
    return Consumer<StockingProposalSummaryProvider>(
      builder: (context, value, child) {
        return DraggableScrollableSheet(
          initialChildSize: value.expandvalue == true ? .50 : .1,
          minChildSize:  value.expandvalue == true ? .50 : .1,
          maxChildSize: .50,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFFDEDDE),
                    border: Border.all(color: Colors.red.shade200, width: 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0))),
                child: ListView(
                  //controller: scrollController,
                  physics: value.expandvalue == true ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 5.0, top: 5.0, bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(language.text('total'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () {
                                  if(value.expandvalue){
                                    value.setexpandtotal(false);
                                    Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryShowScroll(true);
                                  }
                                  else{
                                    value.setexpandtotal(true);
                                    Provider.of<StockingProposalSummaryProvider>(context, listen: false).setStkPrpSummryShowScroll(false);
                                  }
                                },
                                icon: value.expandvalue == true
                                    ? Icon(Icons.arrow_circle_down_rounded,
                                    size: 32, color: Colors.blue)
                                    : Icon(Icons.arrow_circle_up_rounded,
                                    size: 32, color: Colors.blue)
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('totprpinit'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              value.totalprposalinit == 0 ? Text("0", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)) : InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                      widget.fromdate, widget.todate, "TOTAL_PROPOSAL_INITIATED")));
                                },
                                child: Text(value.totalprposalinit.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('prpindrfdatege'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              value.prpindrfdatege == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                          widget.fromdate, widget.todate, "PROPOSAL_IN_DRAFT_STAGE")));
                                    },
                                    child: Text(value.prpindrfdatege.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(language.text('prpother'),
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 4.0),
                              value.prpother == 0 ? Text("0", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)) : InkWell(
                                      onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                          widget.fromdate, widget.todate, "PROPOSAL_WITH_DEPTTS")));
                                        },
                                      child: Text(value.prpother.toString(), style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600))
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('prpstrdepot'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              value.prpstrdepot == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                          widget.fromdate, widget.todate, "PROPOSAL_WITH_STORE_DEPO")));
                                    },
                                    child: Text(value.prpstrdepot.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('prppcm'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              value.prppcm == 0 ? Text("0",
                                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                          widget.fromdate, widget.todate, "PROPOSAL_WITH_PCMM")));
                                    },
                                    child: Text(value.prppcm.toString(), style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('prpunifrly'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              value.prpunifrly == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                          widget.fromdate, widget.todate, "PROPOSAL_WITH_UNIFYING")));
                                    },
                                    child: Text("${value.prpunifrly.toString()}",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('prprejected'), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              value.prprejected == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600))
                                  : InkWell(
                                     onTap: (){
                                       Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                           widget.fromdate, widget.todate, "PROPOSAL_REJECTED_UNIFYING")));
                                     },
                                     child: Text("${value.prprejected.toString()}", style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('prpreturned'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              value.prpreturned == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                          widget.fromdate, widget.todate, "PROPOSAL_RETURNED_TO_INITIATOR")));
                                    },
                                    child: Text("${value.prpreturned.toString()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                        fontSize: 16)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('stcprpdrop'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              value.stcprpdrop == 0
                                  ? Text("0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                          widget.fromdate, widget.todate, "STOKING_PROPOSAL_DROPED")));
                                    },
                                    child: Text("${value.stcprpdrop.toString()}",
                                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue, fontSize: 16)),
                                  )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(language.text('stkprpapp'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              value.stkprpapp == 0
                                  ? Text("0", style: TextStyle(fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16))
                                  : InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StockingProposalSummaryDatalinkScreen(widget.rly, widget.department, widget.unitinitproposal, widget.unifyingrly, widget.storesdepot,
                                          widget.fromdate, widget.todate, "STOKING_PROPOSAL_APPROVED")));
                                    },
                                    child: Text("${value.stkprpapp.toString()}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                        fontSize: 16)),
                                  )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }
}
