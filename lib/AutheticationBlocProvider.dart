
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'AuthenticationBloc.dart';

class AuthenticationBlocProvider extends StatefulWidget{
  final Widget child;
  final AuthenticationBloc bloc;
  const AuthenticationBlocProvider({this.bloc,this.child}) : super();

  static AuthenticationBloc of(BuildContext context){
    return context
        .dependOnInheritedWidgetOfExactType<_AuthenticationBlocProvider>()
        .bloc;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AuthenticationBlocProviderState();
  }

}

class AuthenticationBlocProviderState extends State<AuthenticationBlocProvider> {

  @override
  Widget build(BuildContext context) =>  _AuthenticationBlocProvider(bloc: widget.bloc, child: widget.child);


  @override
  void dispose() {
    //widget.bloc.dispose();
    super.dispose();
  }
}

class _AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc bloc;

  _AuthenticationBlocProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_AuthenticationBlocProvider old) => bloc != old.bloc;
}