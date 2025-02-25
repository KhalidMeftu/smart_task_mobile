import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';

class BuildTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType inputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final Color fillColor;
  final Color hintColor;
  final int? maxLength;
  final Function onChange;


   BuildTextField(
      {super.key,
        required this.hint,
        this.controller,
        required this.inputType,
        this.prefixIcon,
        this.suffixIcon,
        this.obscureText = false,
        this.enabled = true,
        this.fillColor=Colors.white,
        this.hintColor=Colors.grey,
        this.maxLength,
        required this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        onChange(value);
      },
      validator: (val) => val!.isEmpty ? 'required' : null,
      keyboardType: inputType,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: inputType == TextInputType.multiline ? 3 : 1,
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        counterText: "",
        fillColor: fillColor,
        filled: true,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: SmartTaskFonts.medium().copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: hintColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorStyle:  SmartTaskFonts.medium().copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: SmartTaskAppColors.redColor),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 1, color:SmartTaskAppColors.primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 0, color: fillColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 0, color:SmartTaskAppColors.greyColor),
        ),
        border:  OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(width: 0, color: SmartTaskAppColors.greyColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(width: 1, color: SmartTaskAppColors.greyColor)),
        focusedErrorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(width: 1, color: SmartTaskAppColors.greyColor)),
        focusColor: SmartTaskAppColors.whiteColor,
        hoverColor: SmartTaskAppColors.whiteColor,
      ),
      cursorColor: SmartTaskAppColors.primaryColor,
      style:  SmartTaskFonts.medium().copyWith(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: SmartTaskAppColors.blackColor),
    );
  }
}