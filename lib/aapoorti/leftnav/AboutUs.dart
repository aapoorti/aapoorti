import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/home/policy_screen.dart';
import 'package:flutter_app/aapoorti/provider/aapoorti_language_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
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
    AapoortiLanguageProvider language = Provider.of<AapoortiLanguageProvider>(context);
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D47A1), // Dark Blue
                    Color(0xFF1976D2), // Lighter Blue
                  ],
                ),
              ),
              child: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: Colors.transparent, // Make AppBar background transparent
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  language.text('aboutus'),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                actions: [
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
                          language.text('irepsheading'),
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
                        language.text('aboutusdesc'),
                        style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    leading: Icon(Icons.info_outline, color: Colors.blue.shade800),
                    title: Text(language.text('nameversion')),
                    subtitle: Text('${language.text('ireps')} : v$appVersion'),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    leading: Icon(Icons.language, color: Colors.blue.shade800),
                    title: Text(language.text('website')),
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
                    title: Text(language.text('pp')),
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
                            language.text('developedby'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            language.text('cfris'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2),
                          Text(
                            language.text('goi'),
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
