import 'package:flutter_app/mmis/utils/dimensions.dart';
import 'package:flutter_app/mmis/utils/my_color.dart';
import 'package:flutter_app/mmis/view/components/text/default_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuRowWidget extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onPressed;
  final bool? isSvg;
  const MenuRowWidget({Key? key, required this.image, required this.label, required this.onPressed, this.isSvg = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              isSvg! ? SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(
                        image,
                         height: 20,
                         width: 20,
                         color: MyColor.getSelectedIconColor(),
                         fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      image,
                      color: MyColor.getSelectedIconColor(),
                      height: 20,
                      width: 20,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(width: Dimensions.space15),
              DefaultText(text: label, textColor: MyColor.getTextColor())
            ],
          ),
          Container(
            alignment: Alignment.center,
            height: 30,
            width: 30,
            decoration: const BoxDecoration(color: MyColor.transparentColor, shape: BoxShape.circle),
            child: Icon(Icons.arrow_forward_ios_rounded, color: MyColor.getTextColor(), size: 15),
          )
        ],
      ),
    );
  }
}
