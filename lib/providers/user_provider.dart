import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier{

  String _name = "";
  String _targetDepartment = "";
  double _tytNet = 0.0;
  double _aytNet = 0.0;

  String get name => _name;
  String get targetDepartment => _targetDepartment;
  double get tytNet => _tytNet;
  double get aytNet => _aytNet;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
  void setTargetDepartment(String targetDepartment) {
    _targetDepartment = targetDepartment;
    notifyListeners();
  }
  void setTytNet(double tytNet) {
    _tytNet = tytNet;
  }
  void setAytNet(double aytNet) {
    _aytNet = aytNet;
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", _name);
    await prefs.setString("targetDepartment", _targetDepartment);
    await prefs.setDouble("tytNet", _tytNet);
    await prefs.setDouble("aytNet", _aytNet);

  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name") ?? "";
    _targetDepartment = prefs.getString("targetDepartment") ?? "";
    _tytNet = prefs.getDouble("tytNet") ?? 0.0;
    _aytNet = prefs.getDouble("aytNet" )?? 0.0;
    notifyListeners();
  }
}