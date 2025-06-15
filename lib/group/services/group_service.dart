import 'package:http/http.dart' as http;
import '../../shared/client/api_client.dart';

class GroupService {
  Future<http.Response> searchGroupByCode(String code) async {
    return await ApiClient.get('groups/search?code=$code');
  }
}