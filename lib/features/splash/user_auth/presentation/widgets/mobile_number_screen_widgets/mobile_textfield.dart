import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class MobileTextfield extends StatelessWidget {
  final PhoneController controller;
  final void Function(PhoneNumber?)? onChanged;
  final String label;
  final bool enabled;
  final bool autofocus;
  final bool countryButtonVisible;
  final bool isCountrySelectionEnabled;
  final String? Function(PhoneNumber?)? validator;

  const MobileTextfield({
    super.key,
    required this.controller,
    this.onChanged,
    this.label = "Mobile Number",
    this.enabled = true,
    this.autofocus = false,
    this.validator,
    this.countryButtonVisible = true,
    this.isCountrySelectionEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return PhoneFormField(
      controller: controller,
      autofocus: autofocus,
      shouldLimitLengthByCountry: true,
      cursorColor: Colors.white,
      keyboardType: TextInputType.number,
      enabled: enabled,
      countryButtonStyle: CountryButtonStyle(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(controlWidth(context, 32)),
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: controlWidth(context, 17.5),
      ),
      validator:
          validator ??
          PhoneValidator.compose([
            PhoneValidator.required(context),
            PhoneValidator.validMobile(context),
          ]),
      countrySelectorNavigator:
          const CountrySelectorNavigator.modalBottomSheet(),
      isCountryButtonPersistent: countryButtonVisible,
      isCountrySelectionEnabled: isCountrySelectionEnabled,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.symmetric(
          vertical: controlHeight(context, 60),
          horizontal: controlWidth(context, 150),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: controlWidth(context, 26),
        ),
        filled: true,
        fillColor: Colors.white.withAlpha(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlWidth(context, 32)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlWidth(context, 32)),
          borderSide: const BorderSide(color: AppColor.textFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlWidth(context, 32)),
          borderSide: const BorderSide(color: AppColor.primary, width: 3),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
