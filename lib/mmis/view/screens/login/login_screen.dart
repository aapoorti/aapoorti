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

  final ScrollController _scrollController = ScrollController();

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
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  void dispose() {
    // TODO: implement dispose
    controller.loginState = LoginState.idle.obs;
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
      body: InkWell(
        onTap: (){
          FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside
        },
        child: Container(
          height: Get.height,
          width: Get.width,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
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
                        Obx((){
                          return TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Enter PIN',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  controller.isVisible = !controller.isVisible;
                                  // setState(() {
                                  //   _obscureText = !_obscureText;
                                  // });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            obscureText: controller.isVisible,
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
                          );
                        }),
                        const SizedBox(height: 16),
                        // Remember Me Section with Days Selection
                        _buildRememberMeSection(),
                        const SizedBox(height: 24),
                        // Login Button
                        Obx(() {
                          if (controller.loginState.value == LoginState.idle) {
                            Future.delayed(Duration.zero, () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              _usernameController.text = (prefs.containsKey('mmisemail') ? prefs.getString('mmisemail') : "")!;
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
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -55,
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
