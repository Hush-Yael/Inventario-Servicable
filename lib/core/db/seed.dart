// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:faker/faker.dart';
import 'package:servicable_stock/shared/password_manager.dart';

enum Category {
  ONU(
    usesDetailedUnits: true,
    products: [
      (name: 'ONU XPON BT-131XR', code: 'ONUXPON131XR'),
      (name: 'ONU XPON BT-6712AX SERVITEL C/ CATV', code: 'ONUBTG710'),
      (name: 'ONU/ONT MULTICON G3100-CF/CATV', code: 'ONU/ΟΝΤP4-RF'),
      (name: 'UNU AMERICAN PON SOLO INT.', code: 'ONUV-003'),
      (name: 'UNU V SOL G/EPON V2802AACT DUAL', code: 'ONUV-002'),
      (name: 'UNU V-SOL 2001 SIN WIFI', code: 'ONUV-001'),
    ],
  ),

  router(
    usesDetailedUnits: true,
    products: [
      (name: 'NETPRO AX1800 DUAL BAN', code: 'ROUTERCCR1072'),
      (name: 'TP-LINKAC1200 DUAL', code: 'ROUTERAC1200'),
      (name: 'TP-LINK AX1500 WIFI 6', code: 'ROUTERAX1500'),
      (name: 'VI-SOL AX3000 WIFI 6', code: 'ROUTERG5013-4G'),
    ],
  ),

  patch(
    label: 'Patch cord',
    products: [
      (name: 'SC/APC SC/APC 2M', code: 'APC/APC-2M'),
      (name: 'SC/APC SC/UPC 3M', code: 'APC/UPC-3M'),
    ],
  ),

  kit(products: [(name: 'Kit de de instalación rápida', code: 'KITRAPIDO')]),

  preformado(
    label: 'Preformado para fibra óptica',
    products: [
      (name: 'Preformado ASU 10-12MM', code: 'PREFASUSS'),
      (name: 'Preformado ASU 6-7MM', code: 'PREFASU'),
    ],
  ),

  fleje(
    products: [
      (name: 'Fleje de acero inoxidable 3/4 30 MTS', code: 'FLEJE3/430MTS'),
    ],
  ),

  grapas(
    products: [
      (
        name: 'Grapas para cable 8mm con clavo de acero pack de 100 UND',
        code: ' GRAPAS8MM',
      ),
    ],
  ),

  herraje(
    products: [(name: 'Herraje tipo trompo platina', code: 'HERRAJETRO')],
  ),

  hebilla(products: [(name: 'Hebilla de correa', code: 'HEBILLA3/4')]),

  manga(
    products: [
      (name: 'Manga 48FO entrada oval', code: 'MANGA48'),
      (name: 'Manga 96FO entrada circular', code: 'MANGA96CIR'),
    ],
  ),

  NAP(
    products: [
      (
        name: 'NAP 16 puertos com splitter 1*16 y 4 entradas FDT',
        code: 'NAP16/1x16-4FDT',
      ),
      (
        name: 'NAP 8 puertos con splitter 1*16 y 4 entradas FDT',
        code: 'NAPS/1x8-2',
      ),
    ],
  ),

  splitter(
    products: [
      (name: 'SPLITTER 1X16', code: 'SPLITTER1x16'),
      (name: 'SPLITTER 1X8', code: 'SPLITTER1x8'),
      (name: 'SPLITTER 1X2 0.91M con conector', code: 'SPLITTER10/90'),
    ],
  );

  const Category({
    required this.products,
    this.usesDetailedUnits = false,
    this.label,
  });

  final String? label;
  final List<({String code, String name})> products;
  final bool usesDetailedUnits;
}

Future<void> seed(AppDatabase db) async {
  final pm = PasswordManager();

  final salt = pm.generateSalt();

  final pass = await pm.securePassword(passwordValue: 'admin', salt: salt);

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

  await db.batch((batch) async {
    batch.insertAll(
      db.categories,
      Category.values.mapIndexed((i, cat) {
        return CategoriesCompanion.insert(
          name: cat.label ?? cat.name.uppercaseFirst(),
        );
      }),
    );

    batch.insertAll(
      db.products,
      Category.values
          .mapIndexed((i, cat) {
            return cat.products.mapIndexed((j, product) {
              final usesDetailedUnits = cat.usesDetailedUnits;

              return ProductsCompanion.insert(
                name: product.name,
                code: product.code,
                categoryId: Value(i + 1),
                units: !usesDetailedUnits
                    ? Value(faker.randomGenerator.integer(100))
                    : Value.absent(),
                usesDetailedUnits: Value(usesDetailedUnits),
              );
            });
          })
          .expand((l) => l),
    );

    Category.values.where((cat) => cat.usesDetailedUnits).forEach((cat) {
      batch.insertAll(
        db.units,
        List.generate(
          cat.products.length,
          (i) => UnitsCompanion.insert(
            identifier: faker.randomGenerator.fromCharSet(
              'ABCDEFGHIJKLMONPQESTUVWXYZ#/-_1234567890',
              20,
            ),
            productId: Value(i + 1),
            soldTo: faker.randomGenerator.boolean()
                ? Value(faker.person.name())
                : Value.absent(),
            details: faker.randomGenerator.boolean()
                ? Value(faker.lorem.sentence())
                : Value.absent(),
          ),
        ),
      );
    });
  });
}
