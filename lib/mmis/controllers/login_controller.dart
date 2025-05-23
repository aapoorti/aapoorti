import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/mmis/db/db_models/userloginrespdb.dart';
import 'package:flutter_app/mmis/extention/extension_util.dart';
import 'package:flutter_app/mmis/models/OtpVerRespData.dart';
import 'package:flutter_app/mmis/services/repo/login_repo.dart';
import 'package:flutter_app/mmis/services/sharedprefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_app/mmis/models/loginResponse.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginState {idle, loading, success, failed, failedWithError }
enum ReqSetPinState {idle, loading, success, failed, failedWithError}
enum SetPinState {idle, loading, success, failed, failedWithError}
enum OtpverState {idle, loading, success, failed, failedWithError }
enum ForgetPinState {idle, loading, success, failed, failedWithError }
class LoginController extends GetxController{

  var loginState = LoginState.idle.obs;
  var otpverState = OtpverState.idle.obs;
  var reqsetpinState = ReqSetPinState.idle.obs;
  var setpinState = SetPinState.idle.obs;
  var forgetpinState = ForgetPinState.idle.obs;

  final _checkValue = false.obs;
  bool get checkValue => _checkValue.value;
  set checkValue(bool value) => _checkValue.value = value;

  final _checkValuedays = 5.obs;
  int get checkValuedays => _checkValuedays.value;
  set checkValuedays(int value) => _checkValuedays.value = value;

  final _isVisible = true.obs;
  bool get isVisible => _isVisible.value;
  set isVisible(bool value) => _isVisible.value = value;

  final _emailValue = ''.obs;
  String get emailValue => _emailValue.value;
  set emailValue(String value) => _emailValue.value = value;

  final _selectModule = ''.obs;
  String get selectModule => _selectModule.value;
  set selectModule(String value) => _selectModule.value = value;

  @override
  void onInit(){
    //change([], status: RxStatus.empty());
    super.onInit();
    loginState = LoginState.idle.obs;
    debugPrint("onInit Called");
    //autologin();
  }

  @override
  void onReady(){
    //change([], status: RxStatus.empty());
    super.onReady();
    debugPrint("onReady Called");
    //autologin();
  }

  @override
  void onClose(){
    debugPrint("onClose called");
    //Hive.close();
    loginState = LoginState.idle.obs;
    super.onClose();
  }

  Future<void> loginUsers(String email, String pin, bool isLoginSaved, int days) async  {
    try {
      loginState.value = LoginState.loading;
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      SharePreferenceService prefs = SharePreferenceService();
      List<LoginrespData> loginResponse = await LoginRepo.authenticateUser(email, pin, isLoginSaved);
      debugPrint("mmis login response email: ${loginResponse[0].emailId}");
      //debugPrint("loginC response: ${loginResponse[0].userName!.capitalizeFirstLetter()}");
      if(loginResponse.isNotEmpty){
        //ToastMessage.success("Successfully login!!");
        loginState.value = LoginState.success;
        await prefs.removePrefs();
        await prefs.setBoolValue('ismmisLoginSaved', isLoginSaved);
        await prefs.setStringValue("days", days.toString());
        await prefs.setStringValue('orgzone', loginResponse[0].orgZone!);
        await prefs.setStringValue('userid', loginResponse[0].userType!.split("~").last);
        await prefs.setStringValue('mmisemail', loginResponse[0].emailId!);
        Timer(const Duration(milliseconds: 0), () {
          Get.offAndToNamed(Routes.chooseDepartScreen);
        });
      }
      else{
        //error = 'Login failed. Please try again.';
        loginState.value = LoginState.failed;
        ToastMessage.error('Login failed. Please try again.');
        Timer(const Duration(milliseconds: 0), () {
          loginState.value = LoginState.idle;
        });
      }
    } catch (e) {
      loginState.value = LoginState.failedWithError;
      ToastMessage.error('Login failed. Please try again.');
      Timer(const Duration(milliseconds: 1000), () {
        loginState.value = LoginState.idle;
      });
    }
  }

