abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String username;
  final String password;

  SignInEvent({required this.username, required this.password});
}

class ResetAuthStateEvent extends AuthEvent {}