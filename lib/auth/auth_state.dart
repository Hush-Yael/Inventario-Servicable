import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/db/db.dart';

class AuthState extends ChangeNotifier {
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

  static final provider = Provider((context) => AuthState());
}
