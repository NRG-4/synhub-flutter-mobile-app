import 'dart:convert';

import 'package:bloc/bloc.dart';
import '../../client/api_client.dart';
import '../../models/sign_in_request.dart';
import '../../models/signn_in_response.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<SignInEvent>(_onSignInEvent);
    on<ResetAuthStateEvent>(_onResetAuthStateEvent);
  }

  void _onSignInEvent(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authService.signIn(
        SignInRequest(
          username: event.username,
          password: event.password,
        ),
      );

      if (response.statusCode == 200) {
        final signInResponse = SignInResponse.fromJson(
          json.decode(response.body),
        );
        ApiClient.updateToken(signInResponse.token);
        emit(AuthSuccess(signInResponse));
      } else {
        emit(AuthFailure('Login failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthFailure('Error: $e'));
    }
  }

  void _onResetAuthStateEvent(
      ResetAuthStateEvent event,
      Emitter<AuthState> emit,
      ) {
    emit(AuthInitial());
  }
}