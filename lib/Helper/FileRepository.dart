import 'dart:async';
import 'dart:convert';
import 'package:key_value_store/key_value_store.dart';
import '../model/User.dart';

class FileRepository {
  final KeyValueStore storage;

  FileRepository({this.storage});

  //  Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();

  //   return directory.path;
  // }

  //  Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/user.txt');
  // }

  Future<String> write(User user) async {
    var content = jsonEncode(user);
    await storage.setString("user", content);
    return null;
  }

  Future<String> delete() async {
    await storage.remove("user");
    return null;
  }

  Future<User> read() async {
    try {
      // Read the file.
      var contents = await storage.getString("user");

      var userMap = jsonDecode(contents);
      var user = User.fromJson(userMap);

      return user;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }
}
