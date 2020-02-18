import 'dart:async';
import 'Helper/FileAccess.dart';
import 'model/User.dart';

class AuthenticationBloc {
  final StreamController<AuthenticationState> streamController;
  AuthenticationBloc({this.streamController});

  Stream<AuthenticationState> get stream => streamController.stream;

  void init() async{
    var authState = await getCurrentUser();
    streamController.add(authState);
  }

  void login(String email,String token) async {
    await FileAccess.write(User(email, email, 'token', true));
    streamController.add(AuthenticationState.loggedIn());
  }
  void logout() async{
    await FileAccess.delete2();
    streamController.add(AuthenticationState.loggedOut());
  }

  Future<AuthenticationState> getCurrentUser() async {
    var user = await FileAccess.read();
    if(user != null){
      return AuthenticationState.loggedIn();
    }else{
      return AuthenticationState.loggedOut();
    }
  }


}

class AuthenticationState{
  final bool Authenticated;
  AuthenticationState.init({this.Authenticated = false}){
    //await auth.getCurrentUser();
  }
  AuthenticationState.loggedIn({this.Authenticated = true});
  AuthenticationState.loggedOut({this.Authenticated = false});
}