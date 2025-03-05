import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/mmis/models/newCrisMmisData.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum CrisMmmisState {Idle, Busy, Finished, NoData, Error, FinishedwithError}
class CrisMMISController extends GetxController{

  var crismmisState = CrisMmmisState.Idle.obs;
  RxBool searchoption = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  List<CrisMmisData> newcrismmisData = [];
  List<CrisMmisData> duplicatenewcrismmisData = [];

  Future<void> fetchCrismmisData(BuildContext context, String postId) async{
    fetchToken(context);
    crismmisState.value = CrisMmmisState.Busy;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CRIS_MMIS_PENDING_DEMAND_NEW",
        //"input": '1213717~93257',
        "input": "${prefs.getString('userid')!}~$postId",
        "key_ver" : "V3"
      });
      debugPrint("user id ${prefs.getString('userid')!}");
      debugPrint("new cris mmis body $body");
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("new cris mmis response ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        newcrismmisData.clear();
        duplicatenewcrismmisData.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            newcrismmisData = listJson.map<CrisMmisData>((val) => CrisMmisData.fromJson(val)).toList();
            duplicatenewcrismmisData = listJson.map<CrisMmisData>((val) => CrisMmisData.fromJson(val)).toList();
            crismmisState.value = CrisMmmisState.Finished;
          }
          else{
            crismmisState.value = CrisMmmisState.NoData;
            newcrismmisData = [];
          }
        }
      }
      else{
        newcrismmisData.clear();
        crismmisState.value = CrisMmmisState.Error;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      crismmisState.value = CrisMmmisState.FinishedwithError;
    }
  }

  Future<void> changetoolbarUi(bool searchres) async{
    searchoption.value = searchres;
  }

  // --- Searching Cris mmis pending case Data
  void searchingCrismmisData(String query, BuildContext context){
    crismmisState.value = CrisMmmisState.Busy;
    if(query.isNotEmpty && query.length > 0) {
      try{
        Future<List<CrisMmisData>> data = fetchSearchnewcrismmisData(duplicatenewcrismmisData, query);
        data.then((value) {
          newcrismmisData = value.toSet().toList();
          crismmisState.value = CrisMmmisState.Finished;
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      newcrismmisData = duplicatenewcrismmisData;
      crismmisState.value = CrisMmmisState.Finished;
    }
    else{
      newcrismmisData = duplicatenewcrismmisData;
      crismmisState.value = CrisMmmisState.Finished;
    }
  }

  // --- Search Cris mmis pending case Data ----
  Future<List<CrisMmisData>> fetchSearchnewcrismmisData(List<CrisMmisData> data, String query) async{
    if(query.isNotEmpty){
      newcrismmisData = data.where((element) => element.key1.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key2.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key3.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key4.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key5.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key6.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key7.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key8.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key9.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key10.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key11.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key12.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key13.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key14.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key15.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key16.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key17.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key18.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key19.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key20.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key21.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.key22.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return newcrismmisData;
    }
    else{
      return data;
    }
  }

}