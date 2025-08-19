import 'package:crm_clinic/core/constant.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';

abstract class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailCantBeEmpty;
    }
    if (!RegExp(Constant.regExValidateEmail).hasMatch(value)) {
      return AppStrings.enterValidEmailAddress;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordCantBeEmpty;
    }
    if (value.length < 6) {
      return AppStrings.passwordMustBeAtLeast6Characters;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return AppStrings.passwordMustContainAtLeastOneUppercaseLetter;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return AppStrings.passwordMustContainAtLeastOneNumber;
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return AppStrings.passwordMustContainAtLeastOneSpecialCharacter;
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.userNameCannotBeEmpty;
    }
    if (value.length > 20) {
      return AppStrings.userNameCannotBeMoreThan20Characters;
    }
    return null;
  }

  static dropdownButton(value) {
    if (value == null) {
      return AppStrings.fieldCannotBeEmpty;
    }
    return null;
  }

  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.dateCannotBeEmpty;
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldCannotBeEmpty;
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return AppStrings.enterValidPhoneNumber;
    }
    return null;
  }
}
