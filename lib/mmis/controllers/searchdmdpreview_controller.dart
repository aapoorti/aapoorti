import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/mmis/models/CrismmisDemandAllocation.dart';
import 'package:flutter_app/mmis/models/CrismmisDemandAuth.dart';
import 'package:flutter_app/mmis/models/CrismmisDemandCondition.dart';
import 'package:flutter_app/mmis/models/CrismmisDemandDoc.dart';
import 'package:flutter_app/mmis/models/CrismmisDemandHeader.dart';
import 'package:flutter_app/mmis/models/CrismmisDemandItemCon.dart';
import 'package:flutter_app/mmis/models/CrismmisDemandLPR.dart';
import 'package:flutter_app/mmis/models/CrismmisDemandLikelySupplier.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SearchdmdPreviewHeaderState {idle, loading, success, failure, failurewithexception}
enum SearchdmdPreviewLPRState {idle, loading, success, failure, failurewithexception}
enum SearchdmdPreviewlsstate {idle, loading, success, failure, failurewithexception}
enum SearchdmdPreviewDocstate {idle, loading, success, failure, failurewithexception}
enum SearchdmdPreviewConditionstate {idle, loading, success, failure, failurewithexception}
enum SearchdmdPreviewItemConstate {idle, loading, success, failure, failurewithexception}
enum SearchdmdPreviewAllocationstate {idle, loading, success, failure, failurewithexception}
enum SearchdmdPreviewAuthenticationstate {idle, loading, success, failure, failurewithexception}
class SearchdmdPreviewController extends GetxController{

  var searchdmdPreviewHeaderState = SearchdmdPreviewHeaderState.idle.obs;
  var searchdmdPreviewLPRState = SearchdmdPreviewLPRState.idle.obs;
  var searchdmdPreviewlsState = SearchdmdPreviewlsstate.idle.obs;
  var searchdmdPreviewDocState = SearchdmdPreviewDocstate.idle.obs;
  var searchdmdPreviewConditionState = SearchdmdPreviewConditionstate.idle.obs;
  var searchdmdPreviewItemConState = SearchdmdPreviewItemConstate.idle.obs;
  var searchdmdPreviewAllocationState = SearchdmdPreviewAllocationstate.idle.obs;
  var searchdmdPreviewAuthenticationState = SearchdmdPreviewAuthenticationstate.idle.obs;

  List<HeaderData> headerData = [];
  List<LPRData> lprData = [];
  List<LikelySupplierData> lsData = [];
  List<DocData> docData = [];
  List<ConditionData> conditionData = [];
  List<AllocationData> allocationData = [];
  List<ItemConData> itemConData = [];
  List<AuthData> authenticationData = [];

