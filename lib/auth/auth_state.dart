import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/db/db.dart';

class AuthState extends ChangeNotifier {
  AuthState._internal();

  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  bool isAuthenticated() => _user != null;

  static final instance = Provider((context) => AuthState._internal());
}
