import 'package:flutter_app/mmis/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/my_color.dart';

class FormRow extends StatelessWidget {
  const FormRow({Key? key,
    required this.label,
    required this.isRequired}) : super(key: key);

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(label.tr,style: interBoldDefault.copyWith(color: MyColor.getPrimaryTextColor())),
        Text(isRequired?' *':'',style: interBoldDefault.copyWith(color: MyColor.red))
      ],
    );
  }
}
