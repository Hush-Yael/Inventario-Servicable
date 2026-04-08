import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/db/db.dart';

class AuthController extends ChangeNotifier {
  User? _user; /* = User(
    id: 0,
    name: 'Administrador',
    username: 'admin',
    role: UserRole.admin,
    password: '',
    salt: '',
    createdAt: DateTime.now(),
  ); */

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

  static final provider = Provider((context) => AuthController());
}
