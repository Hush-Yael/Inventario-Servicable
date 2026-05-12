import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography_plus/cryptography_plus.dart';

class PasswordManager {
  PasswordManager();

  final algorithm = Argon2id(
    memory: 10 * 1000, // 10 MB
    parallelism: 2, //  two CPU cores.
    iterations: 1,
    hashLength: 32,
  );

  final random = Random.secure();

  Future<bool> compare({
    required String passwordToCompare,
    required String hashedPassword,
    required String encodedSalt,
  }) async {
    final secretPassToCompare = await securePassword(
      passwordValue: passwordToCompare,
      salt: base64Decode(encodedSalt),
    );

    final String hashToCompare = base64Encode(
      await secretPassToCompare.extractBytes(),
    );

    return hashToCompare == hashedPassword;
  }

  Uint8List generateSalt() =>
      Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));

  Future<SecretKey> securePassword({
    required String passwordValue,
    required List<int> salt,
  }) async {
    return await algorithm.deriveKeyFromPassword(
      password: passwordValue,
      nonce: salt,
    );
  }
}
