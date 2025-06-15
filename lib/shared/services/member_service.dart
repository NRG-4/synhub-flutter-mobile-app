import 'package:http/http.dart' as http;

import '../client/api_client.dart';

class MemberService {
  Future<http.Response> getMemberDetails() async {
    return await ApiClient.get('member/details');
  }
}