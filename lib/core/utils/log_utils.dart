import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class Log {
  static const perform = MethodChannel('x_log');

  static var logger = Logger();

  static void d(String msg, {tag = 'X-LOG'}) {
    logger.d(msg);
  }

  static void w(String msg, {tag = 'X-LOG'}) {
    logger.w(msg);
  }

  static void i(String msg, {tag = 'X-LOG'}) {
    logger.i(msg);
  }

  static void e(String msg, {tag = 'X-LOG'}) {
    logger.e(msg);
  }

  static void json(String msg, {tag = 'X-LOG'}) {
    try {
      logger.f(msg);
    } catch (e) {
      d(msg);
    }
  }
}
