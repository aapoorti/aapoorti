import 'package:flutter/material.dart';
import 'package:flutter_app/udm/providers/languageProvider.dart';
import 'package:provider/provider.dart';


class WarningAlertDialog {
  const WarningAlertDialog();

  void logOut(BuildContext context, VoidCallback press){
    showDialog(
        context: context,
        builder: (context) => UdmConfirmDialog(press: press)
        // builder: (context) => Dialog(
        //   backgroundColor: Colors.white,
        //   insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //   child: SingleChildScrollView(
        //     physics: const ClampingScrollPhysics(),
        //     child: Stack(
        //       clipBehavior: Clip.none,
        //       children: [
        //         Container(
        //           padding: const EdgeInsets.only(top: 40, bottom: 15, left: 15, right: 15),
        //           alignment: Alignment.center,
        //           width: MediaQuery.of(context).size.width,
        //           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        //           child: Column(
        //             children: [
        //               Text(
        //                 "Confirmation!!",
        //                 style: TextStyle(color: Colors.red),
        //                 textAlign: TextAlign.center,
        //                 overflow: TextOverflow.ellipsis,
        //                 maxLines: 2,
        //               ),
        //               const SizedBox(height: 10),
        //               Text(
        //                 'Are you want to logout from application?',
        //                 style: TextStyle(color: Colors.black),
        //                 textAlign: TextAlign.center,
        //                 overflow: TextOverflow.ellipsis,
        //                 maxLines: 4,
        //               ),
        //               const SizedBox(height: 15),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Expanded(
        //                     child: ElevatedButton(
        //                       style: ElevatedButton.styleFrom(
        //                         backgroundColor: Colors.red,
        //                         side: BorderSide(color: Colors.white, width: 1),
        //                         textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
        //                       ),
        //                       onPressed: (){
        //                         Navigator.pop(context);
        //                       },
        //                       child: Text('Cancel',style: TextStyle(fontSize: 14, color: Colors.white)),
        //                     ),
        //                   ),
        //                   const SizedBox(width: 10),
        //                   Expanded(
        //                     child: ElevatedButton(
        //                       style: ElevatedButton.styleFrom(
        //                         backgroundColor: Colors.green,
        //                         side: BorderSide(color: Colors.white, width: 1),
        //                         textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.normal),
        //                       ),
        //                       onPressed: press,
        //                       child: Text('Yes', style: TextStyle(fontSize: 14, color: Colors.white)),
        //                     ),
        //                   ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //         Positioned(
        //           top: -30,
        //           left: MediaQuery.of(context).padding.left,
        //           right: MediaQuery.of(context).padding.right,
        //           child: Image.asset(
        //             "assets/web.png",
        //             height: 60,
        //             width: 60,
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // )
    );
  }

  void changeLoginAlertDialog(BuildContext context, VoidCallback press, [LanguageProvider? language]) {
    showDialog(
        context: context,
        builder: (context) => UdmConfirmDialog(press: press)
    );
  }

  // void actionAlertDialog(BuildContext context, VoidCallback press,String title) {
  //   showDialog(
  //       context: context,
  //       builder: (context) => Dialog(
  //         backgroundColor: MyColor.getCardBg(),
  //         insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.space40),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  //         child: SingleChildScrollView(
  //           physics: const ClampingScrollPhysics(),
  //           child: Stack(
  //             clipBehavior: Clip.none,
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.only(top: Dimensions.space40, bottom: Dimensions.space15, left: Dimensions.space15, right: Dimensions.space15),
  //                 alignment: Alignment.center,
  //                 width: MediaQuery.of(context).size.width,
  //                 decoration: BoxDecoration(color: MyColor.getCardBg(), borderRadius: BorderRadius.circular(5)),
  //                 child: Column(
  //                   children: [
  //                     const SizedBox(height: Dimensions.space5),
  //                     Text(
  //                      title,
  //                       style: interRegularDefault.copyWith(color: MyColor.getTextColor()),
  //                       textAlign: TextAlign.center,
  //                       overflow: TextOverflow.ellipsis,
  //                       maxLines: 4,
  //                     ),
  //                     const SizedBox(height: Dimensions.space15),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Expanded(
  //                           child: RoundedButton(
  //                             text: Strings.no.tr,
  //                             press: () {
  //                               Navigator.pop(context);
  //                             },
  //                             horizontalPadding: 3,
  //                             verticalPadding: 3,
  //                             color: MyColor.getScreenBgColor(),
  //                             textColor: MyColor.getTextColor(),
  //                           ),
  //                         ),
  //                         const SizedBox(width: Dimensions.space10),
  //                         Expanded(
  //                           child: RoundedButton(text: Strings.yes.tr, press: press, horizontalPadding: 3, verticalPadding: 3, color: MyColor.getPrimaryColor(), textColor: MyColor.colorWhite),
  //                         )
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               Positioned(
  //                 top: -30,
  //                 left: MediaQuery.of(context).padding.left,
  //                 right: MediaQuery.of(context).padding.right,
  //                 child: Image.asset(
  //                   MyImages.warningImage,
  //                   height: 60,
  //                   width: 60,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ));
  // }
}

class UdmConfirmDialog extends StatefulWidget {
  final VoidCallback press;

  const UdmConfirmDialog({Key? key, required this.press}) : super(key: key);

  @override
  State<UdmConfirmDialog> createState() => _UdmConfirmDialogState();
}

class _UdmConfirmDialogState extends State<UdmConfirmDialog> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    LanguageProvider language = Provider.of<LanguageProvider>(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E40AF).withOpacity(0.15),
                    blurRadius: 30.0,
                    spreadRadius: 5.0,
                    offset: const Offset(0.0, 15.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: _rotateAnimation.value * 3.14159,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E40AF).withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
                    ).createShader(bounds),
                    child: Text(
                      language.text('conftitle'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    language.text('confdesc'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton(
                        language.text('nostay'),
                        Icons.close_rounded, () => Navigator.pop(context, true),
                        isOutlined: true,
                      ),
                      SizedBox(width: 5.0),
                      _buildButton(
                        language.text('yesexit'),
                        Icons.exit_to_app_rounded, widget.press,
                        isOutlined: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed, {required bool isOutlined}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            gradient: isOutlined
                ? null
                : const LinearGradient(
              colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: isOutlined
                ? Border.all(color: const Color(0xFF1E40AF), width: 2)
                : null,
            boxShadow: isOutlined
                ? null
                : [
              BoxShadow(
                color: const Color(0xFF1E40AF).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   icon,
              //   color: isOutlined ? const Color(0xFF1E40AF) : Colors.white,
              //   size: 20,
              // ),
              // const SizedBox(width: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isOutlined ? const Color(0xFF1E40AF) : Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
