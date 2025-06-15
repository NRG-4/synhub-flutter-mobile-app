import 'package:http/http.dart' as http;

import '../client/api_client.dart';
import '../models/sign_in_request.dart';

class AuthService {

  Future<http.Response> signIn(SignInRequest request) async {
    return await ApiClient.post(
      'authentication/sign-in',
      body: request.toJson(),
    );
  }
}