import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static String baseUrl = dotenv.env['API_URL'] ?? '';
  static final http.Client _client = http.Client();

  // Headers mặc định cho mọi request
  static final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      final response = await _client.get(
        uri,
        headers: {..._defaultHeaders, ...?headers},
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {..._defaultHeaders, ...?headers},
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {..._defaultHeaders, ...?headers},
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {..._defaultHeaders, ...?headers},
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Xử lý response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': decodedResponse,
          'message': decodedResponse['message'] ?? 'Thành công',
        };
      } else {
        return {
          'success': false,
          'message': decodedResponse['message'] ?? 'Có lỗi xảy ra',
          'error': decodedResponse['error'] ?? 'Không rõ lỗi',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Phản hồi không hợp lệ từ server',
        'error': e.toString(),
        'statusCode': response.statusCode,
      };
    }
  }

  // Xử lý lỗi
  static Map<String, dynamic> _handleError(dynamic error) {
    return {
      'success': false,
      'message': 'Có lỗi xảy ra: ${error.toString()}',
    };
  }

  // Đóng client
  static void dispose() {
    _client.close();
  }
}
