import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/mmis/db/db_models/userloginrespdb.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PendingCaseState {idle, loading, success, failure, failurewithexception}
class HomeController extends GetxController {
  late RxBool isSelected = true.obs;
  RxInt selectedIndex = 0.obs;

  //-----User Data------
  RxString username = ''.obs;
  RxString mobile = ''.obs;
  RxString email = ''.obs;

  var pendingcaseState = PendingCaseState.idle.obs;
  RxString crismmispendingcases = '0'.obs;
  RxString oldimmspendingcases = "0".obs;

  @override
  void onInit() {
    debugPrint("home init");
    getUserloginData();
    getPendingCases();
    super.onInit();
  }

  List<Map<String, String>> list = [
    {
      'icon': 'assets/images/searchdmd.jpeg',
      'label': "searchdmd".tr,
    },
    {
      'icon': 'assets/images/nonsdmd.jpeg',
      //'label': "nonstkdmd".tr
      'label' : "Coming Soon"
    },
    // {
    //   'icon': 'assets/images/stock_sm.jpg',
    //   'label': Strings.monitoring.tr
    // },
  ].obs;


  List<Map<String, String>> get getlist => list;

  void getUserloginData() async{
    final box = await Hive.openBox<UserLoginrespDb>('user');
    for (var i = 0; i < box.length; i++) {
      var userLoginrespDb = box.getAt(i);
      debugPrint("hfhfhhfh $userLoginrespDb");
      username.value = userLoginrespDb!.userName;
      mobile.value = userLoginrespDb.mobile!;
      email.value = userLoginrespDb.emailId;
    }
  }

  Future<void> getPendingCases() async{
    pendingcaseState.value = PendingCaseState.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CRIS_MMIS_AFTER_LOGIN_COUNT",
        "input": "${prefs.getString('userid')!}",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response pending case ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
           crismmispendingcases.value = listdata['data'][0]['key1'].toString();
           oldimmspendingcases.value = listdata['data'][0]['key2'].toString();
           pendingcaseState.value = PendingCaseState.success;
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          pendingcaseState.value = PendingCaseState.failure;
        }
      }
      else{
        pendingcaseState.value = PendingCaseState.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      pendingcaseState.value = PendingCaseState.failurewithexception;
    }
  }

  @override
  void dispose() async{
    //await Hive.close();
    super.dispose();
  }

}
