/*========================Email Validator==============================================*/

import '../../export.dart';

class EmailValidator {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return strEmailEmpty;
    } else if (!GetUtils.isEmail(value.trim())) {
      return strInvalidEmail;
    }
    return null;
  }
}

/*================================================== Password Validator ===================================================*/

class PasswordFormValidator {
  static String? validatePassword(String value) {
    var pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return strPasswordEmpty;
    } else if (value.length < 8) {
      return strInvalidPassword;
    }else if(!regExp.hasMatch(value)){
      return strPasswordNotSecure;
    }
    return null;
  }



  static String? validateConfirmPasswordMatch(
      {String? value, String? password}) {
    var pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return strConfirmPasswordEmpty;
    } else if (value.length < 8) {
      return strConfirmInvalidPassword;
    } else if(!regExp.hasMatch(value)){
      return strPasswordNotSecure;
    }else if (value != password) {
      return strPasswordMatch;
    }
    return null;
  }
}

/*================================================== Phone Number Validator ===================================================*/

class PhoneNumberValidate {
  static String? validateMobile(String value) {
    if (value.isEmpty) {
      return strPhoneEmEmpty;
    } else if (value.length < 8 || value.length > 15) {
      return strPhoneNumberInvalid;
    } else if (!validateNumber(value)) {
      return strSpecialCharacter;
    }
    return null;
  }
}

bool validateNumber(String value) {
  var pattern = r'^[0-9]+$';
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

/*===============================Field Checker=================================================*/
class FieldChecker {
  static String? fieldChecker({String? value, message}) {
    if (value == null || value.toString().trim().isEmpty) {
      return "$message $strCannotBeEmpty";
    }
    return null;
  }
}