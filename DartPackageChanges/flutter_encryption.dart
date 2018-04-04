
/**
//// Original package code is located at 

~/.pub-cache/hosted/pub.dartlang.org/flutter_string_encryption-0.0.1/lib/flutter_string_encryption.dart

ISSUE:

FIX: 
Change all Future<String> to Future

**/

import 'dart:async';

import 'package:flutter/services.dart';

/// Interface for the Plugin
abstract class StringCryptor {
  /// Generates a random key to use with [encrypt] and [decrypt] methods
  Future generateRandomKey();

  /// Gets a key from the given [password] and [salt]. [salt] can be generated
  /// with [generateSalt] while [password] is usually provided by the user.
  Future generateKeyFromPassword(String password, String salt);

  /// Generates a salt to use with [generateKeyFromPassword]
  Future generateSalt();

  /// Encrypts [string] using a [key] generated from [generateRandomKey] or
  /// [generateKeyFromPassword]. The returned string is a sequence of 3
  /// base64-encoded strings (iv, mac and cipherText) and can be transferred and
  /// stored almost anywhere.
  Future encrypt(String string, String key);

  /// Decrypts [data] created with the [encrypt] method using a [key] created
  /// with [generateRandomKey] or [generateKeyFromPassword] methods.
  /// In case the [key] is wrong or the [data] has been forged, a
  /// [MacMismatchException] is thrown
  Future decrypt(String data, String key);
}

/// Implementation of [StringCryptor] using platform channels
class PlatformStringCryptor implements StringCryptor {
  static const MethodChannel _channel =
      const MethodChannel('flutter_string_encryption');

  static final _cryptor = new PlatformStringCryptor._();

  factory PlatformStringCryptor() => _cryptor;

  PlatformStringCryptor._();

  @override
  Future decrypt(String data, String key) async {
    try {
      final decrypted = await _channel.invokeMethod("decrypt", {
        "data": data,
        "key": key,
      });
      return decrypted;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "mac_mismatch":
          throw new MacMismatchException();
        default:
          rethrow;
      }
    }
  }

  @override
  Future encrypt(String string, String key) =>
      _channel.invokeMethod("encrypt", {
        "string": string,
        "key": key,
      });

  @override
  Future generateRandomKey() =>
      _channel.invokeMethod("generate_random_key");

  @override
  Future generateSalt() => _channel.invokeMethod("generate_salt");

  @override
  Future generateKeyFromPassword(String password, String salt) =>
      _channel.invokeMethod("generate_key_from_password", <String, String>{
        "password": password,
        "salt": salt,
      });
}

class MacMismatchException implements Exception {
  final String message =
      "Mac don't match, either the password is wrong, or the message has been forged.";
}
