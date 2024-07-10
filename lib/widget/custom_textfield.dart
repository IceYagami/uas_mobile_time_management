import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../style.dart';
import '../utils/contants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key, // Add Key? key parameter here
    required this.controller,
    required this.textInputType,
    required this.textInputAction,
    required this.hint,
    this.validator,
    this.errorText,
    this.isObscure = false, // Corrected typo here: isObscure
    this.hasSuffix = false,
    this.onPressed,
  }); // Initialize super with key parameter

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? errorText;
  final bool hasSuffix;
  final String hint;
  final bool isObscure; // Corrected typo here: isObscure
  final VoidCallback? onPressed;
  final TextInputAction textInputAction;
  final TextInputType textInputType;

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.0,
        color: color,
      ),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        controller: controller,
        style: TextStyles.body.copyWith(
          color: createThemeColorSchema(
              lightColor: AppColors.grey, darkColor: Colors.white),
        ),
        cursorColor: createThemeColorSchema(
            lightColor: AppColors.grey, darkColor: Colors.white),
        keyboardType: textInputType,
        obscureText: isObscure,
        validator: validator,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          suffixIcon: hasSuffix
              ? IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
          enabledBorder: _buildBorder(AppColors.grey),
          errorText: errorText, // Display error text if errorText is not null
          errorBorder: _buildBorder(Colors.red),
          focusedErrorBorder: _buildBorder(Colors.red),
          focusedBorder: _buildBorder(AppColors.grey),
          hintText: hint,
          hintStyle: TextStyle(
              color: createThemeColorSchema(
                  darkColor: Colors.white, lightColor: AppColors.grey)),
        ),
      ),
    );
  }
}
