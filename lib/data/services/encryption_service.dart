import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class EncryptionService {
  static final key = Key.fromLength(32); // Tạo key 32 bytes
  static final iv = IV.fromLength(16); // Tạo IV 16 bytes
  static final encrypter = Encrypter(AES(key));

  // Mã hoá string
  static String encrypt(String text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  // Giải mã string
  static String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  // Mã hoá object
  static String encryptObject(Map<String, dynamic> object) {
    final jsonString = json.encode(object);
    return encrypt(jsonString);
  }

  // Giải mã object
  static Map<String, dynamic>? decryptObject(String encryptedText) {
    try {
      final decryptedString = decrypt(encryptedText);
      return json.decode(decryptedString);
    } catch (e) {
      return null;
    }
  }

  // Mã hoá list object
  static String encryptList(List<Map<String, dynamic>> list) {
    final jsonString = json.encode(list);
    return encrypt(jsonString);
  }

  // Giải mã list object
  static List<Map<String, dynamic>>? decryptList(String encryptedText) {
    try {
      final decryptedString = decrypt(encryptedText);
      List<dynamic> list = json.decode(decryptedString);
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }
} 