import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonParamData.dart';

class AapoortiConstants{

  static final primary = Colors.lightBlue[800]!;
  static const secondary = Color(0xFF0F3773);
  static const accent = Color(0xFFF47852);
  static const textColor = Color(0xFF1a237e);
  static const cardColor1 = Color(0xFFE6E3FF);
  static const cardColor2 = Color(0xFFDAEFDC);
  static const cardColor3 = Color(0xFFFFE0B2);
  static const backgroundLight = Color(0xFFF7F7FD);
  static const dividerColor = Color(0xFFE0E0E0);
  static const darkGreen = Color(0xFF006400);

  // change for development
  static String webirepsServiceUrl = 'https://gw.crisapis.indianrail.gov.in/t/eps.cris.in/EPSGenApi/';
  static String webServiceUrl = "https://ireps.gov.in/Aapoorti/ServiceCall";
  static String webServicetrialUrl = "https://trial.ireps.gov.in/Aapoorti/ServiceCall";
  static String esbWebServiceUrl ="https://ireps.gov.in/Aapoortiesb/ServiceCall";
  // static String webServiceUrl = "https://trial.ireps.gov.in/Aapoorti/ServiceCall";
  static String contextPath = "https://ireps.gov.in";
  // static String contextPath = "https://trial.ireps.gov.in";
  static String loginUserEmailID = "";
  static String hash="";
  static List<dynamic> jsonResult1 = [];
  static String trialpath= "https://trial.ireps.gov.in/Aapoorti/ServiceCall";
  static var date = DateTime.now().toString();
  static int n = 0;
  static String ans = "true";
  static String check = '';
  static List<dynamic>? jsonResult2 = [];
  static List<dynamic> jsonResult3 = [];
  static List<dynamic> jsonResult4 = [];
  static List<dynamic> jsonResult5 = [];
  static String count = '0';
  static String count1 = '0';
  static String count2 = '0';
  static String count3 = '0';
  static var date2 = DateTime.now().toString();
  static var corr = "CORRI_DETAILS";
  static var common = CommonParamData.AucSchedCountVal;
}


