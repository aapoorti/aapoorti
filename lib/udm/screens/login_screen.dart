import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/aapoorti/common/AapoortiConstants.dart';
import 'package:flutter_app/aapoorti/common/AapoortiUtilities.dart';
import 'package:flutter_app/aapoorti/common/CommonScreen.dart';
import 'package:flutter_app/udm/helpers/wso2token.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/localization/languageHelper.dart';
import 'package:flutter_app/udm/providers/change_visibility_provider.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:flutter_app/udm/widgets/switch_language_button.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/error.dart';
import '../helpers/shared_data.dart';
import '../providers/loginProvider.dart';
import '../providers/versionProvider.dart';
import '../widgets/dailog.dart';
import '../widgets/sigin_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{

  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 15.0);
  var email= '11', pin;
  var connectivityresult;

  bool _obscureText = true;
  String _selectedLoginType = 'UDM';

  // Add day options
  final List<int> _dayOptions = [5, 7, 10];

  var jsonResult = null;
  var errorcode = 0;


  ProgressDialog? pr;
  bool value1 = true;
  String? checkbox;
  BuildContext? context1;
  String? logoutsucc;

  bool visibilty = false;

  bool _isEnglish = true;
  late AnimationController _animationController;

  // Build Remember Me Section
  Container _buildRememberMeSection(LanguageProvider language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Consumer<LoginProvider>(
            builder: (context, provider, child){
                return Checkbox(
                  value: provider.remValue,
                  onChanged: (value) {
                    provider.setRememberMe(value ?? false);
                  },
                );
            }
          ),
          Text(language.text('slcf')),
          const SizedBox(width: 8),
          Consumer<LoginProvider>(
            builder: (context, provider, child){
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: provider.selectdaysValue,
                    items: _dayOptions.map((days) {
                      return DropdownMenuItem<int>(
                        value: days,
                        child: Text('$days days'),
                      );
                    }).toList(),
                    onChanged: provider.remValue ? (value) {
                      provider.setSelectDays(value!);
                    } : null,
                    style: TextStyle(
                      color: provider.remValue ? Colors.black87 : Colors.grey,
                      fontSize: 14,
                    ),
                    isDense: true,
                  ),
                ),
              );
            },
          )
          ,
        ],
      ),
    );
  }

  Map<String, String> versionResult = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwdFieldController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  Error? _error;

  var appStoreUrl = 'https://apps.apple.com/in/app/ireps/id1462024189';

  var playStoreUrl = 'https://play.google.com/store/apps/details?id=in.gov.ireps';

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      Provider.of<LoginProvider>(context, listen: false).setState(LoginState.Idle);
      checkVersion();

      _checkLanguage();
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Add listener to check input length
    _passwdFieldController.addListener(() {
      if (_passwdFieldController.text.length >= 6) {
        // Scroll up when input has 6 or more digits
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void checkVersion() async {
    try {
      Uri default_url = Uri.parse(IRUDMConstants.downTimeUrl);
      var response = await http.get(default_url);
      await fetchToken(context);
      await Provider.of<VersionProvider>(context, listen: false).fetchVersion(context);
      _error = Provider.of<VersionProvider>(context, listen: false).error;
      if(_error!.title == "Exception") {
        Timer.run(() => showDialog(
            context: context,
            builder: (_) => CommonDailog(
              title: _error!.title,
              contentText: _error!.description,
              type: 'Exception',
              action: action,
            )));
      }
      else if(_error!.title.contains("Error")) {
        Timer.run(() => showDialog(
            context: context,
            builder: (_) => CommonDailog(
              title: _error!.title,
              contentText: _error!.description,
              type: 'Error',
              action: action,
            )));
      }
      // else if(_error!.title.contains("Update")) {
      //   Timer.run(() => showDialog(
      //       context: context,
      //       builder: (_) => CommonDailog(
      //         title: _error!.title,
      //         contentText: _error!.description,
      //         type: 'Error',
      //         action: action,
      //       )));
      // }
      else if(_error!.title.contains('title2')) {
        Provider.of<LoginProvider>(context, listen: false).autologin(context);
      }
      // if(response.statusCode == 200) {
      //   Navigator.pop(context);
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(IRUDMConstants.downTimeUrl)));
      // } else {
      //    await Provider.of<VersionProvider>(context, listen: false).fetchVersion(context);
      //   _error = Provider.of<VersionProvider>(context, listen: false).error;
      //   if(_error!.title == "Exception") {
      //     Timer.run(() => showDialog(
      //         context: context,
      //         builder: (_) => CommonDailog(
      //               title: _error!.title,
      //               contentText: _error!.description,
      //               type: 'Exception',
      //               action: action,
      //             )));
      //   }
      //   else if(_error!.title.contains("Error")) {
      //     Timer.run(() => showDialog(
      //         context: context,
      //         builder: (_) => CommonDailog(
      //               title: _error!.title,
      //               contentText: _error!.description,
      //               type: 'Error',
      //               action: action,
      //             )));
      //   }
      //   else if(_error!.title.contains("Update")) {
      //     Timer.run(() => showDialog(
      //         context: context,
      //         builder: (_) => CommonDailog(
      //               title: _error!.title,
      //               contentText: _error!.description,
      //               type: 'Error',
      //               action: action,
      //             )));
      //   }
      //   else if(_error!.title.contains('title2')) {
      //     Provider.of<LoginProvider>(context, listen: false).autologin(context);
      //   }
      // }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void action() {
    if(_error!.title.contains('Error')) {}
    else if (_error!.title.contains('Update')) {
      AapoortiUtilities.openStore(context);
    }
  }

  void validateAndLogin(int days, bool isLoginSaved) {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Provider.of<LoginProvider>(context, listen: false).authenticateUser(email, pin, isLoginSaved, false, context);
      }
      catch (err) {
        SchedulerBinding.instance.addPostFrameCallback((_){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
            content: Text('Something Unexpected happened!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ));
        });
      }
    }
  }

  void _checkLanguage() {
    Language lan = Provider.of<LanguageProvider>(context, listen: false).language;
    setState(() {
      Language.Hindi == lan ?  _isEnglish = false : true;
    });
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return WillPopScope(
      onWillPop: () async{
        //AapoortiUtilities.showAlertDailog(context, "UDM");
        Navigator.push(context, MaterialPageRoute(builder: (context) => CommonScreen()));
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D47A1), // Dark Blue
                  Color(0xFF1976D2), // Lighter Blue
                ],
              ),
            ),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent, // Make AppBar background transparent
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CommonScreen()));
                  //Navigator.of(context).pop();
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: _toggleLanguage,
                    child: Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4285F4),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: _isEnglish ? 5 : null,
                            right: _isEnglish ? null : 5,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _isEnglish ? 'A' : 'अ',
                                  style: TextStyle(
                                    color: const Color(0xFF1A73E8),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
              title: Text(
                language.text('login'),
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back, color: Colors.white),
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(builder: (context) => CommonScreen()));
        //       //Navigator.of(context).pop();
        //     },
        //   ),
        //   actions: [
        //     SwitchLanguageButton(color: Colors.black)
        //   ],
        //   centerTitle: true,
        //   title: Text(language.text('login'), style: TextStyle(color: Colors.white)), // You can customize the title
        //   backgroundColor: AapoortiConstants.primary,
        // ),
        body: FutureBuilder(
          future: Provider.of<LanguageProvider>(context, listen: false).fetchLanguage(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator()) : Consumer<LanguageProvider>(
              builder: (context, language, child) {
                return GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus(); // Dismiss keyboard when tapping outside
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey[50],
                      // image: DecorationImage(
                      //   image: AssetImage("assets/images/login_bg.jpg"),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: Column(
                      children: [_trialCheck(context),
                        Expanded(child: SafeArea(
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
                                    Center(
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.1),
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
                                        'Indian Railways E - Procurement System',
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
                                              title: language.text('irepslabel'),
                                              isSelected: _selectedLoginType == 'IREPS',
                                              onTap: () {
                                                setState(() {
                                                  _selectedLoginType = 'IREPS';
                                                });
                                                Navigator.of(context).pushReplacementNamed('/common_screen', arguments: [1,'']);
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: _LoginTypeButton(
                                              title: language.text('udmlabel'),
                                              isSelected: _selectedLoginType == 'UDM',
                                              onTap: () {
                                                setState(() {
                                                  _selectedLoginType = 'UDM';
                                                });
                                                //Navigator.pushNamed(context, LoginScreen.routeName);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // Email Field
                                    TextFormField(
                                      controller: _emailFieldController,
                                      //initialValue: AapoortiConstants.loginUserEmailID != "" ? AapoortiConstants.loginUserEmailID : null,
                                      validator: (value) {
                                        // bool emailValid = RegExp("^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                                        bool emailValid = RegExp("^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})\$").hasMatch(value!.trim());
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
                                        labelText: "${language.text('emailId')}/${language.text('userId')}",
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
                                    Consumer<ChangeVisibilityProvider>(builder: (context, provider, child){
                                       return TextFormField(
                                         decoration: InputDecoration(
                                           labelText: language.text('enterPin'),
                                           prefixIcon: const Icon(Icons.lock_outline),
                                           suffixIcon: IconButton(
                                             icon: Icon(
                                               provider.visibilityValue ? Icons.visibility : Icons.visibility_off,
                                             ),
                                             onPressed: () {
                                               provider.setVisibility(!provider.visibilityValue);
                                               //provider.visibilityValue = !provider.visibilityValue;
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
                                         obscureText: provider.getVisibility,
                                         controller: _passwdFieldController,
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
                                         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                       );
                                    }),
                                    const SizedBox(height: 16),
                                    // Remember Me Section with Days Selection
                                    _buildRememberMeSection(language),
                                    const SizedBox(height: 24),
                                    // Login Button
                                    Consumer<LoginProvider>(builder: (_, loginProvider, __) {
                                      if((_emailFieldController.value.text.isEmpty) && (loginProvider.user != null)) {
                                        Future.delayed(Duration.zero, () async {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          _emailFieldController.text = prefs.get('email') as String;
                                          _passwdFieldController.text = '';
                                        });
                                      }
                                      if(loginProvider.state == LoginState.Idle || loginProvider.state == LoginState.Complete) {
                                        Future.delayed(Duration.zero, () async {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          if(_emailFieldController.text == '') {
                                            _emailFieldController.text = "${prefs.get('email') ?? ""}";
                                            _passwdFieldController.text = '';
                                          }
                                        });
                                      }
                                      else if(loginProvider.state == LoginState.Finished) {
                                        SchedulerBinding.instance.addPostFrameCallback((_) {
                                          loginProvider.setState(LoginState.FinishedWithError);
                                        });
                                      }
                                      return SignInButton(text: language.text('login'), action: () async{
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        DateTime providedTime = DateTime.parse(prefs.getString('checkExp')!);
                                        if(providedTime.isBefore(DateTime.now())){
                                          await fetchToken(context);
                                          validateAndLogin(loginProvider.selectdaysValue, loginProvider.remValue);
                                        }
                                        else{
                                          validateAndLogin(loginProvider.selectdaysValue, loginProvider.remValue);
                                        }
                                      }, loginstate: loginProvider.state);
                                      // return ElevatedButton(
                                      //   onPressed: () async{
                                      //     FocusScope.of(context).unfocus();
                                      //     try {
                                      //       connectivityresult = await InternetAddress.lookup('google.com');
                                      //       if(connectivityresult != null) {
                                      //         validateAndLogin(loginProvider.selectdaysValue);
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
                                      // );
                                    }),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              //_enableloginBottomSheet(context);
                                              _enableAndResetModalSheet(context, 'enable', language);
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
                                              _enableAndResetModalSheet(context, 'reset', language);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[200],
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              language.text('resetPinInstructionsLabel2'),
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
                        ))
                        // Expanded(
                        //   child: SafeArea (
                        //     child: Center(
                        //       child: SingleChildScrollView(
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           clipBehavior: Clip.none,
                        //           children: [
                        //             Form(
                        //               key: _formKey,
                        //               autovalidateMode: AutovalidateMode.onUserInteraction,
                        //               child: Card(
                        //                 surfaceTintColor: Colors.white,
                        //                 elevation: 8.0,
                        //                 margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        //                 color: Colors.white.withOpacity(0.8),
                        //                 shape: RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(20),
                        //                   side: BorderSide(color: Colors.red.shade300, width: 1),
                        //                 ),
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        //                   child: Column(
                        //                     mainAxisAlignment: MainAxisAlignment.start,
                        //                     children: [
                        //                       SizedBox(height: 70),
                        //                       Row(mainAxisAlignment: MainAxisAlignment.spaceAround, // Center the radio buttons
                        //                           children: [
                        //                             InkWell(
                        //                               onTap: (){
                        //                                 setState(() {
                        //                                   selectedValue = 'IREPS';
                        //                                 });
                        //                                 Navigator.of(context).pushReplacementNamed('/common_screen', arguments: [1,'']);
                        //                               },
                        //                               child: Container(
                        //                                 height: 45,
                        //                                 width: 120,
                        //                                 decoration: BoxDecoration(
                        //                                   borderRadius: BorderRadius.circular(8.0),
                        //                                   //border: Border.all(color: Colors.red.shade300, strokeAlign: 1.0)
                        //                                 ),
                        //                                 child:RadioOption(
                        //                                   value: 'IREPS',
                        //                                   groupValue: selectedValue,
                        //                                   onChanged: (String? newValue) {
                        //                                     setState(() {
                        //                                       selectedValue = newValue;
                        //                                     });
                        //                                     Navigator.of(context).pushReplacementNamed('/common_screen', arguments: [1,'']);
                        //                                   },
                        //                                   label: language.text('irepslabel'),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                             SizedBox(width: 25),
                        //                             InkWell(
                        //                               onTap: (){
                        //                                 setState(() {
                        //                                   selectedValue = 'UDM';
                        //                                 });
                        //                                 Navigator.pushNamed(context, LoginScreen.routeName);
                        //                               },
                        //                               child: Container(
                        //                                 height: 45,
                        //                                 width: 120,
                        //                                 decoration: BoxDecoration(
                        //                                   borderRadius: BorderRadius.circular(8.0),
                        //                                   //border: Border.all(color: Colors.red.shade300, strokeAlign: 1.0)
                        //                                 ),
                        //                                 child: RadioOption(
                        //                                   value: 'UDM',
                        //                                   groupValue: selectedValue,
                        //                                   onChanged: (String? newValue) {
                        //                                     setState(() {
                        //                                       selectedValue = newValue;
                        //                                     });
                        //                                   },
                        //                                   label: language.text('udmlabel'),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //
                        //                           ]),
                        //                       SizedBox(height: 20),
                        //                       TextFormField(
                        //                         keyboardType: TextInputType.emailAddress,
                        //                         controller: _emailFieldController,
                        //                         cursorColor: Colors.black,
                        //                         decoration: InputDecoration(
                        //                           contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 1.0),
                        //                           prefixIcon: Icon(Icons.mail),
                        //                           focusColor: Colors.red.shade800,
                        //                           focusedErrorBorder: OutlineInputBorder(
                        //                             borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                        //                             borderRadius: BorderRadius.circular(10.0),
                        //                           ),
                        //                           focusedBorder: OutlineInputBorder(
                        //                             borderSide: const BorderSide(color: Color(0xFF00008B), width: 1.0),
                        //                             borderRadius: BorderRadius.circular(10.0),
                        //                           ),
                        //                           errorBorder: OutlineInputBorder(
                        //                             borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                        //                             borderRadius: BorderRadius.circular(10.0),
                        //                           ),
                        //                           enabledBorder: OutlineInputBorder(
                        //                             borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        //                             borderRadius: BorderRadius.circular(10.0),
                        //                           ),
                        //                           labelText: language.text('userId') + '/' + language.text('emailId'),
                        //                           labelStyle: TextStyle(fontSize: 15),
                        //                           floatingLabelBehavior: FloatingLabelBehavior.auto,
                        //                         ),
                        //                         validator: (value) {
                        //                           bool emailValid = RegExp("^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9\.]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})\$").hasMatch(value!.trim());
                        //                           //bool emailValid = RegExp("^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})\$").hasMatch(value!.trim());
                        //                           if(value.isEmpty) {
                        //                             return language.text('validEmail');
                        //                           }
                        //                           else if(!emailValid) {
                        //                             return language.text('validEmail');
                        //                           }
                        //                         },
                        //                         onChanged: (value){
                        //
                        //                         },
                        //                         onSaved: (val) {
                        //                           email = val!.trim();
                        //                         },
                        //                       ),
                        //                       SizedBox(height: 25),
                        //                       Consumer<ChangeVisibilityProvider>(builder: (context, value, child){
                        //                         return TextFormField(
                        //                           obscureText: value.getVisibility,
                        //                           keyboardType: TextInputType.text,
                        //                           controller: _passwdFieldController,
                        //                           cursorColor: Colors.black,
                        //                           decoration: InputDecoration(
                        //                             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        //                             labelText: language.text('enterPin'),
                        //                             prefixIcon: Icon(Icons.vpn_key),
                        //                             suffixIcon: InkWell(
                        //                               onTap: (){
                        //                                 if(value.getVisibility == true){
                        //                                   value.setVisibility(false);
                        //                                 }
                        //                                 else{
                        //                                   value.setVisibility(true);
                        //                                 }
                        //                               },
                        //                               child: value.getVisibility == true ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off),
                        //                             ),
                        //                             labelStyle: TextStyle(fontSize: 15),
                        //                             floatingLabelBehavior: FloatingLabelBehavior.auto,
                        //                             focusedBorder: OutlineInputBorder(
                        //                               borderSide: const BorderSide(color: Color(0xFF00008B), width: 1.0),
                        //                               borderRadius: BorderRadius.circular(10.0),
                        //                             ),
                        //                             border: OutlineInputBorder(
                        //                               borderSide: const BorderSide(
                        //                                 color: Colors.grey,
                        //                               ),
                        //                               borderRadius: BorderRadius.circular(14),
                        //                             ),
                        //                             disabledBorder: OutlineInputBorder(
                        //                               borderSide: const BorderSide(
                        //                                 color: Colors.grey,
                        //                               ),
                        //                               borderRadius: BorderRadius.circular(14),
                        //                             ),
                        //                             errorBorder: OutlineInputBorder(
                        //                               borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        //                               borderRadius: BorderRadius.circular(10.0),
                        //                             ),
                        //                             enabledBorder: OutlineInputBorder(
                        //                               borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        //                               borderRadius: BorderRadius.circular(10.0),
                        //                             ),
                        //                             focusColor: Colors.red.shade800,
                        //                             focusedErrorBorder: OutlineInputBorder(
                        //                               borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
                        //                               borderRadius: BorderRadius.circular(10.0),
                        //                             ),
                        //                           ),
                        //                           validator: (pin) {
                        //                             String text = language.text('pinLengthError');
                        //                             if(pin == null || pin.isEmpty) {
                        //                               return text;
                        //                             } else if(pin.length < 6 || pin.length > 12) {
                        //                               return text;
                        //                             }
                        //                             return null;
                        //                           },
                        //                           onSaved: (val) {
                        //                             pin = val;
                        //                           },
                        //                         );
                        //                       }),
                        //                       SizedBox(height: 10),
                        //                       LoginSavedCheckBox(
                        //                         value: isLoginSaved,
                        //                         setValue: (bool val) {
                        //                           isLoginSaved = val;
                        //                         },
                        //                       ),
                        //                       Consumer<LoginProvider>(builder: (_, loginProvider, __) {
                        //                         if((_emailFieldController.value.text.isEmpty) && (loginProvider.user != null)) {
                        //                           Future.delayed(Duration.zero, () async {
                        //                             SharedPreferences prefs = await SharedPreferences.getInstance();
                        //                             _emailFieldController.text = prefs.get('email') as String;
                        //                             _passwdFieldController.text = '';
                        //                           });
                        //                         }
                        //                         if(loginProvider.state == LoginState.Idle || loginProvider.state == LoginState.Complete) {
                        //                           Future.delayed(Duration.zero, () async {
                        //                             SharedPreferences prefs = await SharedPreferences.getInstance();
                        //                             if(_emailFieldController.text == '') {
                        //                               _emailFieldController.text = "${prefs.get('email') ?? ""}";
                        //                               _passwdFieldController.text = '';
                        //                             }
                        //                           });
                        //                         }
                        //                         else if(loginProvider.state == LoginState.Finished) {
                        //                           SchedulerBinding.instance.addPostFrameCallback((_) {
                        //                             loginProvider.setState(LoginState.FinishedWithError);
                        //                           });
                        //                         }
                        //                         return SignInButton(
                        //                           text: language.text('login'),
                        //                           action: validateAndLogin,
                        //                           loginstate: loginProvider.state,
                        //                         );
                        //                       }),
                        //                       SizedBox(height: 20),
                        //                       // Row(
                        //                       //   mainAxisAlignment: MainAxisAlignment.center,
                        //                       //   mainAxisSize: MainAxisSize.min,
                        //                       //   children: [
                        //                       //     TextButton ( onPressed: (){
                        //                       //       Get.toNamed(Routes.reqsetPinScreen, arguments: ['0']);
                        //                       //     },
                        //                       //     style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        //                       //     child: Text('Set PIN for iMMS/UDM', style:
                        //                       //      TextStyle(fontFamily: 'Roboto', decorationColor: Color(0xFF007BFF),  decoration: TextDecoration.underline, color: Color(0xFF007BFF), fontSize: 14, fontWeight: FontWeight.bold))),
                        //                       //     SizedBox(width: 15),
                        //                       //     Row(
                        //                       //       children: [
                        //                       //         Container(
                        //                       //           height: 15,  // Line thickness
                        //                       //           width: 1.5, // Length of the line
                        //                       //           color: Colors.blueGrey, // Line color
                        //                       //         ),
                        //                       //         SizedBox(width: 5),
                        //                       //         Container(
                        //                       //           height: 15,  // Line thickness
                        //                       //           width: 1.5, // Length of the line
                        //                       //           color: Colors.blueGrey, // Line color
                        //                       //         ),
                        //                       //       ],
                        //                       //     ),
                        //                       //     SizedBox(width: 15),
                        //                       //     TextButton(
                        //                       //         onPressed: (){
                        //                       //           Get.toNamed(Routes.reqsetPinScreen, arguments: ['1']);
                        //                       //         },
                        //                       //         style: TextButton.styleFrom(
                        //                       //           padding: EdgeInsets.zero, // No padding
                        //                       //         ),
                        //                       //         child: Text('Forgot PIN', style:
                        //                       //         TextStyle(fontFamily: 'Roboto', decorationColor: Color(0xFFDC3545), decoration: TextDecoration.underline, color: Color(0xFFDC3545), fontSize: 14, fontWeight: FontWeight.bold)
                        //                       //         )),
                        //                       //   ],
                        //                       // ),
                        //                       InkWell(
                        //                           child: RichText(
                        //                             text: TextSpan(
                        //                               text: language.text('enableAccessLabel1'),
                        //                               style: TextStyle(
                        //                                 decoration: TextDecoration.underline,
                        //                                 color: Colors.teal[900],
                        //                               ),
                        //                               children: <TextSpan>[
                        //                                 TextSpan(
                        //                                     text: language.text('enableAccessLabel2'),
                        //                                     style: TextStyle(fontWeight: FontWeight.bold,
                        //                                         decoration: TextDecoration.underline,
                        //                                         color: Colors.teal[900])),
                        //                                 TextSpan(text: language.text('enableAccessLabel3')),
                        //                               ],
                        //                             ),
                        //                           ),
                        //                           onTap: () {
                        //                             _enableAndResetModalSheet(context, 'enable', language);
                        //                           }),
                        //                       SizedBox(height: 15.0),
                        //                       Row(
                        //                         mainAxisAlignment: MainAxisAlignment.center,
                        //                         children: [
                        //                           InkWell(
                        //                             child: RichText(
                        //                               text: TextSpan(
                        //                                 text: language.text('resetPinInstructionsLabel1'),
                        //                                 style: TextStyle(
                        //                                   decoration: TextDecoration.underline,
                        //                                   color: Colors.teal[900],
                        //                                 ),
                        //                                 children: <TextSpan>[
                        //                                   TextSpan(
                        //                                       text: language.text('resetPinInstructionsLabel2'),
                        //                                       style: TextStyle(
                        //                                         fontWeight: FontWeight.bold,
                        //                                         decoration: TextDecoration.underline,
                        //                                         color: Colors.teal[900],
                        //                                       )),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                             onTap: () {
                        //                               _enableAndResetModalSheet(
                        //                                 context,
                        //                                 'reset',
                        //                                 language,
                        //                               );
                        //                             },
                        //                           ),
                        //                           //Text(" ||", style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold)),
                        //                           // TextButton(onPressed: (){
                        //                           //   Navigator.push(context, MaterialPageRoute(builder: (context) => HelpDeskScreen(data: 0)));
                        //                           // }, child: Text(language.text('helpdesktitle'), style: TextStyle(color: Colors.teal[900], fontWeight: FontWeight.bold, decoration: TextDecoration.underline)))
                        //                         ],
                        //                       )
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //             child!,
                        //             Positioned(right: 45, left: 45, top: -30, child: Image.asset('assets/nlogo.png', height: 75, width: 75))
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
              child: Positioned(
                top: 15,
                child: Column(
                  children: [
                    // CircleAvatar(
                    //   backgroundColor: Colors.white,
                    //   backgroundImage: AssetImage('assets/indian_railway2.png'),
                    //   radius: 40,
                    // ),
                    // SizedBox(height: 5),
                    // Text('यूजर डिपो मॉड्यूल',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       color: Color(0xFF00008B),
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 20),
                    // ),
                    SizedBox(height: 30),
                    Text(language.text('udmtitle'), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF00008B), fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _trialCheck(BuildContext context) {
    if(IRUDMConstants.webServiceUrl.contains('trial')) {
      return Text("TRIAL", style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold));
    } else {
      return Text("");
    }
  }

  Future<void> _enableAndResetModalSheet(BuildContext context, String type, LanguageProvider language) async {
    return await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        clipBehavior: Clip.hardEdge,
        builder: (_) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
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
                Row(
                  children: <Widget>[
                    Text(
                      type == 'reset' ? language.text('resetPinInstructionsTitle') : language.text('enableAccessInstructionsTitle'),
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 32.0)),
                    Text("1.", style: TextStyle(fontSize: 16.0, color: Colors.blueGrey)),
                    SizedBox(width: 5),
                    Text(language.text('loginScreenInstructions1'), style: TextStyle(fontSize: 16.0, color: Colors.blueGrey)),
                    Padding(padding: EdgeInsets.only(left: 35.0)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 32.0)),
                    Text("2.", style: TextStyle(fontSize: 16.0,color: Colors.blueGrey)),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        language.text('loginScreenInstructions2'),
                        style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 32.0)),
                    Text("3.", style: TextStyle(fontSize: 16.0, color: Colors.blueGrey)),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        type == 'reset' ? language.text('resetPinInstructionsText') : language.text('enableAccessInstructionsText'),
                        style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
      if(_isEnglish) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
    _isEnglish ? Provider.of<LanguageProvider>(context, listen: false).updateLanguage(Language.English) : Provider.of<LanguageProvider>(context, listen: false).updateLanguage(Language.Hindi);
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 3);
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => true;
}

class RadioOption extends StatelessWidget {
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final String label;

  const RadioOption({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          activeColor: label == 'IREPS' || label == 'आईआरईपीएस' ? AapoortiConstants.primary : AapoortiConstants.primary,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(label),
      ],
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