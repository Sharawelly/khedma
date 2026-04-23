import 'package:intl/intl.dart';

import '../../config/locale/app_localizations.dart';

class Validator {
  static String? nameValidate(String value, context) {
    if (value.isEmpty || value.length < 3) {
      return AppLocalizations.of(context)!.text('enterYourName');
    }
    return null;
  }

  static String? linkValidate(String value, context) {
    if (value.isNotEmpty) {
      if (value.startsWith('www.') || value.startsWith('http://')) {
        return null;
      } else {
        return AppLocalizations.of(context)!.text('enterValidUrl');
      }
    }
    return AppLocalizations.of(context)!.text('enterfield');
  }

  static String? nameArValidate(value, context, {direction = false}) {
    if (value.isEmpty || value.length < 3) {
      return AppLocalizations.of(context)!.text('enterYourNameAR');
    }
    return null;
  }

  static String? phoneValidate(String value, context) {
    if (value.isNotEmpty) {
      if (Validator.isValidPhoneNumber(value) == true) {
        return null;
      } else {
        return AppLocalizations.of(context)!.text('enterCorrectPhone');
      }
    } else {
      return AppLocalizations.of(context)!.text('enterCorrecData');
    }
  }

  static String? emailPhoneValidate(String value, context) {
    if (value.isNotEmpty) {
      if (value.contains('@')) {
        if (Validator.isEmail(value) == true) {
          return null;
        } else {
          return AppLocalizations.of(context)!.text('enterCorrectemail');
        }
      } else {
        if (Validator.isValidPhoneNumber(value) == true) {
          return null;
        } else {
          return AppLocalizations.of(context)!.text('enterCorrecData');
        }
      }
    } else {
      return AppLocalizations.of(context)!.text('enterYourE-mailOrPhoneNumber');
    }
  }

  static String? emailValidate(String value, context) {
    if (value.isNotEmpty) {
      if (value.contains('@')) {
        if (Validator.isEmail(value) == true) {
          return null;
        } else {
          return AppLocalizations.of(context)!.text('enterCorrectemail');
        }
      }
    } else {
      return AppLocalizations.of(context)!.text('enterfield');
    }
    return null;
  }

  static String? passwordValidate(value, context) {
    if (value.isEmpty || value.length < 8) {
      return AppLocalizations.of(context)!.text('shortPassText');
    }
    return null;
  }

  static String? passwordMatching(value, reValue, context) {
    if (value.isEmpty || value.length < 8) {
      return AppLocalizations.of(context)!.text('shortPassText');
    } else if (value != reValue) {
      return AppLocalizations.of(context)!.text('passwordsNotMatchText');
    }
    return null;
  }

  static bool isEmail(String email) {
    // email.trim();
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email.trim());
  }

  static bool isValidPhoneNumber(String string) {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);
    if (string.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  static String? txtValidate(value, context, {direction = false}) {
    if (value.isEmpty) {
      return direction == true
          ? AppLocalizations.of(context)!.text('enterfieldAR')
          : AppLocalizations.of(context)!.text('enterfield');
    }
    return null;
  }

  static String? startTimeTextValidate(value, context, {direction = false}) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.text('required');
    }
    return null;
  }

  static String? endTimeTextValidate(String value, value2, context) {
    if (value2.isNotEmpty) {
      var format = DateFormat("HH:mm");
      var start = format.parse(value);
      var end = format.parse(value2);

      if (start.isAfter(end)) {
        return AppLocalizations.of(context)!.text('wrongTime');
      } else {
        return null;
      }
    }
    return AppLocalizations.of(context)!.text('required');
  }

  static String? numValidate(value, context, {direction = false}) {
    if (value.isEmpty) {
      return direction == true
          ? AppLocalizations.of(context)!.text('enterfieldAR')
          : AppLocalizations.of(context)!.text('enterfield');
    }

    return null;
  }

  static String? checkCPR(value, int code, context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.text('enterfield');
    } else if (code == 3 && value.toString().length != 9) {
      return AppLocalizations.of(context)!.text('cprLenght');
    } else if (code == 2 && value.toString().length != 10) {
      return AppLocalizations.of(context)!.text('cprSALenght');
    } else if ((code != 2 || code != 3) && value.toString().length >= 15) {
      return AppLocalizations.of(context)!.text('cprEGLenght');
    } else if ((code != 2 || code != 3) && value.toString().length <= 8) {
      return AppLocalizations.of(context)!.text('cprEGLenght');
    }
    return null;
  }
}
