import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/models/CrismmisDemandHeader.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SearchdmdPreviewState {idle, loading, success, failure, failurewithexception}
class SearchdmdPreviewController extends GetxController{

  var searchdmdPreviewState = SearchdmdPreviewState.idle.obs;

  List<HeaderData> headerData = [];
  List<HeaderData> duplicateheaderData = [];

  Future<void> getSearchdmdPreview() async{
    searchdmdPreviewState.value = SearchdmdPreviewState.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CrisMMisDemandHdr",
        "input":"176000",
        //"input": "${prefs.getString('userid')!}",
        "key_ver" : "V2"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response sdp ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            headerData = listJson.map<HeaderData>((val) => HeaderData.fromJson(val)).toList();
            duplicateheaderData = listJson.map<HeaderData>((val) => HeaderData.fromJson(val)).toList();
            searchdmdPreviewState.value = SearchdmdPreviewState.success;
          }
          else{
            searchdmdPreviewState.value = SearchdmdPreviewState.failure;
            headerData = [];
          }
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          searchdmdPreviewState.value = SearchdmdPreviewState.failure;
        }
      }
      else{
        searchdmdPreviewState.value = SearchdmdPreviewState.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      searchdmdPreviewState.value = SearchdmdPreviewState.failurewithexception;
    }
  }
}