import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/export.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class EDocumentsLinks extends StatefulWidget {
  final String label;

  EDocumentsLinks({required this.label});

  @override
  State<EDocumentsLinks> createState() => _EDocumentsLinksState();
}

class _EDocumentsLinksState extends State<EDocumentsLinks> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("label now ${widget.label}");
  }

  final List<Map<String, String>> emptylist = [{'title' : ''}];
  final List<Map<String, String>> generalItems = [
    {'title': 'Security Aspects for use of E-tokens'},
    {'title': 'Procedure for Public Key Export from E-token'},
    {'title': 'List of Special Characters Not Allowed as Input/Upload'},
    {'title': 'Getting Your System Ready for IREPS Application'},
    {'title': 'IREPS Security Tips'},
    {
      'title':
      'Guidelines for Procurement, Use, and Management of Encryption Certificate Version 2.0'
    },
    {'title': 'Procedure for Mapping Party Codes and Viewing Status of Bills'},
    {
      'title':
      'User Manual for Contractors/Suppliers for Online Bill Tracking Version 1.0'
    },
    {
      'title':
      'User Manual for Registration of New Vendors and Contractors Version 1.0'
    },
    {'title': 'User Manual for Creation/Change of Primary User (Vendors)'},
  ];

  final List<Map<String, String>> pdfGoodsandServices = [
    {'title': "User Manual for Vendors (Goods and Services)\nVersion 1.0"},
    {'title': "How to Turn Off Compatibility View Settings"},
    {'title': "User manual for vendors on Post Contract\nActivities"},
    {'title': "User Manual for Vendors- for Reverse Auction\n(Goods and Services Module) Version 2"},
    {'title': "User Manual for On-line Submission of\nSupplementary Bills by Vendors(Version-1.0)"}];

  final List<Map<String, String>> pdfWorks = [
    {'title': "User Manual for Contractors"},
    {'title': "User Manual for Standard Railway User\n( Version 1.0 )"},
    {'title': "User Manual for Department Admins(Version 1.0)\n( for Railway Users )"},
    {'title': "Creation and Management of SOR and NS Item\nDirectories ( for Railway Users )"},
    {'title': "User Manual for Contractors - For Two Stage\nReverse Auction (Works Module) Version 2.0"}];

  List<Map<String, String>> pdfEarningLeasing = [{'title' : "User Manual for Contractors (Earning / Leasing)\nVersion 1.0"}];

  List<Map<String, String>> pdfE_Auction = [
    {'title' : "Bidder User Manual"},
    {'title' : "Guide For SBI Corporate Account User"},
    {'title' : "User Manual of Balance Sale Value and Invoice\nGeneration"},
    {'title' : "User Manual for Bidders On Lot Publishing\nModule"}];

  List<Map<String, String>> pdf_iMMS = [
    {'title' : "User Manual for HQ users (HQ Module)"},
    {'title' : "User Manual for Depot users Depot Module)"},
    {'title' : "User Manual for Depot and Division users\n(LP Module)"},
    {'title' : "User Manual for System Administrator"},
    {'title' : "Procedure For Installation of Java And PKI Server"},
    {'title' : "Procedure For Change Digital Certificate(DSC)"}];

  List<Map<String, String>> pdfFaq = [
  {'title' : "E-Tender"},
  {'title' :  "E-Auction"},
  {'title' :  "E-Payment"}];

  //------Pdf list------
  List<String> General = [
    "https://ireps.gov.in/ireps/upload/resources/SecurityAspectofeTokens.pdf",
    "https://ireps.gov.in/ireps/upload/resources/PublicKeyExportProcess.pdf",
    "https://ireps.gov.in/ireps/upload/resources/List-Of-Special-Characters.pdf",
    "https://ireps.gov.in//ireps/upload/resources/Getting_Your_System_Ready_for_IREPS_Application_Version_2.0.pdf",
    "https://ireps.gov.in/ireps/upload/resources/SecrityTipsIREPS.pdf",
    "https://ireps.gov.in//ireps/upload/resources/Guidelines_for_Procurement_and_Management_of_DEC_Versio_2.0.pdf",
    "https://ireps.gov.in/ireps/upload/resources/Procedure_for_Mapping_Party_Codes_&_Viewing_Bills.pdf",
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Contractors-Suppliers_for_Online_Bill_Tracking_Version_1.0.pdf",
    "https://www.ireps.gov.in/ireps/upload/resources/User_Manual_for_Registration_of_New_Vendors_&_Contractors_Version_1.0.pdf",
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Creation-Change_of_Primary_User_(Vendors).pdf"
  ];
  List<String> GoodsandServices=[
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Vendors_(Goods&Services)_Version_1.0.pdf",
    "https://ireps.gov.in/ireps/upload/resources/Compatibility_View_Settings.pdf",
    "https://ireps.gov.in/ireps/upload/resources/User_manual_for_vendors_on_Post_Contract_Activities.pdf",
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Vendors_%20for_Reverse_Auction_(Goods_&_Services_Module)_Version_2.pdf",
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Supplementary_Bills_(Vendors).pdf",
  ];
  List<String> works=[
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Contractors.pdf",
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_Railway_User_Version_1.0.pdf",
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Department_Admins_Version_1.0.pdf",
    "https://ireps.gov.in//ireps/upload/resources/CM_SOR_NS_Item_DIR.pdf",
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Contractors-For_Two_Stage_Reverse_Auction_(Works_Module)_Version_2.0.pdf",

  ];
  List<String> EarningLeasing=[
    "https://ireps.gov.in/ireps/upload/resources/User_Manual_for_Contractors_(Earning-Leasing)_Version_1.0.pdf"];
  List<String> EAuction=[
    "https://ireps.gov.in/ireps/upload/resources/Bidder_manual.pdf",
    "https://ireps.gov.in/ireps/upload/resources/SBICorporateGuide.pdf",
    "https://ireps.gov.in/ireps/upload/resources/E-auction_bsvinvoice.pdf",
    "https://ireps.gov.in/ireps/upload/resources/BidderManual_LotPublishing.pdf"];
  List<String> iMMS=[
    "https://ireps.gov.in/ireps/upload/resources/iMMS_HQ_Manual.pdf",
    "https://ireps.gov.in/ireps/upload/resources/iMMS_Depot_Manual.pdf",
    "https://ireps.gov.in/ireps/upload/resources/iMMS_LP_Manual.pdf",
    "https://ireps.gov.in/ireps/upload/resources/iMMS_SYSADM_User_Manual.pdf",
    "https://ireps.gov.in/ireps/upload/resources/Procedure%20For%20Installation%20of%20Java%20And%20PkiServer.pdf",
    "https://ireps.gov.in/ireps/upload/resources/Procedure%20For%20Change%20Digital%20Certificate(DSC).pdf"];
  List<String> Faq=[
    "https://ireps.gov.in/ireps/upload/resources/FAQetenders06May10.pdf",
    "https://ireps.gov.in/ireps/upload/resources/BidderandPaymentFAQ.pdf",
    "https://ireps.gov.in/ireps/upload/resources/E-PaymentFAQ.pdf"];

  List<String> zonal_rly=["561","3482","6806","8937","31528","541","4702","401","4527","4494","562","5261","581","582","4495","601","483"];
  List<String> Production_unit=["6721","1222","831","641","501","20281","1233","43901"];
  List<String> other_units=["45221","321","55541","58281","46401","2261","31381","20504"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, "/common_screen", (route) => false);
                //Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
          backgroundColor: AapoortiConstants.primary,
          title: Text('E-Documents', style: TextStyle(color: Colors.white))),
      backgroundColor: Colors.grey[200],
      //drawer : AapoortiUtilities.navigationdrawerbeforLOgin(_scaffoldKey,context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: widget.label == "General" ? generalItems.length :
          widget.label == "Goods and services" ? pdfGoodsandServices.length :
          widget.label == "works" ? pdfWorks.length :
          widget.label == "EarningLeasing" ? pdfEarningLeasing.length :
          widget.label == "Auction" ? pdfE_Auction.length :
          widget.label == "iMMS" ? pdf_iMMS.length :
          widget.label == "Faq" ?  pdfFaq.length : 0,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = widget.label == "General" ? generalItems[index] :
            widget.label == "Goods and services" ? pdfGoodsandServices[index] :
            widget.label == "works" ? pdfWorks[index] :
            widget.label == "EarningLeasing" ? pdfEarningLeasing[index] :
            widget.label == "Auction" ? pdfE_Auction[index] :
            widget.label == "iMMS" ? pdf_iMMS[index] :
            widget.label == "Faq" ? pdfFaq[index] : emptylist[index];
            return buildListItem(context, item['title'] ?? '', index);
          },
        ),
      ),
    );
  }

  Widget buildListItem(BuildContext context, String title, int index) {
    return InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          if(Platform.isIOS){
            if(widget.label == "General"){
              var fileName = General[index].substring(General[index].lastIndexOf("/"));
              AapoortiUtilities.openPdf(context, General[index], fileName);
            }
            else if(widget.label == "Goods and services"){
              var fileName = GoodsandServices[index].substring(GoodsandServices[index].lastIndexOf("/"));
              AapoortiUtilities.openPdf(context, GoodsandServices[index], fileName);
            }
            else if(widget.label == "works"){
              var fileName = works[index].substring(works[index].lastIndexOf("/"));
              AapoortiUtilities.openPdf(context, works[index], fileName);
            }
            else if(widget.label == "EarningLeasing"){
              var fileName = EarningLeasing[index].substring(EarningLeasing[index].lastIndexOf("/"));
              AapoortiUtilities.openPdf(context, EarningLeasing[index], fileName);
            }
            else if(widget.label == "Auction"){
              var fileName = EAuction[index].substring(EAuction[index].lastIndexOf("/"));
              AapoortiUtilities.openPdf(context, EAuction[index], fileName);
            }
            else if( widget.label == "iMMS"){
              var fileName = iMMS[index].substring(iMMS[index].lastIndexOf("/"));
              AapoortiUtilities.openPdf(context, iMMS[index], fileName);
            }
            else if(widget.label == "Faq"){
              var fileName = Faq[index].substring(Faq[index].lastIndexOf("/"));
              AapoortiUtilities.openPdf(context, Faq[index], fileName);
            }
          }
          else{
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  contentPadding: EdgeInsets.all(20),
                  content: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Choose an option for file  ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "$title",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Colors.lightBlue[700],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue[700],
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if(widget.label == "General"){
                                    var fileName = General[index].substring(General[index].lastIndexOf("/"));
                                    AapoortiUtilities.downloadpdf(General[index], fileName, context);
                                  }
                                  else if(widget.label == "Goods and services"){
                                    var fileName = GoodsandServices[index].substring(GoodsandServices[index].lastIndexOf("/"));
                                    AapoortiUtilities.downloadpdf(GoodsandServices[index], fileName, context);
                                    //AapoortiUtilities.ackAlert(context,GoodsandServices[index],fileName);
                                  }
                                  else if(widget.label == "works"){
                                    var fileName = works[index].substring(works[index].lastIndexOf("/"));
                                    AapoortiUtilities.downloadpdf(works[index], fileName, context);
                                  }
                                  else if(widget.label == "EarningLeasing"){
                                    var fileName = EarningLeasing[index].substring(EarningLeasing[index].lastIndexOf("/"));
                                    AapoortiUtilities.downloadpdf(EarningLeasing[index], fileName, context);
                                  }
                                  else if(widget.label == "Auction"){
                                    var fileName = EAuction[index].substring(EAuction[index].lastIndexOf("/"));
                                    AapoortiUtilities.downloadpdf(EAuction[index], fileName, context);
                                  }
                                  else if( widget.label == "iMMS"){
                                    var fileName = iMMS[index].substring(iMMS[index].lastIndexOf("/"));
                                    AapoortiUtilities.downloadpdf(iMMS[index], fileName, context);
                                  }
                                  else if(widget.label == "Faq"){
                                    var fileName = Faq[index].substring(Faq[index].lastIndexOf("/"));
                                    AapoortiUtilities.downloadpdf(Faq[index], fileName, context);
                                  }
                                },
                                child: Text('Download'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue[700],
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if(widget.label == "General"){
                                    var fileName = General[index].substring(General[index].lastIndexOf("/"));
                                    AapoortiUtilities.openPdf(context, General[index], fileName);
                                  }
                                  else if(widget.label == "Goods and services"){
                                    var fileName = GoodsandServices[index].substring(GoodsandServices[index].lastIndexOf("/"));
                                    AapoortiUtilities.openPdf(context, GoodsandServices[index], fileName);
                                  }
                                  else if(widget.label == "works"){
                                    var fileName = works[index].substring(works[index].lastIndexOf("/"));
                                    AapoortiUtilities.openPdf(context, works[index], fileName);
                                  }
                                  else if(widget.label == "EarningLeasing"){
                                    var fileName = EarningLeasing[index].substring(EarningLeasing[index].lastIndexOf("/"));
                                    AapoortiUtilities.openPdf(context, EarningLeasing[index], fileName);
                                  }
                                  else if(widget.label == "Auction"){
                                    var fileName = EAuction[index].substring(EAuction[index].lastIndexOf("/"));
                                    AapoortiUtilities.openPdf(context, EAuction[index], fileName);
                                  }
                                  else if( widget.label == "iMMS"){
                                    var fileName = iMMS[index].substring(iMMS[index].lastIndexOf("/"));
                                    AapoortiUtilities.openPdf(context, iMMS[index], fileName);
                                  }
                                  else if(widget.label == "Faq"){
                                    var fileName = Faq[index].substring(Faq[index].lastIndexOf("/"));
                                    AapoortiUtilities.openPdf(context, Faq[index], fileName);
                                  }
                                },
                                child: Text('Open'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Text(
                '${index + 1}.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _selectedIndex == index
                      ? Colors.lightBlue[700]
                      : Colors.black54,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    color: _selectedIndex == index
                        ? Colors.lightBlue[700]
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  }
}
