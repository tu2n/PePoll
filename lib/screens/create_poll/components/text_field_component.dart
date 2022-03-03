import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';

import '../../../core/common_util.dart';

class TextFieldComponent extends StatelessWidget {
  final TextEditingController txtCtrl;
  final Function(String) validator;
  final String label;
  final bool disableTap;
  final Function onTap;
  const TextFieldComponent({Key key,
    @required this.txtCtrl,
    @required this.validator,
    @required this.label,
    this.disableTap = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: txtCtrl,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      cursorColor: kLightMagenta,
      focusNode: disableTap ? AlwaysDisabledFocusNode() : null,
      decoration: InputDecoration(
        suffixIcon: disableTap ? const Icon(Icons.calendar_today_outlined, color: kLightMagenta,) : null,
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          letterSpacing: 1.5
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kPaleYellow),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kLightMagenta),
        ),
      ),
    );
  }
}
