import 'dart:convert';

import 'package:cryptography_plus/cryptography_plus.dart';
import 'package:drift/drift.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:faker/faker.dart';

Future<void> seed(AppDatabase db) async {
  final algorithm = Argon2id(
    memory: 10 * 1000, // 10 MB
    parallelism: 2, //  two CPU cores.
    iterations: 1,
    hashLength: 32,
  );

  final salt = Uint8List(8);
  final pass = await algorithm.deriveKeyFromPassword(
    password: 'admin',
    nonce: salt,
  );

  await db
      .into(db.users)
      .insert(
        UsersCompanion.insert(
          role: UserRole.admin,
          name: 'Administrador',
          username: 'admin',
          password: base64Encode(await pass.extractBytes()),
          salt: base64Encode(salt),
          lastLogin: Value(DateTime.now()),
        ),
      );

  const List<String> defaultCategories = [
    'Router',
    'ONU',
    'Splitter',
    'Fleje',
    'Pack de grapas',
    'Kit',
    'Herraje',
    'Manga',
    'NAP',
    'Patch cord',
  ];

  await db.batch((batch) async {
    batch.insertAll(
      db.categories,
      List.generate(
        defaultCategories.length,
        (i) => CategoriesCompanion.insert(name: defaultCategories[i]),
      ),
    );

    final productsList = List.generate(defaultCategories.length, (i) {
      final cat = defaultCategories[i];
      final usesDetailedUnits = faker.randomGenerator.boolean();

      return ProductsCompanion.insert(
        code: faker.randomGenerator.string(10),
        name:
            '$cat - ${faker.lorem.word()} ${faker.randomGenerator.string(10)}',
        usesDetailedUnits: Value(usesDetailedUnits),
        units: !usesDetailedUnits
            ? Value(faker.randomGenerator.integer(100))
            : Value.absent(),
        categoryId: Value(i + 1),
      );
    });

    batch.insertAll(db.products, productsList);

    for (var i = 0; i < productsList.length; i++) {
      final product = productsList[i];

      if (product.usesDetailedUnits.value == true) {
        batch.insertAll(
          db.units,
          List.generate(
            faker.randomGenerator.integer(10),
            (i) => UnitsCompanion.insert(
              identifier: faker.randomGenerator.string(20),
              productId: Value(i + 1),
            ),
          ),
        );
      }
    }
  });
}
