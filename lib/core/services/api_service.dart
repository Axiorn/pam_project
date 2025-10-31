import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<Map<String, dynamic>?> fetchBmi(double weight, double height) async {
    final url = Uri.parse('https://bmicalculatorapi.vercel.app/api/bmi/$weight/$height');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data is Map<String, dynamic> ? data : null;
    }
    return null;
  }
}