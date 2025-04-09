import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/mmis/models/oldimmsData.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum OldimmsState {Idle, Busy, Finished, NoData, Error, FinishedwithError}
class OldiMMsController extends GetxController{

  var oldimmsState = OldimmsState.Idle.obs;
  RxBool searchoption = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  List<OldImmsData> oldimmsData = [];
  List<OldImmsData> duplicateoldimmsData = [];

  Future<void> fetchOldimmsData(BuildContext context) async{
    fetchToken(context);
    oldimmsState.value = OldimmsState.Busy;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CRIS_MMIS_PENDING_DEMAND_OLD",
        //"input": '1213717',
        "input": "${prefs.getString('userid')!}",
        "key_ver" : "V1"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("old imms response ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        oldimmsData.clear();
        duplicateoldimmsData.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          debugPrint("hfhhfhfhfhhfhfh $listJson");
          if(listJson != null) {
            oldimmsData = listJson.map<OldImmsData>((val) => OldImmsData.fromJson(val)).toList();
            duplicateoldimmsData = listJson.map<OldImmsData>((val) => OldImmsData.fromJson(val)).toList();
            oldimmsState.value = OldimmsState.Finished;
          }
          else{
            oldimmsState.value = OldimmsState.NoData;
            oldimmsData = [];
          }
        }
      }
      else{
        oldimmsData.clear();
        oldimmsState.value = OldimmsState.Error;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      oldimmsState.value = OldimmsState.FinishedwithError;
    }
  }

  Future<void> changetoolbarUi(bool searchres) async{
    searchoption.value = searchres;
  }

  // --- Searching old iMMS pending case Data
  void searchingOldimmsData(String query, BuildContext context){
    oldimmsState.value = OldimmsState.Busy;
    if(query.isNotEmpty && query.length > 0) {
      try{
        Future<List<OldImmsData>> data = fetchSearchOldimmsData(duplicateoldimmsData, query);
        data.then((value) {
          oldimmsData = value.toSet().toList();
          oldimmsState.value = OldimmsState.Finished;
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      oldimmsData = duplicateoldimmsData;
      oldimmsState.value = OldimmsState.Finished;
    }
    else{
      oldimmsData = duplicateoldimmsData;
      oldimmsState.value = OldimmsState.Finished;
    }
  }

  // --- Search old iMMS pending case Data ----
  Future<List<OldImmsData>> fetchSearchOldimmsData(List<OldImmsData> data, String query) async{
    if(query.isNotEmpty){
      oldimmsData = data.where((element) => element.key1.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key2.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key3.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key4.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key5.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key6.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key7.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key8.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key9.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key10.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return oldimmsData;
    }
    else{
      return data;
    }
  }
}