  Future<void> verifiedOtp(String email, String otp) async{
    try {
      otpverState.value = OtpverState.loading;
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      List<OtpRespData> loginResponse = await LoginRepo.otpVerified(email, otp);
      if(loginResponse.isNotEmpty){
        ToastMessage.success("Successfully login!!");
        otpverState.value = OtpverState.success;
        Timer(const Duration(milliseconds: 1000), () {
          //Get.offAndToNamed(Routes.menuScreen);
          Get.offAndToNamed(Routes.performanceDB);
        });
      }
      else{
        //error = 'Invalid OTP, Please enter valid otp';
        otpverState.value = OtpverState.failed;
        ToastMessage.error('Invalid OTP, Please enter valid otp');
      }
    } catch (e) {
      //error = 'Login failed. Please try again.';
      otpverState.value = OtpverState.failedWithError;
      ToastMessage.error('Invalid OTP, Please enter valid otp');
    }
  }

  //"poonam.crismmis@gmail.com~919871110621~ab1298",

  Future<void> reqsetPin(String email, String mobile, String requestId, String reqtype, String moduletype, BuildContext context) async{
    reqsetpinState.value = ReqSetPinState.loading;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //https://gw.crisapis.indianrail.gov.in/t/eps.cris.in/EPSGenApi/P3/V1/GetData
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
    //var url = AapoortiConstants.webirepsServiceUrl;
    // Set the headers for the request
    //debugPrint("Token is ${prefs.getString('token')}");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    // Create the body of the request
    final body = json.encode({
      "input_type" : "APP_NEW_PIN_REQ",
      "input": "$email~91$mobile~$requestId~$moduletype",
      "key_ver" : "V1"
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        if(listJson[0]['key5'] == "You are not CRIS MMIS User."){
          reqsetpinState.value = ReqSetPinState.failed;
          ToastMessage.showSnackBar("Alert!!", listJson[0]['key5'].toString(), Colors.red.shade500);
          Future.delayed(Duration(milliseconds: 500), () {
            reqsetpinState.value = ReqSetPinState.idle;
          });
        }
        else{
          reqsetpinState.value = ReqSetPinState.success;
          String requestId = listJson[0]['key1'];
          String email = listJson[0]['key2'];
          String mobile = listJson[0]['key3'];
          Get.toNamed(Routes.setPinScreen, arguments: [email, mobile, requestId, reqtype]);
          debugPrint('req Set Pin request: ${response.body}');
        }

      } else {
        reqsetpinState.value = ReqSetPinState.failed;
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        ToastMessage.showSnackBar("Alert!!", json.decode(response.body)['status'], Colors.red.shade500);
        Future.delayed(Duration(milliseconds: 500), () {
          reqsetpinState.value = ReqSetPinState.idle;
        });
      }
    }
    on SocketException catch(ex){
      AapoortiUtilities.showInSnackBar(context, 'Please check your internet connection.');
      Future.delayed(Duration(milliseconds: 500), () {
        reqsetpinState.value = ReqSetPinState.idle;
      });
    }
    on HttpException catch(e1){}
    catch (e) {
      reqsetpinState.value = ReqSetPinState.failedWithError;
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
      Future.delayed(Duration(milliseconds: 500), () {
        reqsetpinState.value = ReqSetPinState.idle;
      });
    }
  }

