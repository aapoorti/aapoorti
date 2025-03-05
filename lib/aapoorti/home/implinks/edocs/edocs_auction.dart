import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'EdocsAucDetails.dart';
import 'Edocuments_func.dart';
import 'IREPSpucdocs.dart';

class DocumentSection {
  final String title;
  final IconData icon;
  final List<String> subItems;
  final List<String> rly;


  DocumentSection({
    required this.title,
    required this.icon,
    required this.subItems,
    required this.rly,
  });
}

class edocs_auction extends StatelessWidget{

  List<DocumentSection> get sections => [
    DocumentSection(
      title: 'Zonal Railways',
      icon: Icons.train,
      subItems: [
        "Central Railways","East Coast Railways","East Central Railways","Eastern Railways","Kolkata Metro",
        "North Central Railwys","North Eastern Railways","Northern Railways","North Frontier Railways","North Western Railways",
        "South Central Railways","South Eastern Railways","South East Central Railways","Southern Railways","South Western Railways",
        "West Central Railways","Western Railways"
      ],
      rly : ["561","3482","6806","8937","31528","541","4702","401","4527","4494","562","5261","581","582","4495","601","483"]
    ),
    DocumentSection(
      title: 'Production Units',
      icon: Icons.factory,
      subItems: [
        "Chittranjan Locomotive Works","Diesel Locomotive Works / Varansi","Diesel Loco Modernisation Works / Patiala",
        "Integral Coach Factory / Chennai","Rail Coach Factory / Kapurthla","Rail Coach Factory / Raebrali","Rail Wheel Factory / Banglore",
        "Rail Wheel Plant / Bela"
      ],
      rly :["6721","1222","831","641","501","20281","1233","43901"]
    ),
    DocumentSection(
      title: 'Railway Board and Other Units',
      icon: Icons.business,
      subItems: [
        "COFMOW","CRIS","Delhi Metro Rail Corp.","Konkan Railways","Mumbai Railways Vikas Corp.""Railway Board","CORE / Allahabad","RDSO"
      ],
      rly :["45221","321","55541","58281","46401","2261","31381","20504"]
    ),
    DocumentSection(
      title: 'IREPS Public Documents',
      icon: Icons.description,
      subItems: [
        'Tender Documents',
        'Auction Documents',
        'General Documents',
        'Policy Documents',
      ],
      rly:  []
    ),
  ];

  String? name;

  //List<String> zonal_rly=["561","3482","6806","8937","31528","541","4702","401","4527","4494","562","5261","581","582","4495","601","483"];
  List<String> Production_unit=["6721","1222","831","641","501","20281","1233","43901"];


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: AapoortiConstants.primary,
          title: const Text(
            'Public Documents',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(
                Icons.home,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.blueAccent,
              width: double.infinity,
              child: const Text(
                'Auction',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.blue[100]!, width: 1),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(section.icon, color: Colors.blue[800]),
                      ),
                      title: Text(
                        section.title,
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.blue[300]),
                      onTap: () {
                        if(section.title == 'IREPS Public Documents'){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => IREPSpubdocs()));
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SectionDetailPage(section: section)));
                          //_Overlaypdf(context,section.subItems,"Zonal Railways");
                        }

                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

  }

  Future _Overlaypdf(BuildContext context,List<String> pdf,String name)
  {
    this.name=name;
    return showDialog(
        context: context,
        builder: (_) => Material(
            type: MaterialType.transparency,
            child: Center(
                child:Container(
                    margin: EdgeInsets.only(top: 55),
                    padding: EdgeInsets.only( bottom: 50),
                    color: Color(0xAB000000),

                    // Aligns the container to center
                    child:Column(
                        children:<Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only( bottom: 20),
                              child: Edocuments_func.OverlayList(context,pdf,name),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child:
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                },
                                child: Image(image: AssetImage('images/close_overlay.png'), height: 50, )
                            ),

                          )
                        ]
                    )

                )
            )

        )

    );
  }
}

class SectionDetailPage extends StatelessWidget {
  final DocumentSection section;

  const SectionDetailPage({super.key, required this.section});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          section.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AapoortiConstants.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: section.subItems.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              leading: Text(
                '${index + 1}.',
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              title: Text(
                section.subItems[index],
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 16,
                ),
              ),
              onTap: () {
                //debugPrint("id here ${section.rly[index]}");
                Navigator.push(context,MaterialPageRoute(builder: (context) => EdocAucDetails(id:section.rly[index].toString())));
              },
            ),
          );
        },
      ),
    );
  }
}