import 'package:dating_app/features/splash/user_auth/presentation/cubit/mobile_number_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/mobile_number_screen_widgets/mobile_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';

class MobileInput extends StatelessWidget {
  final PhoneController phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.IN, nsn: ''),
  );

  MobileInput({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileTextfield(
      label: 'Mobile Number',
      controller: phoneController,
      autofocus: false,
      isCountrySelectionEnabled: false,
      onChanged: (phone) {
        final bool valid = phone?.isValid() ?? false;
        final String number = phone?.nsn ?? "";
        context.read<MobileNumberCubit>().onNumberChanged(number, valid: valid);
      },
    );
  }
}
