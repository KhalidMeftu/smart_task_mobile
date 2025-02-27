import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool required;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextEditingController? repeatPasswordController;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    required this.required,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.repeatPasswordController,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.hintText}${widget.required ? ' *' : ''}',
          style: SmartTaskFonts.medium().copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: SmartTaskAppColors.blackColor),
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 60,
          child: TextFormField(
            cursorColor: SmartTaskAppColors.primaryColor,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: SmartTaskAppColors.blackColor),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: SmartTaskAppColors.primaryColor.withOpacity(0.3),
                    width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: SmartTaskAppColors.primaryColor, width: 1.0),
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: SmartTaskAppColors.blackColor),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
                  : null,
            ),
            style: SmartTaskFonts.medium().copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).brightness == Brightness.dark
                    ? SmartTaskAppColors.whiteColor
                    : SmartTaskAppColors.blackColor,
                fontSize: 16),
            validator: (value) {
              if (widget.validator != null) {
                return widget.validator!(value);
              }
              if (widget.isPassword && value != null && value.isEmpty) {
                return 'Password is required';
              }
              if (widget.repeatPasswordController != null &&
                  value != widget.repeatPasswordController!.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
