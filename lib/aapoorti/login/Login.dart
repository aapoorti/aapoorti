import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonScreen.dart';
import 'package:flutter_app/aapoorti/common/NoConnection.dart';
import 'package:flutter_app/aapoorti/localization/languageHelper.dart';
import 'package:flutter_app/aapoorti/provider/aapoorti_language_provider.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:get/get.dart';

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'home/UserHome.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_app/udm/screens/login_screen.dart';
import 'package:crypto/crypto.dart';

class LoginActivity extends StatefulWidget {
   String logoutsucc;
   final GlobalKey<ScaffoldState> _scaffoldkey;
   LoginActivity(this._scaffoldkey, this.logoutsucc);

  @override
  State<LoginActivity> createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {

  bool _obscureText = true;
  bool _rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedLoginType = 'IREPS';
  // Add selected days variable
  int _selectedDays = 5;
  // Add day options
  final List<int> _dayOptions = [5, 7, 10];

  var jsonResult = null;
  var errorcode = 0;
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  var email, pin;
  var connectivityresult;
  ProgressDialog? pr;
  bool? _check;
  bool value1 = true;
  String? checkbox;
  BuildContext? context1;
  String? logoutsucc;

  bool visibilty = false;

  // Build Remember Me Section
  Container _buildRememberMeSection(AapoortiLanguageProvider language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
          ),
          Text(language.text('slcf')),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedDays,
                items: _dayOptions.map((days) {
                  return DropdownMenuItem<int>(
                    value: days,
                    child: Text('$days ${language.text('dayskey')}'),
                  );
                }).toList(),
                onChanged: _rememberMe
                    ? (value) {
                  setState(() {
                    _selectedDays = value!;
                  });
                }
                    : null,
                style: TextStyle(
                  color: _rememberMe ? Colors.black87 : Colors.grey,
                  fontSize: 14,
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        logoutsucc = widget.logoutsucc;

        pr = ProgressDialog(context);
        debugPrint('logoutsucc' + widget.logoutsucc);
        debugPrint("init ==" + AapoortiConstants.loginUserEmailID);
      });
    });

    // Add listener to check input length
    _passwordController.addListener(() {
      if (_passwordController.text.length >= 6) {
        // Scroll up when input has 6 or more digits
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void showDialogBox(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                    "For better experience to users, login on APP is allowed using Email ID & PIN.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text(
                  "Please visit www.ireps.gov.in to create/reset your PIN and then try to login using Email ID and PIN.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text(
                  "If successfully logged in using Email ID & PIN, please ignore this.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.blue,
              child: Text(
                "OKAY",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
  }

  Future<void> _enableloginBottomSheet(BuildContext context, AapoortiLanguageProvider language) async {
    return await showModalBottomSheet(
        context: context,
        constraints:
        BoxConstraints.loose(Size(MediaQuery.of(context).size.width, 415)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        clipBehavior: Clip.hardEdge,
        builder: (_) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12.0)),
                        alignment: Alignment.center,
                        child: Icon(Icons.clear, size: 15, color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            " ${language.text('note')}: ",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.red),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Expanded(
                              child: Text(
                                  "1. ${language.text('loginfeature')}.",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ))),
                          Padding(padding: EdgeInsets.only(left: 20.0)),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Text(
                              "2. ${language.text('lfama')}:\n",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              )
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                              padding:
                              EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 10.0)),
                          //Padding(padding: new EdgeInsets.only(top:1.0)),
                          RichText(
                            text: TextSpan(
                              text: language.text('vendor'),
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                    '                              Launched',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[500],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                              padding:
                              EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 10.0)),
                          RichText(
                            text: TextSpan(
                              text: language.text('rut'),
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '     Launched',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[500],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 10.0)),
                          RichText(
                            text: TextSpan(
                              text: language.text('ruu'),
                              style: TextStyle(fontSize:15.0,color: Colors.blueGrey),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '        Launched',
                                    style: TextStyle(fontWeight: FontWeight.bold,color:Colors.green[500])
                                ),
                              ],
                            ),
                          ),/*//Padding(padding: new EdgeInsets.only(top:1.0)),
                            Text("Bidder",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),*/
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(8.0)),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "   ${language.text('telafi')}: ",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      //new Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 30.0)),
                          Text("1. ${language.text('websitelink')}",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                              )),
                          Padding(padding: EdgeInsets.only(left: 35.0)),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 30.0)),
                          Expanded(
                            child: Text(
                                '2. ${language.text('lafi')}',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blueGrey,
                                )),
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                      Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 30.0)),
                          Expanded(child: Text("3. ${language.text('ctp')}.",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blueGrey,
                              ))),
                        ],
                      ),
                      //Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _resetpinBottomSheet(BuildContext context, AapoortiLanguageProvider language) async {
    return await showModalBottomSheet(
        context: context,
        constraints:
        BoxConstraints.loose(Size(MediaQuery.of(context).size.width, 200)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        clipBehavior: Clip.hardEdge,
        builder: (_) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("${language.text('toresetpin')}: ",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.normal)),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12.0)),
                            alignment: Alignment.center,
                            child: Icon(Icons.clear,
                                size: 15, color: Colors.white),
                          ))
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Text("1. ${language.text('websitelink')}",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blueGrey,
                          )),
                      Padding(padding: EdgeInsets.only(left: 35.0)),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Expanded(
                        child: Text(
                            "2. ${language.text('goto')}",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.blueGrey,
                            )),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10.0)),
                      Expanded(
                          child: Text(
                              "3. ${language.text('selresetpin')}.",
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.blueGrey))),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  String? hashPassOutput;
  String? hash2;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userType = "";

  Future<bool> _callLoginWebService(String email, String pin) async {
    debugPrint('Function called ' + email.toString() + "-------" + pin.toString());
    try {
      var input = email + "#" + pin;
      debugPrint(input);
      var hashPassInput = <String, String>{"input": input};
      var bytes = utf8.encode(input);
      hash2 = sha256.convert(bytes).toString();
      debugPrint(hash2);
      AapoortiConstants.hash = '' + "~" + hash2!;
      var random = Random.secure();
      String ctoken = random.nextInt(100).toString();

      for (var i = 1; i < 10; i++) {
        ctoken = ctoken + random.nextInt(100).toString();
      }

      //JSON VALUES FOR POST PARAM
      Map<String, dynamic> urlinput = {
        "userId": "$email",
        "pass": "" + "~$hash2",
        "cToken": "$ctoken",
        "sToken": "",
        "os": "Flutter~ios",
        "token4": "",
        "token5": ""
      };
      // Map<String, dynamic>  urlinput = {"userId":"$email","pass":"$hashPassOutput","cToken":"$ctoken","sToken":"","os":"Flutter","token4":"","token5":""};

      String urlInputString = json.encode(urlinput);
      debugPrint("login url input ${urlinput.toString()}");

      //NAME FOR POST PARAM
      String paramName = 'UserLogin';

      //Form Body For URL
      String formBody = paramName + '=' + Uri.encodeQueryComponent(urlInputString);

      var url = AapoortiConstants.webServiceUrl + 'Login/UserLogin';

      debugPrint("url = " + url);

      final response = await http.post(Uri.parse(url),
       headers: {
         "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
      },
       body: formBody,
       encoding: Encoding.getByName("utf-8"));
      jsonResult = json.decode(response.body);
      debugPrint("form body = " + json.encode(formBody).toString());
      debugPrint("json result = " + jsonResult.toString());
      debugPrint("response code = " + response.statusCode.toString());

      AapoortiUtilities.stopProgress(pr!);
      if(response.statusCode == 200) {
        debugPrint("Error code " + jsonResult[0]['ErrorCode'].toString());
        if (jsonResult[0]['ErrorCode'] == null) {
          AapoortiConstants.loginUserEmailID = email;
          AapoortiUtilities.setUserDetails(jsonResult); //To save user details in shared object
          userType = jsonResult[0]['USER_TYPE'].toString();
          return true;
        }
        else
          return false;
      }
      else
        return false;
    } on PlatformException catch (e) {
      AapoortiUtilities.stopProgress(pr!);
      AapoortiUtilities.showInSnackBar(context, "Something unexpected happened, please try again");
    }
    on FormatException catch (ex) {
      AapoortiUtilities.stopProgress(pr!);
      AapoortiUtilities.showInSnackBar(
          context, "Something unexpected happened, please try again");
    }
    on Exception catch(exc){
      AapoortiUtilities.stopProgress(pr!);
      AapoortiUtilities.showInSnackBar(context, "Something unexpected happened, please try again");
    }
    return false;
  }

  void validateAndLogin(int days) async {
    var res;
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AapoortiUtilities.getProgressDialog(pr!);
      _check = await _callLoginWebService(email, pin);
      res = _check;
      debugPrint("res return ${res.toString()}");
      if(res == true) {
        debugPrint("res return1 ${res.toString()}");
        _check = true;
        AapoortiUtilities.loggedin = false;
        Navigator.pop(context);


        AapoortiConstants.ans = "true";
        if(_rememberMe == true) checkbox = "true";
        else checkbox = "false";
        AapoortiConstants.check = checkbox!;
        AapoortiConstants.date = DateTime.now().add(Duration(days: days)).toString();
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserHome(userType, email)));
      } else {
        debugPrint("res return3 ${res.toString()}");
        AapoortiUtilities.stopProgress(pr!);
        AapoortiUtilities.showInSnackBar(context, 'Invalid Credentials!');
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AapoortiLanguageProvider language = Provider.of<AapoortiLanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: InkWell(
        onTap: (){
          FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside
        },
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //const SizedBox(height: 40),
                    Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/nlogo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        language.text('irepsheading'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1565C0),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Updated Login Type Selector
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _LoginTypeButton(
                              title: language.text('ireps'),
                              isSelected: _selectedLoginType == 'IREPS',
                              onTap: () {
                                setState(() {
                                  _selectedLoginType = 'IREPS';
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: _LoginTypeButton(
                              title: language.text('udmtitle'),
                              isSelected: _selectedLoginType == 'UDM',
                              onTap: () {
                                setState(() {
                                  _selectedLoginType = 'UDM';
                                });
                                Navigator.pushNamed(context, LoginScreen.routeName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Email Field
                    TextFormField(
                      //controller: _emailController,
                      initialValue: AapoortiConstants.loginUserEmailID != "" ? AapoortiConstants.loginUserEmailID : '',
                      validator: (value) {
                        // bool emailValid = RegExp("^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                        bool emailValid = RegExp("^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})\$").hasMatch(value!.trim());
                        if(value.isEmpty) {
                          return (language.text('evalidemail'));
                        } else if (!emailValid) {
                          return (language.text('evalidemail'));
                        }
                        return null;
                        },
                      onSaved: (value) {
                        email = value!.trim();
                      },
                      decoration: InputDecoration(
                        labelText: language.text('email'),
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    // PIN Field with numeric keyboard
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: language.text('enterpin'),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText: _obscureText,
                      keyboardType: TextInputType.number,
                      initialValue: null,
                      validator: (pin) {
                        if (pin!.isEmpty) {
                          return (language.text('digitpin'));
                        } else if (pin.length < 6 || pin.length > 12) {
                          return (language.text('digitpin'));
                        }
                        return null;
                        },
                      onSaved: (value) {
                        pin = value;
                      },
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 16),
                    // Remember Me Section with Days Selection
                    _buildRememberMeSection(language),
                    const SizedBox(height: 24),
                    // Login Button
                    ElevatedButton(
                      onPressed: () async{
                        FocusScope.of(context).unfocus();
                        try {
                          connectivityresult = await InternetAddress.lookup('google.com');
                          if(connectivityresult != null) {
                            validateAndLogin(_selectedDays);
                          }
                        } on SocketException catch (_) {
                          AapoortiUtilities.showInSnackBar(context, language.text('connectionissue'));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        language.text('login'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Help Links
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _enableloginBottomSheet(context, language);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              language.text('ela'),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _resetpinBottomSheet(context, language);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              language.text('resetpin'),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginTypeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LoginTypeButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// class LoginActivity extends StatefulWidget {
//   String logoutsucc;
//   final GlobalKey<ScaffoldState> _scaffoldkey;
//   LoginActivity(this._scaffoldkey, this.logoutsucc);
//
//   @override
//   _LoginActivityState createState() => _LoginActivityState();
// }
//
// class _LoginActivityState extends State<LoginActivity> {
//   var jsonResult = null;
//   var errorcode = 0;
//   TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
//   var email, pin;
//   var connectivityresult;
//   ProgressDialog? pr;
//   bool? _check;
//   bool value1 = true;
//   bool _check1 = false;
//   String? checkbox;
//   BuildContext? context1;
//   String? logoutsucc;
//
//   bool visibilty = false;
//
//   String? selectedValue = 'IREPS';
//
//   initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       setState(() {
//         logoutsucc = widget.logoutsucc;
//
//         pr = ProgressDialog(context);
//         debugPrint('logoutsucc' + widget.logoutsucc);
//         debugPrint("init ==" + AapoortiConstants.loginUserEmailID);
//       });
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//   }
//
//   void showDialogBox(BuildContext context1) {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await showDialog<String>(
//         barrierDismissible: false,
//         context: context1,
//         builder: (BuildContext context) => AlertDialog(
//           content: Container(
//             height: MediaQuery.of(context).size.height * 0.32,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                     "For better experience to users, login on APP is allowed using Email ID & PIN.",
//                     textAlign: TextAlign.justify,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15,
//                     )),
//                 Padding(
//                   padding: EdgeInsets.only(top: 10),
//                 ),
//                 Text(
//                   "Please visit www.ireps.gov.in to create/reset your PIN and then try to login using Email ID and PIN.",
//                   textAlign: TextAlign.justify,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 10),
//                 ),
//                 Text(
//                   "If successfully logged in using Email ID & PIN, please ignore this.",
//                   textAlign: TextAlign.justify,
//                   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             MaterialButton(
//               color: Colors.blue,
//               child: Text(
//                 "OKAY",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 15),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//
//   static const platform = const MethodChannel('MyNativeChannel');
//   String? hashPassOutput;
//   String? hash2;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   // final GlobalKey<ScaffoldState> _scaffoldkey=new GlobalKey<ScaffoldState>();
//   String userType = "";
//
//   Future<bool> _callLoginWebService(String email, String pin) async {
//     debugPrint('Function called ' + email.toString() + "-------" + pin.toString());
//     try {
//       var input = email + "#" + pin;
//       debugPrint(input);
//       var hashPassInput = <String, String>{"input": input};
//       var bytes = utf8.encode(input);
//       hash2 = sha256.convert(bytes).toString();
//       debugPrint(hash2);
//       AapoortiConstants.hash = '' + "~" + hash2!;
//     } on PlatformException catch (e) {
//       debugPrint("Failed to get data from native : '${e.message}'.");
//     }
//     var random = Random.secure();
//     String ctoken = random.nextInt(100).toString();
//
//     for (var i = 1; i < 10; i++) {
//       ctoken = ctoken + random.nextInt(100).toString();
//     }
//
//     //JSON VALUES FOR POST PARAM
//     Map<String, dynamic> urlinput = {
//       "userId": "$email",
//       "pass": "" + "~$hash2",
//       "cToken": "$ctoken",
//       "sToken": "",
//       "os": "Flutter~ios",
//       "token4": "",
//       "token5": ""
//     };
//     // Map<String, dynamic>  urlinput = {"userId":"$email","pass":"$hashPassOutput","cToken":"$ctoken","sToken":"","os":"Flutter","token4":"","token5":""};
//
//     String urlInputString = json.encode(urlinput);
//     debugPrint("login url input ${urlinput.toString()}");
//
//     //NAME FOR POST PARAM
//     String paramName = 'UserLogin';
//
//     //Form Body For URL
//     String formBody = paramName + '=' + Uri.encodeQueryComponent(urlInputString);
//
//     var url = AapoortiConstants.webServiceUrl + 'Login/UserLogin';
//
//     debugPrint("url = " + url);
//
//     final response = await http.post(Uri.parse(url),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/x-www-form-urlencoded"
//     },
//     body: formBody,
//     encoding: Encoding.getByName("utf-8"));
//     jsonResult = json.decode(response.body);
//     debugPrint("form body = " + json.encode(formBody).toString());
//     debugPrint("json result = " + jsonResult.toString());
//     debugPrint("response code = " + response.statusCode.toString());
//
//     AapoortiUtilities.stopProgress(pr!);
//     if(response.statusCode == 200) {
//       debugPrint("Error code "+jsonResult[0]['ErrorCode'].toString());
//       if (jsonResult[0]['ErrorCode'] == null) {
//         AapoortiUtilities.setUserDetails(jsonResult); //To save user details in shared object
//         userType = jsonResult[0]['USER_TYPE'].toString();
//         return true;
//       }
//       else
//         return false;
//     }
//     else
//       return false;
//   }
//
//   void validateAndLogin() async {
//     var res;
//     if(_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       AapoortiUtilities.getProgressDialog(pr!);
//       _check = await _callLoginWebService(email, pin);
//       res = _check;
//       debugPrint("res return ${res.toString()}");
//       if(res == true) {
//         debugPrint("res return1 ${res.toString()}");
//         _check = true;
//         AapoortiUtilities.loggedin = false;
//         Navigator.pop(context);
//
//
//         AapoortiConstants.ans = "true";
//         if(_check1 == true) checkbox = "true";
//         else checkbox = "false";
//         AapoortiConstants.check = checkbox!;
//         AapoortiConstants.date = DateTime.now().add(Duration(days: 5)).toString();
//         Navigator.push(context, MaterialPageRoute(builder: (context) => UserHome(userType, email)));
//       } else {
//         debugPrint("res return3 ${res.toString()}");
//         AapoortiUtilities.stopProgress(pr!);
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       decoration: BoxDecoration(color: Colors.grey.shade100),
//       child: Center(child: SingleChildScrollView(child: Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Card(
//                         color: Colors.white,
//                         surfaceTintColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                           side: BorderSide(color: AapoortiConstants.primary, width: 1),
//                         ),
//                         child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   SizedBox(height: 25.0),
//                                   if(AapoortiUtilities.logoutBanner) AapoortiUtilities.customTextView(logoutsucc != null ? logoutsucc! : '', Colors.red),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                                     child: Text("Indian Railways e-procurement System(IREPS)", textAlign: TextAlign.center, style: TextStyle(color: AapoortiConstants.primary, fontWeight: FontWeight.bold)),
//                                   ),
//                                   SizedBox(height: 20.0),
//                                   Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                       children: [
//                                         InkWell(
//                                           onTap: (){},
//                                           child: Container(
//                                             height: 45,
//                                             width: 120,
//                                             decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.circular(8.0),
//                                                 //border: Border.all(color: AapoortiConstants.primary!, strokeAlign: 1.0)
//                                             ),
//                                             child: RadioOption(
//                                               value: 'IREPS',
//                                               groupValue: selectedValue,
//                                               onChanged: (String? newValue) {},
//                                               label: 'IREPS',
//                                             ),
//                                           ),
//                                         ),
//                                         //SizedBox(width: 40.0),
//                                         InkWell(
//                                           onTap: (){
//                                             setState(() {
//                                               selectedValue = 'UDM';
//                                             });
//                                             Navigator.pushNamed(context, LoginScreen.routeName);
//                                           },
//                                           child: Container(
//                                             height: 45,
//                                             width: 120,
//                                             decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.circular(8.0),
//                                                 //border: Border.all(color: AapoortiConstants.primary!, strokeAlign: 1.0)
//                                             ),
//                                             child: RadioOption(
//                                               value: 'UDM',
//                                               groupValue: selectedValue,
//                                               onChanged: (String? newValue) {
//                                                 setState(() {
//                                                   selectedValue = newValue;
//                                                 });
//                                                 Navigator.pushNamed(context, LoginScreen.routeName);
//                                               },
//                                               label: 'UDM',
//                                             ),
//                                           ),
//                                         ),
//                                       ]),
//                                   SizedBox(height: 15),
//                                   //SizedBox(height: 30.0),
//                                   TextFormField(
//                                     initialValue: AapoortiConstants.loginUserEmailID != "" ? AapoortiConstants.loginUserEmailID : null,
//                                     validator: (value) {
//                                       // bool emailValid = RegExp("^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
//                                       bool emailValid = RegExp(
//                                           "^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})\$")
//                                           .hasMatch(value!.trim());
//                                       if (value.isEmpty) {
//                                         return ('Please enter valid Email-ID');
//                                       } else if (!emailValid) {
//                                         return ('Please enter valid Email-ID');
//                                       }
//                                       return null;
//                                     },
//                                     onSaved: (value) {
//                                       email = value!.trim();
//                                     },
//                                     style: style,
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                                       prefixIcon: Icon(Icons.mail),
//                                       focusColor: Colors.red.shade800,
//                                       border: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                       enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                       errorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                       labelText: 'User ID' + '/' + 'Email ID',
//                                       labelStyle: TextStyle(fontSize: 15.0),
//                                       hintText: "Enter Registered Email ID",
//                                       // icon: Icon(
//                                       //   Icons.mail,
//                                       //   color: Colors.black,
//                                       // ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 30.0),
//                                   TextFormField(
//                                     initialValue: null,
//                                     keyboardType: TextInputType.number,
//                                     validator: (pin) {
//                                       if (pin!.isEmpty) {
//                                         return ('Please enter 6-12 digit PIN');
//                                       } else if (pin.length < 6 || pin.length > 12) {
//                                         return ('Please enter 6-12 digit PIN');
//                                       }
//                                       return null;
//                                     },
//                                     onSaved: (value) {
//                                       pin = value;
//                                     },
//                                     obscureText: visibilty,
//                                     style: style,
//                                     decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                                       hintText: "Enter PIN",
//                                       labelText: 'Enter PIN',
//                                       prefixIcon: Icon(Icons.vpn_key),
//                                       suffixIcon: InkWell(
//                                         onTap: (){
//                                           if(visibilty == true){
//                                             setState(() {
//                                               visibilty = false;
//                                             });
//                                           }
//                                           else{
//                                             setState(() {
//                                               visibilty = true;
//                                             });
//                                           }
//                                         },
//                                         child: visibilty == true ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off),
//                                       ),
//                                       labelStyle: TextStyle(fontSize: 15),
//                                       focusColor: Colors.red.shade800,
//                                       enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                       border: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.grey.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                       errorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
//                                           borderRadius: BorderRadius.circular(10.0)
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10.0,
//                                   ),
//                                   Padding(padding: EdgeInsets.only(left: 3)),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Row(
//                                         children: <Widget>[
//                                           Column(
//                                             children: <Widget>[
//                                               Checkbox(
//                                                   value: _check1,
//                                                   onChanged: (bool? value) {
//                                                     setState(() {
//                                                       _check1 = value!;
//                                                     });
//                                                   })
//                                             ],
//                                           ),
//                                           Padding(padding: EdgeInsets.only(left: 3)),
//                                           InkWell(
//                                             child:
//                                             Text("Save Login Credentials for 5 days "),
//                                             onTap: () {
//                                               onChanged(value1);
//                                               value1 = !value1;
//                                             },
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 60,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10.0),
//                                         gradient: LinearGradient(
//                                             begin: Alignment.topCenter,
//                                             end: Alignment.bottomCenter,
//                                             stops: [
//                                               0.1,
//                                               0.3,
//                                               0.5,
//                                               0.7,
//                                               0.9
//                                             ],
//                                             colors: [
//                                               Colors.teal[400]!,
//                                               Colors.teal[400]!,
//                                               Colors.teal[800]!,
//                                               Colors.teal[400]!,
//                                               Colors.teal[400]!,
//                                             ]),
//                                       ),
//                                       child: MaterialButton(
//                                         minWidth: 350,
//                                         height: 60,
//                                         padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
//                                         onPressed: () async {
//                                           FocusScope.of(context).unfocus();
//                                           try {
//                                             connectivityresult = await InternetAddress.lookup('google.com');
//                                             if (connectivityresult != null) {
//                                               validateAndLogin();
//                                             }
//                                           } on SocketException catch (_) {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         NoConnection()));
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(SnackBar(
//                                               content: Text(
//                                                   "You are not connected to the internet!"),
//                                               duration: const Duration(seconds: 1),
//                                               backgroundColor: Colors.red[800],
//                                             ));
//                                           }
//                                         },
//                                         child: Text("Login",
//                                             textAlign: TextAlign.center,
//                                             style: style.copyWith(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 18)),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 20.0),
//                                   // Row(
//                                   //   mainAxisAlignment: MainAxisAlignment.center,
//                                   //   mainAxisSize: MainAxisSize.min,
//                                   //   children: [
//                                   //     TextButton ( onPressed: (){
//                                   //       Get.toNamed(Routes.reqsetPinScreen, arguments: ['0']);
//                                   //     },
//                                   //         style: TextButton.styleFrom(
//                                   //           padding: EdgeInsets.zero,
//                                   //         ),
//                                   //         child: Text('Set PIN for IREPS', style:
//                                   //         TextStyle(fontFamily: 'Roboto', decorationColor: Color(0xFF007BFF),  decoration: TextDecoration.underline, color: Color(0xFF007BFF), fontSize: 14, fontWeight: FontWeight.bold))),
//                                   //     SizedBox(width: 15),
//                                   //     Row(
//                                   //       children: [
//                                   //         Container(
//                                   //           height: 15,  // Line thickness
//                                   //           width: 1.5, // Length of the line
//                                   //           color: Colors.blueGrey, // Line color
//                                   //         ),
//                                   //         SizedBox(width: 5),
//                                   //         Container(
//                                   //           height: 15,  // Line thickness
//                                   //           width: 1.5, // Length of the line
//                                   //           color: Colors.blueGrey, // Line color
//                                   //         ),
//                                   //       ],
//                                   //     ),
//                                   //     SizedBox(width: 15),
//                                   //     TextButton(
//                                   //         onPressed: (){
//                                   //           Get.toNamed(Routes.reqsetPinScreen, arguments: ['1']);
//                                   //         },
//                                   //         style: TextButton.styleFrom(
//                                   //           padding: EdgeInsets.zero, // No padding
//                                   //         ),
//                                   //         child: Text('Forgot PIN', style:
//                                   //         TextStyle(fontFamily: 'Roboto', decorationColor: Color(0xFFDC3545), decoration: TextDecoration.underline, color: Color(0xFFDC3545), fontSize: 14, fontWeight: FontWeight.bold)
//                                   //         )),
//                                   //   ],
//                                   // ),
//                                   InkWell(
//                                       child: RichText(
//                                         text: TextSpan(
//                                           text: 'How to ',
//                                           style: TextStyle(
//                                             decoration: TextDecoration.underline,
//                                             color: Colors.teal[900],
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(
//                                                 text: 'enable login ',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   decoration: TextDecoration.underline,
//                                                   color: Colors.teal[900],
//                                                 )),
//                                             TextSpan(text: 'access for IREPS App?'),
//                                           ],
//                                         ),
//                                       ),
//                                       onTap: () {
//                                         _enableloginBottomSheet(context);
//                                         //Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
//                                       }),
//                                   SizedBox(height: 20.0),
//                                   InkWell(
//                                       child: RichText(
//                                         text: TextSpan(
//                                           text: 'How to ',
//                                           style: TextStyle(
//                                             decoration: TextDecoration.underline,
//                                             color: Colors.teal[900],
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(
//                                                 text: 'reset PIN? ',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   decoration: TextDecoration.underline,
//                                                   color: Colors.teal[900],
//                                                 )),
//                                           ],
//                                         ),
//                                       ),
//                                       onTap: () {
//                                         _resetpinBottomSheet(context);
//                                         //Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPIN()));
//                                       }),
//                                   SizedBox(height: 5.0),
//                                 ],
//                               ),
//                             )),
//                       ),
//                       Positioned(right: 45, left: 45, top: -30, child: Image.asset('assets/nlogo.png', height: 75, width: 75))
//                     ],
//                   )
//
//                 ],
//               ),
//             ),
//       ))),
//       // ),
//     );
//   }
//
//   onChanged(value1) {
//     debugPrint(value1);
//     setState(() {
//       _check1 = value1;
//       debugPrint(value1);
//     });
//   }
//
//   final snackbar = SnackBar(
//     backgroundColor: Colors.redAccent[100],
//     content: Container(
//       child: Text(
//         'Invalid Credentials!',
//         style: TextStyle(
//             fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
//       ),
//     ),
//     duration: Duration(seconds: 2),
//   );
//
//   final snackbar1 = SnackBar(
//     backgroundColor: Colors.redAccent[100],
//     content: Container(
//       child: Text('Internet not available', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white)),
//     ),
//     duration: Duration(seconds: 2),
//   );
//
//   Future<Widget> _enableloginBottomSheet(BuildContext context) async {
//     return await showModalBottomSheet(
//         context: context,
//         constraints:
//         BoxConstraints.loose(Size(MediaQuery.of(context).size.width, 400)),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             )),
//         clipBehavior: Clip.hardEdge,
//         builder: (_) {
//           return Container(
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(color: Colors.white),
//             child: Column(
//               children: [
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         height: 25,
//                         width: 25,
//                         decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius: BorderRadius.circular(12.0)),
//                         alignment: Alignment.center,
//                         child: Icon(Icons.clear, size: 15, color: Colors.white),
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: Column(
//                     children: <Widget>[
//                       Row(
//                         children: <Widget>[
//                           Text(
//                             " Note: ",
//                             style: TextStyle(
//                                 fontSize: 15.0,
//                                 fontWeight: FontWeight.normal,
//                                 color: Colors.red),
//                           )
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Padding(padding: EdgeInsets.only(left: 5.0)),
//                           Expanded(
//                               child: Text(
//                                   "1. Login feature is available to users already \n    registered in IREPS.",
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: Colors.black,
//                                   ))),
//                           Padding(padding: EdgeInsets.only(left: 20.0)),
//                         ],
//                       ),
//                       Padding(
//                           padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
//                       Row(
//                         children: <Widget>[
//                           Padding(padding: EdgeInsets.only(left: 5.0)),
//                           Text(
//                               "2. Login feature is available on Mobile App for:\n",
//                               style: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Colors.black,
//                               )
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Padding(
//                               padding:
//                               EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 10.0)),
//                           //Padding(padding: new EdgeInsets.only(top:1.0)),
//                           RichText(
//                             text: TextSpan(
//                               text: 'Vendor',
//                               style: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Colors.blueGrey,
//                               ),
//                               children: <TextSpan>[
//                                 TextSpan(
//                                     text:
//                                     '                              Launched',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green[500],
//                                     )),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Padding(
//                               padding:
//                               EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 10.0)),
//                           RichText(
//                             text: TextSpan(
//                               text: 'Railway User(Tender)',
//                               style: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Colors.blueGrey,
//                               ),
//                               children: <TextSpan>[
//                                 TextSpan(
//                                     text: '     Launched',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green[500],
//                                     )),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       // Row(
//                       //   children: <Widget>[
//                       //     Padding(padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 10.0)),
//                       //     RichText(
//                       //       text: TextSpan(
//                       //         text: 'Bidder',
//                       //         style: TextStyle(fontSize:15.0,color: Colors.blueGrey,),
//                       //         children: <TextSpan>[
//                       //           TextSpan(
//                       //               text: '                               Coming Soon',
//                       //               style: TextStyle(color: Colors.redAccent,)
//                       //           ),
//                       //         ],
//                       //       ),
//                       //     ),/*//Padding(padding: new EdgeInsets.only(top:1.0)),
//                       //       Text("Bidder",style: TextStyle(fontSize:15.0,color: Colors.blueGrey,)),*/
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: Column(
//                     children: <Widget>[
//                       Padding(padding: EdgeInsets.all(8.0)),
//                       Row(
//                         children: <Widget>[
//                           Text(
//                             "   To enable Login access for IREPS: ",
//                             style: TextStyle(
//                                 fontSize: 15.0, fontWeight: FontWeight.normal),
//                           )
//                         ],
//                       ),
//                       Padding(
//                           padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
//                       //new Padding(padding: new EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
//                       Row(
//                         children: <Widget>[
//                           Padding(padding: EdgeInsets.only(left: 30.0)),
//                           Text("1. Login to www.ireps.gov.in",
//                               style: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Colors.blueGrey,
//                               )),
//                           Padding(padding: EdgeInsets.only(left: 35.0)),
//                         ],
//                       ),
//                       Padding(
//                           padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
//                       Row(
//                         children: <Widget>[
//                           Padding(padding: EdgeInsets.only(left: 30.0)),
//                           Text(
//                               "2. Go to link on the right navigation (Enable\n    MobileApp Access for IREPS)",
//                               style: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Colors.blueGrey,
//                               )),
//                         ],
//                       ),
//                       Padding(
//                           padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
//                       Row(
//                         children: <Widget>[
//                           Padding(padding: EdgeInsets.only(left: 30.0)),
//                           Text("3. Complete the process.",
//                               style: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Colors.blueGrey,
//                               )),
//                         ],
//                       ),
//                       Padding(
//                           padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 20.0)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
//
//   Future<Widget> _resetpinBottomSheet(BuildContext context) async {
//     return await showModalBottomSheet(
//         context: context,
//         constraints:
//         BoxConstraints.loose(Size(MediaQuery.of(context).size.width, 200)),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             )),
//         clipBehavior: Clip.hardEdge,
//         builder: (_) {
//           return Container(
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(color: Colors.white),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text("To reset PIN for IREPS: ",
//                           style: TextStyle(
//                               fontSize: 15.0, fontWeight: FontWeight.normal)),
//                       InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius: BorderRadius.circular(12.0)),
//                             alignment: Alignment.center,
//                             child: Icon(Icons.clear,
//                                 size: 15, color: Colors.white),
//                           ))
//                     ],
//                   ),
//                   Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
//                   Row(
//                     children: <Widget>[
//                       Padding(padding: EdgeInsets.only(left: 10.0)),
//                       Text("1. Login to www.ireps.gov.in",
//                           style: TextStyle(
//                             fontSize: 15.0,
//                             color: Colors.blueGrey,
//                           )),
//                       Padding(padding: EdgeInsets.only(left: 35.0)),
//                     ],
//                   ),
//                   Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
//                   Row(
//                     children: <Widget>[
//                       Padding(padding: EdgeInsets.only(left: 10.0)),
//                       Text(
//                           "2. Go to link on the right navigation (Enable\n    MobileApp Access for IREPS)",
//                           style: TextStyle(
//                             fontSize: 15.0,
//                             color: Colors.blueGrey,
//                           )),
//                     ],
//                   ),
//                   Padding(padding: EdgeInsets.fromLTRB(35.0, 0.0, 30.0, 10.0)),
//                   Row(
//                     children: <Widget>[
//                       Padding(padding: EdgeInsets.only(left: 10.0)),
//                       Expanded(
//                           child: Text(
//                               "3. Select RESET PIN and complete the process.",
//                               style: TextStyle(
//                                   fontSize: 15.0, color: Colors.blueGrey))),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
// }
//
// class RadioOption extends StatelessWidget {
//   final String value;
//   final String? groupValue;
//   final ValueChanged<String?> onChanged;
//   final String label;
//
//   const RadioOption({
//     required this.value,
//     required this.groupValue,
//     required this.onChanged,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Radio<String>(
//           activeColor: label == 'IREPS' ? AapoortiConstants.primary : Colors.red.shade300,
//           value: value,
//           groupValue: groupValue,
//           onChanged: onChanged,
//         ),
//         Text(label),
//       ],
//     );
//   }
// }
