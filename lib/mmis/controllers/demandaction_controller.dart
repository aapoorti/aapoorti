import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/mmis/models/DemandActionUser.dart';
import 'package:flutter_app/mmis/models/StageActionData.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum StageState {idle, loading, success, failed, failedWithError }
enum ActionState {idle, loading, success, failed, failedWithError }
enum UserState {idle, loading, success, failed, failedWithError }
class DemandActionController extends GetxController{

  var stageState = StageState.idle.obs;
  var actionState = ActionState.idle.obs;
  var userState = UserState.idle.obs;

  List<StageactionData> data = [];

  List<String> stageslist = [];
  List<String> actionlist = [];

  RxString? actionuser = 'User'.obs;
  List<ActionUser> userlist = [];

  List<String> keyList = [];
  List<String> valueList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchstageAction();
    fetchActionUser();
  }

  // Getter
  RxString? get user {
    return actionuser;
  }

  // Setter
  set name(RxString value) {
    actionuser = value;
  }

  Future<void> fetchstageAction() async{
    stageState.value = StageState.loading;
    actionState.value = ActionState.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P5/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CrisMMisDemandStageAction",
        //"input":"94~351898~1214642",
        "input": "94~614032~1214642",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response fetchstageAction ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          keyList.clear();
          valueList.clear();
          stageslist.clear();
          actionlist.clear();
          var listJson = listdata['data'];
          data = listJson.map<StageactionData>((val) => StageactionData.fromJson(val)).toList();
          debugPrint("response fetchstageAction1 ${json.decode(response.body)}");
          var resp = data[0].key1;
          if(resp!.contains('@')) {
            List<String> sections = resp.split('@');
            for (var section in sections) {
              if(section.contains('#')) {
                List<String> parts = section.split('#');
                if (parts.length == 2) {
                  keyList.add(parts[0]);
                  valueList.add(parts[1]);
                }
              }
            }
          }
          else{
            if(resp.contains('#')){
                List<String> parts = resp.split('#');
                if (parts.length == 2) {
                  keyList.add(parts[0]);
                  valueList.add(parts[1]);
                }
            }
          }
          actionlist = getSplitValue(keyList[0]);
          stageslist.addAll(keyList);
          //actionlist.addAll(result);
          debugPrint("response stagelist $keyList");
          //debugPrint("response actionlist $result");
          stageState.value = StageState.success;

        }
        else{
          stageState.value = StageState.failed;
          ToastMessage.error("Something went wrong, please try again");
        }
      }
      else{
        stageState.value = StageState.failed;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      stageState.value = StageState.failedWithError;
    }
  }

  Future<void> fetchActionUser() async{
    userState.value = UserState.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P5/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CrisMMisDemandActionUser",
        //"input": '1213717',
        "input": "94~0~93257~19~19~19~-1~93257~330",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response users ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          userlist = listJson.map<ActionUser>((val) => ActionUser.fromJson(val)).toList();
          actionuser!.value = userlist.first.key3!;
          debugPrint("response users $userlist");
          userState.value = UserState.success;
        }
        else{
          userState.value = UserState.failed;
          ToastMessage.error("Something went wrong, please try again");
        }
      }
      else{
        userState.value = UserState.failed;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      userState.value = UserState.failedWithError;
    }
  }


  List<String> getSplitValue(String key) {
    actionState.value = ActionState.loading;
    int index = keyList.indexOf(key);
    actionlist.clear();
    debugPrint("index $index");
    if(index != -1 && index < valueList.length) {
      actionlist.addAll(valueList[index].split('~'));
      actionState.value = ActionState.success;
      return valueList[index].split('~');
    } else {
      actionState.value = ActionState.failed;
      return [];
    }
  }
}