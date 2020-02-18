import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/User.dart';

class FileAccess {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user.txt');
  }

  static Future<File> write(User user) async {
    final file = await _localFile;

    // Write the file.
    var content = jsonEncode(user);
    return file.writeAsString('$content');
  }

  static Future<File> delete2() async {
    final file = await _localFile;

    // Write the file.
    return file.delete();
  }

  static Future<User> read() async {
    try {
      final file = await _localFile;

      // Read the file.
      var contents = await file.readAsString();

      var userMap = jsonDecode(contents);
      var user = User.fromJson(userMap);

      return user;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }
}
