import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/users/users_types.dart';

abstract class UsersRepository {
  Future<UsersList> fetchUsers();

  Future<int> deleteUsers(List<int> ids);

  Future<int> changeUsersRole(UserRole role, List<int> ids);
}
