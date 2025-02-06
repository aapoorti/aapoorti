import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/policy_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  initState() {
    super.initState();
    versionControl();
  }

  String appVersion = '';
  void versionControl() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = "${packageInfo.version}(${packageInfo.buildNumber})";
    });

  }

  String? url;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AapoortiConstants.primary,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(child: Text('About Us', style: TextStyle(color: Colors.white))),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10), // Added space below the navbar
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/nlogo.png'),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Indian Railways E-Procurement System',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AapoortiConstants.primary)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        'This is the official mobile app of IREPS application (www.ireps.gov.in). IREPS mobile app provides information available on IREPS. IREPS application provides services related to procurement of Goods, Works and Services, Sale of Materials through the process of E-Tendering, E-Auction or Reverse Auction.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    leading: Icon(Icons.info_outline, color: Colors.blue.shade800),
                    title: Text('App Name & Version'),
                    subtitle: Text('IREPS : v$appVersion'),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    leading: Icon(Icons.language, color: Colors.blue.shade800),
                    title: Text('Website'),
                    subtitle: Text('www.ireps.gov.in'),
                    onTap: () {
                      url = "http://www.ireps.gov.in";
                      _launchURL(url!);
                    },
                  ),
                  Divider(indent: 4, endIndent: 4),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    leading: Icon(Icons.privacy_tip, color: Colors.blue.shade800),
                    title: Text('Privacy Policy'),
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => PolicyScreen()));
                    },
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/crisnew.png', height: 55, width: 55),
                          Text(
                            'Developed and Published by',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Centre for Railway Information Systems',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2),
                          Text(
                            '(An Organization of the Ministry of Railways, Govt. of India)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                            //maxLines: 1,
                            //overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _launchPolicyURL() async {
    const url = 'https://www.ireps.gov.in/html/misc/Privacy_Policy_IREPS_App_NEW.html';
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openStore() async{
     String storeUrl = '';
     if(Platform.isIOS){
       storeUrl = 'https://apps.apple.com/in/app/ireps/id1462024189';
     }
     else{
       storeUrl = "https://play.google.com/store/apps/details?id=in.gov.ireps";
     }
     if(await canLaunchUrl(Uri.parse(storeUrl))){
       await launch(storeUrl);
     }
     else{
       AapoortiUtilities.showInSnackBar(context, 'Could not launch $storeUrl');
     }
  }
}
