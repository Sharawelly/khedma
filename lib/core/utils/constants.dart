import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:url_launcher/url_launcher.dart';

import '/core/api/dio_consumer.dart';
import '/core/utils/app_strings.dart';
import '/core/utils/extension.dart';
import '/core/utils/log_utils.dart';
import '/core/widgets/app_snack_bar.dart';
import '../../config/locale/app_localizations.dart';
import '../../injection_container.dart';

final Color baseColorShimmer = Colors.grey.shade300;
final Color highlightColorShimmer = Colors.grey.shade100;

class Constants {
  static const String appVersionType = 'test'; // live, test
  static String getSystemLang() {
    Locale locale = ui.PlatformDispatcher.instance.locale;
    return locale.languageCode;
  }

  static Future<void> launchAppUrl(String url) async {
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Log.d(e.toString());
      throw 'Could not launch $url';
    }
  }

  static String buildImage(String img) {
    String imagePath = '';
    if (img.isNotEmpty) {
      if (img.contains(ApiConstants.baseUrl)) {
        return img;
      } else {
        imagePath = "${ApiConstants.baseUrl}$img";
        return imagePath;
      }
    } else {
      return imagePath;
    }
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      log('Could not launch $url');
    }
  }

  static Future<bool> launchEmail(String email, {BuildContext? context}) async {
    if (email.isEmpty) {
      Log.e('Email is empty');
      if (context != null && context.mounted) {
        showAppSnackBar(
          context: context,
          message: 'email_is_empty'.tr,
          type: ToastType.error,
        );
      }
      return false;
    }
    final Uri emailUri = Uri.parse('mailto:$email');
    try {
      if (await canLaunchUrl(emailUri)) {
        final launched = await launchUrl(emailUri);
        if (!launched && context != null && context.mounted) {
          showAppSnackBar(
            context: context,
            message: 'could_not_launch_email'.tr,
            type: ToastType.error,
          );
        }
        return launched;
      } else {
        Log.e('Could not launch email to $email');
        if (context != null && context.mounted) {
          showAppSnackBar(
            context: context,
            message: 'no_email_app_configured'.tr,
            type: ToastType.error,
          );
        }
        return false;
      }
    } catch (e) {
      Log.e('Could not launch email to $email: ${e.toString()}');
      if (context != null && context.mounted) {
        showAppSnackBar(
          context: context,
          message: 'could_not_launch_email'.tr,
          type: ToastType.error,
        );
      }
      return false;
    }
  }

  static Future<String?> getAgent({bool isFullAgent = true}) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return isFullAgent
          ? "${iosDeviceInfo.systemName} - ${iosDeviceInfo.name} - ${iosDeviceInfo.identifierForVendor} - ${iosDeviceInfo.model} - $version"
          : iosDeviceInfo.systemName;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return isFullAgent
          ? "Android - ${androidDeviceInfo.model} - $version"
          : "Android";
    } else {
      return '';
    }
  }

  static Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    } else {
      return '';
    }
  }

  static Future<String> getModel() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.model;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model;
    } else {
      return '';
    }
  }
  // static Future<void> makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   try {
  //     await launchUrl(launchUri);
  //   } catch (e) {
  //     throw 'Could not launch $launchUri';
  //   }
  // }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  static Color textColor(FocusNode focusNode, BuildContext context) {
    return focusNode.hasFocus ? colors.main : colors.textColor;
  }

  static ColorFilter colorFilter(Color color) {
    return ColorFilter.mode(color, BlendMode.srcIn);
  }

  static Future<String?> phoneParsing({
    String? phone,
    String? countryCode,
    bool withCode = true,
  }) async {
    PhoneNumber phoneParsed;
    try {
      phoneParsed = PhoneNumber.parse(
        phone!,
        callerCountry: IsoCode.values
            .where((element) => element.name == countryCode!.toUpperCase())
            .first,
        destinationCountry: countryCode == 'SA'
            ? IsoCode.SA
            : IsoCode.values
                  .where(
                    (element) => element.name == countryCode!.toUpperCase(),
                  )
                  .first,
      );

      if (phoneParsed.isValid()) {
        return withCode == true ? phoneParsed.international : phoneParsed.nsn;
      } else {
        log('Phone number is invalid');
        // throw 'Invalid Phone Number';
        return null;
      }
    } on PlatformException {
      rethrow;
    }
  }

  static bool checkPDFFiles(String file) {
    var newString = file.substring(file.length - 5);

    debugPrint('file $file');
    debugPrint('checkFile pdf or image  $newString');
    return newString.contains('pdf') ? true : false;
  }

  static bool checkAuth(String msg) {
    return msg == AppStrings.unAuthorizedFailure ||
        msg == AppStrings.tokenFailure;
  }

  static void showErrorDialog({
    required BuildContext context,
    required String msg,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          msg,
          style: TextStyle(color: colors.textColor, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop,
            style: TextButton.styleFrom(
              foregroundColor: colors.textColor,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  // static void showToast(
  //     {required String msg, Color? color, ToastGravity? gravity}) {
  //   Fluttertoast.showToast(
  //       toastLength: Toast.LENGTH_LONG,
  //       msg: msg,
  //       backgroundColor: color ?? colors.main,
  //       gravity: gravity ?? ToastGravity.BOTTOM);
  // }

  /// Type: 1 done , 2: warning, 3: error
  static void showSnakToast({required context, message, type}) {
    Color background = colors.main;
    Color textColor = colors.textColor;
    var width = MediaQuery.of(context).size.width;

    String icon = '';

    switch (type) {
      // Add to WishList
      case 1:
        background = colors.main;
        icon = 'assets/images/done.png';
        textColor = colors.backGround;
        textColor = colors.backGround;
        break;

      // warning
      case 2:
        background = colors.secondary;
        icon = 'assets/images/warning.png';
        textColor = colors.backGround;
        textColor = colors.backGround;
        break;
      // error
      case 3:
        background = colors.errorColor;
        icon = 'assets/images/warning.png';
        textColor = colors.backGround;
        textColor = colors.backGround;
        break;

      // General
      case 4:
        background = colors.backGround;
        icon = 'assets/address.svg';
        textColor = colors.textColor;
        textColor = colors.backGround;
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        elevation: 3,
        content: type != 5
            ? Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(icon, width: 25, color: textColor),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: width * 0.7,
                      child: Text(
                        message,
                        style: TextStyle(color: textColor),
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    width: width * 0.8,
                    child: Center(
                      child: Text(
                        message,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: textColor),
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        Log.e('Could not launch phone call to $phoneNumber');
      }
    } catch (e) {
      Log.e(e.toString());
    }
  }

  //openGallery
  static void imagesSourcesShowModel({
    required BuildContext context,
    Function? onCameraPressed,
    Function? onGalleryPressed,
    Function? onPDFPressed,
    bool? containPDF = false,
    bool? allowMultible = false,
  }) async {
    buildCustomShowModel(
      context: context,
      height: containPDF == true ? 210.0 : 140.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.text('takePhoto'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              onPressed: () {
                onCameraPressed!();
                //
              },
            ),
          ),
          // Gallery //
          Expanded(
            child: TextButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.text(
                    allowMultible == true ? 'selectImages' : 'selectImage',
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              onPressed: () {
                onGalleryPressed!();
              },
            ),
          ),
          containPDF == true
              ? Expanded(
                  child: TextButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!.text('selectPDF'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    onPressed: () {
                      onPDFPressed!();
                    },
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  static void buildCustomShowModel({
    required BuildContext context,
    required Widget child,
    double? height,
    EdgeInsets? padding,
  }) async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: colors.backGround,
          ),
          height: height,
          width: ScreenUtil().screenWidth,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16.0),
          child: child,
        );
      },
    );
  }

  static void showLoading(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: colors.textColor.withValues(alpha: 0.65),
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(color: colors.main).appLoading,
        );
      },
    );
  }

  static void hideLoading(context) {
    // Only pop if there's actually a route to pop (i.e., a dialog is shown)
    // This prevents accidentally popping the screen when no loading dialog exists
    final navigator = Navigator.of(context, rootNavigator: false);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  Future<int> getImageFileSize(File file) async {
    int fileSize = file.lengthSync();
    Log.d("File Size is: $fileSize");
    return fileSize;
  }

  Future<File?> getCompressedFile(File file, String targetPath) async {
    XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
    );

    if (result != null) {
      log(
        "Original File Size -- ${file.lengthSync()} --- CompressedFile ${File(result.path).lengthSync()} ",
      );
      return File(result.path);
    } else {
      return null;
    }
  }

  // static void navigateTo(double lat, double lng) async {
  //   var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not launch ${uri.toString()}';
  //   }
  // }
  static String getInitials(String fullName) {
    // Split the full name into a list of words
    List<String> words = fullName.split(' ');

    // If there are at least two words, get the first character of each word
    if (words.length >= 2) {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    }

    // If there is only one word, return the first two characters capitalized
    if (words.length == 1 && words[0].length >= 2) {
      return words[0][0].toUpperCase() + words[0][1].toUpperCase();
    }

    // If the input doesn't meet the requirements, return an empty string
    return '';
  }

  /// Generates a random password with the specified length
  ///
  /// [length] - The desired length of the password (default: 12)
  /// [includeUppercase] - Whether to include uppercase letters (default: true)
  /// [includeLowercase] - Whether to include lowercase letters (default: true)
  /// [includeNumbers] - Whether to include numbers (default: true)
  /// [includeSpecialChars] - Whether to include special characters (default: true)
  ///
  /// Returns a randomly generated password string
  static String generateRandomPassword({
    int length = 12,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecialChars = true,
  }) {
    const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (includeUppercase) chars += uppercase;
    if (includeLowercase) chars += lowercase;
    if (includeNumbers) chars += numbers;
    if (includeSpecialChars) chars += specialChars;

    // Ensure at least one character set is included
    if (chars.isEmpty) {
      chars = uppercase + lowercase + numbers;
    }

    final random = math.Random.secure();
    final password = StringBuffer();

    // Generate password
    for (int i = 0; i < length; i++) {
      password.write(chars[random.nextInt(chars.length)]);
    }

    return password.toString();
  }
}

abstract class ArabicNumeric {
  static String zero = '٠';
  static String one = '١';
  static String two = '٢';
  static String three = '٣';
  static String four = '٤';
  static String five = '٥';
  static String six = '٦';
  static String seven = '٧';
  static String eight = '٨';
  static String nine = '٩';
}
