import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonScreen.dart';
import 'package:flutter_app/mmis/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:get/get.dart';
import 'package:flutter_app/mmis/controllers/login_controller.dart';
import 'package:flutter_app/mmis/controllers/network_controller.dart';
import 'package:flutter_app/mmis/utils/toast_message.dart';
import 'package:form_validator/form_validator.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  //final networkController = Get.find<NetworkController>();

  //final controller = Get.find<LoginController>();
  final controller = Get.put<LoginController>(LoginController());

  final networkController = Get.put<NetworkController>(NetworkController());
  var username, password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _rememberMe = false;
  final _emailController = TextEditingController();
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
  Container _buildRememberMeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Obx(() => Checkbox(
              value: controller.checkValue,
              onChanged: (value) {
                controller.checkValue = value!;
              })
          ),
          // Checkbox(
          //   value: _rememberMe,
          //   onChanged: (value) {
          //     setState(() {
          //       _rememberMe = value ?? false;
          //     });
          //   },
          // ),
          Text('Save Login Credentials for'),
          const SizedBox(width: 8),
          Obx(() => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: controller.checkValuedays,
                items: _dayOptions.map((days) {
                  return DropdownMenuItem<int>(
                    value: days,
                    child: Text('$days days'),
                  );
                }).toList(),
                onChanged: controller.checkValue ? (value) {
                  controller.checkValuedays = value!;
                }
                    : null,
                style: TextStyle(
                  color: controller.checkValue ? Colors.black87 : Colors.grey,
                  fontSize: 14,
                ),
                isDense: true,
              ),
            ),
          ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.loginState = LoginState.idle.obs;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: false,
      //floatingActionButton: SwitchLanguageButton(color: Colors.black),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CommonScreen()));
            //Navigator.of(context).pop();
          },
        ),
        // actions: [
        //   SwitchLanguageButton(color: Colors.black)
        // ],
        centerTitle: true,
        title: Text(language.text('login'),
            style:
                TextStyle(color: Colors.white)), // You can customize the title
        backgroundColor: AapoortiConstants.primary,
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            SafeArea(
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
                        child: const Text(
                          'CRIS MMIS',
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
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withOpacity(0.05),
                      //         blurRadius: 10,
                      //         offset: const Offset(0, 2),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: _LoginTypeButton(
                      //           title: 'IREPS',
                      //           isSelected: _selectedLoginType == 'IREPS',
                      //           onTap: () {
                      //             setState(() {
                      //               _selectedLoginType = 'IREPS';
                      //             });
                      //           },
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: _LoginTypeButton(
                      //           title: 'UDM',
                      //           isSelected: _selectedLoginType == 'UDM',
                      //           onTap: () {
                      //             setState(() {
                      //               _selectedLoginType = 'UDM';
                      //             });
                      //             Navigator.pushNamed(context, LoginScreen.routeName);
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 10),
                      // Email Field
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        //initialValue: AapoortiConstants.loginUserEmailID != "" ? AapoortiConstants.loginUserEmailID : null,
                        validator: (value) {
                          // bool emailValid = RegExp("^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                          bool emailValid = RegExp(
                              "^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})\$")
                              .hasMatch(value!.trim());
                          if (value.isEmpty) {
                            return ('Please enter valid Email-ID');
                          } else if (!emailValid) {
                            return ('Please enter valid Email-ID');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!.trim();
                        },
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // PIN Field with numeric keyboard
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Enter PIN',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                            return ('Please enter 6-12 digit PIN');
                          } else if (pin.length < 6 || pin.length > 12) {
                            return ('Please enter 6-12 digit PIN');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          pin = value;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Remember Me Section with Days Selection
                      _buildRememberMeSection(),
                      const SizedBox(height: 24),
                      // Login Button
                      Obx(() {
                        if (controller.loginState.value == LoginState.idle) {
                          Future.delayed(Duration.zero, () async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            _usernameController.text =
                            (prefs.containsKey('mmisemail')
                                ? prefs.getString('mmisemail')
                                : "")!;
                            _passwordController.text = '';
                          });
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF1565C0),
                                  minimumSize: Size.fromHeight(45),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0)),
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (networkController
                                    .connectionStatus.value !=
                                    0) {
                                  if (_formKey.currentState!.validate()) {
                                    controller.loginUsers(
                                        _usernameController.text.trim(),
                                        _passwordController.text.trim(),
                                        controller.checkValue,
                                        _selectedDays);
                                  }
                                } else {
                                  ToastMessage.networkError('plcheckconn'.tr);
                                }
                              },
                              child: Text('login'.tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0)));
                        } else if (controller.loginState.value ==
                            LoginState.loading) {
                          return Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(27.5)),
                              alignment: Alignment.center,
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0)));
                        } else if (controller.loginState.value ==
                            LoginState.success) {
                          return Container(
                              height: 55,
                              width: 55,
                              child: Icon(Icons.done_rounded,
                                  color: Colors.white, size: 30.0),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(27.5)));
                        } else if (controller.loginState.value ==
                            LoginState.failedWithError ||
                            controller.loginState.value ==
                                LoginState.failed) {
                          return Container(
                              height: 55,
                              width: 55,
                              child: Icon(Icons.clear,
                                  color: Colors.white, size: 30.0),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(27.5)));
                        }
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                minimumSize: Size.fromHeight(45),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10.0)),
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if(networkController.connectionStatus.value != 0) {
                                if(_formKey.currentState!.validate()) {
                                  controller.loginUsers(_usernameController.text.trim(), _passwordController.text.trim(), controller.checkValue, _selectedDays);
                                }
                              } else {
                                ToastMessage.networkError('plcheckconn'.tr);
                              }
                            },
                            child: Text('login'.tr,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)));
                      }),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.reqsetPinScreen,
                                    arguments: ['0']);
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              child: Text('Set PIN for CRIS MMIS',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      decorationColor: Color(0xFF007BFF),
                                      decoration: TextDecoration.underline,
                                      color: Color(0xFF007BFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold))),
                          // SizedBox(width: 15),
                          // Row(
                          //   children: [
                          //     Container(
                          //       height: 15,  // Line thickness
                          //       width: 1.5, // Length of the line
                          //       color: Colors.blueGrey, // Line color
                          //     ),
                          //     SizedBox(width: 5),
                          //     Container(
                          //       height: 15,  // Line thickness
                          //       width: 1.5, // Length of the line
                          //       color: Colors.blueGrey, // Line color
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(width: 15),
                          // TextButton(
                          //     onPressed: (){
                          //       Get.toNamed(Routes.reqsetPinScreen, arguments: ['1']);
                          //     },
                          //     style: TextButton.styleFrom(
                          //       padding: EdgeInsets.zero, // No padding
                          //     ),
                          //     child: Text('Forgot PIN', style:
                          //     TextStyle(fontFamily: 'Roboto', decorationColor: Color(0xFFDC3545), decoration: TextDecoration.underline, color: Color(0xFFDC3545), fontSize: 14, fontWeight: FontWeight.bold)
                          // )),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: RichText(text: TextSpan(children: [
                      //     TextSpan(text: "This is not ",style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black,fontSize: 17, letterSpacing: 1.0)),
                      //     TextSpan(text: '"iMMS Application"\n', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 17,letterSpacing: 1.0)),
                      //     TextSpan(text: "This is for Internal users of ", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black,fontSize: 17,letterSpacing: 1.0)),
                      //     TextSpan(text: '"CRIS Employees only."', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17,letterSpacing: 1.0))
                      //   ])),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () async{
                      //     FocusScope.of(context).unfocus();
                      //     try {
                      //       connectivityresult = await InternetAddress.lookup('google.com');
                      //       if(connectivityresult != null) {
                      //         //validateAndLogin(_selectedDays);
                      //       }
                      //     } on SocketException catch (_) {
                      //       AapoortiUtilities.showInSnackBar(context, "You are not connected to the internet!");
                      //     }
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: const Color(0xFF1565C0),
                      //     padding: const EdgeInsets.symmetric(vertical: 16),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      //   child: const Text(
                      //     'Login',
                      //     style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                      // Help Links
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: ElevatedButton(
                      //         onPressed: () {
                      //           _enableloginBottomSheet(context);
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: Colors.grey[200],
                      //           padding: const EdgeInsets.symmetric(vertical: 16),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(12),
                      //           ),
                      //         ),
                      //         child: const Text(
                      //           'Enable Login Access',
                      //           style: TextStyle(
                      //             fontSize: 13,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.black87,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 16),
                      //     Expanded(
                      //       child: ElevatedButton(
                      //         onPressed: () {
                      //           _resetpinBottomSheet(context);
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: Colors.grey[200],
                      //           padding: const EdgeInsets.symmetric(vertical: 16),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(12),
                      //           ),
                      //         ),
                      //         child: const Text(
                      //           'Reset PIN',
                      //           style: TextStyle(
                      //             fontSize: 13,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.black87,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: Get.height * 0.10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Note:", style: TextStyle(color: Colors.red, fontSize: 18)),
                  RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "1. ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 15,
                                letterSpacing: 0.0)),
                        TextSpan(
                            text: "This is not ",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15,
                                letterSpacing: 0.0)),
                        TextSpan(
                            text: '"iMMS Application"\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade600,
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                letterSpacing: 1.0)),
                        TextSpan(
                            text: "2. ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 15,
                                letterSpacing: 0.0)),
                        TextSpan(
                            text: "This is for ",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15,
                                letterSpacing: 1.0)),
                        TextSpan(
                            text: '"CRIS Employees only."',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade600,
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                letterSpacing: 1.0))
                      ])),
                ],
              ),
            )
          ],
        ),
      ),
      // body: Container(
      //   height: Get.height,
      //   width: Get.width,
      //   decoration: BoxDecoration(
      //     color : Colors.white
      //     // image: DecorationImage(
      //     //   image: AssetImage("assets/images/login_bg.jpg"),
      //     //   fit: BoxFit.cover,
      //     // ),
      //   ),
      //   child: Column(
      //     children: [
      //       Expanded(child: SafeArea(
      //         child: Center(
      //           child: SingleChildScrollView(
      //             child: Padding(
      //               padding: const EdgeInsets.all(15.0),
      //               child: Stack(
      //                 clipBehavior: Clip.none,
      //                 children: [
      //                   Card(
      //                       color: Colors.white.withOpacity(0.8),
      //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.indigo, width: 1.0)),
      //                       elevation: 5.0,
      //                       child: Padding(
      //                         padding: const EdgeInsets.all(10.0),
      //                         child: Form(
      //                           key: _formKey,
      //                           autovalidateMode: AutovalidateMode.onUserInteraction,
      //                           child: Column(
      //                             children: [
      //                               // Image.asset('assets/images/cris_logo.png',color: Colors.indigo, width: Get.width / 4, height: Get.width / 4),
      //                               // const SizedBox(height: 10),
      //                               // Text("क्रिस एमएमआईएस ",
      //                               //     textAlign: TextAlign.center,
      //                               //     style: TextStyle(fontSize: 16, color: Colors.indigo)),
      //                               const SizedBox(height: 30),
      //                               Text("CRIS MMIS",
      //                                   textAlign: TextAlign.center, style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 18)),
      //                               const SizedBox(
      //                                 height: 20,
      //                               ),
      //                               TextFormField(
      //                                 keyboardType: TextInputType.emailAddress,
      //                                 controller: _usernameController,
      //                                 decoration: InputDecoration(
      //                                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      //                                   labelText: 'userid'.tr,
      //                                   prefixIcon: const Icon(Icons.mail),
      //                                   labelStyle: TextStyle(fontSize: 15),
      //                                   floatingLabelBehavior: FloatingLabelBehavior.auto,
      //                                   focusedBorder: OutlineInputBorder(
      //                                     borderSide: const BorderSide(color: Colors.indigo, width: 1.0),
      //                                     borderRadius: BorderRadius.circular(10.0),
      //                                   ),
      //                                   errorBorder: OutlineInputBorder(
      //                                     borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                     borderRadius: BorderRadius.circular(10.0),
      //                                   ),
      //                                   enabledBorder: OutlineInputBorder(
      //                                     borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                     borderRadius: BorderRadius.circular(10.0),
      //                                   ),
      //                                   focusColor: Colors.red[300],
      //                                 ),
      //                                 validator: ValidationBuilder().email().maxLength(60).build(),
      //                                 onSaved: (val) {
      //                                   username = val;
      //                                 },
      //                               ),
      //                               const SizedBox(height: 30),
      //                               Obx(() => TextFormField(
      //                                 obscureText: controller.isVisible,
      //                                 keyboardType: TextInputType.text,
      //                                 controller: _passwordController,
      //                                 decoration: InputDecoration(
      //                                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      //                                   labelText: 'pin'.tr,
      //                                   prefixIcon: Icon(Icons.vpn_key),
      //                                   suffixIcon: IconButton(
      //                                     onPressed: () {
      //                                       controller.isVisible ? controller.isVisible = false : controller.isVisible = true;
      //                                     },
      //                                     icon: controller.isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
      //                                   ),
      //                                   labelStyle: TextStyle(fontSize: 15),
      //                                   floatingLabelBehavior: FloatingLabelBehavior.auto,
      //                                   focusedBorder: OutlineInputBorder(
      //                                     borderSide: const BorderSide(color: Colors.indigo, width: 1.0),
      //                                     borderRadius: BorderRadius.circular(10.0),
      //                                   ),
      //                                   errorBorder: OutlineInputBorder(
      //                                     borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                     borderRadius: BorderRadius.circular(10.0),
      //                                   ),
      //                                   enabledBorder: OutlineInputBorder(
      //                                     borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      //                                     borderRadius: BorderRadius.circular(10.0),
      //                                   ),
      //                                   focusColor: Colors.red[300],
      //                                 ),
      //                                 validator: ValidationBuilder().minLength(6).maxLength(12).build(),
      //                                 onSaved: (val) {
      //                                   password = val;
      //                                 },
      //                               )),
      //                               const SizedBox(height: 15),
      //                               Row(
      //                                 mainAxisAlignment: MainAxisAlignment.start,
      //                                 crossAxisAlignment: CrossAxisAlignment.start,
      //                                 children: [
      //                                   Obx(() => Checkbox(
      //                                       value: controller.checkValue,
      //                                       onChanged: (value) {
      //                                         controller.checkValue = value!;
      //                                       })
      //                                   ),
      //                                   SizedBox(width: Get.width/100),
      //                                   Padding(
      //                                     padding: EdgeInsets.only(top: 11.0),
      //                                     child: SizedBox(
      //                                         child: Text('svcred'.tr,
      //                                             style: TextStyle(
      //                                                 fontSize: 16,
      //                                                 color: Colors.black,
      //                                                 fontWeight: FontWeight.w300))),
      //                                   )
      //                                 ],
      //                               ),
      //                               Obx((){
      //                                 if(controller.loginState.value == LoginState.idle){
      //                                   Future.delayed(Duration.zero, () async {
      //                                     SharedPreferences prefs = await SharedPreferences.getInstance();
      //                                     _usernameController.text = (prefs.containsKey('mmisemail') ? prefs.getString('mmisemail') :  "")!;
      //                                     _passwordController.text = '';
      //                                   });
      //                                   return ElevatedButton(
      //                                       style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, minimumSize: Size.fromHeight(45),
      //                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //                                           textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      //                                       onPressed: () async{
      //                                         FocusManager.instance.primaryFocus?.unfocus();
      //                                         if(networkController.connectionStatus.value != 0){
      //                                           if(_formKey.currentState!.validate()){
      //                                             controller.loginUsers(_usernameController.text.trim(), _passwordController.text.trim(), controller.checkValue);
      //                                           }
      //                                         }
      //                                         else{
      //                                           ToastMessage.networkError('plcheckconn'.tr);
      //                                         }
      //                                       },
      //                                       child: Text('login'.tr, style: TextStyle(color: Colors.white, fontSize: 18.0)));
      //                                 }
      //                                 else if(controller.loginState.value == LoginState.loading){
      //                                   return Container(height: 55, width: 55, decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(27.5)), alignment: Alignment.center, child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)));
      //                                 }
      //                                 else if(controller.loginState.value == LoginState.success){
      //                                   return Container(height: 55, width: 55, child: Icon(Icons.done_rounded,color: Colors.white,  size: 30.0), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(27.5)));
      //                                 }
      //                                 else if(controller.loginState.value == LoginState.failedWithError || controller.loginState.value == LoginState.failed){
      //                                   return Container(height: 55, width: 55, child: Icon(Icons.clear,color: Colors.white,  size: 30.0), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(27.5)));
      //                                 }
      //                                 return ElevatedButton(
      //                                     style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, minimumSize: Size.fromHeight(45),
      //                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //                                         textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      //                                     onPressed: () {
      //                                       FocusManager.instance.primaryFocus?.unfocus();
      //                                       if(networkController.connectionStatus.value != 0){
      //                                         if(_formKey.currentState!.validate()){
      //                                           controller.loginUsers(_usernameController.text.trim(), _passwordController.text.trim(), controller.checkValue);
      //                                         }
      //                                       }
      //                                       else{
      //                                         ToastMessage.networkError('plcheckconn'.tr);
      //                                       }
      //                                     },
      //                                     child: Text('login'.tr, style: TextStyle(color: Colors.white, fontSize: 18.0)));
      //                               }),
      //                               const SizedBox(height: 10),
      //                               Row(
      //                                 mainAxisAlignment: MainAxisAlignment.center,
      //                                 mainAxisSize: MainAxisSize.min,
      //                                 children: [
      //                                   TextButton ( onPressed: (){
      //                                     Get.toNamed(Routes.reqsetPinScreen, arguments: ['0']);
      //                                   },
      //                                   style: TextButton.styleFrom(padding: EdgeInsets.zero),
      //                                   child: Text('Set PIN for CRIS MMIS', style: TextStyle(fontFamily: 'Roboto', decorationColor: Color(0xFF007BFF),  decoration: TextDecoration.underline, color: Color(0xFF007BFF), fontSize: 14, fontWeight: FontWeight.bold))),
      //                                   // SizedBox(width: 15),
      //                                   // Row(
      //                                   //   children: [
      //                                   //     Container(
      //                                   //       height: 15,  // Line thickness
      //                                   //       width: 1.5, // Length of the line
      //                                   //       color: Colors.blueGrey, // Line color
      //                                   //     ),
      //                                   //     SizedBox(width: 5),
      //                                   //     Container(
      //                                   //       height: 15,  // Line thickness
      //                                   //       width: 1.5, // Length of the line
      //                                   //       color: Colors.blueGrey, // Line color
      //                                   //     ),
      //                                   //   ],
      //                                   // ),
      //                                   // SizedBox(width: 15),
      //                                   // TextButton(
      //                                   //     onPressed: (){
      //                                   //       Get.toNamed(Routes.reqsetPinScreen, arguments: ['1']);
      //                                   //     },
      //                                   //     style: TextButton.styleFrom(
      //                                   //       padding: EdgeInsets.zero, // No padding
      //                                   //     ),
      //                                   //     child: Text('Forgot PIN', style:
      //                                   //     TextStyle(fontFamily: 'Roboto', decorationColor: Color(0xFFDC3545), decoration: TextDecoration.underline, color: Color(0xFFDC3545), fontSize: 14, fontWeight: FontWeight.bold)
      //                                   // )),
      //                                 ],
      //                               ),
      //                               //SizedBox(height: 15.0),
      //                             ],
      //                           ),
      //                         ),
      //                       )
      //                   ),
      //                   Positioned(right: 20, left: 20, bottom: -80, child: RichText(text: TextSpan(children: [
      //                     TextSpan(text: "This is not ",style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black,fontSize: 17, letterSpacing: 1.0)),
      //                     TextSpan(text: '"iMMS Application"\n', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 17,letterSpacing: 1.0)),
      //                     TextSpan(text: "This is for Internal users of ", style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black,fontSize: 17,letterSpacing: 1.0)),
      //                     TextSpan(text: '"CRIS Employees only."', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 17,letterSpacing: 1.0))
      //                   ]))),
      //                   Positioned(right: 45, left: 45, top: -30, child: Image.asset('assets/nlogo.png', height: 75, width: 75))
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       ))
      //     ],
      //   ),
      // )
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
