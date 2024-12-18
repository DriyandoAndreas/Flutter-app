import 'package:flutter/foundation.dart';
import 'package:app5/database/sqlite_helper.dart';
import 'package:app5/models/sqlite_user_model.dart';

class SqliteUserProvider with ChangeNotifier {
  late SqliteUserModel _currentuser = SqliteUserModel();

  SqliteUserModel get currentuser => _currentuser;

  set currentuser(SqliteUserModel currentuser) {
    _currentuser = currentuser;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    final List<SqliteUserModel> users = await SqLiteHelper().getusers();
    if (users.isNotEmpty) {
      _currentuser = users.first;
      notifyListeners();
    }
  }

  Future<void> clearState() async {
    SqliteUserModel data = SqliteUserModel();
    _currentuser = data;
    notifyListeners();
  }
}
