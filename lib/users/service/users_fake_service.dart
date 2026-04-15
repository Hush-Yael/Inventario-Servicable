import 'dart:math';
import 'package:faker/faker.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/users/service/users_repository.dart';
import 'package:servicable_stock/users/users_types.dart';

class FakeUsersService implements UsersRepository {
  final random = Random();

  @override
  Future<UsersList> fetchUsers() async {
    await Future.delayed(const Duration(seconds: 1));

    var faker = Faker(seed: 5002);

    return List.generate(10, (index) {
      return User(
        id: index,
        name: faker.person.name(),
        username: faker.internet.userName(),
        role: UserRole.values[index % 3],
        password: '',
        salt: '',
        createdAt: faker.date.dateTime(),
        lastLogin: random.nextBool()
            ? null
            : faker.date.dateTimeBetween(
                DateTime.now().subtract(const Duration(days: 30)),
                DateTime.now(),
              ),
      );
    });
  }

  @override
  Future<int> deleteUsers(List<int> ids) async {
    await Future.delayed(const Duration(seconds: 1));

    if (random.nextBool()) {
      throw Exception('No se pudieron eliminar los usuarios');
    }

    return ids.length;
  }

  @override
  Future<int> changeUsersRole(UserRole role, List<int> ids) async {
    await Future.delayed(const Duration(seconds: 1));

    if (random.nextBool()) {
      throw Exception('No se pudieron eliminar los usuarios');
    }

    return ids.length;
  }
}
