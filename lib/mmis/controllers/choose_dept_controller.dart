import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/mmis/models/department.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum ChooseDeptState {idle, loading, success, failed, failedWithError }
enum SelectDeptState {idle, loading, success, failed, failedWithError }
class ChooseDeptController extends GetxController{

  var choosedeptState = ChooseDeptState.idle.obs;
  var selectdeptState = SelectDeptState.idle.obs;

  List<DepartData> departlist = [];

  @override
  void onClose(){
    debugPrint("ChooseDeptController onClose called");
    choosedeptState.value = ChooseDeptState.idle;
    super.onClose();
  }

  Future<void> fetchDepartmentCount(String userId) async{
    debugPrint("üserId $userId");
    choosedeptState.value = ChooseDeptState.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CRIS_MMIS_CHOOSE_DEPT",
        //"input": '1213717',
        "input": "$userId",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response fetchDepartmentCount ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          departlist = listJson.map<DepartData>((val) => DepartData.fromJson(val)).toList();
          choosedeptState.value = ChooseDeptState.success;
          if(departlist.length == 1){
            Future.delayed(Duration(milliseconds: 0), (){
              Get.toNamed(Routes.homeScreen, arguments: [departlist[0].key1, departlist[0].key6, departlist[0].key8,departlist[0].key9, departlist[0].key2]);
            });
          }
        }
        else{
          choosedeptState.value = ChooseDeptState.failed;
          ToastMessage.error("Something went wrong, please try again");
        }
      }
      else{
        choosedeptState.value = ChooseDeptState.failed;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      choosedeptState.value = ChooseDeptState.failedWithError;
    }
  }

  // Future<void> selectDept() async{
  //   selectdeptState.value = SelectDeptState.loading;
  //   try{
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
  //     final headers = {
  //       'accept': '*/*',
  //       'Content-Type': 'application/json',
  //       'Authorization': '${prefs.getString('token')}',
  //     };
  //     final body = json.encode({
  //       "input_type" : "CRIS_MMIS_SELECT_DEPT",
  //       "input": "",
  //       "key_ver" : "V1"
  //     });
  //     final response = await http.post(url, headers: headers, body: body);
  //     debugPrint("response sdd ${json.decode(response.body)}");
  //     if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
  //       var listdata = json.decode(response.body);
  //       if(listdata['status'] == 'Success'){
  //         selectdeptState.value = SelectDeptState.success;
  //         //ToastMessage.success("Choose Department Successfully!!");
  //         Future.delayed(Duration(milliseconds: 0), (){
  //           Get.offAndToNamed(Routes.homeScreen);
  //         });
  //       }
  //       else{
  //         selectdeptState.value = SelectDeptState.failed;
  //         ToastMessage.error("Something went wrong, please try again");
  //       }
  //     }
  //     else{
  //       selectdeptState.value = SelectDeptState.failed;
  //       //IRUDMConstants().showSnack('Data not found.', context);
  //     }
  //   }
  //   on Exception{
  //     selectdeptState.value = SelectDeptState.failedWithError;
  //   }
  // }
}