  Future<void> setPin(String email, String mobile, String requestId, String otp, String confirmpin, BuildContext context) async{
    setpinState.value = SetPinState.loading;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //https://gw.crisapis.indianrail.gov.in/t/eps.cris.in/EPSGenApi/P3/V1/GetData
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
    //var url = AapoortiConstants.webirepsServiceUrl;
    // Set the headers for the request
    //debugPrint("Token is ${prefs.getString('token')}");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };
    try {
     var input = email + "#" + confirmpin;
     debugPrint("set pin input $input");
     var bytes = utf8.encode(input);
     String? cHashCode = sha256.convert(bytes).toString();
     debugPrint("set pin Hash Value: $cHashCode");

    // Create the body of the request
    final body = json.encode({
      "input_type" : "APP_PIN_SET",
      "input": "$requestId~$email~$mobile~$otp~$cHashCode",
      "key_ver" : "V1"
    });

    final response = await http.post(url, headers: headers, body: body);

    debugPrint('Set Pin response: ${response.body}');
      // Check the status code and print the response or handle errors
     if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        setpinState.value = SetPinState.success;
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        //String requestId = listJson[0]['key1'];
        //String email = listJson[0]['key2'];
        //String mobile = listJson[0]['key3'];
        if(listJson[0]['key6'].toString() == "pin has been set succesfully") {
          //ToastMessage.showSnackBar("Alert!!", listJson[0]['key6'].toString(), Colors.red.shade500);
          ToastMessage.showSnackBar("Confirmation!!", "You have successfully set you PIN for CRIS MMIS App login.", Colors.indigo.shade500);
          Future.delayed(Duration(seconds: 2), (){
            Get.toNamed(Routes.loginScreen);
          });
        }
        else{
          ToastMessage.showSnackBar("Alert!!", "Something unexpected happend! Please try again.", Colors.red.shade500);
          setpinState.value = SetPinState.idle;
        }

      }
      else {
        setpinState.value = SetPinState.failed;
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(context, json.decode(response.body)['status']);
      }
    } catch (e) {
      setpinState.value = SetPinState.failedWithError;
      debugPrint('Error occurred: $e');
      AapoortiUtilities.showInSnackBar(context, 'Something went wrong, please try later.');
    }
  }

  Future<void> foregetPin(String email, String mobile, String requestId, String otp, String confirmpin, BuildContext context) async{
    forgetpinState.value = ForgetPinState.loading;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //https://gw.crisapis.indianrail.gov.in/t/eps.cris.in/EPSGenApi/P3/V1/GetData
    final url = Uri.parse("${AapoortiConstants.webirepsServiceUrl}P3/V1/GetData");
    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': '${prefs.getString('token')}',
    };

    try {

      var input = email + "#" + confirmpin;
      debugPrint("forget pin input $input");
      var bytes = utf8.encode(input);
      String? cHashCode = sha256.convert(bytes).toString();
      debugPrint("forget pin Hash Value: $cHashCode");

      final body = json.encode({
        "input_type": "FORGET_PIN_SET",
        "input": "$requestId~$email~$mobile~$otp~$cHashCode",
        "key_ver": "V1"
      });

      // Perform the HTTP POST request
      final response = await http.post(url, headers: headers, body: body);

      debugPrint('Forget Pin request: ${response.body}');
      // Check the status code and print the response or handle errors
      if(response.statusCode == 200 && json.decode(response.body)['status'] == 'Success') {
        setpinState.value = SetPinState.success;
        var listdata = json.decode(response.body);
        var listJson = listdata['data'];
        if(listJson[0]['key6'].toString() == "User already exists please use forget/reset pin option"){
          ToastMessage.showSnackBar("Alert!!", listJson[0]['key6'].toString(), Colors.red.shade500);
        }
        else{
          ToastMessage.showSnackBar("Confirmation!!", "You have successfully set you PIN for CRIS MMIS App login.", Colors.indigo.shade500);
          Future.delayed(Duration(seconds: 2), (){
            Get.toNamed(Routes.loginScreen);
          });
        }
      }
      else {
        setpinState.value = SetPinState.failed;
        debugPrint('Request failed with status: ${response.statusCode}');
        debugPrint('Error body: ${response.body}');
        AapoortiUtilities.showInSnackBar(context, json.decode(response.body)['status']);
      }
    }
    catch(e){}
  }

  Future<void> autologin(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //var box = await Hive.openBox<UserLoginrespDb>('user');
      //emailValue = box.get(0)!.emailId.toString();
      if(prefs.containsKey('ismmisLoginSaved')) {
        if(prefs.get('ismmisLoginSaved') == true) {
          //debugPrint("last log time ${box.get(0)!.lastLogTime.toString()}");
          if(int.parse(prefs.getString("days")!) != "0") {
            loginUsers(prefs.getString('mmisemail')!, prefs.getString('mmismpin')!, true, int.parse(prefs.getString("days")!));
          }
        }
        else{
          AapoortiUtilities.showInSnackBar(context, "Please enter valid password");
        }
      }
    } on SocketException catch (err) {
      AapoortiUtilities.showInSnackBar(context, "Please check your internet connection!!");
    }
    on HttpException catch(httpExp){
      AapoortiUtilities.showInSnackBar(context, "Something went wrong, please try later!!");
    }
    on Exception catch(ex){
      AapoortiUtilities.showInSnackBar(context, "Something went wrong, please try later!!");
    }
  }

  int getDaysDifference(String dateString) {
    debugPrint("DB dateTime $dateString");
        DateFormat inputFormat = DateFormat("dd-MM-yyyy HH:mm");
        DateTime parsedDateTime = inputFormat.parse(dateString);
        DateTime currentDateTime = inputFormat.parse(inputFormat.format(DateTime.now()));
        var differenceInDays = currentDateTime.difference(parsedDateTime).inDays;
        debugPrint("difference Days $differenceInDays");
        return differenceInDays;
      }
}