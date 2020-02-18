
class User {
  final String id;
  final String name;
  final String token;
  final bool loggedIn;

  User(this.id, this.name, this.token,this.loggedIn);

  @override
  int get hashCode =>
      loggedIn.hashCode ^ name.hashCode ^ id.hashCode ^ token.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              loggedIn == other.loggedIn &&
              token == other.token &&
              id == other.id;

  Map<String, dynamic> toJson() {
    return {
      'loggedIn': loggedIn,
      'name': name,
      'id': id,
      'token': token
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, loggedIn: $loggedIn}';
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      json['id'] as String,
      json['name'] as String,
      json['token'] as String,
      json['loggedIn'] as bool
    );
  }
}