  Future<void> getSearchdmdPreviewHeader(String? dmdKey) async{
    searchdmdPreviewHeaderState.value = SearchdmdPreviewHeaderState.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type" : "CrisMMisDemandViewHdr",
        //"input":"176000",
        "input": dmdKey,
        "key_ver" : "V2"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response preview header ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            headerData = listJson.map<HeaderData>((val) => HeaderData.fromJson(val)).toList();
            //duplicateheaderData = listJson.map<HeaderData>((val) => HeaderData.fromJson(val)).toList();
            searchdmdPreviewHeaderState.value = SearchdmdPreviewHeaderState.success;
          }
          else{
            searchdmdPreviewHeaderState.value = SearchdmdPreviewHeaderState.failure;
            headerData = [];
          }
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          searchdmdPreviewHeaderState.value = SearchdmdPreviewHeaderState.failure;
        }
      }
      else{
        searchdmdPreviewHeaderState.value = SearchdmdPreviewHeaderState.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      searchdmdPreviewHeaderState.value = SearchdmdPreviewHeaderState.failurewithexception;
    }
  }

  Future<void> getSearchdmdPreviewLPR(String? dmdKey) async{
    debugPrint("hdhhdhdhhd $dmdKey");
    searchdmdPreviewLPRState.value = SearchdmdPreviewLPRState.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
         "input_type":"CrisMMisDemandViewLpr",
         //"input":"459791",
        "input": dmdKey,
         "key_ver":"V2"
        //"input": "${prefs.getString('userid')!}",
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response preview LPR ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            lprData = listJson.map<LPRData>((val) => LPRData.fromJson(val)).toList();
            //duplicateheaderData = listJson.map<LPRData>((val) => LPRData.fromJson(val)).toList();
            searchdmdPreviewLPRState.value = SearchdmdPreviewLPRState.success;
          }
          else{
            searchdmdPreviewLPRState.value = SearchdmdPreviewLPRState.failure;
            lprData = [];
          }
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          searchdmdPreviewLPRState.value = SearchdmdPreviewLPRState.failure;
        }
      }
      else{
        searchdmdPreviewLPRState.value = SearchdmdPreviewLPRState.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      searchdmdPreviewLPRState.value = SearchdmdPreviewLPRState.failurewithexception;
    }
  }

  Future<void> getSearchdmdPreviewLS(String? dmdKey) async{
    searchdmdPreviewlsState.value = SearchdmdPreviewlsstate.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type":"CrisMMisDemandViewLikelySplrs",
        "input": dmdKey,
        //"input":"459791",
        "key_ver":"V2"
        //"input": "${prefs.getString('userid')!}",
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response preview LPR ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            lsData = listJson.map<LikelySupplierData>((val) => LikelySupplierData.fromJson(val)).toList();
            //duplicatelsData = listJson.map<LikelySupplierData>((val) => LikelySupplierData.fromJson(val)).toList();
            searchdmdPreviewlsState.value = SearchdmdPreviewlsstate.success;
          }
          else{
            searchdmdPreviewlsState.value = SearchdmdPreviewlsstate.failure;
            lsData = [];
          }
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          searchdmdPreviewlsState.value = SearchdmdPreviewlsstate.failure;
        }
      }
      else{
        searchdmdPreviewlsState.value = SearchdmdPreviewlsstate.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      searchdmdPreviewlsState.value = SearchdmdPreviewlsstate.failurewithexception;
    }
  }

  Future<void> getSearchdmdPreviewDoc(String? dmdKey) async{
    searchdmdPreviewDocState.value = SearchdmdPreviewDocstate.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type":"CrisMMisDemandViewDocument",
        //"input":"176000",
        "input": dmdKey,
        "key_ver":"V1"
        //"input": "${prefs.getString('userid')!}",
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response preview Doc ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            docData = listJson.map<DocData>((val) => DocData.fromJson(val)).toList();
            //duplicatelsData = listJson.map<LikelySupplierData>((val) => LikelySupplierData.fromJson(val)).toList();
            searchdmdPreviewDocState.value = SearchdmdPreviewDocstate.success;
          }
          else{
            searchdmdPreviewDocState.value = SearchdmdPreviewDocstate.failure;
            docData = [];
          }
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          searchdmdPreviewDocState.value = SearchdmdPreviewDocstate.failure;
        }
      }
      else{
        searchdmdPreviewDocState.value = SearchdmdPreviewDocstate.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      searchdmdPreviewlsState.value = SearchdmdPreviewlsstate.failurewithexception;
    }
  }

  Future<void> getSearchdmdPreviewCondition(String? dmdKey) async{
    searchdmdPreviewConditionState.value = SearchdmdPreviewConditionstate.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type":"CrisMMisDemandViewConditions",
        //"input":"459791",
        "input": dmdKey,
        "key_ver":"V2"
        //"input": "${prefs.getString('userid')!}",
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response preview condition ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            conditionData = listJson.map<ConditionData>((val) => ConditionData.fromJson(val)).toList();
            //duplicatelsData = listJson.map<LikelySupplierData>((val) => LikelySupplierData.fromJson(val)).toList();
            searchdmdPreviewConditionState.value = SearchdmdPreviewConditionstate.success;
          }
          else{
            searchdmdPreviewConditionState.value = SearchdmdPreviewConditionstate.failure;
            conditionData = [];
          }
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          searchdmdPreviewConditionState.value = SearchdmdPreviewConditionstate.failure;
        }
      }
      else{
        searchdmdPreviewDocState.value = SearchdmdPreviewDocstate.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      searchdmdPreviewlsState.value = SearchdmdPreviewlsstate.failurewithexception;
    }
  }

  Future<void> getSearchdmdPreviewItemCon(String? dmdKey) async{
    searchdmdPreviewItemConState.value = SearchdmdPreviewItemConstate.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type":"CrisMMisItemAndConsignee",
        "input": dmdKey,
        "key_ver":"V2"
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response preview ItemCon ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            itemConData = listJson.map<ItemConData>((val) => ItemConData.fromJson(val)).toList();
            //duplicatelsData = listJson.map<LikelySupplierData>((val) => LikelySupplierData.fromJson(val)).toList();
            searchdmdPreviewItemConState.value = SearchdmdPreviewItemConstate.success;
          }
          else{
            searchdmdPreviewItemConState.value = SearchdmdPreviewItemConstate.failure;
            itemConData = [];
          }
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          searchdmdPreviewItemConState.value = SearchdmdPreviewItemConstate.failure;
        }
      }
      else{
        searchdmdPreviewItemConState.value = SearchdmdPreviewItemConstate.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      searchdmdPreviewItemConState.value = SearchdmdPreviewItemConstate.failurewithexception;
    }
  }

  Future<void> getSearchdmdPreviewAuthentication(String? dmdKey) async{
    searchdmdPreviewAuthenticationState.value = SearchdmdPreviewAuthenticationstate.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type":"CrisMMisDemandViewAuthentication",
        "input": dmdKey,
        "key_ver": "V2"
      }
      );
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response preview authentication ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            authenticationData = listJson.map<AuthData>((val) => AuthData.fromJson(val)).toList();
            //duplicatelsData = listJson.map<LikelySupplierData>((val) => LikelySupplierData.fromJson(val)).toList();
            searchdmdPreviewAuthenticationState.value = SearchdmdPreviewAuthenticationstate.success;
          }
          else{
            searchdmdPreviewAuthenticationState.value = SearchdmdPreviewAuthenticationstate.failure;
            authenticationData = [];
          }
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          searchdmdPreviewAuthenticationState.value = SearchdmdPreviewAuthenticationstate.failure;
        }
      }
      else{
        searchdmdPreviewAuthenticationState.value = SearchdmdPreviewAuthenticationstate.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      searchdmdPreviewAuthenticationState.value = SearchdmdPreviewAuthenticationstate.failurewithexception;
    }
  }

  Future<void> getSearchdmdPreviewAllocation(String? dmdKey) async{
    searchdmdPreviewAllocationState.value = SearchdmdPreviewAllocationstate.loading;
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P1/V1/GetData");
      final headers = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': '${prefs.getString('token')}',
      };
      final body = json.encode({
        "input_type":"CrisMMisDemandViewAllocation",
        //"input":"459791",
        "input": dmdKey,
        "key_ver":"V2"
        //"input": "${prefs.getString('userid')!}",
      });
      final response = await http.post(url, headers: headers, body: body);
      debugPrint("response preview allocation ${json.decode(response.body)}");
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success'){
        var listdata = json.decode(response.body);
        if(listdata['status'] == 'Success'){
          var listJson = listdata['data'];
          if(listJson != null) {
            allocationData = listJson.map<AllocationData>((val) => AllocationData.fromJson(val)).toList();
            //duplicatelsData = listJson.map<LikelySupplierData>((val) => LikelySupplierData.fromJson(val)).toList();
            searchdmdPreviewAllocationState.value = SearchdmdPreviewAllocationstate.success;
          }
          else{
            searchdmdPreviewAllocationState.value = SearchdmdPreviewAllocationstate.failure;
            conditionData = [];
          }
        }
        else{
          ToastMessage.error("Something went wrong, please try again");
          searchdmdPreviewAllocationState.value = SearchdmdPreviewAllocationstate.failure;
        }
      }
      else{
        searchdmdPreviewAllocationState.value = SearchdmdPreviewAllocationstate.failure;
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on Exception{
      searchdmdPreviewAllocationState.value = SearchdmdPreviewAllocationstate.failurewithexception;
    }
  }
}