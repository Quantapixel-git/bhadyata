import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class SessionManager {
  static Future<void> setValue(String key, String value) async {
    if (kIsWeb) {
      html.window.localStorage[key] = value;
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    }
  }

  static Future<String?> getValue(String key) async {
    if (kIsWeb) {
      return html.window.localStorage[key];
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
  }

  static Future<void> removeValue(String key) async {
    if (kIsWeb) {
      html.window.localStorage.remove(key);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    }
  }

  static Future<void> clearAll() async {
    if (kIsWeb) {
      html.window.localStorage.clear();
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
  }
}
